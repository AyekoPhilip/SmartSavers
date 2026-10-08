page 50020 "Pr Employee transaction"
{
    ApplicationArea = All;
    Caption = 'Pr Employee transaction';
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
                field("No. of Repayment"; Rec."No. of Repayment")
                {
                    ToolTip = 'Specifies the value of the No. of Repayment field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Membership; Rec.Membership)
                {
                    ToolTip = 'Specifies the value of the Membership field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Suspended; Rec.Suspended)
                {
                    ToolTip = 'Specifies the value of the Suspended field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amortized Loan Repayment"; Rec."Amortized Loan Repayment")
                {
                    ToolTip = 'Specifies the value of the Amortized Loan Repayment field.';
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
                field("Is Coop/Loanrep"; Rec."Is Coop/Loanrep")
                {
                    ToolTip = 'Specifies the value of the Is Coop/Loanrep field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Code field.';
                    Style = StandardAccent;
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
    trigger OnInit()
    begin
        Rec.fngetcurrentPayrollPeriod();
        Rec.SetFilter("Payroll Period", Format(PayMngt.fnGetOpenPeriod()));
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Payroll Period", Format(PayMngt.fnGetOpenPeriod()));
        Rec.FilterGroup(0);
    end;

    var
        PayMngt: Codeunit "Payroll Post Mngt.";
}
