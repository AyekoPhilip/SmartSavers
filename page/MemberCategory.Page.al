page 50981 "Member Category"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Member Category";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Caption = 'Code';
                    ApplicationArea = All;
                }
                field("Terms of Service"; Rec."Terms of Service")
                {
                    ApplicationArea = All;

                }
                field("Registration Fee"; Rec."Registration Fee")
                {
                    ApplicationArea = All;
                }
                field("Share Capital"; Rec."Share Capital")
                {
                    ApplicationArea = All;
                }
                field("Default Share Deposit";Rec."Default Share Deposit")
                {
                    ApplicationArea = All;
                }
                field("Cannot Guarantee Loan"; Rec."Cannot Guarantee Loan")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control15; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control16; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control17; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




