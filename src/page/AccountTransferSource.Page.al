page 50872 "Account Transfer Source"
{
    PageType = ListPart;
    SourceTable = "Account Transfer Source";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                ShowCaption = false;
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    ValuesAllowed = 0, 1, 2;
                    StyleExpr = true;
                    Visible = false;

                }
                field("Account Type"; Rec."Account Type")
                {
                    Caption = 'Account Type';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    ValuesAllowed = 7, 8;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Account No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Available Balance"; Rec."Available Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field("Transaction Type"; Rec."Transaction Type")
                {
                    Caption = 'Transaction Type';
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    Caption = 'Loan No.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    Caption = 'Product Type';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

            }
        }
    }
    actions
    {
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transfer Type" := Rec."Transfer Type"::Self;
        Rec."Account Type" := Rec."Account Type"::Credit;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Transfer Type" := Rec."Transfer Type"::Self;
        Rec."Account Type" := Rec."Account Type"::Credit;
    end;
}




