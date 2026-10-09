page 50112 "Pr List Transaction"
{
    ApplicationArea = All;
    Caption = 'Employee Transaction';
    PageType = List;
    SourceTable = "Pr Employee Transaction";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Transaction Code"; Rec."Transaction Code")
                {
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }


                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Period Month"; Rec."Period Month")
                {
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Period Year"; Rec."Period Year")
                {
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
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
