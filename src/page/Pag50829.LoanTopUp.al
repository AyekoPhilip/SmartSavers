page 50829 "Loan Top Up"
{
    PageType = List;
    SourceTable = "Loans Top up";
    SourceTableView = where("Document Type" = const("Loan Topup"));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Outstanding Principle"; Rec."Outstanding Principle")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Untransfered Interest"; Rec."Untransfered Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Fee"; Rec."Outstanding Fee")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Ignore Charges"; Rec."Ignore Charges")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Commision; Rec.Commision)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Settlement Fee"; Rec."Settlement Fee")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Outstanding Amount"; Rec."Total Outstanding Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;

                }
                field("Total Total Up"; Rec."Total Total Up")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;

                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Account)
            {
                Caption = 'Loan Card';
                Image = CalculateCost;
                RunObject = Page "Loans List Posted";
                RunPageLink = "No." = field("Loan Top Up");
                ApplicationArea = All;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Account_Promoted; Account)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        LoanApp: Record "Loan Application";
    begin
        if LoanApp.Get(Rec."No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                CurrPage.Editable := false
    end;
}




