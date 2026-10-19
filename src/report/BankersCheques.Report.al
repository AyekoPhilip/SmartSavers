report 50364 "Bankers Cheques"
{
    ApplicationArea = All;
    Caption = 'Bankers Cheques';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/BankersCheque.rdl';
    dataset
    {
        dataitem(TellerTransaction; "Teller Transaction")
        {
            DataItemTableView = where(Type = filter("Cheque Deposit" | "Bankers Cheque"), Posted = const(true));
            column(No; "No.")
            {
            }
            column(Payee; Payee)
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(TillCode; "Till Code")
            {
            }
            column(TillName; "Till Name")
            {
            }
            column(TransactionDate; "Transaction Date")
            {
            }
            column(TransactionDescription; "Transaction Description")
            {
            }
            column(TransactionOptions; "Transaction Options")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(Type; "Type")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ProductCategory; "Product Category")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(IDNo; "ID No")
            {
            }
            column(ChequeDate; "Cheque Date")
            {
            }
            column(ChequeIssueingBank; "Cheque Issueing Bank")
            {
            }
            column(ChequeNo; "Cheque No")
            {
            }
            column(ChequeType; "Cheque Type")
            {
            }
            column(ChequeStatus; "Cheque Status")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(BankersChequeNo; "Bankers Cheque No")
            {
            }
            column(BankAccount; "Bank Account")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AllocatedAmount; "Allocated Amount")
            {
            }
            column(EmployerCode; "Employer Code")
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



