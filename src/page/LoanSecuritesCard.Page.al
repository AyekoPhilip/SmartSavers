page 50957 "Loan Securites Card"
{
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = "Loan Securities Set-up";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Security Description")
                {
                    ApplicationArea = All;
                }
                field(Examples; Rec.Examples)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                }
                field("Collateral Multiplier"; Rec."Collateral Multiplier")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("Revaluation Frequency"; Rec."Revaluation Frequency")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control9; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control10; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control11; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




