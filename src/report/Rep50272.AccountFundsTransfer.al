report 50272 "Account Funds Transfer"
{
    ApplicationArea = All;
    Caption = 'Account Funds Transfer';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/AccountFundsTransfer.rdl';
    dataset
    {
        dataitem(AccountTransferDestination; "Account Transfer Destination")
        {
            DataItemTableView = where(Posted = const(true));
            column(AccountName; "Account Name")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(Amount; Amount)
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(LoanNo; "Loan No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(No; "No.")
            {
            }
            column(Posted; Posted)
            {
            }
            column(ProductCode; "Product Code")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(TransferType; "Transfer Type")
            {
            }
            dataitem("Account Transfer Source"; "Account Transfer Source")
            {
                DataItemLink = "No." = field("No.");
                column(Transfer_Type; "Transfer Type")
                { }
                column(No_; "No.")
                { }
                column(Transaction_Type; "Transaction Type")
                { }
                column(Account_Type; "Account Type")
                { }
                column(Account_No_; "Account No.")
                { }
                column(Account_Name; "Account Name")
                { }
                column(SourceAmount; Amount)
                { }
                column(Product_Code; "Product Code")
                { }
                column(Product_Name; "Product Name")
                { }
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                //here
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
        AccTransfer: Record "Account Transfer Header";
}



