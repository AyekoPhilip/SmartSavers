page 50858 "Salary Line"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Salary Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Staff No."; Rec."Staff No.")
                {
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Account Not Found"; Rec."Account Not Found")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Blocked Accounts"; Rec."Blocked Accounts")
                {
                    ApplicationArea = All;
                }
                field("Multiple Salary"; Rec."Multiple Salary")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Salary Header No."; Rec."Salary Header No.")
                {
                    ApplicationArea = All;
                }
                field("Partial Charged STO"; Rec."Partial Charged STO")
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




