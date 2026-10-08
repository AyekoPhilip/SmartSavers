page 50789 "Bank Code Structure"
{
    PageType = List;
    SourceTable = "Bank Code Structure";
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field(Branch; Rec.Branch)
                { }
            }
        }
        area(factboxes)
        {
            systempart(Control8; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control10; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




