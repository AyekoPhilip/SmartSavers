codeunit 50076 LoanAccrualMgt
{
    trigger OnRun()
    begin
        //RunAccrual(Today);
    end;

    procedure RunAccrual(Loans: Record Loans; AsAtDate: Date)
    var
        AccrualEntries: Record "Loan Accrual Entries";
    begin
        AccrualEntries.Init();
        AccrualEntries."Entry No" := 0;
        AccrualEntries."Loan No" := Loans."No.";
        AccrualEntries."Posting Date" := AsAtDate;
        AccrualEntries.Amount := CalculateAccrualAmount(Loans."No.", AsAtDate);
        if AccrualEntries.Amount <> 0 then
            AccrualEntries.Insert(true);
    end;

    procedure CalculateAccrualAmount(LoanNo: Code[20]; AsAtDate: Date) Amount: Decimal
    var
        AccrualEntries: Record "Loan Accrual Entries";
        DateFilter: Text;
        Loans: Record Loans;
    begin
        DateFilter := '..' + Format(AsAtDate);
        AccrualEntries.Reset();
        AccrualEntries.SetRange("Loan No", LoanNo);
        AccrualEntries.SetRange("Posting Date", AsAtDate);
        if not AccrualEntries.IsEmpty then
            exit(0);
        Amount := 0;
        Loans.Reset();
        Loans.SetFilter("Date Filter", DateFilter);
        Loans.SetRange("No.", LoanNo);
        if Loans.FindSet() then begin
            Loans.CalcFields("Outstanding Principal");
            Amount := Loans."Outstanding Principal" * Loans."Interest Rate" * 0.01;
            Amount := Amount / 365;
        end;
        exit(Amount);
    end;

    procedure CalculateAccruedInterestAtDate(LoanNo: Code[20]; AsAtDate: Date) AccruedInterest: Decimal
    var
        DetCustLedger: Record "Detailed Cust. Ledg. Entry";
        LastInterestChargedDate: Date;
        DateFilter: Text;
        Accruals: Record "Loan Accrual Entries";
    begin
        AccruedInterest := 0;
        DetCustLedger.Reset();
        DetCustLedger.SetRange("Loan No.", LoanNo);
        DetCustLedger.SetRange("Transaction Type", DetCustLedger."Transaction Type"::"Interest Due");
        DetCustLedger.SetFilter("Posting Date", '>%1', AsAtDate);
        if DetCustLedger.FindSet() then
            exit(0); //No Accrued Interest
        DetCustLedger.Reset();
        DetCustLedger.SetRange("Loan No.", LoanNo);
        DetCustLedger.SetRange("Transaction Type", DetCustLedger."Transaction Type"::"Interest Due");
        DetCustLedger.SetFilter("Posting Date", '<%1', AsAtDate);
        if DetCustLedger.FindLast() then
            LastInterestChargedDate := DetCustLedger."Posting Date"; //Last Interest Charged Date
        if LastInterestChargedDate <> 0D then
            DateFilter := Format(LastInterestChargedDate) + '..' + Format(AsAtDate)
        else
            DateFilter := Format(0D) + '..' + Format(AsAtDate);
        Accruals.Reset();
        Accruals.setRange("Loan No", LoanNo);
        Accruals.SetFilter("Posting Date", DateFilter);
        if Accruals.FindSet() then begin
            Accruals.CalcSums(Amount);
            AccruedInterest := Accruals.Amount;
        end;
        exit(AccruedInterest);
    end;
}