page 50812 "Standing Order Lines"
{
    PageType = ListPart;
    SourceTable = "Standing Order Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Destination Account Type"; Rec."Destination Account Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Destination Account No."; Rec."Destination Account No.")
                {
                    ApplicationArea = All;
                }
                field("Destination Account Name"; Rec."Destination Account Name")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        DestinationTypeControl;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    var
        BankEdit: Boolean;
        BranchEdit: Boolean;
        BankAccountNo: Boolean;


    procedure DestinationTypeControl()
    begin
        case Rec."Destination Account Type" of
            Rec."Destination Account Type"::"Bank Account":
                begin
                    BankEdit := true;
                    BranchEdit := true;
                    BankAccountNo := true;
                end;

            Rec."Destination Account Type"::Employee, Rec."Destination Account Type"::Savings:
                begin
                    BankEdit := false;
                    BranchEdit := false;
                    BankAccountNo := false;
                end;
        end;
    end;
}




