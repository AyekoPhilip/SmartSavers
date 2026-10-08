page 50947 "Social Listening Sites"
{
    PageType = List;
    SourceTable = "Social Listening Sites";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No."; Rec."Account No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control6; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; MyNotes)
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




