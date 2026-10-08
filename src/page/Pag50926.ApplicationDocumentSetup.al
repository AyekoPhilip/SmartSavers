page 50926 "Application Document Setup"
{
    CardPageID = "Application Doc. Setup Card";
    Editable = false;
    PageType = List;
    SourceTable = "Application Document Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
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
            systempart(Control8; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




