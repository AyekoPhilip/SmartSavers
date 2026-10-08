report 50004 "Monthly Advise-Loans"
{
    ApplicationArea = All;
    Caption = 'Monthly Advise-Loans';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoanMonthlyAdvise.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            RequestFilterFields = "No.", "Account No.", "Payroll/Staff No.", "Product Type", "Disbursement Date";
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(PrincipleRepayment; "Principle Repayment")
            {
            }
            column(Repayment; Repayment)
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                case "Interest Calculation Method" of

                    "Interest Calculation Method"::Amortised:
                        begin
                            "Approved Amount" := DocMngt.CreateScheduledLoanPaymentJnline("No.", Enum::"LoanTransactionType"::Repayment, 0);
                            Repayment := DocMngt.CreateScheduledLoanPaymentJnline("No.", Enum::"LoanTransactionType"::Repayment, 1);
                        end;
                    "Interest Calculation Method"::"Reducing Balance":
                        begin
                            Repayment := "Principle Repayment"
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
                group(GroupName)
                {
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
        DocMngt: Codeunit "Doc-PostMgt";
}
