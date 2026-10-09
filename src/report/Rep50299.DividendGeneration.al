report 50299 "Dividend Generation"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)
        {

            trigger OnAfterGetRecord()
            begin
                intProgressI += 1;

                if (intProgressI >= NoOfRecsProgress) or (Time - TimeProgress > 1000) then begin
                    NoOfProgressed := NoOfProgressed + intProgressI;
                    diaProgress.Update(1, Round(NoOfProgressed / intProgressTotal * 10000, 1));
                    intProgressI := 0;
                    TimeProgress := Time;
                end;

                //DividendProcess.GenerateDivdends(Member."No.");
            end;

            trigger OnPostDataItem()
            begin
                diaProgress.Close;
            end;

            trigger OnPreDataItem()
            begin
                intProgressTotal := Member.Count;

                intProgressI := 0;
                TimeProgress := Time;
                NoOfRecsProgress := intProgressTotal div 100;
                NoOfProgressed := 0;

                diaProgress.Open(GeneratingDividends + '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', intProgress);
            end;
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

    trigger OnPostReport()
    begin
    end;

    trigger OnPreReport()
    begin
    end;

    var
        intProgressTotal: Integer;
        diaProgress: Dialog;
        intProgressI: Integer;
        GeneratingDividends: Label 'Generating Dividends';
        intProgress: Integer;
        TimeProgress: Time;
        NoOfProgressed: Integer;
        NoOfRecsProgress: Integer;
}




