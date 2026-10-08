codeunit 50042 "Periodic Activities Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        GeneralSetUp: Record "General Set-Up";
        InterestEntry: Record "Interest Line";
        InterestProgEntry: Record "Loan Progression Lines";
        InitPost: Codeunit "Initialize Gen. Jnl.-Post";
        Temp: Record "Banking User Template";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Linenum: Integer;
        GenJournal: Record "Gen. Journal Line";
        PostPeriodic: Codeunit "Gen.Jnl.-Post Periodic";
        Post: Codeunit "Journal Post Mngt.";
        RegMgt: Codeunit "Register Management";
        LoanEntry: Record Loans;
        AccountCredit: Record "Account Credit";
        AccountBanking: Record "Account Banking";
        AppMngt: Codeunit "Approval Mgmt.";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        StartDate: Date;
        EndDate: Date;
        ErrorOnNotAccountFound: Label 'Member No. %1 have no existing %2 found.';
        ErrorOnNotApprovedApplic: Label 'This application not yet approved. Kindly have the document approved before you can continue';
        Notif: Codeunit "SMS Notification";

    procedure fnIntEntriesonSpecificLoan(VarVariant: Record Loans; IntPostDate: Date; CodeNo: Code[20]; PostInt: Integer; IntDays: Integer; intStartDate: Date) OutInt: Decimal
    var
        ProductFactory: Record "Product Factory";
        IntDue: array[12] of Decimal;
        NoOfdays: Integer;
        NoOfdaysInMonth: Integer;
        PLoanCategory: Record "Loans Categorization";
        LoanLedger: Record "Loan Ledger Entry";
        MonthNumber: Integer;
        YearNumber: Integer;
        MonthTexts: Text;
        DateMngt: Codeunit "Date Conversion";
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
        PostLoan: Record Loans;
        Amt: array[5] of Decimal;
    begin
        //<<Documentation >> PostInt >> 1-Checks Daily Charging 0-Monthly Charging
        //<< ApplicType >> 1-Interest Due 2-Penalty Charged Posting
        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        IntDue[1] := 0;
        IntDue[2] := 0;
        IntDue[3] := 0;
        IntDue[4] := 0;
        IntDue[5] := 0;
        IntDue[6] := 0;
        PDate := 0D;
        RIntDays := IntDays;
        AsAt := IntStartDate;


        MonthTexts := FORMAT(IntStartDate, 0, '<Month Text,3> ');
        MonthNumber := Date2DMY(IntStartDate, 2);
        YearNumber := Date2DMY(IntStartDate, 3);
        if VarVariant."Interest Posting Date" = 0D then
            PDate := VarVariant."Interest Posting Date";
        NoOfDaysInMonth := DateMngt.DetermineDaysInMonth(MonthNumber, YearNumber);
        VarVariant.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
        if VarVariant."Outstanding Balance" > 0 then begin
            if VarVariant."Outstanding Interest" <= VarVariant."Outstanding Principal" then begin
                if ProductFactory.Get(VarVariant."Product Type") then begin

                    case PostInt of
                        1:
                            begin
                                repeat
                                    RIntDays := RIntDays - 1;
                                    DFilter := '01/01/06..' + Format(AsAt);
                                    PostLoan.Reset();
                                    PostLoan.SetRange("No.", VarVariant."No.");
                                    PostLoan.SetFilter("Date Filter", DFilter);
                                    if PostLoan.FindSet() then begin
                                        PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                                        Bal := 0;
                                        DBalance := 0;
                                        Bal := PostLoan."Outstanding Balance";
                                        DBalance := ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");
                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / NoOfDaysInMonth) * PostLoan."Outstanding Balance");
                                    end;
                                    AsAt := CalcDate('1D', AsAt);
                                until RIntDays = 0;
                                OutInt := Amt[3];
                            end;
                    end;
                end;
                exit(OutInt)
            end;
        end;
    end;

    procedure fnIntEntriesBBF(VarVariant: Record "Account Credit"; IntPostDate: Date; CodeNo: Code[50]; PostInt: Integer; ApplicType: Enum CreditBillingType; IntDays: Integer; intStartDate: Date)
    var
        ProductFactory: Record "Product Factory";
        IntDue: array[12] of Decimal;
        NoOfdays: Integer;
        NoOfdaysInMonth: Integer;
        BosaAccount: Record "Account Credit";
        LoanLedger: Record "Loan Ledger Entry";
        MonthNumber: Integer;
        YearNumber: Integer;
        MonthTexts: Text;
        DateMngt: Codeunit "Date Conversion";
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
        PostLoan: Record Loans;
        Amt: array[5] of Decimal;
        BenvAccount: Record "Account Credit";
        ErrorOnMissingAccount: Label 'Member does not have a Benevolent Account';
    begin

        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        PDate := 0D;

        RIntDays := IntDays;
        AsAt := IntStartDate;
        case VarVariant."Account Category" of
            VarVariant."Account Category"::"Shares Deposit":
                begin

                    VarVariant.CalcFields("Balance (LCY)");
                    BenvAccount.Reset();
                    BenvAccount.SetRange("Member No.", VarVariant."Member No.");
                    BenvAccount.SetRange("Account Category", BenvAccount."Account Category"::"Benevolent Fund");
                    if BenvAccount.FindFirst() then begin
                    end else begin
                        Error(ErrorOnMissingAccount);
                    end;
                    ProductFactory.Get(BenvAccount."Product Type");
                    ProductFactory.TestField("Minimum Contribution");
                    Amt[1] := ProductFactory."Minimum Contribution";

                    if VarVariant."Balance (LCY)" >= Amt[1] then begin
                        InterestEntry.LockTable;
                        InterestEntry.Init();
                        InterestEntry."Loan No." := '';
                        InterestEntry.No := CodeNo;
                        InterestEntry."Account No" := VarVariant."No.";
                        InterestEntry."Product Type" := VarVariant."Product Type";
                        InterestEntry."Interest Bills" := Amt[1];
                        InterestEntry."Accrued Interest" := 0;
                        InterestEntry.Amount := Amt[1];
                        InterestEntry."Bal. Account Type" := InterestEntry."Bal. Account Type"::Credit;
                        InterestEntry."Bal. Account No." := BenvAccount."No.";
                        InterestEntry."Transaction Type" := InterestEntry."Transaction Type"::" ";
                        InterestEntry.Description := 'Benevolent Fund (' + VarVariant."No." + ')' + ' ' +
                        Format(Today, 0, '<Month Text>') + ' ' + Format(Date2DMY(Today, 3));
                        InterestEntry."Interest Date" := Today;
                        InterestEntry.Insert(true);
                    end;
                end;
        end;
    end;

    procedure fnCloseInterestPeriod(dtOpenPeriod: Date; InterestCode: Code[20]) Closed: Boolean
    var
        dtNewPeriod: Date;
        intNewMonth: Integer;
        intNewYear: Integer;
        PrEmployeeTransactions: Record "Pr Employee Transaction";
        PrPeriodTransactions: Record "Pr Period Transaction";
        intMonth: Integer;
        intYear: Integer;
        PrTransactionCodes: Record "Pr Transaction Code";
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        PrEmployeeTrans: Record "Pr Employee Transaction";
        PrPayrollPeriods: Record "Pr Payroll Period";
        PrNewPayrollPeriods: Record "Pr Payroll Period";
        CreateTrans: Boolean;
    begin

    end;

    procedure fnIntEntries(VarVariant: Record Loans; IntPostDate: Date; CodeNo: Code[20]; ApplicType: Enum CreditBillingType; IntDays: Integer; intStartDate: Date; InterestFrequency: Enum RepaymentFrequency)
    var
        ProductFactory: Record "Product Factory";
        IntDue: array[12] of Decimal;
        NoOfdays: Integer;
        NoOfdaysInMonth: Integer;
        PLoanCategory: Record "Loans Categorization";
        LoanLedger: Record "Loan Ledger Entry";
        MonthNumber: Integer;
        YearNumber: Integer;
        MonthTexts: Text;
        DateMngt: Codeunit "Date Conversion";
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
        PostLoan: Record Loans;
        Amt: array[5] of Decimal;
        CustRec: Record Member;
    begin


        //<<Documentation >> PostInt >> 1-Checks Daily Charging 0-Monthly Charging
        //<< ApplicType >> 1-Interest Due 2-Penalty Charged Posting

        GeneralSetUp.Get();
        GeneralSetUp.TestField("Interest Posting Based On");

        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        IntDue[1] := 0;
        IntDue[2] := 0;
        IntDue[3] := 0;
        IntDue[4] := 0;
        IntDue[5] := 0;
        IntDue[6] := 0;
        IntDue[7] := 0;
        IntDue[8] := 0;
        IntDue[9] := 0;
        PDate := 0D;

        RIntDays := IntDays;
        AsAt := IntStartDate;

        AsAt := AsAt;
        MonthTexts := FORMAT(IntStartDate, 0, '<Month Text,3> ');
        MonthNumber := Date2DMY(IntStartDate, 2);
        YearNumber := Date2DMY(IntStartDate, 3);
        if VarVariant."Interest Posting Date" = 0D then
            PDate := VarVariant."Interest Posting Date";

        NoOfDaysInMonth := DateMngt.DetermineDaysInMonth(MonthNumber, YearNumber);

        IF VarVariant."Interest Posting Date" = 0D then
            VarVariant."Interest Posting Date" := VarVariant."Repayment Start Date";

        VarVariant.Modify(true);
        VarVariant.CalcFields("Outstanding Balance", "Accrued Interest", "Outstanding Principal", "Outstanding Interest");
        if VarVariant."Outstanding Balance" > 0 then begin

            if ProductFactory.Get(VarVariant."Product Type") then begin

                case ProductFactory."Billing Type" of
                    ProductFactory."Billing Type"::Insurance:
                        begin
                            ProductFactory.TestField("Insurance Due A/c");
                            ProductFactory.TestField("Insurance Paid A/c");
                            ProductFactory.TestField("Insurance Fee");

                        end;
                    ProductFactory."Billing Type"::Interest:
                        begin
                            ProductFactory.TestField("Interest Account (G/L)");
                            ProductFactory.TestField("Receivable Account (G/L)");

                        end;
                    ProductFactory."Billing Type"::"Interest+Insurance":
                        begin
                            ProductFactory.TestField("Interest Account (G/L)");
                            ProductFactory.TestField("Receivable Account (G/L)");
                            ProductFactory.TestField("Insurance Due A/c");
                            ProductFactory.TestField("Insurance Paid A/c");
                            ProductFactory.TestField("Insurance Fee");
                        end;

                    ProductFactory."Billing Type"::LedgerFee:
                        begin
                            ProductFactory.TestField("Ledger Fee Due A/c");
                            ProductFactory.TestField("Ledger Paid A/c");
                            ProductFactory.TestField("Settlement Fee");
                        end;

                    ProductFactory."Billing Type"::"Interest+Ledger Fee":
                        begin
                            ProductFactory.TestField("Interest Account (G/L)");
                            ProductFactory.TestField("Receivable Account (G/L)");
                            ProductFactory.TestField("Ledger Fee Due A/c");
                            ProductFactory.TestField("Ledger Paid A/c");
                            ProductFactory.TestField("Settlement Fee");
                        end;
                    ProductFactory."Billing Type"::All:
                        begin

                            ProductFactory.TestField("Interest Account (G/L)");
                            ProductFactory.TestField("Receivable Account (G/L)");
                            ProductFactory.TestField("Insurance Due A/c");
                            ProductFactory.TestField("Insurance Paid A/c");
                            ProductFactory.TestField("Insurance Fee");
                            ProductFactory.TestField("Penalty Due Account");
                            ProductFactory.TestField("Penalty Paid Account");
                            ProductFactory.TestField("Penalty Percentage");
                            ProductFactory.TestField("Settlement Fee");
                        end;
                end;

                case ApplicType of

                    ApplicType::Insurance:
                        begin
                            ProductFactory.TestField("Insurance Fee");
                            ProductFactory.TestField("Insurance Due A/c");
                            IntDue[7] := Round(((ProductFactory."Penalty Percentage" / 100) * VarVariant."Outstanding Balance"), 1, '=')
                        end;
                    ApplicType::"Ledger fee":
                        begin
                            ProductFactory.TestField("Settlement Fee");
                            ProductFactory.TestField("Ledger Fee Due A/c");
                            IntDue[8] := ProductFactory."Settlement Fee";
                        end;

                    ApplicType::Penalty:
                        begin
                            if PLoanCategory.Get(VarVariant."No.") then begin
                                case PLoanCategory."Performance Indicator" of
                                    PLoanCategory."Performance Indicator"::Doubtfull,
                                    PLoanCategory."Performance Indicator"::Substandard,
                                    PLoanCategory."Performance Indicator"::Loss:
                                        begin

                                            ProductFactory.TestField("Penalty Percentage");
                                            ProductFactory.TestField("Penalty Due Account");
                                            IntDue[1] := Round(((ProductFactory."Penalty Percentage" / 100) * VarVariant."Outstanding Balance"), 1, '=')

                                        end;
                                end;
                            end
                        end;

                    ApplicType::"Loan Interest":
                        begin
                            if VarVariant."Interest Calculation Method" <> VarVariant."Interest Calculation Method"::"Zero Interest" then begin
                                case VarVariant."Billing Type" of
                                    VarVariant."Billing Type"::Interest:
                                        begin
                                            if VarVariant."Outstanding Interest" <= VarVariant."Outstanding Principal" then begin
                                                case InterestFrequency of
                                                    InterestFrequency::Daily:
                                                        begin
                                                            repeat
                                                                RIntDays := RIntDays - 1;

                                                                DFilter := '01/01/06..' + Format(AsAt);
                                                                PostLoan.Reset();
                                                                PostLoan.SetRange("No.", VarVariant."No.");
                                                                PostLoan.SetFilter("Date Filter", DFilter);
                                                                if PostLoan.FindSet() then begin

                                                                    PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                                                                    Bal := 0;
                                                                    DBalance := 0;
                                                                    Bal := PostLoan."Outstanding Balance";
                                                                    DBalance := ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");
                                                                    if VarVariant."Interest Calculation Method" = VarVariant."Interest Calculation Method"::"Straight Line" then
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Approved Amount") else
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");

                                                                    InterestProgEntry.LockTable();
                                                                    InitializeProgEntry(VarVariant, InterestProgEntry, CodeNo);
                                                                    InterestProgEntry."Interest Bills" := VarVariant."Outstanding Bill";
                                                                    InterestProgEntry."Accrued Interest" := VarVariant."Outstanding Interest";
                                                                    InterestProgEntry.Amount := DBalance;
                                                                    InterestProgEntry."Transaction Type" := InterestProgEntry."Transaction Type"::"Interest Due";
                                                                    InterestProgEntry.Description := 'Interest Due (' + VarVariant."No." + ')' + ' ' + Format(AsAt, 0, '<Month Text>') + ' ' + Format(Date2DMY(AsAt, 3));
                                                                    InterestProgEntry."Interest Date" := AsAt;
                                                                    if InterestProgEntry.Amount > 0 then
                                                                        InterestProgEntry.Insert(true);
                                                                end;
                                                                AsAt := CalcDate('1D', AsAt);
                                                            until RIntDays = 0;
                                                            IntDue[2] := Amt[3];
                                                        end;
                                                    InterestFrequency::Monthly:
                                                        begin
                                                            case VarVariant."Interest Calculation Method" of
                                                                VarVariant."Interest Calculation Method"::"Straight Line":
                                                                    begin
                                                                        IntDue[2] := Round(VarVariant."Approved Amount" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end else begin
                                                                    case GeneralSetUp."Interest Posting Based On" of
                                                                        GeneralSetUp."Interest Posting Based On"::"Outstanding Principle":
                                                                            IntDue[2] := Round(VarVariant."Outstanding Principal" * (VarVariant."Interest Rate" / 1200), 0.01, '>')
                                                                        else
                                                                            IntDue[2] := Round(VarVariant."Outstanding Balance" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end;
                                                                end;
                                                            end
                                                        end;

                                                end
                                            end
                                        end
                                end
                            end;
                        end;

                    ApplicType::"Interest+Insurance":
                        begin

                            if VarVariant."Interest Calculation Method" <> VarVariant."Interest Calculation Method"::"Zero Interest" then begin

                                case VarVariant."Billing Type" of
                                    VarVariant."Billing Type"::"Interest+Insurance":
                                        begin
                                            if VarVariant."Outstanding Interest" <= VarVariant."Outstanding Principal" then begin

                                                case InterestFrequency of
                                                    InterestFrequency::Daily:
                                                        begin
                                                            repeat
                                                                RIntDays := RIntDays - 1;

                                                                DFilter := '01/01/06..' + Format(AsAt);
                                                                PostLoan.Reset();
                                                                PostLoan.SetRange("No.", VarVariant."No.");
                                                                PostLoan.SetFilter("Date Filter", DFilter);
                                                                if PostLoan.FindSet() then begin

                                                                    PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                                                                    Bal := 0;
                                                                    DBalance := 0;
                                                                    Bal := PostLoan."Outstanding Balance";
                                                                    DBalance := ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");
                                                                    if VarVariant."Interest Calculation Method" = VarVariant."Interest Calculation Method"::"Straight Line" then
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Approved Amount") else
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");

                                                                    InterestProgEntry.LockTable();
                                                                    InitializeProgEntry(VarVariant, InterestProgEntry, CodeNo);
                                                                    InterestProgEntry."Interest Bills" := VarVariant."Outstanding Bill";
                                                                    InterestProgEntry."Accrued Interest" := VarVariant."Outstanding Interest";
                                                                    InterestProgEntry.Amount := DBalance;
                                                                    InterestProgEntry."Transaction Type" := InterestProgEntry."Transaction Type"::"Interest Due";
                                                                    InterestProgEntry.Description := 'Interest Due (' + VarVariant."No." + ')' + ' ' + Format(AsAt, 0, '<Month Text>') + ' ' + Format(Date2DMY(AsAt, 3));
                                                                    InterestProgEntry."Interest Date" := AsAt;
                                                                    if InterestProgEntry.Amount > 0 then
                                                                        InterestProgEntry.Insert(true);
                                                                end;
                                                                AsAt := CalcDate('1D', AsAt);
                                                            until RIntDays = 0;
                                                            IntDue[2] := Amt[3];
                                                        end;
                                                    InterestFrequency::Monthly:
                                                        begin
                                                            case VarVariant."Interest Calculation Method" of
                                                                VarVariant."Interest Calculation Method"::"Straight Line":
                                                                    begin
                                                                        IntDue[2] := Round(VarVariant."Approved Amount" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end else begin
                                                                    case GeneralSetUp."Interest Posting Based On" of
                                                                        GeneralSetUp."Interest Posting Based On"::"Outstanding Principle":
                                                                            IntDue[2] := Round(VarVariant."Outstanding Principal" * (VarVariant."Interest Rate" / 1200), 0.01, '>')
                                                                        else
                                                                            IntDue[2] := Round(VarVariant."Outstanding Balance" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end;
                                                                end;
                                                            end
                                                        end;

                                                end;
                                                IntDue[7] := Round(((VarVariant."Approved Amount" * (ProductFactory."Insurance Fee" / 1000)) / 2));
                                            end
                                        end;
                                end
                            end else begin

                                if VarVariant."Billing Type" <> VarVariant."Billing Type"::" " then begin
                                    IntDue[7] := Round(((VarVariant."Approved Amount" * (ProductFactory."Insurance Fee" / 1000)) / 2));
                                end
                            end;
                        end;

                    ApplicType::"Interest+LedgerFee":
                        begin
                            if VarVariant."Interest Calculation Method" <> VarVariant."Interest Calculation Method"::"Zero Interest" then begin

                                case VarVariant."Billing Type" of
                                    VarVariant."Billing Type"::"Interest+Ledger Fee":
                                        begin
                                            if VarVariant."Outstanding Interest" <= VarVariant."Outstanding Principal" then begin

                                                case InterestFrequency of
                                                    InterestFrequency::Daily:
                                                        begin
                                                            repeat
                                                                RIntDays := RIntDays - 1;

                                                                DFilter := '01/01/06..' + Format(AsAt);
                                                                PostLoan.Reset();
                                                                PostLoan.SetRange("No.", VarVariant."No.");
                                                                PostLoan.SetFilter("Date Filter", DFilter);
                                                                if PostLoan.FindSet() then begin

                                                                    PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                                                                    Bal := 0;
                                                                    DBalance := 0;
                                                                    Bal := PostLoan."Outstanding Balance";
                                                                    DBalance := ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");
                                                                    if VarVariant."Interest Calculation Method" = VarVariant."Interest Calculation Method"::"Straight Line" then
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Approved Amount") else
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");

                                                                    InterestProgEntry.LockTable();
                                                                    InitializeProgEntry(VarVariant, InterestProgEntry, CodeNo);
                                                                    InterestProgEntry."Interest Bills" := VarVariant."Outstanding Bill";
                                                                    InterestProgEntry."Accrued Interest" := VarVariant."Outstanding Interest";
                                                                    InterestProgEntry.Amount := DBalance;
                                                                    InterestProgEntry."Transaction Type" := InterestProgEntry."Transaction Type"::"Interest Due";
                                                                    InterestProgEntry.Description := 'Interest Due (' + VarVariant."No." + ')' + ' ' + Format(AsAt, 0, '<Month Text>') + ' ' + Format(Date2DMY(AsAt, 3));
                                                                    InterestProgEntry."Interest Date" := AsAt;
                                                                    if InterestProgEntry.Amount > 0 then
                                                                        InterestProgEntry.Insert(true);
                                                                end;
                                                                AsAt := CalcDate('1D', AsAt);
                                                            until RIntDays = 0;
                                                            IntDue[2] := Amt[3];
                                                        end;
                                                    InterestFrequency::Monthly:
                                                        begin
                                                            case VarVariant."Interest Calculation Method" of
                                                                VarVariant."Interest Calculation Method"::"Straight Line":
                                                                    begin
                                                                        IntDue[2] := Round(VarVariant."Approved Amount" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end else begin
                                                                    case GeneralSetUp."Interest Posting Based On" of
                                                                        GeneralSetUp."Interest Posting Based On"::"Outstanding Principle":
                                                                            IntDue[2] := Round(VarVariant."Outstanding Principal" * (VarVariant."Interest Rate" / 1200), 0.01, '>')
                                                                        else
                                                                            IntDue[2] := Round(VarVariant."Outstanding Balance" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end;
                                                                end;
                                                            end
                                                        end;

                                                end;
                                                IntDue[8] := ProductFactory."Settlement Fee";
                                            end
                                        end;
                                end
                            end else begin
                                if VarVariant."Billing Type" <> VarVariant."Billing Type"::" " then begin
                                    IntDue[8] := ProductFactory."Settlement Fee";
                                end
                            end;
                        end;
                    ApplicType::"Interest or Ledger Fee":
                        begin

                            if VarVariant."Interest Calculation Method" <> VarVariant."Interest Calculation Method"::"Zero Interest" then begin

                                case VarVariant."Billing Type" of
                                    VarVariant."Billing Type"::Interest:
                                        begin
                                            if VarVariant."Outstanding Interest" <= VarVariant."Outstanding Principal" then begin

                                                case InterestFrequency of
                                                    InterestFrequency::Daily:
                                                        begin
                                                            repeat
                                                                RIntDays := RIntDays - 1;

                                                                DFilter := '01/01/06..' + Format(AsAt);
                                                                PostLoan.Reset();
                                                                PostLoan.SetRange("No.", VarVariant."No.");
                                                                PostLoan.SetFilter("Date Filter", DFilter);
                                                                if PostLoan.FindSet() then begin

                                                                    PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                                                                    Bal := 0;
                                                                    DBalance := 0;
                                                                    Bal := PostLoan."Outstanding Balance";
                                                                    DBalance := ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");
                                                                    if VarVariant."Interest Calculation Method" = VarVariant."Interest Calculation Method"::"Straight Line" then
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Approved Amount") else
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");

                                                                    InterestProgEntry.LockTable();
                                                                    InitializeProgEntry(VarVariant, InterestProgEntry, CodeNo);
                                                                    InterestProgEntry."Interest Bills" := VarVariant."Outstanding Bill";
                                                                    InterestProgEntry."Accrued Interest" := VarVariant."Outstanding Interest";
                                                                    InterestProgEntry.Amount := DBalance;
                                                                    InterestProgEntry."Transaction Type" := InterestProgEntry."Transaction Type"::"Interest Due";
                                                                    InterestProgEntry.Description := 'Interest Due (' + VarVariant."No." + ')' + ' ' + Format(AsAt, 0, '<Month Text>') + ' ' + Format(Date2DMY(AsAt, 3));
                                                                    InterestProgEntry."Interest Date" := AsAt;
                                                                    if InterestProgEntry.Amount > 0 then
                                                                        InterestProgEntry.Insert(true);
                                                                end;
                                                                AsAt := CalcDate('1D', AsAt);
                                                            until RIntDays = 0;
                                                            IntDue[2] := Amt[3];
                                                        end;
                                                    InterestFrequency::Monthly:
                                                        begin
                                                            case VarVariant."Interest Calculation Method" of
                                                                VarVariant."Interest Calculation Method"::"Straight Line":
                                                                    begin
                                                                        IntDue[2] := Round(VarVariant."Approved Amount" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end else begin
                                                                    case GeneralSetUp."Interest Posting Based On" of
                                                                        GeneralSetUp."Interest Posting Based On"::"Outstanding Principle":
                                                                            IntDue[2] := Round(VarVariant."Outstanding Principal" * (VarVariant."Interest Rate" / 1200), 0.01, '>')
                                                                        else
                                                                            IntDue[2] := Round(VarVariant."Outstanding Balance" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end;
                                                                end;
                                                            end
                                                        end;
                                                end;
                                            end
                                        end;
                                end
                            end else begin

                                if VarVariant."Billing Type" = VarVariant."Billing Type"::LedgerFee then begin

                                    ProductFactory.TestField("Settlement Fee");
                                    ProductFactory.TestField("Ledger Fee Due A/c");
                                    IntDue[8] := ProductFactory."Settlement Fee";
                                end
                            end;
                        end;

                    ApplicType::"Interest+Insurance+LedgerFee":
                        begin
                            if VarVariant."Interest Calculation Method" <> VarVariant."Interest Calculation Method"::"Zero Interest" then begin

                                case VarVariant."Billing Type" of
                                    VarVariant."Billing Type"::All:
                                        begin
                                            if VarVariant."Outstanding Interest" <= VarVariant."Outstanding Principal" then begin

                                                case InterestFrequency of
                                                    InterestFrequency::Daily:
                                                        begin
                                                            repeat
                                                                RIntDays := RIntDays - 1;

                                                                DFilter := '01/01/06..' + Format(AsAt);
                                                                PostLoan.Reset();
                                                                PostLoan.SetRange("No.", VarVariant."No.");
                                                                PostLoan.SetFilter("Date Filter", DFilter);
                                                                if PostLoan.FindSet() then begin

                                                                    PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest");
                                                                    Bal := 0;
                                                                    DBalance := 0;
                                                                    Bal := PostLoan."Outstanding Balance";
                                                                    DBalance := ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");
                                                                    if VarVariant."Interest Calculation Method" = VarVariant."Interest Calculation Method"::"Straight Line" then
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Approved Amount") else
                                                                        Amt[3] := Amt[3] + ((PostLoan."Interest Rate" / 1200 / IntDays) * PostLoan."Outstanding Balance");

                                                                    InterestProgEntry.LockTable();
                                                                    InitializeProgEntry(VarVariant, InterestProgEntry, CodeNo);
                                                                    InterestProgEntry."Interest Bills" := VarVariant."Outstanding Bill";
                                                                    InterestProgEntry."Accrued Interest" := VarVariant."Outstanding Interest";
                                                                    InterestProgEntry.Amount := DBalance;
                                                                    InterestProgEntry."Transaction Type" := InterestProgEntry."Transaction Type"::"Interest Due";
                                                                    InterestProgEntry.Description := 'Interest Due (' + VarVariant."No." + ')' + ' ' + Format(AsAt, 0, '<Month Text>') + ' ' + Format(Date2DMY(AsAt, 3));
                                                                    InterestProgEntry."Interest Date" := AsAt;
                                                                    if InterestProgEntry.Amount > 0 then
                                                                        InterestProgEntry.Insert(true);
                                                                end;
                                                                AsAt := CalcDate('1D', AsAt);
                                                            until RIntDays = 0;
                                                            IntDue[2] := Amt[3];
                                                        end;
                                                    InterestFrequency::Monthly:
                                                        begin
                                                            case VarVariant."Interest Calculation Method" of
                                                                VarVariant."Interest Calculation Method"::"Straight Line":
                                                                    begin
                                                                        IntDue[2] := Round(VarVariant."Approved Amount" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end else begin
                                                                    case GeneralSetUp."Interest Posting Based On" of
                                                                        GeneralSetUp."Interest Posting Based On"::"Outstanding Principle":
                                                                            IntDue[2] := Round(VarVariant."Outstanding Principal" * (VarVariant."Interest Rate" / 1200), 0.01, '>')
                                                                        else
                                                                            IntDue[2] := Round(VarVariant."Outstanding Balance" * (VarVariant."Interest Rate" / 1200), 0.01, '>');
                                                                    end;
                                                                end;
                                                            end
                                                        end;

                                                end;
                                                IntDue[7] := Round(((VarVariant."Approved Amount" * (ProductFactory."Insurance Fee" / 1000)) / 2));
                                                IntDue[8] := ProductFactory."Settlement Fee";
                                            end
                                        end;
                                end
                            end else begin

                                if VarVariant."Billing Type" <> VarVariant."Billing Type"::" " then begin
                                    IntDue[7] := Round(((VarVariant."Approved Amount" * (ProductFactory."Insurance Fee" / 1000)) / 2));
                                    IntDue[8] := ProductFactory."Settlement Fee";
                                end
                            end;
                        end;
                    ApplicType::" ":
                        Error('Case condition %1 not implemented.', ApplicType::" ");
                    ApplicType::"Transfer Interest(G/L)":
                        Error('Case condition %1 not implemented.', ApplicType::"Transfer Interest(G/L)");
                    ApplicType::"Transfer Interest(Banking)":
                        Error('Case condition %1 not implemented.', ApplicType::"Transfer Interest(Banking)");
                    ApplicType::Commisions:
                        Error('Case condition %1 not implemented.', ApplicType::Commisions);
                    ApplicType::"Benevolent Recovery":
                        Error('Case condition %1 not implemented.', ApplicType::"Benevolent Recovery");
                    ApplicType::"Interest+Penalty":
                        Error('Case condition %1 not implemented.', ApplicType::"Interest+Penalty");

                end;

                if IntDue[2] > 0 then begin

                    InterestEntry.LockTable;
                    InitializeIntEntry(VarVariant, InterestEntry, CodeNo);
                    InterestEntry."Interest Bills" := IntDue[2];
                    if InterestFrequency = InterestFrequency::Daily then
                        InterestEntry."Accrued Interest" := IntDue[2] else
                        InterestEntry."Accrued Interest" := 0;

                    InterestEntry.Amount := IntDue[2];
                    InterestEntry."Transaction Type" := InterestEntry."Transaction Type"::"Interest Due";
                    InterestEntry."Bal. Account No." := ProductFactory."Interest Account (G/L)";
                    InterestEntry.Description := 'Interest Due (' + VarVariant."No." + ')' + ' ' + Format(IntPostDate, 0, '<Month Text>') + ' ' + Format(Date2DMY(IntPostDate, 3));
                    InterestEntry."Interest Date" := IntPostDate;
                    InterestEntry."Interest Calculation Method" := VarVariant."Interest Calculation Method";
                    if PLoanCategory.Get(VarVariant."No.") then
                        InterestEntry."Loans Category-Sasra" := PLoanCategory."Performance Indicator";

                    case PLoanCategory."Performance Indicator" of
                        PLoanCategory."Performance Indicator"::Performing,
                        PLoanCategory."Performance Indicator"::Substandard,
                        PLoanCategory."Performance Indicator"::Watch:
                            InterestEntry.Insert(true);
                    end;
                end;

                if IntDue[7] > 0 then begin

                    InterestEntry.LockTable;
                    InitializeIntEntry(VarVariant, InterestEntry, CodeNo);
                    InterestEntry."Interest Bills" := 0;
                    InterestEntry."Accrued Interest" := 0;
                    InterestEntry.Amount := IntDue[7];
                    InterestEntry."Transaction Type" := InterestEntry."Transaction Type"::"Insurance Due";
                    InterestEntry."Bal. Account No." := ProductFactory."Insurance Paid A/c";
                    InterestEntry.Description := 'Insurance Due (' + VarVariant."No." + ')' + ' ' + Format(IntPostDate, 0, '<Month Text>') + ' ' + Format(Date2DMY(IntPostDate, 3));
                    InterestEntry."Interest Date" := IntPostDate;
                    InterestEntry."Interest Calculation Method" := VarVariant."Interest Calculation Method";
                    if PLoanCategory.Get(VarVariant."No.") then
                        InterestEntry."Loans Category-Sasra" := PLoanCategory."Performance Indicator";

                    case PLoanCategory."Performance Indicator" of
                        PLoanCategory."Performance Indicator"::Performing,
                        PLoanCategory."Performance Indicator"::Substandard,
                        PLoanCategory."Performance Indicator"::Watch:
                            InterestEntry.Insert(true);
                    end;
                end;

                if IntDue[8] > 0 then begin

                    InterestEntry.LockTable;
                    InitializeIntEntry(VarVariant, InterestEntry, CodeNo);
                    InterestEntry."Interest Bills" := 0;
                    InterestEntry."Accrued Interest" := 0;
                    InterestEntry.Amount := IntDue[8];
                    InterestEntry."Transaction Type" := InterestEntry."Transaction Type"::"Ledger Fee Due";
                    InterestEntry."Bal. Account No." := ProductFactory."Ledger Paid A/c";
                    InterestEntry.Description := 'Ledger Fee Due (' + VarVariant."No." + ')' + ' ' + Format(IntPostDate, 0, '<Month Text>') + ' ' + Format(Date2DMY(IntPostDate, 3));
                    InterestEntry."Interest Date" := IntPostDate;
                    InterestEntry."Interest Calculation Method" := VarVariant."Interest Calculation Method";
                    if PLoanCategory.Get(VarVariant."No.") then
                        InterestEntry."Loans Category-Sasra" := PLoanCategory."Performance Indicator";
                    if InterestEntry.Amount > 0 then begin

                        case PLoanCategory."Performance Indicator" of
                            PLoanCategory."Performance Indicator"::Performing,
                            PLoanCategory."Performance Indicator"::Substandard,
                            PLoanCategory."Performance Indicator"::Watch:
                                InterestEntry.Insert(true);
                        end;
                    end;

                end;

                if IntDue[9] > 0 then begin

                    InterestEntry.LockTable;
                    InitializeIntEntry(VarVariant, InterestEntry, CodeNo);
                    InterestEntry."Interest Bills" := 0;
                    InterestEntry."Accrued Interest" := 0;
                    InterestEntry.Amount := IntDue[1];
                    InterestEntry."Transaction Type" := InterestEntry."Transaction Type"::"Penalty Due";
                    InterestEntry."Bal. Account No." := ProductFactory."Penalty Paid Account";
                    InterestEntry.Description := 'Penalty Due (' + VarVariant."No." + ')' + ' ' + Format(IntPostDate, 0, '<Month Text>') + ' ' + Format(Date2DMY(IntPostDate, 3));
                    InterestEntry."Interest Calculation Method" := VarVariant."Interest Calculation Method";
                    if PLoanCategory.Get(VarVariant."No.") then
                        InterestEntry."Loans Category-Sasra" := PLoanCategory."Performance Indicator";

                    case PLoanCategory."Performance Indicator" of
                        PLoanCategory."Performance Indicator"::Performing,
                        PLoanCategory."Performance Indicator"::Substandard,
                        PLoanCategory."Performance Indicator"::Watch:
                            InterestEntry.Insert(true);
                    end
                end
            end
        end;

    end;

    procedure PostMobileLoanPenalty(PostLoan: Record Loans; PostInt: Integer; AmtCharged: Decimal; PostingDate: Date)
    var
        PFact: Record "Product Factory";
        IntDue: Decimal;
        Post: Codeunit "Journal Post Mngt.";
        PostDate: Date;
        FirstDayOfYear: Date;
        Member: Record Member;
        SmsNotification: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        DateMonth: Integer;
        MonthYear: Integer;
        TempEntry: Record "Transaction Types-Mobile";
        TransactionType: Enum MobileTransType;
        MobileDeductionStatus: Enum MobileDeductionStatus;
        RepayType: Enum "LoanTransactionType";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        FosaAc: Record "Account Banking";
        Varvariant: Variant;
        TransTypeEntry: Record "Transaction Types-Mobile";
        TotalPenaltyCharged: Decimal;
        DetailedCust: Record "Detailed Cust. Ledg. Entry";

    begin

        Temp.Reset();
        Temp.SetRange("Account ID", UserId);
        Temp.SetRange("Account Type", Temp."Account Type"::"Automated Posting");
        if Temp.FindFirst() then begin
            Temp.TestField("Bills Template");
            Temp.TestField("Bills Batch");
            Temp.TestField("Shortcut Dimension 1 Code");
            Temp.TestField("Shortcut Dimension 2 Code");
            Jtemplate := Temp."Bills Template";
            JBatch := Temp."Bills Batch";
        end else begin
            Error('No journal template and batch found for user');
        end;
        Post.ClearJournalLines(Jtemplate, JBatch);
        PostLoan.CalcFields("Outstanding Balance",
                    "Outstanding Interest",
                    "Outstanding Principal",
                    "Outstanding Bill");

        IntDue := 0;
        PostDate := 0D;
        FirstDayOfYear := 0D;
        DateMonth := 0;
        TotalPenaltyCharged := 0;
        FirstDayOfYear := CalcDate('<-CY>', Today);


        if PostLoan."Outstanding Balance" > 0 then begin

            DetailedCust.Reset();
            DetailedCust.SetRange("Loan No.", PostLoan."No.");
            DetailedCust.SetRange("Transaction Type", DetailedCust."Transaction Type"::"Penalty Due");
            if DetailedCust.FindSet() then begin
                DetailedCust.CalcSums(Amount);
                TotalPenaltyCharged := DetailedCust.Amount;
            end;

            if PFact.Get(PostLoan."Product Type") then begin
                PFact.TestField("Penalty Due Account");
                PFact.TestField("Penalty Paid Account");
                PFact.TestField("Penalty Percentage");
                PFact.TestField("Minimum Balance");

                if TotalPenaltyCharged < PFact."Minimum Balance" then begin

                    IntDue := PFact."Penalty Percentage";
                    Linenum := Linenum + 1000;
                    PostDate := PostingDate;

                    GenJournal.Init();
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostDate;
                    GenJournal."Document No." := PostLoan."No.";
                    GenJournal."External Document No." := PostLoan."Account No.";
                    GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                    GenJournal.Validate("Account No.", PostLoan."Loan Account");
                    GenJournal.Validate(Amount, IntDue);
                    GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Penalty Due";
                    GenJournal.Description := CopyStr(format(GenJournal."Transaction Type") + '-' + PostLoan."No.", 1, 50);
                    GenJournal.Validate("Loan No.", PostLoan."No.");
                    GenJournal.Validate("Bal. Account No.", PFact."Penalty Paid Account");
                    GenJournal.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                    GenJournal.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);

                    if FosaAc.Get(PostLoan."Disbursement Account No.") then
                        TempEntry.LockTable();
                    TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                    RegMgt.InitializeTempEntry(PostLoan,
                            TempEntry, TellMngt.CalcAvailableBal(FosaAc."No."),
                            TellMngt.CalcAvailableBal(FosaAc."No."),
                            TransactionType::"Penalty Due",
                            RepayType::"Penalty Due",
                            MobileDeductionStatus::"Full Deduction", Abs(GenJournal.Amount));
                    TempEntry.Insert(true);

                    if PostInt = 1 then begin
                        Post.CompletePosting(Jtemplate, JBatch);
                        PostLoan."Interest Due Date" := CalcDate('1D', PostDate);
                        PostLoan.Modify(true);

                        Varvariant := TransTypeEntry;
                        RegMgt.ValuePosting(Varvariant, 0, PostLoan."No.", Today);

                        if Member.Get(PostLoan."Account No.") then begin
                            SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", Member."Mobile Phone No",
                      'Dear ' + PostLoan."Account Name" + ', Your ' + PostLoan."Product Description" +
                      ' of KES' + format(PostLoan."Approved Amount") + ' is overdue. KES ' + format(IntDue) + ' Penalty has been charged. Pay ' + Format(PostLoan."Outstanding Balance") + ' before recovery from deposits.', Member."No.",
                         Member."No.", false);
                        end;
                    end else begin

                        if Member.Get(PostLoan."Account No.") then begin
                            SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", Member."Mobile Phone No",
                      'Dear ' + PostLoan."Account Name" + ', Your ' + PostLoan."Product Description" +
                      ' of KES' + format(PostLoan."Approved Amount") + ' is overdue. KES ' + format(IntDue) + ' Penalty has been charged. Pay ' + Format(PostLoan."Outstanding Balance") + ' before recovery from deposits.', Member."No.",
                         Member."No.", false);
                        end;
                    end;

                end;
            end;
        end;
    end;

    procedure PostMobileLoanInterest(PostLoan: Record Loans; PostInt: Integer)
    var
        PFact: Record "Product Factory";
        IntDue: Decimal;
        Post: Codeunit "Journal Post Mngt.";
        PostDate: Date;
        FirstDayOfYear: Date;
        SmsNotification: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        ReminderMessage: Text[250];
        CustRec: Record Member;
        Varvariant: Variant;
        TransTypeEntry: Record "Transaction Types-Mobile";
        MessageTemp: Label 'You may repay partially or fully by dialling *605*5# or via the QC Wallet App.';
        TransactionType: Enum MobileTransType;
        FosaAc: Record "Account Banking";
        RegisterMngt: Codeunit "Register Management";
        AvailBalance: Decimal;
        BalanceLCY: Decimal;
        RepayType: Enum "LoanTransactionType";
        DeductionStatus: Enum MobileDeductionStatus;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        TempEntry: Record "Transaction Types-Mobile";

    begin

        Temp.Reset();
        Temp.SetRange("Account ID", UserId);
        Temp.SetRange("Account Type", Temp."Account Type"::"Automated Posting");
        if Temp.FindFirst() then begin
            Temp.TestField("Bills Template");
            Temp.TestField("Bills Batch");
            Temp.TestField("Shortcut Dimension 1 Code");
            Temp.TestField("Shortcut Dimension 2 Code");
            Jtemplate := Temp."Bills Template";
            JBatch := Temp."Bills Batch";
        end else begin
            Error('No journal template and batch found for user');
        end;
        Post.ClearJournalLines(Jtemplate, JBatch);
        PostLoan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
        IntDue := 0;
        PostDate := 0D;
        FirstDayOfYear := 0D;
        FirstDayOfYear := CalcDate('<-CY>', Today);
        PostDate := Today;

        if PostLoan."Interest Due Date" = Today then begin

            if PostLoan."Outstanding Balance" > 0 then begin

                if PostLoan."Outstanding Interest" <= PostLoan."Outstanding Balance" then begin
                    if PFact.Get(PostLoan."Product Type") then begin
                        PFact.TestField("Interest Account (G/L)");
                        PFact.TestField("Receivable Account (G/L)");
                        PFact.TestField("Interest Rate (Max.)");

                        IntDue := Round(PostLoan."Outstanding Balance" * (PFact."Interest Rate (Max.)" / 100));
                        Linenum := Linenum + 1000;

                        GenJournal.Init();
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostDate;
                        GenJournal."Document No." := PostLoan."No.";
                        GenJournal."External Document No." := PostLoan."Account No.";
                        GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                        GenJournal.Validate("Account No.", PostLoan."Loan Account");
                        GenJournal.Validate(Amount, IntDue);
                        GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Due";
                        GenJournal.Description := CopyStr(format(GenJournal."Transaction Type") + '-' + PostLoan."No.", 1, 50);
                        GenJournal.Validate("Loan No.", PostLoan."No.");
                        GenJournal.Validate("Bal. Account No.", PFact."Interest Account (G/L)");
                        GenJournal.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                        GenJournal.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);

                        AvailBalance := 0;
                        BalanceLCY := 0;
                        if FosaAc.Get(PostLoan."Disbursement Account No.") then
                            FosaAc.CalcFields("Balance (LCY)");
                        AvailBalance := TellMngt.CalcAvailableBal(PostLoan."Disbursement Account No.");

                        TempEntry.LockTable();
                        TempEntry."Entry No." := RegisterMngt.InitNextAltTransTypesEntryNo();
                        RegisterMngt.InitializeTempEntry(PostLoan,
                                TempEntry, AvailBalance,
                                FosaAc."Balance (LCY)",
                                TransactionType::"Penalty Due",
                                RepayType::"Penalty Due",
                                MobileDeductionStatus::"Full Deduction", IntDue);
                        TempEntry.Insert(true);

                        if PostInt = 1 then begin

                            Post.CompletePosting(Jtemplate, JBatch);
                            PostLoan."Interest Cycles" := PostLoan."Interest Cycles" + 1;
                            PostLoan.Validate("Interest Due Date", CalcDate('30D', Today));
                            PostLoan.Modify(true);

                            Varvariant := TransTypeEntry;
                            RegMgt.ValuePosting(Varvariant, 0, PostLoan."No.", Today);

                            if CustRec.Get(PostLoan."Account No.") then begin
                                ReminderMessage := 'Dear, ' + PostLoan."Account Name" + ', your ' + PostLoan."Product Description" + 'balance of KES' + Format(PostLoan."Outstanding Balance") + ' has rolled over on ' + Format(PostDate) + '.';
                                SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", CustRec."Mobile Phone No",
                          ReminderMessage + ' ' + MessageTemp, PostLoan."No.", CustRec."No.", false);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure InitializeIntEntry(RecRef: Record Loans; var LoanRecordEntry: Record "Interest Line"; DocNo: Code[20])
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry."Entry No." := InitNextLineEntryNo();
        LoanRecordEntry.CopyFromLoanLines(RecRef);
        LoanRecordEntry.No := DocNo;
        OnAfterInitializeIntEntry(LoanRecordEntry, RecRef);
    end;

    local procedure InitializeProgEntry(RecRef: Record Loans; var LoanRecordEntry: Record "Loan Progression Lines"; DocNo: Code[20])
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry."Entry No." := InitNextEntryNo();
        LoanRecordEntry.CopyFromLoanLines(RecRef);
        LoanRecordEntry.No := DocNo;
    end;

    local procedure InitializeBBFIntEntry(RecRef: Record "Account Credit"; var LoanRecordEntry: Record "Interest Line"; DocNo: Code[20])
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry.CopyFromCreditAccLines(RecRef);
        LoanRecordEntry.No := DocNo;
    end;

    procedure InitializeIntLoanApplicEntry(RecRef: Record "Loan Application"; var LoanRecordEntry: Record "Interest Line"; DocNo: Code[20])
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry.CopyFromLoanApplicationLines(RecRef);
        LoanRecordEntry.No := DocNo;

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitializeIntEntry(var LoanEntry: Record "Interest Line"; Applic: Record Loans)
    begin
    end;


    procedure PostCode(CheckHeader: Record "Checkoff Header"; PostInt: Integer)
    var
        Purchline: Record "Checkoff Receipt Lines";
        EntryNo: Integer;
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
    begin
        CheckHeader.TestField("Posting Date");
        CheckHeader.TestField("Application Type");

        case CheckHeader."Application Type" of

            CheckHeader."Application Type"::"Consolidated Amount":
                begin

                    case PostInt of
                        0:
                            begin
                                exit
                            end;
                        1:
                            begin

                                Purchline.Reset;
                                Purchline.SetRange("No.", CheckHeader."No.");
                                Purchline.SetRange("Account Found", true);
                                Purchline.SetRange(Posted, false);
                                if Purchline.Find('-') then begin
                                    Purchline.TestField("Account Found", true);
                                    if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Generate Batch" then begin
                                        PassDocumentNo;
                                    end;
                                    repeat
                                        if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
                                            PassDocumentNo;
                                        end;

                                        PostPurchLineNoPriority(Purchline, 1, CheckHeader."Posting Date",
                                        CheckHeader.Description, CheckHeader."Account No.",
                                         CheckHeader."Account Type", CheckHeader."Cutoff Date");

                                        if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
                                            Post.CompletePosting(Jtemplate, JBatch);
                                            Commit;
                                            Purchline.Posted := true;
                                            Purchline."Poated By" := UserId;
                                            Purchline."Date Posted" := CurrentDateTime;
                                            Purchline.Modify;
                                        end;

                                    until Purchline.Next = 0;
                                    if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Generate Batch" then begin
                                        VarVariant := CheckHeader;
                                        Commit();
                                        Docx.DocPrintstatement(VarVariant, 0);
                                    end;
                                end
                            end;
                        2:
                            begin
                                PassDocumentNo;
                                Purchline.Reset;
                                Purchline.SetRange("No.", CheckHeader."No.");
                                if Purchline.Find('-') then begin
                                    repeat
                                        EntryNo := PostPurchLineNoPriority(Purchline, 0,
                                        CheckHeader."Posting Date",
                                        CheckHeader.Description, '',
                                        Enum::"Gen. Journal Account Type"::"G/L Account", CheckHeader."Cutoff Date");

                                    until Purchline.Next = 0;
                                    CreateBalancingAcc(EntryNo + 1000,
                                    Jtemplate, JBatch, Dim1, Dim2,
                                    CheckHeader."Scheduled Amount",
                                    CheckHeader."Posting Date",
                                    CheckHeader."No.",
                                    CheckHeader."No.",
                                    CheckHeader."Account No.",
                                    CheckHeader."Account Type",
                                    CheckHeader.Description, '');
                                    if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
                                        Post.CompletePosting(Jtemplate, JBatch);
                                    end;
                                end;
                            end;
                    end;
                end;
            CheckHeader."Application Type"::"Allocated Amount":
                begin
                    case PostInt of
                        0:
                            begin
                                exit
                            end;
                        1:
                            begin

                                Purchline.Reset;
                                Purchline.SetRange("No.", CheckHeader."No.");
                                Purchline.SetRange("Account Found", true);
                                Purchline.SetRange(Posted, false);
                                if Purchline.Find('-') then begin
                                    if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Generate Batch" then begin
                                        PassDocumentNo;
                                    end;
                                    repeat
                                        if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
                                            PassDocumentNo;
                                        end;
                                        PostPurchLineAllocAmount(Purchline, 1, CheckHeader."Posting Date",
                                        CheckHeader.Description, CheckHeader."Account No.",
                                         CheckHeader."Account Type", CheckHeader."Cutoff Date");

                                        if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
                                            Post.CompletePosting(Jtemplate, JBatch);
                                            Commit;
                                            Purchline.Posted := true;
                                            Purchline."Poated By" := UserId;
                                            Purchline."Date Posted" := CurrentDateTime;
                                            Purchline.Modify;
                                        end;
                                    until Purchline.Next = 0;
                                    if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Generate Batch" then begin
                                        VarVariant := CheckHeader;
                                        Commit();
                                        Docx.DocPrintstatement(VarVariant, 0);
                                    end;
                                end
                            end;
                        2:
                            begin
                                PassDocumentNo;
                                Purchline.Reset;
                                Purchline.SetRange("No.", CheckHeader."No.");
                                if Purchline.Find('-') then begin
                                    repeat
                                        EntryNo := PostPurchLineNoPriority(Purchline, 0,
                                        CheckHeader."Posting Date",
                                        CheckHeader.Description, '',
                                        Enum::"Gen. Journal Account Type"::"G/L Account", CheckHeader."Cutoff Date");

                                    until Purchline.Next = 0;
                                    CreateBalancingAcc(EntryNo + 1000,
                                    Jtemplate, JBatch, Dim1, Dim2,
                                    CheckHeader."Scheduled Amount",
                                    CheckHeader."Posting Date",
                                    CheckHeader."No.",
                                    CheckHeader."No.",
                                    CheckHeader."Account No.",
                                    CheckHeader."Account Type",
                                    CheckHeader.Description, '');
                                    if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
                                        Post.CompletePosting(Jtemplate, JBatch);
                                    end;
                                end;
                            end;
                    end;

                end;
        end;
        if CheckHeader."Posting Type" = CheckHeader."Posting Type"::"Post Application" then begin
            CheckHeader.Posted := true;
            CheckHeader."Approval Status" := CheckHeader."Approval Status"::Posted;
            CheckHeader."Posted By" := UserId;
            CheckHeader."Date Posted" := Today;
            CheckHeader.Modify;
        end;


    end;

    procedure PerfomValidate(CheckHeader: Record "Checkoff Header"; PostInt: Integer)
    var
        Purchline: Record "Checkoff Receipt Lines";
        ProgressWindow: Dialog;
    begin
        case PostInt of
            0:
                begin
                    exit
                end;
            1:
                begin
                    Purchline.Reset;
                    Purchline.SetRange("No.", CheckHeader."No.");
                    if Purchline.Find('-') then begin
                        ProgressWindow.Open('Validating Lines #1########################');
                        repeat
                            ProgressWindow.Update(1, Purchline."Upload ID" + ':' + Format(Purchline.Amount));
                            ValidateReceiptsLines(Purchline, Purchline."Upload Response", CheckHeader."Application Type");
                        until Purchline.Next = 0;
                        ProgressWindow.Close
                    end
                end;
            2:
                begin

                end
        end
    end;

    local procedure PassDocumentNo()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        Post.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;

    local procedure CreateJournalTemplate()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        Post.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;

    procedure PostPurchLineNoPriority(Checkline: Record "Checkoff Receipt Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[150]; AccountNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; CutoffDate: Date): Integer
    var
        RunBal: Decimal;
        PLoans: Record Loans;
        LRepayment: Decimal;
        AccBanking: Record "Account Banking";
        AccCred: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        Temp: Record "Banking User Template";
        FProduct: Record "Product Factory";
        FosaBal: Decimal;
        CustAccount: Record Member;
        ShareCapBal: Decimal;
        OutInterest: Decimal;
        CustomerEntry: Record Customer;
        RegistryMngt: Codeunit "Register Management";
        CustAccType: Enum CustAccountType;
        ProdFact: Record "Product Factory";
        StartDate: Date;
        DFilter: Text[100];
        RcptHeader: Record "Checkoff Header";
        AdviceType: Option "Full Amount","Half Amount";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        OutPrinciple: Decimal;
        OutBills: Decimal;
        MonthlyRemittance: Decimal;
        LReshedule: Record "Repayment Schedule";
        ExpInt: Decimal;
        ExpPrinc: Decimal;
        IntialDate: Date;
        LastCheckoffDate: Date;
        DateFilter: Text[150];
        LastMonthDate: Date;
        LoansCategory: Record "Loans Categorization";
        DiffAmt: Decimal;
        DefaultedInt: Boolean;
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        ScheduleAmt: Decimal;
        BlockedAc: Record "Account Banking";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
        RepayAcc: Record "Repayment Account";
        NonExitAccount: Boolean;
        ErrorOnNegatedBalanceTxt: Label 'Loan has an outstanding Interest/Insurance/Bill that is less than zero-%1';

    begin
        RunBal := 0;
        FosaBal := 0;
        MonthlyRemittance := 0;
        OutBills := 0;
        OutPrinciple := 0;
        ShareCapBal := 0;
        ExpInt := 0;
        ExpPrinc := 0;
        ScheduleAmt := 0;
        OutInterest := 0;
        StartDate := 0D;
        NonExitAccount := false;

        DFilter := '..' + Format(CutoffDate);

        RunBal := Checkline.Amount;

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");

        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        CustAccount.Reset();
        CustAccount.SetRange("No.", Checkline."Member No.");
        CustAccount.SetFilter(Status, '%1|%2', CustAccount.Status::Withdrawn, CustAccount.Status::Deceased);
        if CustAccount.Find('-') then begin

            NonExitAccount := true;

            RepayAcc.Reset;
            RepayAcc.SetRange("Member No.", CustAccount."No.");
            RepayAcc.SetRange("Account Category", RepayAcc."Account Category"::Repayment);
            if RepayAcc.FindFirst() then begin
                if RepayAcc.Blocked = RepayAcc.Blocked::All then begin
                    RepayAcc.Blocked := RepayAcc.Blocked::" ";
                    RepayAcc.Modify(true);
                end;
            end;

            RepayAcc.Reset;
            RepayAcc.SetRange("Member No.", CustAccount."No.");
            RepayAcc.SetRange("Account Category", RepayAcc."Account Category"::Repayment);
            if RepayAcc.FindFirst() then begin

                if RunBal > 0 then begin

                    GenJournal.LockTable;
                    Linenum := Linenum + 1000;
                    InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Document No." := Checkline."No.";
                    GenJournal."Source Code" := 'NONMEMBJNL';
                    GenJournal."External Document No." := RepayAcc."Member No.";
                    GenJournal.Validate(Amount, RunBal * -1);
                    GenJournal.Description := CopyStr(RepayAcc."Product Name" + '-' + TextDescription, 1, 100);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);
                    RunBal := RunBal - Abs(GenJournal.Amount);
                end;
            end;
        end;

        if not NonExitAccount then begin

            AccBanking.Reset;
            AccBanking.SetRange("Member No.", Checkline."Member No.");
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            if AccBanking.Find('-') then begin

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", Checkline."Member No.");
                MonthlyContrib.SetRange(Type, MonthlyContrib.Type::Other);
                if MonthlyContrib.Find('-') then begin
                    MonthlyContrib.TestField("Application No.");
                    if MonthlyContrib.Amount > 0 then begin

                        if RunBal > 0 then begin
                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                            GenJournal."Account No." := AccBanking."No.";
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := Checkline."No.";
                            GenJournal."External Document No." := Checkline."Member No.";
                            if MonthlyContrib.Amount > RunBal then
                                GenJournal.Validate(Amount, RunBal)
                            else
                                GenJournal.Validate(Amount, MonthlyContrib.Amount);
                            GenJournal.Description := CopyStr(Format(MonthlyContrib.Type) + '-' + Checkline.Name, 1, 100);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            GenJournal."Bal. Account Type" := GenJournal."Bal. Account Type"::"G/L Account";
                            GenJournal.Validate("Bal. Account No.", MonthlyContrib."Application No.");
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                            RunBal := RunBal - GenJournal.Amount;
                        end;
                    end;
                end;
            end;

            PLoans.SetCurrentKey("No.");
            PLoans.Reset;
            PLoans.SetAscending("No.", true);
            PLoans.SetRange("Account No.", Checkline."Member No.");
            PLoans.SetFilter("Outstanding Insurance", '>0');
            PLoans.SetFilter("Disbursement Date", DFilter);
            PLoans.SetRange("Recovery Mode", PLoans."Recovery Mode"::"Check Off");
            if PLoans.Find('-') then begin
                repeat

                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                    "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");

                    OutInterest := 0;
                    ExpInt := 0;
                    IntialDate := 0D;
                    LastCheckoffDate := 0D;
                    LastMonthDate := 0D;
                    DateFilter := '';

                    OutInterest := PLoans."Outstanding Insurance";

                    case AdviceType of
                        AdviceType::"Full Amount":
                            OutInterest := OutInterest;
                        AdviceType::"Half Amount":
                            OutInterest := (OutInterest / 2);
                    end;

                    if RunBal > 0 then begin

                        GenJournal.LockTable;
                        Linenum := Linenum + 1000;
                        PostPeriodic.InitializeDebitEntry(PLoans,
                        GenJournal, 0, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        Enum::"LoanTransactionType"::"Insurance Paid");
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Document No." := Checkline."No.";
                        if OutInterest > RunBal then
                            GenJournal.Validate(Amount, RunBal * -1) else
                            GenJournal.Validate(Amount, OutInterest * -1);
                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        GenJournal.Validate("Loan No.", PLoans."No.");
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);
                        RunBal := RunBal - Abs(GenJournal.Amount);
                    end;
                until PLoans.Next = 0;
            end;

            PLoans.SetCurrentKey("No.");
            PLoans.Reset;
            PLoans.SetAscending("No.", true);
            PLoans.SetRange("Account No.", Checkline."Member No.");
            PLoans.SetFilter("Outstanding Interest", '>0');
            PLoans.SetFilter("Disbursement Date", DFilter);
            PLoans.SetRange("Recovery Mode", PLoans."Recovery Mode"::"Check Off");
            if PLoans.Find('-') then begin
                repeat

                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                    "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");

                    OutInterest := 0;
                    ExpInt := 0;
                    IntialDate := 0D;
                    LastCheckoffDate := 0D;
                    LastMonthDate := 0D;
                    DateFilter := '';

                    OutInterest := PLoans."Outstanding Interest";

                    case AdviceType of
                        AdviceType::"Full Amount":
                            OutInterest := OutInterest;
                        AdviceType::"Half Amount":
                            OutInterest := (OutInterest / 2);
                    end;

                    if RunBal > 0 then begin

                        GenJournal.LockTable;
                        Linenum := Linenum + 1000;
                        PostPeriodic.InitializeDebitEntry(PLoans,
                        GenJournal, 0,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        Enum::"LoanTransactionType"::"Interest Paid");
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Document No." := Checkline."No.";
                        if OutInterest > RunBal then
                            GenJournal.Validate(Amount, RunBal * -1) else
                            GenJournal.Validate(Amount, OutInterest * -1);
                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        GenJournal.Validate("Loan No.", PLoans."No.");
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);
                        RunBal := RunBal - Abs(GenJournal.Amount);
                    end;
                until PLoans.Next = 0;
            end;


            PLoans.SetCurrentKey("No.");
            PLoans.Reset;
            PLoans.SetAscending("No.", true);
            PLoans.SetRange("Account No.", Checkline."Member No.");
            PLoans.SetFilter("Outstanding Bill", '>0');
            PLoans.SetFilter("Disbursement Date", DFilter);
            PLoans.SetRange("Recovery Mode", PLoans."Recovery Mode"::"Check Off");
            if PLoans.Find('-') then begin
                repeat
                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                    "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");

                    OutBills := 0;
                    OutBills := PLoans."Outstanding Bill";
                    case AdviceType of

                        AdviceType::"Full Amount":
                            OutBills := PLoans."Outstanding Bill";
                        AdviceType::"Half Amount":
                            OutBills := (PLoans."Outstanding Bill" / 2);
                    end;

                    if RunBal > 0 then begin

                        GenJournal.LockTable;
                        Linenum := Linenum + 1000;
                        PostPeriodic.InitializeDebitEntry(PLoans, GenJournal, 0,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        Enum::"LoanTransactionType"::"Penalty Paid");
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Document No." := Checkline."No.";
                        if OutBills > RunBal then
                            GenJournal.Validate(Amount, RunBal * -1) else
                            GenJournal.Validate(Amount, OutBills * -1);
                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        GenJournal.Validate("Loan No.", PLoans."No.");
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);

                        RunBal := RunBal - Abs(GenJournal.Amount);
                    end;
                until PLoans.Next = 0;
            end;

            PLoans.SetCurrentKey("No.");

            PLoans.Reset;
            PLoans.SetAscending("No.", true);
            PLoans.SetRange("Account No.", Checkline."Member No.");
            PLoans.SetFilter("Outstanding Principal", '>0');
            PLoans.SetFilter("Disbursement Date", DFilter);
            PLoans.SetRange("Recovery Mode", PLoans."Recovery Mode"::"Check Off");
            PLoans.SetRange("Interest Defaulted", false);
            if PLoans.Find('-') then begin
                repeat
                    if RunBal > 0 then begin

                        PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                        "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");

                        OutInterest := 0;
                        LRepayment := 0;
                        ScheduleAmt := 0;

                        if PLoans."Outstanding Bill" < 0 then
                            Error(ErrorOnNegatedBalanceTxt, PLoans."No.");

                        if (PLoans."Outstanding Interest" < 0) or (PLoans."Outstanding Insurance" < 0) then
                            Error(ErrorOnNegatedBalanceTxt, PLoans."No.");

                        LRepayment := (PLoans.Repayment - (PLoans."Outstanding Interest" + PLoans."Outstanding Insurance" + PLoans."Outstanding Bill"));

                        if LRepayment < 0 then
                            LRepayment := 0;

                        if LRepayment >= PLoans."Outstanding Principal" then
                            LRepayment := PLoans."Outstanding Principal" else
                            LRepayment := LRepayment;

                        case AdviceType of
                            AdviceType::"Full Amount":
                                begin
                                    LRepayment := LRepayment;
                                end;
                            AdviceType::"Half Amount":
                                begin
                                    LRepayment := (LRepayment / 2);
                                end;
                        end;

                        GenJournal.LockTable;
                        Linenum := Linenum + 1000;
                        PostPeriodic.InitializeDebitEntry(PLoans, GenJournal, 0,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        Enum::"LoanTransactionType"::Repayment);
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Document No." := Checkline."No.";
                        if LRepayment >= RunBal then
                            GenJournal.Validate(Amount, RunBal * -1) else
                            GenJournal.Validate(Amount, LRepayment * -1);
                        GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::Repayment) + '-' + TextDescription, 1, 100);
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        GenJournal.Validate("Loan No.", PLoans."No.");
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);
                        RunBal := RunBal - Abs(GenJournal.Amount);
                    end;
                until PLoans.Next = 0;
            end;

            AccCred.Reset;
            AccCred.SetRange("Member No.", Checkline."Member No.");
            AccCred.SetRange(Blocked, AccCred.Blocked::" ");
            AccCred.SetRange("Account Category", AccCred."Account Category"::"Registration Fee");
            if AccCred.Find('-') then begin

                if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > 0 then begin
                    if not AccCred."Registration Fee Paid" then begin

                        CustomerEntry.Reset();
                        CustomerEntry.SetRange("No.", AccCred."No.");
                        if not CustomerEntry.FindFirst() then begin
                            RegistryMngt.fnCreateCustMemberPostAc(AccCred."No.",
                             AccCred.Name, AccCred."Mobile No.", AccCred."Global Dimension 1 Code",
                                    AccCred."Global Dimension 2 Code", AccCred."Customer Posting Group",
                                    '', AccCred.Status, AccCred."Product Type", AccCred."ID/Passport No.",
                                     AccCred."Member No.", CustAccType::"Credit Account",
                                     ProdFact."Account Dimension", ProdFact."Account Category");
                        end;

                        if RunBal > 0 then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := Checkline."No.";
                            GenJournal.Validate("Account No.", AccCred."No.");
                            if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > RunBal then
                                GenJournal.Validate(Amount, RunBal * -1) else
                                GenJournal.Validate(Amount, getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") * -1);
                            GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                            RunBal := RunBal - Abs(GenJournal.Amount)
                        end;
                    end;
                end;
            end;

            AccCred.Reset;
            AccCred.SetRange("Member No.", Checkline."Member No.");
            AccCred.SetRange(Blocked, AccCred.Blocked::" ");
            AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Capital");
            if AccCred.Find('-') then begin
                AccCred.CalcFields("Balance (LCY)");
                if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > 0 then begin
                    if ProdFact.Get(AccCred."Product Type") then
                        if ProdFact."Enforce Min. Share Rule" then begin

                            if RunBal > 0 then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                GenJournal.Validate("Account No.", AccCred."No.");
                                if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") * -1);
                                GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);
                                ShareCapBal := Abs(GenJournal.Amount);
                            end;
                        end;
                end;
            end else begin
                Error(ErrorOnNotAccountFound, Checkline."Member No.", AccCred."Account Category")
            end;

            AccCred.Reset;
            AccCred.SetRange("Member No.", Checkline."Member No.");
            AccCred.SetRange(Blocked, AccCred.Blocked::" ");
            AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Capital");
            if AccCred.Find('-') then begin

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Application No.", AccCred."No.");
                MonthlyContrib.SetRange("Account No.", AccCred."Member No.");
                MonthlyContrib.SetRange(Type, AccCred."Account Category");
                if MonthlyContrib.Find('-') then begin
                    if ProdFact.Get(AccCred."Product Type") then
                        if MonthlyContrib.Amount > 0 then begin

                            if RunBal > 0 then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                GenJournal.Validate("Account No.", AccCred."No.");
                                if AdviceType = AdviceType::"Half Amount" then begin
                                    if (MonthlyContrib.Amount / 2) > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                                end else begin
                                    if MonthlyContrib.Amount > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                                end;
                                GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount)
                            end;
                        end;
                end;
            end else begin
                Error(ErrorOnNotAccountFound, Checkline."Member No.", AccCred."Account Category")
            end;


            AccCred.Reset;
            AccCred.SetRange("Member No.", Checkline."Member No.");
            AccCred.SetRange(Blocked, AccCred.Blocked::" ");
            AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
            if AccCred.Find('-') then begin

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Application No.", AccCred."No.");
                MonthlyContrib.SetRange("Account No.", AccCred."Member No.");
                MonthlyContrib.SetRange(Type, AccCred."Account Category");
                if MonthlyContrib.Find('-') then begin
                    if ProdFact.Get(AccCred."Product Type") then
                        if MonthlyContrib.Amount > 0 then begin

                            if RunBal > 0 then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                GenJournal.Validate("Account No.", AccCred."No.");
                                if AdviceType = AdviceType::"Half Amount" then begin
                                    if (MonthlyContrib.Amount / 2) > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                                end else begin
                                    if MonthlyContrib.Amount > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                                end;
                                GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount)
                            end;
                        end;
                end;
            end else begin
                Error(ErrorOnNotAccountFound, Checkline."Member No.", AccCred."Account Category")
            end;

            AccBanking.Reset;
            AccBanking.SetRange("Member No.", Checkline."Member No.");
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Junior);
            if AccBanking.Find('-') then begin
                repeat

                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", AccBanking."Member No.");
                    MonthlyContrib.SetRange(Type, AccBanking."Account Category");
                    if MonthlyContrib.Find('-') then begin

                        ProdFact.Get(AccBanking."Product Type");
                        if MonthlyContrib.Amount > 0 then begin

                            if RunBal > 0 then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                GenJournal.Validate("Account No.", AccBanking."No.");
                                if AdviceType = AdviceType::"Half Amount" then begin
                                    if (MonthlyContrib.Amount / 2) > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                                end else begin
                                    if MonthlyContrib.Amount > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                                end;
                                GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);
                            end;
                        end;
                    end;
                until AccBanking.Next = 0;
            end;

            AccBanking.Reset;
            AccBanking.SetRange("Member No.", Checkline."Member No.");
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Money Market");
            if AccBanking.Find('-') then begin

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Application No.", AccBanking."No.");
                MonthlyContrib.SetRange("Account No.", AccBanking."Member No.");
                MonthlyContrib.SetRange(Type, AccBanking."Account Category");
                if MonthlyContrib.Find('-') then begin

                    ProdFact.Get(AccBanking."Product Type");
                    if MonthlyContrib.Amount > 0 then begin

                        if RunBal > 0 then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := Checkline."No.";
                            GenJournal.Validate("Account No.", AccBanking."No.");
                            if AdviceType = AdviceType::"Half Amount" then begin
                                if (MonthlyContrib.Amount / 2) > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                            end else begin
                                if MonthlyContrib.Amount > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                            end;
                            GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + TextDescription, 1, 100);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                            RunBal := RunBal - Abs(GenJournal.Amount)
                        end;
                    end;
                end;
            end;

            AccBanking.Reset;
            AccBanking.SetRange("Member No.", Checkline."Member No.");
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
            if AccBanking.Find('-') then begin

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Application No.", AccBanking."No.");
                MonthlyContrib.SetRange("Account No.", AccBanking."Member No.");
                MonthlyContrib.SetRange(Type, AccBanking."Account Category");
                if MonthlyContrib.Find('-') then begin
                    ProdFact.Get(AccBanking."Product Type");
                    if MonthlyContrib.Amount > 0 then begin

                        if RunBal > 0 then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := Checkline."No.";
                            GenJournal.Validate("Account No.", AccBanking."No.");
                            if AdviceType = AdviceType::"Half Amount" then begin
                                if (MonthlyContrib.Amount / 2) > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                            end else begin
                                if MonthlyContrib.Amount > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                            end;
                            GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + TextDescription, 1, 100);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                            RunBal := RunBal - Abs(GenJournal.Amount)
                        end;
                    end;
                end;
            end;

            MonthlyContrib.Reset();
            MonthlyContrib.SetRange("Account No.", Checkline."Member No.");
            MonthlyContrib.SetRange(Type, MonthlyContrib.Type::KinAccount);
            if MonthlyContrib.Find('-') then begin
                if MonthlyContrib.Amount > 0 then begin

                    if RunBal > 0 then begin

                        AccCred.Reset;
                        AccCred.SetRange("No.", MonthlyContrib."Application No.");
                        AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                        if AccCred.Find('-') then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := Checkline."No.";
                            GenJournal.Validate("Account No.", AccCred."No.");
                            if AdviceType = AdviceType::"Half Amount" then begin
                                if (MonthlyContrib.Amount / 2) > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                            end else begin
                                if MonthlyContrib.Amount > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                            end;

                            GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                            RunBal := RunBal - Abs(GenJournal.Amount)

                        end else begin

                            AccBanking.Reset;
                            AccBanking.SetRange("No.", MonthlyContrib."Application No.");
                            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
                            if AccBanking.Find('-') then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                                GenJournal."External Document No." := AccBanking."Member No.";
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                if AdviceType = AdviceType::"Half Amount" then begin
                                    if (MonthlyContrib.Amount / 2) > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, (MonthlyContrib.Amount / 2) * -1);

                                end else begin
                                    if MonthlyContrib.Amount > RunBal then
                                        GenJournal.Validate(Amount, RunBal * -1) else
                                        GenJournal.Validate(Amount, MonthlyContrib.Amount * -1);
                                end;
                                GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount)
                            end
                        end
                    end;
                end;
            end;

            AccBanking.Reset;
            AccBanking.SetRange("Member No.", Checkline."Member No.");
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::"Specialty Savings");
            if AccBanking.Find('-') then begin

                if RunBal > 0 then begin

                    GenJournal.LockTable;
                    Linenum := Linenum + 100070;
                    InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Document No." := Checkline."No.";
                    GenJournal."Source Code" := 'EXCSAMTJNL';
                    GenJournal."External Document No." := AccBanking."Member No.";
                    GenJournal.Validate(Amount, RunBal * -1);
                    GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + TextDescription, 1, 100);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);
                end;
            end else begin
                Error(ErrorOnNotAccountFound, Checkline."Member No.", AccBanking."Account Category")
            end;
        end;

        case PostInt of
            1:
                begin
                    Linenum := Linenum + 1000;
                    CreateBalancingAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2,
                    Checkline.Amount, PostingDate,
                    Checkline."No.",
                    Checkline."Member No.",
                    RcptHeader."Account No.", RcptHeader."Account Type",
                    CopyStr(Checkline.Name + '-' + TextDescription, 1, 100), '');
                end;
        end;
        exit(Linenum)
    end;

    procedure PostPurchLineAllocAmount(Checkline: Record "Checkoff Receipt Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[150]; AccountNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; CutoffDate: Date): Integer
    var
        RunBal: Decimal;
        PLoans: Record Loans;
        LRepayment: Decimal;
        AccBanking: Record "Account Banking";
        AccCred: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        Temp: Record "Banking User Template";
        FProduct: Record "Product Factory";
        FosaBal: Decimal;
        CustAccount: Record Member;
        ShareCapBal: Decimal;
        OutInterest: Decimal;
        CustomerEntry: Record Customer;
        RegistryMngt: Codeunit "Register Management";
        CustAccType: Enum CustAccountType;
        ProdFact: Record "Product Factory";
        StartDate: Date;
        DFilter: Text[100];
        RcptHeader: Record "Checkoff Header";
        AdviceType: Option "Full Amount","Half Amount";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        OutPrinciple: Decimal;
        OutBills: Decimal;
        MonthlyRemittance: Decimal;
        LReshedule: Record "Repayment Schedule";
        ExpInt: Decimal;
        ExpPrinc: Decimal;
        IntialDate: Date;
        LastCheckoffDate: Date;
        DateFilter: Text[150];
        LastMonthDate: Date;
        LoansCategory: Record "Loans Categorization";
        DiffAmt: Decimal;
        DefaultedInt: Boolean;
        ScheduleAmt: Decimal;
        VendAc: Record Vendor;
        BlockedAc: Record "Account Banking";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
        RepayAcc: Record "Repayment Account";
        JnlMgt: Codeunit "Journal Post Mngt.";
        NonExitAccount: Boolean;
        ErrorOnNegatedBalanceTxt: Label 'Loan has an outstanding Interest/Insurance/Bill that is less than zero-%1';

    begin
        RunBal := 0;
        FosaBal := 0;
        MonthlyRemittance := 0;
        OutBills := 0;
        OutPrinciple := 0;
        ShareCapBal := 0;
        ExpInt := 0;
        ExpPrinc := 0;
        ScheduleAmt := 0;
        OutInterest := 0;
        StartDate := 0D;
        NonExitAccount := false;

        DFilter := '..' + Format(CutoffDate);

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");

        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        if Checkline.Amount > 0 then begin

            RepayAcc.Reset;
            RepayAcc.SetRange("No.", Checkline."Repayment Account");
            if RepayAcc.FindFirst() then begin
                if not VendAc.Get(RepayAcc."No.") then begin
                    CreateRepayAc(RepayAcc."No.");
                end;
            end;

            RunBal := Checkline.Amount;
            case PostInt of
                1:
                    begin
                        Linenum := Linenum + 1000;
                        CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2, Checkline.Amount, PostingDate,
                        Checkline."No.", Checkline."Member No.", RcptHeader."Account No.", RcptHeader."Account Type",
                        CopyStr(Checkline.Name + '-' + TextDescription, 1, 100), '');
                    end;
            end;

            RepayAcc.Reset;
            RepayAcc.SetRange("No.", Checkline."Repayment Account");
            if RepayAcc.FindFirst() then begin

                Linenum := Linenum + 1000;
                Post.PostJournal(Jtemplate, JBatch, Linenum,
                Enum::"Gen. Journal Account Type"::Vendor, Checkline."No.",
                CopyStr(TextDescription, 1, 100), (Checkline.Amount * -1), RepayAcc."No.",
                PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                RepayAcc."Member No.", Dim1, Dim2, Enum::"LoanTransactionType"::" ", '', '', '',
                Enum::"Gen. Journal Document Type"::" ", RepayAcc."Currency Code",
                Enum::"Gen. Journal Document Type"::" ");
            end;

            CustAccount.Reset();
            CustAccount.SetRange("No.", Checkline."Member No.");
            CustAccount.SetFilter(Status, '%1|%2', CustAccount.Status::Withdrawn, CustAccount.Status::Deceased);
            if CustAccount.Find('-') then begin
                NonExitAccount := true;
            end;

            if not NonExitAccount then begin

                case Checkline."Account Dimension" of
                    Checkline."Account Dimension"::Credit,
                    Checkline."Account Dimension"::"Micro Credit":
                        begin
                            AccCred.Reset;
                            AccCred.SetRange("No.", Checkline."Account No.");
                            AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                            AccCred.SetRange("Account Category", Checkline."Account Category");
                            if AccCred.FindFirst() then begin

                                CustomerEntry.Reset();
                                CustomerEntry.SetRange("No.", AccCred."No.");
                                if not CustomerEntry.FindFirst() then begin
                                    RegistryMngt.fnCreateCustMemberPostAc(AccCred."No.",
                                     AccCred.Name, AccCred."Mobile No.", AccCred."Global Dimension 1 Code",
                                            AccCred."Global Dimension 2 Code", AccCred."Customer Posting Group",
                                            '', AccCred.Status, AccCred."Product Type", AccCred."ID/Passport No.",
                                             AccCred."Member No.", CustAccType::"Credit Account",
                                             ProdFact."Account Dimension", ProdFact."Account Category");
                                end;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                GenJournal.Validate("Account No.", AccCred."No.");
                                GenJournal.Validate(Amount, Checkline.Amount * -1);
                                GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);


                                RepayAcc.Reset;
                                RepayAcc.SetRange("No.", Checkline."Repayment Account");
                                if RepayAcc.FindFirst() then begin

                                    GenJournal.LockTable;
                                    Linenum := Linenum + 1000;
                                    InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := PostingDate;
                                    GenJournal."Document No." := Checkline."No.";
                                    GenJournal.Validate(Amount, Checkline.Amount);
                                    GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);
                                end;

                            end else begin
                                Error(ErrorOnNotAccountFound, Checkline."Member No.", AccCred."Account Category")
                            end;
                        end;
                    Checkline."Account Dimension"::Banking:
                        begin

                            AccBanking.Reset;
                            AccBanking.SetRange("No.", Checkline."Account No.");
                            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
                            AccBanking.SetRange("Account Category", Checkline."Account Category");
                            if AccBanking.FindFirst() then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal."Account No." := AccBanking."No.";
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline."No.";
                                GenJournal."External Document No." := Checkline."Member No.";
                                GenJournal.Validate(Amount, CheckLine.Amount * -1);
                                GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + Checkline.Name, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                                RepayAcc.Reset;
                                RepayAcc.SetRange("No.", Checkline."Repayment Account");
                                if RepayAcc.FindFirst() then begin

                                    GenJournal.LockTable;
                                    Linenum := Linenum + 1000;
                                    InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := PostingDate;
                                    GenJournal."Document No." := Checkline."No.";
                                    GenJournal.Validate(Amount, Checkline.Amount);
                                    GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);
                                end;

                            end else begin
                                Error(ErrorOnNotAccountFound, Checkline."Member No.", AccCred."Account Category")
                            end;
                        end;
                    Checkline."Account Dimension"::Loan:
                        begin
                            Checkline.TestField("Account No.");
                            case Checkline."Transaction Type" of
                                Checkline."Transaction Type"::" ":
                                    begin
                                        PLoans.SetCurrentKey("No.");
                                        PLoans.Reset;
                                        PLoans.SetAscending("No.", true);
                                        PLoans.SetRange("No.", Checkline."Loan No.");
                                        PLoans.SetRange("Account No.", Checkline."Member No.");
                                        PLoans.SetFilter("Outstanding Balance", '>0');
                                        PLoans.SetRange("Recovery Mode", PLoans."Recovery Mode"::"Check Off");
                                        if PLoans.Find('-') then begin

                                            PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                            "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
                                            if PLoans."Outstanding Interest" > 0 then begin

                                                OutInterest := 0;
                                                OutInterest := PLoans."Outstanding Interest";
                                                if RunBal > 0 then begin

                                                    GenJournal.LockTable;
                                                    Linenum := Linenum + 1000;
                                                    PostPeriodic.InitializeDebitEntry(PLoans,
                                                    GenJournal, 0, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                                    Enum::"LoanTransactionType"::"Interest Paid");
                                                    GenJournal."Line No." := Linenum;
                                                    GenJournal."Journal Template Name" := Jtemplate;
                                                    GenJournal."Journal Batch Name" := JBatch;
                                                    GenJournal."Posting Date" := PostingDate;
                                                    GenJournal."Document No." := Checkline."No.";
                                                    if OutInterest > RunBal then
                                                        GenJournal.Validate(Amount, RunBal * -1)
                                                    else
                                                        GenJournal.Validate(Amount, OutInterest * -1);
                                                    GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + TextDescription, 1, 100);
                                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                    GenJournal.Validate("Loan No.", PLoans."No.");
                                                    if GenJournal.Amount <> 0 then
                                                        GenJournal.Insert(true);
                                                    RunBal := RunBal - Abs(GenJournal.Amount);

                                                    RepayAcc.Reset;
                                                    RepayAcc.SetRange("No.", Checkline."Repayment Account");
                                                    if RepayAcc.FindFirst() then begin

                                                        GenJournal.LockTable;
                                                        Linenum := Linenum + 1000;
                                                        InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                                                        GenJournal."Line No." := Linenum;
                                                        GenJournal."Journal Template Name" := Jtemplate;
                                                        GenJournal."Journal Batch Name" := JBatch;
                                                        GenJournal."Posting Date" := PostingDate;
                                                        GenJournal."Document No." := Checkline."No.";
                                                        // GenJournal."Source Code" := RepayAcc."No.";
                                                        if OutInterest > RunBal then
                                                            GenJournal.Validate(Amount, RunBal) else
                                                            GenJournal.Validate(Amount, OutInterest);
                                                        GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + TextDescription, 1, 100);
                                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                        if GenJournal.Amount <> 0 then
                                                            GenJournal.Insert(true);
                                                        RunBal := RunBal - Abs(GenJournal.Amount);
                                                    end;

                                                end;
                                            end;
                                            if RunBal > 0 then begin
                                                if PLoans."Outstanding Principal" > 0 then begin

                                                    LRepayment := 0;
                                                    ScheduleAmt := 0;

                                                    /* if PLoans."Outstanding Bill" < 0 then
                                                        Error(ErrorOnNegatedBalanceTxt, PLoans."No.");

                                                    if (PLoans."Outstanding Interest" < 0) or (PLoans."Outstanding Insurance" < 0) then
                                                        Error(ErrorOnNegatedBalanceTxt, PLoans."No.");
 */
                                                    LRepayment := (PLoans.Repayment - (PLoans."Outstanding Interest" + PLoans."Outstanding Insurance" + PLoans."Outstanding Bill"));

                                                    if LRepayment < 0 then
                                                        LRepayment := 0;

                                                    if LRepayment >= PLoans."Outstanding Principal" then
                                                        LRepayment := PLoans."Outstanding Principal" else
                                                        LRepayment := LRepayment;

                                                    GenJournal.LockTable;
                                                    Linenum := Linenum + 1000;
                                                    PostPeriodic.InitializeDebitEntry(PLoans, GenJournal, 0,
                                                    Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                                    Enum::"LoanTransactionType"::Repayment);
                                                    GenJournal."Line No." := Linenum;
                                                    GenJournal."Journal Template Name" := Jtemplate;
                                                    GenJournal."Journal Batch Name" := JBatch;
                                                    GenJournal."Posting Date" := PostingDate;
                                                    GenJournal."Document No." := Checkline."No.";
                                                    if LRepayment >= RunBal then
                                                        GenJournal.Validate(Amount, RunBal * -1) else
                                                        GenJournal.Validate(Amount, LRepayment * -1);
                                                    GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::Repayment) + '-' + TextDescription, 1, 100);
                                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                    GenJournal.Validate("Loan No.", PLoans."No.");
                                                    if GenJournal.Amount <> 0 then
                                                        GenJournal.Insert(true);
                                                    RunBal := RunBal - Abs(GenJournal.Amount);

                                                    RepayAcc.Reset;
                                                    RepayAcc.SetRange("No.", Checkline."Repayment Account");
                                                    if RepayAcc.FindFirst() then begin

                                                        GenJournal.LockTable;
                                                        Linenum := Linenum + 1000;
                                                        InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                                                        GenJournal."Line No." := Linenum;
                                                        GenJournal."Journal Template Name" := Jtemplate;
                                                        GenJournal."Journal Batch Name" := JBatch;
                                                        GenJournal."Posting Date" := PostingDate;
                                                        GenJournal."Document No." := Checkline."No.";
                                                        // GenJournal."Source Code" := RepayAcc."No.";
                                                        if LRepayment >= RunBal then
                                                            GenJournal.Validate(Amount, RunBal) else
                                                            GenJournal.Validate(Amount, LRepayment);
                                                        GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::Repayment) + '-' + TextDescription, 1, 100);
                                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                        if GenJournal.Amount <> 0 then
                                                            GenJournal.Insert(true);
                                                    end;
                                                    RunBal := RunBal - Abs(GenJournal.Amount);
                                                end
                                            end;
                                        end;
                                    end else begin

                                    PLoans.SetCurrentKey("No.");
                                    PLoans.Reset;
                                    PLoans.SetAscending("No.", true);
                                    PLoans.SetRange("No.", Checkline."Loan No.");
                                    PLoans.SetRange("Account No.", Checkline."Member No.");
                                    if PLoans.Find('-') then begin

                                        PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                        "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");

                                        if Checkline."Interest Repayment" > 0 then begin

                                            if PLoans."Outstanding Interest" > 0 then begin

                                                OutInterest := 0;
                                                OutInterest := Checkline."Interest Repayment";

                                                if OutInterest >= PLoans."Outstanding Interest" then
                                                    OutInterest := PLoans."Outstanding Interest";

                                                GenJournal.LockTable;
                                                Linenum := Linenum + 1000;
                                                PostPeriodic.InitializeDebitEntry(PLoans,
                                                GenJournal, 0, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                                Enum::"LoanTransactionType"::"Interest Paid");
                                                GenJournal."Line No." := Linenum;
                                                GenJournal."Journal Template Name" := Jtemplate;
                                                GenJournal."Journal Batch Name" := JBatch;
                                                GenJournal."Posting Date" := PostingDate;
                                                GenJournal."Document No." := Checkline."No.";
                                                if OutInterest > Checkline."Interest Repayment" then
                                                    GenJournal.Validate(Amount, Checkline."Interest Repayment" * -1) else
                                                    GenJournal.Validate(Amount, OutInterest * -1);
                                                GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + TextDescription, 1, 100);
                                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                GenJournal.Validate("Loan No.", PLoans."No.");
                                                if GenJournal.Amount <> 0 then
                                                    GenJournal.Insert(true);


                                                RepayAcc.Reset;
                                                RepayAcc.SetRange("No.", Checkline."Repayment Account");
                                                if RepayAcc.FindFirst() then begin

                                                    GenJournal.LockTable;
                                                    Linenum := Linenum + 1000;
                                                    InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                                                    GenJournal."Line No." := Linenum;
                                                    GenJournal."Journal Template Name" := Jtemplate;
                                                    GenJournal."Journal Batch Name" := JBatch;
                                                    GenJournal."Posting Date" := PostingDate;
                                                    GenJournal."Document No." := Checkline."No.";
                                                    GenJournal.Validate(Amount, Abs(GenJournal.Amount));
                                                    GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + TextDescription, 1, 100);
                                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                    if GenJournal.Amount <> 0 then
                                                        GenJournal.Insert(true);
                                                    RunBal := RunBal - Abs(GenJournal.Amount);
                                                end;
                                            end;
                                        end;

                                        if Checkline."Principle Repayment" > 0 then begin

                                            if PLoans."Outstanding Principal" > 0 then begin
                                                LRepayment := Checkline."Principle Repayment";

                                                if LRepayment < 0 then
                                                    LRepayment := 0;

                                                if LRepayment >= PLoans."Outstanding Principal" then
                                                    LRepayment := PLoans."Outstanding Principal" else
                                                    LRepayment := LRepayment;

                                                GenJournal.LockTable;
                                                Linenum := Linenum + 1000;
                                                PostPeriodic.InitializeDebitEntry(PLoans, GenJournal, 0,
                                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                                Enum::"LoanTransactionType"::Repayment);
                                                GenJournal."Line No." := Linenum;
                                                GenJournal."Journal Template Name" := Jtemplate;
                                                GenJournal."Journal Batch Name" := JBatch;
                                                GenJournal."Posting Date" := PostingDate;
                                                GenJournal."Document No." := Checkline."No.";

                                                if LRepayment >= Checkline."Principle Repayment" then
                                                    GenJournal.Validate(Amount, Checkline."Principle Repayment" * -1) else
                                                    GenJournal.Validate(Amount, LRepayment * -1);

                                                GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::Repayment) + '-' + TextDescription, 1, 100);
                                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                GenJournal.Validate("Loan No.", PLoans."No.");
                                                if GenJournal.Amount <> 0 then
                                                    GenJournal.Insert(true);

                                                RepayAcc.Reset;
                                                RepayAcc.SetRange("No.", Checkline."Repayment Account");
                                                if RepayAcc.FindFirst() then begin

                                                    GenJournal.LockTable;
                                                    Linenum := Linenum + 1000;
                                                    InitPost.InitializeRepayAccEntry(RepayAcc, GenJournal, 0);
                                                    GenJournal."Line No." := Linenum;
                                                    GenJournal."Journal Template Name" := Jtemplate;
                                                    GenJournal."Journal Batch Name" := JBatch;
                                                    GenJournal."Posting Date" := PostingDate;
                                                    GenJournal."Document No." := Checkline."No.";
                                                    GenJournal.Validate(Amount, Abs(GenJournal.Amount));
                                                    GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::Repayment) + '-' + TextDescription, 1, 100);
                                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                    if GenJournal.Amount <> 0 then
                                                        GenJournal.Insert(true);
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                end;
            end;
        end;
        exit(Linenum)
    end;

    procedure getAccountMinBalance(MemberNo: Code[20]; Prod: Code[10]): Decimal
    var
        AccCred: Record "Account Credit";
        ProductFactory: Record "Product Factory";
        AccBal: array[2] of Decimal;
    begin

        AccCred.Reset;
        AccCred.SetRange("Member No.", MemberNo);
        AccCred.SetRange("Product Type", Prod);
        if AccCred.Find('-') then begin
            AccCred.CalcFields("Balance (LCY)");

            if ProductFactory.Get(AccCred."Product Type") then begin
                ProductFactory.TestField("Minimum Balance");

                if AccCred."Balance (LCY)" < ProductFactory."Minimum Balance" then
                    AccBal[1] := (ProductFactory."Minimum Balance" - AccCred."Balance (LCY)") else
                    AccBal[1] := 0
            end;
        end;
        exit(AccBal[1])
    end;


    procedure CreateBalancingAcc(LineNo: Integer; JTemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal; PDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; AccNo: Code[20]; AccType: Enum "Gen. Journal Account Type"; DescriptText: Text[150]; CurrCode: Code[20])
    begin
        Post.PostJournal(JTemplate, JBatch,
        LineNo, AccType, DocNo, DescriptText,
        Amt, AccNo, PDate,
        Enum::"Gen. Journal Account Type"::"G/L Account", '',
        ExtDocNo, Dim1, Dim2,
        Enum::"LoanTransactionType"::" ", '', '', '',
        Enum::"Gen. Journal Document Type"::" ", CurrCode,
        Enum::"Gen. Journal Document Type"::" ")
    end;

    procedure ValidateReceiptsLines(CheckLine: Record "Checkoff Receipt Lines"; Responce: Integer; ApplicType: Enum CheckoffTypes)
    var
        CustRecord: Record Member;
        RepayAcc: Record "Repayment Account";
        CredAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
    begin
        CheckLine.fncheckRequiredItems;

        case ApplicType of

            ApplicType::"Consolidated Amount":
                begin

                    case
                    Responce of
                        0:
                            begin
                                Error('Option does not exist')
                            end;
                        1:
                            begin
                                CustRecord.Reset;
                                CustRecord.SetRange("No.", CheckLine."Upload ID");
                                if CustRecord.Find('-') then begin
                                    CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                    CheckLine."Member No." := CustRecord."No.";
                                    CheckLine.Name := CustRecord.Name;
                                    CheckLine."ID No." := CustRecord."ID No.";
                                    CheckLine.Status := CustRecord.Status;
                                    CheckLine.Blocked := CustRecord.Blocked;
                                    CheckLine."Repayment Account" := getPrepaymentAc(CheckLine."Member No.");
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                    CheckLine.Modify;
                                end;
                            end;
                        2:
                            begin
                                CustRecord.Reset;
                                CustRecord.SetRange("ID No.", CheckLine."Upload ID");
                                if CustRecord.Find('-') then begin
                                    CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                    CheckLine."Member No." := CustRecord."No.";
                                    CheckLine."ID No." := CustRecord."ID No.";
                                    CheckLine.Name := CustRecord.Name;
                                    CheckLine.Status := CustRecord.Status;
                                    CheckLine."Repayment Account" := getPrepaymentAc(CheckLine."Member No.");
                                    CheckLine.Blocked := CustRecord.Blocked;
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                    CheckLine.Modify
                                end;
                            end;
                        3:
                            begin
                                CustRecord.Reset;
                                CustRecord.SetRange("Payroll/Staff No.", CheckLine."Upload ID");
                                CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                if CustRecord.Find('-') then begin
                                    CheckLine."Member No." := CustRecord."No.";
                                    CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                    CheckLine.Name := CustRecord.Name;
                                    CheckLine."ID No." := CustRecord."ID No.";
                                    CheckLine.Status := CustRecord.Status;
                                    CheckLine.Blocked := CustRecord.Blocked;
                                    CheckLine."Repayment Account" := getPrepaymentAc(CheckLine."Member No.");
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;

                                    CredAccount.Reset();
                                    CredAccount.SetRange("Member No.", CustRecord."No.");
                                    CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Deposit");
                                    if CredAccount.FindFirst() then begin
                                        CheckLine."Account No." := CredAccount."No.";
                                        CheckLine."Product Type" := CredAccount."Product Type";
                                        CheckLine."Account Category" := CredAccount."Account Category";
                                    end;

                                    CheckLine.Modify
                                end;
                            end;
                        4:
                            begin
                                RepayAcc.Reset;
                                RepayAcc.SetRange("No.", CheckLine."Upload ID");
                                if RepayAcc.Find('-') then begin
                                    CheckLine."Account No." := RepayAcc."No.";
                                    CheckLine.Status := RepayAcc.Status;
                                    CheckLine.Blocked := RepayAcc.Blocked;
                                    CheckLine."ID No." := RepayAcc."ID No.";
                                    CheckLine.Name := RepayAcc.Name;
                                    CheckLine."Product Type" := RepayAcc."Product Type";
                                    CheckLine."Account Category" := RepayAcc."Account Category";
                                    CheckLine."Repayment Account" := RepayAcc."No.";
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                    CheckLine.Modify
                                end;
                            end;
                    end;
                end;
            ApplicType::"Allocated Amount":
                begin
                    ValidateReceiptConsolidated(CheckLine, Responce, ApplicType);
                end;
        end;
    end;

    procedure ValidateReceiptConsolidated(CheckLine: Record "Checkoff Receipt Lines"; Responce: Integer; ApplicType: Enum CheckoffTypes)
    var
        CustRecord: Record Member;
        RepayAcc: Record "Repayment Account";
        CredAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
        Loans: Record Loans;
    begin

        case
        Responce of
            0:
                begin
                    Error('Option does not exist')
                end;
            1:
                begin

                    CustRecord.Reset;
                    CustRecord.SetRange("No.", CheckLine."Upload ID");
                    if CustRecord.Find('-') then begin

                        if CheckLine."Loan No." = '' then begin

                            case CheckLine."Account Category" of
                                CheckLine."Account Category"::"Registration Fee",
                                CheckLine."Account Category"::"Shares Capital",
                                CheckLine."Account Category"::"Shares Deposit",
                                CheckLine."Account Category"::"Benevolent Fund",
                                CheckLine."Account Category"::Insurance:
                                    begin
                                        CredAccount.Reset();
                                        CredAccount.SetRange("Member No.", CustRecord."No.");
                                        CredAccount.SetRange("Account Category", CheckLine."Account Category");
                                        if CredAccount.FindFirst() then begin

                                            CheckLine."Account No." := CredAccount."No.";
                                            CheckLine.Name := CredAccount.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                            CheckLine."Member No." := CredAccount."Member No.";
                                            CheckLine."ID No." := CredAccount."ID/Passport No.";
                                            CheckLine.Status := CredAccount.Status;
                                            CheckLine.Blocked := CredAccount.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account Dimension" := CredAccount."Account Dimension";
                                            CheckLine.Validate("Product Type", CredAccount."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;
                                        end;
                                    end;

                                CheckLine."Account Category"::"Islamic Banking",
                                CheckLine."Account Category"::"Specialty Savings",
                                CheckLine."Account Category"::"Money Market":
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CheckLine."Member No.");
                                        AccBanking.SetRange("Account Category", AccBanking."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := AccBanking."Staff/Payroll No.";
                                            CheckLine."Member No." := AccBanking."Member No.";
                                            CheckLine."ID No." := AccBanking."ID/Passport No.";
                                            CheckLine.Status := AccBanking.Status;
                                            CheckLine.Blocked := AccBanking.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine."Account Dimension" := AccBanking."Account Dimension";
                                            CheckLine.Validate("Product Type", AccBanking."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;

                                        end;
                                    end;
                            end;
                        end else begin

                            Loans.Reset();
                            Loans.SetRange("No.", CheckLine."Loan No.");
                            if Loans.FindFirst() then begin
                                if Loans."Outstanding Balance" > 0 then begin
                                    case Loans."Interest Calculation Method" of
                                        Loans."Interest Calculation Method"::Amortised:
                                            begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::" ";
                                            end else begin
                                            if CheckLine."Principle Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::Repayment;
                                            end;
                                            if CheckLine."Interest Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::"Interest Paid"
                                            end;
                                        end;
                                    end;
                                    CheckLine."Account No." := Loans."Loan Account";
                                    CheckLine."Account Dimension" := CheckLine."Account Dimension"::Loan;
                                    CheckLine.Validate("Product Type", Loans."Product Type");
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                end;
                            end;
                        end;

                        CheckLine.Modify;
                    end;
                end;
            2:
                begin
                    CustRecord.Reset;
                    CustRecord.SetRange("ID No.", CheckLine."Upload ID");
                    if CustRecord.Find('-') then begin

                        if CheckLine."Loan No." = '' then begin

                            case CheckLine."Account Category" of
                                CheckLine."Account Category"::"Registration Fee",
                                CheckLine."Account Category"::"Shares Capital",
                                CheckLine."Account Category"::"Shares Deposit",
                                CheckLine."Account Category"::"Benevolent Fund",
                                CheckLine."Account Category"::Insurance:
                                    begin
                                        CredAccount.Reset();
                                        CredAccount.SetRange("Member No.", CustRecord."No.");
                                        CredAccount.SetRange("Account Category", CheckLine."Account Category");
                                        if CredAccount.FindFirst() then begin

                                            CheckLine."Account No." := CredAccount."No.";
                                            CheckLine.Name := CredAccount.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                            CheckLine."Member No." := CredAccount."Member No.";
                                            CheckLine."ID No." := CredAccount."ID/Passport No.";
                                            CheckLine.Status := CredAccount.Status;
                                            CheckLine.Blocked := CredAccount.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account Dimension" := CredAccount."Account Dimension";
                                            CheckLine.Validate("Product Type", CredAccount."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;
                                        end;
                                    end;

                                CheckLine."Account Category"::"Islamic Banking",
                                CheckLine."Account Category"::"Specialty Savings",
                                CheckLine."Account Category"::"Money Market":
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CheckLine."Member No.");
                                        AccBanking.SetRange("Account Category", AccBanking."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := AccBanking."Staff/Payroll No.";
                                            CheckLine."Member No." := AccBanking."Member No.";
                                            CheckLine."ID No." := AccBanking."ID/Passport No.";
                                            CheckLine.Status := AccBanking.Status;
                                            CheckLine.Blocked := AccBanking.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine."Account Dimension" := AccBanking."Account Dimension";
                                            CheckLine.Validate("Product Type", AccBanking."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;

                                        end;
                                    end;
                            end;
                        end else begin

                            Loans.Reset();
                            Loans.SetRange("No.", CheckLine."Loan No.");
                            if Loans.FindFirst() then begin
                                Loans.CalcFields("Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin
                                    case Loans."Interest Calculation Method" of
                                        Loans."Interest Calculation Method"::Amortised:
                                            begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::" ";
                                            end else begin
                                            if CheckLine."Principle Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::Repayment;
                                            end;
                                            if CheckLine."Interest Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::"Interest Paid"
                                            end;
                                        end;
                                    end;
                                    CheckLine."Account No." := Loans."Loan Account";
                                    CheckLine.Name := Loans."Account Name";
                                    CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                    CheckLine."Member No." := Loans."Account No.";
                                    CheckLine."ID No." := CustRecord."ID No.";
                                    CheckLine.Status := CustRecord.Status;
                                    CheckLine.Blocked := CustRecord.Blocked;
                                    CheckLine."Account No." := Loans."Loan Account";
                                    CheckLine."Account Dimension" := CheckLine."Account Dimension"::Loan;
                                    CheckLine.Validate("Product Type", Loans."Product Type");
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                end;
                            end;
                        end;
                        CheckLine.Modify;
                    end;
                end;
            3:
                begin
                    CustRecord.Reset;
                    CustRecord.SetRange("Payroll/Staff No.", CheckLine."Upload ID");
                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                    if CustRecord.Find('-') then begin

                        if CheckLine."Loan No." = '' then begin

                            case CheckLine."Account Category" of
                                CheckLine."Account Category"::"Registration Fee",
                                CheckLine."Account Category"::"Shares Capital",
                                CheckLine."Account Category"::"Shares Deposit",
                                CheckLine."Account Category"::"Benevolent Fund",
                                CheckLine."Account Category"::Insurance:
                                    begin
                                        CredAccount.Reset();
                                        CredAccount.SetRange("Member No.", CustRecord."No.");
                                        CredAccount.SetRange("Account Category", CheckLine."Account Category");
                                        if CredAccount.FindFirst() then begin

                                            CheckLine."Account No." := CredAccount."No.";
                                            CheckLine.Name := CredAccount.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                            CheckLine."Member No." := CredAccount."Member No.";
                                            CheckLine."ID No." := CredAccount."ID/Passport No.";
                                            CheckLine.Status := CredAccount.Status;
                                            CheckLine.Blocked := CredAccount.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account Dimension" := CredAccount."Account Dimension";
                                            CheckLine.Validate("Product Type", CredAccount."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;
                                        end;
                                    end;

                                CheckLine."Account Category"::"Islamic Banking",
                                CheckLine."Account Category"::"Specialty Savings",
                                CheckLine."Account Category"::"Money Market":
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CheckLine."Member No.");
                                        AccBanking.SetRange("Account Category", AccBanking."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := AccBanking."Staff/Payroll No.";
                                            CheckLine."Member No." := AccBanking."Member No.";
                                            CheckLine."ID No." := AccBanking."ID/Passport No.";
                                            CheckLine.Status := AccBanking.Status;
                                            CheckLine.Blocked := AccBanking.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine."Account Dimension" := AccBanking."Account Dimension";
                                            CheckLine.Validate("Product Type", AccBanking."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;

                                        end;
                                    end;
                            end;
                        end else begin

                            Loans.Reset();
                            Loans.SetRange("No.", CheckLine."Loan No.");
                            if Loans.FindFirst() then begin

                                Loans.CalcFields("Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin
                                    case Loans."Interest Calculation Method" of
                                        Loans."Interest Calculation Method"::Amortised:
                                            begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::" ";
                                            end else begin
                                            if CheckLine."Principle Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::Repayment;
                                            end;
                                            if CheckLine."Interest Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::"Interest Paid"
                                            end;
                                        end;
                                    end;
                                    CheckLine."Account No." := Loans."Loan Account";
                                    CheckLine.Name := Loans."Account Name";
                                    CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                    CheckLine."Member No." := Loans."Account No.";
                                    CheckLine."ID No." := CustRecord."ID No.";
                                    CheckLine.Status := CustRecord.Status;
                                    CheckLine.Blocked := CustRecord.Blocked;
                                    CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                    CheckLine."Account Dimension" := CheckLine."Account Dimension"::Loan;
                                    CheckLine.Validate("Product Type", Loans."Product Type");
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                end;
                            end;
                        end;
                        CheckLine.Modify;
                    end;
                end;
            4:
                begin

                    RepayAcc.Reset;
                    RepayAcc.SetRange("No.", CheckLine."Upload ID");
                    if RepayAcc.Find('-') then begin

                        if CheckLine."Loan No." = '' then begin

                            case CheckLine."Account Category" of
                                CheckLine."Account Category"::"Registration Fee",
                                CheckLine."Account Category"::"Shares Capital",
                                CheckLine."Account Category"::"Shares Deposit",
                                CheckLine."Account Category"::"Benevolent Fund",
                                CheckLine."Account Category"::Insurance:
                                    begin
                                        CredAccount.Reset();
                                        CredAccount.SetRange("Member No.", CustRecord."No.");
                                        CredAccount.SetRange("Account Category", CheckLine."Account Category");
                                        if CredAccount.FindFirst() then begin

                                            CheckLine."Account No." := CredAccount."No.";
                                            CheckLine.Name := CredAccount.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                            CheckLine."Member No." := CredAccount."Member No.";
                                            CheckLine."ID No." := CredAccount."ID/Passport No.";
                                            CheckLine.Status := CredAccount.Status;
                                            CheckLine.Blocked := CredAccount.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account Dimension" := CredAccount."Account Dimension";
                                            CheckLine.Validate("Product Type", CredAccount."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;
                                        end;
                                    end;

                                CheckLine."Account Category"::"Islamic Banking",
                                CheckLine."Account Category"::"Specialty Savings",
                                CheckLine."Account Category"::"Money Market":
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CheckLine."Member No.");
                                        AccBanking.SetRange("Account Category", AccBanking."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := AccBanking."Staff/Payroll No.";
                                            CheckLine."Member No." := AccBanking."Member No.";
                                            CheckLine."ID No." := AccBanking."ID/Passport No.";
                                            CheckLine.Status := AccBanking.Status;
                                            CheckLine.Blocked := AccBanking.Blocked;
                                            CheckLine."Repayment Account" := getPrepaymentAc(CustRecord."No.");
                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine."Account Dimension" := AccBanking."Account Dimension";
                                            CheckLine.Validate("Product Type", AccBanking."Product Type");
                                            CheckLine."Account Found" := true;
                                            CheckLine."Line Validated" := true;

                                        end;
                                    end;
                            end;
                        end else begin

                            Loans.Reset();
                            Loans.SetRange("No.", CheckLine."Loan No.");
                            if Loans.FindFirst() then begin
                                Loans.CalcFields("Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin
                                    case Loans."Interest Calculation Method" of
                                        Loans."Interest Calculation Method"::Amortised:
                                            begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::" ";
                                            end else begin
                                            if CheckLine."Principle Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::Repayment;
                                            end;
                                            if CheckLine."Interest Repayment" > 0 then begin
                                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::"Interest Paid"
                                            end;
                                        end;
                                    end;
                                    CheckLine."Account No." := Loans."Loan Account";
                                    CheckLine.Name := Loans."Account Name";
                                    CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                                    CheckLine."Member No." := Loans."Account No.";
                                    CheckLine."ID No." := CustRecord."ID No.";
                                    CheckLine.Status := CustRecord.Status;
                                    CheckLine.Blocked := CustRecord.Blocked;
                                    CheckLine."Account Dimension" := CheckLine."Account Dimension"::Loan;
                                    CheckLine.Validate("Product Type", Loans."Product Type");
                                    CheckLine."Account Found" := true;
                                    CheckLine."Line Validated" := true;
                                end;
                            end;
                        end;

                        CheckLine.Modify;
                    end;
                end;
        end;
    end;

    local procedure GetCheckLineAccount(CheckLine: Record "Checkoff Receipt Lines")
    var

        CustRecord: Record Member;
        RepayAcc: Record "Repayment Account";
        CredAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
        Loans: Record Loans;
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        SavingsAcc: Record "Account Banking";
        CreditAcc: Record "Credit Account";

    begin

        if CheckLine."Member No." <> '' then begin
            if CheckLine."Loan No." <> '' then begin

                Loans.Reset();
                Loans.SetRange("No.", CheckLine."Loan No.");
                if Loans.FindFirst() then begin
                    case Loans."Interest Calculation Method" of
                        Loans."Interest Calculation Method"::Amortised:
                            begin
                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::" ";
                            end else begin
                            if CheckLine."Principle Repayment" > 0 then begin
                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::Repayment;
                            end;
                            if CheckLine."Interest Repayment" > 0 then begin
                                CheckLine."Transaction Type" := CheckLine."Transaction Type"::"Interest Paid"
                            end;
                        end;
                    end;
                    CheckLine."Account No." := Loans."Loan Account";
                    CheckLine."Account Dimension" := CheckLine."Account Dimension"::Loan;
                    CheckLine.Validate("Product Type", Loans."Product Type");
                    CheckLine."Account Found" := true;
                end;

            end else begin

                case CheckLine."Account Category" of
                    CheckLine."Account Category"::"Registration Fee",
                    CheckLine."Account Category"::"Shares Capital",
                    CheckLine."Account Category"::"Shares Deposit",
                    CheckLine."Account Category"::"Benevolent Fund",
                    CheckLine."Account Category"::Insurance:
                        begin
                            CredAccount.Reset();
                            CredAccount.SetRange("Member No.", CheckLine."Member No.");
                            CredAccount.SetRange("Account Category", CheckLine."Account Category");
                            if CredAccount.FindFirst() then begin
                                CheckLine."Account No." := CredAccount."No.";
                                CheckLine."Account Dimension" := CredAccount."Account Dimension";
                                CheckLine.Validate("Product Type", CredAccount."Product Type");
                            end;

                        end;
                    CheckLine."Account Category"::"Islamic Banking",
                    CheckLine."Account Category"::"Specialty Savings",
                    CheckLine."Account Category"::"Money Market":
                        begin
                            AccBanking.Reset();
                            AccBanking.SetRange("Member No.", CheckLine."Member No.");
                            AccBanking.SetRange("Account Category", AccBanking."Account Category");
                            if AccBanking.FindFirst() then begin
                                CheckLine."Account No." := AccBanking."No.";
                                CheckLine."Account Dimension" := AccBanking."Account Dimension";
                                CheckLine.Validate("Product Type", AccBanking."Product Type");
                            end;
                        end;
                end;
            end;
            CheckLine.Modify(true)
        end;
    end;

    procedure InitializeRecoveryEntry(RecRef: Record "Guarantor & Security Posted"; var DisbursementLine: Record "Loan Disbursement Lines"; DocNo: Code[20])
    begin
        DisbursementLine.Init;
        DisbursementLine.CopyFromGuarantorLine(RecRef);
        DisbursementLine."Line No." := RegMgt.InitNextLineEntryNo;
        DisbursementLine.No := DocNo;
        OnAfterInitializeRecoveryEntry(DisbursementLine, RecRef)
    end;

    procedure InitiPostEntry(DocNo: Code[50]; LoanNo: Code[50]; AccountNo: Code[100]; RequestedAmt: Decimal; RemarkTxt: Text): Code[100]
    var
        PFact: Record "Product Factory";
        LoanApplic: Record "Loan Application";
        LoanApp: Record "Loan Application";
    begin

        PFact.Reset();
        PFact.SetRange(Status, PFact.Status::Active);
        PFact.SetRange("Nature of Loan Type", PFact."Nature of Loan Type"::Defaulter);
        if PFact.FindFirst() then begin

            LoanApplic.Init();
            LoanApplic.Validate("Application Type", LoanApplic."Application Type"::Defaulter);
            LoanApplic.Validate("Account No.", AccountNo);
            LoanApplic.Validate("Product Type", PFact."Product ID");
            LoanApplic.Validate("Requested Amount", RequestedAmt);
            LoanApplic.Validate("Disbursement Date", Today);
            LoanApplic."Loan Status" := LoanApplic."Loan Status"::Approved;
            LoanApplic."Approval Status" := LoanApplic."Approval Status"::Approved;
            LoanApplic."Payment Mode" := LoanApplic."Payment Mode"::Checkoff;
            LoanApplic.Remarks := RemarkTxt;
            LoanApplic.Sectors := '0000';
            LoanApplic."Sub Sectors" := '0000';
            LoanApplic."Purpose of Loan" := '0000';
            LoanApplic.Validate("Recovery Header No.", DocNo);
            LoanApplic.Validate("Defaulted Loan No.", LoanNo);
            if LoanApplic.Insert(true) then
                exit(LoanApplic."No.") else
                exit('')
        end
    end;

    procedure InitializeLoanRecoveryEntry(AccNo: Code[20]; ReqAmount: Decimal; DocNo: Code[50]; LoanNo: Code[50]; ApplicNo: Code[50])
    var
        PFact: Record "Product Factory";
        LoanApplic: Record "Loan Application";
        LoanAppl: Record "Loan Application";
        RemarkTxt: Text[150];
        CredMngt: Codeunit "Credit Mgmt.";
    begin

        PFact.Reset();
        PFact.SetRange(Status, PFact.Status::Active);
        PFact.SetRange("Nature of Loan Type", PFact."Nature of Loan Type"::Defaulter);
        if PFact.FindFirst() then begin

            RemarkTxt := PFact.Description + '-' + LoanNo;

            message('%1| %2 %3', DocNo, LoanNo, ApplicNo);

            LoanApplic.Reset();
            LoanApplic.SetRange("Defaulted Loan No.", LoanNo);
            LoanApplic.Setrange("No.", ApplicNo);
            LoanApplic.SetRange("Recovery Header No.", DocNo);
            LoanApplic.SetRange("Application Type", LoanApplic."Application Type"::Defaulter);
            if LoanApplic.FindFirst() then begin

                message('%1', LoanApplic."No.");

                LoanApplic.Validate("Account No.", AccNo);
                LoanApplic.Validate("Product Type", PFact."Product ID");
                LoanApplic.Validate("Requested Amount", ReqAmount);
                LoanApplic.Validate("Disbursement Date", Today);
                LoanApplic."Loan Status" := LoanApplic."Loan Status"::Approved;
                LoanApplic."Approval Status" := LoanApplic."Approval Status"::Approved;
                LoanApplic."Payment Mode" := LoanApplic."Payment Mode"::Checkoff;
                LoanApplic.Sectors := '0000';
                LoanApplic."Sub Sectors" := '0000';
                LoanApplic."Purpose of Loan" := '0000';
                LoanApplic.Remarks := RemarkTxt;
                LoanApplic.Modify(true)

            end else begin

                LoanAppl.Reset();
                LoanAppl.SetRange("Account No.", AccNo);
                LoanAppl.SetRange("Defaulted Loan No.", LoanNo);
                LoanAppl.SetRange("Recovery Header No.", DocNo);
                LoanAppl.SetRange("Application Type", LoanAppl."Application Type"::Defaulter);
                if LoanAppl.FindFirst() then begin
                    Loanappl.init;
                    LoanAppl.Validate("Account No.", AccNo);
                    LoanAppl.Validate("Product Type", PFact."Product ID");
                    LoanAppl.Validate("Requested Amount", ReqAmount);
                    LoanAppl.Validate("Disbursement Date", Today);
                    LoanApplic."Loan Status" := LoanApplic."Loan Status"::Approved;
                    LoanApplic."Approval Status" := LoanApplic."Approval Status"::Approved;
                    LoanAppl."Payment Mode" := LoanAppl."Payment Mode"::Checkoff;
                    LoanApplic.Remarks := RemarkTxt;
                    LoanApplic.Sectors := '0000';
                    LoanApplic."Sub Sectors" := '0000';
                    LoanApplic."Purpose of Loan" := '0000';
                    LoanAppl.Insert(true);

                end
            end;
        end;
    end;

    procedure InitializeRecoveryEntryLine(DisbursementLine: Record "Loan Disbursement Lines"; DocNo: Code[20])
    begin
        DisbursementLine.Init;
        DisbursementLine."Line No." := RegMgt.InitNextLineEntryNo;
        DisbursementLine.No := DocNo;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitializeRecoveryEntry(var DisbursementLine: Record "Loan Disbursement Lines"; Applic: Record "Guarantor & Security Posted")
    begin
    end;

    procedure PostRecvMngtFosaLine(DisbursementLine: Record "Loan Disbursement Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[50]; AccountNo: Code[20]; AccountType: Integer)
    var
        RunBal: array[7] of Decimal;
        TellerMngt: codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        Descript: Text[150];
        RecHeader: Record "Recovery Header";
        TextLoanEntry: Label 'Defaulter Recovery-';
        ErrorOnNonAvailBal: Label 'No enough fund for this application';
        ErrorOnPostedEntry: Label 'Entry already Posted';
        ErrorNonMatchingAmount: Label 'Running balance of Kshs %1 cannot be less than available account balance of Kshs %2.';
    begin
        RunBal[1] := 0;
        RunBal[2] := 0;
        RunBal[3] := 0;
        RunBal[4] := 0;
        RunBal[5] := 0;
        RunBal[6] := 0;
        RunBal[7] := 0;

        if TellerMngt.TestNoEntriesExist('', DisbursementLine.No, 2) then
            Error('Application No. %1 already posted', DisbursementLine.No);

        if RecHeader.Get(DisbursementLine.No) then
            Descript := Format(RecHeader."Application Type");

        RunBal[1] := 0;
        RunBal[3] := 0;
        if AccountBanking.Get(DisbursementLine."Account No.") then begin
            AccountBanking.CalcFields("Balance (LCY)");
            if AccountBanking."Balance (LCY)" > 0 then begin
                RunBal[1] := DisbursementLine.Amount;
                RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                if RunBal[1] > RunBal[3] then
                    Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");

                if LoanEntry.Get(DisbursementLine."Loan No.") then begin
                    LoanEntry.CalcFields("Outstanding Bill", "Outstanding Insurance",
                   "Outstanding Interest", "Outstanding Principal");

                    if (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") > 0 then begin
                        RunBal[2] := 0;
                        if RunBal[1] > (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") then
                            RunBal[2] := (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") else
                            RunBal[2] := RunBal[1];

                        if DisbursementLine."Accrued Interest" > 0 then begin
                            if PFact.Get(LoanEntry."Product Type") then begin

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Customer,
                                DisbursementLine.No, CopyStr('Accrued Interest' +
                                LoanEntry."No.", 1, 50), DisbursementLine."Accrued Interest",
                                LoanEntry."Loan Account", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", PFact."Interest Account (G/L)",
                                LoanEntry."Account No.", Dim1, Dim2,
                                Enum::"LoanTransactionType"::"Interest Due", LoanEntry."No.", '', '',
                                Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");
                            end;

                        end;

                        Linenum := Linenum + 1000;
                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                        Enum::"Gen. Journal Account Type"::Vendor,
                        DisbursementLine.No, CopyStr(Descript + '-' +
                        DisbursementLine."Loan No.", 1, 50),
                        RunBal[2], AccountBanking."No.",
                        PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                        '', LoanEntry."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ", '', '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");

                        Linenum := Linenum + 1000;
                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DisbursementLine.No, CopyStr(Descript + '-' +
                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                        LoanEntry."Loan Account", PostingDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        LoanEntry."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Interest Paid", LoanEntry."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");

                        RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Insurance" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Insurance" then
                                RunBal[2] := LoanEntry."Outstanding Insurance" else
                                RunBal[2] := RunBal[1];

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            DisbursementLine."Loan No.", 1, 50),
                            RunBal[2], AccountBanking."No.",
                            PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                            '', LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '', '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");


                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Insurance Paid",
                            LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                            RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Bill" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Bill" then
                                RunBal[2] := LoanEntry."Outstanding Bill" else
                                RunBal[2] := RunBal[1];

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            DisbursementLine."Loan No.", 1, 50),
                            RunBal[2], AccountBanking."No.",
                            PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                            '', LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '', '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");


                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Penalty Paid",
                            LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                            RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Principal" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Principal" then
                                RunBal[2] := LoanEntry."Outstanding Principal" else
                                RunBal[2] := RunBal[1];

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            DisbursementLine."Loan No.", 1, 50),
                            RunBal[2], AccountBanking."No.",
                            PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                            '', LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '', '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::Repayment, LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                        end;
                    end;
                end;
            end else begin
                Error(ErrorOnNonAvailBal);
            end;
        end;
    end;

    procedure PostRecvMngtLienLine(DisbursementLine: Record "Loan Disbursement Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[50]; AccountNo: Code[20]; AccountType: Integer)
    var
        RunBal: array[7] of Decimal;
        TellerMngt: codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        TextLoanEntry: Label 'Defaulter Recovery-';
        ErrorOnNonAvailBal: Label 'No enough fund for this application';
        ErrorOnPostedEntry: Label 'Entry already Posted';
        ErrorNonMatchingAmount: Label 'Running balance of Kshs %1 cannot be less than available account balance of Kshs %2.';
    begin

        RunBal[1] := 0;
        RunBal[3] := 0;
        if AccountBanking.Get(DisbursementLine."Account No.") then begin
            AccountBanking.CalcFields("Balance (LCY)");
            if AccountBanking."Balance (LCY)" > 0 then begin
                RunBal[1] := DisbursementLine.Amount;
                RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                if RunBal[1] > RunBal[3] then
                    Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");
                BnkMngt.PostLien(AccountBanking, DisbursementLine.Amount, DisbursementLine."Account Name", 0, DisbursementLine.No);
            end else begin
                Error(ErrorOnNonAvailBal);
            end;
        end;

    end;

    procedure PostRecovMngtShareLine(DisbursementLine: Record "Loan Disbursement Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[50]; AccountNo: Code[20]; AccountType: Integer)
    var
        RunBal: array[7] of Decimal;
        TellerMngt: codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        RecHeader: Record "Recovery Header";
        Descript: Text[150];
        TextLoanEntry: Label 'Defaulter Recovery-';
        ErrorOnNonAvailBal: Label 'No enough fund for this application';
        ErrorOnPostedEntry: Label 'Entry already Posted';
        ErrorNonMatchingAmount: Label 'Running balance of Kshs %1 cannot be less than available account balance of Kshs %2.';
    begin
        RunBal[1] := 0;
        RunBal[2] := 0;
        RunBal[3] := 0;
        RunBal[4] := 0;
        RunBal[5] := 0;
        RunBal[6] := 0;
        RunBal[7] := 0;

        if TellerMngt.TestNoEntriesExist('', DisbursementLine.No, 2) then
            exit;
        if RecHeader.Get(DisbursementLine.No) then
            Descript := Format(RecHeader."Application Type");

        if AccountCredit.Get(DisbursementLine."Account No.") then begin
            if AccountCredit.Blocked = AccountCredit.Blocked::" " then begin
                AccountCredit.CalcFields("Balance (LCY)");

                RunBal[1] := DisbursementLine.Amount;
                if RunBal[1] > AccountCredit."Balance (LCY)" then
                    Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountCredit."Balance (LCY)");

                Linenum := Linenum + 1000;
                Post.PostJournal(Jtemplate, JBatch, Linenum,
                Enum::"Gen. Journal Account Type"::Customer,
                DisbursementLine.No, CopyStr(Descript + '-' +
                DisbursementLine."Loan No.", 1, 50),
                RunBal[1], DisbursementLine."Account No.",
                PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                '', LoanEntry."Account No.", Dim1, Dim2,
                Enum::"LoanTransactionType"::" ", '', '', '',
                Enum::"Gen. Journal Document Type"::" ", '',
                Enum::"Gen. Journal Document Type"::" ");

                if LoanEntry.Get(DisbursementLine."Loan No.") then begin
                    LoanEntry.CalcFields("Outstanding Bill", "Outstanding Insurance",
                   "Outstanding Interest", "Outstanding Principal");

                    if (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") > 0 then begin
                        RunBal[2] := 0;
                        if RunBal[1] > (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") then
                            RunBal[2] := (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") else
                            RunBal[2] := RunBal[1];

                        if DisbursementLine."Accrued Interest" > 0 then begin
                            if PFact.Get(LoanEntry."Product Type") then begin

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Customer,
                                DisbursementLine.No, CopyStr('Accrued Interest-' +
                                LoanEntry."No.", 1, 50), DisbursementLine."Accrued Interest",
                                LoanEntry."Loan Account", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", PFact."Interest Account (G/L)",
                                LoanEntry."Account No.", Dim1, Dim2,
                                Enum::"LoanTransactionType"::"Interest Due", LoanEntry."No.", '', '',
                                Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");
                            end;

                        end;

                        Linenum := Linenum + 1000;
                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DisbursementLine.No, CopyStr(Descript + '-' +
                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                        LoanEntry."Loan Account", PostingDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        LoanEntry."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Interest Paid", LoanEntry."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");
                        RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Insurance" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Insurance" then
                                RunBal[2] := LoanEntry."Outstanding Insurance" else
                                RunBal[2] := RunBal[1];
                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Insurance Paid",
                            LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                            RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Bill" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Bill" then
                                RunBal[2] := LoanEntry."Outstanding Bill" else
                                RunBal[2] := RunBal[1];
                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Penalty Paid",
                            LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                            RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Principal" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Principal" then
                                RunBal[2] := LoanEntry."Outstanding Principal" else
                                RunBal[2] := RunBal[1];
                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::Repayment, LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                        end;
                    end;
                end;
            end;
        end;

    end;

    procedure PostRecovMngt(DisbursementLine: Record "Loan Disbursement Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[50]; AccountNo: Code[20]; AccountType: Integer)
    var
        RunBal: array[7] of Decimal;
        TellerMngt: codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        RecHeader: Record "Recovery Header";
        Descript: Text[150];
        TextLoanEntry: Label 'Defaulter Recovery-';
        ErrorOnNonAvailBal: Label 'No enough fund for this application';
        ErrorOnPostedEntry: Label 'Entry already Posted';
        ErrorNonMatchingAmount: Label 'Running balance of Kshs %1 cannot be less than available account balance of Kshs %2.';
    begin
        RunBal[1] := 0;
        RunBal[2] := 0;
        RunBal[3] := 0;
        RunBal[4] := 0;
        RunBal[5] := 0;
        RunBal[6] := 0;
        RunBal[7] := 0;

        if TellerMngt.TestNoEntriesExist('', DisbursementLine.No, 2) then
            exit;
        if RecHeader.Get(DisbursementLine.No) then
            Descript := Format(RecHeader."Application Type");

        if AccountCredit.Get(DisbursementLine."Account No.") then begin
            if AccountCredit.Blocked = AccountCredit.Blocked::" " then begin
                AccountCredit.CalcFields("Balance (LCY)");

                RunBal[1] := DisbursementLine.Amount;
                if RunBal[1] > AccountCredit."Balance (LCY)" then
                    Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountCredit."Balance (LCY)");

                Linenum := Linenum + 1000;
                Post.PostJournal(Jtemplate, JBatch, Linenum,
                Enum::"Gen. Journal Account Type"::Customer,
                DisbursementLine.No, CopyStr(Descript + '-' +
                DisbursementLine."Loan No.", 1, 50),
                RunBal[1], DisbursementLine."Account No.",
                PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                '', LoanEntry."Account No.", Dim1, Dim2,
                Enum::"LoanTransactionType"::" ", '', '', '',
                Enum::"Gen. Journal Document Type"::" ", '',
                Enum::"Gen. Journal Document Type"::" ");

                if LoanEntry.Get(DisbursementLine."Loan No.") then begin
                    LoanEntry.CalcFields("Outstanding Bill", "Outstanding Insurance",
                   "Outstanding Interest", "Outstanding Principal");

                    if (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") > 0 then begin
                        RunBal[2] := 0;
                        if RunBal[1] > (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") then
                            RunBal[2] := (LoanEntry."Outstanding Interest" + DisbursementLine."Accrued Interest") else
                            RunBal[2] := RunBal[1];

                        if DisbursementLine."Accrued Interest" > 0 then begin
                            if PFact.Get(LoanEntry."Product Type") then begin

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Customer,
                                DisbursementLine.No, CopyStr('Accrued Interest-' +
                                LoanEntry."No.", 1, 50), DisbursementLine."Accrued Interest",
                                LoanEntry."Loan Account", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", PFact."Interest Account (G/L)",
                                LoanEntry."Account No.", Dim1, Dim2,
                                Enum::"LoanTransactionType"::"Interest Due", LoanEntry."No.", '', '',
                                Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");
                            end;

                        end;

                        Linenum := Linenum + 1000;
                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DisbursementLine.No, CopyStr(Descript + '-' +
                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                        LoanEntry."Loan Account", PostingDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        LoanEntry."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Interest Paid", LoanEntry."No.", '', '',
                        Enum::"Gen. Journal Document Type"::" ", '',
                        Enum::"Gen. Journal Document Type"::" ");
                        RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Insurance" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Insurance" then
                                RunBal[2] := LoanEntry."Outstanding Insurance" else
                                RunBal[2] := RunBal[1];
                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Insurance Paid",
                            LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                            RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Bill" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Bill" then
                                RunBal[2] := LoanEntry."Outstanding Bill" else
                                RunBal[2] := RunBal[1];
                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Penalty Paid",
                            LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                            RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        if LoanEntry."Outstanding Principal" > 0 then begin
                            RunBal[2] := 0;
                            if RunBal[1] > LoanEntry."Outstanding Principal" then
                                RunBal[2] := LoanEntry."Outstanding Principal" else
                                RunBal[2] := RunBal[1];
                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Descript + '-' +
                            LoanEntry."No.", 1, 50), RunBal[2] * -1,
                            LoanEntry."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::Repayment, LoanEntry."No.", '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure PostRecvMgt(RecoveryHeader: Record "Recovery Header"; PostInt: Integer)
    var
        Purchline: Record "Loan Disbursement Lines";
        GenJournaline: Record "Gen. Journal Line";
        Docx: Codeunit "Doc. Mngt";
        VarVariant: Variant;
        RecHeader: Record "Recovery Header";
        CredAc: Record "Account Credit";
        Customer: Record Customer;
        CustMember: Record Member;
        DocMngt: Codeunit "Doc-PostMgt";
        LnRecoveryMngt: Record "Loan Recovery Mngt.";
        Loan: Record Loans;
        Ploan: Record "Loans Categorization";
        IntDays: Integer;
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        RegisterMngt: Codeunit "Register Management";
        AvailBalance: Decimal;
        BalanceLCY: Decimal;
        TransactionType: Enum MobileTransType;
        RepayType: Enum "LoanTransactionType";
        DeductionStatus: Enum MobileDeductionStatus;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        TempEntry: Record "Transaction Types-Mobile";
        RecLoan: Record Loans;

    begin
        RecoveryHeader.TestField("Posting Date");
        RecoveryHeader.TestField("Post As");
        RecoveryHeader.fnCheckMinRequirement();

        CreateJournalTemplate;

        Purchline.Reset;
        Purchline.SetRange(Posted, false);
        Purchline.SetRange(No, RecoveryHeader."No.");
        Purchline.SetRange("Default Account No.", RecoveryHeader."Account No.");
        if Purchline.Find('-') then begin
            repeat
                case RecoveryHeader."Application Type" of
                    RecoveryHeader."Application Type"::"Recovery from Shares",
                        RecoveryHeader."Application Type"::"Recover from guarantors":
                        begin
                            PostLine(Purchline, 0, RecoveryHeader."Posting Date", '', '', 0);
                        end;
                    RecoveryHeader."Application Type"::"Place Lien":
                        begin
                            PostLine(Purchline, 2, RecoveryHeader."Posting Date", '', '', 0);
                        end;
                    RecoveryHeader."Application Type"::"Fosa Recovery":
                        begin
                            PostLine(Purchline, 1, RecoveryHeader."Posting Date", '', '', 0);
                        end;
                end;

                if PostInt = 1 then begin

                    case RecoveryHeader."Application Type" of
                        RecoveryHeader."Application Type"::"Recover from guarantors":
                            begin
                                if Loan.Get(RecoveryHeader."Loan No.") then begin
                                    DocMngt.CreateRecovLine(Loan."Account No.",
                                    Loan."Account No.", Purchline."Shares Deposit", Loan."Approved Amount",
                                    RecoveryHeader."Outstanding Interest", RecoveryHeader."Outstanding Principal",
                                    Loan."Product Type", Purchline.Amount, 3, Loan."No.", RecoveryHeader."No.");
                                end;
                            end;
                    end;
                end;
            until Purchline.Next = 0;
            if PostInt = 1 then begin
                Post.CompletePosting(Jtemplate, JBatch);
            end;
        end;

        if PostInt = 1 then begin
            if RecHeader.Get(RecoveryHeader."No.") then begin
                RecHeader.Posted := true;
                RecHeader."Posted By" := UserId;
                RecHeader."Approval Status" := RecHeader."Approval Status"::Posted;
                RecHeader."Date Posted" := Today;
                RecHeader.Modify(true);
            end;

            case RecoveryHeader."Application Type" of
                RecoveryHeader."Application Type"::"Recovery from Shares",
                RecoveryHeader."Application Type"::"Recover from guarantors":
                    begin

                        if CustMember.Get(RecoveryHeader."Account No.") then begin
                            if RecoveryHeader."Application Source" = RecoveryHeader."Application Source"::Manual then begin
                                CustMember."Loan Status" := CustMember."Loan Status"::Defaulter;
                            end else begin
                                CustMember."Mobile Status" := CustMember."Mobile Status"::Defaulter;
                                if RecLoan.Get(RecoveryHeader."Loan No.") then begin
                                    RecoveryHeader.CalcFields("Total Amount LCY");

                                    TempEntry.LockTable();
                                    TempEntry."Entry No." := RegisterMngt.InitNextAltTransTypesEntryNo();
                                    RegisterMngt.InitializeTempEntry(RecLoan,
                                            TempEntry, RecoveryHeader."Total Amount LCY",
                                            RecoveryHeader."Shares Deposits",
                                            TransactionType::"Recovery from Deposits",
                                            RepayType::Repayment,
                                            MobileDeductionStatus::"Full Deduction", RecoveryHeader."Total Amount LCY");
                                    TempEntry.Insert(true);
                                end;
                            end;
                            CustMember.Modify(true);
                        end;

                        Ploan.Reset();
                        Ploan.SetRange("No.", RecoveryHeader."Loan No.");
                        if Ploan.FindFirst() then begin
                            Ploan."Performance Indicator" := Ploan."Performance Indicator"::"Defaulted Account";
                            Ploan.Modify(true);
                        end;
                    end;
            end;

            case RecoveryHeader."Application Type" of
                RecoveryHeader."Application Type"::"Recovery from Shares":
                    begin
                        CredAc.Reset();
                        CredAc.SetRange("Member No.", RecoveryHeader."Account No.");
                        CredAc.SetRange("Account Category", CredAc."Account Category"::"Shares Deposit");
                        if CredAc.FindSet() then begin

                            if Loan.Get(RecoveryHeader."Loan No.") then
                                DocMngt.CreateRecovLine(CredAc."No.",
                                CredAc."Member No.",
                                RecoveryHeader."Shares Deposits",
                                Loan."Approved Amount",
                                RecoveryHeader."Outstanding Interest",
                                RecoveryHeader."Outstanding Principal",
                                Loan."Product Type", RecoveryHeader."Shares Deductable", 2, Loan."No.", RecoveryHeader."No.");

                        end;
                    end;
                RecoveryHeader."Application Type"::"Fosa Recovery":
                    begin
                        AccountBanking.Reset();
                        AccountBanking.SetRange("No.", RecoveryHeader."Account to Debit");
                        if AccountBanking.FindFirst() then begin
                            if Loan.Get(RecoveryHeader."Loan No.") then
                                DocMngt.CreateRecovLine(AccountBanking."No.",
                                RecoveryHeader."Account No.",
                                Purchline.Amount,
                                Loan."Approved Amount",
                                RecoveryHeader."Outstanding Interest",
                                RecoveryHeader."Outstanding Principal",
                                Loan."Product Type", Purchline."Shares Deposit", 1, Loan."No.", RecoveryHeader."No.");
                        end;
                    end;
            end;
            Purchline.Reset;
            Purchline.SetRange(No, RecoveryHeader."No.");
            Purchline.SetRange("Default Account No.", RecoveryHeader."Account No.");
            if Purchline.FindSet() then begin
                Purchline.ModifyAll(Posted, true);
                Purchline.ModifyAll("Posted By", UserId);
                Purchline.ModifyAll("Date Posted", Today);
                Purchline.ModifyAll("Time Posted", Time);
            end;
            VarVariant := RecoveryHeader;
        end;


        if PostInt = 0 then begin
            VarVariant := RecoveryHeader;
            Commit();
            Docx.DocPrintstatement(VarVariant, 0);
        end;
        if PostInt = 2 then begin
            VarVariant := RecoveryHeader;
            Commit();
            Docx.DocPrintstatement(VarVariant, 1);
        end;
    end;

    procedure PostLine(DisbursementLine: Record "Loan Disbursement Lines"; PostInt: Integer; PostingDate: Date; TextDescription: Text[50]; AccountNo: Code[20]; AccountType: Integer)
    var
        RunBal: array[7] of Decimal;
        TellerMngt: codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        TextLoanEntry: Label 'Defaulter Recovery-';
        ErrorOnNonAvailBal: Label 'No enough fund for this application';
        ErrorOnPostedEntry: Label 'Entry already Posted';
        RecovHeader: Record "Recovery Header";
        IntDays: Integer;
        AccruedInt: Decimal;
        NoOfGuarant: Integer;
        PeriodicMgt: Codeunit "Periodic Activities Mgt.";
        ErrorNonMatchingAmount: Label 'Running balance of Kshs %1 cannot be less than available account balance of Kshs %2.';
    begin
        RunBal[1] := 0;
        RunBal[2] := 0;
        RunBal[3] := 0;
        RunBal[4] := 0;
        RunBal[5] := 0;
        RunBal[6] := 0;
        RunBal[7] := 0;
        AccruedInt := 0;
        NoOfGuarant := 0;

        case PostInt of
            0:
                begin
                    if TellerMngt.TestNoEntriesExist('', DisbursementLine.No, 2) then
                        exit;

                    if AccountCredit.Get(DisbursementLine."Account No.") then begin
                        if AccountCredit.Blocked = AccountCredit.Blocked::" " then begin
                            AccountCredit.CalcFields("Balance (LCY)");

                            RunBal[1] := DisbursementLine.Amount;
                            if RunBal[1] > AccountCredit."Balance (LCY)" then
                                Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountCredit."Balance (LCY)");

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            DisbursementLine.No, CopyStr(Format(AccountCredit.Name) + '-' +
                            DisbursementLine."Loan No.", 1, 50),
                            RunBal[1], DisbursementLine."Account No.",
                            PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                            '', LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '', '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");

                            if LoanEntry.Get(DisbursementLine."Loan No.") then begin

                                LoanEntry.CalcFields("Outstanding Bill", "Outstanding Insurance",
                               "Outstanding Interest", "Outstanding Principal");

                                EndDate := Today;
                                StartDate := CalcDate('-CM', Today);
                                IntDays := (EndDate - StartDate) + 1;

                                RecovHeader.Reset();
                                RecovHeader.SetRange("No.", DisbursementLine.No);
                                if RecovHeader.FindFirst() then begin

                                    NoOfGuarant := 0;
                                    NoOfGuarant := RecovHeader.CountGuarantor(RecovHeader."Loan No.");
                                    AccruedInt := 0;

                                    case RecovHeader."Acrued Interest Options" of
                                        RecovHeader."Acrued Interest Options"::"Charge Accrued Interest":
                                            begin
                                                if RecovHeader."Application Type" = RecovHeader."Application Type"::"Recovery from Shares" then
                                                    AccruedInt := PeriodicMgt.fnIntEntriesonSpecificLoan(LoanEntry, Today, LoanEntry."No.", 1, IntDays, StartDate) else
                                                    AccruedInt := (PeriodicMgt.fnIntEntriesonSpecificLoan(LoanEntry, Today, LoanEntry."No.", 1, IntDays, StartDate) / DisbursementLine."No. of Guarantors");
                                                DisbursementLine."Accrued Interest" := AccruedInt;
                                            end;
                                        RecovHeader."Acrued Interest Options"::"Ignore Acrued Interest":
                                            begin
                                                AccruedInt := 0;
                                            end;
                                    end;

                                end;

                                if AccruedInt > 0 then begin
                                    if PFact.Get(LoanEntry."Product Type") then begin
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                        Enum::"Gen. Journal Account Type"::Customer,
                                        DisbursementLine.No, CopyStr('Accrued Interest-' +
                                        LoanEntry."No.", 1, 50), AccruedInt,
                                        LoanEntry."Loan Account", PostingDate,
                                        Enum::"Gen. Journal Account Type"::"G/L Account", PFact."Interest Account (G/L)",
                                        LoanEntry."Account No.", Dim1, Dim2,
                                        Enum::"LoanTransactionType"::"Interest Due", LoanEntry."No.", '', '',
                                        Enum::"Gen. Journal Document Type"::" ", '',
                                        Enum::"Gen. Journal Document Type"::" ");
                                    end;
                                end;

                                if (LoanEntry."Outstanding Interest" + AccruedInt) > 0 then begin
                                    RunBal[2] := 0;

                                    if RunBal[1] > (LoanEntry."Outstanding Interest" + AccruedInt) then
                                        RunBal[2] := (LoanEntry."Outstanding Interest" + AccruedInt) else
                                        RunBal[2] := RunBal[1];

                                    Linenum := Linenum + 1000;
                                    Post.PostJournal(Jtemplate, JBatch, Linenum,
                                    Enum::"Gen. Journal Account Type"::Customer,
                                    DisbursementLine.No, CopyStr(AccountCredit.Name + '-' +
                                    LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                    LoanEntry."Loan Account", PostingDate,
                                    Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                    LoanEntry."Account No.", Dim1, Dim2,
                                    Enum::"LoanTransactionType"::"Interest Paid", LoanEntry."No.", '', '',
                                    Enum::"Gen. Journal Document Type"::" ", '',
                                    Enum::"Gen. Journal Document Type"::" ");
                                    RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                                end;

                                if RunBal[1] > 0 then begin
                                    if LoanEntry."Outstanding Bill" > 0 then begin
                                        RunBal[2] := 0;
                                        if RunBal[1] > LoanEntry."Outstanding Bill" then
                                            RunBal[2] := LoanEntry."Outstanding Bill" else
                                            RunBal[2] := RunBal[1];
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                        Enum::"Gen. Journal Account Type"::Customer,
                                        DisbursementLine.No, CopyStr(AccountCredit.Name + '-' +
                                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                        LoanEntry."Loan Account", PostingDate,
                                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2,
                                        Enum::"LoanTransactionType"::"Penalty Paid",
                                        LoanEntry."No.", '', '',
                                        Enum::"Gen. Journal Document Type"::" ", '',
                                        Enum::"Gen. Journal Document Type"::" ");
                                        RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                                    end;
                                end;

                                if RunBal[1] > 0 then begin
                                    if LoanEntry."Outstanding Principal" > 0 then begin
                                        RunBal[2] := 0;
                                        if RunBal[1] > LoanEntry."Outstanding Principal" then
                                            RunBal[2] := LoanEntry."Outstanding Principal" else
                                            RunBal[2] := RunBal[1];
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                        Enum::"Gen. Journal Account Type"::Customer,
                                        DisbursementLine.No, CopyStr(AccountCredit.Name + '-' +
                                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                        LoanEntry."Loan Account", PostingDate,
                                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2,
                                        Enum::"LoanTransactionType"::Repayment, LoanEntry."No.", '', '',
                                        Enum::"Gen. Journal Document Type"::" ", '',
                                        Enum::"Gen. Journal Document Type"::" ");
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            1:
                begin
                    if TellerMngt.TestNoEntriesExist('', DisbursementLine.No, 2) then
                        exit;
                    RunBal[1] := 0;
                    RunBal[3] := 0;

                    if AccountBanking.Get(DisbursementLine."Account No.") then begin

                        AccountBanking.CalcFields("Balance (LCY)");
                        if AccountBanking."Balance (LCY)" > 0 then begin
                            RunBal[1] := DisbursementLine.Amount;
                            RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                            if RunBal[1] > RunBal[3] then
                                Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor,
                            DisbursementLine.No, CopyStr(Format(AccountBanking.Name) + '-' +
                            DisbursementLine."Loan No.", 1, 50),
                            RunBal[1], AccountBanking."No.",
                            PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                            '', LoanEntry."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '', '', '',
                            Enum::"Gen. Journal Document Type"::" ", '',
                            Enum::"Gen. Journal Document Type"::" ");

                            if LoanEntry.Get(DisbursementLine."Loan No.") then begin

                                LoanEntry.CalcFields("Outstanding Bill", "Outstanding Insurance",
                                "Outstanding Interest", "Outstanding Principal");

                                EndDate := Today;
                                StartDate := CalcDate('-CM', Today);
                                IntDays := (EndDate - StartDate) + 1;

                                RecovHeader.Reset();
                                RecovHeader.SetRange("No.", DisbursementLine.No);
                                if RecovHeader.FindFirst() then begin

                                    NoOfGuarant := 0;
                                    NoOfGuarant := RecovHeader.CountGuarantor(RecovHeader."Loan No.");
                                    AccruedInt := 0;
                                    case RecovHeader."Acrued Interest Options" of
                                        RecovHeader."Acrued Interest Options"::"Charge Accrued Interest":
                                            begin
                                                AccruedInt := PeriodicMgt.fnIntEntriesonSpecificLoan(LoanEntry, Today, LoanEntry."No.", 1, IntDays, StartDate);
                                                DisbursementLine."Accrued Interest" := AccruedInt;
                                            end;
                                        RecovHeader."Acrued Interest Options"::"Ignore Acrued Interest":
                                            begin
                                                AccruedInt := 0;
                                            end;
                                    end;
                                end;

                                if (LoanEntry."Outstanding Interest" + AccruedInt) > 0 then begin
                                    RunBal[2] := 0;
                                    if RunBal[1] > (LoanEntry."Outstanding Interest" + AccruedInt) then
                                        RunBal[2] := (LoanEntry."Outstanding Interest" + AccruedInt) else
                                        RunBal[2] := RunBal[1];

                                    if AccruedInt > 0 then begin

                                        if PFact.Get(LoanEntry."Product Type") then begin

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                                            Enum::"Gen. Journal Account Type"::Customer,
                                            DisbursementLine.No, CopyStr('Accrued Interest-' +
                                            LoanEntry."No.", 1, 50), AccruedInt,
                                            LoanEntry."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", PFact."Interest Account (G/L)",
                                            LoanEntry."Account No.", Dim1, Dim2,
                                            Enum::"LoanTransactionType"::"Interest Due", LoanEntry."No.", '', '',
                                            Enum::"Gen. Journal Document Type"::" ", '',
                                            Enum::"Gen. Journal Document Type"::" ");
                                        end;

                                    end;

                                    Linenum := Linenum + 1000;
                                    Post.PostJournal(Jtemplate, JBatch, Linenum,
                                    Enum::"Gen. Journal Account Type"::Customer,
                                    DisbursementLine.No, CopyStr(LoanEntry."Account Name" + '-' +
                                    LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                    LoanEntry."Loan Account", PostingDate,
                                    Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                    LoanEntry."Account No.", Dim1, Dim2,
                                    Enum::"LoanTransactionType"::"Interest Paid", LoanEntry."No.", '', '',
                                    Enum::"Gen. Journal Document Type"::" ", '',
                                    Enum::"Gen. Journal Document Type"::" ");

                                    RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                                end;

                                if RunBal[1] > 0 then begin

                                    if LoanEntry."Outstanding Bill" > 0 then begin
                                        RunBal[2] := 0;
                                        if RunBal[1] > LoanEntry."Outstanding Bill" then
                                            RunBal[2] := LoanEntry."Outstanding Bill" else
                                            RunBal[2] := RunBal[1];
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                        Enum::"Gen. Journal Account Type"::Customer,
                                        DisbursementLine.No, CopyStr(LoanEntry."Account Name" + '-' +
                                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                        LoanEntry."Loan Account", PostingDate,
                                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2,
                                        Enum::"LoanTransactionType"::"Penalty Paid",
                                        LoanEntry."No.", '', '',
                                        Enum::"Gen. Journal Document Type"::" ", '',
                                        Enum::"Gen. Journal Document Type"::" ");
                                        RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                                    end;
                                end;

                                if RunBal[1] > 0 then begin
                                    if LoanEntry."Outstanding Principal" > 0 then begin
                                        RunBal[2] := 0;
                                        if RunBal[1] > LoanEntry."Outstanding Principal" then
                                            RunBal[2] := LoanEntry."Outstanding Principal" else
                                            RunBal[2] := RunBal[1];
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                        Enum::"Gen. Journal Account Type"::Customer,
                                        DisbursementLine.No, CopyStr(LoanEntry."Account Name" + '-' +
                                        LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                        LoanEntry."Loan Account", PostingDate,
                                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2,
                                        Enum::"LoanTransactionType"::Repayment, LoanEntry."No.", '', '',
                                        Enum::"Gen. Journal Document Type"::" ", '',
                                        Enum::"Gen. Journal Document Type"::" ");
                                    end;
                                end;
                            end;
                        end else begin
                            Error(ErrorOnNonAvailBal);
                        end;
                    end;
                end;
            2:
                begin
                    RunBal[1] := 0;
                    RunBal[3] := 0;
                    if AccountBanking.Get(DisbursementLine."Account No.") then begin
                        AccountBanking.CalcFields("Balance (LCY)");
                        if AccountBanking."Balance (LCY)" > 0 then begin
                            RunBal[1] := DisbursementLine.Amount;
                            RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                            if RunBal[1] > RunBal[3] then
                                Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");
                            BnkMngt.PostLien(AccountBanking, DisbursementLine.Amount, DisbursementLine."Account Name", 0, DisbursementLine.No);
                        end else begin
                            Error(ErrorOnNonAvailBal);
                        end;
                    end;
                end;
            3:
                begin
                    if TellerMngt.TestNoEntriesExist('', DisbursementLine.No, 2) then
                        exit;
                    RunBal[1] := 0;
                    RunBal[3] := 0;

                    if AccountBanking.Get(DisbursementLine."Account No.") then begin
                        AccountBanking.CalcFields("Balance (LCY)");

                        if AccountBanking."Balance (LCY)" > 0 then begin
                            RunBal[1] := DisbursementLine.Amount;
                            RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                            if RunBal[1] > RunBal[3] then
                                Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");

                            AccountCredit.Reset();
                            AccountCredit.SetRange("Member No.", DisbursementLine."Default Account No.");
                            AccountCredit.SetRange(Blocked, AccountCredit.Blocked::" ");
                            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
                            if AccountCredit.FindFirst() then begin

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor,
                                DisbursementLine.No, CopyStr(Format(AccountBanking.Name) + '-' +
                                DisbursementLine."Loan No.", 1, 50), RunBal[1], AccountBanking."No.",
                                PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                '', LoanEntry."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::" ", '', '', '',
                                Enum::"Gen. Journal Document Type"::" ", '', Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Customer, DisbursementLine.No,
                                CopyStr(AccountCredit.Name + '-' + AccountCredit."No.", 1, 50), RunBal[1] * -1,
                                AccountCredit."No.", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                LoanEntry."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::" ", '', '', '',
                                Enum::"Gen. Journal Document Type"::" ", '', Enum::"Gen. Journal Document Type"::" ");
                            end

                        end else begin
                            Error(ErrorOnNonAvailBal);
                        end;
                    end;
                end;
        end;
    end;

    procedure generateCustPeriodicAdvise(CustomerMember: Record Member)
    var
        CutoffDate: Date;
        Loans: Record Loans;
        MonthlyContrib: Record "Member Monthly Contribution";
        AdviceLine: Record "Checkoff Advice Line";
        AcctCredit: Record "Account Credit";
        BanktAcc: Record "Account Banking";
    begin
        case CustomerMember.Status of
            customermember.Status::Active:
                begin

                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", CustomerMember."No.");
                    MonthlyContrib.SetFilter(Type, '%1|%2|%3', MonthlyContrib.Type::"Shares Capital",
                    MonthlyContrib.Type::"Shares Deposit", MonthlyContrib.Type::"Registration Fee");
                    if MonthlyContrib.FindSet() then begin
                        repeat
                            MonthlyContrib.TestField("Application No.");

                            AcctCredit.Reset();
                            AcctCredit.SetRange("No.", MonthlyContrib."Application No.");
                            AcctCredit.SetRange("Account Category", MonthlyContrib.Type);
                            if AcctCredit.FindFirst() then begin
                                AcctCredit.CalcFields("Balance (LCY)");
                                AdviceLine.LockTable();
                                AdviceLine.Init();
                                AdviceLine."Entry No" := RegMgt.InitNextAdviceEntryNo();
                                AdviceLine."Account No." := MonthlyContrib."Application No.";
                                AdviceLine.Validate("Member No.", MonthlyContrib."Account No.");
                                AdviceLine."Amount On" := MonthlyContrib.Amount;
                                AdviceLine."Amount Off" := MonthlyContrib."Amount Off";
                                AdviceLine."Employer Code" := CustomerMember."Employer Code";
                                AdviceLine."Product Type" := AcctCredit."Product Type";
                                AdviceLine."Payroll Staff No." := CustomerMember."Payroll/Staff No.";
                                AdviceLine."ID No." := CustomerMember."ID No.";
                                AdviceLine."Balance On" := AcctCredit."Balance (LCY)";
                                AdviceLine."Advice Type" := MonthlyContrib."Advise Type";
                                AdviceLine.Insert(true);
                            end;
                        until MonthlyContrib.Next() = 0;
                    end;

                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", CustomerMember."No.");
                    MonthlyContrib.SetFilter(Type, '<>%1|<>%2|<>%3|<>%4', MonthlyContrib.Type::"Shares Capital",
                    MonthlyContrib.Type::"Shares Deposit", MonthlyContrib.Type::"Registration Fee", MonthlyContrib.Type::" ");
                    if MonthlyContrib.FindSet() then begin
                        repeat
                            MonthlyContrib.TestField("Application No.");

                            BanktAcc.Reset();
                            BanktAcc.SetRange("No.", MonthlyContrib."Application No.");
                            BanktAcc.SetRange("Account Category", MonthlyContrib.Type);
                            if BanktAcc.FindFirst() then begin
                                BanktAcc.CalcFields("Balance (LCY)");
                                AdviceLine.LockTable();
                                AdviceLine.Init();
                                AdviceLine."Entry No" := RegMgt.InitNextAdviceEntryNo();
                                AdviceLine.Names := BanktAcc.Name;
                                AdviceLine."Account No." := MonthlyContrib."Application No.";
                                AdviceLine."Member No." := MonthlyContrib."Account No.";
                                AdviceLine."Amount On" := MonthlyContrib.Amount;
                                AdviceLine."Amount Off" := MonthlyContrib."Amount Off";
                                AdviceLine."Product Type" := BanktAcc."Product Type";
                                AdviceLine."Employer Code" := CustomerMember."Employer Code";
                                AdviceLine."Advice Type" := MonthlyContrib."Advise Type";
                                AdviceLine."ID No." := CustomerMember."ID No.";
                                AdviceLine."Balance On" := BanktAcc."Balance (LCY)";
                                AdviceLine."Payroll Staff No." := CustomerMember."Payroll/Staff No.";
                                AdviceLine.Insert(true);
                            end;
                        until MonthlyContrib.Next() = 0;
                    end;

                    Loans.Reset();
                    Loans.SetRange("Account No.", CustomerMember."No.");
                    Loans.SetFilter("Outstanding Balance", '>0');
                    if Loans.FindSet() then begin
                        Loans.CalcSums(Repayment);
                        AdviceLine.LockTable();
                        AdviceLine.Init();
                        AdviceLine."Entry No" := RegMgt.InitNextAdviceEntryNo();
                        AdviceLine.Names := Loans."Account Name";
                        AdviceLine."Account No." := Loans."Loan Account";
                        AdviceLine."Member No." := Loans."Account No.";
                        AdviceLine."Amount On" := Loans.Repayment;
                        AdviceLine."Employer Code" := CustomerMember."Employer Code";
                        AdviceLine."Advice Type" := MonthlyContrib."Advise Type";
                        AdviceLine."ID No." := CustomerMember."ID No.";
                        AdviceLine."Payroll Staff No." := CustomerMember."Payroll/Staff No.";
                        AdviceLine.Insert(true);
                    end;
                end;
        end;
    end;

    procedure PerformPostOnAccClosureEFT(RecRef: Record "Membership closure"; Template: Code[10]; Batch: Code[10]; PostInt: Integer; PostPrev: Integer; ApplicType: Boolean)
    var
        AccountLine: Record "Account Closure Line";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        Temp: Record "Banking User Template";
        Loan: Record Loans;
        Account: Record "Account Credit";
        RunBal: Decimal;
        Member: Record Member;
        TotalLoan: Decimal;
        LineNo: Integer;
        AcctType: Enum "Gen. Journal Account Type";
        TransCharges: Record "Transaction Charge";
        gensetup: Record "General Set-Up";
        ProdFact: Record "Product Factory";
        BufferedInt: Decimal;
        Linterest: Decimal;
        LPrincipal: Decimal;
        Amt: array[5] of Decimal;
        AccBanking: Record "Account Banking";
        JournalLine: Record "Gen. Journal Line";
        MemClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        NotifSource: Enum NotifSourceType;
        HyperText: Text[250];
        Varvariant: Variant;
        Charges: Decimal;
        AmtPost: Decimal;
        ExciseDuty: Decimal;
        NoticeRec: Record "Member withdrawal Notice";
        TotalAmt: Decimal;
        BosaAcc: Record "Account Credit";
        CustRec: Record Customer;
        RegisterMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        FosaAc: Record "Account Banking";
        BosaRec: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        ErrorOnCreditDebitLines: Label 'Total liabilities Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnCreditLines: Label 'Total credit Amount of %1 cannot be more than the account Balance Of %2';
        Externpayment: Record "External Payment";

    begin

        gensetup.Get();
        gensetup.TestField("Excise Duty G/L");
        gensetup.TestField("Excise Duty G/L");
        HyperText := 'https://';

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

        RecRef.TestField("Member No.");
        RecRef.TestField(Remarks);
        RecRef.TestField("Pay Mode", RecRef."Pay Mode"::EFT);

        if AppMngt.CheckBlockedDocsOnJnls(RecRef."No.", 50459) then begin

            if Member.Get(RecRef."Member No.") then
                RunBal := 0;
            TotalLoan := 0;
            Charges := 0;
            ExciseDuty := 0;
            AmtPost := 0;
            TotalAmt := 0;

            JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

            FosaAc.Reset();
            FosaAc.SetRange("Member No.", RecRef."Member No.");
            FosaAc.SetRange("Account Category", FosaAc."Account Category"::Savings);
            if FosaAc.FindFirst() then begin
                FosaAc.CalcFields("Balance (LCY)");
                if FosaAc."Balance (LCY)" > 0 then begin

                    RunBal := FosaAc."Balance (LCY)";

                    case PostPrev of
                        0:
                            begin

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                                RecRef."No.", Format(RecRef."Pay Mode") + '- ( ' +
                                Format(RecRef."EFT Options") + ' ) To-' + Format(Externpayment."Account No."),
                                FosaAc."Balance (LCY)", FosaAc."No.", Today, RecRef."Account Type",
                                RecRef."Paying Account No.", FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                            end;
                        1:
                            begin

                                Externpayment.Reset();
                                Externpayment.SetRange("Application No.", RecRef."No.");
                                Externpayment.SetRange("Member No.", RecRef."Member No.");
                                Externpayment.SetRange("Account Type", Externpayment."Account Type"::"Bank Account");
                                if Externpayment.FindSet() then begin
                                    repeat

                                        Amt[1] := 0;
                                        if RunBal > 0 then begin

                                            if RunBal > Externpayment.Amount then
                                                Amt[1] := Externpayment.Amount else
                                                Amt[1] := RunBal;

                                            LineNo := LineNo + 1000;
                                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                            Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                                            RecRef."No.", Format(RecRef."Pay Mode") + '- ( ' +
                                            Format(RecRef."EFT Options") + ' ) To-' + Format(Externpayment."Account No."),
                                            Amt[1], FosaAc."No.", Today, Externpayment."Account Type",
                                            Externpayment."Account No.", FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                            DocType::" ", '', AppliesToDocType::" ");
                                            RunBal := RunBal - Amt[1];

                                        end
                                    Until Externpayment.Next() = 0;
                                end;

                                Externpayment.Reset();
                                Externpayment.SetRange("Application No.", RecRef."No.");
                                Externpayment.SetRange("Member No.", RecRef."Member No.");
                                Externpayment.SetRange("Account Type", Externpayment."Account Type"::Savings);
                                if Externpayment.FindSet() then begin
                                    repeat

                                        Amt[2] := 0;
                                        if RunBal > 0 then begin

                                            if RunBal > Externpayment.Amount then
                                                Amt[2] := Externpayment.Amount else
                                                Amt[2] := RunBal;

                                            LineNo := LineNo + 1000;
                                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                            Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                                            RecRef."No.", Format(RecRef."Pay Mode") + '- ( ' +
                                            Format(RecRef."EFT Options") + ' ) To-' + Format(Externpayment."Account No."),
                                            Amt[2], FosaAc."No.", Today, AcctType::"G/L Account",
                                            '', FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                            DocType::" ", '', AppliesToDocType::" ");

                                            LineNo := LineNo + 1000;
                                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                            Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                                            RecRef."No.", Format(RecRef."Pay Mode") + '- ( ' +
                                            Format(RecRef."EFT Options") + ' ) To-' + Format(Externpayment."Account No."),
                                            Amt[2] * -1, Externpayment."Account No.", Today, AcctType::"G/L Account",
                                            '', FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                            DocType::" ", '', AppliesToDocType::" ");

                                            RunBal := RunBal - Abs(Amt[2]);

                                            AccBanking.SetRange("No.", Externpayment."Member No.");
                                            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Junior);
                                            if AccBanking.Find('-') then begin
                                                AccBanking.ModifyAll(Status, AccBanking.Status::Active);
                                            end;
                                        end
                                    Until Externpayment.Next() = 0;
                                end;
                            end;
                    end;

                    case PostInt of
                        0:
                            begin
                                JournalLine.Reset();
                                JournalLine.SetRange("Document No.", RecRef."No.");
                                JournalLine.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                                JournalLine.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                                if JournalLine.Find('-') then
                                    Page.Run(Page::"Journal Test Batch", JournalLine, JournalLine."Document No.");

                            end;
                        1:
                            begin
                                JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

                                NoticeRec.Reset();
                                NoticeRec.SetRange("No.", RecRef."Notice No.");
                                if NoticeRec.FindFirst() then begin
                                    NoticeRec.Paid := true;
                                    NoticeRec."Approval Status" := NoticeRec."Approval Status"::Posted;
                                    NoticeRec.Modify(true)
                                end;

                                Commit();
                                BnkMgt.GenerateEFTClosureFile(RecRef);

                                if not ApplicType then begin
                                    if CustomRecord.Get(RecRef."Member No.") then begin
                                        CustomRecord.Blocked := CustomRecord.Blocked::All;
                                        CustomRecord.Status := CustomRecord.Status::Withdrawn;
                                        CustomRecord."Withdrawal Date" := Today;
                                        CustomRecord.modify(true)
                                    end;

                                    AccBanking.SetRange("Member No.", RecRef."Member No.");
                                    if AccBanking.Find('-') then begin
                                        AccBanking.ModifyAll(Blocked, AccBanking.Blocked::All);
                                        AccBanking.ModifyAll(Status, AccBanking.Status::Withdrawn);
                                    end;

                                    Accredit.Reset();
                                    Accredit.SetRange("Member No.", RecRef."Member No.");
                                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                                    if Accredit.FindFirst() then begin
                                        Accredit.Blocked := Accredit.Blocked::All;
                                        Accredit.Status := Accredit.Status::Withdrawn;
                                        Accredit.Modify(true)
                                    end;

                                end else begin
                                    AccBanking.SetRange("Member No.", RecRef."Member No.");
                                    AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                                    if AccBanking.Find('-') then begin
                                        AccBanking.ModifyAll(Blocked, AccBanking.Blocked::All);
                                        AccBanking.ModifyAll(Status, AccBanking.Status::Deceased);
                                    end;
                                end;

                            end;
                    end;
                end;
            end;
        end;
    end;

    procedure GenerateEftFileOnClosure(RecRef: Record "Membership closure"; PostInt: Integer; PostPrev: Integer)
    var
        BnkMgt: Codeunit "Banking Procedure Mngt.";
    begin
        case RecRef."Document Type" of
            RecRef."Document Type"::"Membership Closure":
                begin
                    case RecRef."Closure Type" of
                        RecRef."Closure Type"::"Withdrawal - Normal":
                            begin
                                PerformPostOnAccClosureEFT(RecRef, '', '', 1, 0, false);
                            end;
                        RecRef."Closure Type"::"Withdrawal - Death":
                            begin
                                PerformPostOnAccClosureEFT(RecRef, '', '', 1, 1, true);
                            end;
                    end;
                end;
        end;
    end;

    procedure PerformPost(RecRef: Record "Membership closure"; PostInt: Integer; PostPrev: Integer)
    begin

        case RecRef."Document Type" of

            RecRef."Document Type"::"Account Closure":
                begin
                    if not RecRef.getAvailableAmt() then
                        PerformPostOnAccClosureNormal(RecRef, PostInt, PostPrev);
                end;
            RecRef."Document Type"::"Membership Closure":
                begin
                    case RecRef."Closure Type" of
                        RecRef."Closure Type"::"Withdrawal - Normal":
                            begin
                                if not RecRef.getAvailableAmt() then
                                    PerformPostOnAccClosureNormal(RecRef, PostInt, PostPrev);
                            end;
                        RecRef."Closure Type"::"Withdrawal - Death":
                            begin
                                PostOnMembClosureTxt(RecRef, PostInt, PostPrev);
                            end;
                    end;
                end;
        end;
    end;

    procedure PostOnMembClosureTxt(RecRef: Record "Membership closure"; PostInt: Integer; PostPrev: Integer)
    var
        AccountLine: Record "Account Closure Line";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        Temp: Record "Banking User Template";
        Loan: Record Loans;
        Account: Record "Account Credit";
        RunBal: Decimal;
        Member: Record Member;
        TotalLoan: Decimal;
        LineNo: Integer;
        AcctType: Enum "Gen. Journal Account Type";
        TransCharges: Record "Transaction Charge";
        gensetup: Record "General Set-Up";
        ProdFact: Record "Product Factory";
        BufferedInt: Decimal;
        Linterest: Decimal;
        LPrincipal: Decimal;
        Amt: array[5] of Decimal;
        AccBanking: Record "Account Banking";
        JournalLine: Record "Gen. Journal Line";
        MemClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        NotifSource: Enum NotifSourceType;
        HyperText: Text[250];
        Varvariant: Variant;
        Charges: Decimal;
        AmtPost: Decimal;
        ExciseDuty: Decimal;
        NoticeRec: Record "Member withdrawal Notice";
        TotalAmt: Decimal;
        BosaAcc: Record "Account Credit";
        CustRec: Record Customer;
        RegisterMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        FosaAc: Record "Account Banking";
        BosaRec: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        ErrorOnCreditDebitLines: Label 'Total liabilities Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnCreditLines: Label 'Total credit Amount of %1 cannot be more than the account Balance Of %2';
        Externpayment: Record "External Payment";
    begin

        gensetup.Get();
        gensetup.TestField("Excise Duty G/L");
        gensetup.TestField("Excise Duty G/L");
        HyperText := 'https://';

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

        RecRef.TestField("Member No.");
        RecRef.TestField(Remarks);

        if AppMngt.CheckBlockedDocsOnJnls(RecRef."No.", 50459) then begin

            if Member.Get(RecRef."Member No.") then
                RunBal := 0;
            TotalLoan := 0;
            Charges := 0;
            ExciseDuty := 0;
            AmtPost := 0;
            TotalAmt := 0;

            RecRef.CalcFields("Total Savings", "Total Liabilities");

            BosaRec.Reset();
            BosaRec.SetRange("Member No.", RecRef."Member No.");
            BosaRec.SetRange("Account Category", BosaRec."Account Category"::"Shares Deposit");
            if BosaRec.FindFirst() then
                RunBal := RecRef."Total Savings";
            TotalLoan := RegMgt.getCustLoanBalance(0, BosaRec."Member No.", 0);
            if RunBal <= TotalLoan then begin
                Error(ErrorOnCreditDebitLines, RecRef."Total Savings", TotalLoan);
            end;

            RecRef.TestField("Paying Account No.");

            AccBanking.Reset();
            AccBanking.SetRange("Member No.", RecRef."Member No.");
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            if AccBanking.Find('-') then begin

                LineNo := LineNo + 1000;
                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                Temp."Periodic Journal Batch",
                LineNo, AcctType::Vendor, RecRef."No.",
                'Account Closure Dues-' + Format(AccBanking."Account Category"),
                RecRef."Total Loan" * -1, AccBanking."No.", Today, RecRef."Account Type",
                RecRef."Paying Account No.", AccBanking."Member No.", Temp."Shortcut Dimension 1 Code",
                Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                DocType::" ", '', AppliesToDocType::" ");

            end;

            if RecRef."Other Charges" > 0 then begin

                TransCharges.Reset();
                TransCharges.SetRange("Transaction Type", RecRef."Transaction Type");
                if TransCharges.Find('-') then begin
                    repeat

                        LineNo := LineNo + 1000;
                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch",
                        LineNo, AcctType::Vendor,
                        RecRef."No.", TransCharges.Description,
                        RecRef."Other Charges", AccBanking."No.",
                        Today, AcctType::"G/L Account",
                        TransCharges."G/L Account",
                        Account."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code",
                        TransactionType::" ", '', '', '',
                        DocType::" ", '', AppliesToDocType::" ");

                        if TransCharges."Recover Excise Duty" then begin

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch",
                            LineNo, AcctType::Vendor, RecRef."No.", 'Excise Duty on ' + TransCharges.Description,
                            Round(RecRef."Other Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='),
                            AccBanking."No.", Today, AcctType::"G/L Account",
                            gensetup."Excise Duty G/L",
                            Account."Member No.",
                            Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code",
                            TransactionType::" ", '', '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;
                        RunBal := RunBal - (RecRef."Other Charges" + Round(RecRef."Other Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='));
                    until TransCharges.Next() = 0;
                end;
            end;

            if RecRef."Early Exit Charges" > 0 then begin
                if ProdFact.Get(Account."Product Type") then
                    TransCharges.Reset();
                TransCharges.SetRange("Transaction Type", ProdFact."Closure Fee");
                if TransCharges.Find('-') then begin
                    repeat
                        if RunBal > 0 then begin

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch",
                            LineNo, AcctType::Vendor,
                            RecRef."No.", TransCharges.Description,
                            RecRef."Early Exit Charges", AccBanking."No.",
                            Today, AcctType::"G/L Account",
                            TransCharges."G/L Account",
                            Account."Member No.",
                            Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code",
                            TransactionType::" ", '', '', '',
                            DocType::" ", '', AppliesToDocType::" ");

                            if TransCharges."Recover Excise Duty" then begin

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Vendor, RecRef."No.", 'Excise Duty on ' + TransCharges.Description,
                                Round(RecRef."Early Exit Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='),
                                AccBanking."No.", Today, AcctType::"G/L Account", gensetup."Excise Duty G/L",
                                Account."Member No.", Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                            end;
                            RunBal := RunBal - (RecRef."Early Exit Charges" + Round(RecRef."Early Exit Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='));
                        end;
                    until TransCharges.Next() = 0;
                end;
            end;

            AccountLine.Reset();
            AccountLine.SetRange("No.", RecRef."No.");
            if AccountLine.Find('-') then begin
                repeat

                    Amt[1] := 0;
                    Amt[2] := 0;
                    Amt[4] := 0;

                    Account.Reset();
                    Account.SetRange("No.", AccountLine."Account No.");
                    Account.SetRange("Member No.", RecRef."Member No.");
                    if Account.FindFirst() then begin
                        Account.CalcFields("Balance (LCY)");
                        if ProdFact.Get(Account."Product Type") then
                            ProdFact.TestField("Interest Payable Account");

                        if AccountLine."Accrued Interest" > 0 then begin
                            if ProdFact."Earns Interest" then begin
                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Customer,
                                RecRef."No.", 'Interest Earned On-' + Format(Account."Account Category"),
                                AccountLine."Accrued Interest" * -1, Account."No.",
                                Today, AcctType::"G/L Account", ProdFact."Interest Payable Account",
                                Account."Member No.", Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                            end;
                        end;


                        LineNo := LineNo + 1000;
                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch", LineNo, AcctType::Customer, RecRef."No.",
                        'Account Closure-' + Format(Account."Account Category"),
                        (Account."Balance (LCY)" + AccountLine."Accrued Interest"), Account."No.",
                        Today, AcctType::"G/L Account", '', Account."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                        DocType::" ", '', AppliesToDocType::" ");

                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", RecRef."Member No.");
                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                        if AccBanking.Find('-') then begin

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch",
                            LineNo, AcctType::Vendor,
                            RecRef."No.", 'Account Closure-' + Format(AccBanking."Account Category"),
                            (Account."Balance (LCY)" + AccountLine."Accrued Interest") * -1,
                            AccBanking."No.", Today, AcctType::"G/L Account", '',
                            Account."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;
                    end;

                    FosaAc.Reset();
                    FosaAc.SetRange("No.", AccountLine."Account No.");
                    FosaAc.SetRange("Member No.", RecRef."Member No.");
                    if FosaAc.FindFirst() then begin
                        FosaAc.CalcFields("Balance (LCY)");
                        if ProdFact.Get(Account."Product Type") then
                            ProdFact.TestField("Interest Payable Account");

                        if AccountLine."Accrued Interest" > 0 then begin
                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Vendor, RecRef."No.",
                            'Interest earned-' + Format(FosaAc."Account Category"),
                            AccountLine."Accrued Interest" * -1, FosaAc."No.",
                            Today, AcctType::"G/L Account", ProdFact."Interest Payable Account",
                            FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::" ",
                            '', '', '', DocType::" ", '', AppliesToDocType::" ");
                        end;

                        LineNo := LineNo + 1000;
                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                        RecRef."No.", 'Account Closure-' + Format(FosaAc."Account Category"),
                        (FosaAc."Balance (LCY)" + AccountLine."Accrued Interest"), FosaAc."No.",
                        Today, AcctType::"G/L Account", '', FosaAc."Member No.",
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                        DocType::" ", '', AppliesToDocType::" ");

                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", RecRef."Member No.");
                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                        if AccBanking.Find('-') then begin

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch",
                            LineNo, AcctType::Vendor, RecRef."No.",
                            'Account Closure-' + Format(AccBanking."Account Category"),
                            (FosaAc."Balance (LCY)" + AccountLine."Accrued Interest") * -1,
                            AccBanking."No.", Today, AcctType::"G/L Account", '',
                            AccBanking."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;

                    end;

                    Loan.Reset();
                    Loan.SetRange("No.", AccountLine."Loan No.");
                    Loan.SetFilter("Outstanding Balance", '>0');
                    if Loan.Find('-') then begin
                        Loan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal", "Outstanding Insurance");
                        if AccountLine."Accrued Interest" > 0 then begin
                            if ProdFact.Get(Loan."Product Type") then
                                LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(
                            Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Customer,
                            RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Interest Due") + '-' + Loan."No.",
                            AccountLine."Accrued Interest", Loan."Loan Account", Today, AcctType::"G/L Account",
                            ProdFact."Interest Account (G/L)", Account."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::"Interest Due", Loan."No.", '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;

                        if RunBal > 0 then begin

                            Amt[1] := (AccountLine."Accrued Interest" + Loan."Outstanding Interest");
                            if Amt[1] > RunBal then
                                Amt[1] := RunBal else
                                Amt[1] := Amt[1];

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(
                            Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                            RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Interest Paid") + '-' + Loan."No.",
                            Amt[1], AccBanking."No.", Today, AcctType::"G/L Account", '', Account."Member No.",
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            TransactionType::" ", '', '', '', DocType::" ", '', AppliesToDocType::" ");

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(
                            Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Customer,
                            RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Interest Paid") + '-' + Loan."No.",
                            Amt[1] * -1, Loan."Loan Account", Today, AcctType::"G/L Account", '',
                            Account."Member No.", Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            TransactionType::"Interest Paid", Loan."No.", '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                            RunBal := RunBal - Amt[1];

                        end;

                        if Loan."Outstanding Insurance" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > Loan."Outstanding Insurance" then
                                    Amt[3] := Loan."Outstanding Insurance" else
                                    Amt[3] := RunBal;

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Vendor,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Insurance Paid") + '-' + Loan."No.",
                                Amt[3], AccBanking."No.",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Customer,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Insurance Paid") + '-' + Loan."No.",
                                Amt[3] * -1,
                                Loan."Loan Account",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::"Insurance Paid", Loan."No.", '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                                RunBal := RunBal - Amt[3];
                            end;
                        end;


                        if Loan."Outstanding Principal" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > Loan."Outstanding Principal" then
                                    Amt[2] := Loan."Outstanding Principal" else
                                    Amt[2] := RunBal;

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Vendor,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::Repayment) + '-' + Loan."No.",
                                Amt[2], AccBanking."No.",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Customer,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::Repayment) + '-' + Loan."No.",
                                Amt[2] * -1,
                                Loan."Loan Account",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::Repayment, Loan."No.", '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                                RunBal := RunBal - Amt[2];
                            end;
                        end;
                    end;

                until AccountLine.Next() = 0;
            end;
            case PostInt of
                0:
                    begin

                        JournalLine.Reset();
                        JournalLine.SetRange("Document No.", RecRef."No.");
                        JournalLine.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                        JournalLine.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                        if JournalLine.Find('-') then
                            Page.Run(Page::"Journal Test Batch", JournalLine, JournalLine."Document No.");
                    end;
                1:
                    begin
                        JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

                        if CustomRecord.Get(RecRef."Member No.") then begin
                            CustomRecord.Blocked := CustomRecord.Blocked::All;
                            CustomRecord.Status := CustomRecord.Status::Deceased;
                            CustomRecord."Withdrawal Date" := Today;
                            CustomRecord.modify(true)
                        end;

                        FosaAc.Reset();
                        FosaAc.SetRange("Member No.", RecRef."Member No.");
                        FosaAc.SetFilter("Account Category", '<>%1&<>%2', FosaAc."Account Category"::Junior, FosaAc."Account Category"::Savings);
                        if FosaAc.FindFirst() then begin
                            FosaAc.ModifyAll(Blocked, FosaAc.Blocked::All);
                            FosaAc.ModifyAll(Status, FosaAc.Status::Deceased);
                        end;

                        Accredit.Reset();
                        Accredit.SetRange("Member No.", RecRef."Member No.");
                        Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                        if Accredit.FindFirst() then begin
                            Accredit.Blocked := Accredit.Blocked::All;
                            Accredit.Status := Accredit.Status::Deceased;
                            Accredit.Modify(true)
                        end;

                        MonthlyContrib.Reset();
                        MonthlyContrib.SetRange("Account No.", RecRef."Member No.");
                        if MonthlyContrib.FindSet() then begin
                            MonthlyContrib.ModifyAll(Amount, 0);
                            MonthlyContrib.ModifyAll("Advise Type", MonthlyContrib."Advise Type"::Stoppage);
                        end;

                        if MemClosure.Get(RecRef."No.") then begin

                            MemClosure.Posted := true;
                            MemClosure."Posted By" := UserId;
                            MemClosure."Time Posted" := Time;
                            MemClosure."Date Posted" := Today;
                            MemClosure."Approval Status" := MemClosure."Approval Status"::Posted;
                            MemClosure.Modify(true);

                            if NoticeRec.Get(MemClosure."Notice No.") then begin
                                NoticeRec."Approval Status" := NoticeRec."Approval Status"::Posted;
                                NoticeRec.Paid := true;
                                NoticeRec.Modify(true)
                            end;

                            Notif.CreateSmsNotif(NotifSource::"Account Status",
                            CustomRecord."Mobile Phone No", 'Dear ' + CustomRecord."First Name" +
                            ', your membership withdrawal has been processed. Consider rejoining through ' + HyperText, RecRef."No.", CustomRecord."No.", false);
                            Varvariant := RecRef;
                        end;
                    end;
            end;
        end else begin
            Error(ErrorOnNotApprovedApplic);
        end;
    end;

    procedure PerformPostOnAccClosureNormal(RecRef: Record "Membership closure"; PostInt: Integer; PostPrev: Integer)
    var
        AccountLine: Record "Account Closure Line";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        Temp: Record "Banking User Template";
        Loan: Record Loans;
        Account: Record "Account Credit";
        RunBal: Decimal;
        Member: Record Member;
        TotalLoan: Decimal;
        LineNo: Integer;
        AcctType: Enum "Gen. Journal Account Type";
        TransCharges: Record "Transaction Charge";
        gensetup: Record "General Set-Up";
        ProdFact: Record "Product Factory";
        BufferedInt: Decimal;
        Linterest: Decimal;
        LPrincipal: Decimal;
        Amt: array[5] of Decimal;
        AccBanking: Record "Account Banking";
        JournalLine: Record "Gen. Journal Line";
        MemClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        NotifSource: Enum NotifSourceType;
        HyperText: Text[250];
        Varvariant: Variant;
        Charges: Decimal;
        AmtPost: Decimal;
        AccruedInterest: Decimal;
        ExciseDuty: Decimal;
        NoticeRec: Record "Member withdrawal Notice";
        TotalAmt: Decimal;
        BosaAcc: Record "Account Credit";
        CustRec: Record Customer;
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        RegisterMngt: Codeunit "Register Management";
        DocPostMgt: Codeunit "Doc-PostMgt";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        FosaAc: Record "Account Banking";
        BosaRec: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        ErrorOnCreditDebitLines: Label 'Total liabilities Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnCreditLines: Label 'Total credit Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnExistLoanApp: Label 'Member has an exiting Loan attached to this account';
        Externpayment: Record "External Payment";
        RepayAcc: Record "Repayment Account";

    begin

        gensetup.Get();
        //gensetup.TestField("Excise Duty G/L");
        //gensetup.TestField("Excise Duty G/L");
        HyperText := 'https://';

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

        RecRef.TestField("Member No.");
        RecRef.TestField(Remarks);

        if AppMngt.CheckBlockedDocsOnJnls(RecRef."No.", Database::"Membership closure") then begin

            if Member.Get(RecRef."Member No.") then
                RunBal := 0;
            TotalLoan := 0;
            Charges := 0;
            ExciseDuty := 0;
            AmtPost := 0;
            TotalAmt := 0;
            AccruedInterest := 0;

            StartDate := CalcDate('-CM', Today);
            EndDate := Today;
            IntDays := (EndDate - StartDate) + 1;

            RecRef.CalcFields("Total Savings", "Total Liabilities");

            case RecRef."Document Type" of
                RecRef."Document Type"::"Account Closure":
                    begin
                        FosaAc.Reset();
                        FosaAc.SetRange("No.", RecRef."Account No.");
                        if FosaAc.FindFirst() then begin
                            FosaAc.CalcFields("Balance (LCY)");
                            RunBal := FosaAc."Balance (LCY)";
                            if DocPostMgt.CheckLienAccLoan(FosaAc."No.") then
                                Error(ErrorOnExistLoanApp);
                        end;
                    end;
                RecRef."Document Type"::"Membership Closure":
                    begin

                        BosaRec.Reset();
                        BosaRec.SetRange("Member No.", RecRef."Member No.");
                        BosaRec.SetRange("Account Category", BosaRec."Account Category"::"Shares Deposit");
                        if BosaRec.FindFirst() then
                            BosaRec.CalcFields("Balance (LCY)");
                        RunBal := BosaRec."Balance (LCY)";
                        TotalLoan := RegMgt.getCustAccruedIntLoanBalance(0, BosaRec."Member No.", 0);
                        if RunBal <= TotalLoan then begin
                            Error(ErrorOnCreditDebitLines, BosaRec."Balance (LCY)", TotalLoan);
                        end;
                    end;
            end;

            FosaAc.Reset();
            FosaAc.SetRange("Member No.", RecRef."Member No.");
            FosaAc.SetRange("Account Category", FosaAc."Account Category"::Savings);
            if FosaAc.FindFirst() then begin
                FosaAc.CalcFields("Balance (LCY)");

                if (RecRef."Other Charges" + RecRef."Early Exit Charges") <= FosaAc."Balance (LCY)" then begin
                    if RecRef."Other Charges" > 0 then begin

                        TransCharges.Reset();
                        TransCharges.SetRange("Transaction Type", RecRef."Transaction Type");
                        if TransCharges.Find('-') then begin
                            repeat

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Vendor, RecRef."No.", TransCharges.Description,
                                RecRef."Other Charges", FosaAc."No.", Today, AcctType::"G/L Account",
                                TransCharges."G/L Account", Account."Member No.",
                                Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                                TransactionType::" ", '', '', '', DocType::" ", '', AppliesToDocType::" ");

                                if TransCharges."Recover Excise Duty" then begin

                                    LineNo := LineNo + 1000;
                                    JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                    Temp."Periodic Journal Batch",
                                    LineNo, AcctType::Vendor, RecRef."No.", 'Excise Duty on ' + TransCharges.Description,
                                    Round(RecRef."Other Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='),
                                    FosaAc."No.", Today, AcctType::"G/L Account", gensetup."Excise Duty G/L",
                                    FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                    Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                    DocType::" ", '', AppliesToDocType::" ");
                                end;
                                RunBal := RunBal - (RecRef."Other Charges" + Round(RecRef."Other Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='));
                            until TransCharges.Next() = 0;
                        end;
                    end;

                    if RecRef."Early Exit Charges" > 0 then begin

                        if ProdFact.Get(FosaAc."Product Type") then
                            ProdFact.TestField("Closure Fee");

                        TransCharges.Reset();
                        TransCharges.SetRange("Transaction Type", ProdFact."Closure Fee");
                        if TransCharges.Find('-') then begin
                            repeat
                                if RunBal > 0 then begin

                                    LineNo := LineNo + 1000;
                                    JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                    Temp."Periodic Journal Batch",
                                    LineNo, AcctType::Vendor,
                                    RecRef."No.", TransCharges.Description,
                                    RecRef."Early Exit Charges", FosaAc."No.",
                                    Today, AcctType::"G/L Account", TransCharges."G/L Account",
                                    FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                    Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                    DocType::" ", '', AppliesToDocType::" ");

                                    if TransCharges."Recover Excise Duty" then begin

                                        LineNo := LineNo + 1000;
                                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                        Temp."Periodic Journal Batch",
                                        LineNo, AcctType::Vendor, RecRef."No.", 'Excise Duty on ' + TransCharges.Description,
                                        Round(RecRef."Early Exit Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='),
                                        FosaAc."No.", Today, AcctType::"G/L Account", gensetup."Excise Duty G/L",
                                        FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                        DocType::" ", '', AppliesToDocType::" ");
                                    end;
                                    RunBal := RunBal - (RecRef."Early Exit Charges" + Round(RecRef."Early Exit Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='));
                                end;
                            until TransCharges.Next() = 0;
                        end;
                    end;
                end else begin
                    Error(ErrorOnCreditDebitLines);
                end
            end;

            AccountLine.Reset();
            AccountLine.SetRange("No.", RecRef."No.");
            if AccountLine.Find('-') then begin
                repeat

                    Amt[1] := 0;
                    Amt[2] := 0;
                    Amt[4] := 0;

                    Account.Reset();
                    Account.SetRange("No.", AccountLine."Account No.");
                    Account.SetRange("Member No.", RecRef."Member No.");
                    if Account.FindFirst() then begin
                        Account.CalcFields("Balance (LCY)");
                        if ProdFact.Get(Account."Product Type") then
                            if AccountLine."Accrued Interest" > 0 then begin
                                ProdFact.TestField("Interest Payable Account");

                                if ProdFact."Earns Interest" then begin
                                    LineNo := LineNo + 1000;
                                    JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                    Temp."Periodic Journal Batch",
                                    LineNo, AcctType::Customer,
                                    RecRef."No.", 'Interest Earned On-' + Format(Account."Account Category"),
                                    AccountLine."Accrued Interest" * -1, Account."No.",
                                    Today, AcctType::"G/L Account", ProdFact."Interest Payable Account",
                                    Account."Member No.", Temp."Shortcut Dimension 1 Code",
                                    Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                                    DocType::" ", '', AppliesToDocType::" ");
                                end;
                            end;

                        LineNo := LineNo + 1000;
                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch", LineNo, AcctType::Customer, RecRef."No.",
                        'Account Closure-' + Format(Account."Account Category"),
                        (Account."Balance (LCY)" + AccountLine."Accrued Interest"), Account."No.",
                        Today, AcctType::"G/L Account", '', Account."Member No.", Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                        DocType::" ", '', AppliesToDocType::" ");

                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", RecRef."Member No.");
                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                        if AccBanking.Find('-') then begin

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch",
                            LineNo, AcctType::Vendor,
                            RecRef."No.", 'Account Closure-' + Format(AccBanking."Account Category"),
                            (Account."Balance (LCY)" + AccountLine."Accrued Interest") * -1,
                            AccBanking."No.", Today, AcctType::"G/L Account", '',
                            Account."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;
                    end;

                    FosaAc.Reset();
                    FosaAc.SetRange("No.", AccountLine."Account No.");
                    FosaAc.SetRange("Member No.", RecRef."Member No.");
                    if FosaAc.FindFirst() then begin
                        FosaAc.CalcFields("Balance (LCY)");
                        if ProdFact.Get(Account."Product Type") then
                            if AccountLine."Accrued Interest" > 0 then begin
                                ProdFact.TestField("Interest Payable Account");
                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch", LineNo, AcctType::Vendor, RecRef."No.",
                                'Interest earned-' + Format(FosaAc."Account Category"),
                                AccountLine."Accrued Interest" * -1, FosaAc."No.",
                                Today, AcctType::"G/L Account", ProdFact."Interest Payable Account",
                                FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code", TransactionType::" ",
                                '', '', '', DocType::" ", '', AppliesToDocType::" ");
                            end;

                        LineNo := LineNo + 1000;
                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                        RecRef."No.", 'Account Closure-' + Format(FosaAc."Account Category"),
                        (FosaAc."Balance (LCY)" + AccountLine."Accrued Interest"), FosaAc."No.",
                        Today, AcctType::"G/L Account", '', FosaAc."Member No.", Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                        DocType::" ", '', AppliesToDocType::" ");

                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", RecRef."Member No.");
                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                        if AccBanking.Find('-') then begin

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch",
                            LineNo, AcctType::Vendor, RecRef."No.",
                            'Account Closure-' + Format(AccBanking."Account Category"),
                            (FosaAc."Balance (LCY)" + AccountLine."Accrued Interest") * -1,
                            AccBanking."No.", Today, AcctType::"G/L Account", '',
                            AccBanking."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::" ", '', '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;
                    end;

                    Loan.Reset();
                    Loan.SetRange("No.", AccountLine."Loan No.");
                    Loan.SetFilter("Outstanding Balance", '>0');
                    if Loan.Find('-') then begin
                        Loan.CalcFields("Outstanding Balance", "Outstanding Interest",
                        "Outstanding Principal", "Outstanding Insurance");
                        AccruedInterest := 0;

                        case gensetup."Interest Posting Method" of
                            gensetup."Interest Posting Method"::"Charge Daily":
                                begin
                                    AccruedInterest := PeriodActMngt.fnIntEntriesonSpecificLoan(Loan, Today, Loan."No.", 1, IntDays, Today)
                                end else begin
                                AccruedInterest := 0;
                            end;
                        end;

                        if AccruedInterest > 0 then begin

                            if ProdFact.Get(Loan."Product Type") then
                                LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(
                            Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Customer,
                            RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Interest Due") + '-' + Loan."No.",
                            AccountLine."Accrued Interest", Loan."Loan Account", Today, AcctType::"G/L Account",
                            ProdFact."Interest Account (G/L)", Account."Member No.", Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", TransactionType::"Interest Due", Loan."No.", '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                        end;

                        if RunBal > 0 then begin

                            Amt[1] := (AccruedInterest + Loan."Outstanding Interest");
                            if Amt[1] > RunBal then
                                Amt[1] := RunBal else
                                Amt[1] := Amt[1];

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(
                            Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Vendor,
                            RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Interest Paid") + '-' + Loan."No.",
                            Amt[1], AccBanking."No.", Today, AcctType::"G/L Account", '', Account."Member No.",
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            TransactionType::" ", '', '', '', DocType::" ", '', AppliesToDocType::" ");

                            LineNo := LineNo + 1000;
                            JnlPostMngt.PostJournal(
                            Temp."Periodic Journal Template",
                            Temp."Periodic Journal Batch", LineNo, AcctType::Customer,
                            RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Interest Paid") + '-' + Loan."No.",
                            Amt[1] * -1, Loan."Loan Account", Today, AcctType::"G/L Account", '',
                            Account."Member No.", Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            TransactionType::"Interest Paid", Loan."No.", '', '',
                            DocType::" ", '', AppliesToDocType::" ");
                            RunBal := RunBal - Amt[1];

                        end;

                        if Loan."Outstanding Insurance" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > Loan."Outstanding Insurance" then
                                    Amt[3] := Loan."Outstanding Insurance" else
                                    Amt[3] := RunBal;

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Vendor,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Insurance Paid") + '-' + Loan."No.",
                                Amt[3], AccBanking."No.",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Customer,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::"Insurance Paid") + '-' + Loan."No.",
                                Amt[3] * -1,
                                Loan."Loan Account",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::"Insurance Paid", Loan."No.", '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                                RunBal := RunBal - Amt[3];
                            end;
                        end;


                        if Loan."Outstanding Principal" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > Loan."Outstanding Principal" then
                                    Amt[2] := Loan."Outstanding Principal" else
                                    Amt[2] := RunBal;

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Vendor,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::Repayment) + '-' + Loan."No.",
                                Amt[2], AccBanking."No.",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::" ", '', '', '',
                                DocType::" ", '', AppliesToDocType::" ");

                                LineNo := LineNo + 1000;
                                JnlPostMngt.PostJournal(
                                Temp."Periodic Journal Template",
                                Temp."Periodic Journal Batch",
                                LineNo, AcctType::Customer,
                                RecRef."No.", 'Ac-Closure-' + Format(TransactionType::Repayment) + '-' + Loan."No.",
                                Amt[2] * -1,
                                Loan."Loan Account",
                                Today, AcctType::"G/L Account", '',
                                Account."Member No.",
                                Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code",
                                TransactionType::Repayment, Loan."No.", '', '',
                                DocType::" ", '', AppliesToDocType::" ");
                                RunBal := RunBal - Amt[2];
                            end;
                        end;
                    end;
                until AccountLine.Next() = 0;
            end;

            case PostInt of
                0:
                    begin

                        JournalLine.Reset();
                        JournalLine.SetRange("Document No.", RecRef."No.");
                        JournalLine.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                        JournalLine.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                        if JournalLine.Find('-') then
                            Page.Run(Page::"Journal Test Batch", JournalLine, JournalLine."Document No.");
                    end;
                1:
                    begin
                        JnlPostMngt.CompletePosting(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch");
                        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch");

                        case RecRef."Pay Mode" of
                            RecRef."Pay Mode"::Cheque:
                                begin

                                    AccBanking.Reset();
                                    AccBanking.SetRange("Member No.", RecRef."Member No.");
                                    AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                                    if AccBanking.FindFirst() then begin
                                        AccBanking.CalcFields("Balance (LCY)");
                                        if AccBanking."Balance (LCY)" > 0 then begin
                                            LineNo := LineNo + 1000;
                                            InitDebitBankingAcc(AccBanking."No.", AccBanking."Balance (LCY)", RecRef."No.", Today,
                                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                                            Temp."Periodic Journal Template", Temp."Periodic Journal Batch", RecRef."Account Type",
                                            RecRef."Paying Account No.", LineNo, RecRef."Member No.", 'Ac-Closure-' + Format(RecRef."Closure Type"));
                                            JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");
                                        end
                                    end
                                end
                        end;

                        case RecRef."Document Type" of
                            RecRef."Document Type"::"Account Closure":
                                begin
                                    AccBanking.Reset();
                                    AccBanking.SetRange("No.", RecRef."Account No.");
                                    if AccBanking.FindFirst() then begin
                                        AccBanking.Blocked := AccBanking.Blocked::All;
                                        AccBanking.Status := AccBanking.Status::Closed;
                                        AccBanking.Modify(true)
                                    end;
                                end;

                            RecRef."Document Type"::"Membership Closure":
                                begin

                                    if CustomRecord.Get(RecRef."Member No.") then begin
                                        CustomRecord.Blocked := CustomRecord.Blocked::All;
                                        CustomRecord.Status := CustomRecord.Status::Withdrawn;
                                        CustomRecord."Withdrawal Date" := Today;
                                        CustomRecord.modify(true);

                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", RecRef."Member No.");
                                        if AccBanking.FindFirst() then begin
                                            AccBanking.ModifyAll(Blocked, AccBanking.Blocked::All);
                                            AccBanking.ModifyAll(Status, AccBanking.Status::Withdrawn);
                                        end;
                                        RepayAcc.SetRange("Member No.", RecRef."Member No.");
                                        RepayAcc.SetRange("Account Category", RepayAcc."Account Category"::Repayment);
                                        if RepayAcc.FindFirst() then begin
                                            RepayAcc.Blocked := RepayAcc.Blocked::All;
                                            RepayAcc.Status := RepayAcc.Status::Withdrawn;
                                            RepayAcc.Modify(true)
                                        end;

                                        Accredit.Reset();
                                        Accredit.SetRange("Member No.", RecRef."Member No.");
                                        Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                                        if Accredit.FindFirst() then begin
                                            Accredit.Blocked := Accredit.Blocked::All;
                                            Accredit.Status := Accredit.Status::Withdrawn;
                                            Accredit.Modify(true)
                                        end;
                                    end;
                                end;
                        end;

                        NoticeRec.Reset();
                        NoticeRec.SetRange("No.", RecRef."Notice No.");
                        if NoticeRec.FindFirst() then begin
                            NoticeRec.Paid := true;
                            NoticeRec."Approval Status" := NoticeRec."Approval Status"::Posted;
                            NoticeRec.Modify(true)
                        end;

                        MonthlyContrib.Reset();
                        MonthlyContrib.SetRange("Account No.", RecRef."Member No.");
                        if MonthlyContrib.FindSet() then begin
                            MonthlyContrib.ModifyAll(Amount, 0);
                            MonthlyContrib.ModifyAll("Advise Type", MonthlyContrib."Advise Type"::Stoppage);
                        end;

                        if MemClosure.Get(RecRef."No.") then begin

                            MemClosure.Posted := true;
                            MemClosure."Posted By" := UserId;
                            MemClosure."Time Posted" := Time;
                            MemClosure."Date Posted" := Today;
                            MemClosure."Approval Status" := MemClosure."Approval Status"::Posted;
                            MemClosure.Modify(true);

                            if NoticeRec.Get(MemClosure."Notice No.") then begin
                                NoticeRec."Approval Status" := NoticeRec."Approval Status"::Posted;
                                NoticeRec.Paid := true;
                                NoticeRec.Modify(true)
                            end;

                            Notif.CreateSmsNotif(NotifSource::"Account Status",
                            CustomRecord."Mobile Phone No", 'Dear ' + CustomRecord."First Name" +
                            ', your membership withdrawal has been processed. Consider rejoining through ' + HyperText, RecRef."No.", CustomRecord."No.", false);
                            Varvariant := RecRef;
                        end;
                    end;
            end;
        end else begin
            Error(ErrorOnNotApprovedApplic);
        end;
    end;

    local procedure InitDebitBankingAcc(AccNo: Code[100]; AmtoPost: Decimal; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; BalAcType: Enum "Gen. Journal Account Type"; BalAccNo: Code[100]; LineNo: Integer; ExtDocNo: Code[100]; TextDescription: Text[100])
    var
        LoanT: Record Loans;
        JnlPostMngt: Codeunit "Journal Post Mngt.";
    begin
        JnlPostMngt.ClearJournalLines(GnlTemplate, GnlJBatch);
        LineNo := LineNo + 100;
        JnlPostMngt.CreateJnl(GnlTemplate, GnlJBatch, LineNo,
        Enum::"Gen. Journal Account Type"::Vendor,
        DocumentNo, TextDescription + '-' + DocumentNo,
        AmtoPost, AccNo, PDate,
        Enum::"Gen. Journal Account Type"::"Bank Account",
        BalAccNo, ExtDocNo, DActivity, DBranch,
        Enum::"LoanTransactionType"::" ", '', '', '',
        Enum::"Gen. Journal Document Type"::" ",
        '', Enum::"Gen. Journal Document Type"::" ", DocumentNo);
        JnlPostMngt.CompletePosting(GnlTemplate, GnlJBatch);
    end;



    procedure PerformPostOnAccClosureTxt(RecRef: Record "Membership closure"; Template: Code[10]; Batch: Code[10]; PostInt: Integer; PostPrev: Integer)
    var
        AccountLine: Record "Account Closure Line";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        Temp: Record "Banking User Template";
        Loan: Record Loans;
        Account: Record "Account Credit";
        RunBal: Decimal;
        Member: Record Member;
        TotalLoan: Decimal;
        LineNo: Integer;
        AcctType: Enum "Gen. Journal Account Type";
        TransCharges: Record "Transaction Charge";
        gensetup: Record "General Set-Up";
        ProdFact: Record "Product Factory";
        BufferedInt: Decimal;
        Linterest: Decimal;
        LPrincipal: Decimal;
        Amt: array[5] of Decimal;
        AccBanking: Record "Account Banking";
        JournalLine: Record "Gen. Journal Line";
        MemClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        NotifSource: Enum NotifSourceType;
        HyperText: Text[250];
        Varvariant: Variant;
        Charges: Decimal;
        AmtPost: Decimal;
        ExciseDuty: Decimal;
        NoticeRec: Record "Member withdrawal Notice";
        TotalAmt: Decimal;
        BosaAcc: Record "Account Credit";
        CustRec: Record Customer;
        RegisterMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        FosaAc: Record "Account Banking";
        BosaRec: Record "Account Credit";
        MonthlyContrib: Record "Member Monthly Contribution";
        ErrorOnCreditDebitLines: Label 'Total liabilities Amount of %1 cannot be more than the account Balance Of %2';
        ErrorOnCreditLines: Label 'Total credit Amount of %1 cannot be more than the account Balance Of %2';
        Externpayment: Record "External Payment";
    begin

        gensetup.Get();
        gensetup.TestField("Excise Duty G/L");
        gensetup.TestField("Excise Duty G/L");
        HyperText := 'https://';

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

        RecRef.TestField("Member No.");
        RecRef.TestField(Remarks);

        if AppMngt.CheckBlockedDocsOnJnls(RecRef."No.", 50459) then begin

            if Member.Get(RecRef."Member No.") then
                RunBal := 0;
            TotalLoan := 0;
            Charges := 0;
            ExciseDuty := 0;
            AmtPost := 0;
            TotalAmt := 0;

            Case RecRef."Document Type" of
                RecRef."Document Type"::"Account Closure":
                    begin

                        case RecRef."Customer Type" of
                            RecRef."Customer Type"::Groups:
                                begin

                                    AccBanking.Reset();
                                    AccBanking.SetRange("No.", RecRef."Account No.");
                                    if AccBanking.Find('-') then begin
                                        AccBanking.CalcFields("Balance (LCY)");

                                        if RecRef."Other Charges" > AccBanking."Balance (LCY)" then
                                            Error('No enough funds to facilitate this transaction');

                                        if RecRef."Other Charges" > 0 then begin

                                            TransCharges.Reset();
                                            TransCharges.SetRange("Transaction Type", RecRef."Transaction Type");
                                            if TransCharges.Find('-') then begin

                                                Charges := RecRef."Other Charges";

                                                LineNo := LineNo + 1000;
                                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                Temp."Periodic Journal Batch",
                                                LineNo, AcctType::Vendor,
                                                RecRef."No.", TransCharges.Description,
                                                RecRef."Other Charges", AccBanking."No.",
                                                Today, AcctType::"G/L Account",
                                                TransCharges."G/L Account",
                                                AccBanking."Member No.",
                                                Temp."Shortcut Dimension 1 Code",
                                                Temp."Shortcut Dimension 2 Code",
                                                TransactionType::" ", '', '', '',
                                                DocType::" ", '', AppliesToDocType::" ");

                                                if TransCharges."Recover Excise Duty" then begin

                                                    LineNo := LineNo + 1000;
                                                    JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                    Temp."Periodic Journal Batch",
                                                    LineNo, AcctType::Vendor, RecRef."No.", 'Excise Duty on ' + TransCharges.Description,
                                                    Round(RecRef."Other Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='),
                                                    AccBanking."No.", Today, AcctType::"G/L Account",
                                                    gensetup."Excise Duty G/L",
                                                    AccBanking."Member No.",
                                                    Temp."Shortcut Dimension 1 Code",
                                                    Temp."Shortcut Dimension 2 Code",
                                                    TransactionType::" ", '', '', '',
                                                    DocType::" ", '', AppliesToDocType::" ");
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            RecRef."Customer Type"::Individual:
                                begin
                                    case RecRef."Transfer Type" of
                                        RecRef."Transfer Type"::Other:
                                            begin

                                                AccBanking.Reset();
                                                AccBanking.SetRange("No.", RecRef."Account No.");
                                                if AccBanking.Find('-') then begin
                                                    AccBanking.CalcFields("Balance (LCY)");

                                                    AccountLine.Reset();
                                                    AccountLine.SetRange("No.", RecRef."No.");
                                                    if AccountLine.FindSet() then begin
                                                        AccountLine.CalcSums("Amount to Post");
                                                        TotalAmt := AccountLine."Amount to Post"
                                                    end;
                                                    if TotalAmt > AccBanking."Balance (LCY)" then
                                                        Error(ErrorOnCreditLines, TotalAmt, AccBanking."Balance (LCY)");
                                                end;
                                                AccountLine.Reset();
                                                AccountLine.SetRange("No.", RecRef."No.");
                                                if AccountLine.FindSet() then begin
                                                    repeat

                                                        BosaAcc.Reset();
                                                        BosaAcc.SetRange("No.", AccountLine."Account No.");
                                                        if BosaAcc.FindFirst() then begin

                                                            CustRec.Reset();
                                                            CustRec.SetRange("No.", BosaAcc."No.");
                                                            if not CustRec.FindFirst() then begin
                                                                RegisterMngt.fnCreateCustMemberPostAc(BosaAcc."No.",
                                                                BosaAcc.Name, '',
                                                                BosaAcc."Global Dimension 1 Code",
                                                                BosaAcc."Global Dimension 2 Code",
                                                                BosaAcc."Customer Posting Group", '',
                                                                BosaAcc.Status, BosaAcc."Product Type",
                                                                BosaAcc."ID/Passport No.",
                                                                BosaAcc."Member No.",
                                                                CustomerAccType::"Credit Account",
                                                                AccDimension::Credit, BosaAcc."Account Category");
                                                            end;
                                                        end;

                                                        LineNo := LineNo + 1000;
                                                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                        Temp."Periodic Journal Batch",
                                                        LineNo, AcctType::Vendor,
                                                        RecRef."No.", 'Account Closure-' + RecRef."Member Name",
                                                        AccountLine."Amount to Post", RecRef."Account No.",
                                                        Today, AcctType::"G/L Account", '',
                                                        RecRef."Member No.",
                                                        Temp."Shortcut Dimension 1 Code",
                                                        Temp."Shortcut Dimension 2 Code",
                                                        TransactionType::" ", '', '', '',
                                                        DocType::" ", '', AppliesToDocType::" ");

                                                        if BosaRec.Get(AccountLine."Account No.") then
                                                            LineNo := LineNo + 1000;
                                                        JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                        Temp."Periodic Journal Batch",
                                                        LineNo, AcctType::Customer,
                                                        RecRef."No.", 'Account Closure-' + BosaRec.Name,
                                                        AccountLine."Amount to Post" * -1, AccountLine."Account No.",
                                                        Today, AcctType::"G/L Account", '',
                                                        RecRef."Member No.",
                                                        Temp."Shortcut Dimension 1 Code",
                                                        Temp."Shortcut Dimension 2 Code",
                                                        TransactionType::" ", '', '', '',
                                                        DocType::" ", '', AppliesToDocType::" ");

                                                    until AccountLine.Next() = 0;
                                                end;
                                            end;
                                        RecRef."Transfer Type"::Self:
                                            begin

                                                AccBanking.Reset();
                                                AccBanking.SetRange("No.", RecRef."Account No.");
                                                if AccBanking.Find('-') then begin
                                                    AccBanking.CalcFields("Balance (LCY)");
                                                    AmtPost := AccBanking."Balance (LCY)";

                                                    if RecRef."Other Charges" > AccBanking."Balance (LCY)" then
                                                        Error('No enough funds to facilitate this transaction');

                                                    LineNo := LineNo + 1000;
                                                    JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                    Temp."Periodic Journal Batch",
                                                    LineNo, AcctType::Vendor,
                                                    RecRef."No.", 'Account Closure-' + AccBanking.Name,
                                                    AccBanking."Balance (LCY)", AccBanking."No.",
                                                    Today, AcctType::"G/L Account", '',
                                                    AccBanking."Member No.",
                                                    Temp."Shortcut Dimension 1 Code",
                                                    Temp."Shortcut Dimension 2 Code",
                                                    TransactionType::" ", '', '', '',
                                                    DocType::" ", '', AppliesToDocType::" ");

                                                end;

                                                AccBanking.Reset();
                                                AccBanking.SetRange("No.", RecRef."Destination Account No.");
                                                if AccBanking.Find('-') then begin

                                                    LineNo := LineNo + 1000;
                                                    JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                    Temp."Periodic Journal Batch",
                                                    LineNo, AcctType::Vendor,
                                                    RecRef."No.", 'Account Closure-' + AccBanking.Name,
                                                    AmtPost * -1, AccBanking."No.",
                                                    Today, AcctType::"G/L Account", '',
                                                    AccBanking."Member No.",
                                                    Temp."Shortcut Dimension 1 Code",
                                                    Temp."Shortcut Dimension 2 Code",
                                                    TransactionType::" ", '', '', '',
                                                    DocType::" ", '', AppliesToDocType::" ");

                                                    if RecRef."Other Charges" > 0 then begin

                                                        TransCharges.Reset();
                                                        TransCharges.SetRange("Transaction Type", RecRef."Transaction Type");
                                                        if TransCharges.Find('-') then begin

                                                            Charges := RecRef."Other Charges";

                                                            LineNo := LineNo + 1000;
                                                            JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                            Temp."Periodic Journal Batch",
                                                            LineNo, AcctType::Vendor,
                                                            RecRef."No.", TransCharges.Description,
                                                            RecRef."Other Charges", AccBanking."No.",
                                                            Today, AcctType::"G/L Account",
                                                            TransCharges."G/L Account",
                                                            AccBanking."Member No.",
                                                            Temp."Shortcut Dimension 1 Code",
                                                            Temp."Shortcut Dimension 2 Code",
                                                            TransactionType::" ", '', '', '',
                                                            DocType::" ", '', AppliesToDocType::" ");

                                                            if TransCharges."Recover Excise Duty" then begin

                                                                LineNo := LineNo + 1000;
                                                                JnlPostMngt.PostJournal(Temp."Periodic Journal Template",
                                                                Temp."Periodic Journal Batch",
                                                                LineNo, AcctType::Vendor, RecRef."No.", 'Excise Duty on ' + TransCharges.Description,
                                                                Round(RecRef."Other Charges" * (gensetup."Excise Duty (%)" / 100), 1, '='),
                                                                AccBanking."No.", Today, AcctType::"G/L Account",
                                                                gensetup."Excise Duty G/L",
                                                                AccBanking."Member No.",
                                                                Temp."Shortcut Dimension 1 Code",
                                                                Temp."Shortcut Dimension 2 Code",
                                                                TransactionType::" ", '', '', '',
                                                                DocType::" ", '', AppliesToDocType::" ");
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                    end;
                                end;
                        end;
                    end;
            end;

            case PostInt of
                0:
                    begin

                        JournalLine.Reset();
                        JournalLine.SetRange("Document No.", RecRef."No.");
                        JournalLine.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                        JournalLine.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                        if JournalLine.Find('-') then
                            Page.Run(Page::"Journal Test Batch", JournalLine, JournalLine."Document No.");
                    end;
                1:
                    begin
                        JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");

                        Case RecRef."Document Type" of
                            RecRef."Document Type"::"Account Closure":
                                begin
                                    AccBanking.Reset();
                                    AccBanking.SetRange("No.", RecRef."Account No.");
                                    if AccBanking.Find('-') then begin
                                        AccBanking.Status := AccBanking.Status::Closed;
                                        AccBanking.Modify(true);
                                    end;
                                end;
                        End;

                        if MemClosure.Get(RecRef."No.") then begin

                            MemClosure.Posted := true;
                            MemClosure."Posted By" := UserId;
                            MemClosure."Time Posted" := Time;
                            MemClosure."Date Posted" := Today;
                            MemClosure."Approval Status" := MemClosure."Approval Status"::Posted;
                            MemClosure.Modify(true);

                            Notif.CreateSmsNotif(NotifSource::"Account Status",
                            CustomRecord."Mobile Phone No", 'Dear ' + CustomRecord."First Name" +
                            ', your membership withdrawal has been processed. Consider rejoining through ' + HyperText, RecRef."No.", CustomRecord."No.", false);
                            Varvariant := RecRef;
                        end;
                    end;
            end;
        end else begin
            Error(ErrorOnNotApprovedApplic);
        end;
    end;



    procedure CreateQcLoanEntry(RecRef: Record Loans; TransType: Enum "LoanTransactionType")
    var
        PFact: Record "Product Factory";
        CredMngt: Codeunit "Credit Mgmt.";
    begin
        RecRef.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
        if PFact.Get(RecRef."Product Type") then begin
            if PFact."Loan Span" = PFact."Loan Span"::"Mobile Loan" then begin
                if RecRef."Outstanding Balance" > 0 then begin
                    CredMngt.CreateQCLoans(RecRef, TransType);
                end
            end
        end
    end;

    procedure PerformPostOnMobLoanMngtAuto(ReceiptNo: Code[20]; PostingDate: Date; ValuePost: Integer)
    var
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        PFact: Record "Product Factory";

        RecReference: Record Loans;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        PostMngt: Codeunit "Journal Post Mngt.";
        TextDescription: Label 'on Loan';
        LRepayment: Decimal;
        OutInt: Decimal;
        OutBill: Decimal;
        OutPrinc: Decimal;
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        AvailBal: Decimal;
        OutBalance: Decimal;
        ExciseDuty: Decimal;
        TotalDeducted: Decimal;
        PostedLoans: Record Loans;
        PostedFacility: Record Loans;
        Member: Record Member;
        SmsNotification: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        DeductionStatus: Enum MobileDeductionStatus;
        TransactionType: Enum MobileTransType;
        RepaymentType: Enum "LoanTransactionType";
        TempEntry: Record "Transaction Types-Mobile";

    begin
        GeneralSetUp.Get();

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        PostMngt.ClearJournalLines(Jtemplate, JBatch);

        OutBill := 0;
        OutInt := 0;
        OutPrinc := 0;
        AvailBal := 0;
        OutBalance := 0;
        ExciseDuty := 0;
        TotalDeducted := 0;

        RunBal := 0;
        RecReference.Reset();
        RecReference.SetRange("No.", ReceiptNo);
        RecReference.SetFilter("Outstanding Balance", '>0');
        if RecReference.FindFirst() then begin
            RecReference.CalcFields("Outstanding Balance",
                         "Outstanding Interest",
                         "Outstanding Principal",
                         "Outstanding Bill");

            if RecReference."Expected Date of Completion" <= Today then begin

                if PFact.Get(RecReference."Product Type") then begin
                    PFact.TestField("Minimum Balance");

                    AccountBanking.Reset();
                    AccountBanking.SetRange(Blocked, AccountBanking.Blocked::" ");
                    AccountBanking.SetRange("No.", RecReference."Disbursement Account No.");
                    if AccountBanking.FindFirst() then begin
                        AccountBanking.CalcFields("Balance (LCY)");
                        RunBal := TellMngt.CalcAvailableBal(AccountBanking."No.");
                        AvailBal := TellMngt.CalcAvailableBal(AccountBanking."No.");

                        if AvailBal < 0 then
                            AvailBal := 0;

                        if AvailBal = 0 then begin
                            DeductionStatus := DeductionStatus::Failed;
                        end else begin
                            if AvailBal >= RecReference."Outstanding Balance" then
                                DeductionStatus := DeductionStatus::"Full Deduction" else
                                DeductionStatus := DeductionStatus::"Partial Deduction";
                        end;

                        if RecReference."Outstanding Interest" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Interest" then
                                    OutInt := RecReference."Outstanding Interest" else
                                    OutInt := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                CopyStr(RecReference."Product Description" + '-' + TextDescription, 1, 100),
                                OutInt, RecReference."Disbursement Account No.",
                                Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Format(RecReference."Account No."), Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference,
                                GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::"Interest Paid");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal.Validate(Amount, OutInt * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Paid";
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::"Interest Paid",
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Bill" > 0 then begin
                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Bill" then
                                    OutBill := RecReference."Outstanding Bill" else
                                    OutBill := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                CopyStr(RecReference."Product Description" + '-' + TextDescription, 1, 100),
                                OutBill, RecReference."Disbursement Account No.",
                                Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Format(RecReference."Account No."), Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference,
                                GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::"Penalty Paid");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal.Validate(Amount, OutBill * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") +
                                '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Penalty Paid";
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::"Penalty Paid",
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Principal" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Principal" then
                                    OutPrinc := RecReference."Outstanding Principal" else
                                    OutPrinc := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                CopyStr(RecReference."Product Description" +
                                '-' + TextDescription, 1, 100),
                                OutPrinc, RecReference."Disbursement Account No.",
                                Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Format(RecReference."Account No."), Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference, GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::Repayment);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal.Validate(Amount, OutPrinc * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") +
                                '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::Repayment;
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::Repayment,
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Balance" > AvailBal then begin
                            RecReference.CalcFields("Outstanding Bill");
                            // Comment- Allow Grace Period of 3 days
                            //PostMobileLoanPenalty(RecReference, 0, PFact."Penalty Percentage", PostingDate);
                        end;

                        if ValuePost = 1 then begin

                            PostMngt.CompletePosting(Jtemplate, JBatch);
                            if Member.Get(RecReference."Account No.") then begin
                                SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", Member."Mobile Phone No",
                          'Dear ' + RecReference."Account Name" + ', Your ' + RecReference."Product Description" +
                          ' balance of KES' + format(RecReference."Outstanding Balance") + ' has been recovered from your Fosa account.', Member."No.",
                             Member."No.", false);
                            end;
                        end else begin
                            VarVariant := RecReference;
                            Commit();
                            Docx.DocPrintstatement(VarVariant, 1);
                        end;
                    end;
                end;
            end;
        end;
    end;


    procedure PostPenaltyOnMobLoan(ReceiptNo: Code[20]; PostingDate: Date; ValuePost: Integer)
    var
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        PFact: Record "Product Factory";
        RecReference: Record Loans;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        PostMngt: Codeunit "Journal Post Mngt.";
        TextDescription: Label 'on Loan';
        LRepayment: Decimal;
        OutInt: Decimal;
        OutBill: Decimal;
        OutPrinc: Decimal;
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        AvailBal: Decimal;
        OutBalance: Decimal;
        ExciseDuty: Decimal;
        TotalDeducted: Decimal;
        PostedLoans: Record Loans;
        PostedFacility: Record Loans;
        Member: Record Member;
        SmsNotification: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        DeductionStatus: Enum MobileDeductionStatus;
        TransactionType: Enum MobileTransType;
        RepaymentType: Enum "LoanTransactionType";
        TempEntry: Record "Transaction Types-Mobile";

    begin
        GeneralSetUp.Get();

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        PostMngt.ClearJournalLines(Jtemplate, JBatch);

        OutBill := 0;
        OutInt := 0;
        OutPrinc := 0;
        AvailBal := 0;
        OutBalance := 0;
        ExciseDuty := 0;
        TotalDeducted := 0;

        RunBal := 0;
        RecReference.Reset();
        RecReference.SetRange("No.", ReceiptNo);
        RecReference.SetFilter("Outstanding Balance", '>0');
        if RecReference.FindFirst() then begin
            RecReference.CalcFields("Outstanding Balance",
                         "Outstanding Interest",
                         "Outstanding Principal",
                         "Outstanding Bill");

            if CalcDate('3D', RecReference."Expected Date of Completion") <= Today then begin

                if PFact.Get(RecReference."Product Type") then begin
                    PFact.TestField("Minimum Balance");

                    AccountBanking.Reset();
                    AccountBanking.SetRange(Blocked, AccountBanking.Blocked::" ");
                    AccountBanking.SetRange("No.", RecReference."Disbursement Account No.");
                    if AccountBanking.FindFirst() then begin
                        AccountBanking.CalcFields("Balance (LCY)");
                        RunBal := TellMngt.CalcAvailableBal(AccountBanking."No.");
                        AvailBal := TellMngt.CalcAvailableBal(AccountBanking."No.");

                        if AvailBal < 0 then
                            AvailBal := 0;

                        if AvailBal = 0 then begin
                            DeductionStatus := DeductionStatus::Failed;
                        end else begin
                            if AvailBal >= RecReference."Outstanding Balance" then
                                DeductionStatus := DeductionStatus::"Full Deduction" else
                                DeductionStatus := DeductionStatus::"Partial Deduction";
                        end;

                        if RecReference."Outstanding Interest" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Interest" then
                                    OutInt := RecReference."Outstanding Interest" else
                                    OutInt := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                CopyStr(RecReference."Product Description" + '-' + TextDescription, 1, 100),
                                OutInt, RecReference."Disbursement Account No.",
                                Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Format(RecReference."Account No."), Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference,
                                GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::"Interest Paid");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal.Validate(Amount, OutInt * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Paid";
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::"Interest Paid",
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Bill" > 0 then begin
                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Bill" then
                                    OutBill := RecReference."Outstanding Bill" else
                                    OutBill := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                CopyStr(RecReference."Product Description" + '-' + TextDescription, 1, 100),
                                OutBill, RecReference."Disbursement Account No.",
                                Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Format(RecReference."Account No."), Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference,
                                GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::"Penalty Paid");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal.Validate(Amount, OutBill * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") +
                                '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Penalty Paid";
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::"Penalty Paid",
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Principal" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Principal" then
                                    OutPrinc := RecReference."Outstanding Principal" else
                                    OutPrinc := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                CopyStr(RecReference."Product Description" +
                                '-' + TextDescription, 1, 100),
                                OutPrinc, RecReference."Disbursement Account No.",
                                Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Format(RecReference."Account No."), Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference, GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::Repayment);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal.Validate(Amount, OutPrinc * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") +
                                '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::Repayment;
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::Repayment,
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Balance" > AvailBal then begin
                            RecReference.CalcFields("Outstanding Bill");
                            PostMobileLoanPenalty(RecReference, 0, PFact."Penalty Percentage", PostingDate);
                        end;

                        if ValuePost = 1 then begin

                            PostMngt.CompletePosting(Jtemplate, JBatch);
                            if Member.Get(RecReference."Account No.") then begin
                                SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", Member."Mobile Phone No",
                          'Dear ' + RecReference."Account Name" + ', Your ' + RecReference."Product Description" +
                          ' balance of KES' + format(RecReference."Outstanding Balance") + ' has been recovered from your Fosa account.', Member."No.",
                             Member."No.", false);
                            end;
                        end else begin
                            VarVariant := RecReference;
                            Commit();
                            Docx.DocPrintstatement(VarVariant, 1);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure PerformPostOnMobLoanDefaultedMngtAuto(ReceiptNo: Code[20]; PostingDate: Date; ValuePost: Integer; CutoffDate: Date)
    var
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        PFact: Record "Product Factory";
        RecReference: Record Loans;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        PostMngt: Codeunit "Journal Post Mngt.";
        TextDescription: Label 'on Loan';
        LRepayment: Decimal;
        OutInt: Decimal;
        OutBill: Decimal;
        OutPrinc: Decimal;
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        AvailBal: Decimal;
        OutBalance: Decimal;
        ExciseDuty: Decimal;
        TotalDeducted: Decimal;
        PostedLoans: Record Loans;
        PostedFacility: Record Loans;
        RecovHeader: Record "Recovery Header";
        DisburseLine: Record "Loan Disbursement Lines";
        Member: Record Member;
        SmsNotification: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        DeductionStatus: Enum MobileDeductionStatus;
        TransactionType: Enum MobileTransType;
        RepaymentType: Enum "LoanTransactionType";
        TempEntry: Record "Transaction Types-Mobile";
    begin

        GeneralSetUp.Get();

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        PostMngt.ClearJournalLines(Jtemplate, JBatch);

        OutBill := 0;
        OutInt := 0;
        OutPrinc := 0;
        AvailBal := 0;
        OutBalance := 0;
        ExciseDuty := 0;
        TotalDeducted := 0;

        RunBal := 0;
        RecReference.Reset();
        RecReference.SetRange("No.", ReceiptNo);
        RecReference.SetFilter("Outstanding Balance", '>0');
        if RecReference.FindFirst() then begin

            RecReference.CalcFields("Outstanding Balance",
                        "Outstanding Interest",
                        "Outstanding Principal",
                        "Outstanding Bill");

            if CalcDate('7D', RecReference."Expected Date of Completion") <= Today then begin

                if PFact.Get(RecReference."Product Type") then begin
                    PFact.TestField("Minimum Balance");

                    AccountBanking.Reset();
                    AccountBanking.SetRange("No.", RecReference."Disbursement Account No.");
                    if AccountBanking.FindFirst() then begin
                        AccountBanking.CalcFields("Balance (LCY)");
                        RunBal := TellMngt.CalcAvailableBal(AccountBanking."No.");
                        AvailBal := TellMngt.CalcAvailableBal(AccountBanking."No.");

                        if AvailBal < 0 then
                            AvailBal := 0;

                        if AvailBal = 0 then begin
                            DeductionStatus := DeductionStatus::Failed;
                        end else begin
                            if AvailBal >= RecReference."Outstanding Balance" then
                                DeductionStatus := DeductionStatus::"Full Deduction" else
                                DeductionStatus := DeductionStatus::"Partial Deduction";
                        end;

                        if RecReference."Outstanding Interest" > 0 then begin

                            if RunBal > 0 then begin
                                if RunBal > RecReference."Outstanding Interest" then
                                    OutInt := RecReference."Outstanding Interest" else
                                    OutInt := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                            Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                            CopyStr(RecReference."Product Description" + '-' + TextDescription, 1, 100),
                                            OutInt, RecReference."Disbursement Account No.",
                                            Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            Format(RecReference."Account No."), Dim1, Dim2,
                                            Enum::"LoanTransactionType"::" ", '',
                                            '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                            Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference,
                                GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::"Interest Paid");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal.Validate(Amount, OutInt * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Paid";
                                GenJournal.Validate("Loan No.", RecReference."No.");

                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::"Interest Paid",
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Bill" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Bill" then
                                    OutBill := RecReference."Outstanding Bill" else
                                    OutBill := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                            Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                            CopyStr(RecReference."Product Description" + '-' + TextDescription, 1, 100),
                                            OutBill, RecReference."Disbursement Account No.",
                                            Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            Format(RecReference."Account No."), Dim1, Dim2,
                                            Enum::"LoanTransactionType"::" ", '',
                                            '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                            Enum::"Gen. Journal Document Type"::" ");

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference,
                                GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::"Penalty Paid");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal.Validate(Amount, OutBill * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") +
                                '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Penalty Paid";
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);
                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::"Penalty Paid",
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);

                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;

                        if RecReference."Outstanding Principal" > 0 then begin

                            if RunBal > 0 then begin

                                if RunBal > RecReference."Outstanding Principal" then
                                    OutPrinc := RecReference."Outstanding Principal" else
                                    OutPrinc := RunBal;

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                PostMngt.PostJournal(Jtemplate, JBatch, Linenum,
                                            Enum::"Gen. Journal Account Type"::Vendor, RecReference."No.",
                                            CopyStr(RecReference."Product Description" +
                                            '-' + TextDescription, 1, 100),
                                            OutPrinc, RecReference."Disbursement Account No.",
                                            Today, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            Format(RecReference."Account No."), Dim1, Dim2,
                                            Enum::"LoanTransactionType"::" ", '',
                                            '', '', Enum::"Gen. Journal Document Type"::" ", '',
                                            Enum::"Gen. Journal Document Type"::" ");

                                Linenum := Linenum + 1000;
                                PostPeriodic.InitializeDebitEntry(RecReference, GenJournal, 0,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                Enum::"LoanTransactionType"::Repayment);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := RecReference."No.";
                                GenJournal."External Document No." := Format(RecReference."Account No.");
                                GenJournal.Validate(Amount, OutPrinc * -1);
                                GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") +
                                '-' + TextDescription, 1, 100);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::Repayment;
                                GenJournal.Validate("Loan No.", RecReference."No.");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);

                                TempEntry.LockTable();
                                TempEntry."Entry No." := RegMgt.InitNextAltTransTypesEntryNo();
                                RegMgt.InitializeTempEntry(RecReference,
                                        TempEntry, AvailBal, RunBal,
                                        TransactionType::"Recovery from Fosa",
                                        RepaymentType::Repayment,
                                        DeductionStatus, Abs(GenJournal.Amount));
                                TempEntry.Insert(true);
                                TotalDeducted := TotalDeducted + Abs(GenJournal.Amount);
                            end;
                        end;
                        if ValuePost = 1 then begin

                            PostMngt.CompletePosting(Jtemplate, JBatch);
                            if RecReference."Outstanding Balance" > AvailBal then begin
                                getRecoveryHeader(RecReference."Account No.", RecReference."No.");
                            end;

                            if Member.Get(RecReference."Account No.") then begin
                                SmsNotification.CreateSmsNotif(NotifSource::"Loan defaulted", Member."Mobile Phone No",
                          'Dear ' + RecReference."Account Name" + ', Your ' + RecReference."Product Description" +
                          ' balance of KES' + format(RecReference."Outstanding Balance") + ' has been recovered from your Fosa account.', Member."No.",
                             Member."No.", false);
                            end;
                        end else begin
                            VarVariant := RecReference;
                            Commit();
                            Docx.DocPrintstatement(VarVariant, 1);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure CreateDefaultedLoanMngtAuto(ReceiptNo: Code[20]; PostingDate: Date; ValuePost: Integer; CutoffDate: Date)
    var
        AccountBanking: Record "Account Banking";
        RunBal: Decimal;
        PFact: Record "Product Factory";
        RecReference: Record "Loans (Procedure)";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        PLoans: Record Loans;
        PostMngt: Codeunit "Journal Post Mngt.";
        TextDescription: Label 'on Loan';
        LRepayment: Decimal;
        OutInt: Decimal;
        OutBill: Decimal;
        OutPrinc: Decimal;
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        AvailBal: Decimal;
        OutBalance: Decimal;
        ExciseDuty: Decimal;
        TotalDeducted: Decimal;
        PostedLoans: Record Loans;
        PostedFacility: Record Loans;
        RecovHeader: Record "Recovery Header";
        DisburseLine: Record "Loan Disbursement Lines";
    begin
        GeneralSetUp.Get();

        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");

        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        PostMngt.ClearJournalLines(Jtemplate, JBatch);
        OutBill := 0;
        OutInt := 0;
        OutPrinc := 0;
        AvailBal := 0;
        OutBalance := 0;
        ExciseDuty := 0;
        TotalDeducted := 0;

        RunBal := 0;
        RecReference.Reset();
        RecReference.SetRange(Posted, false);
        RecReference.SetRange("No.", ReceiptNo);
        RecReference.SetFilter("Outstanding Balance", '>0');
        if PFact.Get(RecReference."Product Type") then begin
            if PFact."Loan Span" = PFact."Loan Span"::"Mobile Loan" then begin

                PostedLoans.Reset();
                PostedLoans.SetRange("No.", RecReference."No.");
                PostedLoans.SetFilter("Outstanding Balance", '>0');
                if PostedLoans.FindFirst() then begin
                    PostedLoans.CalcFields("Outstanding Balance");
                    if CalcDate('-90D', PostedLoans."Disbursement Date") <= Today then begin
                        AccountCredit.Reset();
                        AccountCredit.SetRange("Member No.", PostedLoans."Account No.");
                        AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
                        if AccountCredit.FindFirst() then begin
                            AccountCredit.CalcFields("Balance (LCY)");
                            if AccountCredit."Balance (LCY)" > 0 then begin
                                getRecoveryHeader(PostedLoans."Account No.", PostedLoans."No.");

                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure getRecoveryHeader(AccNo: Code[100]; LoanNo: Code[100])
    var
        RecovHeader: Record "Recovery Header";
        RecoveredHeader: Record "Recovery Header";
        DisbursementLine: Record "Loan Disbursement Lines";
        RunBal: array[12] of Decimal;
    begin

        RunBal[5] := 0;

        RecoveredHeader.Reset();
        RecoveredHeader.SetRange("Account No.", AccNo);
        RecoveredHeader.SetRange("Application Source", RecoveredHeader."Application Source"::Automated);
        RecoveredHeader.SetRange("Approval Status", RecoveredHeader."Approval Status"::Approved);
        if not RecoveredHeader.FindFirst() then begin

            RecovHeader.Init();
            RecovHeader."No." := '';
            RecovHeader."Posting Date" := Today;
            RecovHeader."Application Source" := RecovHeader."Application Source"::Automated;
            RecovHeader."Recovery Type" := RecovHeader."Recovery Type"::"Specific Loan";
            RecovHeader."Post As" := RecovHeader."Post As"::"Post Automatically";
            RecovHeader."Shortcut Dimension 1 Code" := Dim1;
            RecovHeader."Shortcut Dimension 2 Code" := Dim2;
            RecovHeader."Responsibility Centre" := Temp."Responsibility Centre";
            RecovHeader."Approval Status" := RecovHeader."Approval Status"::Approved;
            RecovHeader.Validate("Application Type", RecovHeader."Application Type"::"Recovery from Shares");
            RecovHeader.Validate("Account No.", AccNo);
            RecovHeader."Acrued Interest Options" := RecovHeader."Acrued Interest Options"::"Ignore Acrued Interest";
            RecovHeader.Validate("Loan No.", LoanNo);
            RecovHeader.Insert(true);

            AccountCredit.Reset;
            AccountCredit.SetRange("Member No.", RecovHeader."Account No.");
            AccountCredit.SetRange("Account Category", AccountCredit."Account Category"::"Shares Deposit");
            if AccountCredit.Find('-') then begin
                AccountCredit.CalcFields("Balance (LCY)");
                RunBal[5] := AccountCredit."Balance (LCY)";
                DisbursementLine.LockTable;
                DisbursementLine.Init;
                DisbursementLine."Line No." := RegMgt.InitNextLineEntryNo;
                RegMgt.InitializeRecoveryLine(RecovHeader,
                            DisbursementLine,
                            AccountCredit."Balance (LCY)",
                            AccountCredit."No.");

                if RunBal[5] > RecovHeader."Outstanding Balance" then
                    DisbursementLine.Amount := RecovHeader."Outstanding Balance" else
                    DisbursementLine.Amount := RunBal[5];
                DisbursementLine.Insert(true);
            end;
        end;
    end;

    procedure getLoanArrears(AccountNo: Code[100]; CutOffDate: Date)
    var
        Loans: Record "Loans Categorization";

        ReportMngt: Codeunit "Report Execute Mngt.";
        SendNotification: Boolean;
        MembStatus: Enum MemberStatus;
        EmployerCode: Text[150];
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        PLoan: Record Loans;
        IntDays: Integer;
        EndDate: Date;
        PLoans: Record "Loans Categorization";
        StartDate: Date;
        DateFilter: Text[100];
        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        TotExpBalance: Decimal;
        AmountInArrears: Decimal;
        LoanAge: Decimal;
        TotalExpRepayment: Decimal;
        DaysArrears: Decimal;
        PrincipalPaid: Decimal;
        PrinPaid: Decimal;
        LoanPrinc: Decimal;
        NegTotPaid: Decimal;
        RegMngt: Codeunit "Register Management";
        CredMngt: Codeunit "Credit Mgmt.";
        ToDate: Date;
        TotalAmtPaid: Decimal;
        DaysInArrears: Integer;
        RegisterMngt: Codeunit "Register Management";
        Cust: Record Member;
        CrbData: Record "CRB Data";
        Employer: Record Customer;
        CustMember: Record Member;
        Notif: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        VarVariant: Variant;
        FactProduct: Record "Product Factory";
        AmountApp: Decimal;
        MonthInArrears: Decimal;
        MRepayment: Decimal;
        CustLedger: Record "Cust. Ledger Entry";
        MarkAccountAsDefaulter: Boolean;

    begin

    end;

    procedure fnInitialize()
    var
        TotExpBalance: Decimal;
        AmountInArrears: Decimal;
        LoanAge: Decimal;
        TotalExpRepayment: Decimal;
        DaysArrears: Decimal;
        PrincipalPaid: Decimal;
        PrinPaid: Decimal;
        LoanPrinc: Decimal;
        NegTotPaid: Decimal;
        TotalAmtPaid: Decimal;
        DaysInArrears: Integer;
        AmountApp: Decimal;
        MonthInArrears: Decimal;
        MRepayment: Decimal;

    begin
        TotExpBalance := 0;
        AmountInArrears := 0;
        LoanAge := 0;
        TotalExpRepayment := 0;
        MRepayment := 0;
        AmountApp := 0;
        DaysArrears := 0;
        PrincipalPaid := 0;
        MonthInArrears := 0;
        PrinPaid := 0;
        LoanPrinc := 0;
        NegTotPaid := 0;
        AmountInArrears := 0;
        TotalAmtPaid := 0;
        DaysInArrears := 0;
        MonthInArrears := 0;
    end;

    procedure InitNextEntryNo(): Integer
    var
        RecRef: Record "Loan Progression Lines";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextLineEntryNo(): Integer
    var
        RecRef: Record "Interest Line";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitializeRecoveryHeaderEntry(var DisbursementLine: Record "Loan Disbursement Lines"; DocNo: Code[20]; AmountGuaranteed: Decimal; MemberNo: code[100]; LoanNo: code[100])
    begin
        DisbursementLine.Init;
        DisbursementLine."Shares Deposit" := AmountGuaranteed;
        DisbursementLine."Default Account No." := MemberNo;
        DisbursementLine."Loan No." := LoanNo;
        DisbursementLine."Line No." := RegMgt.InitNextLineEntryNo;
        DisbursementLine.No := DocNo;
    end;

    procedure getPrepaymentAc(AcNo: code[100]): Code[100]
    var
        RepayAcc: Record "Repayment Account";
    begin
        RepayAcc.Reset;
        RepayAcc.SetRange("Member No.", AcNo);
        if RepayAcc.FindFirst() then begin
            exit(RepayAcc."No.")
        end;
    end;

    local procedure CreateRepayAc(AccountNo: Code[100])
    Var
        RegisterManagement: codeunit "Register Management";
        Banking: Record "Repayment Account";
    begin

        if Banking.Get(AccountNo) then begin
            RegisterManagement.fnCreateVendorPostAc(Banking."No.",
                                                        Banking.Name, Banking."Phone No.", Banking."Global Dimension 1 Code",
                                                        Banking."Global Dimension 2 Code", Banking."Customer Posting Group",
                                                        '', Banking.Status, Banking."Product Type",
                                                        '', Banking."Member No.", Banking."Account Category")
        end;
    end;
}




