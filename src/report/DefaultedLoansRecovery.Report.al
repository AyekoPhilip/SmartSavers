report 50232 "Defaulted Loans Recovery"
{
    ApplicationArea = All;
    Caption = 'Defaulted Loans Recovery';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/DefaultedLoansRecovery.rdl';
    dataset
    {
        dataitem(LoanRecoveryMngt; "Loan Recovery Mngt.")
        {
            column(LoanNo; "Loan No.")
            { }
            column(MemberNo; "Member No.")
            { }
            column(AccountNo; "Account No.")
            { }
            column(AccountName; "Account Name")
            { }
            column(ProductType; "Product Type")
            { }
            column(RecoveryType; "Recovery Type")
            { }
            column(ApprovedAmount; "Approved Amount")
            { }
            column(OutstandingInterest; "Outstanding Interest")
            { }
            column(OutstandingPrincipal; "Outstanding Principal")
            { }
            column(SharesDeducted; "Shares Deducted")
            { }
            column(SharesDeposit; "Shares Deposit")
            { }
            column(Date_Posted; "Date Posted")
            { }
            column(Posted_By; "Posted By")
            { }
            column(Haeder_No_; "Haeder No.")
            { }
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



