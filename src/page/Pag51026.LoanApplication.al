page 51026 "Loan Application"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
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
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
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

    trigger OnOpenPage()
    begin
        CurrPage.Editable := false
    end;
}




