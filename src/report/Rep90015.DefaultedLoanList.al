namespace SaccoDatabase.SaccoDatabase;

report 90015 "Defaulted Loan List"
{
    ApplicationArea = All;
    Caption = 'Defaulted Loan List';
    UsageCategory = Lists;
    DefaultLayout = RDLC;
    ExcelLayout = './src/report_layout/DefaultLoanlist.xlsx';
    RDLCLayout = './src/report_layout/DefaultLoanlist.rdl';
    dataset
    {
        dataitem(Loans; Loans)
        {

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
            column(ProductDescription; "Product Description")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(AmountinArrears; "Amount in Arrears")
            {
            }
            column(LoanAccount; "Loan Account")
            {
            }

            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }

            column(OutstandingBalance; "Outstanding Balance")
            {
            }

            column(LastPayDate; "Last Pay Date")
            {
            }
            column(Date_Filter; "Date Filter")
            {

            }
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
