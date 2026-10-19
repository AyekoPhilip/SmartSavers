report 50219 "Approval Request Entries"
{
    Caption = 'Approval Request Entries';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/GlvsApprovalEntries.rdl';
    ApplicationArea = All;




    dataset
    {
        dataitem(ApprovalEntry; "Approval Entry")
        {
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



