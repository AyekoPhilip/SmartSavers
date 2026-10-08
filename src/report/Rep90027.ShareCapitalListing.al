namespace SaccoDB.SaccoDB;

report 90027 "Share Capital Listing"
{
    ApplicationArea = All;
    Caption = 'Share Capital Listing';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/ShareCapitalListing.rdl';
    dataset
    {
        dataitem(AccountCredit; "Account Credit")
        {
            RequestFilterFields = "No.";
            DataItemTableView = where("Account Category" = filter("Shares Capital"));
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
            trigger OnAfterGetRecord()
            begin
                if "Member No." = 'NULLENTRY' then CurrReport.Skip();
                if custrec.Get("Member No.") then
                    "ID/Passport No." := custrec."ID No.";
                Gender := custrec.Gender;
                "Date of Birth" := custrec."Date of Birth";
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
        custrec: Record Member;
}
