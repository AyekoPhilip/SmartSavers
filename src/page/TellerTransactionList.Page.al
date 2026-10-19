page 50848 "Teller Transaction List"
{
    CardPageID = "Teller Transaction";
    Editable = false;
    PageType = List;
    SourceTable = "Teller Transaction";
    SourceTableView = WHERE(Posted = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
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
                var
                    ApprovlsMngt: Codeunit "Approval Mgmt.";
                begin
                    if Rec.Type <> Rec.Type::Lien then
                        Error('Only applicable to Lien');
                    if Confirm('Are you sure you want to process the selected transactions?', true) = false then exit;
                    ApprovlsMngt.OnSendTellerTransactionApprovalRequest(Rec);
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

    trigger OnOpenPage()
    begin
        Rec.SetRange(Cashier, UserId);
    end;
}




