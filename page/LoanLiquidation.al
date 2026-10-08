page 90001 "Loan Liquidation"
{
    PageType = List;
    SourceTable = "Loans Liquidation";
    SourceTableView = where("Document Type" = const("Loan Liquidation"));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                 field("No."; Rec."No.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                 field("Account No.";Rec."Account No.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ApplicationArea = All;
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
                field("Outstanding Principle"; Rec."Outstanding Principle")
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


                field("Total Outstanding Amount"; Rec."Total Outstanding Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
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
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::"Loan Liquidation";
    end;

    trigger OnAfterGetRecord()
    begin
        if LoanApp.Get(Rec."No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                CurrPage.Editable := false
    end;
    trigger OnOpenPage()
    begin
        if LoanApp.Get(Rec."No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                CurrPage.Editable := false

    end;
    trigger OnModifyRecord(): Boolean
    begin

        if LoanApp.Get(Rec."No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                Error('You cannot edit an approved application');
    end;
    trigger OnDeleteRecord(): Boolean
    begin
        if LoanApp.Get(Rec."No.") then
            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                Error('You cannot edit an approved application');
    end;
    var
        LoanApp: Record "Loan Application";

}




