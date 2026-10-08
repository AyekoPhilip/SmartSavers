page 50835 "Appraisal Salary Details"
{
    PageType = Card;
    SourceTable = "Appraisal Salary Details";
    SourceTableView = where("Auto Computed" = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {

                ShowCaption = false;
                field("Client Code"; Rec."Client Code")
                {
                    Visible = false;
                    Editable = false;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Visible = false;
                    Editable = false;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Loan Application No."; Rec."Loan Application No.")
                {
                    Visible = false;
                    Editable = false;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action2)
            {
                action("Clear Salary Details")
                {
                    Image = SetupPayment;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        AppSalDetails: Record "Appraisal Salary Details";
                    begin
                        AppSalDetails.Reset();
                        AppSalDetails.SetRange("Loan Application No.", Rec."Loan Application No.");
                        AppSalDetails.SetRange("Client Code", Rec."Client Code");
                        AppSalDetails.DeleteAll();
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Clear Salary Details_Promoted"; "Clear Salary Details")
                {
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        LoanApps.Reset;
        LoanApps.SetRange("Application No.", Rec."Loan Application No.");
        if LoanApps.Find('-') then begin
            if LoanApps."Approval Status" <> LoanApps."Approval Status"::Open then begin
                Error('You cannot delete a record that is already approved');
            end;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin

       LoanApps.Reset;
        LoanApps.SetRange("Application No.", Rec."Loan Application No.");
        if LoanApps.Find('-') then begin
            if LoanApps."Approval Status" = LoanApps."Approval Status"::Open then begin
                CurrPage.Editable := true;
            end else
                CurrPage.Editable := false;
        end; 

    end;

    trigger OnOpenPage()
    begin

       LoanApps.Reset;
        LoanApps.SetRange("Application No.", Rec."Loan Application No.");
        if LoanApps.Find('-') then begin
            if LoanApps."Approval Status" = LoanApps."Approval Status"::Open then begin
                CurrPage.Editable := true;
            end else
                CurrPage.Editable := false;
        end; 

    end;

    trigger OnAfterGetRecord()
    begin
        LoanApps.Reset;
        LoanApps.SetRange("Application No.", Rec."Loan Application No.");
        if LoanApps.Find('-') then begin
            if LoanApps."Approval Status" = LoanApps."Approval Status"::Open then begin
                CurrPage.Editable := true;
            end else
                CurrPage.Editable := false;
        end; 
    end;

    var
        LoanApps: Record Loans;
}




