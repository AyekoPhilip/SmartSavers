report 50274 "Mobile Registration"
{
    ApplicationArea = All;
    Caption = 'Mobile Registration';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MobileRegistrationReport.rdl';
    dataset
    {
        dataitem(DscMobileApplication; "Dsc Mobile Application")
        {
            column(ApplicationNo; "Application No")
            {
            }
            column(ApplicationType; "Application Type")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(Changed; Changed)
            {
            }
            column(Comments; Comments)
            {
            }
            column(CustomerIDNo; "Customer ID No")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(DateEntered; "Date Entered")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentSerialNo; "Document Serial No")
            {
            }
            column(Iagreeinformationistrue; "I agree information is true")
            {
            }
            column(MemberNo; "Member No.")
            {
            }
            column(MobileCorporateNo; "Mobile Corporate No.")
            {
            }
            column(MobilePhoneNo; "Mobile Phone No.")
            {
            }
            column(No; "No.")
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



