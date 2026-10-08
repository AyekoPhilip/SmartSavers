page 51034 "Guarantors & Security"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Guarantor & Security Posted";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Security Type"; Rec."Security Type")
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
                field("Collateral Reg. No."; Rec."Collateral Reg. No.")
                {
                    ApplicationArea = All;
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
                 field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
               
               
                field("Available Shares"; Rec."Available Shares")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deposit Shares"; Rec."Deposit Shares")
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
                field("Self Guaranteed"; Rec."Self Guaranteed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Self Guaranteed field.';
                }
                field(Substituted; Rec.Substituted)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
        }
    }
    actions
    {
        area(creation)
        {

        }
        area(Processing)
        {


        }
        area(Reporting)
        {
            action("Payment Certificate")
            {
                Image = Category;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Agreement.Reset();
                    Agreement.SetRange("Account No.", Rec."Account No.");
                    if Agreement.FindFirst() then begin
                        Report.Run(Report::"Guarantor Payment Certificate", true, false, Agreement);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                actionref("Payment Certificate_Promoted"; "Payment Certificate")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable := false
    end;

    var
        Agreement: Record "Guarantor & Security Posted";
}




