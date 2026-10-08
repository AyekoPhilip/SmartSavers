report 50369 "Account Activation"
{
    ApplicationArea = All;
    Caption = 'Account Activation';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/report_layout/AccountChanges.rdl';
    dataset
    {
        dataitem(MemberChanges; "Member Changes")
        {
            RequestFilterFields = "No.", "Changes Type", "Operation Type", "Document Type", "Application Date";
            DataItemTableView = where("Changes Type" = filter("account Activation"));
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApplicationNo; "Application No.")
            {
            }
            column(ApplicationReason; "Application Reason")
            {
            }
            column(Created_By; "Created By")
            {

            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(ChangesType; "Changes Type")
            {
            }
            column(Classification; Classification)
            {
            }
            column(IDNo; "ID No.")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(Name; Name)
            {
            }
            column(OperationType; "Operation Type")
            {
            }
            column(PostingType; "Posting Type")
            {
            }
            column(ProductType; "Product Type")
            { }
            column(PayrollStaffNo; "Payroll/Staff No.")
            { }
            column(No; "No.")
            { }
            column(Date_Posted; "Date Posted")
            { }
            column(Posted_By; "Posted By")
            { }
            column(Document_Type; "Document Type")
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



