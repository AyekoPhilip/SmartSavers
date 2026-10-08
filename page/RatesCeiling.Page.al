page 50122 "Rates & Ceiling"
{
    ApplicationArea = All;
    Caption = 'Rates & Ceiling';
    PageType = Card;
    SourceTable = "Pr Vital Setup Info";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Tax Relief';
                field("Max Pension Contribution"; Rec."Max Pension Contribution")
                {
                    ToolTip = 'Specifies the value of the Max Pension Contribution field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Max Relief"; Rec."Max Relief")
                {
                    ToolTip = 'Specifies the value of the Max Relief field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Minimun Relief Amount"; Rec."Minimun Relief Amount")
                {
                    ToolTip = 'Specifies the value of the Minimun Relief Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Tax On Excess Pension"; Rec."Tax On Excess Pension")
                {
                    ToolTip = 'Specifies the value of the Tax On Excess Pension field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Tax Relief"; Rec."Tax Relief")
                {
                    ToolTip = 'Specifies the value of the Tax Relief field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Mortgage Relief"; Rec."Mortgage Relief")
                {
                    ToolTip = 'Specifies the value of the Mortgage Relief field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mortgage Relief Percentage"; Rec."Mortgage Relief Percentage")
                {
                    ToolTip = 'Specifies the value of the Mortgage Relief Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Insurance Relief"; Rec."Insurance Relief")
                {
                    ToolTip = 'Specifies the value of the Insurance Relief field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("SHIF %"; Rec."SHIF %")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Housing Levy Relieg"; Rec."Housing Levy Relief")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disabled Tax Limit"; Rec."Disabled Tax Limit")
                {
                    ToolTip = 'Specifies the value of the Disabled Tax Limit field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Max. Non Taxable"; Rec."Max. Non Taxable")
                {
                    ToolTip = 'Specifies the value of the Disabled Tax Limit field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }

            group("Staff Loan")
            {
                field("Checkoff-Cuttof Day";Rec."Checkoff-Cuttof Day")
                {
                    ToolTip = 'Specifies the value of the Loan Corporate Rate field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Loan Corporate Rate"; Rec."Loan Corporate Rate")
                {
                    ToolTip = 'Specifies the value of the Loan Corporate Rate field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Market Rate"; Rec."Loan Market Rate")
                {
                    ToolTip = 'Specifies the value of the Loan Market Rate field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }

            group("Social Security")
            {
                Caption = 'Social Security & Insurance Fund';

                field("NHIF Based On"; Rec."NHIF Based On")
                {
                    ToolTip = 'Specifies the value of the NHIF Based On field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("NSSF Based On"; Rec."NSSF Based On")
                {
                    ToolTip = 'Specifies the value of the NSSF Based On field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("NSSF Employee"; Rec."NSSF Employee")
                {
                    ToolTip = 'Specifies the value of the NSSF Employee field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("NSSF Employer Factor"; Rec."NSSF Employer Factor")
                {
                    ToolTip = 'Specifies the value of the NSSF Employer Factor field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Allowances)
            {
                field("Acting Allowance Based On"; Rec."Acting Allowance Based On")
                {
                    ToolTip = 'Specifies the value of the Acting Allowance Based On field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Acting Allowance Duration"; Rec."Acting Allowance Duration")
                {
                    ToolTip = 'Specifies the value of the Acting Allowance Duration field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Acting Allowance Percentage"; Rec."Acting Allowance Percentage")
                {
                    ToolTip = 'Specifies the value of the Acting Allowance Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Incremental Percentage"; Rec."Incremental Percentage")
                {
                    ToolTip = 'Specifies the value of the Incremental Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Leave Allowance Based On"; Rec."Leave Allowance Based On")
                {
                    ToolTip = 'Specifies the value of the Leave Allowance Based On field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Leave Allownace Percentage"; Rec."Leave Allownace Percentage")
                {
                    ToolTip = 'Specifies the value of the Leave Allownace Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Max. Leave Allownace"; Rec."Max. Leave Allownace")
                {
                    ToolTip = 'Specifies the value of the Max. Leave Allownace field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Salary Incremental %"; Rec."Salary Incremental %")
                {
                    ToolTip = 'Specifies the value of the Salary Incremental % field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Secondary Tax Percentage"; Rec."Secondary Tax Percentage")
                {
                    ToolTip = 'Specifies the value of the Secondary Tax Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
