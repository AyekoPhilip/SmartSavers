page 50126 "Transaction Codes"
{
    ApplicationArea = All;
    Caption = 'Transaction Codes';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "Pr Transaction Code";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Balance Type"; Rec."Balance Type")
                {
                    ToolTip = 'Specifies the value of the Balance Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Is Cash"; Rec."Is Cash")
                {
                    ToolTip = 'Specifies the value of the Is Cash field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Taxable; Rec.Taxable)
                {
                    ToolTip = 'Specifies the value of the Taxable field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Is House Allowance"; Rec."Is House Allowance")
                {
                    ToolTip = 'Specifies the value of the Is House Allowance field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Is Not Gross Allowance "; Rec."Is Not Gross Allowance ")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Formula Based")
            {
                field("Is Formula"; Rec."Is Formula")
                {
                    ToolTip = 'Specifies the value of the Is Formula field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Is Formula For Employer"; Rec."Is Formula For Employer")
                {
                    ToolTip = 'Specifies the value of the Is Formula For Employer field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Inc. Employer Deduction"; Rec."Inc. Employer Deduction")
                {
                    ToolTip = 'Specifies the value of the Inc. Employer Deduction field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Posting)
            {
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
            }
            group(Loans)
            {
                field("Is Coop/Loan"; Rec."Is Coop/Loan")
                {
                    ToolTip = 'Specifies the value of the Is Coop/Loan field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Repayment Method"; Rec."Repayment Method")
                {
                    ToolTip = 'Specifies the value of the Repayment Method field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Other Information")
            {

                field("Amount Preference"; Rec."Amount Preference")
                {
                    ToolTip = 'Specifies the value of the Amount Preference field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Special Transactions"; Rec."Special Transactions")
                {
                    ToolTip = 'Specifies the value of the Special Transactions field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Fringe Benefit"; Rec."Fringe Benefit")
                {
                    ToolTip = 'Specifies the value of the Fringe Benefit field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deduct Premium"; Rec."Deduct Premium")
                {
                    ToolTip = 'Specifies the value of the Deduct Premium field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deduct Morgage"; Rec."Deduct Morgage")
                {
                    ToolTip = 'Specifies the value of the Deduct Morgage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Coop Parameter"; Rec."Coop Parameter")
                {
                    ToolTip = 'Specifies the value of the Coop Parameter field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Suspended; Rec.Suspended)
                {
                    ToolTip = 'Specifies the value of the Suspended field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Account Category"; Rec."Account Category")
                {
                    ToolTip = 'Specifies the value of the Account Category field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
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
}
