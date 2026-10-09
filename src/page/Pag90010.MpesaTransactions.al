namespace SaccoDatabase.SaccoDatabase;

page 90010 "Mpesa Transactions"
{
    ApplicationArea = All;
    Caption = 'Mpesa Transactions';
    PageType = List;
    Editable = false;
    SourceTable = "MPESA Transactions";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Editable = false;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                    Editable = false;
                }
                field("Completion Time"; Rec."Completion Time")
                {
                    ToolTip = 'Specifies the value of the Completion Time field.', Comment = '%';
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("Paybil Number"; Rec."Paybil Number")
                {
                    ToolTip = 'Specifies the value of the Paybil Number field.', Comment = '%';
                    Editable = false;
                }
                field("Phone "; Rec."Phone")
                {
                    ToolTip = 'Specifies the value of the Phone  field.', Comment = '%';
                }
                field("Posted On"; Rec."Posted On")
                {
                    ToolTip = 'Specifies the value of the Posted On field.', Comment = '%';
                    Editable = false;
                }
                field("Processed "; Rec."Processed")
                {
                    ToolTip = 'Specifies the value of the Processed  field.', Comment = '%';
                    Editable = false;
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.', Comment = '%';
                    Editable = true;
                }
                field("Received On"; Rec."Received On")
                {
                    ToolTip = 'Specifies the value of the Received On field.', Comment = '%';
                    Editable = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    Editable = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    Editable = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    Editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    Editable = false;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Try Post")
            {
                trigger OnAction()
                var
                    MpesaMgt: Codeunit "Mpesa Integration";
                    DebitAccount, CreditAccount, LoanNo : Code[20];
                begin
                    MpesaMgt.ConstructPostingAccounts(Rec."Receipt No.", DebitAccount, CreditAccount, LoanNo);
                    Message('Debit Account: %1, Credit Account: %2, Loan No: %3', DebitAccount, CreditAccount, LoanNo);
                    MpesaMgt.Run();
                end;
            }
        }
    }
}
