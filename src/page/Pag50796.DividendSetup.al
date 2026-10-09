page 50796 "Dividend Setup"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Dividend SetUp";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Period Filter")
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Share Distribute"; Rec."Total Share Distribute")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Qualifying"; Rec."Total Qualifying")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Qualifying Share Calc"; Rec."Total Qualifying Share")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    
                }
                field("Interest On Deposit %"; Rec."Interest On Deposit %")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Dividend %"; Rec."Dividend %")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Loans)
            {
                field("Dividend Discounting"; Rec."Dividend Discounting")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Defaulter Recovery"; Rec."Defaulter Recovery")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Arrears Recovery"; Rec."Loan Arrears Recovery")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Dividend Instructions"; Rec."Dividend Instructions")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Savings)
            {
                field("Minimum Shares Recovery"; Rec."Minimum Shares Recovery")
                {
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Minimum Shares Account"; Rec."Minimum Shares Account")
                {
                    Visible = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Minimum Capitalized"; Rec."Minimum Capitalized")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Charges)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }
}




