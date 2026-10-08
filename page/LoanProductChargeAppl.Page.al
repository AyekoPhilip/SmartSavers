page 50952 "Loan Product Charge Appl."
{
    PageType = List;
    SourceTable = "Loan Product Charge Appl.";
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
                    ApplicationArea = All;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                }
                field("Charging Option"; Rec."Charging Option")
                {
                    ApplicationArea = All;
                }
                field("Charges G_L Account"; Rec."Charges G_L Account")
                {
                    ApplicationArea = All;
                }
                field(Minimum; Rec.Minimum)
                {
                    ApplicationArea = All;
                }
                field(Maximum; Rec.Maximum)
                {
                    ApplicationArea = All;
                }
                field("Additional Conditional Charge"; Rec."Additional Conditional Charge")
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




