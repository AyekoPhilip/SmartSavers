codeunit 50068 "Alt. Post Jnl. Line  (Yes/No)"
{
    trigger OnRun()
    begin

        AltChannel.Reset();
        AltChannel.SetRange(Posted, false);
        AltChannel.SetFilter(Amount, '>0');
        AltChannel.SetFilter("Trace ID", '<>%1', '');
        AltChannel.SetRange(Source, AltChannel.Source::ATM);
        if AltChannel.FindFirst() then begin
            repeat
                case AltChannel.Source of
                    AltChannel.Source::ATM:
                        begin
                            Post.PerformPostWithdrawalSaccoLinkTxt(AltChannel."Trace ID")

                        end;
                end;
            until AltChannel.Next() = 0;

        end;

    end;

    var
        AltChannel: Record "ATM Transaction";
        Post: Codeunit "Mngt. Post Alt. Channels";

}



