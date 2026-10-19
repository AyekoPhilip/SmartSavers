codeunit 50069 "Generate RapaymentSchedule"
{

    trigger OnRun()
    begin
    end;

    var

    procedure RepaymentSchedule(Post: Boolean; LoanNo: Code[20]; PostInt: Integer)
    var
        RSchedule: Record "Loan Repayment Schedule";
        LoansR: Record "Loan Application";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        DocMngt: Codeunit "Doc. Mngt";
        RepayPeriod: Integer;
        InitialInstal: Integer;
        RegMgt: Codeunit "Register Management";
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        Varvariant: Variant;
        Principal: Decimal;
        GrInterest: Decimal;
        GrPrinciple: Decimal;
        RepayCode: Code[10];
        LoanApp: Record "Loan Application";
        AccInt: Decimal;
        StartMonth: Date;
        EndMonthDate: Date;
        CheckoffDate: Date;
        MidCheckDate: Date;
        IntDays: Integer;
        LSchedule: Record "Loan Repayment Schedule";
        SharesDeposit: Decimal;
        SharesBanding: Decimal;

    begin

        RSchedule.Reset;
        RSchedule.SetRange("No.", LoanNo);
        RSchedule.DeleteAll;

        LoansR.Reset;
        LoansR.SetRange("No.", LoanNo);
        if LoansR.Find('-') then begin

            LoansR.TestField("Disbursement Date");
            LoansR.TestField("Repayment Start Date");
            IntDays := 0;

            StartMonth := CalcDate('-CM', LoansR."Disbursement Date");
            EndMonthDate := CalcDate('CM', LoansR."Disbursement Date");

            if LoansR."Disbursement Date" >= MidCheckDate then
                IntDays := StartMonth - EndMonthDate else
                IntDays := 0;
            LoanAmount := LoansR."Approved Amount";
            InterestRate := LoansR."Interest Rate";
            RepayPeriod := LoansR.Installments;
            InitialInstal := LoansR.Installments;
            LBalance := LoansR."Approved Amount";
            RunDate := LoansR."Repayment Start Date";
            SharesBanding := LoansR."Shares Banding";
            SharesDeposit := LoansR."Shares Deposit";
            InstalNo := 0;

            case LoansR."Repayment Frequency" of
                LoansR."Repayment Frequency"::Daily:
                    RunDate := CalcDate('-1D', RunDate);
                LoansR."Repayment Frequency"::Weekly:
                    RunDate := CalcDate('-1W', RunDate);
                LoansR."Repayment Frequency"::Monthly:
                    RunDate := CalcDate('-1M', RunDate);
                LoansR."Repayment Frequency"::Quarterly:
                    RunDate := CalcDate('-1Q', RunDate);
                LoansR."Repayment Frequency"::Yearly:
                    RunDate := CalcDate('-1Y', RunDate);
            end;
            repeat

                InstalNo := InstalNo + 1;
                case LoansR."Repayment Frequency" of
                    LoansR."Repayment Frequency"::Daily:
                        RunDate := CalcDate('1D', RunDate);
                    LoansR."Repayment Frequency"::Weekly:
                        RunDate := CalcDate('1W', RunDate);
                    LoansR."Repayment Frequency"::Monthly:
                        RunDate := CalcDate('1M', RunDate);
                    LoansR."Repayment Frequency"::Quarterly:
                        RunDate := CalcDate('1Q', RunDate);
                    LoansR."Repayment Frequency"::Yearly:
                        RunDate := CalcDate('1Y', RunDate);
                end;

                SharesDeposit := (SharesDeposit + SharesBanding);

                LoansR.TestField(Installments);

                case LoansR."Interest Calculation Method" of
                    LoansR."Interest Calculation Method"::Amortised:
                        begin
                            LoansR.TestField("Interest Rate");
                            TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 1, '=');
                            LInterest := Round(LBalance * InterestRate / 12 / 100, 0.01, '=');
                            LPrincipal := (TotalMRepay - LInterest);

                        end;
                    LoansR."Interest Calculation Method"::"Straight Line":
                        begin
                            LoansR.TestField("Interest Rate");
                            LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');
                            LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');
                        end;
                    LoansR."Interest Calculation Method"::"Reducing Balance":
                        begin
                            LoansR.TestField("Interest Rate");
                            LPrincipal := LoanAmount / RepayPeriod;
                            LInterest := (InterestRate / 12 / 100) * LBalance;
                        end;
                    LoansR."Interest Calculation Method"::"Reducing Flat":
                        begin
                            LoansR.TestField("Interest Rate");
                            LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '=');
                            LInterest := Round((LoansR."Approved Amount" * 0.6) * (LoansR.Installments + 1) / (LoansR.Installments * 100), 1, '=');
                        end;
                    LoansR."Interest Calculation Method"::"Zero Interest":
                        begin
                            LPrincipal := LoanAmount / RepayPeriod;
                        end
                end;

                if GrInterest > 0 then
                    LInterest := 0;
                GrPrinciple := GrPrinciple - 1;
                GrInterest := GrInterest - 1;
                Evaluate(RepayCode, Format(InstalNo));

                if InstalNo = LoansR.Installments then
                    Principal := LPrincipal else
                    Principal := LPrincipal;

                RegMgt.ScheduledRepayDetail(LoansR."No.", RepayCode, RunDate, InstalNo,
                LoansR."Interest Rate", Principal, LInterest, 0, (LInterest + Principal),
                LBalance, SharesBanding, SharesDeposit, 0, 0, 0);
                LBalance := Round(LBalance - LPrincipal);
            until InstalNo = LoansR.Installments;
        end;

        Commit;
        Varvariant := LoansR;
        DocMngt.DocPrintRepayschedule(Varvariant, 1);

    end;

}
