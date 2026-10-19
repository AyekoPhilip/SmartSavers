report 50355 "Generate QC. Loan Entry"
{
    ApplicationArea = All;
    Caption = 'Generate QC. Loan Entry';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    UsageCategory = Administration;
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
            column(OutstandingPrincipal; "Outstanding Principal")
            {
            }
            column(OutstandingInterest; "Outstanding Interest")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingBill; "Outstanding Bill")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                PeriodicMngt.CreateQcLoanEntry(Loans, TransType::Repayment);
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
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        TransType: Enum "LoanTransactionType";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        PostingType: Option " ","Post Application","Generate Batch";
}



