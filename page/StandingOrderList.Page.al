page 50810 "Standing Order List"
{
    CardPageID = "Standing Order";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Standing Order Header";
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
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Source Account No."; Rec."Source Account No.")
                {
                    ApplicationArea = All;
                }
                field("Frequency (Months)"; Rec."Frequency (Months)")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Next Run Date"; Rec."Next Run Date")
                {
                    ApplicationArea = All;
                }
                field("Source Account Name"; Rec."Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ApplicationArea = All;
                }
                field("Income Type"; Rec."Income Type")
                {
                    ApplicationArea = All;
                }
                field("Allocated Amount"; Rec."Allocated Amount")
                {
                    ApplicationArea = All;
                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }

        area(factboxes)
        {

            part(Control48; "Member Picture")
            {
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;

            }
            part(Control47; "Member Signature")
            {
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;

            }
            systempart(Control45; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




