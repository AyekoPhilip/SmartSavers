report 50350 "Automated Card Report"
{
    ApplicationArea = All;
    Caption = 'Automated Card Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/AutomatedCard.rdl';
    dataset
    {
        dataitem(AccountBanking; "Account Banking")
        {
            DataItemTableView=where("Account Category"=const(Savings));
            
            column(ATMNo; "ATM No.")
            {
            }
            column(ATMTransactions; "ATM Transactions")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountDimension; "Account Dimension")
            {
            }
            column(Balance; Balance)
            {
            }
            column(AvailableShares; "Available Shares")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Name; Name)
            {
            }
            column(No; "No.")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(Status; Status)
            {
            }
            column(ExpiryDateCard; "Expiry Date (Card)")
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



