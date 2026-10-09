page 50901 "Guarantor Subsitution List"
{
    CardPageID = "Guarantor Substitution";
    Editable = false;
    PageType = List;
    Caption = 'Substitution List';
    SourceTable = "Guarantors Substitution";
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
                field("Loan Account No."; Rec."Loan Account No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Account Status"; Rec."Account Status")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Current Savings"; Rec."Current Savings")
                {
                    ApplicationArea = All;
                }
                field("FOSA Account"; Rec."FOSA Account")
                {
                    ApplicationArea = All;
                }
                field("Business Loan No."; Rec."Business Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Business Loan Shares"; Rec."Business Loan Shares")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




