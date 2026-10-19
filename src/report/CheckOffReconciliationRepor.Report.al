report 90001 "Check Off Reconciliation Repor"
{
    ApplicationArea = All;
    Caption = 'Check Off Reconciliation Report';
    RDLCLayout = './src/report_layout/CheckoffReconcilliation.rdl';


    UsageCategory = Lists;
    dataset
    {
        dataitem(CheckoffHeader; "Checkoff Header")
        {
            column(No; "No.")
            {
            }
            column(AccountNo; "Account No.")
            {
            }
            column(AccountName; "Account Name")
            {
            }
            column(Description; Description)
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(EmployerName; "Employer Name")
            {
            }
            column(AccountFound; "Account Found")
            {
            }
            column(AccounNotFound; "Accoun Not Found")
            {
            }
            column(RecordNotPosted; "Record Not Posted")
            {
            }
            column(PostedRecord; "Posted Record")
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



