page 50804 "Fixed Deposit Type List"
{
    CardPageID = "Fixed Deposit Type";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Fixed Deposit Type";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("No. of Months"; Rec."No. of Months")
                {
                    ApplicationArea = All;
                }
                field("Interest Method"; Rec."Interest Method")
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




