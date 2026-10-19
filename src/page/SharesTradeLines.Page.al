page 51110 "Shares Trade Lines"
{
    ApplicationArea = All;
    Caption = 'Shares Trade Lines';
    PageType = ListPart;
    SourceTable = "Account Transfer Destination";
    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                ShowCaption = false;
                field("Transfer Type"; Rec."Transfer Type")
                {
                    Style = StandardAccent;
                    Editable = false;
                    Visible = false;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ValuesAllowed = 0, 1, 2;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Caption = 'Account Type';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Editable=false;
                    ValuesAllowed = 7, 8, 9;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Caption = 'Account No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Caption = ' Description';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    Caption = 'Loan No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Clear Loan"; Rec."Clear Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Visible = false;
                    StyleExpr = true;

                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Settlement Fee"; Rec."Settlement Fee")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Visible = false;

                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Outstanding Bills"; Rec."Outstanding Bills")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Caption = 'Outstanding Balance';
                    StyleExpr = TRUE;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    Caption = 'Product Type';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Editable = false;
                    StyleExpr = true;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action1000000002)
            {
                action("Import Bulk Refunds")
                {
                    Image = ImportExcel;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Print Report")
                {
                    Caption = 'Print';
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transfer Type" := Rec."Transfer Type"::"Share Transfer";
        Rec."Account Type" := Rec."Account Type"::Credit;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Transfer Type" := Rec."Transfer Type"::"Share Transfer";
        Rec."Account Type" := Rec."Account Type"::Credit;
    end;
}
