namespace SaccoDatabase.SaccoDatabase;

page 50096 "Pr P9 Information"
{
    ApplicationArea = All;
    Caption = 'Pr P9 Information';
    PageType = List;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Pr Employee P9 Info";
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ToolTip = 'Specifies the value of the Basic Pay field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Allowance; Rec.Allowance)
                {
                    ToolTip = 'Specifies the value of the Allowance field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Allowances; Rec.Allowances)
                {
                    ToolTip = 'Specifies the value of the Allowances field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Deductions; Rec.Deductions)
                {
                    ToolTip = 'Specifies the value of the Deductions field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Defined Contribution"; Rec."Defined Contribution")
                {
                    ToolTip = 'Specifies the value of the Defined Contribution field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ToolTip = 'Specifies the value of the Gross Pay field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(NHIF; Rec.NHIF)
                {
                    ToolTip = 'Specifies the value of the NHIF field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(NSSF; Rec.NSSF)
                {
                    ToolTip = 'Specifies the value of the NSSF field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ToolTip = 'Specifies the value of the Net Pay field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(PAYE; Rec.PAYE)
                {
                    ToolTip = 'Specifies the value of the PAYE field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Insurance Relief"; Rec."Insurance Relief")
                {
                    ToolTip = 'Specifies the value of the Insurance Relief field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Tax Charged"; Rec."Tax Charged")
                {
                    ToolTip = 'Specifies the value of the Tax Charged field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Tax Relief"; Rec."Tax Relief")
                {
                    ToolTip = 'Specifies the value of the Tax Relief field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Taxable Pay"; Rec."Taxable Pay")
                {
                    ToolTip = 'Specifies the value of the Taxable Pay field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Benefits; Rec.Benefits)
                {
                    ToolTip = 'Specifies the value of the Benefits field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Owner Occupier Interest"; Rec."Owner Occupier Interest")
                {
                    ToolTip = 'Specifies the value of the Owner Occupier Interest field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Pension; Rec.Pension)
                {
                    ToolTip = 'Specifies the value of the Pension field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Period Month"; Rec."Period Month")
                {
                    ToolTip = 'Specifies the value of the Period Month field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Period Year"; Rec."Period Year")
                {
                    ToolTip = 'Specifies the value of the Period Year field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Value Of Quarters"; Rec."Value Of Quarters")
                {
                    ToolTip = 'Specifies the value of the Value Of Quarters field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
