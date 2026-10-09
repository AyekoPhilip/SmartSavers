report 50376 "Post SaccoLink Transactions"
{
    ApplicationArea = All;
    Caption = 'Post SaccoLink Transactions';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

    dataset
    {
        dataitem(ATMTransaction; "ATM Transaction")
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

                if Source = Source::ATM then begin
                    PostMngt.PerformPostATM("Trace ID")

                end else begin
                    CurrReport.Skip();
                end;
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



