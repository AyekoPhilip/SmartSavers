page 51033 "Collateral Registers"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    CardPageId = "Collateral Register Card";
    SourceTable = "Collateral Register";
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
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field(Collateral; Rec.Collateral)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control5; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control6; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




