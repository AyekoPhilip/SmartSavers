page 50134 "Pr Salary Information"
{
    ApplicationArea = All;
    Caption = 'Pr Salary Information';
    PageType = ListPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Pr Salary Card";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pays PAYE"; Rec."Pays PAYE")
                {
                    ToolTip = 'Specifies the value of the Pays PAYE field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pays NSSF"; Rec."Pays NSSF")
                {
                    ToolTip = 'Specifies the value of the Pays NSSF field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pays NHIF"; Rec."Pays NHIF")
                {
                    ToolTip = 'Specifies the value of the Pays NHIF field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("PAYE Relief?"; Rec."PAYE Relief?")
                {
                    ToolTip = 'Specifies the value of the PAYE Relief? field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Insurance Certificate?"; Rec."Insurance Certificate?")
                {
                    ToolTip = 'Specifies the value of the Insurance Certificate? field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ToolTip = 'Specifies the value of the Payment Mode field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Suspend Pay"; Rec."Suspend Pay")
                {
                    ToolTip = 'Specifies the value of the Suspend Pay field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Suspend Half Pay"; Rec."Suspend Half Pay")
                {
                    ToolTip = 'Specifies the value of the Suspend Half Pay field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Cumm PAYE"; Rec."Cumm PAYE")
                {
                    ToolTip = 'Specifies the value of the Cumm PAYE field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm Grosspay"; Rec."Cumm Grosspay")
                {
                    ToolTip = 'Specifies the value of the Cumm Grosspay field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm Deductions"; Rec."Cumm Deductions")
                {
                    ToolTip = 'Specifies the value of the Cumm Deductions field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm Allowances"; Rec."Cumm Allowances")
                {
                    ToolTip = 'Specifies the value of the Cumm Allowances field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm HELB"; Rec."Cumm HELB")
                {
                    ToolTip = 'Specifies the value of the Cumm HELB field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm NHIF"; Rec."Cumm NHIF")
                {
                    ToolTip = 'Specifies the value of the Cumm NHIF field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm NSSF"; Rec."Cumm NSSF")
                {
                    ToolTip = 'Specifies the value of the Cumm NSSF field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm NetPay"; Rec."Cumm NetPay")
                {
                    ToolTip = 'Specifies the value of the Cumm NetPay field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Cumm Pension"; Rec."Cumm Pension")
                {
                    ToolTip = 'Specifies the value of the Cumm Pension field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
            }
        }
    }
}
