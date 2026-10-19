page 50772 "Tariff Codes"
{
    PageType = List;
    SourceTable = "Tariff Codes";
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Account Type";Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("To Use"; Rec."To Use")
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
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




