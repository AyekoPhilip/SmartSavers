page 50105 "NSSF Setup"
{
    ApplicationArea = All;
    Caption = 'NSSF Setup';
    PageType = List;
    SourceTable = "Pr NSSF Tier";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Tier; Rec.Tier)
                {
                    ToolTip = 'Specifies the value of the Tier field.';
                }
                field(Earnings; Rec.Earnings)
                {
                    ToolTip = 'Specifies the value of the Earnings field.';
                }
                field("Pensionable Earnings"; Rec."Pensionable Earnings")
                {
                    ToolTip = 'Specifies the value of the Pensionable Earnings field.';
                }
                field("Tier 1 Earnings";Rec."Tier 1 Earnings")
                {
                    ToolTip = 'Specifies the value of the Tier 1 Earnings field.';

                }
                field("Tier 1 Employee Deduction"; Rec."Tier 1 Employee Deduction")
                {
                    ToolTip = 'Specifies the value of the Tier 1 Employee Deduction field.';
                }
                field("Tier 1 Employer Deduction"; Rec."Tier 1 Employer Deduction")
                {
                    ToolTip = 'Specifies the value of the Tier 1 Employer Deduction field.';
                }
                field("Tier 2 Earnings"; Rec."Tier 2 Earnings")
                {
                    ToolTip = 'Specifies the value of the Tier 2 Earnings field.';
                }
                field("Tier 2 Employee Deduction"; Rec."Tier 2 Employee Deduction")
                {
                    ToolTip = 'Specifies the value of the Tier 2 Employee Deduction field.';
                }
                field("Tier 2 Employer Deduction"; Rec."Tier 2 Employer Deduction")
                {
                    ToolTip = 'Specifies the value of the Tier 2 Employer Deduction field.';
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    ToolTip = 'Specifies the value of the Lower Limit field.';
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    ToolTip = 'Specifies the value of the Upper Limit field.';
                }
                field("Nssf Percentage";Rec."Nssf Percentage")
                {
                    ToolTip = 'Specifies the value of NSSF PERCENTAGE';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
}
