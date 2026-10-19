namespace SaccoDatabase.SaccoDatabase;

report 90016 "Generate Loan Repayment Schedu"
{
    Caption = 'Generate Loan Repayment Schedule';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/GenerateLoanrepaymentSchedules.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Outstanding Balance" = filter(<> 0));
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Date Filter";

            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin



                if Loan.Get(loans."No.") then begin

                    CredMngt.fncreateRepayschedule(false, Loan."No.", 0)
                end;


            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var

        loan: Record Loans;
        CredMngt: Codeunit "Credit Mgmt.";


}
