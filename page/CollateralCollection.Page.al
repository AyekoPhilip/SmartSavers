page 50967 "Collateral Collection"
{
    CardPageID = "Collateral Collection Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    Caption = 'Collection List';
    SourceTable = "Security Collection";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {

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




