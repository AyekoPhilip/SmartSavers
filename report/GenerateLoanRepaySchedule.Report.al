report 50328 "Generate Loan Repay Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/GenerateLoanRepaySchedule.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Loans; Loans)
        {
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}




