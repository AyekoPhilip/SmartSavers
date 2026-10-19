page 50822 "Loan Charges"
{
    PageType = List;
    SourceTable = "Loan Charges";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Charges Account"; Rec."Charges Account")
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                }
                field("Charging Option"; Rec."Charging Option")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
                {
                    Editable = true;
                    ApplicationArea = All;

                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                }
                field(Maximum; Rec.Maximum)
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




