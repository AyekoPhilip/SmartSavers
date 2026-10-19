namespace DynamicsNav.SaccoDatabase.PayrollMgt;

page 50073 "Pr Period Transactions"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Period Transactions';
    PageType = List;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Pr Period Transaction";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = FALSE;

                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ToolTip = 'Specifies the value of the Transaction Name field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = FALSE;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = FALSE;
                }
                field("Period Month"; Rec."Period Month")
                {
                    ToolTip = 'Specifies the value of the Period Month field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = FALSE;
                }
                field("Period Year"; Rec."Period Year")
                {
                    ToolTip = 'Specifies the value of the Period Year field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = FALSE;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = TRUE;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Group Order"; Rec."Group Order")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Sub Group Order"; Rec."Sub Group Order")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Group Text"; Rec."Group Text")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Coop Parameters"; Rec."Coop Parameters")
                {
                    ToolTip = 'Specifies the value of the Coop Parameters field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Transaction Type"; Rec."Loan Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Coop Parameters field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Post As"; Rec."Post As")
                {
                    ToolTip = 'Specifies the value of the Post As field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("G/L Account"; Rec."Account Category")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Statutory category"; Rec."Statutory category")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
