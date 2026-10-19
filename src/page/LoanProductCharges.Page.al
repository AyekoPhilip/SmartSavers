page 50823 "Loan Product Charges"
{
    DeleteAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Loan Product Charges";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                }
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
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Charge Method"; Rec."Charge Method")
                {
                    ApplicationArea = All;
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Effect Excise Duty"; Rec."Effect Excise Duty")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
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
                field("Charging Option"; Rec."Charging Option")
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
                field("Additional Charge %"; Rec."Additional Charge %")
                {
                    ApplicationArea = All;
                }
                field(Prorate; Rec.Prorate)
                {
                    ApplicationArea = All;
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
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




