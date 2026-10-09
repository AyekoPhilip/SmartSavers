page 50103 "NHIF Setup"
{
    ApplicationArea = All;
    Caption = 'NHIF Setup';
    PageType = List;
    SourceTable = "Pr NHIF";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Lower Tier"; Rec."Lower Tier")
                {
                    ToolTip = 'Specifies the value of the Lower Tier field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Upper Tier"; Rec."Upper Tier")
                {
                    ToolTip = 'Specifies the value of the Upper Tier field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
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
