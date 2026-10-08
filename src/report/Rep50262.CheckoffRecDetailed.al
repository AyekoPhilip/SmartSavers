report 50262 "Checkoff Rec Detailed"
{
    ApplicationArea = All;
    Caption = 'Checkoff Rec Detailed';
    UsageCategory = Lists;
    RDLCLayout = './src/report_layout/CheckOffSummary.rdl.rdl';
    dataset
    {
        dataitem(CheckoffReceiptLines; "Checkoff Receipt Lines")
        {
            column(MemberNo; "Member No.")
            {
            }
            column(PayrollStaffNo; "Payroll/Staff No.")
            {
            }
            column(Name; Name)
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(UploadID; "Upload ID")
            {
            }
            column(UploadResponse; "Upload Response")
            {
            }
            column(LineValidated; "Line Validated")
            {
            }
            column(AccountFound; "Account Found")
            {
            }
            column(Amount; Amount)
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



