report 50009 "Gen. Loan Arrears"
{
    ApplicationArea = All;
    Caption = 'Generate Loan Arrears';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    PreviewMode = PrintLayout;
    UseRequestPage = true;
    //RDLCLayout = './src/report_layout/GenerateLoanArrears.rdl';
    RDLCLayout = './src/report_layout/LoanPerformanceArrears.rdl';
    dataset
    {
        dataitem(appcategory; "Loans Categorization")
        {
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Employer Code", "Date Filter";

            column(No; "No.")
            { }
            column(AccountNo; "Account No.")
            { }
            column(OverDue_Date; "OverDue Date")
            { }
            column(Loan_Rescheduled; "Loan Rescheduled")
            { }
            column(Date_Rescheduled; "Date Rescheduled")
            { }
            column(Next_Installment_Date; "Next Installment Date")
            { }
            column(Account_Name; "Account Name")
            { }
            column(ProductType; "Product Type")
            { }
            column(DisbursementDate; "Disbursement Date")
            { }
            column(RepaymentStartDate; "Repayment Start Date")
            { }
            column(ApprovedAmount; "Approved Amount")
            { }
            column(Installments; Installments)
            { }
            column(InterestRate; "Interest Rate")
            { }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            { }
            column(DaysArrears; "Days in Arrears")
            { }
            column(DefaultedDays; DefaultedDays)
            { }
            column(LoanAge; "Loan Age")
            { }
            column(AmountInArrears; "Amount In Arrears")
            { }
            column(ExpectedRepayment; "Expected Repayment")
            { }
            column(Performance_Indicator; "Performance Indicator")
            { }
            column(EmployerCode; EmployerCode)
            { }
            column(AmountPaid; "Amount Paid")
            { }
            column(Outstanding_Interest; "Outstanding Interest")
            { }
            column(Outstanding_Principal; "Outstanding Principal")
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            column(Repayment; Repayment)
            { }
            column(LoanPrinc; LoanPrinc)
            { }
            column(LBalance; LoanPrinc)
            { }

            trigger OnPreDataItem()
            begin
                if Cutoffdate = 0D then Cutoffdate := Today;
            end;

            trigger OnAfterGetRecord()
            begin

                Initialize();
                DefaultedDays := 0;
                CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill", "Outstanding Principal");
                if "Performance Indicator" = "Performance Indicator"::"Closed Account" then
                    CurrReport.Skip();

                GensetUp.Get();
                GensetUp.TestField("Checkoff Cutoff Days");
                StartMonthDate := CalcDate('-CM', "Disbursement Date");
                EndMonthDate := CalcDate('CM', "Disbursement Date");
                MidCheckDate := CalcDate(GensetUp."Checkoff Cutoff Days", StartMonthDate);

                accountype.Reset();
                accountype.Get("Product Type");

                EmployerCode := '';
                if Employer.Get("Employer Code") then
                    EmployerCode := Employer.Name;
                if "Repayment Start Date" > Cutoffdate then begin
                    CurrReport.Skip();
                end else begin

                    if "Outstanding Balance" > 0 then begin

                        if "Repayment Start Date" <= Cutoffdate then begin
                            FromDate := "Repayment Start Date";
                            LastDate := CalcDate('CM', Cutoffdate);
                            if Cutoffdate = LastDate then
                                ToDate := CalcDate('1M', LastDate) else
                                ToDate := CalcDate('1M', Cutoffdate);

                            Dfilter := Format(FromDate) + '..' + Format(ToDate);
                            DateFilter := Format(FromDate) + '..' + Format(ToDate);
                            DueDate := "Repayment Start Date";
                            DayDue := Date2DMY("Repayment Start Date", 1);
                            MonthDue := Date2DMY(ToDate, 2);

                            case MonthDue of
                                4,
                                6,
                                9,
                                11:
                                    begin
                                        if DayDue > 30 then
                                            DayDue := 30 else
                                            DayDue := DayDue;
                                    end;
                                2:
                                    begin
                                        if (DayDue > 28) or (DayDue > 29) then
                                            DayDue := 28 else
                                            DayDue := DayDue;
                                    end;
                            end;
                            NextDueDate := CalcDate('1M', DMY2Date(DayDue, MonthDue, Date2DMY(ToDate, 3)));

                            if "Expected Date of Completion" <= Cutoffdate then begin
                                LoanPrinc := "Outstanding Balance";
                                LBalance := "Outstanding Balance";
                            end else begin

                                shedulemgt.Reset();
                                shedulemgt.SetRange("No.", "No.");
                                shedulemgt.SetFilter("Repayment Date", DateFilter);
                                if shedulemgt.FindLast() then begin
                                    LoanPrinc := shedulemgt."Loan Balance";
                                    LBalance := shedulemgt."Loan Balance";

                                end;
                            end;

                            Rshedule.Reset();
                            Rshedule.SetRange("No.", "No.");
                            Rshedule.SetFilter("Repayment Date", DateFilter);
                            Rshedule.SetFilter("Monthly Repayment", '>0');
                            if Rshedule.FindSet() then begin

                                LoanAge := Rshedule.Count;
                                Repaymgt := Rshedule."Monthly Repayment";
                                Rshedule.CalcSums("Monthly Repayment");
                                ExpRepaymgt := Rshedule."Monthly Repayment";

                                if Repaymgt >= "Outstanding Balance" then
                                    Repaymgt := "Outstanding Balance";

                                if ExpRepaymgt >= "Outstanding Balance" then
                                    ExpRepaymgt := "Outstanding Balance";

                                if "Expected Date of Completion" <= Cutoffdate then begin
                                    AmountInArrears := "Outstanding Balance";
                                    DaysInArrears := (Cutoffdate - "Expected Date of Completion");

                                end else begin

                                    AmountInArrears := ("Outstanding Balance" - LoanPrinc);
                                    if AmountInArrears < 0 then
                                        AmountInArrears := 0;
                                    if AmountInArrears > 0 then begin

                                        if AmountInArrears >= Repaymgt then begin
                                            MonthInArrears := Round((AmountInArrears / Repaymgt), 0.05, '<');
                                            DaysInArrears := Round((MonthInArrears * 30.41), 1, '<');
                                        end else begin
                                            MonthInArrears := Round((AmountInArrears / Repaymgt), 0.05, '<');
                                            DaysInArrears := Round((MonthInArrears * 30.41), 1, '<');
                                        end;
                                    end else begin
                                        MonthInArrears := 0;
                                        DaysInArrears := 0;
                                    end;
                                end;

                                if AmountInArrears < Repayment then begin

                                    AmountInArrears := 0;
                                    DaysInArrears := 0;

                                end;

                                if DaysInArrears < 0 then
                                    DaysInArrears := 0;

                                if DaysInArrears > 30 then begin
                                    if "Disbursement Date" >= MidCheckDate then
                                        DefaultedDays := (DaysInArrears - 60) else
                                        DefaultedDays := (DaysInArrears - 30)
                                end else begin
                                    DefaultedDays := DaysInArrears;
                                end;
                                if DefaultedDays < 0 then
                                    DefaultedDays := 0;

                                OverDueDay := DefaultedDays;
                                case accountype."Loan Span" of
                                    accountype."Loan Span"::Dividends,
                                        accountype."Loan Span"::"Mobile Loan":
                                        begin

                                            DaysInArrears := 0;
                                            AmountInArrears := 0;
                                            "Performance Indicator" := "Performance Indicator"::Performing;
                                            "Next Installment Date" := GetnextInstallDate("No.", DateFilter);

                                        end else begin
                                        "Next Installment Date" := NextDueDate;
                                        if AmountInArrears = 0 then begin
                                            "Performance Indicator" := "Performance Indicator"::Performing;

                                        end else begin

                                            case DefaultedDays of
                                                1 .. 30.99:
                                                    "Performance Indicator" := "Performance Indicator"::Watch;
                                                31 .. 180.99:
                                                    "Performance Indicator" := "Performance Indicator"::Substandard;
                                                181 .. 360.99:
                                                    "Performance Indicator" := "Performance Indicator"::Doubtfull;
                                                361 .. 999999999:
                                                    "Performance Indicator" := "Performance Indicator"::Loss
                                            end;
                                        end;
                                    end;
                                end;

                                if "Expected Date of Completion" <= Cutoffdate then
                                    "OverDue Date" := "Expected Date of Completion" else
                                    "OverDue Date" := CalcDate('-' + Format(OverDueDay) + 'D', ToDate);

                                "Loan Age" := LoanAge;
                                "Expected Repayment" := ExpRepaymgt;
                                "Amount In Arrears" := AmountInArrears;
                                "Days in Arrears" := DefaultedDays;
                                Modify(true)
                            end else begin
                                ///Error('Rshedule not found, check if the loan is in arrears %1', "No.");
                            end;
                        end else begin

                            AmountInArrears := 0;
                            DaysInArrears := 0;
                            "Days in Arrears" := 0;
                            "Amount In Arrears" := 0;
                            "Expected Repayment" := Repayment;
                            "Account Status" := "Account Status"::Active;
                            "Performance Indicator" := "Performance Indicator"::Performing;
                            Modify(true)
                        end;
                    end else begin

                        if "Outstanding Balance" < 0 then begin
                            AmountInArrears := 0;
                            DaysInArrears := 0;
                            "Days in Arrears" := 0;
                            "Amount In Arrears" := 0;
                            "Expected Repayment" := 0;
                            "Next Installment Date" := 0D;
                            "Performance Indicator" := "Performance Indicator"::Performing;
                            Modify(true)

                        end else begin

                            AmountInArrears := 0;
                            DaysInArrears := 0;
                            "Days in Arrears" := 0;
                            "Amount In Arrears" := 0;
                            "Expected Repayment" := 0;
                            "Next Installment Date" := 0D;
                            Modify(true)
                        end;
                    end;

                end
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
                    field(Cutoffdate; Cutoffdate)
                    {
                        Caption = 'Cutoff Date';
                    }
                    field(SendNotification; SendNotification)
                    {
                        Caption = 'Send Notification';
                    }
                    field(MarkAccountAsDefaulter; MarkAccountAsDefaulter)
                    {
                        Caption = 'Mark Account As Defaulter';
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
        Cutoffdate: Date;

        ReportMngt: Codeunit "Report Execute Mngt.";
        SendNotification: Boolean;
        NextDueDate: Date;
        MembStatus: Enum MemberStatus;
        EmployerCode: Text[150];
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        PLoan: Record Loans;
        DueDate: Date;
        GensetUp: Record "General Set-Up";
        StartMonthDate: Date;
        EndMonthDate: Date;
        MidCheckDate: Date;
        CheckOffdate: Date;
        DayDue: Integer;
        MonthDue: Integer;
        IntDays: Integer;
        LBalance: Decimal;
        accountype: Record "Product Factory";
        LoanCat: Record "Loans Categorization";
        EndDate: Date;
        PLoans: Record "Loans Categorization";
        StartDate: Date;
        DateFilter: Text[100];
        shedulemgt: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        TotExpBalance: Decimal;
        FromDate: Date;
        LastDate: Date;
        AmountInArrears: Decimal;
        LoanAge: Integer;
        ExpRepaymgt: Decimal;
        PrincipalPaid: Decimal;
        PrinPaid: Decimal;
        LoanPrinc: Decimal;
        Loan: Record Loans;
        NegTotPaid: Decimal;
        RegMngt: Codeunit "Register Management";
        CredMngt: Codeunit "Credit Mgmt.";
        ToDate: Date;
        DaysInArrears: Decimal;
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
        Repaymgt: Decimal;
        CustLedger: Record "Cust. Ledger Entry";
        MarkAccountAsDefaulter: Boolean;
        OverDueDay: Integer;
        DefaultedDays: Decimal;
        Dfilter: Text[50];

    local procedure GetnextInstallDate(LoanNo: Code[50]; NextDateFilter: Text): Date
    var
        Lshedule: Record "Repayment Schedule";

    begin

        Lshedule.Reset();
        Lshedule.SetRange("No.", LoanNo);
        Lshedule.SetFilter("Repayment Date", NextDateFilter);
        if Lshedule.FindLast() then begin
            exit(CalcDate('1M', Lshedule."Repayment Date"));
        end;
    end;

    procedure Initialize()
    begin
        TotExpBalance := 0;
        AmountInArrears := 0;
        Dfilter := '';
        LoanAge := 0;
        LastDate := 0D;
        FromDate := 0D;
        ExpRepaymgt := 0;
        Repaymgt := 0;
        AmountApp := 0;
        LBalance := 0;
        OverDueDay := 0;
        PrincipalPaid := 0;
        MonthInArrears := 0;
        PrinPaid := 0;
        LoanPrinc := 0;
        NegTotPaid := 0;
        AmountInArrears := 0;
        DaysInArrears := 0;
        MonthInArrears := 0;
        DefaultedDays := 0;
    end;
}
