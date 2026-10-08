report 50222 "Generate Loan Arrears"
{
    ApplicationArea = All;
    Caption = 'Generate Loan Arrears';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = false;
    ShowPrintStatus = false;
    PreviewMode = PrintLayout;
    UseRequestPage = true;
    RDLCLayout = './src/report_layout/GenerateLoanArrears.rdl';
    dataset
    {
        dataitem(LoansCategorization; Loans)
        {
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Employer Code";
            DataItemTableView = where("Disbursement Date" = filter(<> ''));

            column(No; "No.")
            { }
            column(AccountNo; "Account No.")
            { }
            column(Account_Name; "Account Name")
            { }
            column(ProductType; "Product Type")
            { }
            column(Product_Description;"Product Description")
            {}
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
            column(DefaultedDays; DefaultedDays)
            { }
            column(DaysInArrears; DaysInArrears)
            {}
            column(LoanAge; "Loan Age")
            { }
            column(AmountInArrears; "Amount In Arrears")
            { }
            column(ExpectedRepayment; "Expected Repayment")
            { }
            column(Sasra_Category; "Sasra Category")
            { }
            column(EmployerCode; EmployerCode)
            { }

            column(Outstanding_Interest; "Outstanding Interest")
            { }
            column(Outstanding_Principal; "Outstanding Principal")
            { }
            column(Outstanding_Balance; "Outstanding Balance")
            { }
            column(Outstanding_Insurance; "Outstanding Insurance")
            { }
            column(Repayment; Repayment)
            { }
            column(LoanPrinc; LoanPrinc)
            { }
            trigger OnPreDataItem()
            begin
                if Cutoffdate = 0D then Cutoffdate := Today;


            end;

            trigger OnAfterGetRecord()
            begin

                TotExpBalance := 0;
                AmountInArrears := 0;
                Dfilter := '';
                LoanAge := 0;
                TotalExpRepayment := 0;
                MRepayment := 0;
                AmountApp := 0;
                DaysArrears := 0;
                OverDueDay := 0;
                PrincipalPaid := 0;
                MonthInArrears := 0;
                PrinPaid := 0;
                LoanPrinc := 0;
                NegTotPaid := 0;
                AmountInArrears := 0;
                TotalAmtPaid := 0;
                DaysInArrears := 0;
                MonthInArrears := 0;
                DefaultedDays := 0;



                CALCFIELDS("Outstanding Balance", "Average Payment", "Outstanding Principal");

                TotalAmtPaid := "Approved Amount" - "Outstanding Principal";

                TotExpBalance := 0;
                AmountInArrears := 0;
                LoanAge := 0;
                TotalExpRepayment := 0;


                //DateFilter:='..'+ Cutoffdate;


                Lshedule.RESET;
                Lshedule.SETRANGE(Lshedule."No.", "No.");
                Lshedule.SetRange("Repayment Date", 0D, Cutoffdate);
                IF Lshedule.FIND('-') THEN
                    REPEAT

                        TotalExpRepayment := ROUND((TotalExpRepayment + Lshedule."Principal Repayment"), 1, '=');
                        LoanAge := Lshedule."Instalment No";
                    UNTIL Lshedule.NEXT = 0;




                Lshedule.Reset();
                Lshedule.SetRange("No.", "No.");
                if not Lshedule.Find('-') then begin
                    CredMngt.fncreateRepayschedule(false, "No.", 0);
                end;




                

                IF "Average Payment" > 0 then begin

                    if "Repayment Start Date" = 0D then begin
                        "Disbursement Date" := "Application Date";
                        Validate("Disbursement Date");
                        Modify(true)
                    end;
                    TotExpBalance := "Approved Amount" - TotalExpRepayment;

                    AmountInArrears := TotalExpRepayment - TotalAmtPaid;


                    IF "Outstanding Balance" <> 0 THEN begin

                        DaysInArrears := ROUND((AmountInArrears / "Average Payment"), 1, '=');
                        DaysArrears := ROUND((AmountInArrears / "Average Payment") * 30, 1, '=');
                    END;

                    IF DaysArrears < 0 THEN
                        DaysArrears := 0;


                    IF DaysArrears <= 30 THEN
                        IF "Outstanding Balance" > 0 THEN
                            "Sasra Category" := "Sasra Category"::Performing;
                    "Days in Arrears" := DaysInArrears;
                    "Amount in Arrears" := AmountInArrears;
                    MODIFY;

                    IF (DaysArrears >= 31) AND (DaysArrears <= 90) THEN BEGIN
                        IF "Outstanding Balance" > 0 THEN
                            "Sasra Category" := "Sasra Category"::Watch;
                        "Days in Arrears" := DaysInArrears;
                        "Amount in Arrears" := AmountInArrears;
                        MODIFY;

                    END ELSE IF (DaysArrears >= 91) AND (DaysArrears <= 180) THEN BEGIN
                        IF "Outstanding Balance" > 0 THEN
                            "Sasra Category" := "Sasra Category"::Substandard;
                        "Days in Arrears" := DaysInArrears;
                        "Amount in Arrears" := AmountInArrears;
                        MODIFY;

                    END ELSE IF (DaysArrears >= 181) AND (DaysArrears <= 360) THEN BEGIN
                        IF "Outstanding Balance" > 0 THEN
                            "Sasra Category" := "Sasra Category"::Doubtful;
                        "Days in Arrears" := DaysInArrears;
                        "Amount in Arrears" := AmountInArrears;
                        MODIFY;

                    END ELSE IF (DaysArrears >= 361) THEN BEGIN
                        IF "Outstanding Balance" > 0 THEN
                            "Sasra Category" := "Sasra Category"::Loss;
                        "Days in Arrears" := DaysInArrears;
                        "Amount in Arrears" := AmountInArrears;
                        MODIFY;
                    END;


                    IF "Outstanding Balance" < 0 THEN
                        "Sasra Category" := "Sasra Category"::Performing;
                    "Days in Arrears" := DaysInArrears;
                    "Amount in Arrears" := AmountInArrears;
                    MODIFY;

                    if ("Outstanding Balance" > 0) and ("Expected Date of Completion" <= Cutoffdate) then begin
                        "Sasra Category" := "Sasra Category"::loss;
                        "Days in Arrears" := DaysInArrears;
                        "Amount in Arrears" := "Outstanding Balance";
                        MODIFY;
                    end;
                END;

              if "Outstanding Balance" = 0 then
              CurrReport.Skip();

            END;

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
                        ApplicationArea = All;
                    }
                    field(SendNotification; SendNotification)
                    {
                        Caption = 'Send Notification';
                        ApplicationArea = All;
                    }
                    field(MarkAccountAsDefaulter; MarkAccountAsDefaulter)
                    {
                        Caption = 'Mark Account As Defaulter';
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
        Cutoffdate: Date;

        ReportMngt: Codeunit "Report Execute Mngt.";
        SendNotification: Boolean;
        NextDueDate: Date;
        MembStatus: Enum MemberStatus;
        EmployerCode: Text[150];
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        PLoan: Record Loans;
        DueDate: Date;
        DayDue: Integer;
        MonthDue: Integer;
        IntDays: Integer;
        LoanCat: Record LOANS;
        EndDate: Date;
        PLoans: Record LOANS;
        StartDate: Date;
        DateFilter: Text[100];

        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        TotExpBalance: Decimal;
        AmountInArrears: Decimal;
        LoanAge: Integer;
        TotalExpRepayment: Decimal;
        DaysArrears: Decimal;
        PrincipalPaid: Decimal;
        PrinPaid: Decimal;
        LoanPrinc: Decimal;
        NegTotPaid: Decimal;
        RegMngt: Codeunit "Register Management";
        CredMngt: Codeunit "Credit Mgmt.";
        ToDate: Date;
        PostedLoan: Record Loans;
        TotalAmtPaid: Decimal;
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
        MRepayment: Decimal;
        CustLedger: Record "Cust. Ledger Entry";
        MarkAccountAsDefaulter: Boolean;
        OverDueDay: Integer;
        DefaultedDays: Decimal;
        Dfilter: Text[50];
        PostLoan: Record Loans;

    procedure fnInitialize()
    begin
        TotExpBalance := 0;
        AmountInArrears := 0;
        Dfilter := '';
        LoanAge := 0;
        TotalExpRepayment := 0;
        MRepayment := 0;
        AmountApp := 0;
        DaysArrears := 0;
        OverDueDay := 0;
        PrincipalPaid := 0;
        MonthInArrears := 0;
        PrinPaid := 0;
        LoanPrinc := 0;
        NegTotPaid := 0;
        AmountInArrears := 0;
        TotalAmtPaid := 0;
        DaysInArrears := 0;
        MonthInArrears := 0;
        DefaultedDays := 0;
    end;


}



