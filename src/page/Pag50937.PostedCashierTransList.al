page 50937 "Posted Cashier Trans List"
{
    CardPageID = "Posted Cashier Transactions";
    Editable = false;
    PageType = List;
    SourceTable = "Teller Transaction";
    SourceTableView = WHERE(Posted = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Branch Code';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Stop Cheque")
            {
                Image = VoidCheck;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SaccoT: Codeunit "Banking Procedure Mngt.";
                begin
                    SaccoT.StopCheque(Rec);
                end;
            }
            action("Clear Lien")
            {
                Image = Delegate;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    if Rec.Type <> Rec.Type::Lien then
                        Error('Only applicable to Lien');

                    if Confirm('Are you sure you want to process the selected transactions?', false) = true then begin

                        Rec."Cheque Status" := Rec."Cheque Status"::Honoured;
                        Rec."Date Cleared" := Today;
                        Rec."Cleared By" := UserId;
                        Rec.Modify;

                        Message('Lien processed successfully');

                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Stop Cheque_Promoted"; "Stop Cheque")
                {
                }
                actionref("Clear Lien_Promoted"; "Clear Lien")
                {
                }
            }
        }
    }

    trigger OnInit()
    begin

        Temp.Get(UserId);

        Jtemplate := Temp."Cashier Journal Template";
        Jbatch := Temp."Cashier Journal Batch";
        TillNo := Temp."Default  Bank";
        MemberNo := Temp."Account No.";
        Excess := Temp."Excess Account";
        Shortage := Temp."Shortage Account";

        if Jtemplate = '' then begin
            Error(Text0001);
        end;
        if Jbatch = '' then begin
            Error(Text0002);
        end;

        if TillNo = '' then begin
            Error(Text0003);
        end;

        if MemberNo = '' then begin
            Error(Text0004);
        end;

        if Shortage = '' then begin
            Error(Text0005);
        end;

        if Excess = '' then begin
            Error(Text0006);
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Cashier, UserId);
    end;

    var
        Temp: Record "Banking User Template";
        Jtemplate: Code[20];
        Jbatch: Code[20];
        TillNo: Code[20];
        MemberNo: Code[20];
        Text0001: Label 'Ensure the Cashier journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier journal Batch is set up in Banking User Setup';
        Text0003: Label 'Ensure the Default Bank is set up in Banking User Setup';
        Text0004: Label 'Ensure the Cashier Member no is set up in Banking User Setup';
        Excess: Code[20];
        Shortage: Code[20];
        Text0005: Label 'Ensure the Cashier Shortage Account is set up in Banking User Setup';
        Text0006: Label 'Ensure the Cashier Excess Account iis set up in Banking User Setup';
}




