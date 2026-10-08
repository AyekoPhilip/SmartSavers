report 50313 "Standing Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/StandingOrder.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Standing Order Header"; "Standing Order Header")
        {
            DataItemTableView = where("Approval Status" = filter(Approved | Stopped));

            RequestFilterFields = "No.", "Approval Status", "Next Run Date", "Effective/Start Date";
            column(No; "Standing Order Header"."No.")
            {
            }
            column(Source_Account_Type; "Source Account Type")
            {

            }
            column(AccNo; "Standing Order Header"."Source Account No.")
            {
            }
            column(Name; "Standing Order Header"."Source Account Name")
            {
            }
            column(Amount; "Standing Order Header".Amount)
            {
            }
            column(EndDate; "Standing Order Header"."End Date")
            {
            }
            column(Statuss; "Standing Order Header"."Approval Status")
            {
            }
            column(Effective_Start_Date; "Effective/Start Date")
            { }
            column(Member_No_; "Member No.")
            {
            }
            column(Description; Description)
            { }
            column(Next_Run_Date; "Next Run Date")
            { }
            column(Approval_Status; "Approval Status")
            { }
            column(Picture; Company.Picture)
            {
            }
            column(Address; Company.Address)
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(IDNumber_StandingOrderHeader; "Standing Order Header"."ID Number")
            {
            }
            dataitem("Standing Order Lines"; "Standing Order Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Type; "Standing Order Lines"."Destination Account Type")
                {
                }
                column(DAcccNo; "Standing Order Lines"."Destination Account No.")
                {
                }
                column(DAmount; "Standing Order Lines".Amount)
                {
                }
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

    trigger OnPreReport()
    begin
        if Company.Get() then
            Company.CalcFields(Company.Picture);
    end;

    var
        Company: Record "Company Information";
}




