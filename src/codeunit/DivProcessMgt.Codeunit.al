namespace SaccoDB.SaccoDB;

codeunit 90012 "Div. Process Mgt."
{


    // Credit BOSA Accounts
    procedure fnCalcCustInterest(SavingsAcc: Record "Account Credit"; ProductType: Code[50]; HeaderNo: Code[50];
    InterestOptions: Enum "Rcv12 Dividend Interest Option"; OpeningDate: Date; ClosingDate: Date)

    begin
        StartDate := OpeningDate;
        EndDate := ClosingDate;
        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        IF ProductFactory.FindFirst() then begin

            AccBnkmgt.Reset();
            AccBnkmgt.SetRange(Processed, false);
            AccBnkmgt.SetRange("No.", SavingsAcc."No.");
            AccBnkmgt.SetRange("Product Type", ProductFactory."Product ID");
            if AccBnkmgt.FindFirst() then begin

                if CustMembr.Get(AccBnkmgt."Member No.") THEN
                    DivPayMode := CustMembr."Dividend Payment Method";

                CustMemberNo := SavingsAcc."Member No.";
                SavingsAcc := AccBnkmgt;
                YearDateFilter := '..' + FORMAT(EndDate);

                case ProductFactory."Dividend Calc. Method" OF
                    ProductFactory."Dividend Calc. Method"::"Flat Rate":
                        begin

                            DateFilter := '..' + Format(EndDate);
                            SavingsAcc.SetFilter(SavingsAcc."Date Filter", DateFilter);
                            SavingsAcc.CalcFields(SavingsAcc."Balance (LCY)");

                            GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)";
                            WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                            NetDiv := GrossDiv - WTaxDiv;

                            if GrossDiv <> 0 then
                                DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                     SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                             SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                             EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                             DivPayMode, HeaderNo, 1, EndDate, InterestOptions, SavingsAcc."Currency Code");
                        end;

                    ProductFactory."Dividend Calc. Method"::Prorated:
                        begin
                            MShares := 0;

                            FirstMonthDate := StartDate;
                            LastMonthDate := CalcDate('1M-1D', FirstMonthDate);
                            DateFilter := Format(FirstMonthDate) + '..' + Format(LastMonthDate);

                            SavingsAcc.Reset();
                            SavingsAcc.SetFilter("Date Filter", DateFilter);
                            SavingsAcc.CalcFields("Balance (LCY)");
                            MShares := SavingsAcc."Balance (LCY)";

                            if MShares < 0 then
                                MShares := 0;

                            FromDate := StartDate;
                            ToDate := CalcDate('1M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := '..' + Format(ToDate);

                                SavingsAcc.RESET;
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (12 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (12 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 3
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('1M', StartDate);
                            ToDate := CALCDATE('2M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (11 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (11 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 4
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                     SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                             SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                             EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                             DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");

                            end;

                            FromDate := CALCDATE('2M', StartDate);
                            ToDate := CALCDATE('3M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (10 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (10 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 5
                                if (GrossDiv <> 0) and (ToDate <= EndDate) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('3M', StartDate);
                            ToDate := CALCDATE('4M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (9 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (9 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 6
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                      SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                              SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                              EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                              DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('4M', StartDate);
                            ToDate := CALCDATE('5M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (8 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (8 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 7
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                   SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                           SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                           EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                           DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('5M', StartDate);
                            ToDate := CALCDATE('6M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (7 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (7 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 8
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('6M', StartDate);
                            ToDate := CALCDATE('7M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (6 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (6 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 9
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('7M', StartDate);
                            ToDate := CALCDATE('8M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (5 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (5 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 10
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('8M', StartDate);
                            ToDate := CALCDATE('9M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (4 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (4 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 11
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                     SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                             SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                             EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                             DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");

                            end;

                            FromDate := CALCDATE('9M', StartDate);
                            ToDate := CALCDATE('10M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (3 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (3 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                //Month 12
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('10M', StartDate);
                            ToDate := CALCDATE('11M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (2 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (2 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;
                            //NewMonth

                            FromDate := CALCDATE('11M', StartDate);
                            ToDate := CALCDATE('12M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (1 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (1 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;

                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;
                        end;
                end;
            end;
        end;
    end;

    // Banking Accounts
    procedure fnCalcCustAcInterest(SavingsAcc: Record "Account Banking";
    ProductType: Code[50]; HeaderNo: Code[50]; InterestOptions: Enum "Rcv12 Dividend Interest Option"; OpeningDate: Date; ClosingDate: Date)

    begin


        StartDate := OpeningDate;
        EndDate := ClosingDate;
        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        if ProductFactory.Find('-') then begin

            accmgt.Reset();
            accmgt.SetRange("No.", SavingsAcc."No.");
            accmgt.SetFilter(Status, '<>%1 & <>%2', accmgt.Status::Deceased, accmgt.Status::Withdrawn);
            accmgt.SetRange("Product Type", ProductFactory."Product ID");
            if accmgt.Find('-') then begin
                accmgt.CalcFields("Balance (LCY)");

                if CustMembr.Get(accmgt."Member No.") then
                    DivPayMode := CustMembr."Dividend Payment Method";

                CustMemberNo := SavingsAcc."Member No.";
                SavingsAcc := accmgt;
                YearDateFilter := '..' + Format(EndDate);

                case ProductFactory."Dividend Calc. Method" OF
                    ProductFactory."Dividend Calc. Method"::"Flat Rate":
                        begin

                            DateFilter := '..' + Format(EndDate);
                            SavingsAcc.SetFilter(SavingsAcc."Date Filter", DateFilter);
                            SavingsAcc.CalcFields(SavingsAcc."Balance (LCY)");
                            GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)";
                            WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                            NetDiv := GrossDiv - WTaxDiv;
                            if CustMembr.Get(accmgt."Member No.") then
                                DivPayMode := CustMembr."Dividend Payment Method";

                            if GrossDiv <> 0 then
                                DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, EndDate, InterestOptions, SavingsAcc."Currency Code");
                        end;

                    ProductFactory."Dividend Calc. Method"::Prorated:
                        begin
                            MShares := 0;

                            FirstMonthDate := StartDate;
                            LastMonthDate := CalcDate('1M-1D', FirstMonthDate);
                            DateFilter := Format(FirstMonthDate) + '..' + Format(LastMonthDate);

                            SavingsAcc.Reset();
                            SavingsAcc.SetFilter("Date Filter", DateFilter);
                            SavingsAcc.CalcFields("Balance (LCY)");
                            MShares := SavingsAcc."Balance (LCY)";

                            if MShares < 0 then
                                MShares := 0;

                            FromDate := StartDate;
                            ToDate := CalcDate('1M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := '..' + Format(ToDate);

                                SavingsAcc.RESET;
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (12 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (12 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                //Month 3
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                    SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                            SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                            EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                            DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('1M', StartDate);
                            ToDate := CALCDATE('2M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (11 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (11 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 4
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");

                            end;

                            FromDate := CALCDATE('2M', StartDate);
                            ToDate := CALCDATE('3M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (10 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (10 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 5
                                if (GrossDiv <> 0) and (ToDate <= EndDate) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                        DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('3M', StartDate);
                            ToDate := CALCDATE('4M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (9 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (9 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 6
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('4M', StartDate);
                            ToDate := CALCDATE('5M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (8 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (8 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 7
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                        DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('5M', StartDate);
                            ToDate := CALCDATE('6M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (7 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (7 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 8
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('6M', StartDate);
                            ToDate := CALCDATE('7M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (6 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (6 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 9
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                        DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('7M', StartDate);
                            ToDate := CALCDATE('8M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (5 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (5 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 10
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                  SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                          SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                          EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                          DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('8M', StartDate);
                            ToDate := CALCDATE('9M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (4 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (4 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 11
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                        DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('9M', StartDate);
                            ToDate := CALCDATE('10M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (3 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (3 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 12
                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                        DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;

                            FromDate := CALCDATE('10M', StartDate);
                            ToDate := CALCDATE('11M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (2 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (2 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;
                            //NewMonth

                            FromDate := CALCDATE('11M', StartDate);
                            ToDate := CALCDATE('12M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (1 / 12);
                                QualifyingAmount := (SavingsAcc."Balance (LCY)" * (1 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(accmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    DivPrgmgt.fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                 SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                         SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                         EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                         DivPayMode, HeaderNo, 1, ToDate, InterestOptions, SavingsAcc."Currency Code");
                            end;
                        end;
                end;

                //Withdrawn
                SavingsAcc.Reset();
                SavingsAcc.SetRange("No.", accmgt."No.");
                SavingsAcc.SetFilter("Date Filter", YearDateFilter);
                IF SavingsAcc.Find('-') then begin
                    SavingsAcc.CalcFields("Balance (LCY)");
                    if SavingsAcc."Balance (LCY)" < 0 then begin

                        DividendProgression.Reset();
                        DividendProgression.SetRange("Header No.", HeaderNo);
                        DividendProgression.SetRange("Account No", SavingsAcc."No.");
                        IF DividendProgression.Find('-') then
                            DividendProgression.DeleteAll();
                    end;
                end;
            end;
        end;
    end;


    var
        CustMemberNo: Code[100];
        MShares: Decimal;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        QualifyingAmount: Decimal;
        accmgt: Record "Account Banking";
        DividendProgression: Record "Dividend Progression";
        DividendSetUp: Record "Dividend SetUp";
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text[100];
        ProductFactory: Record "Product Factory";
        AccBnkmgt: Record "Account Credit";
        DivPayMode: Code[20];
        DividendInstructions: Record "Dividend Instructions - Member";
        Loans: Record Loans;
        YearDateFilter: Text[100];
        GrossAmount: Decimal;
        Regmgt: Codeunit "Register Management";
        GrossDiv: Decimal;
        WTaxDiv: Decimal;
        NetDiv: Decimal;
        FromDate: Date;
        ToDate: Date;
        ////////
        //////
        CustMembr: Record Member;
        GrossDividend: Decimal;
        DivPrgmgt: Codeunit "Dividend Process";
        BnkMngt: Codeunit "Banking Procedure Mngt.";

}
