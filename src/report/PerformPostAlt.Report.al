report 50358 "Perform. Post Alt."
{
    ApplicationArea = All;
    Caption = 'Perform. Post Alt.';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

    dataset
    {
        dataitem(TempAltChannels; "Temp. Alt. Channels")
        {
            column(TraceID; "Trace ID")
            {
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                if not Posted and "Manual Entry" then begin

                    AltTrans.Reset();
                    AltTrans.SetRange("Trace ID", "Trace ID");
                    if AltTrans.FindFirst() then begin
                        ResponsTxt := Post.PerformPostCashWithdrawalcallbackTxt(AltTrans."Trace ID");
                    end else begin
                        ResponsTxt := AltChannelMngt.CallBackPostMngtTxt("Trace ID", "Reference No",
                       Amount, "Charge Amount", "Account No", Description, "Phone No.", "Charge Code")
                    end;
                    Message('%1', ResponsTxt);
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
        AltChannelMngt: Codeunit "Alt. Channel (Mobile Mngt.)";
        Trans: Record "ATM Transaction";
        AltTrans: Record "Alt. Channel Entry";
        Post: Codeunit "Mngt. Post Alt. Channels";
        ResponsTxt: Text[250];

}



