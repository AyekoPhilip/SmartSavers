report 50275 "Send Member Statement"
{
    ApplicationArea = All;
    Caption = 'Send Member Statement';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    dataset
    {
        dataitem(Member; Member)
        {
            column(No; "No.")
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(EmailPersonal; "E-mail (Personal)")
            {
            }
            trigger OnPreDataItem()
            begin
                Gensetup.Get();
                Gensetup.TestField("Statement Frequency");
                if StartDate = 0D then StartDate := CalcDate('-' + format(Gensetup."Statement Frequency"), Today);
                if EndDate = 0D then EndDate := Today;
            end;

            trigger OnAfterGetRecord()
            begin
                case Member.Status of

                    Member.Status::Active,
                    Member.Status::New,
                    Member.Status::Defaulter,
                    Member.Status::Dormant:
                        begin

                            EmailSent := false;
                            
                            if Member."Last Statement Date" = 0D then begin
                                Member."Last Statement Date" := Today;
                                Member.Modify(true);
                            end;

                            if Member."E-Mail" <> '' then begin

                                if Member."Last Statement Date" = Today then begin
                                    EmailSent := AltChannel.SendFullStatementFreq(Member."No.", StartDate, EndDate);
                                    if EmailSent then begin
                                        Member."Last Statement Date" := Today;
                                        Member.Modify(true);
                                    end;
                                end;
                            end;
                        end;
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
        StartDate: Date;
        EndDate: Date;
        AltChannel: Codeunit "Alt. Channel (Mobile Mngt.)";
        Gensetup: Record "General Set-Up";
        EmailSent: Boolean;
}



