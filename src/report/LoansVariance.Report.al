namespace DynamicsNav.SaccoDatabase;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;

report 50023 "Loans- Variance"
{
    ApplicationArea = All;
    Caption = 'Loans- Variance';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/LoanVariance.rdl';
    dataset
    {
        dataitem(LoansCategorization; Loans)
        {
            DataItemTableView = where("Outstanding Balance" = filter(> 0));
            RequestFilterFields = "No.", "Account No.", "Product Type", "Disbursement Date", "Employer Code";
            column(No; "No.") { }
            column(AccountNo; "Account No.") { }
            column(AccountName; "Account Name") { }
            column(ProductDescription; "Product Description") { }
            column(RequestedAmount; "Requested Amount") { }
            column(Expected_Date_of_Completion; "Expected Date of Completion") { }
            column(Last_Pay_Date; "Last Pay Date") { }
            column(ApprovedAmount; "Approved Amount") { }
            column(Intreceived; Intreceived) { }
            column(Princreceived; Princreceived) { }
            column(OutstandingBalance; "Outstanding Balance") { }
            column(TotalExpRepayment; TotalExpRepayment) { }
            column(AmountInArrears; AmountInArrears) { }
            column(LoanPrinc; LoanPrinc) { }
            column(Varianceamt; Varianceamt) { }
            column(totalExpextedInt; totalExpextedInt) { }
           // column(Performance_Indicator; "Performance Indicator") { }
            trigger OnPreDataItem()
            begin
                if Cutoffdate = 0D then Cutoffdate := Today;

            end;

            trigger OnAfterGetRecord()
            begin
                fnInitialize();
                totalExpextedInt := 0;
                Intreceived := 0;
                Princreceived := 0;
                Varianceamt := 0;

                CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Bill", "Outstanding Principal");

                if "Outstanding Balance" > 0 then begin
                    //"Current Balance" := "Outstanding Balance";

                    if "Repayment Start Date" = 0D then begin
                        if PostLoan.Get("No.") then begin
                            if PostLoan."Repayment Start Date" = 0D then begin
                                PostLoan.Validate("Disbursement Date");
                                PostLoan.Modify(true)
                            end;
                            Validate("Disbursement Date", PostLoan."Disbursement Date");
                            Modify(true)
                        end;
                    end;

                    Lshedule.Reset();
                    Lshedule.SetRange("No.", "No.");
                    if Lshedule.FindLast() then begin
                        "Expected Date of Completion" := Lshedule."Repayment Date";
                        Modify(true);
                    end;

                    Lshedule.Reset();
                    Lshedule.SetRange("No.", "No.");
                    if not Lshedule.Find('-') then begin
                        CredMngt.fncreateRepayschedule(false, "No.", 0);
                    end;

                    ToDate := "Repayment Start Date";
                    postdate := 20240116D;

                    TotalAmtPaid := ("Approved Amount" - "Outstanding Principal");
                    //DateFilter := Format(ToDate) + '..' + Format(Cutoffdate);
                    //Dfilter := Format(ToDate) + '..' + Format(Cutoffdate);
                    DateFilter := Format(ToDate) + '..' + Format(CalcDate('CM', Cutoffdate));
                    Dfilter := Format(ToDate) + '..' + Format(CalcDate('CM', Cutoffdate));
                    intfilter := Format(postdate) + '..' + Format(CalcDate('CM', Cutoffdate));

                    Lshedule.Reset();
                    Lshedule.SetRange("No.", "No.");
                    Lshedule.SetFilter("Repayment Date", DateFilter);
                    if Lshedule.FindLast() then begin
                        LoanPrinc := Lshedule."Loan Balance";
                    end;

                    if "Expected Date of Completion" <= Cutoffdate then
                        LoanPrinc := 0;

                    if "Repayment Start Date" <> 0D then begin
                        DueDate := "Repayment Start Date";
                        DayDue := Date2DMY("Repayment Start Date", 1);
                        MonthDue := Date2DMY(Cutoffdate, 2);

                        case MonthDue OF
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
                    end;
                    NextDueDate := CalcDate('1M', DMY2Date(DayDue, MonthDue, Date2DMY(Cutoffdate, 3)));
                    //"Next Installment Date" := NextDueDate;
                    if "Repayment Start Date" <= Cutoffdate then begin

                        Lshedule.Reset();
                        Lshedule.SetRange("No.", "No.");
                        Lshedule.SetFilter("Repayment Date", intfilter);
                        if Lshedule.FindSet() then begin
                            Lshedule.CalcSums("Monthly Interest");
                            totalExpextedInt := Lshedule."Monthly Interest";
                        end;

                        Rshedule.Reset();
                        Rshedule.SetRange("No.", "No.");
                        Rshedule.SetFilter("Repayment Date", DateFilter);
                        if Rshedule.FindSet() then begin

                            LoanAge := Rshedule.Count;
                            MRepayment := Rshedule."Monthly Repayment";
                            Rshedule.CalcSums("Monthly Repayment");
                            //Rshedule.CalcSums("Monthly Interest");
                            TotalExpRepayment := Round(Rshedule."Monthly Repayment", 1, '=');
                            //totalExpextedInt := Round(Rshedule."Monthly Interest", 1, '=');
                            if MRepayment >= "Outstanding Balance" then
                                MRepayment := "Outstanding Balance" else
                                MRepayment := MRepayment;

                            if TotalExpRepayment >= "Outstanding Balance" then
                                TotalExpRepayment := "Outstanding Balance" else
                                "Expected Repayment" := TotalExpRepayment;

                            if AmountInArrears < 0 then
                                AmountInArrears := 0;

                            if "Expected Date of Completion" <= Cutoffdate then begin
                                AmountInArrears := "Outstanding Principal";
                                totalExpextedInt := "Outstanding Interest";
                                TotalExpRepayment := "Outstanding Principal";
                                MonthInArrears := Round((AmountInArrears / MRepayment), 0.05, '>');
                                DaysInArrears := Round((MonthInArrears * 30.41), 1, '>');
                                Princreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::Repayment);
                                Intreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::"Interest Paid")

                            end else begin

                                if AmountInArrears >= MRepayment then begin
                                    MonthInArrears := Round((AmountInArrears / MRepayment), 0.05, '>');
                                    DaysInArrears := Round((MonthInArrears * 30.41), 1, '>');
                                end else begin

                                    MonthInArrears := Round((AmountInArrears / MRepayment), 0.05, '>');
                                    DaysInArrears := Round((MonthInArrears * 30.41), 1, '>');
                                end;

                                Princreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::Repayment);
                                Intreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::"Interest Paid");
                                Varianceamt := (totalExpextedInt - Intreceived);
                                //if Varianceamt < 0 then Varianceamt := 0;
                            end;
                        end;
                    end else begin

                        AmountInArrears := 0;
                        DaysInArrears := 0;
                        "Days in Arrears" := DaysInArrears;
                        "Amount In Arrears" := AmountInArrears;
                        "Expected Repayment" := Repayment;
                       // "Current Balance" := "Outstanding Balance";
                        Princreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::Repayment);
                        Intreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::"Interest Paid");
                        Varianceamt := (totalExpextedInt - Intreceived);
                    end;

                    "Loan Age" := LoanAge;
                    //"Amount Paid" := LoanPrinc;
                    "Amount In Arrears" := AmountInArrears;
                    "Days in Arrears" := DaysInArrears;
                    "Expected Repayment" := TotalExpRepayment;
                    Princreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::Repayment);
                    Intreceived := amountreceivedOnLoan("No.", "Loan Account", Enum::"LoanTransactionType"::"Interest Paid");
                    Varianceamt := (totalExpextedInt - Intreceived);
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
                group(Options)
                {
                    field(Cutoffdate; Cutoffdate)
                    {
                        Caption = 'Cutoff Date';
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
        LoanCat: Record "Loans Categorization";
        EndDate: Date;
        PLoans: Record "Loans Categorization";
        postdate: Date;
        StartDate: Date;
        DateFilter: Text[100];
        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        totalExpextedInt: Decimal;
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
        Princreceived: Decimal;
        Intreceived: Decimal;
        DefaultedDays: Decimal;
        Dfilter: Text[50];
        PostLoan: Record Loans;
        AccountCredit: Record "Account Credit";
        SharesDeposit: Decimal;
        Varianceamt: Decimal;
        intfilter: Text[100];

    procedure fnInitialize()
    begin
        TotExpBalance := 0;
        AmountInArrears := 0;
        Princreceived := 0;
        Intreceived := 0;
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

    local procedure amountreceivedOnLoan(accountno: Code[50]; Loanaccount: Code[100]; transtype: Enum "LoanTransactionType"): Decimal
    var
        custledger: Record "Cust. Ledger Entry";
        detldcustledger: Record "Detailed Cust. Ledg. Entry";
    begin

        detldcustledger.SetRange("Loan No.", accountno);
        detldcustledger.SetRange("Customer No.", Loanaccount);
        detldcustledger.SetRange("Transaction Type", transtype);
        if detldcustledger.FindSet() then begin
            detldcustledger.CalcSums("Amount (LCY)");
            exit(Abs(detldcustledger."Amount (LCY)"))
        end else
            exit(0)
    end;
}
