namespace DynamicsNav.SaccoDatabase;
using Microsoft.Sales.Receivables;

report 50416 "Gen. Loan Categorization"
{
    ApplicationArea = All;
    Caption = 'Gen. Loan Categorization';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Loan; Loans)
        {
            DataItemTableView = where("Outstanding Balance" = filter(<> 0));
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(LoanAccount; "Loan Account")
            {
            }
            column(Installments; Installments)
            {
            }
            column(InterestRate; "Interest Rate")
            {
            }
            column(InterestCalculationMethod; "Interest Calculation Method")
            {
            }
            column(RepaymentStartDate; "Repayment Start Date")
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin

                case ValidationType of
                
                    ValidationType::"Generate Shedule":
                        begin
                            CredMngt.fncreateRepayschedule(false, "No.", 0);
                        end;

                    ValidationType::"Update Loan":
                        begin

                            LoanCat.Reset();
                            LoanCat.SetRange("No.", "No.");
                            if not LoanCat.FindFirst() then begin
                                CredMngt.CreateLoancategory(Loan);

                            end else begin

                                LoanRecEntry.Reset();
                                LoanRecEntry.SetRange("No.", "No.");
                                if LoanRecEntry.FindFirst() then begin

                                    if LoanRecEntry."Application Date" <> "Application Date" then
                                        LoanRecEntry."Application Date" := "Application Date";

                                    if LoanRecEntry."Disbursement Date" <> "Disbursement Date" then
                                        LoanRecEntry."Disbursement Date" := "Disbursement Date";

                                    if LoanRecEntry."Repayment Start Date" <> "Repayment Start Date" then
                                        LoanRecEntry."Repayment Start Date" := "Repayment Start Date";

                                    if LoanRecEntry."Requested Amount" <> "Requested Amount" then
                                        LoanRecEntry."Requested Amount" := "Requested Amount";

                                    if LoanRecEntry."Approved Amount" <> "Approved Amount" then
                                        LoanRecEntry."Approved Amount" := "Approved Amount";

                                    if LoanRecEntry."Interest Rate" <> "Interest Rate" then
                                        LoanRecEntry."Interest Rate" := "Interest Rate";

                                    if LoanRecEntry.Installments <> Installments then
                                        LoanRecEntry.Installments := Installments;

                                    if LoanRecEntry.Repayment <> Repayment then
                                        LoanRecEntry.Repayment := Repayment;

                                    if LoanRecEntry."Principle Repayment" <> "Principle Repayment" then
                                        LoanRecEntry."Principle Repayment" := "Principle Repayment";

                                    if LoanRecEntry."Interest Repayment" <> "Interest Repayment" then
                                        LoanRecEntry."Interest Repayment" := "Interest Repayment";

                                    if LoanRecEntry."Expected Date of Completion" <> "Expected Date of Completion" then
                                        LoanRecEntry."Expected Date of Completion" := "Expected Date of Completion";

                                    if LoanRecEntry."Loan Account" <> "Loan Account" then
                                        LoanRecEntry."Loan Account" := "Loan Account";

                                    if LoanRecEntry."Disbursement Account No." <> "Disbursement Account No." then
                                        LoanRecEntry."Disbursement Account No." := "Disbursement Account No.";
                                    LoanRecEntry.Modify(true)
                                end;
                            end;

                        end;
                end;

            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                     field(ValidationType; ValidationType)
                    {
                        Caption = 'Validation Type';
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        CredLeger: Record "Detailed Cust. Ledg. Entry";
        CustLedger: Record "Cust. Ledger Entry";
        LoanCat: Record "Loans Categorization";
        credtMngt: Codeunit "Credit Post Mngt.";
        Credit: Record "Credit Account";
        Member: Record Member;
        CredMngt: Codeunit "Credit Mgmt.";
        LoanRecEntry: Record "Loans Categorization";
        ValidationType: Option " ","Update Loan","Correct Amount","Generate Shedule";
}
