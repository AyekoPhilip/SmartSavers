page 50773 "EDMS"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = EDMS;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Key"; Rec.Key)
                {
                    ApplicationArea = All;
                }
                field("url path"; Rec."url path")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




