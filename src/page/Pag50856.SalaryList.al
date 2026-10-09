page 50856 "Salary List"
{
    CardPageID = "Salary Header";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Salary Header";
    SourceTableView = WHERE("Account No" = FILTER(<> '00'));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Count"; Rec."Total Count")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Income Type"; Rec."Income Type")
                {
                    ApplicationArea = All;
                }
                field("Posting date"; Rec."Posting date")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
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




