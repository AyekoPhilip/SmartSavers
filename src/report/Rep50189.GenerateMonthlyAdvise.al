report 50189 "Generate Monthly Advise"
{
    ApplicationArea = All;
    Caption = 'Generate Monthly Advise';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Member; Member)
        {
            column(No; "No.")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(Status; Status)
            {
            }
            column(MemberCategory; "Member Category")
            {
            }
            column(MemberSegment; "Member Segment")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                PeriodicAct.generateCustPeriodicAdvise(Member);

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

    var
        PeriodicAct: Codeunit "Periodic Activities Mgt.";
}



