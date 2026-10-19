report 50314 "STO Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/STORegister.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Standing Order Register"; "Standing Order Register")
        {
            column(No; "Standing Order Register"."No.")
            {
            }
            column(STONo; "Standing Order Register"."Document No.")
            {
            }
            column(SourceAccount; "Standing Order Register"."Source Account No.")
            {
            }
            column(AccName; "Standing Order Register"."Source Account Name")
            {
            }
            column(Status; "Standing Order Register"."Deduction Status")
            {
            }
            column(Amount; "Standing Order Register".Amount)
            {
            }
            column(AmountDeducted; "Standing Order Register"."Amount Deducted")
            {
            }
            column(DateProcessed; "Standing Order Register"."Date Processed")
            {
            }
            column(Picture; Company.Picture)
            {
            }
            column(Address; Company.Address)
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            dataitem("Standing Order Lines"; "Standing Order Lines")
            {
                DataItemLink = "Document No." = FIELD("Document No.");
                column(Type; "Standing Order Lines"."Destination Account Type")
                {
                }
                column(DAcc; "Standing Order Lines"."Destination Account No.")
                {
                }
                column(DName; "Standing Order Lines"."Destination Account Name")
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




