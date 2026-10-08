report 50277 "Mobile Loan Status"
{
    ApplicationArea = All;
    Caption = 'Mobile Loan Status';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/MobileLoanStatusReport.rdl';
    dataset
    {
        dataitem(DSCMobileLoan; "DSC Mobile Loan")
        {
            column(EntryNo; "Entry No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Date; "Date")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Remarks; Remarks)
            {
            }

            column(LoanNo; "Loan No.")
            {
            }
            column(ProductType; "Product Type")
            {
            }

            column(RequestedAmount; "Requested Amount")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(Status; Status)
            {
            }

            column(DateTimeCaptured; "Date/Time Captured")
            {
            }

            column(Posted; Posted)
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(ReceiptNo; "Receipt No.")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Remarks := CopyStr(Remarks, 4, 250)

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
}



