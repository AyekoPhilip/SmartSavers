page 50052 "Repayment Schedule"
{
    Caption = 'Repayment Schedule';
    PageType = ListPart;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Loan Repayment Schedule";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Repayment Code"; Rec."Repayment Code")
                {
                    ApplicationArea = All;
                    Caption = 'Installment';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Repayment Code field.';
                }
                field("Repayment Date"; Rec."Repayment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Repayment Date field.';
                }
                field("Principal Repayment"; Rec."Principal Repayment")
                {
                    ApplicationArea = All;
                    Caption = 'Principal';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Principal Repayment field.';
                }
                field("Monthly Interest"; Rec."Monthly Interest")
                {
                    ApplicationArea = All;
                    Caption = 'Interest';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Monthly Interest field.';
                }
                field("Insurance Repayment"; Rec."Insurance Repayment")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Monthly Insurance field.';
                }
                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ApplicationArea = All;
                    Caption = 'Repayment';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Monthly Repayment field.';
                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = All;
                    Caption = 'Balance';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Loan Balance field.';
                }
            }
        }
    }
}



