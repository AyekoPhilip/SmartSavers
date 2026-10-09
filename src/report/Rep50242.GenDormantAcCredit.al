report 50242 "Gen. Dormant Ac- Credit"
{
    ApplicationArea = All;
    Caption = 'Gen. Dormant Ac- Credit';
    UsageCategory = ReportsAndAnalysis;

    DefaultLayout = RDLC;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(AccountCredit; "Account Credit")
        {
            column(No; "No.")
            { }
            column(ProductType; "Product Type")
            { }
            column(Status; Status)
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                DocsMngt.GenerateDormantAcMngt(2, "No.");
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
        DocsMngt: Codeunit "Doc-PostMgt";
}



