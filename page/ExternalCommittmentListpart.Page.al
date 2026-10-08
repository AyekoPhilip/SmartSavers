namespace SaccoDatabase.SaccoDatabase;

page 90007 "External Committment Listpart"
{
    ApplicationArea = All;
    Caption = 'External Committment Listpart';
    PageType = ListPart;
    SourceTable = "Other Commitements Clearance";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.', Comment = '%';
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    Editable = false;
                }
                field("Bankers Cheque No"; Rec."Bankers Cheque No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
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
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }


            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Account;
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Account;
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
    end;

    trigger OnDeleteRecord(): Boolean
    begin

    end;

    trigger OnModifyRecord(): Boolean
    begin

    end;

    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnAfterGetRecord()
    begin


    end;

    var
        LoanApp: Record "Loan Application";
}
