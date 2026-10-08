codeunit 50043 "Dividend Process"
{

    trigger OnRun()
    begin
    end;

    var
        DividendProgression: Record "Dividend Progression";
        DividendSetUp: Record "Dividend SetUp";
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text[100];
        ProductFactory: Record "Product Factory";
        SavingsAccounts: Record "Account Credit";
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
        CustMembr: Record Member;
        GrossDividend: Decimal;
        BnkMngt: Codeunit "Banking Procedure Mngt.";

    procedure GetDividendSetup()
    begin
        DividendSetUp.Get();
        DividendSetUp.TestField(DividendSetUp."Start Date");
        DividendSetUp.TestField(DividendSetUp."End Date");
        StartDate := DividendSetUp."Start Date";
        EndDate := DividendSetUp."End Date";
    end;

    procedure GenerateDividendsOnallAccount(CustMemberNo: Code[100]; HeaderNo: Code[50]; ProductType: Code[20])
    var
        SavingsAcc: Record "Account Credit";

    begin
        GetDividendSetup();



        ProductFactory.RESET;
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        ProductFactory.SETFILTER(ProductFactory."Dividend Calc. Method", '<>%1', ProductFactory."Dividend Calc. Method"::" ");
        IF ProductFactory.FIND('-') then begin


            SavingsAccounts.RESET;
            SavingsAccounts.SETRANGE("Product Type", ProductFactory."Product ID");
            SavingsAccounts.SETRANGE("Member No.", CustMemberNo);
            IF SavingsAccounts.FIND('-') then begin
                repeat

                    SavingsAcc := SavingsAccounts;
                    YearDateFilter := '..' + FORMAT(EndDate);

                    CASE ProductFactory."Dividend Calc. Method" OF
                        ProductFactory."Dividend Calc. Method"::"Flat Rate":
                            BEGIN

                                DateFilter := '..' + FORMAT(EndDate);

                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.SETFILTER(SavingsAcc."Balance (LCY)", '>0');
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)";
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";


                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name",
                                SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    EndDate, StartDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, 0);
                            END;

                        ProductFactory."Dividend Calc. Method"::Prorated:
                            BEGIN

                                //Month 1
                                FromDate := StartDate;
                                YearDateFilter := '..' + FORMAT(EndDate);
                                ToDate := CALCDATE('-1D', StartDate);
                                DateFilter := '..' + FORMAT(CALCDATE('-1D', FromDate));
                                SavingsAcc.RESET;
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (12 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 2
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    CALCDATE('-1D', FromDate), CALCDATE('-1D', FromDate), ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (12 / 12));
                                FromDate := StartDate;
                                ToDate := CALCDATE('1M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.RESET;
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (11 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 3
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (11 / 12));
                                FromDate := CALCDATE('1M', StartDate);
                                ToDate := CALCDATE('2M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (10 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 4
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (10 / 12));
                                FromDate := CALCDATE('2M', StartDate);
                                ToDate := CALCDATE('3M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (9 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 5
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (9 / 12));
                                FromDate := CALCDATE('3M', StartDate);
                                ToDate := CALCDATE('4M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (8 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 6
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (8 / 12));
                                FromDate := CALCDATE('4M', StartDate);
                                ToDate := CALCDATE('5M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (7 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";
                                //Month 7

                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (7 / 12));
                                FromDate := CALCDATE('5M', StartDate);
                                ToDate := CALCDATE('6M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (6 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";
                                //Month 8

                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (6 / 12));
                                FromDate := CALCDATE('6M', StartDate);
                                ToDate := CALCDATE('7M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (5 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 9
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (5 / 12));
                                FromDate := CALCDATE('7M', StartDate);
                                ToDate := CALCDATE('8M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (4 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 10
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (4 / 12));
                                FromDate := CALCDATE('8M', StartDate);
                                ToDate := CALCDATE('9M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (3 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";
                                //Month 11

                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (3 / 12));
                                FromDate := CALCDATE('9M', StartDate);
                                ToDate := CALCDATE('10M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (2 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";
                                //Month 12

                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (2 / 12));
                                FromDate := CALCDATE('10M', StartDate);
                                ToDate := CALCDATE('11M-1D', StartDate);
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (1 / 12);
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (1 / 12));


                            END;
                    END;

                    //Withdrawn
                    SavingsAcc.Reset();
                    SavingsAcc.SetFilter("Date Filter", YearDateFilter);
                    SavingsAcc.SetFilter("Balance (LCY)", '<=0');
                    SavingsAcc.CalcFields("Balance (LCY)");
                    IF SavingsAcc.Find('-') then begin
                        DividendProgression.Reset();
                        DividendProgression.SetRange("Account No", SavingsAcc."No.");
                        DividendProgression.SetRange("Processing Date", Today);
                        IF DividendProgression.Find('-') then
                            DividendProgression.DeleteAll();
                    END;

                UNTIL SavingsAccounts.NEXT = 0;
            END;

        END;
    end;

    procedure GenerateDividendsOnLoanAccount(CustMemberNo: Code[100]; HeaderNo: Code[50]; ProductType: Code[20])
    var
        SavingsAcc: Record "Account Credit";

    begin
        GetDividendSetup();
        DividendProgression.Reset();
        DividendProgression.SetRange("Member No", CustMemberNo);
        if DividendProgression.Find('-') then
            DividendProgression.DeleteAll();

        ProductFactory.Reset();
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        IF ProductFactory.Find('-') then begin
            repeat

                SavingsAccounts.RESET;
                SavingsAccounts.SETRANGE("Product Type", ProductFactory."Product ID");
                SavingsAccounts.SETRANGE("Member No.", CustMemberNo);
                IF SavingsAccounts.FIND('-') then begin
                    repeat

                        SavingsAcc := SavingsAccounts;
                        YearDateFilter := '..' + FORMAT(EndDate);

                        CASE ProductFactory."Dividend Calc. Method" OF
                            ProductFactory."Dividend Calc. Method"::"Flat Rate":
                                BEGIN

                                    DateFilter := '..' + FORMAT(EndDate);

                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.SETFILTER(SavingsAcc."Balance (LCY)", '>0');
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)";
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 1
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, 0);
                                END;

                            ProductFactory."Dividend Calc. Method"::Prorated:
                                BEGIN
                                    FromDate := StartDate;
                                    YearDateFilter := '..' + FORMAT(EndDate);
                                    ToDate := CALCDATE('-1D', StartDate);
                                    DateFilter := '..' + FORMAT(CALCDATE('-1D', FromDate));
                                    SavingsAcc.RESET;
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (12 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 2
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        CALCDATE('-1D', FromDate), CALCDATE('-1D', FromDate), ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (12 / 12));
                                    FromDate := StartDate;
                                    ToDate := CALCDATE('1M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.RESET;
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (11 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 3
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (11 / 12));
                                    FromDate := CALCDATE('1M', StartDate);
                                    ToDate := CALCDATE('2M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (10 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 4
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (10 / 12));
                                    FromDate := CALCDATE('2M', StartDate);
                                    ToDate := CALCDATE('3M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (9 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 5
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (9 / 12));
                                    FromDate := CALCDATE('3M', StartDate);
                                    ToDate := CALCDATE('4M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (8 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 6
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (8 / 12));
                                    FromDate := CALCDATE('4M', StartDate);
                                    ToDate := CALCDATE('5M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (7 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";
                                    //Month 7

                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (7 / 12));
                                    FromDate := CALCDATE('5M', StartDate);
                                    ToDate := CALCDATE('6M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (6 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";
                                    //Month 8

                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (6 / 12));
                                    FromDate := CALCDATE('6M', StartDate);
                                    ToDate := CALCDATE('7M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (5 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 9
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (5 / 12));
                                    FromDate := CALCDATE('7M', StartDate);
                                    ToDate := CALCDATE('8M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (4 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    //Month 10
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (4 / 12));
                                    FromDate := CALCDATE('8M', StartDate);
                                    ToDate := CALCDATE('9M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (3 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";
                                    //Month 11

                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (3 / 12));
                                    FromDate := CALCDATE('9M', StartDate);
                                    ToDate := CALCDATE('10M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (2 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";
                                    //Month 12

                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (2 / 12));
                                    FromDate := CALCDATE('10M', StartDate);
                                    ToDate := CALCDATE('11M-1D', StartDate);
                                    DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                    SavingsAcc.SETFILTER(SavingsAcc."Date Filter", DateFilter);
                                    SavingsAcc.CALCFIELDS(SavingsAcc."Balance (LCY)");
                                    GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)") * (1 / 12);
                                    WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                    NetDiv := GrossDiv - WTaxDiv;
                                    IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                        DivPayMode := CustMembr."Dividend Payment Method";

                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (1 / 12));


                                END;
                        END;

                        //Withdrawn
                        SavingsAcc.Reset();
                        SavingsAcc.SetFilter("Date Filter", YearDateFilter);
                        SavingsAcc.SetFilter("Balance (LCY)", '<=0');
                        SavingsAcc.CalcFields("Balance (LCY)");
                        IF SavingsAcc.Find('-') then begin
                            DividendProgression.Reset();
                            DividendProgression.SetRange("Account No", SavingsAcc."No.");
                            DividendProgression.SetRange("Processing Date", Today);
                            IF DividendProgression.Find('-') then
                                DividendProgression.DeleteAll();
                        END;

                    UNTIL SavingsAccounts.NEXT = 0;
                END;
            UNTIL ProductFactory.NEXT = 0;
        END;
    end;



    procedure fnCalculateCustDivdends(SavingsAcc: Record "Account Credit"; ProductType: Code[50]; HeaderNo: Code[50])
    var
        CustMemberNo: Code[100];
        DividendSimulationHeader: Record "Dividend Simulation Header";
        MShares: Decimal;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        QualifyingAmount: Decimal;
    begin

        DividendSimulationHeader.Get(HeaderNo);
        StartDate := DividendSimulationHeader."Start Date";
        EndDate := DividendSimulationHeader."End Date";
        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        IF ProductFactory.Find('-') then begin

            SavingsAccounts.Reset();
            SavingsAccounts.SetRange(Processed, false);
            SavingsAccounts.SetRange("No.", SavingsAcc."No.");
            SavingsAccounts.SetRange("Product Type", ProductFactory."Product ID");
            if SavingsAccounts.Find('-') then begin

                CustMemberNo := SavingsAcc."Member No.";
                SavingsAcc := SavingsAccounts;
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
                            if CustMembr.GET(SavingsAccounts."Member No.") THEN
                                DivPayMode := CustMembr."Dividend Payment Method";

                            if GrossDiv <> 0 then
                                CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                    SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    EndDate, StartDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, 0);

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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 3
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type",
                                    SavingsAcc."Product Name", SavingsAcc."Member No.",
                                    QualifyingAmount, MShares, GrossDiv, WTaxDiv, NetDiv, ToDate, FromDate,
                                    ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (12 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 4
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (11 / 12));

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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 5
                                if (GrossDiv <> 0) and (ToDate <= EndDate) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (10 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 6
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (9 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 7
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                       QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (8 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 8
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (7 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 9
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (6 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 10
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (5 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 11
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (4 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 12
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (3 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (2 / 12));
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (1 / 12));
                            end;
                        end;
                end;

                //Withdrawn

                /* SavingsAcc.Reset();
                SavingsAcc.SetFilter("Date Filter", YearDateFilter);
                SavingsAcc.SetFilter("Balance (LCY)", '<=0');
                SavingsAcc.CalcFields("Balance (LCY)");
                IF SavingsAcc.Find('-') then begin
                    DividendProgression.Reset();
                    DividendProgression.SetRange("Account No", SavingsAcc."No.");
                    DividendProgression.SetRange("Processing Date", Today);
                    IF DividendProgression.Find('-') then
                        DividendProgression.DeleteAll();
                end; */

            end;
        end;
    end;


    ///Hapa

    procedure fnCalculateCustAcInterest(SavingsAcc: Record "Account Banking"; ProductType: Code[50]; HeaderNo: Code[50])
    var
        CustMemberNo: Code[100];
        DividendSimulationHeader: Record "Dividend Simulation Header";
        MShares: Decimal;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        QualifyingAmount: Decimal;
        AccountBnk: Record "Account Banking";
    begin

        DividendSimulationHeader.Get(HeaderNo);
        StartDate := DividendSimulationHeader."Start Date";
        EndDate := DividendSimulationHeader."End Date";
        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        if ProductFactory.Find('-') then begin

            AccountBnk.Reset();
            AccountBnk.SetRange("No.", SavingsAcc."No.");
            AccountBnk.SetFilter(Status, '<>%1 & <>%2', AccountBnk.Status::Deceased, AccountBnk.Status::Withdrawn);
            AccountBnk.SetRange("Product Type", ProductFactory."Product ID");
            if AccountBnk.Find('-') then begin
                AccountBnk.CalcFields("Balance (LCY)");

                CustMemberNo := SavingsAcc."Member No.";
                SavingsAcc := AccountBnk;
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
                            if CustMembr.Get(AccountBnk."Member No.") then
                                DivPayMode := CustMembr."Dividend Payment Method";

                            if GrossDiv <> 0 then
                                CreateDividendLines(SavingsAcc."No.", Today, SavingsAcc."Product Type",
                                SavingsAcc."Product Name", SavingsAcc."Member No.", SavingsAcc."Balance (LCY)",
                                                    SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                    EndDate, StartDate, ProductFactory."Dividend Calc. Method",
                                                    DivPayMode, HeaderNo, 0);
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 3
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type",
                                    SavingsAcc."Product Name", SavingsAcc."Member No.",
                                    QualifyingAmount, MShares, GrossDiv, WTaxDiv, NetDiv, ToDate, FromDate,
                                    ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (12 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 4
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (11 / 12));

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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 5
                                if (GrossDiv <> 0) and (ToDate <= EndDate) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (10 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 6
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (9 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 7
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                       QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (8 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 8
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (7 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 9
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (6 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 10
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (5 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 11
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (4 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 12
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (3 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (2 / 12));
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
                                IF CustMembr.GET(AccountBnk."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, (1 / 12));
                            end;
                        end;
                end;

                //Withdrawn
                SavingsAcc.Reset();
                SavingsAcc.SetRange("No.", AccountBnk."No.");
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

    procedure CreateDividendLines(AccountNo: Code[100]; ProcessingDate: Date; ProductID: Code[20]; ProductName: Text[150]; MemberNo: Code[100]; QualifyingShares: Decimal; DivShares: Decimal; GrossDiv: Decimal; DivWHoldingTax: Decimal; NetDiv: Decimal; DivEndDate: Date; DivStartDate: Date; DivCalcMethod: Enum DividendMethod; PayMode: Code[20]; HeaderNo: Code[50]; Factor: Decimal)
    begin

        DividendProgression.Init();
        DividendProgression."Entry No." := DividendProgression.GetNextEntryNo();
        DividendProgression.Validate("Account No", AccountNo);
        DividendProgression."Processing Date" := ProcessingDate;
        DividendProgression.Validate("Product Type", ProductID);
        DividendProgression."Product Name" := ProductName;
        DividendProgression.Validate("Member No", MemberNo);
        DividendProgression."Qualifying Shares" := QualifyingShares;
        DividendProgression.Shares := DivShares;
        DividendProgression."Gross Dividends" := GrossDiv;
        DividendProgression."Witholding Tax" := DivWHoldingTax;
        DividendProgression."Net Dividends" := NetDiv;
        DividendProgression."Start Date" := DivStartDate;
        DividendProgression."End Date" := DivEndDate;
        DividendProgression."Dividend Calc. Method" := DivCalcMethod;
        DividendProgression."Payment Mode" := PayMode;
        DividendProgression."Weighted Factor" := Factor;
        DividendProgression."Header No." := HeaderNo;
        DividendProgression.Insert(true);
    end;

    procedure PerformPostOnDividends(SimDivHeader: Record "Dividend Simulation Header")
    var
        SavingsAcc: Record "Account Banking";
        DividendLine: Record "Dividend Progression";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
        Temp."Periodic Journal Batch");

        DividendLine.Reset();
        DividendLine.SetRange(Posted, false);
        DividendLine.SetFilter("Gross Dividends", '>0');
        DividendLine.SetRange("Header No.", SimDivHeader."No.");
        if DividendLine.FindSet() then begin
            repeat
                SavingsAcc.Reset();
                SavingsAcc.SetRange("Member No.", DividendLine."Member No");
                SavingsAcc.SetRange("Account Category", SavingsAcc."Account Category"::Savings);
                if SavingsAcc.FindFirst() then begin

                    /*  BnkMngt.InitPost(SavingsAcc,DividendLine."End Date",0,
                     DividendLine."Gross Dividends",
                     DividendLine."Product Name",
                     SimDivHeader."No.",DividendLine."Product Type"); */
                end;
            until DividendLine.Next() = 0;
        end;
    end;

    procedure generateInterestOnBankingAccount(Vendor: Record "Account Banking"; IntDays: Integer; StartDate: Date; PostInt: Integer; Descript: Text[150])
    var
        GenJournalLine: Record "Gen. Journal Line";
        Account: Record "Account Banking";
        AccountType: Record "Product Factory";
        LineNo: Integer;
        IntRate: Decimal;
        DocNo: Code[10];
        PDate: Date;
        IntBufferNo: Integer;
        MidMonthFactor: Decimal;
        DaysInMonth: Integer;

        AsAt: Date;
        MinBal: Boolean;
        AccruedInt: Decimal;
        RIntDays: Integer;
        Bal: Decimal;
        DFilter: Text[50];
        Dfilter2: Date;
        Dfilter3: Text[30];
        LowestBal: Decimal;
        BalStarting: Decimal;
        Withholdingtax: Decimal;
        InterestBand: Record "Interest Rates Banding";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        GenJournaline: Record "Gen. Journal Line";
        JTemplate: code[20];
        JBatch: Code[20];
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        InterestEntry: Record "Interest Line";
        SavingsBuffer: Record "Savings Interest Buffer";
    begin
        IntRate := 0;
        AccruedInt := 0;
        MidMonthFactor := 1;
        MinBal := false;
        RIntDays := IntDays;
        AsAt := StartDate;
        LowestBal := 0;
        Bal := 0;
        BalStarting := 0;
        Withholdingtax := 0;

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
        Temp."Periodic Journal Batch");

        JTemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        if AccountType.GET(Vendor."Product Type") then begin
            AccountType.TestField("Interest Calc Min Balance");
            AccountType.TestField("Earns Interest", true);

            if AccountType."Earns Interest" then begin
                repeat
                    DFilter := '01.01.06..' + Format(StartDate);

                    Account.Reset();
                    Account.SetRange(Account."No.", Vendor."No.");
                    Account.SetRange(Blocked, Account.Blocked::" ");
                    Account.SetFilter(Account."Date Filter", DFilter);
                    Account.SetFilter("Account Category", '<>%1', Account."Account Category"::"Certificates of Deposit");
                    if Account.Find('-') then begin
                        Account.CalcFields(Balance, Account."Balance (LCY)", "Untranferred Interest");
                        Bal := Account."Balance (LCY)";
                        if Account."Balance (LCY)" >= AccountType."Interest Calc Min Balance" then begin
                            AccountType.TestField(AccountType."Interest Rate (Max.)");
                            IntRate := AccountType."Interest Rate (Max.)";
                            if LowestBal = 0 then
                                LowestBal := Account."Balance (LCY)";

                            if LowestBal > Account."Balance (LCY)" then
                                LowestBal := Account."Balance (LCY)"
                        end else begin
                            MinBal := true;
                        end;
                    end;

                    RIntDays := RIntDays - 1;
                    AsAt := CalcDate('1D', AsAt);
                    StartDate := StartDate + 1;
                until RIntDays = 0;
                AccruedInt := Round((LowestBal - AccountType."Interest Calc Min Balance") * (IntRate / 1200), 0.1, '<');
            end;

            if MinBal = true then
                AccruedInt := 0;
            if AccruedInt > 0 then begin
                Message('%1', AccruedInt);

                if PostInt = 1 then begin

                    GenJournaline.LockTable();
                    LineNo := LineNo + 1000;
                    GenJournaline."Line No." := LineNo;
                    TellerMngt.InitializeEntry(GenJournaline, LineNo,
                    Jtemplate, Jbatch, Account."No.", '', Today,
                    Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code");
                    GenJournaline."External Document No." := Account."Member No.";
                    GenJournaline.Description := 'A/c Interest - ' + FORMAT(Account."Product Name", 0,
                    ' <Day,2>-<Month Text,3>-<Year4> ');
                    GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                    GenJournaline.Validate("Account No.", Account."No.");
                    GenJournaline.Validate(Amount, Account."Untranferred Interest" * -1);
                    GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                    GenJournaline.Validate("Bal. Account No.", AccountType."Interest Payable Account");
                    if GenJournaline.Amount <> 0 then
                        GenJournaline.Insert(true);

                    //Withholding tax
                    GenJournaline.LockTable();
                    LineNo := LineNo + 1000;
                    GenJournaline."Line No." := LineNo;
                    TellerMngt.InitializeEntry(GenJournaline, LineNo,
                    Jtemplate, Jbatch, Account."No.", '', Today,
                    Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code");
                    GenJournaline."External Document No." := Account."Member No.";
                    GenJournaline.Description := 'Withholding Tax on - ' + Account."No.";
                    GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                    GenJournaline.Validate("Account No.", Account."No.");
                    GenJournaline.Validate(Amount, Account."Untranferred Interest" * (AccountType."WithHolding Tax" / 100));
                    GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                    GenJournaline.Validate("Bal. Account No.", AccountType."Withholding Tax Account");
                    if GenJournaline.Amount <> 0 then
                        GenJournaline.Insert(true);
                end;
                InterestEntry.LockTable();
                InterestEntry.Init();
                InterestEntry.No := DocNo;
                InterestEntry."Account No" := Account."No.";
                InterestBand."Product ID" := Account."Product Type";
                InterestEntry."Interest Date" := Today;
                InterestEntry.Description := Descript;
                InterestEntry.Amount := AccruedInt;
                InterestEntry."Interest Bills" := AccruedInt;
                if ProductFactory.Get(Account."Product Type") then
                    InterestEntry."Bal. Account No." := ProductFactory."Interest Payable Account";
                InterestEntry.Insert(true);

                Regmgt.CreateIntBufferEntry(Account."No.", Account."Product Type", Today, AccruedInt, Today)
            end;
        end;
    end;

    procedure generateAccountInterestTiered(Vendor: Record "Account Banking"; IntDays: Integer; StartDate: Date; PostInt: Integer; DocNo: Code[50]; Descript: Text[150])
    var
        GenJournalLine: Record "Gen. Journal Line";
        Account: Record "Account Banking";
        AccountType: Record "Product Factory";
        LineNo: Integer;
        IntRate: Decimal;
        PDate: Date;
        IntBufferNo: Integer;
        MidMonthFactor: Decimal;
        DaysInMonth: Integer;
        AsAt: Date;
        MinBal: Boolean;
        AccruedInt: Decimal;
        RIntDays: Integer;
        Bal: Decimal;
        DFilter: Text[50];
        PostStart: Date;
        PostEnd: Date;
        DBalance: Decimal;
        Nointerest: Boolean;
        Withholdingtax: Decimal;
        InterestBand: Record "Interest Rates Banding";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        GenJournaline: Record "Gen. Journal Line";
        JTemplate: code[20];
        JBatch: Code[20];
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        InterestEntry: Record "Interest Line";
        SavingsBuffer: Record "Savings Interest Buffer";
        NoOfDaysInMonth: Integer;
        MonthNumber: Integer;
        YearNumber: Integer;
        MonthTexts: Text;
        DateMngt: Codeunit "Date Conversion";
        Amt: array[5] of Decimal;
        RegMngt: Codeunit "Register Management";
    begin
        IntRate := 0;
        AccruedInt := 0;
        MidMonthFactor := 1;
        MinBal := false;
        RIntDays := IntDays;
        AsAt := StartDate;
        Nointerest := false;
        Withholdingtax := 0;
        DBalance := 0;
        IntRate := 0;
        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;

        AsAt := AsAt - 1;
        MonthTexts := FORMAT(StartDate, 0, '<Month Text,3> ');
        MonthNumber := Date2DMY(StartDate, 2);
        YearNumber := Date2DMY(StartDate, 3);

        NoOfDaysInMonth := DateMngt.DetermineDaysInMonth(MonthNumber, YearNumber);

        if AccountType.Get(Vendor."Product Type") then begin
            AccountType.TestField("Interest Expense Account");
            AccountType.TestField("Interest Payable Account");
            if AccountType."Earns Interest" = true then begin

                repeat
                    RIntDays := RIntDays - 1;
                    AsAt := AsAt + 1;
                    DFilter := '01/01/06..' + Format(AsAt);
                    Account.Reset();
                    Account.SetRange(Account."No.", Vendor."No.");
                    Account.SetFilter(Account."Date Filter", DFilter);
                    Account.SetFilter(Account."Account Category", '<>%1', Account."Account Category"::"Certificates of Deposit");
                    IF Account.Find('-') then begin
                        Account.CalcFields(Account."Balance (LCY)", Account."Untranferred Interest");

                        Bal := 0;
                        Bal := Account."Balance (LCY)";
                        DBalance := 0;
                        if Bal >= AccountType."Interest Calc Min Balance" then begin

                            InterestBand.Reset();
                            InterestBand.SetRange("Product ID", Account."Product Type");
                            if InterestBand.FindSet() then begin
                                repeat
                                    if (Bal >= InterestBand."Min. Limit") and (Bal <= InterestBand."Max. Limit") then begin
                                        Amt[1] := (InterestBand."Interest Rate" / 1200);
                                        Amt[2] := (Amt[1] / NoOfDaysInMonth);
                                        DBalance := (Bal * Amt[2]);
                                        IntRate := InterestBand."Interest Rate";
                                        Amt[3] := Amt[3] + DBalance;
                                    end;
                                until InterestBand.Next() = 0;
                            end;
                            Nointerest := false;
                        end else begin
                            Nointerest := true;
                        end;
                    end;
                    if Nointerest = true then exit;

                    if not Nointerest then begin

                        Regmgt.CreateMonthlyAccruedInt(DocNo, Account."No.",
                        Account.Name, Bal, IntRate, AsAt, Account."Product Type", Descript, Amt[3],
                        AccountType."Interest Payable Account", AccountType."Interest Expense Account");
                    end;
                until RIntDays = 0;
                AccruedInt := Amt[3];

                IF Nointerest = true then begin
                    AccruedInt := 0;
                end;

                if AccruedInt > 0 then begin
                    if ProductFactory.Get(Account."Product Type") then
                        Regmgt.CreateLines(DocNo, Account."No.", Account."Product Type", Descript,
                        AccruedInt, ProductFactory."Interest Payable Account");
                    Regmgt.CreateIntBufferEntry(Account."No.", Account."Product Type", Today, AccruedInt, Today)
                end;
            end;
        end;
    end;

    procedure InitializePostOnInterest(PurchHeader: Record "Savings Interest Header"; PostDate: Date; PostInt: Integer; Descript: Text[150])
    var
        GenJournalLine: Record "Gen. Journal Line";
        Account: Record "Account Banking";
        AccountType: Record "Product Factory";
        LineNo: Integer;
        IntRate: Decimal;
        PDate: Date;
        IntBufferNo: Integer;
        Vendor: Record "Account Banking";
        MidMonthFactor: Decimal;
        DaysInMonth: Integer;
        AsAt: Date;
        MinBal: Boolean;
        AccruedInt: Decimal;
        RIntDays: Integer;
        Bal: Decimal;
        DFilter: Text[50];
        PostStart: Date;
        PostEnd: Date;
        DBalance: Decimal;
        Nointerest: Boolean;
        Withholdingtax: Decimal;
        InterestBand: Record "Interest Rates Banding";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        GenJournaline: Record "Gen. Journal Line";
        JTemplate: code[20];
        JBatch: Code[20];
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        InterestEntry: Record "Interest Buffer";
        SavingsBuffer: Record "Savings Interest Buffer";
        NoOfDaysInMonth: Integer;
        MonthNumber: Integer;
        YearNumber: Integer;
        MonthTexts: Text;
        DateMngt: Codeunit "Date Conversion";
        Amt: array[5] of Decimal;
        PurchLine: Record "Interest Line";
        PostedPurch: Record "Savings Interest Header";
        VendAc: Record Vendor;
        RegisterManagement: Codeunit "Register Management";
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        JTemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";
        PurchHeader.TestField("Posting Date");

        PurchLine.Reset();
        PurchLine.SetRange(No, PurchHeader."No.");
        PurchLine.SetRange(Posted, false);
        PurchLine.SetFilter(Amount, '>0');
        if PurchLine.Find('-') then begin
            repeat

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

                Account.Reset;
                Account.SetRange("No.", PurchLine."Account No");
                Account.SetRange(Blocked, Account.Blocked::" ");
                if Account.Find('-') then begin
                    if AccountType.Get(Account."Product Type") then begin

                        VendAc.Reset();
                        VendAc.SetRange("No.", Account."No.");
                        if not VendAc.FindFirst() then begin
                            RegisterManagement.fnCreateVendorPostAc(Account."No.",
                                                    Account.Name, Account."Mobile No.", Account."Global Dimension 1 Code",
                                                    Account."Global Dimension 2 Code", Account."Customer Posting Group",
                                                    Account."E-Mail", Account.Status, Account."Product Type",
                                                    Account."ID/Passport No.", Account."Member No.", Account."Account Category");

                        end;

                        GenJournaline.LockTable();

                        LineNo := LineNo + 1000;
                        GenJournaline."Line No." := LineNo;
                        TellerMngt.fnInitializeEntries(GenJournaline, LineNo,
                        Jtemplate, Jbatch, PurchHeader."No.", '', PurchHeader."Posting Date",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", PurchHeader."Posting Date");
                        GenJournaline."External Document No." := Account."Member No.";
                        GenJournaline.Description := CopyStr('Gross Interest Paid To A/c No' + ' [ ' + Account."No." + ' ] ' + Format(PurchHeader."Posting Date", 0, '<Month Text>'), 1, 100);
                        GenJournaline."Account Type" := GenJournaline."Account Type"::"G/L Account";
                        GenJournalLine."Account No." := AccountType."Interest Expense Account";
                        GenJournaline.Validate("Account No.", AccountType."Interest Expense Account");
                        GenJournaline.Validate(Amount, PurchLine.Amount);

                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);

                        LineNo := LineNo + 1000;
                        GenJournaline."Line No." := LineNo;
                        TellerMngt.fnInitializeEntries(GenJournaline, LineNo,
                        Jtemplate, Jbatch, PurchHeader."No.", '', PurchHeader."Posting Date",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", PurchHeader."Posting Date");
                        GenJournaline."External Document No." := Account."Member No.";
                        GenJournaline.Description := CopyStr('Gross Interest transfered To A/c No' + ' [ ' + Account."No." + ' ] ' + Format(PurchHeader."Posting Date", 0, '<Month Text>'), 1, 100);
                        GenJournaline."Account Type" := GenJournaline."Account Type"::"G/L Account";
                        GenJournalLine."Account No." := AccountType."Interest Payable Account";
                        GenJournaline.Validate("Account No.", AccountType."Interest Payable Account");
                        GenJournaline.Validate(Amount, PurchLine.Amount * -1);
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);

                        LineNo := LineNo + 1000;
                        GenJournaline."Line No." := LineNo;
                        TellerMngt.fnInitializeEntries(GenJournaline, LineNo,
                        Jtemplate, Jbatch, PurchHeader."No.", '', PurchHeader."Posting Date",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", PurchHeader."Posting Date");
                        GenJournaline."External Document No." := Account."Member No.";
                        GenJournaline.Description := CopyStr('Interest earned' + '-' + Format(PurchHeader."Posting Date", 0, '<Month Text>'), 1, 100);
                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                        GenJournaline.Validate("Account No.", Account."No.");
                        GenJournaline.Validate(Amount, PurchLine.Amount * -1);
                        GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                        GenJournaline.Validate("Bal. Account No.", AccountType."Interest Payable Account");
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);

                        //Withholding tax

                        LineNo := LineNo + 1000;
                        GenJournaline."Line No." := LineNo;
                        TellerMngt.fnInitializeEntries(GenJournaline, LineNo,
                        Jtemplate, Jbatch, PurchHeader."No.", '', PurchHeader."Posting Date",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", PurchHeader."Posting Date");
                        GenJournaline."External Document No." := Account."Member No.";
                        GenJournaline.Description := 'Withholding Tax on Interest- ' + Account."No.";
                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                        GenJournaline.Validate("Account No.", Account."No.");
                        GenJournaline.Validate(Amount, PurchLine.Amount * (AccountType."WithHolding Tax" / 100));
                        GenJournaline.Validate("Bal. Account No.", AccountType."Withholding Tax Account");
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);
                        if PostInt = 1 then begin

                            //ToUncomment
                            JnlPostMngt.CompletePosting(JTemplate, JBatch);
                            Commit();
                            PurchLine.Posted := true;
                            PurchLine."Date Posted" := Today;
                            PurchLine."Time Posted" := Time;
                            PurchLine.Modify(true);

                            InterestEntry.Reset();
                            InterestEntry.SetRange("Account No", PurchLine."Account No");
                            InterestEntry.SetRange("Product Type", PurchLine."Product Type");
                            if InterestEntry.FindSet() then begin
                                InterestEntry.ModifyAll(Transferred, true);
                            end;
                        end;
                    end;
                end;
            until PurchLine.Next() = 0;
            PostedPurch.Reset();
            PostedPurch.SetRange("No.", PurchHeader."No.");
            if PostedPurch.FindFirst() then begin
                PostedPurch.Posted := true;
                PostedPurch."Date Posted" := Today;
                PostedPurch.Status := PostedPurch.Status::Approved;
                PostedPurch.Modify(true)
            end;
        end;

    end;

    procedure fngetIndividualCustDiv(CustomerNo: Code[100]; ValuePost: Integer; StartDate: Date; EndDate: Date; InterestOptions: Enum "Rcv12 Dividend Interest Option")
    var
        AccountCredits: Record "Account Credit";
        acmgt: Record "Account Banking";
        Divprogression: Record "Dividend Progression";
        DivProgressionslip: Report "Dividend Slip Portal";
        DivproMgt: Codeunit "Div. Process Mgt.";
        Accounttype: Record "Product Factory";

    begin

        DividendSetUp.Get();
        DividendSetUp.TestField("Start Date");
        DividendSetUp.TestField("End Date");

        DividendProgression.Reset();
        DividendProgression.SetRange("Member No", CustomerNo);
        DividendProgression.SetRange("Header No.", 'ALTC/' + Format(StartDate));
        DividendProgression.DeleteAll();

        AccountCredits.Reset();
        AccountCredits.SetRange("Member No.", CustomerNo);
        AccountCredits.SetRange("Account Category", AccountCredits."Account Category"::"Shares Capital");
        if AccountCredits.FindFirst() then begin
            Accounttype.Get(AccountCredits."Product Type");
            if Accounttype."Earns Interest" then
                generateDividentMgt(AccountCredits, AccountCredits."Product Type", 'ALTC/' + Format(StartDate), StartDate, EndDate);
        end;

        AccountCredits.Reset();
        AccountCredits.SetRange("Member No.", CustomerNo);
        AccountCredits.SetRange("Account Category", AccountCredits."Account Category"::"Shares Deposit");
        if AccountCredits.FindFirst() then begin
            case InterestOptions of
                InterestOptions::"Daily Basis":
                    begin
                        Accounttype.Get(AccountCredits."Product Type");
                        if Accounttype."Earns Interest" then
                            generateDividendInterest(AccountCredits, AccountCredits."Product Type", 'ALTC/' + Format(StartDate), StartDate, EndDate);
                    end;
                InterestOptions::"Monthly Accrual":
                    begin
                        Accounttype.Get(AccountCredits."Product Type");
                        if Accounttype."Earns Interest" then
                            DivproMgt.fnCalcCustInterest(AccountCredits, AccountCredits."Product Type", 'ALTC/' + Format(StartDate), InterestOptions, StartDate, EndDate);
                    end;
                InterestOptions::" ":
                    Error('Case Option not implemented');
            end;
        end;

        acmgt.Reset();
        acmgt.SetRange("Member No.", CustomerNo);
        acmgt.SetRange("Account Category", acmgt."Account Category"::"Money Market");
        if acmgt.FindFirst() then begin
            case InterestOptions of
                InterestOptions::"Monthly Accrual":
                    begin
                        Accounttype.Get(acmgt."Product Type");
                        if Accounttype."Earns Interest" then
                            DivproMgt.fnCalcCustAcInterest(acmgt, acmgt."Product Type",
                            'ALTC/' + Format(StartDate), InterestOptions, StartDate, EndDate);
                    end;
                InterestOptions::" ":
                    Error('Case Option not implemented');
            end;
        end;

        case ValuePost of
            1:
                begin

                    Commit();
                    Divprogression.SetFilter("Member No", CustomerNo);
                    Divprogression.SetRange("Header No.", 'ALTC/' + Format(StartDate));
                    DivProgressionslip.SetTableView(Divprogression);
                    DivProgressionslip.Run();
                end;
        end;
    end;

    procedure generateDividentMgt(SavingsAcc: Record "Account Credit"; ProductType: Code[50]; HeaderNo: Code[50]; OpeningDate: Date; ClosingDate: Date)
    var
        CustMemberNo: Code[100];
        DividendSimulationHeader: Record "Dividend Simulation Header";
        MShares: Decimal;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        InterestOptions: Enum "Rcv12 Dividend Interest Option";
    begin

        GetDividendSetup();
        DividendSetUp.Get();
        DividendSetUp.TestField("Start Date");
        DividendSetUp.TestField("End Date");
        InterestOptions := InterestOptions::"Daily Basis";

        StartDate := OpeningDate;
        EndDate := ClosingDate;

        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        IF ProductFactory.Find('-') then begin

            SavingsAccounts.Reset();
            SavingsAcc.SetRange(Processed, false);
            SavingsAccounts.SetRange("No.", SavingsAcc."No.");
            SavingsAccounts.SetRange("Product Type", ProductFactory."Product ID");
            if SavingsAccounts.Find('-') then begin

                CustMemberNo := SavingsAcc."Member No.";
                SavingsAcc := SavingsAccounts;
                YearDateFilter := '..' + Format(EndDate);

                case ProductFactory."Dividend Calc. Method" OF
                    ProductFactory."Dividend Calc. Method"::"Flat Rate":
                        begin

                            DateFilter := '..' + Format(EndDate);
                            SavingsAcc.SetFilter(SavingsAcc."Date Filter", DateFilter);
                            SavingsAcc.CalcFields(SavingsAcc."Balance (LCY)");
                            if SavingsAcc."Balance (LCY)" > 49999.99 then begin

                                GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)";
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                if CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if GrossDiv <> 0 then
                                    fnDivProgmgt(SavingsAcc."No.", Today, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo, 1, EndDate, InterestOptions, SavingsAcc."Currency Code");
                            end;
                        end;
                end;
            end
        end
    end;

    procedure fnDivProgmgt(AccountNo: Code[100]; ProcessingDate: Date;
    ProductID: Code[20]; ProductName: Text[150]; MemberNo: Code[100];
    QualifyingShares: Decimal; DivShares: Decimal; GrossDiv: Decimal;
    DivWHoldingTax: Decimal; NetDiv: Decimal; DivEndDate: Date;
    DivStartDate: Date; DivCalcMethod: Enum DividendMethod;
    PayMode: Code[20]; HeaderNo: Code[50]; Noofday: Integer;
    DepositDate: Date; InterestOptions: Enum "Rcv12 Dividend Interest Option"; currencycode: Code[10])
    begin

        DividendProgression.Init();
        DividendProgression."Entry No." := DividendProgression.GetNextEntryNo();
        DividendProgression.Validate("Account No", AccountNo);
        DividendProgression."Processing Date" := ProcessingDate;
        DividendProgression.Validate("Product Type", ProductID);
        DividendProgression."Product Name" := ProductName;
        DividendProgression.Validate("Member No", MemberNo);
        DividendProgression."Qualifying Shares" := QualifyingShares;
        DividendProgression.Shares := DivShares;
        DividendProgression."Gross Dividends" := GrossDiv;
        DividendProgression."Witholding Tax" := DivWHoldingTax;
        DividendProgression."Net Dividends" := NetDiv;
        DividendProgression."Start Date" := DivStartDate;
        DividendProgression."End Date" := DivEndDate;
        DividendProgression."Dividend Calc. Method" := DivCalcMethod;
        DividendProgression."Payment Mode" := PayMode;
        DividendProgression."Header No." := HeaderNo;
        DividendProgression."Rcv No. of Days" := Noofday;
        Dividendprogression."Rcv Deposit Date" := DepositDate;
        Dividendprogression."Rcv Interest Options" := InterestOptions;
        DividendProgression."Rcv Currency Code" := currencycode;
        DividendProgression."Rcv Document Source" := DividendProgression."Rcv Document Source"::"Online Slip";
        if DividendProgression."Gross Dividends" <> 0 then
            DividendProgression.Insert(true);
    end;

    procedure generateDividendInterest(var AccountCredit: Record "Account Credit"; ProductType: Code[50]; HeaderNo: Code[50]; StartDate: Date; EndDate: Date)
    var
        SavingsAcc: Record "Account Credit";
        DateFilter: Text[150];
        RIntDays: Integer;
        Bal: Decimal;
        DBalance: Decimal;
        Amt: array[7] of Decimal;
        Dfilter: Text[150];
        AsAt: Date;
        Duedate: Date;
        FromDate: Date;
        ToDate: Date;
        Minbal: Decimal;
        DaysInYear: Integer;
        AccBosa: Record "Account Credit";
        Pfact: Record "Product Factory";
        WTaxDiv: Decimal;
        WithTax: Decimal;
        DocNo: Code[20];
        GrossDiv: Decimal;
        NetDiv: Decimal;
        DivPayMode: Code[20];
        FirstMonthDate: Date;
        LastMonthDate: Date;
        DepositDate: Date;
        Custledgerentry: Record "Cust. Ledger Entry";
        DivprocessMgt: Codeunit "Dividend Process";
        Dividendsetup: Record "Dividend SetUp";
        DividendProgression: Record "Dividend Progression";
        DailyInt: Decimal;
        NoofDays: Integer;
        SavingBal: Decimal;
        InterestOptions: Enum "Rcv12 Dividend Interest Option";
    begin

        if AccountCredit."Member No." <> 'BLOCKED' then begin

            Bal := 0;
            DBalance := 0;
            Amt[3] := 0;
            DaysInYear := 0;
            RIntDays := 0;
            SavingBal := 0;

            Dividendsetup.Get();
            Dividendsetup.TestField("Start Date");

            if fncheckIfLeapYear(CalcDate('1M', StartDate)) then
                DaysInYear := 366 else
                DaysInYear := 365;

            Pfact.Reset();
            Pfact.SetRange("Product ID", AccountCredit."Product Type");
            if Pfact.FindFirst() then begin

                Pfact.TestField("WithHolding Tax");
                Pfact.TestField("Interest Rate (Max.)");
                Pfact.TestField("Dividend Calc. Method", Pfact."Dividend Calc. Method"::Prorated);
                DailyInt := (Pfact."Interest Rate (Max.)" / 100) * (1 / DaysInYear);
                WithTax := Pfact."WithHolding Tax";

                FirstMonthDate := StartDate;
                LastMonthDate := CalcDate('1M-1D', FirstMonthDate);
                DateFilter := Format(FirstMonthDate) + '..' + Format(LastMonthDate);

                FromDate := StartDate;
                ToDate := StartDate;

                if (ToDate <= EndDate) then begin
                    DateFilter := '..' + Format(ToDate);

                    SavingsAcc.Reset();
                    SavingsAcc.SetRange("No.", AccountCredit."No.");
                    SavingsAcc.SetFilter("Date Filter", DateFilter);
                    if SavingsAcc.FindFirst() then begin
                        SavingsAcc.CalcFields("Balance (LCY)", Balance);
                        case SavingsAcc."Account Category" of
                            SavingsAcc."Account Category"::"Shares Capital":
                                begin
                                    SavingBal := SavingsAcc."Balance (LCY)";
                                end else begin
                                if SavingsAcc."Currency Code" = '' then
                                    SavingBal := SavingsAcc."Balance (LCY)" else
                                    SavingBal := SavingsAcc.Balance;
                            end;
                        end;

                        Amt[1] := (SavingBal * DailyInt * DaysInYear);

                        WTaxDiv := Amt[1] * (Pfact."WithHolding Tax" / 100);
                        NetDiv := Amt[1] - WTaxDiv;
                        Bal := SavingBal;

                        DivprocessMgt.fnDivProgmgt(
                                AccountCredit."No.", Today, AccountCredit."Product Type",
                                AccountCredit."Product Name", AccountCredit."Member No.",
                                                              SavingBal, SavingBal,
                                                              Amt[1], WTaxDiv, NetDiv,
                                                              EndDate, StartDate,
                                                              Enum::DividendMethod::Prorated,
                                                              DivPayMode, HeaderNo,
                                                              DaysInYear, StartDate,
                                                              Enum::"Rcv12 Dividend Interest Option"::"Daily Basis",
                                                              AccountCredit."Currency Code");
                    end;
                end;

                AsAt := CalcDate('1D', FirstMonthDate);
                Duedate := LastMonthDate;
                RIntDays := DaysInYear;
                repeat

                    RIntDays := RIntDays - 1;
                    Dfilter := Format(AsAt);

                    Custledgerentry.Reset();
                    Custledgerentry.SetRange(Reversed, false);
                    Custledgerentry.SetFilter("Posting Date", Dfilter);
                    Custledgerentry.SetRange("Customer No.", AccountCredit."No.");
                    if Custledgerentry.FindSet() then begin
                        repeat
                            Custledgerentry.CalcFields(Amount, "Amount (LCY)");

                            Bal := 0;
                            DBalance := 0;
                            NetDiv := 0;
                            WTaxDiv := 0;
                            Amt[1] := 0;

                            if AccountCredit."Currency Code" = '' then
                                DBalance := Custledgerentry."Amount (LCY)" * -1 else
                                DBalance := Custledgerentry.Amount * -1;
                            Bal := DBalance;

                            if DBalance <> 0 then begin

                                DepositDate := Custledgerentry."Posting Date";
                                if EndDate = DepositDate then
                                    NoofDays := 1 else
                                    NoofDays := (EndDate - DepositDate);

                                Amt[1] := Round(DBalance * DailyInt * NoofDays);

                                if (Amt[1] <> 0) and (RIntDays > 0) then begin

                                    WTaxDiv := Amt[1] * (WithTax / 100);
                                    NetDiv := Amt[1] - WTaxDiv;

                                    DivprocessMgt.fnDivProgmgt(
                                        AccountCredit."No.", Today, AccountCredit."Product Type",
                                        AccountCredit."Product Name", AccountCredit."Member No.",
                                                                      Bal,
                                                                      DBalance,
                                                                      Amt[1], WTaxDiv, NetDiv,
                                                                      EndDate, StartDate,
                                                                      Enum::DividendMethod::Prorated,
                                                                      DivPayMode, HeaderNo,
                                                                      NoofDays, DepositDate, Enum::"Rcv12 Dividend Interest Option"::"Daily Basis", AccountCredit."Currency Code");
                                end
                            end;
                        until Custledgerentry.Next() = 0;
                    end;
                    AsAt := CalcDate('1D', AsAt);
                    Duedate := CalcDate('1D', Duedate);
                until RIntDays = 0
            end
        end;
    end;

    local procedure fncheckIfLeapYear(IntStartDate: Date): Boolean
    var
        DateMngt: Codeunit "Date Conversion";
    begin
        if DateMngt.DetermineDaysInMonth(Date2DMY(IntStartDate, 2), Date2DMY(IntStartDate, 3)) = 29 then
            exit(true)
    end;

    procedure fnCalcCustIntAltChannelMgt(acmgt: Record "Account Banking"; ProductType: Code[50]; HeaderNo: Code[50]; OpeningDate: Date; ClosingDate: Date)
    var
        CustMemberNo: Code[100];
        DividendSimulationHeader: Record "Dividend Simulation Header";
        MShares: Decimal;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        QualifyingAmount: Decimal;
        acbnkmgt: Record "Account Banking";
    begin

        GetDividendSetup();
        DividendSetUp.Get();
        DividendSetUp.TestField("Start Date");
        DividendSetUp.TestField("End Date");

        StartDate := OpeningDate;
        EndDate := ClosingDate;

        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        if ProductFactory.FindFirst() then begin

            acbnkmgt.Reset();
            acbnkmgt.SetRange("No.", acmgt."No.");
            acbnkmgt.SetRange("Product Type", ProductFactory."Product ID");
            if acbnkmgt.FindFirst() then begin

                CustMemberNo := acmgt."Member No.";
                acmgt := acbnkmgt;
                YearDateFilter := '..' + Format(EndDate);

                case ProductFactory."Dividend Calc. Method" OF
                    ProductFactory."Dividend Calc. Method"::"Flat Rate":
                        begin

                            DateFilter := '..' + Format(EndDate);
                            acmgt.SetFilter(acmgt."Date Filter", DateFilter);
                            acmgt.CalcFields(acmgt."Balance (LCY)");
                            if acmgt."Balance (LCY)" > 49999.99 then begin

                                GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)";
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                if CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if GrossDiv <> 0 then
                                    CreateDividendLines(acmgt."No.", Today, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        acmgt."Balance (LCY)", acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;
                        end;

                    ProductFactory."Dividend Calc. Method"::Prorated:
                        begin

                            MShares := 0;
                            FirstMonthDate := StartDate;
                            LastMonthDate := CalcDate('1M-1D', FirstMonthDate);
                            DateFilter := Format(FirstMonthDate) + '..' + Format(LastMonthDate);

                            acmgt.Reset();
                            acmgt.SetFilter("Date Filter", DateFilter);
                            acmgt.CalcFields("Balance (LCY)");
                            MShares := acmgt."Balance (LCY)";

                            if MShares < 0 then
                                MShares := 0;

                            FromDate := StartDate;
                            ToDate := CalcDate('1M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := '..' + Format(ToDate);

                                acmgt.RESET;
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (12 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (12 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 3
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type",
                                    acmgt."Product Name", acmgt."Member No.",
                                    QualifyingAmount, MShares, GrossDiv, WTaxDiv, NetDiv, ToDate, FromDate,
                                    ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('1M', StartDate);
                            ToDate := CALCDATE('2M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (11 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (11 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 4
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);

                            end;

                            FromDate := CALCDATE('2M', StartDate);
                            ToDate := CALCDATE('3M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (10 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (10 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 5
                                if (GrossDiv <> 0) and (ToDate <= EndDate) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('3M', StartDate);
                            ToDate := CALCDATE('4M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (9 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (9 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 6
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('4M', StartDate);
                            ToDate := CALCDATE('5M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (8 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (8 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 7
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                       QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('5M', StartDate);
                            ToDate := CALCDATE('6M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (7 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (7 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 8
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('6M', StartDate);
                            ToDate := CALCDATE('7M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (6 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (6 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 9
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('7M', StartDate);
                            ToDate := CALCDATE('8M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (5 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (5 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 10
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('8M', StartDate);
                            ToDate := CALCDATE('9M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (4 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (4 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 11
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('9M', StartDate);
                            ToDate := CALCDATE('10M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (3 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (3 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 12
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;

                            FromDate := CALCDATE('10M', StartDate);
                            ToDate := CALCDATE('11M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (2 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (2 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;
                            //NewMonth

                            FromDate := CALCDATE('11M', StartDate);
                            ToDate := CALCDATE('12M-1D', StartDate);
                            if (ToDate <= EndDate) then begin
                                DateFilter := FORMAT(FromDate) + '..' + FORMAT(ToDate);
                                acmgt.SETFILTER(acmgt."Date Filter", DateFilter);
                                acmgt.CALCFIELDS(acmgt."Balance (LCY)");
                                GrossDiv := ((ProductFactory."Interest Rate (Min.)" / 100) * acmgt."Balance (LCY)") * (1 / 12);
                                QualifyingAmount := (acmgt."Balance (LCY)" * (1 / 12));
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                IF CustMembr.GET(acbnkmgt."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(acmgt."No.", TODAY, acmgt."Product Type", acmgt."Product Name", acmgt."Member No.",
                                                        QualifyingAmount, acmgt."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;
                        end;
                end;

                //Withdrawn
                acmgt.Reset();
                acmgt.SetFilter("Date Filter", YearDateFilter);
                acmgt.SetFilter("Balance (LCY)", '<=0');
                acmgt.CalcFields("Balance (LCY)");
                IF acmgt.Find('-') then begin
                    DividendProgression.Reset();
                    DividendProgression.SetRange("Account No", acmgt."No.");
                    DividendProgression.SetRange("Processing Date", Today);
                    IF DividendProgression.Find('-') then
                        DividendProgression.DeleteAll();
                end;
            end;
        end;
    end;


    procedure fnCalcCustDivdendAltChannelMgt(SavingsAcc: Record "Account Credit"; ProductType: Code[50]; HeaderNo: Code[50]; OpeningDate: Date; ClosingDate: Date)
    var
        CustMemberNo: Code[100];
        DividendSimulationHeader: Record "Dividend Simulation Header";
        MShares: Decimal;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        QualifyingAmount: Decimal;
    begin

        GetDividendSetup();
        DividendSetUp.Get();
        DividendSetUp.TestField("Start Date");
        DividendSetUp.TestField("End Date");

        StartDate := OpeningDate;
        EndDate := ClosingDate;

        CustMemberNo := '';

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", ProductType);
        ProductFactory.SetRange("Product Class", ProductFactory."Product Class"::Account);
        IF ProductFactory.Find('-') then begin

            SavingsAccounts.Reset();
            SavingsAcc.SetRange(Processed, false);
            SavingsAccounts.SetRange("No.", SavingsAcc."No.");
            SavingsAccounts.SetRange("Product Type", ProductFactory."Product ID");
            if SavingsAccounts.Find('-') then begin

                CustMemberNo := SavingsAcc."Member No.";
                SavingsAcc := SavingsAccounts;
                YearDateFilter := '..' + Format(EndDate);

                case ProductFactory."Dividend Calc. Method" OF
                    ProductFactory."Dividend Calc. Method"::"Flat Rate":
                        begin

                            DateFilter := '..' + Format(EndDate);
                            SavingsAcc.SetFilter(SavingsAcc."Date Filter", DateFilter);
                            SavingsAcc.CalcFields(SavingsAcc."Balance (LCY)");
                            if SavingsAcc."Balance (LCY)" > 49999.99 then begin

                                GrossDiv := (ProductFactory."Interest Rate (Min.)" / 100) * SavingsAcc."Balance (LCY)";
                                WTaxDiv := GrossDiv * (ProductFactory."WithHolding Tax" / 100);
                                NetDiv := GrossDiv - WTaxDiv;
                                if CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if GrossDiv <> 0 then
                                    CreateDividendLines(SavingsAcc."No.", Today, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        SavingsAcc."Balance (LCY)", SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        EndDate, StartDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 3
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type",
                                    SavingsAcc."Product Name", SavingsAcc."Member No.",
                                    QualifyingAmount, MShares, GrossDiv, WTaxDiv, NetDiv, ToDate, FromDate,
                                    ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 4
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);

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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 5
                                if (GrossDiv <> 0) and (ToDate <= EndDate) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 6
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 7
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                       QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 8
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 9
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 10
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 11
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                //Month 12
                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
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
                                IF CustMembr.GET(SavingsAccounts."Member No.") THEN
                                    DivPayMode := CustMembr."Dividend Payment Method";

                                if (GrossDiv <> 0) then
                                    CreateDividendLines(SavingsAcc."No.", TODAY, SavingsAcc."Product Type", SavingsAcc."Product Name", SavingsAcc."Member No.",
                                                        QualifyingAmount, SavingsAcc."Balance (LCY)", GrossDiv, WTaxDiv, NetDiv,
                                                        ToDate, FromDate, ProductFactory."Dividend Calc. Method", DivPayMode, HeaderNo);
                            end;
                        end;
                end;

                //Withdrawn
                SavingsAcc.Reset();
                SavingsAcc.SetFilter("Date Filter", YearDateFilter);
                SavingsAcc.SetFilter("Balance (LCY)", '<=0');
                SavingsAcc.CalcFields("Balance (LCY)");
                IF SavingsAcc.Find('-') then begin
                    DividendProgression.Reset();
                    DividendProgression.SetRange("Account No", SavingsAcc."No.");
                    DividendProgression.SetRange("Processing Date", Today);
                    IF DividendProgression.Find('-') then
                        DividendProgression.DeleteAll();
                end;
            end;
        end;
    end;

    procedure CreateDividendLines(AccountNo: Code[100]; ProcessingDate: Date; ProductID: Code[20]; ProductName: Text[150]; MemberNo: Code[100]; QualifyingShares: Decimal; DivShares: Decimal; GrossDiv: Decimal; DivWHoldingTax: Decimal; NetDiv: Decimal; DivEndDate: Date; DivStartDate: Date; DivCalcMethod: Enum DividendMethod; PayMode: Code[20]; HeaderNo: Code[50])
    begin

        DividendProgression.Init();
        DividendProgression."Entry No." := DividendProgression.GetNextEntryNo();
        DividendProgression.Validate("Account No", AccountNo);
        DividendProgression."Processing Date" := ProcessingDate;
        DividendProgression.Validate("Product Type", ProductID);
        DividendProgression."Product Name" := ProductName;
        DividendProgression.Validate("Member No", MemberNo);
        DividendProgression."Qualifying Shares" := QualifyingShares;
        DividendProgression.Shares := DivShares;
        DividendProgression."Gross Dividends" := GrossDiv;
        DividendProgression."Witholding Tax" := DivWHoldingTax;
        DividendProgression."Net Dividends" := NetDiv;
        DividendProgression."Start Date" := DivStartDate;
        DividendProgression."End Date" := DivEndDate;
        DividendProgression."Dividend Calc. Method" := DivCalcMethod;
        DividendProgression."Payment Mode" := PayMode;
        DividendProgression."Header No." := HeaderNo;
        DividendProgression.Insert(true);
    end;

}



