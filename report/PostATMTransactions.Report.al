report 50371 "Post ATM Transactions"
{
    ApplicationArea = All;
    Caption = 'Post ATM Transactions';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(ATMTransaction; "Link Transactions")
        {
            column(TraceID; "Trace ID")
            {
            }
            column(Source; Source)
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if Posted then CurrReport.Skip();
                PostMngt.PerformPostWithdrawalSaccoLinkTxt("Trace ID")
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
        PostMngt: Codeunit "Mngt. Post Alt. Channels";
}



