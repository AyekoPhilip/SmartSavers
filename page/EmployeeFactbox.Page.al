page 50127 "Employee Factbox"
{
    ApplicationArea = All;
    Caption = 'Employee Factbox';
    PageType = CardPart;
    SourceTable = "HR Employees";

    layout
    {
        area(content)
        {
            group("Leave Details")
            {
                Caption = 'Leave Details';
                Editable = false;
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ToolTip = 'Specifies the value of the Leave Balance field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Accrued Leave Days"; Rec."Accrued Leave Days")
                {
                    ToolTip = 'Specifies the value of the Accrued Leave Days field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Allocated Leave Days"; Rec."Allocated Leave Days")
                {
                    ToolTip = 'Specifies the value of the Allocated Leave Days field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Reimbursed Leave Days"; Rec."Reimbursed Leave Days")
                {
                    ToolTip = 'Specifies the value of the Reimbursed Leave Days field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Compassionate Leave A/c"; Rec."Compassionate Leave A/c")
                {
                    ToolTip = 'Specifies the value of the Compassionate Leave A/c field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Sick Leave A/c"; Rec."Sick Leave A/c")
                {
                    ToolTip = 'Specifies the value of the Sick Leave A/c field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Study Leave A/c"; Rec."Study Leave A/c")
                {
                    ToolTip = 'Specifies the value of the Study Leave A/c field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Paternity Leave A/c"; Rec."Paternity Leave A/c")
                {
                    ToolTip = 'Specifies the value of the Paternity Leave A/c field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Maternity Leave A/c"; Rec."Maternity Leave A/c")
                {
                    ToolTip = 'Specifies the value of the Maternity Leave A/c field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total (Leave Days)"; Rec."Total (Leave Days)")
                {
                    ToolTip = 'Specifies the value of the Total (Leave Days) field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Leave Taken"; Rec."Total Leave Taken")
                {
                    ToolTip = 'Specifies the value of the Total Leave Taken field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
        }
    }
}
