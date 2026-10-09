namespace DynamicsNav.SaccoDatabase.PayrollMgt;

page 50148 "Payroll Request Lookup"
{
    ApplicationArea = All;
    Caption = 'Payroll Request Lookup';
    PageType = List;
    SourceTable = "Payroll Requests";
    UsageCategory = None;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed=false;
    ModifyAllowed=false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Code Descripton"; Rec."Code Descripton")
                {
                    ToolTip = 'Specifies the value of the Code Descripton field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Payroll Status field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
