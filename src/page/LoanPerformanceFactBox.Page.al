page 50443 "Loan Performance FactBox"
{
    Caption = 'Loan Performance FactBox';
    PageType = CardPart;
    SourceTable = "Loans Categorization";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Last Pay Date";Rec."Last Pay Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Loan Age"; Rec."Loan Age")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Loan Age field.';
                }
                field("Expected Repayment"; Rec."Expected Repayment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Days in Arrears"; Rec."Days in Arrears")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Days in Arrears field.';
                }
                field("Amount In Arrears"; Rec."Amount In Arrears")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Amount In Arrears field.';
                }
                field("Outstanding Insurance";Rec."Outstanding Insurance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies Outstanding Insurance field.';

                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    ToolTip = 'Specifies the value of the Outstanding Interest field.';
                    trigger OnDrillDown()
                    begin

                    end;
                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Outstanding Principal field.';
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Outstanding Balance field.';
                }
            }
        }

    }
}



