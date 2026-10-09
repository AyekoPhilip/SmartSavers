page 50102 "Receipt Lines"
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;

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
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Product Category"; Rec."Product Category")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                }

                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }
                field("Interest Balance"; Rec."Interest Balance")
                {
                    Caption = 'Outstanding Interest';
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Cheque/Deposit Slip No"; Rec."Cheque/Deposit Slip No")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Cheque/Deposit Slip Date"; Rec."Cheque/Deposit Slip Date")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Cheque/Deposit Slip Type"; Rec."Cheque/Deposit Slip Type")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    Visible = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Balance; Rec.Balance)
                {
                    Caption = 'Balance';
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                }

            }
        }
    }

    actions
    {
        
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


