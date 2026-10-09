page 51082 "External Commitments"
{

    Caption = 'External Commitments';
    PageType = List;
    SourceTable = "Other Commitements Clearance";
    UsageCategory = Lists;
    Editable = true;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
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
                    Editable=false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    Visible = false;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }

            }
        }
    }

    actions
    {
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Account;
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
    end;

    trigger OnOpenPage()
    begin
        if LoanApp.Get(Rec."Application No.") then begin
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                CurrPage.Editable := false;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin


    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if LoanApp.Get(Rec."Application No.") then begin
            LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if LoanApp.Get(Rec."Application No.") then begin
            LoanApp.TestField("Approval Status", LoanApp."Approval Status"::Open);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if LoanApp.Get(Rec."Application No.") then begin
            Rec."Disbursement Date" := LoanApp."Disbursement Date";
            Rec."Approval Status" := LoanApp."Approval Status";
            Rec.Modify(true)
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.Type := Rec.Type::Account;
        if LoanApp.Get(Rec."Application No.") then begin

            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then begin
                CurrPage.Editable := false
            end else begin

                Rec."Disbursement Date" := LoanApp."Disbursement Date";
                Rec."Approval Status" := LoanApp."Approval Status";
                Rec.Modify(true)
            end;
        end;
    end;

    var
        LoanApp: Record "Loan Application";
}
