report 50005 "Checkoff Advise-Detailed"
{
    ApplicationArea = All;
    Caption = 'Checkoff Advise-Detailed';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/CheckoffMonthlyAdvise.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            RequestFilterFields = "No.", "Account No.", "Payroll/Staff No.", "Product Type", "Disbursement Date";
            column(No_; "No.")
            { }
            column(Payroll_Staff_No_; "Payroll/Staff No.")
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
            column(Repayment; Repayment)
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(Installments; Installments)
            {
            }
            column(LoanCode; LoanCode)
            {

            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                LoanCode := '';

                if LoanType.Get("Product Type") then
                    LoanCode := LoanType."Search Code";
                if "Interest Calculation Method" <> LoanType."Interest Calculation Method" then begin
                    "Interest Calculation Method" := LoanType."Interest Calculation Method";
                    Modify(true)
                end;

                case "Interest Calculation Method" of
                    "Interest Calculation Method"::Amortised:
                        begin
                            "Approved Amount" := DocMngt.CreateScheduledLoanPaymentJnline("No.", Enum::"LoanTransactionType"::Repayment, 0);
                            Repayment := DocMngt.CreateScheduledLoanPaymentJnline("No.", Enum::"LoanTransactionType"::Repayment, 1);
                        end;
                    "Interest Calculation Method"::"Zero Interest",
               "Interest Calculation Method"::"Reducing Balance":
                        begin
                            "Approved Amount" := "Approved Amount";
                            Repayment := Round("Approved Amount" / Installments)
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
        LoanCode: Code[10];
        LoanType: Record "Product Factory";
}
