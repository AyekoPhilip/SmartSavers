report 50209 "Deposit Returns"
{
    ApplicationArea = All;
    Caption = 'Deposit Returns';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/DepositReturns.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Member; Member)
        {
            column(No_; "No.")
            { }
            column(CompInfo; CompInfo.Name)
            { }

            column(StartDate; StartDate)
            { }
            column(EndDate; EndDate)
            { }
            column(TotalAmt; Amt[16])
            { }
            column(TotalAccCount; AccCount[16])
            { }
            column(Amt1; Amt[1])
            { }
            column(Amt2; Amt[2])
            { }
            column(Amt3; Amt[3])
            { }
            column(Amt4; Amt[4])
            { }
            column(Amt5; Amt[5])
            { }
            column(Amt6; Amt[6])
            { }
            column(Amt7; Amt[7])
            { }
            column(Amt8; Amt[8])
            { }
            column(Amt9; Amt[9])
            { }
            column(Amt10; Amt[10])
            { }
            column(Amt11; Amt[11])
            { }
            column(Amt12; Amt[12])
            { }
            column(Amt13; Amt[13])
            { }
            column(Amt14; Amt[14])
            { }
            column(Amt15; Amt[15])
            { }
            column(Amt16; Amt[16])
            { }
            column(Amt17; Amt[17])
            {}
            column(Amt18; Amt[18])
            { }
            column(Amt19; Amt[19])
            { }
            column(Amt20; Amt[20])
            { }
            column(Amt21; Amt[21])
            { }
            column(Amt22; Amt[22])
            { }

            column(AccCount1; AccCount[1])
            { }
            column(AccCount2; AccCount[2])
            { }
            column(AccCount3; AccCount[3])
            { }
            column(AccCount4; AccCount[4])
            { }
            column(AccCount5; AccCount[5])
            { }
            column(AccCount6; AccCount[6])
            { }
            column(AccCount7; AccCount[7])
            { }
            column(AccCount8; AccCount[8])
            { }
            column(AccCount9; AccCount[9])
            { }
            column(AccCount10; AccCount[10])
            { }
            column(AccCount11; AccCount[11])
            { }
            column(AccCount12; AccCount[12])
            { }
            column(AccCount13; AccCount[13])
            { }
            column(AccCount14; AccCount[14])
            { }
            column(AccCount15; AccCount[15])
            { }
            column(AccCount16; AccCount[16])
            { }
             column(AccCount17; AccCount[17])
            { }
             column(AccCount18; AccCount[18])
            { }
             column(AccCount19; AccCount[19])
            { }
             column(AccCount20; AccCount[20])
            { }
             column(AccCount21; AccCount[21])
            { }
             column(AccCount22; AccCount[22])
            { }

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then StartDate := 20000101D;
                if EndDate = 0D then EndDate := Today;
                CompInfo.get();
                TempData.DeleteAll();

                TempData.Init();
                TempData."No." := '002';
                TempData.Insert(true)
            end;

            trigger OnAfterGetRecord()
            begin

                /*  Amt[1] := 0;
                  Amt[2] := 0;
                  Amt[3] := 0;
                  Amt[4] := 0;
                  Amt[5] := 0;
                  Amt[6] := 0;
                  Amt[7] := 0;
                  Amt[8] := 0;
                  Amt[9] := 0;
                  Amt[10] := 0;
                  Amt[11] := 0;
                  Amt[12] := 0;
                  Amt[13] := 0;
                  Amt[14] := 0;
                  Amt[15] := 0;
                  Amt[16] := 0;*/

                DFilter := Format(StartDate) + '..' + Format(EndDate);


                AccCredit.Reset();
                AccCredit.SetRange("Date Filter", 0D, EndDate);
                AccCredit.SetFilter("Product Type", 'DP-00103');
                if AccCredit.Find('-') then begin
                    repeat
                        AccCredit.CalcFields(Balance);
                        if AccCredit.Balance <> 0 then begin

                            if AccCredit.Balance <= 50000 then begin
                                Amt[1] := Amt[1] + AccCredit.Balance;
                                if AccCredit.Balance <> 0 then
                                    AccCount[1] := AccCount[1] + 1;
                            end;
                            if (AccCredit.Balance > 50000) and (AccCredit.Balance <= 100000) then begin
                                Amt[2] := Amt[2] + AccCredit.Balance;
                                if AccCredit.Balance <> 0 then
                                    AccCount[2] := AccCount[2] + 1;
                            end;

                            if (AccCredit.Balance > 100000) and (AccCredit.Balance <= 300000) then begin
                                Amt[3] := Amt[3] + AccCredit.Balance;
                                if AccCredit.Balance <> 0 then
                                    AccCount[3] := AccCount[3] + 1;
                            end;

                            if (AccCredit.Balance > 300000) and (AccCredit.Balance <= 1000000) then begin
                                Amt[4] := Amt[4] + AccCredit.Balance;
                                if AccCredit.Balance <> 0 then
                                    AccCount[4] := AccCount[4] + 1;
                            end;

                            if AccCredit.Balance > 1000000 then begin
                                Amt[5] := Amt[5] + AccCredit.Balance;
                                if AccCredit.Balance <> 0 then
                                    AccCount[5] := AccCount[5] + 1;

                            end;
                        end;
                    until AccCredit.Next() = 0;
                end;

                AccBanking.Reset();
                AccBanking.SetRange("Date Filter", 0D, EndDate);
                AccBanking.SetFilter("Product Type", 'IE-00109');
                if AccBanking.Find('-') then begin
                    repeat

                        AccBanking.CalcFields(Balance);
                        if AccBanking.Balance <= 50000 then begin
                            Amt[6] := Amt[6] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[6] := AccCount[6] + 1;

                        end;
                        if (AccBanking.Balance > 50000.00) and (AccBanking.Balance <= 100000.00) then begin
                            Amt[7] := Amt[7] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[7] := AccCount[7] + 1;

                        end;
                        if (AccBanking.Balance > 100000.00) and (AccBanking.Balance <= 300000.00) then begin
                            Amt[8] := Amt[8] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[8] := AccCount[8] + 1;

                        end;
                        if (AccBanking.Balance > 300000.00) and (AccBanking.Balance <= 1000000.00) then begin
                            Amt[9] := Amt[9] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[9] := AccCount[9] + 1;

                        end;
                        if AccBanking.Balance > 1000000.00 then begin
                            Amt[10] := Amt[10] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[10] := AccCount[10] + 1;

                        end;
                    until AccBanking.Next() = 0;
                end;



                AccBanking.Reset();
                AccBanking.SetRange("Date Filter", 0D, EndDate);
                AccBanking.SetRange("Product Type", 'MS-0010');
                if AccBanking.Find('-') then begin
                    repeat
                        AccBanking.CalcFields(Balance);
                        if AccBanking.Balance <= 50000 then begin
                            Amt[11] := Amt[11] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[11] := AccCount[11] + 1;
                        end;
                        if (AccBanking.Balance > 50000.00) and (AccBanking.Balance <= 100000.00) then begin
                            Amt[12] := Amt[12] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[12] := AccCount[12] + 1;
                        end;
                        if (AccBanking.Balance > 100000.00) and (AccBanking.Balance <= 300000.00) then begin
                            Amt[13] := Amt[13] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[13] := AccCount[13] + 1;
                        end;
                        if (AccBanking.Balance > 300000.00) and (AccBanking.Balance <= 1000000.00) then begin
                            Amt[14] := Amt[14] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[14] := AccCount[14] + 1;
                        end;
                        if AccBanking.Balance > 1000000.00 then begin
                            Amt[15] := Amt[15] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[15] := AccCount[15] + 1;

                        end;
                    until AccBanking.Next() = 0;
                end;
        AccBanking.Reset();
        AccBanking.SetRange("Date Filter", 0D, EndDate);
              AccBanking.SetRange("Product Type", 'HD-00108');
                if AccBanking.Find('-') then begin
                    repeat
                        AccBanking.CalcFields(Balance);
                        if AccBanking.Balance <= 50000 then begin
                            Amt[17] := Amt[17] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[17] := AccCount[17] + 1;
                        end;
                        if (AccBanking.Balance > 50000.00) and (AccBanking.Balance <= 100000.00) then begin
                            Amt[18] := Amt[18] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[18] := AccCount[18] + 1;
                        end;
                        if (AccBanking.Balance > 100000.00) and (AccBanking.Balance <= 300000.00) then begin
                            Amt[19] := Amt[19] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[19] := AccCount[19] + 1;
                        end;
                        if (AccBanking.Balance > 300000.00) and (AccBanking.Balance <= 1000000.00) then begin
                            Amt[20] := Amt[20] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[20] := AccCount[20] + 1;
                        end;
                        if AccBanking.Balance > 1000000.00 then begin
                            Amt[21] := Amt[21] + AccBanking.Balance;
                            if AccBanking.Balance <> 0 then
                                AccCount[21] := AccCount[21] + 1;

                        end;
                    until AccBanking.Next() = 0;
                end;



                Amt[16] := (Amt[1] + Amt[2] +
                Amt[3] + Amt[4] + Amt[5] +
                Amt[6] + Amt[7] + Amt[8] +
                Amt[9] + Amt[10] + Amt[11] + 
                Amt[12] + Amt[13] + Amt[14] + Amt[15]+
                Amt[17] + Amt[18] + Amt[19] + Amt[20] + Amt[21]);

                AccCount[16] := (AccCount[1] +
                AccCount[2] + AccCount[4] + AccCount[5] +
                AccCount[6] + AccCount[7] + AccCount[8] + AccCount[9] +
                AccCount[10] + AccCount[11] +AccCount[12] + AccCount[13] + AccCount[14] + AccCount[15]
                + AccCount[17] +AccCount[18] + AccCount[19] + AccCount[20] + AccCount[21]);

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
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
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
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        BalanceLCY: array[7] of Decimal;
        Amt: array[23] of Decimal;
        AccCount: array[23] of Integer;
        DFilter: Text[100];
        StartDate: Date;
        EndDate: Date;
        CompInfo: Record "Company Information";
        TempData: Record "Temp. Data (Reporting)";
}



