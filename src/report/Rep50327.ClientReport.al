report 50327 "Client Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/ClientReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)
        {
            column(No_Members; Member."No.")
            {
            }
            column(Name_Members; Member.Name)
            {
            }
            column(PhoneNo_Members; Member."Phone No.")
            {
            }
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




