codeunit 50071 "Cred. Mngt Loan Appraisal"
{
    TableNo = "Loan Calculator";

    trigger OnRun()
    begin

        AppCode(Rec, true);
    end;

    var
        AppraisalParameter: Record "Loan Appraisal Parameter";
        RegMngt: Codeunit "Register Management";
        LoanApplication: Record "Loan Calculator";
        CreditMngt: Codeunit "Credit Mgmt.";
        PeriodicAct: Codeunit "Periodic Activities Mgt.";
        LoanIntLine: Record "Interest Line";
        IntLine: Record "Interest Line";
        ExciseDuty: Decimal;
        NetUlizableAmt: Decimal;
        Amts: array[3] of Decimal;
        DocMngt: Codeunit "Doc. Mngt";
        AccountB: Record "Account Banking";
        SalAttribAmt: array[19] of Decimal;
        NoOfLoanGuaranteed: Integer;
        GuarantorsPosted: Record "Guarantor & Security Posted";
        PostedFacility: Record Loans;
        TotOutBalance: Decimal;
        TieredChargeLine: Record "Tiered Charges Line";
        TransType: Record "Transaction Charge";
        NotifSource: Enum NotifSourceType;
        CustRec: Record Member;
        Notif: Codeunit "SMS Notification";

    procedure RunWithCheck(var LoanApplic2: Record "Loan Calculator")
    begin
        LoanApplication.Copy(LoanApplic2);
        AppCode(LoanApplication, true);
        LoanApplic2 := LoanApplication
    end;

    procedure RunWithoutCheck(var LoanApplic2: Record "Loan Calculator")
    begin
        LoanApplication.Copy(LoanApplic2);
        AppCode(LoanApplication, false);
        LoanApplic2 := LoanApplication
    end;

    procedure AppCode(var RecRef: Record "Loan Calculator"; CheckLine: Boolean)
    var
        LoanAppcharges: Record "Loan Application Charge";
        MemberDeposits: Decimal;
        Loan: Record Loans;
        BoostAmt: Decimal;
        ProductFactory: Record "Product Factory";
        GeneralSetUp: Record "General Set-Up";
        DepositMultiplier: Decimal;
        RelatedBal: Decimal;
        NetOnDeposits: Decimal;
        AccruedInt: Decimal;
        AppraisalSal: Record "Appraisal Salary Details";
        ApprDetails: Record "Appraisal Salary Details";
        TBasic: Decimal;
        TEarning: Decimal;
        TAllowance: Decimal;
        TDeductions: Decimal;
        NetSalary: Decimal;
        TotalAmtCharge: Decimal;
        ExternalEff: Record "Other Commitements Clearance";
        TotalExteralRec: Decimal;
        NetOnSalary: Decimal;
        QualifyingAmount: Decimal;
        AvInterest: Decimal;
        Mult: Decimal;
        NetTakeHome: Decimal;
        TopUpComms: Decimal;
        TExternalEffects: Decimal;
        RepBasedOnRequested: Decimal;
        TotalLoan: Decimal;
        MaxAvailable: Decimal;
        LnSecurity: Record "Loan Guarantors and Security";
        TotAmtGuarant: Decimal;
        ChargeAmt: Decimal;
        LoanNetAmount: Decimal;
        QualifyingDivAmt: Decimal;
        Varvariant: Variant;
        AccountCred: Record "Account Credit";
        LoansTopUp: Record "Loans Topup-Ln. Calculator";
        LoanApplic: Record "Loan Calculator";
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
        RSchedule: Record "Loan Repayment Schedule";
        LoansType: Record "Product Factory";
        RelatedLoanT: Decimal;
        TopUpRepayment: Decimal;
        TopupLoan: Record "Loans Topup-Ln. Calculator";
        PostedFacility: Record Loans;
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
        TotInterestDue: Decimal;
        TotInsuranceFee: Decimal;
        DiffBoostAmt: Decimal;
        TotalLoanOrder: Decimal;
        NetDeduction: Decimal;
        NewNetSalary: Decimal;
        NewExcessTake: Decimal;
        InsuranceFee: Decimal;

    begin
        Initialize(RecRef);

        GeneralSetUp.Get();
        SalAttribAmt[1] := 0;
        SalAttribAmt[2] := 0;
        SalAttribAmt[3] := 0;
        SalAttribAmt[4] := 0;
        TotalLoanOrder := 0;
        SalAttribAmt[5] := 0;
        SalAttribAmt[6] := 0;

        JuniorBal := 0;
        TotalAmtCharge := 0;
        TotInterestDue := 0;
        TotInsuranceFee := 0;
        InsuranceFee := 0;
        RelatedLoan := 0;
        TopupAmt := 0;
        ExistDivLoan := 0;
        TDeductions := 0;
        NetDeduction := 0;
        AmtBoost := 0;
        NewExcessTake := 0;
        NewNetSalary := 0;
        SalAttribAmt[7] := 0;
        SalAttribAmt[8] := 0;
        SalAttribAmt[9] := 0;
        SalAttribAmt[10] := 0;
        SalAttribAmt[11] := 0;
        SalAttribAmt[12] := 0;
        SalAttribAmt[13] := 0;
        SalAttribAmt[14] := 0;
        SalAttribAmt[15] := 0;
        SalAttribAmt[16] := 0;
        ConsolidateLoans[1] := 0;
        ConsolidateLoans[2] := 0;
        DepMultiplier := 0;
        CurrDepMultiplier := 0;
        TopUpRepayment := 0;
        DFilter := '';
        QualifyingDivAmt := 0;
        FirstDayOfMonth := 0D;
        LastDayOfMonth := 0D;

        if RecRef."Approved Amount" = 0 then exit;

        GeneralSetUp.Get();
        GeneralSetUp.TestField("Max. Member Age");

        FirstDateMonth := CalcDate('-45D', Today);
        LastDateMonth := CalcDate('-CM', FirstDateMonth);
        FirstDayOfMonth := CalcDate('-3M', Today);
        LastDayOfMonth := CalcDate('CM', Today);

        RecRef.CalcFields("Total TopUp", "Amount Guaranteed", "Outstanding Total TopUp");

        ProductFactory.Reset();
        ProductFactory.SetRange("Product ID", RecRef."Product Type");
        if ProductFactory.FindFirst() then
            case ProductFactory."Deposits Appraisal Parameter" of
                ProductFactory."Deposits Appraisal Parameter"::Account,
                    ProductFactory."Deposits Appraisal Parameter"::Deposits:
                    begin
                        DepMultiplier := ProductFactory."Deposit Multiplier";
                    end else begin
                    DepMultiplier := ProductFactory."Ordinary Deposits Multiplier";
                end;
            end;

        Loan.Reset();
        Loan.SetRange("Account No.", RecRef."Account No.");
        if Loan.Find('-') then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                if Loan."Outstanding Balance" > 0 then begin
                    TotalLoanOrder := TotalLoanOrder + Loan.Repayment;
                    ConsolidateLoans[1] := (ConsolidateLoans[1] + Loan."Outstanding Balance");
                end
            until Loan.Next() = 0;
        end;
        ConsolidateLoans[1] := (ConsolidateLoans[1] - RecRef."Outstanding Total TopUp");

        if ConsolidateLoans[1] < 0 then
            ConsolidateLoans[1] := 0;

        AppraisalParameter."Applicant Age" := RecRef.getCustomerAge();
        AppraisalParameter."No." := RecRef."No.";
        AppraisalParameter."Minute No." := RecRef.Minute;
        AppraisalParameter."Account No." := RecRef."Account No.";
        AppraisalParameter."Account Name" := RecRef."Account Name";
        AppraisalParameter."Application Date" := RecRef."Application Date";
        AppraisalParameter."Created By" := RecRef."Captured By";
        AppraisalParameter."Product Type" := RecRef."Product Type";
        AppraisalParameter."Payroll/Staff No." := RecRef."Payroll/Staff No.";
        AppraisalParameter."Employer Code" := RecRef."Employer Code";
        AppraisalParameter."Product Name" := RecRef."Product Description";
        AppraisalParameter."Repayment Start Date" := RecRef."Repayment Start Date";
        AppraisalParameter."Expected Completion Date" := RecRef."Expected Date of Completion";
        AppraisalParameter.Installments := RecRef.Installments;

        AppraisalParameter.Interest := RecRef."Interest Rate";
        AppraisalParameter."Deposit Purchase" := RecRef."Deposit Purchase";
        AppraisalParameter.Sector := RecRef.Sectors;
        AppraisalParameter."Sub-Sector" := RecRef."Sub Sectors";
        AppraisalParameter."Loan Purpose" := RecRef."Purpose of Loan";
        AppraisalParameter."Balance (LCY)" := RecRef."Savings Balance(LCY)";
        AppraisalParameter.Remarks := RecRef.Remarks;
        AppraisalParameter."Amount (Requested)" := RecRef."Requested Amount";
        AppraisalParameter."Total Topup" := RecRef."Total TopUp";

        AppraisalParameter."Consolidated Loans(Sacco)" := ConsolidateLoans[1];

        AccountCred.Reset();
        AccountCred.SetRange("Member No.", RecRef."Account No.");
        AccountCred.SetRange("Account Category", AccountCred."Account Category"::"Shares Deposit");
        if AccountCred.FindFirst() then begin
            DFilter := Format(FirstDayOfMonth) + '..' + Format(Today);

            CustLedgerEntry.Reset();
            CustLedgerEntry.SetRange(Reversed, false);
            CustLedgerEntry.SetFilter("Posting Date", DFilter);
            CustLedgerEntry.SetRange("Source Code", 'CASHRECJNL');
            CustLedgerEntry.SetRange("Customer No.", AccountCred."No.");
            if CustLedgerEntry.Find('-') then begin
                CustLedgerEntry.CalcFields(Amount);
                if CustLedgerEntry.Amount >= ProductFactory."Max. Boost Amount" then
                    AmtBoost := (CustLedgerEntry.Amount * -1) else
                    AmtBoost := 0;
            end;
        end;

        if RecRef."Interest Calculation Method" = RecRef."Interest Calculation Method"::Amortised then
            AvInterest := Round((((RecRef.Repayment * RecRef.Installments) - RecRef."Approved Amount") / RecRef.Installments), 0.5, '=')
        else
            AvInterest := RecRef."Interest Repayment";
        AppraisalParameter."Average Interest" := AvInterest;
        if RecRef."Interest Calculation Method" <> RecRef."Interest Calculation Method"::"Zero Interest" then
            RepBasedOnRequested := Round((RecRef."Interest Rate" / 12 / 100) /
            (1 - Power((1 + (RecRef."Interest Rate" / 12 / 100)), -RecRef.Installments)) * RecRef."Requested Amount", 0.5, '=');

        if GeneralSetUp."Appraise On Deposit Purchase" then
            MemberDeposits := fnSharesDeposits(RecRef."Account No.", RecRef."Product Type", RecRef."Deposit Purchase") - AmtBoost else
            MemberDeposits := fnSharesDeposits(RecRef."Account No.", RecRef."Product Type", 0) - AmtBoost;

        if CustRec.Get(RecRef."Account No.") then begin
            CustRec.TestField("Date of Birth");

            if CalcDate(GeneralSetUp."Max. Member Age", CustRec."Date of Birth") <= Today then begin
                DepositMultiplier := MemberDeposits;

            end else begin

                case ProductFactory."Deposits Appraisal Parameter" of
                    ProductFactory."Deposits Appraisal Parameter"::Deposits:
                        begin
                            ProductFactory.TestField("Deposit Multiplier");
                            DepositMultiplier := Round((MemberDeposits * (ProductFactory."Deposit Multiplier" / 100)));
                        end;
                    ProductFactory."Deposits Appraisal Parameter"::"Requested Amount":
                        begin
                            ProductFactory.TestField("Maximum Loan Amount");
                            DepositMultiplier := (MemberDeposits * DepMultiplier);
                        end;
                    ProductFactory."Deposits Appraisal Parameter"::Account:
                        begin
                            ProductFactory.TestField("Deposit Multiplier");
                            ProductFactory.TestField("Minimum Balance");
                            ProductFactory.TestField("Product Type");

                            AccBanking.Reset();
                            AccBanking.SetRange("Member No.", RecRef."Account No.");
                            AccBanking.SetRange("Product Type", ProductFactory."Product Type");
                            if AccBanking.FindSet() then begin
                                repeat
                                    AccBanking.CalcFields("Balance (LCY)");
                                    JuniorBal := JuniorBal + AccBanking."Balance (LCY)";
                                until AccBanking.Next() = 0;
                                DepositMultiplier := ((JuniorBal - ProductFactory."Minimum Balance") * ProductFactory."Deposit Multiplier");
                            end
                        end;
                    ProductFactory."Deposits Appraisal Parameter"::Salary:
                        begin

                            ProductFactory.TestField("Deposit Multiplier");
                            AccBanking.Reset();
                            AccBanking.SetRange("No.", RecRef."Disbursement Account No.");
                            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                            if AccBanking.FindFirst() then begin

                                StartDate := FirstDateMonth;
                                Enddate := Today;
                                DateFilter := Format(StartDate) + '..' + Format(Enddate);

                                BankAccLedgerEntry.SetCurrentKey("External Document No.");
                                BankAccLedgerEntry.Reset();
                                BankAccLedgerEntry.SetRange("External Document No.", 'SALPROC');
                                BankAccLedgerEntry.SetRange("Vendor No.", AccBanking."No.");
                                BankAccLedgerEntry.SetFilter("Posting Date", DateFilter);
                                if BankAccLedgerEntry.FindLast() then begin
                                    BankAccLedgerEntry.CalcFields(Amount);
                                    DepositMultiplier := Round(((BankAccLedgerEntry.Amount * -1) * (ProductFactory."Ordinary Deposits Multiplier")));
                                end else begin
                                    DepositMultiplier := 0;
                                end;
                            end else begin
                                DepositMultiplier := 0;
                            end;

                            AppraisalParameter."Salary Remittance" := (BankAccLedgerEntry.Amount * -1);
                            AppraisalParameter."Salary Remittance Multiplier" := DepositMultiplier;
                        end;

                    ProductFactory."Deposits Appraisal Parameter"::Dividends:
                        begin
                            case GeneralSetUp."Dividend Qualify Formula" of

                                GeneralSetUp."Dividend Qualify Formula"::"Generate Automatically":
                                    begin
                                        DivMngt.GenerateDividendsOnLoanAccount(RecRef."Account No.", RecRef."No.", RecRef."Product Type");
                                        DivProgression.Reset();
                                        DivProgression.SetRange("Member No", RecRef."Account No.");
                                        DivProgression.SetRange("Header No.", RecRef."No.");
                                        if DivProgression.FindSet() then begin
                                            DivProgression.CalcSums("Gross Dividends");
                                            QualifyingDivAmt := Round(DivProgression."Gross Dividends", 100, '<');
                                        end;

                                    end;
                                GeneralSetUp."Dividend Qualify Formula"::"Load Data":
                                    begin
                                        QualifyTemp.Reset();
                                        QualifyTemp.SetRange("No.", RecRef."Account No.");
                                        QualifyTemp.SetRange("Product Type", 'DIVIDEND');
                                        if QualifyTemp.FindFirst() then begin
                                            QualifyingDivAmt := QualifyTemp."Qualifying Amount"

                                        end;
                                    end;
                            end;

                            DepositMultiplier := QualifyingDivAmt * (ProductFactory."Deposit Multiplier" / 100);
                            if CsMember.Get(RecRef."Account No.") then
                                CsMember."Gross Dividends" := QualifyingDivAmt;
                            CsMember.Modify(true);
                        end else begin

                        DepositMultiplier := (MemberDeposits * DepMultiplier);
                    end;
                end;
            end;
        end;

        RecRef."Shares Deposit" := MemberDeposits;
        RecRef."Qualifying Dividend Amount" := QualifyingDivAmt;

        Mult := DepMultiplier;
        NetOnDeposits := DepositMultiplier;
        AppraisalParameter."Shares Deposits" := MemberDeposits;
        AppraisalParameter."Deposit Mutiplier" := DepositMultiplier;
        AppraisalParameter."Qualifying Dividend" := QualifyingDivAmt;
        AppraisalParameter.Multiplier := DepMultiplier;
        AppraisalParameter."Net On Deposit" := NetOnDeposits;

        ExternalEff.Reset;
        ExternalEff.SetRange("Application No.", RecRef."No.");
        ExternalEff.SetRange("Account Type", ExternalEff."Account Type"::"External Bank");
        if ExternalEff.Find('-') then begin
            ExternalEff.CalcSums(ExternalEff.Amount);
            ConsolidateLoans[2] := ExternalEff.Amount;
        end;

        AppraisalParameter."Consolidated Loans(External)" := ConsolidateLoans[2];

        AppraisalSal.Reset;
        AppraisalSal.SetRange("Client Code", RecRef."Account No.");
        AppraisalSal.SetRange("Loan Application No.", RecRef."No.");
        if AppraisalSal.Find('-') then begin
            repeat
                case AppraisalSal.Type of
                    AppraisalSal.Type::Basic:
                        begin
                            TBasic := TBasic + AppraisalSal.Amount;
                        end;
                    AppraisalSal.Type::Earnings:
                        begin
                            TEarning := TEarning + AppraisalSal.Amount;
                        end;
                    AppraisalSal.Type::"Other Allowances":
                        begin
                            TAllowance := TAllowance + AppraisalSal.Amount;
                        end;
                    AppraisalSal.Type::"Statutory Deduction",
                    Appraisalsal.Type::"Voluntary Deductions",
                    Appraisalsal.Type::"Sacco Deduction",
                    AppraisalSal.Type::Deductions:
                        begin
                            TDeductions := TDeductions + AppraisalSal.Amount;
                        end;
                end;
            until AppraisalSal.Next = 0;
        end;

        // Gross Pay
        ApprDetails.RESET;
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        ApprDetails.SetFilter(Type, '%1|%2|%3', ApprDetails.Type::"Other Allowances", ApprDetails.Type::Basic,
        ApprDetails.Type::Earnings);
        IF ApprDetails.FIND('-') then begin
            repeat
                SalAttribAmt[1] := SalAttribAmt[1] + ApprDetails.Amount;
            until ApprDetails.Next() = 0;
        end;
        AppraisalParameter."Gross Pay" := SalAttribAmt[1];

        ApprDetails.RESET;
        ApprDetails.SetRange(Type, ApprDetails.Type::"Gross Pay");
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.FIND('-') then begin
            ApprDetails.Amount := SalAttribAmt[1];
            ApprDetails.Modify(true)
        end;

        ApprDetails.Reset();
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        ApprDetails.SetRange(Type, ApprDetails.Type::"Cleared Effects");
        IF ApprDetails.FIND('-') then begin
            SalAttribAmt[15] := ApprDetails.Amount;
            ApprDetails.Modify(true)
        end;


        // Statutory Deductions
        ApprDetails.RESET;
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        ApprDetails.SetRange(Type, ApprDetails.Type::"Statutory Deduction");
        IF ApprDetails.FIND('-') then begin
            ApprDetails.CalcSums(Amount);
            SalAttribAmt[2] := ApprDetails.Amount;
        end;

        // Earning [Other Income]
        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::Earnings);
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.FIND('-') then begin
            ApprDetails.CalcSums(Amount);
            SalAttribAmt[3] := ApprDetails.Amount;
        end;
        // Net Salary
        SalAttribAmt[4] := (SalAttribAmt[1] - SalAttribAmt[2] - SalAttribAmt[3]);

        //utilizable
        ApprDetails.Reset();
        ApprDetails.SetFilter(Type, '%1|%2|%3|%4', ApprDetails.Type::Deductions,
        ApprDetails.Type::"Voluntary Deductions", ApprDetails.Type::Banding,
        ApprDetails.Type::"Sacco Deduction");
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            repeat
                SalAttribAmt[5] := SalAttribAmt[5] + ApprDetails.Amount;
            until ApprDetails.Next() = 0;
        end;

        //Net Take Home
        if ProductFactory."Appraise Based on Banking" then begin
            SalAttribAmt[6] := Round(SalAttribAmt[4] * (1 / 6), 0.5, '>')
        end else begin

            case ProductFactory."Deposits Appraisal Parameter" of
                ProductFactory."Deposits Appraisal Parameter"::Account:
                    begin
                        SalAttribAmt[6] := Round(SalAttribAmt[4] * (1 / 6), 0.5, '>')
                    end else begin
                    SalAttribAmt[6] := Round(SalAttribAmt[4] * (1 / 3), 0.5, '>');
                end;
            end;
        end;

        // Net Ulizable
        ApprDetails.RESET;
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetFilter(Type, '%1|%2|%3|%4|%5', ApprDetails.Type::Deductions,
        ApprDetails.Type::"Voluntary Deductions", ApprDetails.Type::Banding,
        ApprDetails.Type::"Sacco Deduction", ApprDetails.Type::"Statutory Deduction");
        IF ApprDetails.FIND('-') then begin
            repeat
                SalAttribAmt[7] := SalAttribAmt[7] + ApprDetails.Amount;
            until ApprDetails.Next() = 0;
        end;

        //Utilizable
        SalAttribAmt[8] := SalAttribAmt[1] - (SalAttribAmt[7] + SalAttribAmt[6]);

        /* Bridged Release */
        SalAttribAmt[9] := 0;

        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::Bridge);
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin

            LoansTopUp.Reset();
            LoansTopUp.SetRange("No.", RecRef."No.");
            LoansTopUp.SetRange("Account No.", RecRef."Account No.");
            if LoansTopup.FindSet() then begin
                LoansTopUp.CalcSums("Monthly Repayment");
                SalAttribAmt[9] := LoansTopup."Monthly Repayment";
                ApprDetails.Amount := SalAttribAmt[9];
                ApprDetails.Modify(true);
            end;
        end;

        // Non payroll
        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::"Non Payroll");
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            SalAttribAmt[10] := ApprDetails.Amount;
        end;

        ApprDetails.Reset();
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        ApprDetails.SetRange(Type, ApprDetails.Type::"New Repayment");
        if ApprDetails.FIND('-') then begin
            if RecRef."Product Type" = 'A106' then
                ApprDetails.Amount := (RecRef.Repayment / 2) else
                ApprDetails.Amount := RecRef.Repayment;
            ApprDetails.Modify(true);
        end;

        // Banding
        ApprDetails.RESET;
        ApprDetails.SetRange(Type, ApprDetails.Type::Banding);
        ApprDetails.SETRANGE("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            SalAttribAmt[11] := RecRef."Shares Banding";
            ApprDetails.Amount := SalAttribAmt[11];
            ApprDetails.Modify(true);
        end;
        // sacco Deductions
        RecRef.CalcFields("Total TopUp");

        TopUpRepayment := 0;
        if RecRef."Total TopUp" > 0 then begin
            TopupLoan.Reset();
            TopupLoan.SetRange("No.", RecRef."No.");
            if TopupLoan.FindSet() then begin
                TopupLoan.CalcSums("Monthly Repayment");
                TopUpRepayment := TopupLoan."Monthly Repayment"
            end;
        end else begin
            TopUpRepayment := 0
        end;

        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::"Sacco Deduction");
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            SalAttribAmt[12] := RecRef."Sacco Deductions";
            ApprDetails.Amount := SalAttribAmt[12];
            if ApprDetails.Amount < 0 then
                ApprDetails.Amount := 0;
            ApprDetails.Modify(true);
        end;

        SalAttribAmt[13] := 0;

        ApprDetails.Reset();
        ApprDetails.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7', ApprDetails.Type::Deductions,
        ApprDetails.Type::"Voluntary Deductions", ApprDetails.Type::Banding,
        ApprDetails.Type::"Sacco Deduction", ApprDetails.Type::"Non Payroll",
        ApprDetails.Type::"Statutory Deduction", ApprDetails.Type::"External Effects");
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        if ApprDetails.FindSet() then begin
            repeat
                SalAttribAmt[13] := SalAttribAmt[13] + ApprDetails.Amount;
            until ApprDetails.Next() = 0;
        end;

        ExternalEff.Reset;
        ExternalEff.SetRange("Application No.", RecRef."No.");
        ExternalEff.SetRange(Type, ExternalEff.Type::"Micro Finance");
        if ExternalEff.Find('-') then begin
            ExternalEff.CalcSums(ExternalEff."Monthly Deduction");
            TExternalEffects := ExternalEff."Monthly Deduction";
        end;

        ApprDetails.Reset();
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        ApprDetails.SetRange(Type, ApprDetails.Type::"External Effects");
        if ApprDetails.FIND('-') then begin
            SalAttribAmt[16] := ApprDetails.Amount
        end;

        //Net Pay
        SalAttribAmt[14] := 0;

        if RecRef."Total TopUp" > 0 then begin

            ApprDetails.Reset();
            ApprDetails.SetRange(Type, ApprDetails.Type::"Net Pay");
            ApprDetails.SetRange("Loan Application No.", RecRef."No.");
            ApprDetails.SetRange("Client Code", RecRef."Account No.");
            IF ApprDetails.Find('-') then begin
                SalAttribAmt[14] := ((SalAttribAmt[1] - SalAttribAmt[13]) + SalAttribAmt[9] + SalAttribAmt[15]);
                AppraisalParameter."Net utilizable" := SalAttribAmt[14];
                ApprDetails.Amount := SalAttribAmt[14];
                ApprDetails.Modify(true)
            end;
        end else begin

            ApprDetails.Reset();
            ApprDetails.SetRange(Type, ApprDetails.Type::"Net Pay");
            ApprDetails.SetRange("Loan Application No.", RecRef."No.");
            ApprDetails.SetRange("Client Code", RecRef."Account No.");
            IF ApprDetails.Find('-') then begin
                SalAttribAmt[14] := (SalAttribAmt[1] - (SalAttribAmt[13] + SalAttribAmt[15]));
                AppraisalParameter."Net utilizable" := SalAttribAmt[14];
                ApprDetails.Amount := SalAttribAmt[14];
                ApprDetails.Modify(true)
            end;
        end;

        if RecRef."Product Type" = 'A106' then
            NewNetSalary := (SalAttribAmt[14] - (RecRef.Repayment / 2)) else
            NewNetSalary := (SalAttribAmt[14] - RecRef.Repayment);

        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::"Net Pay");
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            ApprDetails.Amount := NewNetSalary;
            ApprDetails.Modify(true)
        end;

        AppraisalParameter."Net Pay" := SalAttribAmt[14];
        NoOfLoanGuaranteed := 0;

        GuarantorsPosted.Reset();
        GuarantorsPosted.SetRange(Substituted, false);
        GuarantorsPosted.SetFilter("Outstanding Balance", '>0');
        GuarantorsPosted.SetRange("Account No.", RecRef."Account No.");
        if GuarantorsPosted.Find('-') then begin
            GuarantorsPosted.CalcFields("Outstanding Balance");
            NoOfLoanGuaranteed := GuarantorsPosted.Count;
        end;

        PostedFacility.Reset();
        PostedFacility.SetRange("Account No.", RecRef."Account No.");
        PostedFacility.SetFilter("Outstanding Balance", '>0');
        if PostedFacility.FindSet() then begin
            repeat
                PostedFacility.CalcFields("Outstanding Balance");
                TotOutBalance := TotOutBalance + PostedFacility."Outstanding Balance";
            until PostedFacility.Next() = 0;
        end;

        if ProductFactory."Product ID" = 'FOSA' then begin
            if RecRef."Total TopUp" > 0 then
                RefinancedLoan := true else
                RefinancedLoan := false;

            ProductFactory.TestField("Maximum Loan Amount");
            if DepositMultiplier > ProductFactory."Maximum Loan Amount" then
                DepositMultiplier := ProductFactory."Maximum Loan Amount" else
                DepositMultiplier := DepositMultiplier;

            Loan.Reset;
            Loan.SetRange(Loan."Account No.", RecRef."Account No.");
            Loan.SetRange("Product Type", 'FOSA');
            Loan.SetFilter("Outstanding Balance", '>0');
            if Loan.Find('-') then begin
                repeat
                    Loan.CalcFields("Outstanding Balance", "Outstanding Interest");
                    RelatedLoan := (RelatedLoan + Loan."Outstanding Balance");
                until Loan.Next = 0;
                RelatedBal := RelatedLoan;
            end;
            if RefinancedLoan then
                RelatedBal := 0 else
                RefinancedLoan := RefinancedLoan;

        end else begin

            Loan.Reset;
            Loan.SetRange("Topped Up Loan", false);
            Loan.SetRange("Ignore Related Balance", false);
            Loan.SetRange("Exclude From Related Balance", false);
            Loan.SetRange(Loan."Account No.", RecRef."Account No.");
            if Loan.Find('-') then begin
                repeat
                    Loan.CalcFields("Outstanding Balance", "Outstanding Interest");
                    if Loan."Outstanding Balance" > 0 then begin
                        RelatedBal := (RelatedBal + Loan."Outstanding Balance");
                    end;
                until Loan.Next = 0;
            end;
        end;

        if RecRef."Total TopUp" > 0 then begin

            RelatedBal := RelatedBal;
            if RelatedBal < 0 then
                RelatedBal := 0;

            TopupAmt := RecRef."Total TopUp";
        end else begin
            TopupAmt := 0;
            RelatedBal := RelatedBal
        end;

        case
            ProductFactory."Deposits Appraisal Parameter" of
            ProductFactory."Deposits Appraisal Parameter"::"Requested Amount":
                begin
                    ProductFactory.TestField("Maximum Loan Amount");
                    MaxAvailable := DepositMultiplier;
                    if MaxAvailable >= ProductFactory."Maximum Loan Amount" then
                        MaxAvailable := ProductFactory."Maximum Loan Amount";
                end;
            ProductFactory."Deposits Appraisal Parameter"::Business:
                begin
                    ProductFactory.TestField("Maximum Loan Amount");
                    MaxAvailable := ProductFactory."Maximum Loan Amount";
                end;
            ProductFactory."Deposits Appraisal Parameter"::Account:
                begin
                    MaxAvailable := DepositMultiplier;
                end;
            ProductFactory."Deposits Appraisal Parameter"::Collateral:
                begin

                    ProductFactory.TestField("Maximum Loan Amount");
                    MaxAvailable := ProductFactory."Maximum Loan Amount";
                end;
            ProductFactory."Deposits Appraisal Parameter"::Dividends:
                begin
                    Loan.Reset();
                    Loan.SetRange("Account No.", RecRef."Account No.");
                    Loan.SetRange("Appraisal Parameter Type", Loan."Appraisal Parameter Type"::Dividends);
                    if Loan.FindFirst() then begin
                        repeat
                            Loan.CalcFields("Outstanding Balance");
                            ExistDivLoan := (ExistDivLoan + Loan."Outstanding Balance");
                        until Loan.Next() = 0;
                    end;
                    MaxAvailable := (DepositMultiplier - ExistDivLoan);
                end else begin
                if ProductFactory."Repayment Mode" = ProductFactory."Repayment Mode"::Salary then begin
                    if RecRef."Total TopUp" > 0 then
                        MaxAvailable := DepositMultiplier else
                        MaxAvailable := DepositMultiplier;
                end else begin
                    // if ProductFactory."Deposits Appraisal Parameter" = ProductFactory."Deposits Appraisal Parameter"::Collateral then
                    //     MaxAvailable := DepositMultiplier else
                    MaxAvailable := DepositMultiplier;
                    //MaxAvailable := (DepositMultiplier - RelatedBal);
                end;
            end;
        end;


        if MaxAvailable < 0 then
            MaxAvailable := 0;

        AppraisalParameter."Max. Credit Available" := MaxAvailable;
        AppraisalParameter."Total (Basic)" := TBasic;
        AppraisalParameter."Total (Allowance)" := TAllowance;
        AppraisalParameter."Total (Deductions)" := TDeductions;
        AppraisalParameter."Total (Earnings)" := TEarning;
        AppraisalParameter."Related Balance" := RelatedBal;

        ExternalEff.Reset;
        ExternalEff.SetRange("Application No.", RecRef."No.");
        ExternalEff.SetRange("Affects 2/3 Rule", true);
        if ExternalEff.Find('-') then begin
            ExternalEff.CalcSums("Monthly Deduction");
            TotalExteralRec := ExternalEff."Monthly Deduction";
        end;

        ExternalEff.Reset;
        ExternalEff.SetRange("Application No.", RecRef."No.");
        ExternalEff.SetRange(Type, ExternalEff.Type::"Micro Finance");
        if ExternalEff.Find('-') then begin
            ExternalEff.CalcSums(ExternalEff."Monthly Deduction");
            TExternalEffects := ExternalEff."Monthly Deduction";
        end;

        AppraisalParameter."External Commitment" := TExternalEffects;

        NetSalary := ((TBasic + TEarning + TAllowance) - TDeductions);
        NetOnSalary := Round((NetSalary - (TBasic * 1 / 3)), 1, '=');

        NetUlizableAmt := 0;
        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::"Net Pay");
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            NetUlizableAmt := ApprDetails.Amount;
        end;

        AppraisalParameter."New Net Salary" := NewNetSalary;
        AppraisalParameter."Gross Pay %" := SalAttribAmt[1] * (33 / 100);
        AppraisalParameter."Excess of a Third" := (SalAttribAmt[14] - AppraisalParameter."Gross Pay %");

        if NewNetSalary <= AppraisalParameter."Gross Pay %" then begin
            NewNetSalary := AppraisalParameter."Gross Pay %";
            NewExcessTake := (NewNetSalary - AppraisalParameter."Gross Pay %");
        end else begin
            NewExcessTake := (NewNetSalary - AppraisalParameter."Gross Pay %");
        end;

        AppraisalParameter."New Excess Amount" := NewExcessTake;

        RSchedule.Reset();
        RSchedule.SetRange("No.", RecRef."No.");
        if RSchedule.FindSet() then begin
            RSchedule.CalcSums("Monthly Interest", "Insurance Repayment");
            TotInsuranceFee := RSchedule."Insurance Repayment";
            TotInterestDue := RSchedule."Monthly Interest";
        end;

        LoanNetAmount := Round(AppraisalParameter."Excess of a Third" * (Power((1 + (RecRef."Interest Rate" / 12 / 100)), RecRef.Installments) - 1) *
           (1 / ((RecRef."Interest Rate" / 12 / 100) * Power((1 + (RecRef."Interest Rate" / 12 / 100)), RecRef.Installments))), 1, '=');

        if CalcDate(GeneralSetUp."Max. Member Age", CustRec."Date of Birth") <= Today then
            LoanNetAmount := LoanNetAmount else
            LoanNetAmount := (LoanNetAmount - TotInsuranceFee);

        if LoanNetAmount < 0 then
            LoanNetAmount := 0;

        case ProductFactory."Deposits Appraisal Parameter" of
            ProductFactory."Deposits Appraisal Parameter"::Collateral:
                begin

                    LnSecurity.Reset;
                    LnSecurity.SetRange("No.", RecRef."No.");
                    LnSecurity.SetRange("Security Type", LnSecurity."Security Type"::Collateral);
                    if LnSecurity.Find('-') then begin
                        LnSecurity.CalcSums("Amount Guaranteed");
                        TotAmtGuarant := LnSecurity."Amount Guaranteed";
                    end;
                    CollateralReg.Reset();
                    CollateralReg.SetRange("No.", LnSecurity."Collateral Reg. No.");
                    if CollateralReg.Find('-') then begin
                        PropType.Reset();
                        PropType.SetRange(Code, CollateralReg."Property Type");
                        if PropType.Find('-') then begin
                            PropType.TestField("Value %");
                            TotAmtGuarant := Round((TotAmtGuarant * (PropType."Value %" / 100)), 1, '=')
                        end;
                    end;
                end;

            ProductFactory."Deposits Appraisal Parameter"::Account:
                begin
                    LnSecurity.Reset;
                    LnSecurity.SetRange("No.", RecRef."No.");
                    LnSecurity.SetRange("Security Type", LnSecurity."Security Type"::Lien);
                    if LnSecurity.Find('-') then begin
                        LnSecurity.CalcSums("Amount Guaranteed");
                        TotAmtGuarant := LnSecurity."Amount Guaranteed";
                    end;
                end else begin

                LnSecurity.Reset;
                LnSecurity.SetRange("No.", RecRef."No.");
                LnSecurity.SetRange("Security Type", LnSecurity."Security Type"::Guarantor);
                if LnSecurity.Find('-') then begin
                    LnSecurity.CalcSums("Amount Guaranteed");
                    TotAmtGuarant := LnSecurity."Amount Guaranteed";
                end;

            end;
        end;

        TotalLoan := Round((((NetUlizableAmt * (RecRef.Installments * 100)) / (RecRef.Installments + 100)) - 1000), 1, '=');
        if TotalLoan < 0 then
            TotalLoan := 0;
        if MaxAvailable < 0 then
            MaxAvailable := 0;

        if TotAmtGuarant < 0 then
            TotAmtGuarant := 0;

        AppraisalParameter."Total External Deduct." := TotalExteralRec;
        AppraisalParameter."External Effects" := TExternalEffects;
        AppraisalParameter."Net Salary" := NetSalary;
        AppraisalParameter."Net On Salary" := NetOnSalary;
        AppraisalParameter."Loan Net Amount" := LoanNetAmount;
        AppraisalParameter."Total Loan" := TotalLoan;
        AppraisalParameter."Tot Amt. Guaranteed" := TotAmtGuarant;

        case RecRef."Appraisal Parameter Type" of
            RecRef."Appraisal Parameter Type"::"Check Off":
                begin

                    case ProductFactory."Deposits Appraisal Parameter" of
                        ProductFactory."Deposits Appraisal Parameter"::Deposits:
                            begin

                                if MaxAvailable >= RecRef."Requested Amount" then
                                    QualifyingAmount := RecRef."Requested Amount" else
                                    QualifyingAmount := MaxAvailable;

                                if QualifyingAmount >= LoanNetAmount then
                                    QualifyingAmount := LoanNetAmount else
                                    QualifyingAmount := QualifyingAmount;
                            end;
                        ProductFactory."Deposits Appraisal Parameter"::Collateral:
                            begin
                                if MaxAvailable >= TotAmtGuarant then
                                    QualifyingAmount := TotAmtGuarant else
                                    QualifyingAmount := MaxAvailable;

                                if QualifyingAmount >= RecRef."Requested Amount" then
                                    QualifyingAmount := RecRef."Requested Amount" else
                                    QualifyingAmount := QualifyingAmount;

                                if QualifyingAmount >= LoanNetAmount then
                                    QualifyingAmount := LoanNetAmount else
                                    QualifyingAmount := QualifyingAmount;

                            end else begin

                            if MaxAvailable >= LoanNetAmount then
                                QualifyingAmount := LoanNetAmount else
                                QualifyingAmount := MaxAvailable;

                            if QualifyingAmount >= RecRef."Requested Amount" then
                                QualifyingAmount := RecRef."Requested Amount" else
                                QualifyingAmount := QualifyingAmount;
                        end;
                    end;
                end;
            RecRef."Appraisal Parameter Type"::Horticulture:
                begin
                    if MaxAvailable >= TotAmtGuarant then
                        QualifyingAmount := TotAmtGuarant else
                        QualifyingAmount := MaxAvailable;
                    if QualifyingAmount > LoanNetAmount then
                        QualifyingAmount := LoanNetAmount else
                        QualifyingAmount := QualifyingAmount;
                    if QualifyingAmount > RecRef."Requested Amount" then
                        QualifyingAmount := RecRef."Requested Amount" else
                        QualifyingAmount := QualifyingAmount;
                end;
            RecRef."Appraisal Parameter Type"::Salary:
                begin
                    if ProductFactory."Appraise Based on Banking" then begin

                        if MaxAvailable >= TotAmtGuarant then
                            QualifyingAmount := TotAmtGuarant else
                            QualifyingAmount := MaxAvailable;

                        if QualifyingAmount >= RecRef."Requested Amount" then
                            QualifyingAmount := RecRef."Requested Amount" else
                            QualifyingAmount := QualifyingAmount;
                        if QualifyingAmount >= LoanNetAmount then
                            QualifyingAmount := LoanNetAmount else
                            QualifyingAmount := QualifyingAmount;

                    end else begin
                        if RecRef."Requested Amount" > LoanNetAmount then begin
                            QualifyingAmount := LoanNetAmount;
                        end else begin
                            QualifyingAmount := RecRef."Requested Amount";
                        end;
                    end;
                end;
            RecRef."Appraisal Parameter Type"::Business:
                begin
                    if MaxAvailable >= LoanNetAmount then
                        QualifyingAmount := LoanNetAmount else
                        QualifyingAmount := MaxAvailable;

                    if QualifyingAmount >= RecRef."Requested Amount" then
                        QualifyingAmount := RecRef."Requested Amount" else
                        QualifyingAmount := QualifyingAmount;
                end;
            RecRef."Appraisal Parameter Type"::Dividends:
                begin
                    if RecRef."Requested Amount" >= MaxAvailable then begin
                        QualifyingAmount := MaxAvailable;
                    end else begin
                        QualifyingAmount := RecRef."Requested Amount";
                    end;
                end;
        end;

        if not RecRef."Adjust Approved Amount" then begin
            RecRef."Recommended Amount" := Round(QualifyingAmount, 0.5, '<');
            if RecRef."Recommended Amount" < 0 then
                RecRef."Recommended Amount" := 0;

            if RecRef."Total TopUp" > RecRef."Recommended Amount" then
                RecRef."Recommended Amount" := 0;

            RecRef."Approved Amount" := RecRef."Recommended Amount";
            RecRef."Amount to Disburse" := RecRef."Recommended Amount";
            AppraisalParameter."Qualification (Salary)" := LoanNetAmount;
            AppraisalParameter."Qualification (Security)" := TotAmtGuarant;
            AppraisalParameter."Qualification (Shares)" := DepositMultiplier;
            AppraisalParameter."Amount (Recommended)" := RecRef."Recommended Amount";
            AppraisalParameter."Qualifying Amount" := QualifyingAmount;

        end else begin

            if RecRef."Recommended Amount" < 0 then
                RecRef."Recommended Amount" := 0;

            if RecRef."Total TopUp" > RecRef."Recommended Amount" then
                RecRef."Recommended Amount" := 0;

            RecRef."Approved Amount" := RecRef."Recommended Amount";
            RecRef."Amount to Disburse" := RecRef."Recommended Amount";
            AppraisalParameter."Qualification (Salary)" := LoanNetAmount;
            AppraisalParameter."Qualification (Security)" := TotAmtGuarant;
            AppraisalParameter."Qualification (Shares)" := DepositMultiplier;
            AppraisalParameter."Amount (Recommended)" := RecRef."Recommended Amount";
            AppraisalParameter."Qualifying Amount" := QualifyingAmount;
        end;

        LoanAppcharges.Reset;
        LoanAppcharges.SetRange("Post Charge", true);
        LoanAppcharges.SetRange("Application No.", RecRef."No.");
        LoanAppcharges.SetRange("Product Code", RecRef."Product Type");
        LoanAppcharges.SetRange("Charge Type", LoanAppcharges."Charge Type"::General);
        if LoanAppcharges.Find('-') then begin
            repeat
                if LoanAppcharges."Use Percentage" then begin
                    LoanAppcharges.TestField(Percentage);
                    ChargeAmt := (ChargeAmt + (RecRef."Approved Amount" * (LoanAppcharges.Percentage / 100)));
                end else begin
                    LoanAppcharges.TestField("Charge Amount");
                    ChargeAmt := (ChargeAmt + LoanAppcharges."Charge Amount")
                end;
                if LoanAppcharges."Effect Excise Duty" = LoanAppcharges."Effect Excise Duty"::Yes then begin
                    ExciseDuty := (ExciseDuty + (ChargeAmt * GeneralSetUp."Excise Duty (%)" / 100));
                end;
            until LoanAppcharges.Next = 0;
        end;

        Amts[1] := ExciseDuty;

        if RecRef."Deposit Purchase" > 0 then begin
            LoanAppcharges.Reset;
            LoanAppcharges.SetRange("Application No.", RecRef."No.");
            LoanAppcharges.SetRange("Charge Type", LoanAppcharges."Charge Type"::Boosting);
            if LoanAppcharges.FindSet then begin
                repeat
                    if LoanAppcharges."Use Percentage" then begin
                        LoanAppcharges.TestField(Percentage);
                        BoostAmt := Round((BoostAmt + (RecRef."Deposit Purchase" * (LoanAppcharges.Percentage / 100))), 0.5, '=');
                    end else begin
                        LoanAppcharges.TestField("Charge Amount");
                        BoostAmt := (BoostAmt + LoanAppcharges."Charge Amount")
                    end;

                    if LoanAppcharges."Effect Excise Duty" = LoanAppcharges."Effect Excise Duty"::Yes then begin
                        ExciseDuty := Round((ExciseDuty + (BoostAmt * GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=');
                    end;
                until LoanAppcharges.Next = 0;
            end;
        end;

        Amts[2] := ExciseDuty;

        if RecRef."Total TopUp" > 0 then begin
            LoanAppcharges.Reset;
            LoanAppcharges.SetRange("Application No.", RecRef."No.");
            LoanAppcharges.SetRange("Charge Type", LoanAppcharges."Charge Type"::"Top up");
            if LoanAppcharges.FindSet then begin
                repeat
                    if LoanAppcharges."Staggered Charge Code" = '' then begin
                        if LoanAppcharges."Use Percentage" then begin
                            LoanAppcharges.TestField(Percentage);
                            TopUpComms := (TopUpComms + (RecRef."Outstanding Total TopUp" * (LoanAppcharges.Percentage / 100)));
                        end else begin
                            LoanAppcharges.TestField("Charge Amount");
                            TopUpComms := (TopUpComms + LoanAppcharges."Charge Amount")
                        end;

                    end else begin
                        TransType.Reset();
                        TransType.SetRange("Staggered Charge Code", LoanAppcharges."Staggered Charge Code");
                        if TransType.FindFirst() then begin

                            TieredChargeLine.Reset();
                            TieredChargeLine.SetRange(code, TransType."Staggered Charge Code");
                            if TieredChargeLine.FindSet() then begin
                                repeat
                                    if (RecRef."Total TopUp" >= TieredChargeLine."Lower Limit") and (RecRef."Total TopUp" <= TieredChargeLine."Upper Limit") then begin
                                        if TieredChargeLine."Use Percentage" then begin
                                            TopUpComms := (RecRef."Outstanding Total TopUp" * (TieredChargeLine.Percentage / 100));
                                        end else begin
                                            TopUpComms := TieredChargeLine."Charge Amount"
                                        end;
                                    end;
                                until TieredChargeLine.Next() = 0;
                            end;
                        end;
                    end;

                    if LoanAppcharges."Effect Excise Duty" = LoanAppcharges."Effect Excise Duty"::Yes then begin
                        ExciseDuty := (ExciseDuty + (TopUpComms * GeneralSetUp."Excise Duty (%)" / 100));
                    end;
                until LoanAppcharges.Next = 0;
            end;
        end else begin
            TopUpComms := 0
        end;

        Amts[3] := ExciseDuty;

        TotalAmtCharge := (TopUpComms + ChargeAmt + Amts[1] + Amts[2] + Amts[3] + BoostAmt);
        AppraisalParameter."Boosting (Charges)" := BoostAmt;
        AppraisalParameter."TopUp Commission" := TopUpComms;
        AppraisalParameter."Excise Duty Charges" := Amts[1];
        AppraisalParameter."No. of Loan Guaranteed" := RegMngt.getNoOfLoansGuarantor(RecRef."No.");
        AppraisalParameter.Repayment := RecRef.Repayment;
        AppraisalParameter."Amount (Total Charges)" := TotalAmtCharge;
        AppraisalParameter."Due Application" := RecRef."Approved Amount" - (RecRef."Deposit Purchase" + ChargeAmt + Amts[1] + Amts[2] + Amts[3] + BoostAmt + RecRef."Total TopUp" +
         AppraisalParameter."Consolidated Loans(External)");

        NetTakeHome := RecRef."Approved Amount" - (RecRef."Deposit Purchase" + ChargeAmt + Amts[1] + Amts[2] + Amts[3] + BoostAmt + RecRef."Total TopUp" +
         AppraisalParameter."Consolidated Loans(External)");

        if NetTakeHome < 0 then begin
            RecRef."Approved Amount" := 0;
        end;

        RecRef."Amount to Disburse" := NetTakeHome;
        AppraisalParameter."Amount (Net Take Home)" := NetTakeHome;

        RecRef.Validate("Approved Amount");

        AppraisalParameter.Repayment := RecRef.Repayment;
        RecRef.CalcFields("Total TopUp");

        AppraisalParameter."Total Commitment" := (AppraisalParameter."Consolidated Loans(External)" + AppraisalParameter."Consolidated Loans(Sacco)");
        AppraisalParameter."Gross Pay %" := AppraisalParameter."Gross Pay" * (33 / 100);
        AppraisalParameter."Excess of a Third" := (AppraisalParameter."Net Pay" - AppraisalParameter."Gross Pay %");

        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::"Take Home");
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.FIND('-') then begin
            ApprDetails.Amount := AppraisalParameter."Excess of a Third";
            ApprDetails.Modify(true)
        end;

        if AppraisalParameter."Excess of a Third" < 0 then
            AppraisalParameter."Excess of a Third" := 0;

        AppraisalParameter."Total Exposure" := ((AppraisalParameter."Consolidated Loans(Sacco)" + RecRef."Approved Amount") - AppraisalParameter."Consolidated Loans(Sacco)");
        AppraisalParameter."Total Stop Order Amount" := (TotalLoanOrder + TExternalEffects + RecRef.Repayment) - TopUpRepayment;

        if RecRef."Product Type" = 'A106' then
            AppraisalParameter."Sacco Deductions" := (RecRef."Sacco Deductions" - SalAttribAmt[9]) + (RecRef.Repayment / 2) else
            AppraisalParameter."Sacco Deductions" := (RecRef."Sacco Deductions" - SalAttribAmt[9]) + RecRef.Repayment;
        AppraisalParameter."Qualification (Salary)" := LoanNetAmount;
        AppraisalParameter."Max. Loan Amount" := ProductFactory."Maximum Loan Amount";


        ApprDetails.Reset();
        ApprDetails.SetRange(Type, ApprDetails.Type::Banding);
        ApprDetails.SetRange("Loan Application No.", RecRef."No.");
        ApprDetails.SetRange("Client Code", RecRef."Account No.");
        IF ApprDetails.Find('-') then begin
            ApprDetails.Amount := RecRef."Shares Banding";
            ApprDetails.Modify(true);
        end;

        RecRef."Charges & Commissions" := (TopUpComms + BoostAmt + ChargeAmt);
        RecRef."Loan Status" := RecRef."Loan Status"::Appraisal;
        RecRef."Sacco Deductions" := RecRef."Sacco Deductions";
        RecRef."Amount to Disburse" := NetTakeHome;

        GuarantPosted.Reset();
        GuarantPosted.SetRange("No.", RecRef."No.");
        GuarantPosted.SetRange("Security Type", GuarantPosted."Security Type"::Collateral);
        if GuarantPosted.FindFirst() then begin
            GuarantPosted.CalcSums("Collateral Value");
            AppraisalParameter."Valuation Amount" := GuarantPosted."Collateral Value";

            CollReg.Reset();
            CollReg.SetRange("No.", GuarantPosted."Collateral Reg. No.");
            if CollReg.FindFirst() then begin

                PropertyType.Reset();
                PropertyType.SetRange(Code, CollReg."Property Type");
                if PropertyType.FindFirst() then begin
                    AppraisalParameter."Property Type" := PropertyType.Code;
                    AppraisalParameter."Property Description" := PropertyType.Description;
                end;
            end;
        end;

        if RecRef."Disbursement Account No." = '' then begin
            AccountB.Reset();
            AccountB.SetRange("Member No.", RecRef."Account No.");
            AccountB.SetRange("Account Category", AccountB."Account Category"::Savings);
            if AccountB.FindFirst() then
                RecRef."Disbursement Account No." := AccountB."No.";
        end;

        RecRef.Modify;
        AppraisalParameter."Amount Approved" := RecRef."Approved Amount";
        AppraisalParameter.Insert(true);

        GeneralSetUp.Get();
        Commit;
        Varvariant := RecRef;
        DocMngt.DocPrintRepayschedule(Varvariant, 2)
    end;

    local procedure Initialize(Rec: Record "Loan Calculator")
    var
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
        GeneralSetUp.Get;
        GeneralSetUp.TestField("Excise Duty (%)");
        AppraisalParameter.SetRange("No.", Rec."No.");
        AppraisalParameter.DeleteAll;
        AppraisalParameter.Init;
        AppraisalParameter."Entry No." := RegMngt.InitNextEntryNo;
    end;

    procedure fnSharesDeposits(MemberNo: Code[20]; ProdType: Code[10]; DepositPurchase: Decimal): Decimal
    var
        CredAcc: Record "Account Credit";
        TotDeposits: Decimal;
    begin
        CredAcc.Reset;
        CredAcc.SetRange("Member No.", MemberNo);
        CredAcc.SetRange("Account Category", CredAcc."Account Category"::"Shares Deposit");
        if CredAcc.Find('-') then begin
            CredAcc.CalcFields(CredAcc."Balance (LCY)");
            TotDeposits := CredAcc."Balance (LCY)" + DepositPurchase;
        end;
        exit(TotDeposits)
    end;

    procedure SendSmsNotification(AcNo: Code[100]; LoaneeTxt: Text[150]; ProdType: Text[150]; ApprAmt: Decimal; LoanNo: Code[20])
    var
        Notification: Codeunit "SMS Notification";
        CredAcc: Record "Account Credit";

        Source: Option "New Member","New Account","Loan Account Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Calculator","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit"," Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit",InternetBanking,CRM,"Loan Repayment",Bithday;
    begin

        if CredAcc.Get(AcNo) then begin
            if CustRec.Get(CredAcc."Member No.") then
                Notification.CreateSmsNotif(NotifSource::"Loan Guarantors",
                CustRec."Mobile Phone No", 'Dear Member,' +
                CredAcc.Name +
                ' You have guaranteed' + LoaneeTxt + ',' +
                 ProdType + ' of Kshs ' + Format(ApprAmt) +
                '. at SNAT SACCO LTD. If in dispute call ********. Thank You.', LoanNo, CredAcc."No.", false);
        end;
    end;

}
