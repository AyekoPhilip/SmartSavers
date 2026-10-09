page 50889 "Remittance Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Checkoff Receipt Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable=false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll No.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Principle Repayment"; Rec."Principle Repayment")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Repayment"; Rec."Interest Repayment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Upload ID"; Rec."Upload ID")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Account"; Rec."Repayment Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Upload Response"; Rec."Upload Response")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Found"; Rec."Account Found")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Multiple; Rec.Multiple)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Line Validated"; Rec."Line Validated")
                {
                    Caption = 'Validated';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
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




