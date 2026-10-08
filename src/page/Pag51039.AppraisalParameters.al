page 51039 "Appraisal Parameters"
{
    //CardPageID = "Appraisal Parameter Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Appraisal Parameter";
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
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Qualification (Shares)"; Rec."Qualification (Shares)")
                {
                    ApplicationArea = All;
                }
                field("Qualification (Salary)"; Rec."Qualification (Salary)")
                {
                    ApplicationArea = All;
                }
                field("Qualification (Security)"; Rec."Qualification (Security)")
                {
                    ApplicationArea = All;
                }
                field("Deposit Mutiplier"; Rec."Deposit Mutiplier")
                {
                    ApplicationArea = All;
                }
                field(Multiplier; Rec.Multiplier)
                {
                    ApplicationArea = All;
                }
                field("Total (Basic)"; Rec."Total (Basic)")
                {
                    ApplicationArea = All;
                }
                field("Total (Allowance)"; Rec."Total (Allowance)")
                {
                    ApplicationArea = All;
                }
                field("Total (Deductions)"; Rec."Total (Deductions)")
                {
                    ApplicationArea = All;
                }
                field("Total (Earnings)"; Rec."Total (Earnings)")
                {
                    ApplicationArea = All;
                }
                field("Shares Deposits"; Rec."Shares Deposits")
                {
                    ApplicationArea = All;
                }
                field("Amount (Recommended)"; Rec."Amount (Recommended)")
                {
                    ApplicationArea = All;
                }
                field("Amount (Net Take Home)"; Rec."Amount (Net Take Home)")
                {
                    ApplicationArea = All;
                }
                field("Amount (Total Charges)"; Rec."Amount (Total Charges)")
                {
                    ApplicationArea = All;
                }
                field("Qualifying Amount"; Rec."Qualifying Amount")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Amount (Requested)"; Rec."Amount (Requested)")
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




