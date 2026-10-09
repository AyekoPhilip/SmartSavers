namespace SaccoDatabase.SaccoDatabase;

report 90013 "Loan Sasra Categorisation"
{
    ApplicationArea = All;
    Caption = 'Loan Sasra Categorisation';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Loans; Loans)
        {
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApprovalDate; "Approval Date")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(DisbursementDate; "Disbursement Date")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Installments; Installments)
            {
            }
            column(LoanAccount; "Loan Account")
            {
            }
            column(MemberCategory; "Member Category")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(Repayment; Repayment)
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(Months_In_arrears;"Months In arrears")
            {}
            column(Amount_in_Arrears;"Amount in Arrears")
            {}
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
}
