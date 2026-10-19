page 50106 "Payroll Posting Group"
{
    ApplicationArea = All;
    Caption = 'Payroll Posting Group';
    PageType = List;
    SourceTable = "Pr Employee Posting Group";
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
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Employee Provident Fund A/c"; Rec."Employee Provident Fund A/c")
                {
                    ToolTip = 'Specifies the value of the Employee Provident Fund A/c field.';
                }
                field("Employment Tax Credit"; Rec."Employment Tax Credit")
                {
                    ToolTip = 'Specifies the value of the Employment Tax Credit field.';
                }
                field("Employment Tax Debit"; Rec."Employment Tax Debit")
                {
                    ToolTip = 'Specifies the value of the Employment Tax Debit field.';
                }
                field("House Levy Employee A/c"; Rec."House Levy Employee A/c")
                {
                    ToolTip = 'Specifies the value of the House Levy Employee A/c field.';
                }
                field("House Levy Employer A/c"; Rec."House Levy Employer A/c")
                {
                    ToolTip = 'Specifies the value of the House Levy Employer A/c field.';
                }
                field("Income Tax Account"; Rec."Income Tax Account")
                {
                    ToolTip = 'Specifies the value of the Income Tax Account field.';
                }
                field("NHIF Employee A/c"; Rec."NHIF Employee A/c")
                {
                    ToolTip = 'Specifies the value of the NHIF Employee A/c field.';
                }
                field("Net Salary Payable"; Rec."Net Salary Payable")
                {
                    ToolTip = 'Specifies the value of the Net Salary Payable field.';
                }
                field("Pension Employee A/c"; Rec."Pension Employee A/c")
                {
                    ToolTip = 'Specifies the value of the Pension Employee A/c field.';
                }
                field("Pension Employer A/c"; Rec."Pension Employer A/c")
                {
                    ToolTip = 'Specifies the value of the Pension Employer A/c field.';
                }
                field("SSF Employee Account"; Rec."SSF Employee Account")
                {
                    ToolTip = 'Specifies the value of the SSF Employee Account field.';
                }
                field("SSF Employer Account"; Rec."SSF Employer Account")
                {
                    ToolTip = 'Specifies the value of the SSF Employer Account field.';
                }
                field("Salary Account"; Rec."Salary Account")
                {
                    ToolTip = 'Specifies the value of the Salary Account field.';
                }
                field("Salary Expense A/c"; Rec."Salary Expense A/c")
                {
                    ToolTip = 'Specifies the value of the Salary Expense A/c field.';
                }
                field("Staff Gratuity"; Rec."Staff Gratuity")
                {
                    ToolTip = 'Specifies the value of the Staff Gratuity field.';
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ToolTip = 'Specifies the value of the Tax Code field.';
                }
                field("Tax Relief"; Rec."Tax Relief")
                {
                    ToolTip = 'Specifies the value of the Tax Relief field.';
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
