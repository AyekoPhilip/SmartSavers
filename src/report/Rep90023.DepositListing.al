namespace SaccoDB.SaccoDB;

report 90023 "Deposit Listing"
{
    ApplicationArea = All;
    Caption = 'Deposit Listing';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/DepositListing.rdl';
    dataset
    {
        dataitem(AccountCredit; "Account Credit")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where("Account Category" = filter("Shares Deposit"));
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Gender; Gender)
            {
            }
            column(DateofBirth; "Date of Birth")
            {
            }
            column(ProductName; "Product Name")
            {
            }
            column(ProductType; "Product Type")
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(Balance; Balance)
            {
            }
            column(BalanceLCY; "Balance (LCY)")
            {
            }
            column(ID_Passport_No_; "ID/Passport No.") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(CustomerType; customertype) { }
            column(InterestRate; interestrate) { }
            column(WithdrawalOption; "Withdrawal Option") { }

            trigger OnAfterGetRecord()
            begin
                interestrate := 0;

                if "Member No." = 'NULLENTRY' then CurrReport.Skip();
                if custrec.Get("Member No.") then
                    "ID/Passport No." := custrec."ID No.";
                Gender := custrec.Gender;
                "Date of Birth" := custrec."Date of Birth";
                "Global Dimension 2 Code" := custrec."Global Dimension 2 Code";
                customertype := custrec."Customer Type";

                accountype.Get("Product Type");
                interestrate := accountype."Interest Rate (Max.)";
                "Withdrawal Option" := accountype."Withdrawal Option";
            end;
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
    var
        accountype: Record "Product Factory";
        custrec: Record Member;
        customertype: Enum CreditCustomerType;
        interestrate: Decimal;
}
