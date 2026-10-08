page 50893 "Receipts Line"
{
    PageType = ListPart;
    SourceTable = "Receipt Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field(No; Rec.No)
                {
                    Editable = false;
                    Visible=false;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    trigger OnValidate()
                    begin
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Receipt);
                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                        if RecPayTypes.Find('-') then begin
                            if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                                "Account No.Editable" := false;
                            end
                            else begin
                                "Account No.Editable" := true;
                            end;
                        end;
                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Visible= true;
                }
                field("Product Category"; Rec."Product Category")
                {
                    ApplicationArea = All;
                    Visible=false;

                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }

                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Editable=false;
                }
                
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Account Status"; Rec."Account Status")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }

                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cheque/Deposit Slip No"; Rec."Cheque/Deposit Slip No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cheque/Deposit Slip Date"; Rec."Cheque/Deposit Slip Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cheque/Deposit Slip Type"; Rec."Cheque/Deposit Slip Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Clear Loan"; Rec."Clear Loan")
                {
                    ApplicationArea = All;
                }
                field("Settlement Fee"; Rec."Settlement Fee")
                {
                    ApplicationArea = All;

                }
                field("Accrued Intrest"; Rec."Accrued Intrest")
                {
                    Caption = 'Accrued Intrest';
                    Editable = false;
                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
                {
                    ApplicationArea = All;
                }
                field("Interest Balance"; Rec."Interest Balance")
                {
                    Caption = 'Outstanding Interest';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    Caption = 'Outstanding Balance';
                    Editable = false;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Editable=false;

                }

                field(Posted; Rec.Posted)
                {
                    Editable = false;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Enabled=false;

                trigger OnAction()
                begin
                    if Rec.Posted then
                        Error('The transaction has already been posted.');

                    if Rec."Transaction Name" = '' then
                        Error('Please enter the transaction description under transaction name.');

                    if Rec.Amount = 0 then
                        Error('Please enter amount.');

                    if Rec.Amount < 0 then
                        Error('Amount cannot be less than zero.');

                    if Rec."Global Dimension 1 Code" = '' then
                        Error('Please enter the Function code');

                    if Rec."Shortcut Dimension 2 Code" = '' then
                        Error('Please enter the source of funds.');

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec.No);
                    GenJnlLine.DeleteAll;

                    if DefaultBatch.Get('CASH RECEI', Rec.No) then
                        DefaultBatch.Delete;

                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name" := 'CASH RECEI';
                    DefaultBatch.Name := Rec.No;
                    DefaultBatch.Insert;

                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := 'CASH RECEI';
                    GenJnlLine."Journal Batch Name" := Rec.No;
                    GenJnlLine."Line No." := 10000;
                    GenJnlLine."Account Type" := Rec."Account Type";
                    GenJnlLine."Account No." := Rec."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    GenJnlLine."External Document No." := Rec."Cheque/Deposit Slip No";
                    GenJnlLine.Amount := -Rec."Total Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);

                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := Rec."Apply to";
                    //GenJnlLine."Bal. Account No.":=CashierLinks."Bank Account No";
                    if Rec."Bank Code" = '' then
                        Error('Select the Bank Code');


                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := Rec."Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;


                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := 'CASH RECEI';
                    GenJnlLine."Journal Batch Name" := Rec.No;
                    GenJnlLine."Line No." := 10001;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No." := Rec."Bank Code";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    GenJnlLine."External Document No." := Rec."Cheque/Deposit Slip No";
                    GenJnlLine.Amount := Rec."Total Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);

                    GenJnlLine.Description := Rec."Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Dest Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Dest Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec.No);
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Line", GenJnlLine);

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec.No);
                    if GenJnlLine.Find('-') then
                        exit;

                    Rec.Posted := true;
                    Rec."Date Posted" := Today;
                    Rec."Time Posted" := Time;
                    Rec."Posted By" := UserId;
                    Rec.Modify;

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Enabled=false;

                trigger OnAction()
                begin
                    if Rec.Posted = false then
                        Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(52015, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Direct Printing")
            {
                Caption = 'Direct Printing';
                Enabled=false;

                trigger OnAction()
                begin
                    if Rec.Posted = false then
                        Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(52015, false, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInit()
    begin
        "Account No.Editable" := true;
        "Bank AccountVisible" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Pay Mode" := Rec."Pay Mode"::EFT;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        RecPayTypes: Record "Receipts and Payment Types";
        DimName1: Text[100];
        rdimname1: Text[100];
        rdimname2: Text[100];
        DImName2: Text[100];
        Custledger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        ApplyEntry: Codeunit "Sales Header Apply";
        // AppliedEntries: Record "Central Payment";
        CustEntries: Record "Cust. Ledger Entry";
        LineNo: Integer;
        
        "Bank AccountVisible": Boolean;
        
        "Account No.Editable": Boolean;
        ShortcutDimCode: array[8] of Code[20];

    local procedure PayModeOnAfterValidate()
    begin
        if Rec."Pay Mode" = Rec."Pay Mode"::"Deposit Slip" then begin
            "Bank AccountVisible" := true;
        end
        else begin
            "Bank AccountVisible" := false;
        end;
    end;
}




