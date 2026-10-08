report 50237 "Receipt Line Summary"
{
    ApplicationArea = All;
    Caption = 'Receipt Line Summary';
    UsageCategory = Lists;
    RDLCLayout = './src/report_layout/PaymentsLine.rdl';
    dataset
    {
        dataitem(ReceiptLine; "Receipt Line")
        {
            column(No; No)
            {
            }
            column(Type; "Type")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(TransactionType; "Transaction Type")
            {
            }
            column(ProductCategory; "Product Category")
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(ReceivedFrom; "Received From")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(OnBehalfOf; "On Behalf Of")
            {
            }
            column(Date; "Date")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(Amount; Amount)
            {
            }
            column(UserID; "User ID")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(BankAccount; "Bank Account")
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



