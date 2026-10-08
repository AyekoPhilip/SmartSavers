report 50239 "Generate Dormant Account"
{
    ApplicationArea = All;
    Caption = 'Generate Dormant Account';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(AccountBanking; "Account Banking")
        {
            DataItemTableView = where("Account Category" = const(Savings));
            column(No; "No.")
            { }
            column(ProductType; "Product Type")
            { }
            column(Status; Status)
            { }
            column(Member_No_; "Member No.")
            { }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                DocMngt.GenerateDormantAcMngt(1, "No.");
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
        DocMngt: Codeunit "Doc-PostMgt";
}



