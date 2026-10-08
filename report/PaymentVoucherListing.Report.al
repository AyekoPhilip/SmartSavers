namespace DynamicsNav.SaccoDatabase;

report 50024 "Payment Voucher-Listing"
{
    ApplicationArea = All;
    Caption = 'Payment Voucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/PaymentvoucerListing.rdl';
    dataset
    {
        dataitem(PaymentsHeader; "Payments Header")
        {
            column(No; "No.")
            {
            }
            column(Payee; Payee)
            {
            }
            column(ChequeNo; "Cheque No")
            {
            }
            column(PayingBankAccount; "Paying Bank Account")
            {
            }
            column(PaymentReleaseDate; "Payment Release Date")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(TotalNetAmount; "Total Net Amount")
            {
            }
            column(TotalVATAmount; "Total VAT Amount")
            {
            }
            column(TotalWitholdingTax; "Total Witholding Tax")
            {
            }
            column(TotalWitholdingTaxAmount; "Total Witholding Tax Amount")
            {
            }
            column(TotalWitholdingVATTax; "Total Witholding VAT Tax")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(Date; "Date")
            {
            }
            column(ChequeType; "Cheque Type")
            {
            }
            column(ChequeDate; "Cheque Date")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
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
}
