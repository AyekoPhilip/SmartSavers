codeunit 50070 "Credit Loan Appraisal"
{
    TableNo = "Loan Application";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        AppraisalParameter: Record "Loan Appraisal Parameter";
        RegMngt: Codeunit "Register Management";
        RegistryMngt: Codeunit "Registry Mngt.";
        LoanApplication: Record "Loan Application";
        PeriodicAct: Codeunit "Periodic Activities Mgt.";
        LoanIntLine: Record "Interest Line";
        IntLine: Record "Interest Line";
        ExciseDuty: Decimal;
        NetUlizableAmt: Decimal;
        Amts: array[3] of Decimal;
        DocMngt: Codeunit "Doc. Mngt";
        AccountB: Record "Account Banking";
        SalAttribAmt: array[14] of Decimal;
        NoOfLoanGuaranteed: Integer;
        GuarantorsPosted: Record "Guarantor & Security Posted";
        PostedFacility: Record Loans;
        TotOutBalance: Decimal;
        TieredChargeLine: Record "Tiered Charges Line";
        TransType: Record "Transaction Charge";
        NotifSource: Enum NotifSourceType;
        CustRec: Record Member;
        Notif: Codeunit "SMS Notification";
        LoanAppcharges: Record "Loan Application Charge";
        MemberDeposits: Decimal;
        Loan: Record Loans;
        BoostAmt: Decimal;
        ProductFactory: Record "Product Factory";


        AccruedInt: Decimal;
        AppraisalSal: Record "Appraisal Salary Details";
        ApprDetails: Record "Appraisal Salary Details";

        QualifyingDivAmt: Decimal;
        Varvariant: Variant;
        AccountCred: Record "Account Credit";
        LoansTopUp: Record "Loans Top up";
        LoanApplic: Record "Loan Application";
        Loans: Record Loans;
        PropType: Record "Property Type";
        CollateralReg: Record "Collateral Register";
        LoanType: Record "Product Factory";
        DepMultiplier: Decimal;
        MultDep: Record "Deposit Multiplier";
        MultDeposit: Record "Deposit Multiplier";
        MaxMultDeposit: Record "Deposit Multiplier";
        FactP: Record "Product Factory";
        CurrDepMultiplier: Decimal;
        LoanAggreement: Record "Loan Guarantors and Security";
        RelatedLoan: Decimal;
        LoansType: Record "Product Factory";
        RelatedLoanT: Decimal;
        TopUpRepayment: Decimal;
        TopupLoan: Record "Loans Top up";
        TopupAmt: Decimal;
        DivMngt: Codeunit "Dividend Process";
        DivProgression: Record "Dividend Progression";
        CsMember: Record Member;
        ExistDivLoan: Decimal;
        AccBanking: Record "Account Banking";
        StartDate: Date;
        Enddate: Date;
        FirstDateMonth: Date;
        LastDateMonth: Date;
        DateFilter: Text;
        BankAccLedgerEntry: Record "Vendor Ledger Entry";
        JuniorBal: Decimal;
        PropertyType: Record "Property Type";
        GuarantPosted: Record "Loan Guarantors and Security";
        CollReg: Record "Collateral Register";
        TotalRef: Decimal;
        QualifyTemp: Record "QC Qualifying Amount";
        RefinancedLoan: Boolean;
        ConsolidateLoans: array[2] of Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        FirstDayOfMonth: Date;
        LastDayOfMonth: Date;
        DFilter: Text[100];
        AmtBoost: Decimal;
        DiffBoostAmt: Decimal;
        TotalLoanOrder: Decimal;
        NetDeduction: Decimal;
        TotDeposits: Decimal;
        AdminstrativeCharges: Decimal;
        CountNo: Integer;
        GuarantorMax: Boolean;
        LoanRecoverd: Boolean;
        GeneralSetUp: Record "General Set-Up";
        MemberDueRetire: Boolean;
        SecurityTotal: Decimal;
        SecurityRisk: Boolean;
        LoanDepositRation: Boolean;
        DepositMultiplier: Decimal;
        RelatedBal: Decimal;
        NetOnDeposits: Decimal;
        TBasic: Decimal;
        TAllowance: Decimal;
        TDeductions: Decimal;
        MonthlyContrib: Record "Member Monthly Contribution";
        TopupRepayments: Decimal;
        AdjustedNet: Decimal;
        NetSalary: Decimal;
        TotalExteralRec: Decimal;
        NetOnSalary: Decimal;
        QualifyingAmount: Decimal;

        AvInterest: Decimal;
        NewRepayment: Decimal;
        CurrLoanBal: Decimal;
        Mult: Decimal;
        NetTakeHome: Decimal;
        SalProcessed: Boolean;
        OffsetBalance: Decimal;
        Twothird: Boolean;
        DiscAmt: Decimal;
        DifferenceSec: Decimal;
        TExternalEffects: Decimal;
        GuarLoanBal: Decimal;
        CountAll: Integer;
        RepBasedOnRequested: Decimal;
        IntBasedOnRequested: Decimal;
        SelfGuaranteedBal: Decimal;
        AthirdDisplay: Text[50];
        AthirdAmt: Decimal;
        MaxAvailable: Decimal;
        AmtOnDeductedBasic: Decimal;
        TotAmtGuarant: Decimal;
        BelaUpfrontInt: Decimal;
        LnCharges: Decimal;
        ChargeAmt: Decimal;
        LoanNetAmount: Decimal;
        TotalTopup: Decimal;
        BufferAmount: array[12] of Decimal;

    procedure RunWithCheck(var RecRef: Record "Loan Application")
    begin
        Initialize(RecRef);
        RecRef.CalcFields("Total TopUp", "Amount Guaranteed");
        FirstDateMonth := CalcDate('-45D', Today);
        LastDateMonth := CalcDate('-CM', FirstDateMonth);
        FirstDayOfMonth := CalcDate('-3M', Today);
        LastDayOfMonth := CalcDate('CM', Today);
        RecRef.CalcFields("Total TopUp", "Amount Guaranteed");

        ProductFactory.Get(RecRef."Product Type");
        DepMultiplier := ProductFactory."Ordinary Deposits Multiplier";


        /* Get Shares Contributions */
        MonthlyContrib.Reset();
        MonthlyContrib.SetRange("Account No.", RecRef."Account No.");
        MonthlyContrib.SetFilter(Type, '%1|%2', MonthlyContrib.Type::"Shares Deposit",
        MonthlyContrib.Type::"Specialty Savings");
        if MonthlyContrib.Find('-') then begin
            MonthlyContrib.CalcSums(Amount);
            BufferAmount[1] := MonthlyContrib.Amount;
        end;

        /* Get Topup Repayment */
        if RecRef."Total TopUp" > 0 then begin
            TopupLoan.Reset();
            TopupLoan.SetRange("No.", RecRef."No.");
            if TopupLoan.FindSet() then begin
                TopupLoan.CalcSums("Monthly Repayment");
                TopUpRepayment := TopupLoan."Monthly Repayment";
            end;
        end else begin
            TopUpRepayment := 0
        end;

        /* Get all Loan balances & Repayment */

        Loan.Reset();
        Loan.SetRange("Account No.", RecRef."Account No.");
        Loan.SetFilter("Outstanding Balance", '>0');
        if Loan.FindSet() then begin
            Loan.CalcSums(Repayment);
            TotalLoanOrder := Loan.Repayment;
            repeat
                Loan.CalcFields("Outstanding Balance");
                ConsolidateLoans[1] := (ConsolidateLoans[1] + Loan."Outstanding Balance");
            until Loan.Next() = 0;
            ConsolidateLoans[1] := (ConsolidateLoans[1] - RecRef."Total TopUp");
        end;
        AppraisalParameter."Consolidated Loans(Sacco)" := ConsolidateLoans[1];













    end;

    local procedure Initialize(ApplicationRec: Record "Loan Application")
    var

    begin
        CountNo := 0;
        AdminstrativeCharges := 0;
        TotAmtGuarant := 0;
        DifferenceSec := 0;
        SecurityTotal := 0;
        LnCharges := 0;
        SecurityRisk := false;
        MemberDueRetire := false;
        GuarantorMax := false;
        LoanRecoverd := false;
        LoanDepositRation := false;
        Twothird := false;
        DepositMultiplier := 0;
        RelatedBal := 0;
        NetOnDeposits := 0;
        TopupRepayments := 0;
        AdjustedNet := 0;
        NetSalary := 0;
        TotalExteralRec := 0;
        LoanNetAmount := 0;
        NetOnSalary := 0;
        QualifyingAmount := 0;
        TDeductions := 0;
        TAllowance := 0;
        TBasic := 0;
        CountAll := 0;
        DiscAmt := 0;
        AvInterest := 0;
        NewRepayment := 0;
        CurrLoanBal := 0;
        Mult := 0;
        NetTakeHome := 0;
        TExternalEffects := 0;
        GuarLoanBal := 0;
        GuarantorMax := false;
        RepBasedOnRequested := 0;
        IntBasedOnRequested := 0;
        SelfGuaranteedBal := 0;
        AthirdDisplay := '';
        AthirdAmt := 0;
        MaxAvailable := 0;
        AmtOnDeductedBasic := 0;
        BelaUpfrontInt := 0;
        TotDeposits := 0;
        ChargeAmt := 0;
        SalProcessed := false;
        OffsetBalance := 0;
        ExciseDuty := 0;

        SalAttribAmt[1] := 0;
        SalAttribAmt[2] := 0;
        SalAttribAmt[3] := 0;
        SalAttribAmt[4] := 0;
        TotalLoanOrder := 0;
        SalAttribAmt[5] := 0;
        SalAttribAmt[6] := 0;
        JuniorBal := 0;
        RelatedLoan := 0;
        TopupAmt := 0;
        ExistDivLoan := 0;
        TDeductions := 0;
        NetDeduction := 0;
        AmtBoost := 0;
        SalAttribAmt[7] := 0;
        SalAttribAmt[8] := 0;
        SalAttribAmt[9] := 0;
        SalAttribAmt[10] := 0;
        SalAttribAmt[11] := 0;
        SalAttribAmt[12] := 0;
        SalAttribAmt[13] := 0;
        ConsolidateLoans[1] := 0;
        ConsolidateLoans[2] := 0;
        DepMultiplier := 0;
        CurrDepMultiplier := 0;
        TopUpRepayment := 0;
        DFilter := '';
        QualifyingDivAmt := 0;
        FirstDayOfMonth := 0D;
        LastDayOfMonth := 0D;

        GeneralSetUp.Get;
        GeneralSetUp.TestField("Excise Duty (%)");
        GeneralSetUp.TestField("Max. Member Age");
        AppraisalParameter.SetRange("No.", ApplicationRec."No.");
        AppraisalParameter.DeleteAll;
        RegistryMngt.InitializeAppraisalDetails(ApplicationRec, AppraisalParameter);
    end;


}
