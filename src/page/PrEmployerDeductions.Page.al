namespace SaccoDatabase.SaccoDatabase;

page 50074 "Pr Employer Deductions"
{
    ApplicationArea = All;
    Caption = 'Employer Deductions';
    PageType = List;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Pr Employer Deduction";
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
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
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
            }
        }
    }
}
