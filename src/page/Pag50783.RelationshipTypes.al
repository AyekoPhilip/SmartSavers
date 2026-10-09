page 50783 "Relationship Types"
{
    DeleteAllowed = false;
    /* Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false; */
    PageType = List;
    SourceTable = "Relationship Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Min. Age"; Rec."Min. Age")
                {
                    ApplicationArea = All;
                }
                field("Max. Age"; Rec."Max. Age")
                {
                    ApplicationArea = All;
                }
                field("Max. Allowed"; Rec."Max. Allowed")
                {
                    ApplicationArea = All;
                }
                field("Principal Child"; Rec."Principal Child")
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




