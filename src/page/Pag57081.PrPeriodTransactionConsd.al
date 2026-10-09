namespace PayrollMngt.PayrollMngt;

page 57081 "Pr Period Transaction - Consd."
{
    ApplicationArea = All;
    Caption = 'Period Transaction - Consolidated';
    PageType = List;
    SourceTable = "Pr Period Transaction- Consd.";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ToolTip = 'Specifies the value of the Transaction Name field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Group Order"; Rec."Group Order")
                {
                    ToolTip = 'Specifies the value of the Group Order field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Sub Group Order"; Rec."Sub Group Order")
                {
                    ToolTip = 'Specifies the value of the Sub Group Order field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Group Text"; Rec."Group Text")
                {
                    ToolTip = 'Specifies the value of the Group Text field.', Comment = '%';
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
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
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
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Coop Parameters";Rec."Coop Parameters")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Coop Parameters field.', Comment = '%';
                }

                field("Account Category"; Rec."Account Category")
                {
                    ToolTip = 'Specifies the value of the Account Category field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ToolTip = 'Specifies the value of the Account Dimension field.', Comment = '%';
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

            }
        }
    }
}
