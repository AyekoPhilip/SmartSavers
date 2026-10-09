codeunit 50004 "Payroll Post Mngt."
{
    TableNo = "HR Employees";

    trigger OnRun()
    begin
        InitPost(Rec);
    end;

    procedure getOpenPeriod(): Date
    begin
        exit(fnGetOpenPeriod());
    end;

    local procedure fngetEmployeeMemberNo(StrEmp: Code[100]): Code[100]
    begin
        HrEmployee.Get(StrEmp);
        HrEmployee.TestField("Member No.");
        exit(HrEmployee."Member No.")
    end;

    procedure InitPost(ObjtEmp: Record "HR Employees")
    var
        ObjPayrollPeriod: Date;
    begin

        ObjPayrollPeriod := 0D;
        ObjtEmp.TestField("Date of Join");
        ObjtEmp.TestField(Status, ObjtEmp.Status::Active);
        ObjtEmp.TestField("Approval Status", ObjtEmp."Approval Status"::Approved);
        ObjPayrollPeriod := fnGetOpenPeriod();

        PrsalCard.Reset();
        PrsalCard.SetRange("Employee Code", ObjtEmp."No.");
        if PrsalCard.FindFirst() then begin

            fnProcesspayroll(ObjtEmp."No.", ObjtEmp."Date of Join", PrsalCard."Basic Pay",
            PrsalCard."Pays PAYE", PrsalCard."Pays NSSF", PrsalCard."Pays NHIF", ObjPayrollPeriod,
            ObjPayrollPeriod, '', '', ObjtEmp."Date of Leaving", true, ObjtEmp."Department Code",
            ObjtEmp."Payroll Code", ObjtEmp."Global Dimension 1 Code", ObjtEmp."Global Dimension 2 Code", true);

        end;
    end;

    procedure fnInitialize()
    var
    begin
        VitalSetup.Get();
        VitalSetup.TestField("Checkoff-Cuttof Day");

        curReliefPersonal := VitalSetup."Tax Relief";
        curReliefInsurance := VitalSetup."Insurance Relief";
        curReliefMorgage := VitalSetup."Mortgage Relief";
        curMaximumRelief := VitalSetup."Max Relief";
        curNssfEmployee := VitalSetup."NSSF Employee";
        curNssfEmployerFactor := VitalSetup."NSSF Employer Factor";
        intNHIFBasedOn := VitalSetup."NHIF Based on";
        intNSSFBasedOn := VitalSetup."NHIF Based on";
        curMaxPensionContrib := VitalSetup."Max Pension Contribution";
        curRateTaxExPension := VitalSetup."Tax On Excess Pension";
        curOOIMaxMonthlyContrb := VitalSetup."OOI Deduction";
        curOOIDecemberDedc := VitalSetup."OOI December";
        curLoanMarketRate := VitalSetup."Loan Market Rate";
        curLoanCorpRate := VitalSetup."Loan Corporate Rate";
        CurMinTxblePwd := VitalSetup."Max. Non Taxable";
        curHIFReliefPerc := VitalSetup."NHIF Relief";
        curHIFReliefPerc := VitalSetup."Housing Levy Relief";
        checkoffcutoffDay := VitalSetup."Checkoff-Cuttof Day";

        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");

        Dim1 := Temp."Global Dimension 1 Code";
        Dim2 := Temp."Global Dimension 2 Code";
    end;

    local procedure fnClearExistsEntry(StrEmpCode: Code[20]; dtOpenPeriod: Date)
    var
        PrPeriodTransactions: Record "Pr Period Transaction";
        prEmployerDeductions: Record "Pr Employer Deduction";
    begin
        PrPeriodTransactions.Reset();
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code", strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", dtOpenPeriod);
        if prPeriodTransactions.FindSet() then
            prPeriodTransactions.DeleteAll();

        prEmployerDeductions.Reset();
        prEmployerDeductions.SetRange(prEmployerDeductions."Employee Code", strEmpCode);
        prEmployerDeductions.SetRange(prEmployerDeductions."Payroll Period", dtOpenPeriod);
        if prEmployerDeductions.FindSet() then
            prEmployerDeductions.DeleteAll();
    end;

    local procedure fnBasicPayProrated(StrEmpCode: Code[20]; Month: Integer; Year: Integer; BasicSalary: Decimal; DaysWorked: Integer; DaysInMonth: Integer) ProratedAmt: Decimal
    begin
        ProratedAmt := Round((DaysWorked / DaysInMonth) * BasicSalary);

    end;

    procedure fnGetOpenPeriod() dtOpenPeriod: Date
    var
        PrPayrollPeriod: Record "Pr Payroll Period";
        intMonth: Integer;
        intYear: Integer;
    begin

        PrPayrollPeriod.Reset();
        PrPayrollPeriod.SetRange(Closed, false);
        if PrPayrollPeriod.FindFirst() then begin
            dtOpenPeriod := PrPayrollPeriod."Date Opened";
            intMonth := Date2DMY(dtOpenPeriod, 2);
            intYear := Date2DMY(dtOpenPeriod, 3);
            exit(dtOpenPeriod)
        end else begin
            Error('There is no open payroll period');
        end;
    end;

    local procedure fnDaysInMonth(dtDate: Date) DaysInMonth: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin

        TodayDate := dtDate;

        Day := DATE2DMY(TodayDate, 1);
        Expr1 := FORMAT(-Day) + 'D+1D';
        FirstDay := CALCDATE(Expr1, TodayDate);
        LastDate := CALCDATE('1M-1D', FirstDay);
        SysDate.RESET;
        SysDate.SETRANGE(SysDate."Period Type", SysDate."Period Type"::Date);
        SysDate.SETRANGE(SysDate."Period Start", FirstDay, LastDate);
        if SysDate.Find('-') then
            DaysInMonth := SysDate.Count;

    end;

    local procedure fnGetEmployeePaye(curTaxablePay: Decimal) PAYE: Decimal
    var
        PrPaye: Record "Pr PAYE";
        curTempAmount: Decimal;
        KeepCount: Integer;
    begin
        KeepCount := 0;
        PrPaye.Reset();
        if PrPaye.FindFirst() then begin
            IF curTaxablePay < PrPaye."PAYE Tier" then exit;
            repeat
                KeepCount += 1;
                curTempAmount := curTaxablePay;
                if curTaxablePay = 0 then exit;
                if KeepCount = PrPaye.Count then
                    curTaxablePay := curTempAmount
                else
                    if curTempAmount >= PrPaye."PAYE Tier" then
                        curTempAmount := PrPaye."PAYE Tier"
                    else
                        curTempAmount := curTempAmount;
                PAYE := PAYE + (curTempAmount * (PrPaye.Rate / 100));
                curTaxablePay := curTaxablePay - curTempAmount;
            until PrPaye.Next() = 0;
        end;

    end;

    local procedure fnGetEmployeeNHIF(curBaseAmount: Decimal): Decimal
    var
        PrNHIF: Record "Pr NHIF";
    begin
        VitalSetup.Get();
        VitalSetup.TestField("SHIF %");
        exit(Round(curBaseAmount * (VitalSetup."SHIF %" / 100)));
    end;

    local procedure fnDaysWorked(dtDate: Date; IsTermination: Boolean) DaysWorked: Decimal
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin

        TodayDate := dtDate;
        Day := Date2DMY(TodayDate, 1);
        Expr1 := Format(-Day) + 'D+1D';
        FirstDay := CalcDate(Expr1, TodayDate);
        LastDate := CalcDate('1M-1D', FirstDay);

        SysDate.Reset();
        SysDate.SetRange(SysDate."Period Type", SysDate."Period Type"::Date);
        if not IsTermination then
            SysDate.SetRange(SysDate."Period Start", dtDate, LastDate)
        else
            SysDate.SetRange(SysDate."Period Start", FirstDay, dtDate);
        if SysDate.FindFirst() then
            DaysWorked := SysDate.Count;
    end;

    local procedure fnUpdatePeriodTrans(EmpCode: Code[20]; TCode: Code[20]; TGroup: Code[20]; GroupOrder: Integer; SubGroupOrder: Integer; Description: Text[50]; curAmount: Decimal; curBalance: Decimal; Month: Integer; Year: Integer; Membership: Text[30]; ReferenceNo: Text[30]; dtOpenPeriod: Date; Department: Code[20]; JournalAc: Code[20]; PostAs: Enum PayrollPostAs; JournalAcType: Enum "Gen. Journal Account Type"; Dim1: Code[50]; Dim2: Code[50]; LoanNo: Code[50]; CoopParam: Enum CooParameter; StatutoryCateg: Enum PayrollStatutoryCategory; TransType: Enum "LoanTransactionType")
    var
        PrPeriodTrans: Record "Pr Period Transaction";
        PrSalCard: Record "HR Employees";
        TransCodes: Record "Pr Transaction Code";
        ProdFac: Record "Product Factory";

    begin

        if curAmount = 0 then exit;
        PrPeriodTrans.Init();
        PrPeriodTrans."Employee Code" := EmpCode;
        PrPeriodTrans."Transaction Code" := TCode;
        PrPeriodTrans."Group Text" := TGroup;
        PrPeriodTrans."Transaction Name" := Description;
        PrPeriodTrans.Amount := Round(curAmount, 0.05);
        PrPeriodTrans.Balance := curBalance;
        PrPeriodTrans."Original Amount" := PrPeriodTrans.Balance;
        PrPeriodTrans."Group Order" := GroupOrder;
        PrPeriodTrans."Sub Group Order" := SubGroupOrder;
        PrPeriodTrans.Membership := Membership;
        PrPeriodTrans."Reference No" := ReferenceNo;
        PrPeriodTrans."Period Month" := Month;
        PrPeriodTrans."Period Year" := Year;
        PrPeriodTrans."Payroll Period" := dtOpenPeriod;

        HrEmployee.Reset();
        HrEmployee.SetRange("No.", EmpCode);
        if HrEmployee.FindFirst() then
            PrPeriodTrans.Department := HrEmployee."Department Code";
        PrPeriodTrans."Department Code" := HrEmployee."Department Code";
        TransCodes.Reset();
        TransCodes.SetRange(Code, TCode);
        if TransCodes.FindFirst() then begin
            PrPeriodTrans."Transaction Type" := TransCodes."Transaction Type";
            PrPeriodTrans."Coop Parameters" := TransCodes."Coop Parameter";
        end;
        PrPeriodTrans."Account Type" := JournalActype;
        PrPeriodTrans."Post As" := PostAs;
        PrPeriodTrans.Validate("Account No.", JournalAc);
        PrPeriodTrans."Payroll Code" := PayrollType;
        PrPeriodTrans."Shortcut Dimension 1 Code" := Dim1;
        PrPeriodTrans."Shortcut Dimension 2 Code" := Dim2;
        PrPeriodTrans.Validate("Loan No.", LoanNo);
        PrPeriodTrans.Validate("coop parameters", CoopParam);
        if PrSalCard.Get(HrEmployee."No.") then
            PrPeriodTrans."Payment Mode" := PrSalCard."Payment Mode";
        PrPeriodTrans."Statutory category" := StatutoryCateg;
        PrPeriodTrans."Loan Transaction Type" := TransType;
        PrPeriodTrans.Insert(true)
    end;

    procedure fnPureFormula(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; strFormula: Text[250]; PayrollPeriod: Date) Formula: Text[250]
    var
        Where: Text[30];
        Which: Text[30];
        i: Integer;
        TransCode: Code[20];
        Char: Text[1];
        FirstBracket: Integer;
        StartCopy: Boolean;
        FinalFormula: Text[250];
        TransCodeAmount: Decimal;
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin

        TransCode := '';
        for i := 1 to StrLen(strFormula) do begin
            Char := CopyStr(strFormula, i, 1);
            if Char = '[' then StartCopy := true;
            if StartCopy then TransCode := TransCode + Char;
            if not StartCopy then
                FinalFormula := FinalFormula + Char;
            if Char = ']' then begin
                StartCopy := false;
                Where := '=';
                Which := '[]';
                TransCode := DelChr(TransCode, Where, Which);
                TransCodeAmount := fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
                TransCode := '';
                FinalFormula := FinalFormula + Format(TransCodeAmount);
            end;
        end;
        Formula := FinalFormula;
    end;

    procedure fnPureFormulaHseLevy(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; strFormula: Text[250]; PayrollPeriod: Date) Formula: Text[250]
    var
        Where: Text[30];
        Which: Text[30];
        i: Integer;
        TransCode: Code[20];
        Char: Text[1];
        FirstBracket: Integer;
        StartCopy: Boolean;
        FinalFormula: Text[250];
        TransCodeAmount: Decimal;
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin

        TransCode := '';
        for i := 1 to StrLen(strFormula) do begin
            Char := CopyStr(strFormula, i, 1);
            if Char = '[' then StartCopy := true;
            if StartCopy then TransCode := TransCode + Char;
            if not StartCopy then
                FinalFormula := FinalFormula + Char;
            if Char = ']' then begin
                StartCopy := false;
                Where := '=';
                Which := '[]';
                TransCode := DelChr(TransCode, Where, Which);
                TransCodeAmount := fnGetTransAmountHseLevy(strEmpCode, TransCode, intMonth, intYear);
                TransCode := '';
                FinalFormula := FinalFormula + Format(TransCodeAmount);
            end;
        end;
        Formula := FinalFormula;
    end;

    procedure fngetNonGrossAmount(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; PayrollPeriod: Date): Decimal
    var
        PrEmpTrans: Record "Pr Employee Transaction";
        PrTranscode: Record "Pr Transaction Code";
        strExtractedFrml: Text;
        FormlAmt: array[3] of Decimal;
    begin

        PrEmpTrans.Reset();
        PrEmpTrans.SetRange("Employee Code", strEmpCode);
        PrEmpTrans.SetRange("Period Month", intMonth);
        PrEmpTrans.SetRange("Period Year", intYear);
        PrEmpTrans.SetRange(Suspended, false);
        PrEmpTrans.SetRange("Payroll Period", PayrollPeriod);
        if PrEmpTrans.FindSet() then begin
            repeat

                PrTranscode.Reset();
                PrTranscode.SetRange(Code, PrEmpTrans."Transaction Code");
                PrTranscode.SetRange("Transaction Type", PrTranscode."Transaction Type"::Income);
                PrTranscode.SetRange("Is Not Gross Allowance ", true);
                if PrTranscode.Find('-') then begin
                    strExtractedFrml := '';
                    case PrTranscode."Is Formula" of
                        true:
                            begin
                                strExtractedFrml := fnPureFormula(PrEmpTrans."Employee Code", PrEmpTrans."Period Month", PrEmpTrans."Period Year", PrTranscode.Formula, fnGetOpenPeriod());
                                FormlAmt[1] := FormlAmt[1] + (fnFormulaResult(strExtractedFrml));
                            end;
                        false:
                            begin
                                FormlAmt[2] := FormlAmt[2] + PrEmpTrans.Amount
                            end;
                    end;
                end;
            until PrEmpTrans.Next() = 0;
        end;
        exit(FormlAmt[1] + FormlAmt[2])
    end;

    procedure fnGetTransAmount(strEmpCode: Code[20]; strTransCode: Code[20]; intMonth: Integer; intYear: Integer) TransAmount: Decimal
    var
        PrEmpTrans: Record "Pr Employee Transaction";
        PrPeriodTrans: Record "Pr Period Transaction";
    begin
        PrEmpTrans.Reset();
        PrEmpTrans.SetRange("Employee Code", strEmpCode);
        PrEmpTrans.SetRange("Transaction Code", strTransCode);
        PrEmpTrans.SetRange("Period Month", intMonth);
        PrEmpTrans.SetRange("Period Year", intYear);
        PrEmpTrans.SetRange(Suspended, false);
        if PrEmpTrans.FindFirst() then begin

            TransAmount := prEmpTrans.Amount;
            if PrEmpTrans."No. Of Units" <> 0 then
                TransAmount := prEmpTrans."No. Of Units";
        end;

        if TransAmount = 0 then begin

            PrPeriodTrans.Reset();
            PrPeriodTrans.SetRange("Employee Code", strEmpCode);
            PrPeriodTrans.SetRange("Transaction Code", strTransCode);
            PrPeriodTrans.SetRange("Period Month", intMonth);
            PrPeriodTrans.SetRange("Period Year", intYear);
            if PrPeriodTrans.FindFirst() then
                TransAmount := PrPeriodTrans.Amount;
        end;
    end;

    procedure fnGetTransAmountHseLevy(strEmpCode: Code[20]; strTransCode: Code[20]; intMonth: Integer; intYear: Integer) TransAmount: Decimal
    var
        PrEmpTrans: Record "Pr Employee Transaction";
        PrPeriodTrans: Record "Pr Period Transaction";
        PrTransCodes: Record "Pr Transaction Code";
    begin
        PrEmpTrans.Reset();
        PrEmpTrans.SetRange("Employee Code", strEmpCode);
        PrEmpTrans.SetRange("Transaction Code", strTransCode);
        PrEmpTrans.SetRange("Period Month", intMonth);
        PrEmpTrans.SetRange("Period Year", intYear);
        PrEmpTrans.SetRange(Suspended, false);
        if PrEmpTrans.FindFirst() then begin
            TransAmount := prEmpTrans.Amount - fngetNonGrossAmount(PrEmpTrans."Employee Code", PrEmpTrans."Period Month", PrEmpTrans."Period Year", PrEmpTrans."Payroll Period");
            if PrEmpTrans."No. Of Units" <> 0 then
                TransAmount := prEmpTrans."No. Of Units";
        end;
        if TransAmount = 0 then begin

            PrPeriodTrans.Reset();
            PrPeriodTrans.SetRange("Employee Code", strEmpCode);
            PrPeriodTrans.SetRange("Transaction Code", strTransCode);
            PrPeriodTrans.SetRange("Period Month", intMonth);
            PrPeriodTrans.SetRange("Period Year", intYear);
            if PrPeriodTrans.FindFirst() then begin
                TransAmount := PrPeriodTrans.Amount - fngetNonGrossAmount(PrPeriodTrans."Employee Code", PrPeriodTrans."Period Month", PrPeriodTrans."Period Year", PrPeriodTrans."Payroll Period");
            end
        end;

    end;

    procedure fnFormulaResult(strFormula: Text[250]) Results: Decimal
    var
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin
        Results := AccSchedMgt.EvaluateExpression(true, strFormula, AccSchedLine, ColumnLayout, CalcAddCurr);
    end;

    local procedure fnGetSpecialHseLevyAmt(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; intSpecTransID: Enum PayrollSpecialTransaction; SpecialTransAmt: Decimal; var HseLevy: decimal; var HseLevyRelief: Decimal)
    var
        PrEmployeeTransactions: Record "Pr Employee Transaction";
        PrTransactionCodes: Record "Pr Transaction Code";
        strExtractedFrml: Text[250];
        FormulaPerc: Decimal;

    begin
        fnInitialize();

        prTransactionCodes.Reset();
        PrTransactionCodes.SetRange(Suspended, false);
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions", intSpecTransID);
        if prTransactionCodes.FindSet() then begin
            repeat

                prEmployeeTransactions.Reset();
                prEmployeeTransactions.SetRange("Employee Code", strEmpCode);
                prEmployeeTransactions.SetRange("Period Month", intMonth);
                prEmployeeTransactions.SetRange("Period Year", intYear);
                prEmployeeTransactions.SetRange(Suspended, false);
                prEmployeeTransactions.SetRange("Transaction Code", prTransactionCodes.Code);
                if prEmployeeTransactions.FindFirst() then begin

                    case intSpecTransID of
                        intSpecTransID::"House Levy":
                            begin
                                if prTransactionCodes."Is Formula" then begin

                                    strExtractedFrml := '';
                                    strExtractedFrml := fnPureFormulaHseLevy(strEmpCode, intMonth, intYear, prTransactionCodes.Formula, getOpenPeriod());
                                    HseLevy := (fnFormulaResult(strExtractedFrml));
                                    HseLevyRelief := (HseLevy * (curHIFReliefPerc / 100))

                                end else begin

                                    HseLevy := prEmployeeTransactions.Amount;
                                    HseLevyRelief := (curHIFReliefPerc * HseLevy)
                                end;
                            end;
                    end;
                end;
            until prTransactionCodes.Next() = 0;
        end;

    end;

    local procedure fnGetSpecialTransAmount(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; intSpecTransID: Enum PayrollSpecialTransaction; blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        PrEmployeeTransactions: Record "Pr Employee Transaction";
        PrTransactionCodes: Record "Pr Transaction Code";
        strExtractedFrml: Text[250];
    begin

        SpecialTransAmount := 0;
        prTransactionCodes.Reset();
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions", intSpecTransID);
        if prTransactionCodes.FindSet() then begin
            repeat

                prEmployeeTransactions.Reset();
                prEmployeeTransactions.SetRange("Employee Code", strEmpCode);
                prEmployeeTransactions.SetRange("Period Month", intMonth);
                prEmployeeTransactions.SetRange("Period Year", intYear);
                prEmployeeTransactions.SetRange(Suspended, false);
                prEmployeeTransactions.SetRange("Transaction Code", prTransactionCodes.Code);
                if prEmployeeTransactions.FindFirst() then begin

                    case intSpecTransID of
                        intSpecTransID::"Defined Contribution":
                            begin

                                if prTransactionCodes."Is Formula" then begin
                                    strExtractedFrml := '';
                                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula, fnGetOpenPeriod());
                                    SpecialTransAmount := SpecialTransAmount + (fnFormulaResult(strExtractedFrml));
                                end else
                                    SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                            end;

                        intSpecTransID::"Life Insurance":
                            begin
                                SpecialTransAmount := SpecialTransAmount + ((curReliefInsurance / 100) * prEmployeeTransactions.Amount);
                            end;
                        intSpecTransID::"Owner Occupier Interest":
                            begin
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                            end;

                        intSpecTransID::"Home Ownership Savings Plan":
                            begin
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                            end;

                        intSpecTransID::Mortgage:
                            begin
                                SpecialTransAmount := SpecialTransAmount + curReliefMorgage;
                                if SpecialTransAmount > curReliefMorgage then begin
                                    SpecialTransAmount := curReliefMorgage
                                end;
                            end;
                        intSpecTransID::"House Levy":
                            begin

                                if prTransactionCodes."Is Formula" then begin
                                    strExtractedFrml := '';
                                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula, fnGetOpenPeriod());
                                    SpecialTransAmount := SpecialTransAmount + (fnFormulaResult(strExtractedFrml));

                                end else
                                    SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                            end;
                    end;
                end;
            until prTransactionCodes.Next() = 0;
        end;
        SpecialTranAmount := SpecialTransAmount;
    end;

    procedure fnClosePayrollPeriod(dtOpenPeriod: Date; PayrollCode: Code[20]) Closed: Boolean
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

        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod, 2);
        intNewYear := Date2DMY(dtNewPeriod, 3);
        intOldMonth := Date2DMY(dtOpenPeriod, 2);
        intOldYear := Date2DMY(dtOpenPeriod, 3);

        intMonth := Date2DMY(dtOpenPeriod, 2);
        intYear := Date2DMY(dtOpenPeriod, 3);

        PrEmployeeTrans.Reset();
        PrEmployeeTrans.SetRange("Period Month", intMonth);
        PrEmployeeTrans.SetRange("Period Year", intYear);
        if PrEmployeeTrans.FindSet() then begin
            repeat
                PrTransactionCodes.Reset();
                PrTransactionCodes.SetRange(Code, PrEmployeeTrans."Transaction Code");
                if PrTransactionCodes.FindFirst() then begin
                    case PrTransactionCodes."Balance Type" of

                        PrTransactionCodes."Balance Type"::" ":
                            begin

                                curTransAmount := prEmployeeTrans.Amount;
                                curTransBalance := 0;

                            end;
                        PrTransactionCodes."Balance Type"::Increasing:
                            begin

                                curTransAmount := prEmployeeTrans.Amount;
                                curTransBalance := (prEmployeeTrans.Balance + prEmployeeTrans.Amount);

                            end;
                        PrTransactionCodes."Balance Type"::Reducing:
                            begin

                                curTransAmount := prEmployeeTrans.Amount;
                                if prEmployeeTrans.Balance < prEmployeeTrans.Amount then begin
                                    curTransAmount := prEmployeeTrans.Balance;
                                    curTransBalance := 0;
                                end else begin
                                    curTransBalance := (prEmployeeTrans.Balance - prEmployeeTrans.Amount);
                                end;
                                if curTransBalance < 0 then begin
                                    curTransAmount := 0;
                                    curTransBalance := 0;
                                end;
                            end;
                    end;
                end;



                case PrTransactionCodes.Frequency of
                    PrTransactionCodes.Frequency::Fixed:
                        begin


                            if ((prTransactionCodes."Balance Type" = prTransactionCodes."Balance Type"::Reducing) and (curTransBalance <> 0))
                             or
                             (prTransactionCodes."Balance Type" <> prTransactionCodes."Balance Type"::Reducing) then
                                prEmployeeTrans.Balance := curTransBalance;
                            prEmployeeTrans.Modify(true);

                            PrEmployeeTransactions.Init();
                            PrEmployeeTransactions."Employee Code" := prEmployeeTrans."Employee Code";
                            PrEmployeeTransactions.Validate("Transaction Code", prEmployeeTrans."Transaction Code");
                            PrEmployeeTransactions."Transaction Name" := prEmployeeTrans."Transaction Name";
                            PrEmployeeTransactions.Amount := curTransAmount;
                            PrEmployeeTransactions.Balance := curTransBalance;
                            PrEmployeeTransactions."Amortized Loan Repayment" := prEmployeeTrans."Amortized Loan Repayment";
                            PrEmployeeTransactions."Original Amount" := prEmployeeTrans."Original Amount";
                            PrEmployeeTransactions.Membership := prEmployeeTrans.Membership;
                            PrEmployeeTransactions."Reference No." := prEmployeeTrans."Reference No.";
                            PrEmployeeTransactions."Loan No." := prEmployeeTrans."Loan No.";
                            PrEmployeeTransactions."Period Month" := intNewMonth;
                            PrEmployeeTransactions."Period Year" := intNewYear;
                            PrEmployeeTransactions."Payroll Period" := dtNewPeriod;
                            PrEmployeeTransactions."Member No." := PrEmployeeTrans."Member No.";
                            PrEmployeeTransactions."Account No." := PrEmployeeTrans."Account No.";
                            PrEmployeeTransactions."Account Type" := PrEmployeeTrans."Account Type";
                            PrEmployeeTransactions."Payroll Code" := PayrollCode;
                            PrEmployeeTransactions.Insert(true)

                        end;

                end;
            until PrEmployeeTrans.Next() = 0
        end;

        //Update the Period as Closed
        prPayrollPeriods.Reset();
        prPayrollPeriods.SetRange("Period Month", intMonth);
        prPayrollPeriods.SetRange("Period Year", intYear);
        prPayrollPeriods.SetRange(Closed, false);
        if prPayrollPeriods.FindFirst() then begin
            prPayrollPeriods.Closed := true;
            prPayrollPeriods."Date Closed" := Today;
            prPayrollPeriods.Modify(true);
        end;
        //Enter a New Period
        PrNewPayrollPeriods.Init();
        PrNewPayrollPeriods."Period Month" := intNewMonth;
        PrNewPayrollPeriods."Period Year" := intNewYear;
        PrNewPayrollPeriods."Period Name" := Format(dtNewPeriod, 0, '<Month Text>') + ' - ' + Format(intNewYear);
        PrNewPayrollPeriods."Date Opened" := dtNewPeriod;
        PrNewPayrollPeriods.Closed := false;
        PrNewPayrollPeriods."Payroll Code" := PayrollCode;
        PrNewPayrollPeriods.Insert(true);

        fnP9PeriodClosure(intMonth, intYear, dtOpenPeriod, PayrollCode);
        fnGetNegativePay(intMonth, intYear, dtOpenPeriod);

    end;

    local procedure fnP9PeriodClosure(intMonth: Integer; intYear: Integer; dtCurPeriod: Date; PayrollCode: Code[20])
    var
        P9EmployeeCode: Code[20];
        P9BasicPay: Decimal;
        P9Allowances: Decimal;
        P9Benefits: Decimal;
        P9ValueOfQuarters: Decimal;
        P9DefinedContribution: Decimal;
        P9OwnerOccupierInterest: Decimal;
        P9GrossPay: Decimal;
        P9TaxablePay: Decimal;
        P9TaxCharged: Decimal;
        P9InsuranceRelief: Decimal;
        P9TaxRelief: Decimal;
        P9Paye: Decimal;
        P9NSSF: Decimal;
        P9NHIF: Decimal;
        P9Deductions: Decimal;
        P9NetPay: Decimal;
        prPeriodTransactions: Record "Pr Period Transaction";
        prEmployee: Record "HR Employees";
    begin

        P9BasicPay := 0;
        P9Allowances := 0;
        P9Benefits := 0;
        P9ValueOfQuarters := 0;
        P9DefinedContribution := 0;
        P9OwnerOccupierInterest := 0;
        P9GrossPay := 0;
        P9TaxablePay := 0;
        P9TaxCharged := 0;
        P9InsuranceRelief := 0;
        P9TaxRelief := 0;
        P9Paye := 0;
        P9NSSF := 0;
        P9NHIF := 0;
        P9Deductions := 0;
        P9NetPay := 0;

        prEmployee.Reset();
        prEmployee.SetRange(Status, prEmployee.Status::Active);
        if prEmployee.FindSet() then begin
            repeat

                P9BasicPay := 0;
                P9Allowances := 0;
                P9Benefits := 0;
                P9ValueOfQuarters := 0;
                P9DefinedContribution := 0;
                P9OwnerOccupierInterest := 0;
                P9GrossPay := 0;
                P9TaxablePay := 0;
                P9TaxCharged := 0;
                P9InsuranceRelief := 0;
                P9TaxRelief := 0;
                P9Paye := 0;
                P9NSSF := 0;
                P9NHIF := 0;
                P9Deductions := 0;
                P9NetPay := 0;

                prPeriodTransactions.Reset();
                prPeriodTransactions.SetRange("Period Month", intMonth);
                prPeriodTransactions.SetRange("Period Year", intYear);
                prPeriodTransactions.SetRange("Employee Code", prEmployee."No.");
                if prPeriodTransactions.FindSet() then begin
                    repeat
                        case prPeriodTransactions."Group Order" of
                            1:
                                begin
                                    if prPeriodTransactions."Sub Group Order" = 1 then P9BasicPay := prPeriodTransactions.Amount;
                                    if prPeriodTransactions."Sub Group Order" = 2 then P9BasicPay := P9BasicPay + prPeriodTransactions.Amount;
                                end;
                            3:
                                begin
                                    P9Allowances := P9Allowances + prPeriodTransactions.Amount
                                end;
                            4:
                                begin
                                    P9GrossPay := prPeriodTransactions.Amount
                                end;
                            6:
                                begin
                                    if prPeriodTransactions."Sub Group Order" = 1 then P9DefinedContribution := prPeriodTransactions.Amount;
                                    if prPeriodTransactions."Sub Group Order" = 9 then P9TaxRelief := prPeriodTransactions.Amount;
                                    if prPeriodTransactions."Sub Group Order" = 8 then P9InsuranceRelief := prPeriodTransactions.Amount;
                                    if prPeriodTransactions."Sub Group Order" = 6 then P9TaxablePay := prPeriodTransactions.Amount;
                                    if prPeriodTransactions."Sub Group Order" = 7 then P9TaxCharged := prPeriodTransactions.Amount;
                                end;
                            7:
                                begin
                                    IF prPeriodTransactions."Sub Group Order" = 1 then P9NSSF := prPeriodTransactions.Amount;
                                    IF prPeriodTransactions."Sub Group Order" = 2 then P9NHIF := prPeriodTransactions.Amount;
                                    IF prPeriodTransactions."Sub Group Order" = 3 then P9Paye := prPeriodTransactions.Amount;
                                    IF prPeriodTransactions."Sub Group Order" = 4 then P9Paye := P9Paye + prPeriodTransactions.Amount;
                                end;
                            8:
                                begin
                                    P9Deductions := P9Deductions + prPeriodTransactions.Amount;
                                end;
                            9:
                                begin
                                    P9NetPay := prPeriodTransactions.Amount;
                                end;
                        end;

                    until prPeriodTransactions.Next() = 0
                end;
                //Update the P9 Details
                if P9NetPay <> 0 then
                    fnUpdateP9Table(prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits,
                    P9ValueOfQuarters, P9DefinedContribution,
                        P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged,
                        P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
                        P9NHIF, P9Deductions, P9NetPay, dtCurPeriod, PayrollCode);

            until prEmployee.Next() = 0;
        end;

    end;

    local procedure fnGetNegativePay(intMonth: Integer; intYear: Integer; dtOpenPeriod: Date)
    var
        prPeriodTransactions: Record "Pr Period Transaction";
        prEmployeeTransactions: Record "Pr Employee Transaction";
        intNewMonth: Integer;
        intNewYear: Integer;
        dtNewPeriod: Date;
    begin

        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2DMY(dtNewPeriod, 2);
        intNewYear := Date2DMY(dtNewPeriod, 3);

        prPeriodTransactions.Reset();
        prPeriodTransactions.SetRange("Period Month", intMonth);
        prPeriodTransactions.SetRange("Period Year", intYear);
        prPeriodTransactions.SetRange("Group Order", 9);
        prPeriodTransactions.SetFilter(Amount, '<0');
        if prPeriodTransactions.FindFirst() then begin
            repeat

                prEmployeeTransactions.Init();

                prEmployeeTransactions."Employee Code" := prPeriodTransactions."Employee Code";
                prEmployeeTransactions."Transaction Code" := 'NEGP';
                prEmployeeTransactions."Transaction Name" := 'Negative Pay';
                prEmployeeTransactions.Amount := prPeriodTransactions.Amount;
                prEmployeeTransactions.Balance := 0;
                prEmployeeTransactions."Original Amount" := 0;
                prEmployeeTransactions."Period Month" := intNewMonth;
                prEmployeeTransactions."Period Year" := intNewYear;
                prEmployeeTransactions."Payroll Period" := dtNewPeriod;
                prEmployeeTransactions.Insert(true)
            until prPeriodTransactions.Next() = 0;
        end;
    end;

    local procedure fnUpdateP9Table(P9EmployeeCode: Code[20]; P9BasicPay: Decimal; P9Allowances: Decimal; P9Benefits: Decimal; P9ValueOfQuarters: Decimal; P9DefinedContribution: Decimal; P9OwnerOccupierInterest: Decimal; P9GrossPay: Decimal; P9TaxablePay: Decimal; P9TaxCharged: Decimal; P9InsuranceRelief: Decimal; P9TaxRelief: Decimal; P9Paye: Decimal; P9NSSF: Decimal; P9NHIF: Decimal; P9Deductions: Decimal; P9NetPay: Decimal; dtCurrPeriod: Date; prPayrollCode: Code[20])
    var
        PrEmployeeP9Info: Record "Pr Employee P9 Info";
        intYear: Integer;
        intMonth: Integer;
    begin

        intMonth := Date2DMY(dtCurrPeriod, 2);
        intYear := Date2DMY(dtCurrPeriod, 3);

        PrEmployeeP9Info.Reset();
        PrEmployeeP9Info.Init();

        PrEmployeeP9Info."Employee Code" := P9EmployeeCode;
        PrEmployeeP9Info."Basic Pay" := P9BasicPay;
        PrEmployeeP9Info.Allowances := P9Allowances;
        PrEmployeeP9Info.Benefits := P9Benefits;
        PrEmployeeP9Info."Value Of Quarters" := P9ValueOfQuarters;
        PrEmployeeP9Info."Defined Contribution" := P9DefinedContribution;
        PrEmployeeP9Info."Owner Occupier Interest" := P9OwnerOccupierInterest;
        PrEmployeeP9Info."Gross Pay" := P9GrossPay;
        PrEmployeeP9Info."Taxable Pay" := P9TaxablePay;
        PrEmployeeP9Info."Tax Charged" := P9TaxCharged;
        PrEmployeeP9Info."Insurance Relief" := P9InsuranceRelief;
        PrEmployeeP9Info."Tax Relief" := P9TaxRelief;
        PrEmployeeP9Info.PAYE := P9Paye;
        PrEmployeeP9Info.NSSF := P9NSSF;
        PrEmployeeP9Info.NHIF := P9NHIF;
        PrEmployeeP9Info.Deductions := P9Deductions;
        PrEmployeeP9Info."Net Pay" := P9NetPay;
        PrEmployeeP9Info."Period Month" := intMonth;
        PrEmployeeP9Info."Period Year" := intYear;
        PrEmployeeP9Info."Payroll Period" := dtCurrPeriod;
        PrEmployeeP9Info."Payroll Code" := prPayrollCode;
        PrEmployeeP9Info.Insert(true)
    end;

    local procedure fnUpdateSalaryArrears(EmployeeCode: Text[50]; TransCode: Text[50]; OrigStartDate: Date; EndDate: Date; SalaryArrears: Decimal; PayeArrears: Decimal; intMonth: Integer; intYear: Integer; Payperiod: Date)
    var
        FirstMonth: Boolean;
        ProratedBasic: Decimal;
        SalaryVariance: Decimal;
        PayeVariance: Decimal;
        SupposedTaxablePay: Decimal;
        SupposedTaxCharged: Decimal;
        SupposedPaye: Decimal;
        CurrentBasic: Decimal;
        StartDate: Date;
        PrSalaryArrears: Record "Pr Salary Arrears";
        PrSalaryArrear: Record "Pr Salary Arrears";
    begin
        PrSalaryArrears.Reset();
        PrSalaryArrears.SetRange("Employee Code", EmployeeCode);
        PrSalaryArrears.SetRange("Transaction Code", TransCode);
        PrSalaryArrears.SetRange("Period Month", intMonth);
        PrSalaryArrears.SetRange("Period Year", intYear);
        if not PrSalaryArrears.FindFirst() then begin

            PrSalaryArrear.Init();
            PrSalaryArrear."Employee Code" := EmployeeCode;
            PrSalaryArrear."Transaction Code" := TransCode;
            PrSalaryArrear."Start Date" := OrigStartDate;
            PrSalaryArrear."End Date" := EndDate;
            PrSalaryArrear."Salary Arrears" := SalaryArrears;
            PrSalaryArrear."PAYE Arrears" := PayeArrears;
            PrSalaryArrear."Period Month" := intMonth;
            PrSalaryArrear."Period Year" := intYear;
            PrSalaryArrear."Payroll Period" := payperiod;

            PrSalaryArrear.Insert(true)
        end;

    end;

    local procedure fnSalaryArrears(EmpCode: Text[30]; TransCode: Text[30]; CBasic: Decimal; StartDate: Date; EndDate: Date; dtOpenPeriod: Date; dtDOE: Date; dtTermination: Date)
    var
        FirstMonth: Boolean;
        startmonth: Integer;
        startYear: Integer;
        PrEmployeeP9Info: Record "Pr Employee P9 Info";
        P9BasicPay: Decimal;
        P9taxablePay: Decimal;
        P9PAYE: Decimal;
        ProratedBasic: Decimal;
        SalaryArrears: Decimal;
        SalaryVariance: Decimal;
        SupposedTaxablePay: Decimal;
        SupposedTaxCharged: Decimal;
        SupposedPAYE: Decimal;
        PAYEVariance: Decimal;
        PAYEArrears: Decimal;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;

    begin

        fnInitialize;
        FirstMonth := true;

        IF EndDate > StartDate then begin
            while StartDate < EndDate DO begin

                //fnGetEmpP9Info
                startmonth := DATE2DMY(StartDate, 2);
                startYear := DATE2DMY(StartDate, 3);

                PrEmployeeP9Info.Reset();
                PrEmployeeP9Info.SetRange(PrEmployeeP9Info."Employee Code", EmpCode);
                PrEmployeeP9Info.SetRange(PrEmployeeP9Info."Period Month", startmonth);
                PrEmployeeP9Info.SetRange(PrEmployeeP9Info."Period Year", startYear);
                if PrEmployeeP9Info.FindFirst() then begin
                    P9BasicPay := PrEmployeeP9Info."Basic Pay";
                    P9taxablePay := PrEmployeeP9Info."Taxable Pay";
                    P9PAYE := PrEmployeeP9Info.PAYE;

                    if P9BasicPay > 0 then begin
                        if FirstMonth then begin
                            if DATE2DMY(StartDate, 1) <> 1 then begin

                                IF (DATE2DMY(dtDOE, 2) = DATE2DMY(StartDate, 2)) AND (DATE2DMY(dtDOE, 3) = DATE2DMY(StartDate, 3)) then begin
                                    CountDaysofMonth := fnDaysInMonth(dtDOE);
                                    DaysWorked := fnDaysWorked(dtDOE, false);
                                    ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay, DaysWorked, CountDaysofMonth)
                                end;

                                if dtTermination <> 0D then begin
                                    if (DATE2DMY(dtTermination, 2) = DATE2DMY(StartDate, 2)) and (DATE2DMY(dtTermination, 3) = DATE2DMY(StartDate, 3)) THEN BEGIN
                                        CountDaysofMonth := fnDaysInMonth(dtTermination);
                                        DaysWorked := fnDaysWorked(dtTermination, TRUE);
                                        ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay, DaysWorked, CountDaysofMonth)
                                    END;
                                END;

                                SalaryArrears := (CBasic - ProratedBasic)
                            END
                            ELSE BEGIN
                                SalaryArrears := (CBasic - P9BasicPay);
                            END;
                        END;
                        SalaryVariance := SalaryVariance + SalaryArrears;
                        SupposedTaxablePay := P9taxablePay + SalaryArrears;

                        IF SupposedTaxablePay > P9taxablePay THEN BEGIN
                            SupposedTaxCharged := fnGetEmployeePaye(SupposedTaxablePay);
                            SupposedPAYE := SupposedTaxCharged - curReliefPersonal;
                            PAYEVariance := SupposedPAYE - P9PAYE;
                            PAYEArrears := PAYEArrears + PAYEVariance;
                        END;
                        FirstMonth := false;
                    END;
                END;
                StartDate := CALCDATE('+1M', StartDate);
            END;
            IF SalaryArrears <> 0 THEN BEGIN
                PeriodYear := DATE2DMY(dtOpenPeriod, 3);
                PeriodMonth := DATE2DMY(dtOpenPeriod, 2);
                fnUpdateSalaryArrears(EmpCode, TransCode, StartDate, EndDate, SalaryArrears,
                PAYEArrears, PeriodMonth, PeriodYear, dtOpenPeriod);
            END
        END
        ELSE
            Error('The start date must be earlier than the end date');

    end;

    local procedure fnCalcLoanInterest(strEmpCode: Code[20]; strTransCode: Code[20]; InterestRate: Decimal; RecoveryMethod: Enum InterestCalculationMethod; LoanAmount: Decimal; Balance: Decimal; CurrPeriod: Date; Welfare: Boolean) LnInterest: Decimal
    var
        curLoanInt: Decimal;
        intMonth: Integer;
        intYear: Integer;
    begin

        intMonth := DATE2DMY(CurrPeriod, 2);
        intYear := DATE2DMY(CurrPeriod, 3);
        curLoanInt := 0;
        if InterestRate > 0 then begin
            case RecoveryMethod of
                RecoveryMethod::"Straight Line":
                    begin
                        curLoanInt := (InterestRate / 1200) * LoanAmount;
                    end else begin
                    curLoanInt := (InterestRate / 1200) * Balance;
                end;
            end;
        end else begin
            curLoanInt := 0;
        end;
    end;

    local procedure fnUpdateEmployerDeductions(EmpCode: Code[20]; TCode: Code[20]; TGroup: Code[20]; GroupOrder: Integer; SubGroupOrder: Integer; Description: Text[50]; curAmount: Decimal; curBalance: Decimal; Month: Integer; Year: Integer; Membership: Text[30]; Reference: Text[30]; dtOpenPeriod: Date)
    var
        prEmployerDeductions: Record "Pr Employer Deduction";

    begin
        if curAmount = 0 then exit;

        prEmployerDeductions.Init();
        prEmployerDeductions."Employee Code" := EmpCode;
        prEmployerDeductions."Transaction Code" := TCode;
        prEmployerDeductions.Amount := curAmount;
        prEmployerDeductions."Period Month" := Month;
        prEmployerDeductions."Period Year" := Year;
        prEmployerDeductions."Payroll Period" := dtOpenPeriod;
        prEmployerDeductions.Insert(true)

    end;

    local procedure fnDisplayFrmlValues(EmpCode: Code[30]; intMonth: Integer; intYear: Integer; Formula: Text[50]) curTransAmount: Decimal
    var
        pureformula: Text[50];
    begin

        pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula, fnGetOpenPeriod());
        curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount

    end;

    local procedure fnUpdateEmployeeTrans(EmpCode: Code[20]; TransCode: Code[20]; Amount: Decimal; Month: Integer; Year: Integer; PayrollPeriod: Date)
    var
        prEmployeeTrans: Record "Pr Employee Transaction";
    begin
        prEmployeeTrans.Reset();
        prEmployeeTrans.Setrange("Employee Code", EmpCode);
        prEmployeeTrans.Setrange("Transaction Code", TransCode);
        prEmployeeTrans.Setrange("Payroll Period", PayrollPeriod);
        prEmployeeTrans.Setrange("Period Month", Month);
        prEmployeeTrans.Setrange("Period Year", Year);
        if prEmployeeTrans.FindFirst() then begin
            prEmployeeTrans.Amount := Amount;
            prEmployeeTrans.Modify(true)

        end;
    end;

    procedure fnGetJournalDet(strEmpCode: Code[100])
    var
        SalaryCard: Record "HR Employees";
    begin
        if SalaryCard.Get(strEmpCode) then begin
            if PostingGroup.Get(SalaryCard."Posting Group") then begin
                PostingGroup.TestField("Salary Account");
                PostingGroup.TestField("Income Tax Account");
                PostingGroup.TestField("Net Salary Payable");
                PostingGroup.TestField("SSF Employer Account");
                PostingGroup.TestField("Pension Employer A/c");

                TaxAccount := PostingGroup."Income Tax Account";
                salariesAcc := PostingGroup."Salary Account";
                PayablesAcc := PostingGroup."Net Salary Payable";
                NSSFEMPyer := PostingGroup."SSF Employer Account";
                NSSFEMPyee := PostingGroup."SSF Employee Account";
                NHIFEMPyee := PostingGroup."NHIF Employee A/c";
                PensionEmpyer := PostingGroup."Pension Employer A/c";

            end else begin
                Error('Please specify Posting Group in Employee No.  ' + strEmpCode);
            end
        end

    end;

    local procedure fnCheckPaysPension(pnEmpCode: Code[20]; pnPayperiod: Date) PaysPens: Boolean
    var
        pnTranCode: Record "Pr Transaction Code";
        pnEmpTrans: Record "Pr Employee Transaction";
    begin
        PaysPens := false;
        PnEmpTrans.Reset();
        PnEmpTrans.SetRange("Employee Code", pnEmpCode);
        PnEmpTrans.SetRange("Payroll Period", pnPayperiod);
        if PnEmpTrans.FindFirst() then begin
            repeat
                if PnTranCode.Get(PnEmpTrans."Transaction Code") then
                    if PnTranCode."Coop Parameter" = PnTranCode."Coop Parameter"::Pension then
                        PaysPens := true;
            until PnEmpTrans.Next() = 0;
        end;
    end;

    local procedure fnemployeeNssfTier(curBaseAmount: Decimal; var Tier1: Decimal; var Tier2: Decimal)
    var
        PrNSSF: Record "Pr NSSF Tier";
        TierAmt: array[7] of Decimal;
    begin

        TierAmt[1] := 0;
        TierAmt[2] := 0;
        TierAmt[3] := 0;
        TierAmt[4] := 0;
        TierAmt[3] := 9000;

        case curBaseAmount of
            0 .. 9000:
                begin
                    TierAmt[1] := Round((curBaseAmount * 6 / 100), 0.5, '>');
                    TierAmt[4] := TierAmt[1] + TierAmt[2];
                    Tier1 := TierAmt[1];
                end;
            9001 .. 9999999:
                begin
                    TierAmt[1] := Round((TierAmt[3] * (6 / 100)), 0.5, '>');
                    TierAmt[2] := Round(((curBaseAmount - TierAmt[3]) * (6 / 100)), 0.5, '>');

                    if TierAmt[2] >= 5940 then
                        TierAmt[2] := 5940;
                    TierAmt[4] := TierAmt[1] + TierAmt[2];
                    Tier1 := TierAmt[1];
                    Tier2 := TierAmt[2];
                end;
        end;
    end;


    /* local procedure fnGetEmployerNSSF(curBaseAmount: Decimal): Decimal
    var
        PrNSSF: Record "Pr NSSF Tier";
        TierAmt: array[7] of Decimal;
    begin
        TierAmt[1] := 0;
        TierAmt[2] := 0;
        TierAmt[3] := 0;
        TierAmt[4] := 0;
        TierAmt[3] := 8000;

        case curBaseAmount of
            0 .. 8000:
                begin
                    TierAmt[1] := Round((curBaseAmount * 6 / 100), 0.5, '>');
                    TierAmt[2] := 0;
                    TierAmt[4] := TierAmt[1] + TierAmt[2]
                end;
            8001 .. 9999999:
                begin
                    TierAmt[1] := Round((TierAmt[3] * (6 / 100)), 0.5, '>');
                    TierAmt[2] := Round(((curBaseAmount - TierAmt[3]) * (6 / 100)), 0.5, '>');

                    if TierAmt[2] >= 3840 then
                        TierAmt[2] := 3840;
                    TierAmt[4] := TierAmt[1] + TierAmt[2]
                end;
        end;
        exit(TierAmt[4])
    end */

    local procedure fnGetSpecialTransAmountOnVolutaryContrib(strEmpCode: Code[20]; intMonth: Integer; intYear: Integer; intSpecTransID: Enum PayrollSpecialTransaction; blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        PrEmployeeTransactions: Record "Pr Employee Transaction";
        prTransactionCodes: Record "Pr Transaction Code";
        strExtractedFrml: Text[250];
    begin

        SpecialTransAmount := 0;
        prTransactionCodes.Reset();
        prTransactionCodes.SetRange("Voluntary Deduction", true);

        prTransactionCodes.SetRange("Special Transactions", intSpecTransID);
        if prTransactionCodes.FindFirst() then begin
            repeat
                prEmployeeTransactions.Reset();
                prEmployeeTransactions.SetRange("Employee Code", strEmpCode);
                prEmployeeTransactions.SetRange("Transaction Code", prTransactionCodes.Code);
                prEmployeeTransactions.SetRange("Period Month", intMonth);
                prEmployeeTransactions.SetRange("Period Year", intYear);
                prEmployeeTransactions.SetRange(Suspended, false);
                if prEmployeeTransactions.FindFirst() then begin
                    case intSpecTransID of
                        intSpecTransID::"Defined Contribution":

                            if prTransactionCodes."Is Formula" then begin
                                strExtractedFrml := '';
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula, fnGetOpenPeriod());
                                SpecialTransAmount := SpecialTransAmount + (fnFormulaResult(strExtractedFrml));
                            end else
                                SpecialTransAmount := SpecialTransAmount + prEmployeeTransactions.Amount;
                    end
                end;
            until prTransactionCodes.NEXT = 0;
        end;
        SpecialTranAmount := SpecialTransAmount;
    end;

    procedure fnProcesspayroll(strEmpCode: Code[20]; dtDOE: Date; curBasicPay: Decimal; blnPaysPaye: Boolean; blnPaysNssf: Boolean; blnPaysNhif: Boolean; SelectedPeriod: Date; dtOpenPeriod: Date; Membership: Text[30]; ReferenceNo: Text[30]; dtTermination: Date; blnGetsPAYERelief: Boolean; Dept: Code[20]; PayrollCode: Code[20]; ShortDim1: Code[50]; ShortDim2: Code[50]; PreviewPayslip: Boolean)
    var
        strTableName: Text[50];
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        strTransDescription: Text[50];
        TGroup: Text[30];
        TGroupOrder: Integer;
        TSubGroupOrder: Integer;
        curSalaryArrears: Decimal;
        curPayeArrears: Decimal;
        curGrossPay: Decimal;
        curTotAllowances: Decimal;
        curExcessPension: Decimal;
        curNSSF: Decimal;
        curDefinedContrib: Decimal;
        curPensionStaff: Decimal;
        curNonTaxable: Decimal;
        curGrossTaxable: Decimal;
        curBenefits: Decimal;
        curValueOfQuarters: Decimal;
        curUnusedRelief: Decimal;
        curInsuranceReliefAmount: Decimal;
        curMorgageReliefAmount: Decimal;
        curTaxablePay: Decimal;
        curTaxCharged: Decimal;
        curPAYE: Decimal;
        PrPeriodTransactions: Record "Pr Period Transaction";
        intYear: Integer;
        intMonth: Integer;
        LeapYear: Boolean;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
        prSalaryArrears: Record "Pr Salary Arrears";
        PrEmployeeTransactions: Record "Pr Employee Transaction";
        PrTransactionCodes: Record "Pr Transaction Code";
        strExtractedFrml: Text[250];
        SpecialTransType: Enum PayrollSpecialTransaction;
        TransacType: Enum PayrollTransType;
        curPensionCompany: Decimal;
        curTaxOnExcessPension: Decimal;
        prUnusedRelief: Record "Pr Unused Relief";
        curNhifBaseAmount: Decimal;
        curNHIF: Decimal;
        curTotalDeductions: Decimal;
        curNetRndEffect: Decimal;
        curNetPay: Decimal;
        curTotCompanyDed: Decimal;
        curOOI: Decimal;
        curHOSP: Decimal;
        curLoanInt: Decimal;
        strTransCode: Text[250];
        fnCalcFringeBenefit: Decimal;
        prEmployerDeductions: Record "Pr Employer Deduction";
        JournalPostingType: Enum "Gen. Journal Account Type";
        JournalAcc: Code[20];
        Customer: Record Customer;
        JournalPostAs: Enum PayrollPostAs;
        IsCashBenefit: Decimal;
        curNssfBaseAmount: Decimal;
        vend: Record Vendor;

    begin
        HrSetup.Get();
        fnInitialize;
        dtOpenPeriod := fnGetOpenPeriod();
        fnGetJournalDet(strEmpCode);

        if SelectedPeriod <> dtOpenPeriod then exit;
        intMonth := Date2DMY(SelectedPeriod, 2);
        intYear := Date2DMY(SelectedPeriod, 3);
        fnClearExistsEntry(strEmpCode, dtOpenPeriod);

        if curBasicPay > 0 then begin

            //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
            IF (DATE2DMY(dtDOE, 2) = DATE2DMY(dtOpenPeriod, 2)) AND (DATE2DMY(dtDOE, 3) = DATE2DMY(dtOpenPeriod, 3)) THEN BEGIN
                CountDaysofMonth := fnDaysInMonth(dtDOE);
                DaysWorked := fnDaysWorked(dtDOE, FALSE);
                curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth)
            END;

            //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
            if dtTermination <> 0D then begin
                IF (DATE2DMY(dtTermination, 2) = DATE2DMY(dtOpenPeriod, 2)) AND (DATE2DMY(dtTermination, 3) = DATE2DMY(dtOpenPeriod, 3)) THEN BEGIN
                    CountDaysofMonth := fnDaysInMonth(dtTermination);
                    DaysWorked := fnDaysWorked(dtTermination, true);
                    curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay, DaysWorked, CountDaysofMonth)
                end;
            end;

            empsalCard.Get(strEmpCode);
            if empsalCard."Suspend Half Pay" then
                curBasicPay := curBasicPay / 2;

            curTransAmount := curBasicPay;
            strTransDescription := 'Basic Pay';
            TGroup := '-------';
            TGroupOrder := 1;
            TSubGroupOrder := 1;
            salariesAcc := PostingGroup."Salary Account";
            fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth, intYear,
            Membership, ReferenceNo, SelectedPeriod, Dept, salariesAcc, JournalPostAs::Debit, JournalPostingType::"G/L Account",
            Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Basic Pay", Enum::"LoanTransactionType"::" ");

            prSalaryArrears.RESET;
            prSalaryArrears.SETRANGE(prSalaryArrears."Employee Code", strEmpCode);
            prSalaryArrears.SETRANGE(prSalaryArrears."Period Month", intMonth);
            prSalaryArrears.SETRANGE(prSalaryArrears."Period Year", intYear);
            IF prSalaryArrears.FindFirst() then begin
                REPEAT
                    curSalaryArrears := prSalaryArrears."Salary Arrears";
                    curPayeArrears := prSalaryArrears."PAYE Arrears";
                    curTransAmount := curSalaryArrears;
                    strTransDescription := 'Salary Arrears';
                    TGroup := 'ARREARS';
                    TGroupOrder := 1;
                    TSubGroupOrder := 2;
                    salariesAcc := PostingGroup."Salary Account";
                    fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code",
                     TGroup, TGroupOrder, TSubGroupOrder,
                      strTransDescription, curTransAmount, 0, intMonth, intYear, Membership,
                      ReferenceNo, SelectedPeriod, Dept, salariesAcc,
                      JournalPostAs::Debit, JournalPostingType::"G/L Account", Dim1, Dim2, '',
                      CoopParameters::" ", StatutCategory::Arrears, Enum::"LoanTransactionType"::" ");

                    curTransAmount := curPayeArrears;
                    strTransDescription := 'P.A.Y.E Arrears';
                    TGroup := '-------';
                    TGroupOrder := 7;
                    TSubGroupOrder := 4;
                    TaxAccount := PostingGroup."Income Tax Account";
                    fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
                       strTransDescription, curTransAmount, 0, intMonth, intYear, Membership,
                       ReferenceNo, SelectedPeriod, Dept,
                       TaxAccount, JournalPostAs::Debit, JournalPostingType::"G/L Account",
                       Dim1, Dim2, '', CoopParameters::" ", StatutCategory::Arrears, Enum::"LoanTransactionType"::" ")

                UNTIL prSalaryArrears.NEXT = 0;
            END;

            PrEmployeeTransactions.Reset();
            PrEmployeeTransactions.SetRange(PrEmployeeTransactions."Employee Code", strEmpCode);
            PrEmployeeTransactions.SetRange(PrEmployeeTransactions."Period Month", intMonth);
            PrEmployeeTransactions.SetRange(PrEmployeeTransactions."Period Year", intYear);
            if PrEmployeeTransactions.FindFirst() then begin
                curTotAllowances := 0;
                repeat

                    PrTransactionCodes.Reset();
                    PrTransactionCodes.SetRange(Code, PrEmployeeTransactions."Transaction Code");
                    PrTransactionCodes.SetRange(PrTransactionCodes."Transaction Type", PrTransactionCodes."Transaction Type"::Income);
                    if PrTransactionCodes.FindFirst() then begin
                        curTransAmount := 0;
                        curTransBalance := 0;
                        strTransDescription := '';
                        strExtractedFrml := '';
                        IF PrTransactionCodes."Is Formula" THEN BEGIN
                            strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, PrTransactionCodes.Formula, fnGetOpenPeriod());
                            curTransAmount := fnFormulaResult(strExtractedFrml);
                            fnUpdateEmployeeTrans(strEmpCode, PrEmployeeTransactions."Transaction Code",
                            curTransAmount, PrEmployeeTransactions."Period Month",
                                                  PrEmployeeTransactions."Period Year",
                                                  PrEmployeeTransactions."Payroll Period");
                        END ELSE BEGIN
                            curTransAmount := PrEmployeeTransactions.Amount;
                        END;

                        IF PrTransactionCodes."Balance Type" = PrTransactionCodes."Balance Type"::" " THEN
                            curTransBalance := 0;
                        IF PrTransactionCodes."Balance Type" = PrTransactionCodes."Balance Type"::Increasing THEN
                            curTransBalance := PrEmployeeTransactions.Balance + curTransAmount;
                        IF PrTransactionCodes."Balance Type" = PrTransactionCodes."Balance Type"::Reducing THEN
                            curTransBalance := PrEmployeeTransactions.Balance - curTransAmount;

                        IF (DATE2DMY(dtDOE, 2) = DATE2DMY(dtOpenPeriod, 2)) AND (DATE2DMY(dtDOE, 3) = DATE2DMY(dtOpenPeriod, 3)) THEN BEGIN
                            CountDaysofMonth := fnDaysInMonth(dtDOE);
                            DaysWorked := fnDaysWorked(dtDOE, FALSE);
                            curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth)
                        END;

                        IF dtTermination <> 0D THEN BEGIN
                            IF (DATE2DMY(dtTermination, 2) = DATE2DMY(dtOpenPeriod, 2)) AND (DATE2DMY(dtTermination, 3) = DATE2DMY(dtOpenPeriod, 3)) THEN BEGIN
                                CountDaysofMonth := fnDaysInMonth(dtTermination);
                                DaysWorked := fnDaysWorked(dtTermination, TRUE);
                                curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount, DaysWorked, CountDaysofMonth)
                            END;
                        END;

                        IF (NOT PrTransactionCodes.Taxable) AND (PrTransactionCodes."Special Transactions" = PrTransactionCodes."Special Transactions"::Ignore) THEN
                            curNonTaxable := curNonTaxable + curTransAmount;

                        IF (NOT PrTransactionCodes.Taxable) AND (PrTransactionCodes."Special Transactions" <>
                        PrTransactionCodes."Special Transactions"::Ignore) THEN
                            curTransAmount := 0;

                        curTotAllowances := curTotAllowances + curTransAmount;
                        curTransAmount := curTransAmount;
                        curTransBalance := curTransBalance;
                        strTransDescription := PrTransactionCodes.Name;
                        TGroup := '-------';
                        TGroupOrder := 3;
                        TSubGroupOrder := 0;

                        //Get the posting Details
                        JournalAcc := '';

                        case PrTransactionCodes."Account Type" of
                            PrTransactionCodes."Account Type"::"G/L Account":
                                begin
                                    JournalAcc := PrTransactionCodes."Account No.";
                                    JournalPostingType := PrTransactionCodes."Account Type"
                                end;

                            PrTransactionCodes."Account Type"::Vendor:
                                begin
                                    vend.Reset();
                                    vend.SetRange("No.", strEmpCode);
                                    if vend.FindFirst() then begin
                                        JournalAcc := vend."No.";
                                        JournalPostingType := JournalPostingType::Vendor
                                    end;
                                end;
                            PrTransactionCodes."Account Type"::Customer:
                                begin
                                    Customer.Reset();
                                    Customer.SetRange("No.", strEmpCode);
                                    IF Customer.FindFirst() then begin
                                        JournalAcc := Customer."No.";
                                        JournalPostingType := JournalPostingType::Customer;
                                    end;
                                end;

                            PrTransactionCodes."Account Type"::Saving:
                                begin
                                    AccBanking.Reset();
                                    AccBanking.SetRange("Member No.", PrEmployeeTransactions."Member No.");
                                    AccBanking.SetRange("Product Type", PrTransactionCodes."Product Type");
                                    AccBanking.SetRange("Account Category", PrTransactionCodes."Account Category");
                                    if AccBanking.FindFirst() then begin
                                        JournalAcc := AccBanking."No.";
                                        JournalPostingType := JournalPostingType::Vendor;
                                    end;
                                end;
                            PrTransactionCodes."Account Type"::Credit:
                                begin

                                    AccountCredit.Reset();
                                    AccountCredit.SetRange("Member No.", PrEmployeeTransactions."Member No.");
                                    AccountCredit.SetRange("Product Type", PrTransactionCodes."Product Type");
                                    AccountCredit.SetRange("Account Category", PrTransactionCodes."Account Category");
                                    if AccountCredit.FindFirst() then begin
                                        JournalAcc := AccountCredit."No.";
                                        JournalPostingType := JournalPostingType::Customer;
                                    end;
                                end;
                            PrTransactionCodes."Account Type"::Loan:
                                begin

                                    Loan.Reset();
                                    Loan.SetFilter("Outstanding Balance", '>0');
                                    Loan.SetRange("Account No.", PrEmployeeTransactions."Member No.");
                                    Loan.SetRange("Product Type", PrTransactionCodes."Product Type");
                                    if Loan.FindFirst() then begin
                                        JournalAcc := Loan."Loan Account";
                                        JournalPostingType := JournalPostingType::Customer
                                    end;
                                end;
                        end;

                        //End posting Details

                        fnUpdatePeriodTrans(strEmpCode, PrTransactionCodes.Code, TGroup, TGroupOrder,
                        TSubGroupOrder, strTransDescription, curTransAmount, curTransBalance, intMonth,
                        intYear, PrEmployeeTransactions.Membership, PrEmployeeTransactions."Reference No.",
                        SelectedPeriod, Dept, JournalAcc, JournalPostAs::Debit, JournalPostingType, Dim1, Dim2, '',
                        CoopParameters::" ", StatutCategory::" ", Enum::"LoanTransactionType"::" ");

                    END;
                UNTIL PrEmployeeTransactions.NEXT = 0;
            END;

            CurNonTxbleGross := 0;
            curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears);

            CurNonTxbleGross := curGrossPay;

            curTransAmount := curGrossPay;
            strTransDescription := 'Gross Pay';
            TGroup := '-------';
            TGroupOrder := 4;
            TSubGroupOrder := 0;
            fnUpdatePeriodTrans(strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder,
            strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ",
             JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Gross Pay", Enum::"LoanTransactionType"::" ");

            curNssfBaseAmount := 0;
            NssfTier1 := 0;
            NssfTier2 := 0;

            if blnPaysNssf then begin
                if intNSSFBasedOn = intNSSFBasedOn::Gross then
                    curNssfBaseAmount := curGrossPay;
                if intNSSFBasedOn = intNSSFBasedOn::Basic then
                    curNssfBaseAmount := curBasicPay;

                fnemployeeNssfTier(curNssfBaseAmount, NssfTier1, NssfTier2);
                curNSSF := NssfTier1 + NssfTier2;

                curTransAmount := NssfTier1;
                strTransDescription := 'NSSF Tier 1';
                TGroup := 'DEDUCTIONS';
                TGroupOrder := 7;
                TSubGroupOrder := 1;
                NSSFEMPyee := PostingGroup."SSF Employee Account";

                fnUpdatePeriodTrans(strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                JournalPostAs::Credit, JournalPostingType::"G/L Account", Dim1, Dim2, '',
                CoopParameters::NSSF, StatutCategory::"Social Security", Enum::"LoanTransactionType"::" ");

                curTransAmount := NssfTier2;
                strTransDescription := 'NSSF Tier 2';
                TGroup := 'DEDUCTIONS';
                TGroupOrder := 7;
                TSubGroupOrder := 1;
                NSSFEMPyee := PostingGroup."SSF Employee Account";

                fnUpdatePeriodTrans(strEmpCode, 'NSSF2', TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                JournalPostAs::Credit, JournalPostingType::"G/L Account", Dim1, Dim2, '',
                CoopParameters::NSSF, StatutCategory::"Social Security", Enum::"LoanTransactionType"::" ");

                // Update Employer Deductions
                curTransAmount := curNSSF;
                fnUpdateEmployerDeductions(strEmpCode, 'NSSF', 'EMP', TGroupOrder, TSubGroupOrder, '',
                curTransAmount, 0, intMonth, intYear, PrEmployeeTransactions.Membership, PrEmployeeTransactions."Reference No.",
                SelectedPeriod);

                /* curDefinedContrib := curNSSF;
                curTransAmount := curDefinedContrib;
                strTransDescription := 'Defined Contributions';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 1;
 */
                curDefinedContrib := (NssfTier2 + NssfTier1);
                curTransAmount := NssfTier1;
                strTransDescription := 'NSSF Tier 1';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 1;

                fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                 '', JournalPostAs::" ", JournalPostingType::"G/L Account", Dim1, Dim2, '',
                 CoopParameters::" ", StatutCategory::"Defined Contribution", Enum::"LoanTransactionType"::" ");

                curTransAmount := NssfTier2;
                strTransDescription := 'NSSF Tier 2';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 1;

                fnUpdatePeriodTrans(strEmpCode, 'DEFCON2', TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                 '', JournalPostAs::" ", JournalPostingType::"G/L Account", Dim1, Dim2, '',
                 CoopParameters::" ", StatutCategory::"Defined Contribution", Enum::"LoanTransactionType"::" ");

                //Update Employer deductions
                fnUpdateEmployerDeductions(strEmpCode, 'NSSF2', 'EMP', TGroupOrder, TSubGroupOrder, '', curTransAmount, 0,
                intMonth, intYear, PrEmployeeTransactions.Membership, PrEmployeeTransactions."Reference No.",
                SelectedPeriod);

            end;

            curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;
            IF curGrossTaxable = 0 THEN curDefinedContrib := 0;

            IF blnGetsPAYERelief THEN BEGIN
                curReliefPersonal := curReliefPersonal + curUnusedRelief;
                curTransAmount := curReliefPersonal;
                strTransDescription := 'Personal Relief';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 9;
                fnUpdatePeriodTrans(strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                 curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '',
                 JournalPostAs::" ", JournalPostingType::"G/L Account"
                 , Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Tax Relief", Enum::"LoanTransactionType"::" ");
            end
            else
                curReliefPersonal := 0;
            curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Defined Contribution", false);
            if curPensionStaff > 0 then begin

                if curPensionStaff > curMaxPensionContrib then
                    curTransAmount := curMaxPensionContrib
                else
                    curTransAmount := curPensionStaff;

                strTransDescription := 'Pension Relief';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 2;
                fnUpdatePeriodTrans(strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::"G/L Account"
                , Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Tax Relief", Enum::"LoanTransactionType"::" ")
            end;

            if blnPaysNhif then begin
                curNhifBaseAmount := 0;

                case intNHIFBasedOn of
                    intNHIFBasedOn::Gross:
                        begin
                            curNhifBaseAmount := (curGrossPay - fngetNonGrossAmount(strEmpCode, intMonth, intYear, dtOpenPeriod));
                        end;
                    intNHIFBasedOn::Basic:
                        begin
                            curNhifBaseAmount := curBasicPay
                        end;
                end;

                curHIFRelief := 0;
                curHIFRelief := fnGetEmployeeNHIF(curNhifBaseAmount);
                curTransAmount := curHIFRelief;
                strTransDescription := 'S.H.I.F Relief';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 1;
                fnUpdatePeriodTrans(strEmpCode, 'NHIFR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                 curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::Credit,
                 JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Tax Relief", Enum::"LoanTransactionType"::" ");
            end;

            fnGetSpecialHseLevyAmt(strEmpCode, intMonth, intYear, SpecialTransType::"House Levy", curGrossPay, curHseLevy, curHouseRelief);

            if curHseLevy > 0 then begin
                curTransAmount := curHseLevy;
                strTransDescription := 'House Levy Relief';
                TGroup := 'TAX CALCULATIONS';
                TGroupOrder := 6;
                TSubGroupOrder := 1;
                fnUpdatePeriodTrans(strEmpCode, 'HSELVR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::"G/L Account"
                , Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Tax Relief", Enum::"LoanTransactionType"::" ")
            end;

            if blnPaysPaye then begin

                curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                SpecialTransType::"Life Insurance", false);
                if curInsuranceReliefAmount > 0 then begin
                    curTransAmount := curInsuranceReliefAmount;
                    strTransDescription := 'Insurance Relief';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 8;
                    fnUpdatePeriodTrans(strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '',
                    JournalPostAs::" ", JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Tax Relief", Enum::"LoanTransactionType"::" ");
                end;

                curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Owner Occupier Interest", false);
                if curOOI > 0 then begin

                    if curOOI <= curOOIMaxMonthlyContrb then
                        curTransAmount := curOOI
                    else
                        curTransAmount := curOOIMaxMonthlyContrb;

                    strTransDescription := 'Owner Occupier Interest';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 3;
                    fnUpdatePeriodTrans(strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '',
                    JournalPostAs::" ", JournalPostingType::"G/L Account", Dim1, Dim2, '',
                    CoopParameters::" ", StatutCategory::"Occupier Interest", Enum::"LoanTransactionType"::" ");
                end;

                //HOSP
                curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
                SpecialTransType::"Home Ownership Savings Plan", false);
                if curHOSP > 0 then begin
                    if curHOSP <= curReliefMorgage then
                        curTransAmount := curHOSP
                    else
                        curTransAmount := curReliefMorgage;

                    strTransDescription := 'Home Ownership Savings Plan';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 4;
                    fnUpdatePeriodTrans(strEmpCode, 'HOSP', TGroup, TGroupOrder,
                    TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '',
                    JournalPostAs::" ", JournalPostingType::"G/L Account"
                   , Dim1, Dim2, '', CoopParameters::" ", StatutCategory::" ", Enum::"LoanTransactionType"::" ");
                end;

                if curNonTaxable > 0 then begin
                    strTransDescription := 'Other Non-Taxable Benefits';
                    TGroup := 'TAX CALCULATIONS';
                    TGroupOrder := 6;
                    TSubGroupOrder := 5;
                    fnUpdatePeriodTrans(strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curNonTaxable, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::"G/L Account"
                    , Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Non-Taxable", Enum::"LoanTransactionType"::" ");
                end;
            end;

            curPensionCompany := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
            SpecialTransType::"Defined Contribution", true);

            VoluntContrib := fnGetSpecialTransAmountOnVolutaryContrib(strEmpCode, intMonth,
            intYear, SpecialTransType::"Defined Contribution", true);

            IF curPensionCompany > 0 THEN BEGIN
                curTransAmount := curPensionCompany;
                strTransDescription := 'Pension (Company)';
                curExcessPension := 0;

                IF curExcessPension > 0 THEN BEGIN
                    curTransAmount := (curExcessPension - VoluntContrib);

                    strTransDescription := 'Excess Pension';
                    TGroup := '-------';
                    TGroupOrder := 7;
                    TSubGroupOrder := 5;

                    fnUpdatePeriodTrans(strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder,
                    strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ",
                     JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Defined Contribution", Enum::"LoanTransactionType"::" ");

                    curTaxOnExcessPension := (curRateTaxExPension / 100) * (curExcessPension - VoluntContrib);
                    curTransAmount := 0;

                    IF curPensionStaff > curMaxPensionContrib THEN
                        TaxOnExcess := curTaxOnExcessPension ELSE
                        TaxOnExcess := 0;

                    strTransDescription := 'Tax on ExPension';
                    TGroup := '-------';
                    TGroupOrder := 7;
                    TSubGroupOrder := 6;

                    fnUpdatePeriodTrans(strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder,
                    strTransDescription, curTransAmount, 0,
                    intMonth, intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
                    JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Defined Contribution", Enum::"LoanTransactionType"::" ");
                END;
            END;

            ObjEmpL.Get(strEmpCode);
            if ObjEmpL.Disabled = ObjEmpL.Disabled::Yes then begin

                if curGrossTaxable >= CurMinTxblePwd then
                    curGrossTaxable := (curGrossTaxable - CurMinTxblePwd) else
                    curGrossTaxable := curGrossTaxable;
            end else begin
                curGrossTaxable := curGrossTaxable;
            end;

            if curPensionStaff > curMaxPensionContrib then
                curTaxablePay := curGrossTaxable - (curSalaryArrears + curDefinedContrib + curMaxPensionContrib + curOOI + curHOSP + curNonTaxable + curHseLevy + curHIFRelief)
            else
                curTaxablePay := curGrossTaxable - (curSalaryArrears + curDefinedContrib + curPensionStaff + curOOI + curHOSP + curNonTaxable + curHseLevy + curHIFRelief);

            curTransAmount := curTaxablePay;
            strTransDescription := 'Taxable Pay';
            TGroup := 'TAX CALCULATIONS';
            TGroupOrder := 6;
            TSubGroupOrder := 6;
            fnUpdatePeriodTrans(strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '',
             JournalPostAs::" ", JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Taxable Pay", Enum::"LoanTransactionType"::" ");

            HrEmployee.RESET;
            HrEmployee.SETRANGE(HrEmployee."No.", strEmpCode);
            if HrEmployee.FIND('-') then
                if HrEmployee."Payroll Type" = HrEmployee."Payroll Type"::"Seconded Staff"
                then
                    curTaxCharged := curTaxablePay * 0.3
                else
                    curTaxCharged := fnGetEmployeePaye(curTaxablePay);

            curTransAmount := curTaxCharged;
            strTransDescription := 'Tax Charged';
            TGroup := 'TAX CALCULATIONS';
            TGroupOrder := 6;
            TSubGroupOrder := 7;
            fnUpdatePeriodTrans(strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ",
            JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Tax Charged", Enum::"LoanTransactionType"::" ");

            if (curReliefPersonal + curInsuranceReliefAmount) > curMaximumRelief then
                curPAYE := curTaxCharged - curMaximumRelief
            else
                curPAYE := ROUND((curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount)));

            IF NOT blnPaysPaye THEN curPAYE := 0;
            curTransAmount := curPAYE;
            IF curPAYE < 0 THEN curTransAmount := 0;
            strTransDescription := 'P.A.Y.E';
            TaxAccount := PostingGroup."Income Tax Account";
            TGroup := '-------';
            TGroupOrder := 7;
            TSubGroupOrder := 3;
            fnUpdatePeriodTrans(strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, TaxAccount, JournalPostAs::Credit,
             JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::PAYE, Enum::"LoanTransactionType"::" ");


            if curPAYE < 0 then begin
                prUnusedRelief.RESET;
                prUnusedRelief.SETRANGE(prUnusedRelief."Employee Code", strEmpCode);
                prUnusedRelief.SETRANGE(prUnusedRelief."Period Month", intMonth);
                prUnusedRelief.SETRANGE(prUnusedRelief."Period Year", intYear);
                if prUnusedRelief.Find('-') then
                    prUnusedRelief.Delete();

                prUnusedRelief.Reset();
                prUnusedRelief.Init();
                prUnusedRelief."Employee Code" := strEmpCode;
                prUnusedRelief."Unused Relief" := curPAYE;
                prUnusedRelief."Period Month" := intMonth;
                prUnusedRelief."Period Year" := intYear;
                prUnusedRelief.Insert(true);

            end;

            curNhifBaseAmount := 0;

            IF intNHIFBasedOn = intNHIFBasedOn::Gross THEN
                curNhifBaseAmount := (curGrossPay - fngetNonGrossAmount(strEmpCode, intMonth, intYear, dtOpenPeriod));
            IF intNHIFBasedOn = intNHIFBasedOn::Basic THEN
                curNhifBaseAmount := curBasicPay;
            IF intNHIFBasedOn = intNHIFBasedOn::"Taxable Pay" THEN
                curNhifBaseAmount := curTaxablePay;

            if blnPaysNhif then begin

                curNHIF := 0;
                curNHIF := fnGetEmployeeNHIF(curNhifBaseAmount);
                curTransAmount := curNHIF;
                NHIFEMPyee := PostingGroup."NHIF Employee A/c";
                strTransDescription := 'S.H.I.F';
                TGroup := '-------';
                TGroupOrder := 7;
                TSubGroupOrder := 2;
                fnUpdatePeriodTrans(strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                 curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NHIFEMPyee, JournalPostAs::Credit,
                 JournalPostingType::"G/L Account", Dim1, Dim2, '', CoopParameters::NHIF, StatutCategory::"Hospital Insurance Fund", Enum::"LoanTransactionType"::" ");
            end;

            //End Earnings
            //Start Deductions

            prEmployeeTransactions.Reset();
            prEmployeeTransactions.SetRange("Employee Code", strEmpCode);
            prEmployeeTransactions.SetRange("Payroll Period", dtOpenPeriod);
            prEmployeeTransactions.SetRange(prEmployeeTransactions.Stopped, false);
            if prEmployeeTransactions.FindSet() then begin
                curTotalDeductions := 0;
                repeat
                    prTransactionCodes.Reset();
                    PrTransactionCodes.SetRange(Suspended, false);
                    prTransactionCodes.SetRange(prTransactionCodes.Code, prEmployeeTransactions."Transaction Code");
                    prTransactionCodes.SetRange(prTransactionCodes."Transaction Type", prTransactionCodes."Transaction Type"::Deduction);
                    if prTransactionCodes.FindFirst() then begin

                        curTransAmount := 0;
                        curTransBalance := 0;
                        strTransDescription := '';
                        strExtractedFrml := '';

                        if prTransactionCodes."Is Formula" then begin
                            if PrTransactionCodes."Coop Parameter" = PrTransactionCodes."Coop Parameter"::"House Levy" then begin
                                strExtractedFrml := fnPureFormulaHseLevy(strEmpCode, intMonth, intYear, prTransactionCodes.Formula, getOpenPeriod())
                            end else begin
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula, getOpenPeriod())
                            end;
                            curTransAmount := fnFormulaResult(strExtractedFrml);
                        end else begin
                            curTransAmount := prEmployeeTransactions.Amount;
                        end;

                        if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::"Life Insurance")
                          and (prTransactionCodes."Deduct Premium" = false) then begin
                            curTransAmount := 0;
                        end;

                        if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::Mortgage)
                         and (prTransactionCodes."Deduct Morgage" = false) then begin
                            curTransAmount := 0;
                        end;
                        if (prTransactionCodes."Special Transactions" = prTransactionCodes."Special Transactions"::Pension)
                         and (prTransactionCodes.Welfare = false) then begin
                            curTransAmount := 0;
                        end;
                        //Get the posting Details
                        JournalAcc := '';
                        case PrTransactionCodes."Account Type" of
                            PrTransactionCodes."Account Type"::"G/L Account":
                                begin
                                    JournalAcc := PrTransactionCodes."Account No.";
                                    JournalPostingType := PrTransactionCodes."Account Type"
                                end;

                            PrTransactionCodes."Account Type"::Vendor:
                                begin
                                    vend.Reset();
                                    vend.SetRange("No.", strEmpCode);
                                    if vend.FindFirst() then begin
                                        JournalAcc := vend."No.";
                                        JournalPostingType := JournalPostingType::Vendor
                                    end;
                                end;
                            PrTransactionCodes."Account Type"::Customer:
                                begin
                                    Customer.Reset();
                                    Customer.SetRange("No.", strEmpCode);
                                    IF Customer.FindFirst() then begin
                                        JournalAcc := Customer."No.";
                                        JournalPostingType := JournalPostingType::Customer;
                                    end;
                                end;
                        end;

                        case prTransactionCodes."Balance Type" OF
                            prTransactionCodes."Balance Type"::" ":
                                curTransBalance := 0;
                            prTransactionCodes."Balance Type"::Increasing:
                                begin
                                    if prTransactionCodes."Special Transactions" <> prTransactionCodes."Special Transactions"::"Defined Contribution"
                                    then begin
                                        curTransAmount := prEmployeeTransactions.Amount;
                                    end;
                                    curTransBalance := prEmployeeTransactions.Balance + curTransAmount;
                                end;

                            prTransactionCodes."Balance Type"::Reducing:
                                begin
                                    if prEmployeeTransactions.Balance < prEmployeeTransactions.Amount then begin
                                        curTransAmount := prEmployeeTransactions.Balance;
                                        curTransBalance := 0;
                                    end else begin
                                        curTransAmount := prEmployeeTransactions.Amount;
                                        curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                                    end;
                                    if curTransBalance < 0 then begin
                                        curTransAmount := 0;
                                        curTransBalance := 0;
                                    end
                                end
                        end;

                        curTotalDeductions := (curTotalDeductions + curTransAmount);
                        curTransAmount := (curTransAmount);
                        curTransBalance := curTransBalance;
                        strTransCode := prEmployeeTransactions."Transaction Code";
                        strTransDescription := prTransactionCodes.Name;
                        TGroup := 'DEDUCTION';
                        TGroupOrder := 8;
                        TSubGroupOrder := 0;

                        fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                          strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                          PrEmployeeTransactions.Membership, PrEmployeeTransactions."Reference No.",
                          SelectedPeriod, Dept, JournalAcc, JournalPostAs::Credit, JournalPostingType, Dim1, Dim2,
                          PrEmployeeTransactions."Loan No.", prTransactionCodes."Coop Parameter", StatutCategory::Deduction, Enum::"LoanTransactionType"::" ");

                        if prTransactionCodes."Fringe Benefit" then begin
                            if prTransactionCodes."Interest Rate" < curLoanMarketRate then begin
                                fnCalcFringeBenefit := (((curLoanMarketRate - prTransactionCodes."Interest Rate") * curLoanCorpRate) / 1200)
                                 * prEmployeeTransactions.Balance;
                            end;
                        end else begin
                            fnCalcFringeBenefit := 0;
                        end;

                        IF fnCalcFringeBenefit > 0 then begin
                            fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code" + '-FRG',
                             'EMP', TGroupOrder, TSubGroupOrder, 'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                              prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No.", SelectedPeriod)
                        end;
                        //End Fringe Benefits

                        if (prTransactionCodes."Employer Deduction") or (prTransactionCodes."Inc. Employer Deduction") then begin
                            if prTransactionCodes."Is Formula for employer" <> '' then begin
                                strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes."Is Formula for employer", getOpenPeriod());
                                curTransAmount := fnFormulaResult(strExtractedFrml);
                            end else begin
                                curTransAmount := prEmployeeTransactions."Employer Amount";
                            end;
                            if curTransAmount > 0 then
                                fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                                 'EMP', TGroupOrder, TSubGroupOrder, '', curTransAmount, 0, intMonth, intYear,
                                  prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No.", SelectedPeriod);

                            PRPeriodTrans.Reset();
                            PRPeriodTrans.SetRange("Employee Code", strEmpCode);
                            PRPeriodTrans.SetRange("Transaction Code", prEmployeeTransactions."Transaction Code");
                            PRPeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                            IF PRPeriodTrans.FindFirst() then begin
                                if PRPeriodTrans.Balance <> 0 then PRPeriodTrans.Balance += curTransAmount;
                                PRPeriodTrans.Modify(true);
                            end;
                        end;
                    end;
                until prEmployeeTransactions.Next() = 0;
            end;

            AccountContrib.Reset();
            AccountContrib.SetFilter(Type, '<>%1', AccountContrib.Type::Loan);
            AccountContrib.SetFilter("Advise Type", '<>%1', AccountContrib."Advise Type"::Stoppage);
            AccountContrib.SetRange("Account No.", fngetEmployeeMemberNo(strEmpCode));
            if AccountContrib.FindSet() then begin
                repeat
                    AccountContrib.TestField(Amount);

                    JournalAcc := AccountContrib."Application No.";
                    if Pfact.Get(AccountContrib."Product Type") then
                        curTransAmount := AccountContrib.Amount;
                    curTotalDeductions := curTotalDeductions + curTransAmount;
                    curTransBalance := 0;
                    strTransCode := 'D/UB-' + AccountContrib."Application No.";
                    strTransDescription := Format(AccountContrib.Type);
                    TGroup := '-------';
                    TGroupOrder := 8;
                    TSubGroupOrder := 1;

                    case Pfact."Account Dimension" of
                        Pfact."Account Dimension"::Credit,
                        Pfact."Account Dimension"::"Micro Credit":
                            begin
                                JournalPostingType := JournalPostingType::Credit;
                                AccountCredit.Get(AccountContrib."Application No.");
                                AccountCredit.CalcFields("Balance (LCY)");

                                case AccountCredit."Account Category" of
                                    AccountCredit."Account Category"::Other,
                                    AccountCredit."Account Category"::Insurance,
                                    AccountCredit."Account Category"::"Benevolent Fund",
                                    AccountCredit."Account Category"::"Registration Fee":
                                        begin
                                            curTransBalance := 0
                                        end
                                    else begin

                                        curTransBalance := Round((AccountCredit."Balance (LCY)"))
                                    end
                                end;
                            end;
                        Pfact."Account Dimension"::Banking:
                            begin
                                JournalPostingType := JournalPostingType::Saving;
                                AccBanking.Get(AccountContrib."Application No.");
                                AccBanking.CalcFields("Balance (LCY)");

                                curTransBalance := Round((AccBanking."Balance (LCY)"))
                            end;
                    end;

                    fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                    strTransDescription, curTransAmount, curTransBalance, intMonth, intYear, '',
                    AccountContrib."Account No.", SelectedPeriod, '', JournalAcc, JournalPostAs::Credit,
                    JournalPostingType, Dim1, Dim2, '', CoopParameters::Shares, StatutCategory::Deduction,
                    Enum::"LoanTransactionType"::" ");

                    PRPeriodTrans.Reset();
                    PRPeriodTrans.SetRange("Employee Code", strEmpCode);
                    PRPeriodTrans.SetRange("Transaction Code", strTransCode);
                    PRPeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                    IF PRPeriodTrans.FindFirst() then begin
                        if PRPeriodTrans.Balance <> 0 then PRPeriodTrans.Balance += curTransAmount;
                        PRPeriodTrans.Modify(true);
                    end;

                until AccountContrib.Next() = 0
            end;
            LoanLastIssuedate := CalcDate(checkoffcutoffDay, CalcDate('-CM', fnGetOpenPeriod()));
            Loan.Reset();
            Loan.SetFilter("Outstanding Balance", '>0');
            Loan.SetFilter("Disbursement Date", '< %1', LoanLastIssuedate);
            Loan.SetRange("Account No.", fngetEmployeeMemberNo(strEmpCode));
            if Loan.FindFirst() then begin
                repeat
                    Loan.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");

                    JournalAcc := Loan."Loan Account";
                    if Pfact.Get(Loan."Product Type") then
                        if Pfact."Deposits Appraisal Parameter" <> Pfact."Deposits Appraisal Parameter"::Business then begin

                            JournalPostingType := JournalPostingType::Loan;
                            if Loan."Outstanding Interest" > 0 then begin

                                curTransAmount := Loan."Outstanding Interest";
                                curTotalDeductions := curTotalDeductions + curTransAmount;
                                curTransBalance := 0;
                                strTransCode := Loan."No." + '-INT';
                                strTransDescription := Loan."Product Description" + ' -Interest';
                                TGroup := '-------';
                                TGroupOrder := 8;
                                TSubGroupOrder := 1;

                                fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                                strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                                '', Loan."Account No.", SelectedPeriod, Loan."Responsibility Centre", JournalAcc,
                                JournalPostAs::Credit, Enum::"Gen. Journal Account Type"::Loan, Dim1, Dim2,
                                Loan."No.", CoopParameters::"loan Interest", StatutCategory::Deduction,
                                Enum::"LoanTransactionType"::"Interest Paid");
                            end;

                            if Loan."Outstanding Principal" > 0 then begin
                                if Loan."Interest Calculation Method" = Loan."Interest Calculation Method"::Amortised then begin
                                    Loan.TestField(Repayment);
                                    curTransAmount := (Loan.Repayment - Loan."Outstanding Interest")
                                end else begin
                                    Loan.TestField("Principle Repayment");
                                    curTransAmount := Loan."Principle Repayment";
                                    if curTransAmount > Loan."Outstanding Principal" then
                                        curTransAmount := Loan."Outstanding Principal";
                                end;

                                curTotalDeductions := (curTotalDeductions + curTransAmount);
                                curTransBalance := 0;
                                strTransCode := Loan."No." + '-LOAN';
                                strTransDescription := Loan."Product Description" + ' -Principal';
                                TGroup := '-------';
                                TGroupOrder := 8;
                                TSubGroupOrder := 1;

                                fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                                strTransDescription, curTransAmount, Round((Loan."Outstanding Balance" - (curTransAmount + Loan."Outstanding Interest"))), intMonth, intYear,
                                '', Loan."Account No.", SelectedPeriod, Loan."Responsibility Centre", JournalAcc, JournalPostAs::Credit, Enum::"Gen. Journal Account Type"::Loan, Dim1, Dim2,
                                Loan."No.", CoopParameters::Loan, StatutCategory::Deduction, Enum::"LoanTransactionType"::Repayment);
                            end;
                        end
                until Loan.Next() = 0;
            end;

            if curPAYE < 0 then curPAYE := 0;
            curTotalDeductions := Round(curNSSF + curNHIF + curPAYE + curPayeArrears + curTotalDeductions);

            curTransBalance := 0;
            strTransCode := 'TOT-DED';
            strTransDescription := 'TOTAL DEDUCTION';
            TGroup := '-------';
            TGroupOrder := 8;
            TSubGroupOrder := 9;

            fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                      strTransDescription, curTotalDeductions, curTransBalance, intMonth, intYear,
                      PrEmployeeTransactions.Membership, PrEmployeeTransactions."Reference No.",
                      SelectedPeriod, Dept, '', JournalPostAs::Credit, JournalPostingType::"G/L Account", Dim1, Dim2,
                      '', CoopParameters::" ", StatutCategory::" ", Enum::"LoanTransactionType"::" ");

            curNetPay := curGrossPay - Round(curTotalDeductions, 0.05);
            curNetPay := Round(curNetPay);

            curNetPay := curNetPay - curTotCompanyDed;
            curNetRndEffect := curNetPay - Round(curNetPay, 1, '=');
            RoundDownDiff := 0;
            RoundUpDif := 0;
            curTransAmount := curNetPay;
            strTransDescription := 'Net Pay';
            PayablesAcc := '';

            case HrSetup."NetPay Post Options" of
                HrSetup."NetPay Post Options"::Vendor:
                    begin
                        HrEmployee.TestField("Member No.");
                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", HrEmployee."Member No.");
                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                        if AccBanking.FindFirst() then begin
                            PayingAccType := PayingAccType::Vendor;
                            PayablesAcc := AccBanking."No.";
                        end else begin
                            Error(ErronOnMissingBankingAc);
                        end;
                    end;
                HrSetup."NetPay Post Options"::"G/L Account":
                    begin
                        PayablesAcc := PostingGroup."Net Salary Payable";
                    end;
                HrSetup."NetPay Post Options"::Employee:
                    begin
                        EmployeeMgt.Get(strEmpCode);
                        PayingAccType := PayingAccType::Employee;
                        PayablesAcc := EmployeeMgt."No."
                    end;
            end;

            TGroup := '-------';
            TGroupOrder := 9;
            TSubGroupOrder := 0;
            fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
            curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, PayablesAcc, JournalPostAs::Credit,
            PrPeriodTransactions."Account Type"::"G/L Account", Dim1, Dim2, '', CoopParameters::" ", StatutCategory::"Net Pay", Enum::"LoanTransactionType"::" ");

            if PreviewPayslip then begin
                Commit();
                fnJournalPreviewMngt(Enum::CustomApprovalEntriesDocType::Salary, strEmpCode, '', '', SelectedPeriod, Enum::BCObjectTypes::Report);
            end;
        end;
    end;

    procedure CreateJnlEntries(AccountType: Enum "Gen. Journal Account Type"; SlipRcptNo: Code[20]; PostDate: Date; AccountNo: Code[20]; JTemplate: Code[10]; JBatch: Code[10]; GlobalDime1: Code[20]; GlobalDime2: Code[20]; Description: Text[150]; DebitAmount: Decimal; CreditAmount: Decimal; PostAs: Enum PayrollPostAs; LoanNo: Code[20]; TransType: Enum "LoanTransactionType"; EDocument: Code[20]; LineEntryNo: Integer)
    var
    begin
        LineNo := LineEntryNo + 1000;
        JnlPostMgt.CreateJnl(JTemplate, JBatch, LineNo, AccountType, SlipRcptNo, Description, CreditAmount,
        AccountNo, PostDate, AccountType::"G/L Account", '', EDocument, GlobalDime1, GlobalDime2, TransType, LoanNo, '', '',
        Enum::"Gen. Journal Document Type"::" ", '', Enum::"Gen. Journal Document Type"::" ", 'PAYROLL/' + Format(PostDate));

    end;

    procedure fnJournalPreviewMngt(Variantext: Enum CustomApprovalEntriesDocType; DocNo: Code[100]; RecJournalTemplate: Code[20]; RecJournalBatch: Code[20]; SelectedPeriod: Date; ObjectTypeTxt: Enum BCObjectTypes)
    var
        JournalLine: Record "Gen. Journal Line";
        HrEmployeeMgt: Record "Hr Employees";
    begin

        case Variantext of
            Variantext::Salary:
                begin
                    case ObjectTypeTxt of
                        ObjectTypeTxt::Report:
                            begin

                                HrEmployeeMgt.Reset();
                                HrEmployeeMgt.SetRange("No.", DocNo);
                                HrEmployeeMgt.SetRange("Current Month Filter", SelectedPeriod);
                                if HrEmployeeMgt.FindFirst() then begin
                                    Report.Run(Report::"PrPayroll Slip -New", true, false, HrEmployeeMgt)

                                end;
                                /* 
                                                                PrsalCard.Reset();
                                                                PrsalCard.SetRange("Employee Code", DocNo);
                                                                PrsalCard.SetRange("Period Filter", SelectedPeriod);
                                                                if PrsalCard.FindFirst() then begin
                                                                    //Report.Run(Report::"Pr Individual Payslip", true, false, PrsalCard);
                                                                    Report.Run(Report::"PrPayroll Slip -New", true, false, PrsalCard);
                                                                end; */
                            end;
                        ObjectTypeTxt::Page:
                            begin
                                JournalLine.Reset();
                                JournalLine.SetRange("Document No.", DocNo);
                                JournalLine.SetRange("Journal Batch Name", RecJournalBatch);
                                JournalLine.SetRange("Journal Template Name", RecJournalTemplate);
                                if JournalLine.Find('-') then
                                    Page.Run(Page::"General Journal", JournalLine, JournalLine."Document No.");
                            end;
                    end

                end;
        end;
    end;

    procedure fnconsolidatePayrollPostMgt(SelectedPeriod: Date)
    var
        PrPeriodConsd: Record "Pr Period Transaction- Consd.";
        PrTransCode: Record "Pr Transaction Code";
    begin

        PRPeriodTrans.Reset();
        PRPeriodTrans.SetRange("Payroll Period", SelectedPeriod);
        PRPeriodTrans.SetRange("Transaction Code", 'BPAY');
        if PRPeriodTrans.FindSet() then begin
            PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
            PrPeriodConsd.Init();
            PrPeriodConsd.CopyFromPeriodTransaction(PRPeriodTrans);
            PrPeriodConsd.Insert(true)
        end;

        PRPeriodTrans.Reset();
        PRPeriodTrans.SetRange("Payroll Period", SelectedPeriod);
        PRPeriodTrans.SetRange("Transaction Code", 'NPAY');
        if PRPeriodTrans.FindSet() then begin
            PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
            PrPeriodConsd.Init();
            PrPeriodConsd.CopyFromPeriodTransaction(PRPeriodTrans);
            PrPeriodConsd.Insert(true)
        end;

        PrTransCode.Reset();
        PrTransCode.SetRange(Suspended, false);
        if PrTransCode.Find('-') then begin
            repeat
                PRPeriodTrans.Reset();
                PRPeriodTrans.SetRange("Payroll Period", SelectedPeriod);
                PRPeriodTrans.SetRange("Transaction Code", PrTransCode.Code);
                PRPeriodTrans.SetRange("Account No.", PrTransCode."Account No.");
                if PRPeriodTrans.FindSet() then begin
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    PrPeriodConsd.Init();
                    PrPeriodConsd.CopyFromPeriodTransaction(PRPeriodTrans);
                    PrPeriodConsd.Insert(true)
                end;
            until PrTransCode.Next() = 0;
        end;
    end;

    procedure fngetEmployeeBasicPay(StrEmpCode: Code[100]): Decimal
    begin

        HrEmployee.SetRange("No.", StrEmpCode);
        HrEmployee.SetRange(Status, HrEmployee.Status::Active);
        if HrEmployee.FindFirst() then begin
            PrsalCard.Reset();
            PrsalCard.SetRange("Employee Code", HrEmployee."No.");
            if PrsalCard.FindFirst() then begin
                PrsalCard.TestField("Basic Pay");
                exit(PrsalCard."Basic Pay")
            end else
                exit(0)
        end;
        exit(0)
    end;

    var
        curReliefPersonal: Decimal;
        LineNo: Integer;
        Pfact: Record "Product Factory";
        curReliefInsurance: Decimal;
        curReliefMorgage: Decimal;
        curMaximumRelief: Decimal;
        LoanLastIssuedate: Date;
        AccountContrib: Record "Member Monthly Contribution";
        curNssfEmployee: Decimal;
        curNssfEmployerFactor: Decimal;
        intNHIFBasedOn: Enum NhifBasedOn;
        intNSSFBasedOn: Enum NhifBasedOn;
        curMaxPensionContrib: Decimal;
        curRateTaxExPension: Decimal;
        curOOIMaxMonthlyContrb: Decimal;
        curOOIDecemberDedc: Decimal;
        curLoanMarketRate: Decimal;
        curLoanCorpRate: Decimal;
        NssfTier1: Decimal;
        NssfTier2: Decimal;
        AccountCredit: Record "Account Credit";
        TaxAccount: Code[20];
        salariesAcc: Code[20];
        PayablesAcc: Code[20];
        NSSFEMPyer: Code[20];
        PensionEmpyer: Code[20];
        NSSFEMPyee: Code[20];
        NHIFEMPyer: Code[20];
        NHIFEMPyee: Code[20];
        SelectedPp: Text[100];
        PayrollType: Code[20];
        RoundUpDif: Decimal;
        RoundDownDiff: Decimal;
        SpecialTranAmount: Decimal;
        txBenefitAmt: Decimal;
        intOldMonth: Integer;
        intOldYear: Integer;
        intMonth: Integer;
        intYear: Integer;
        Memb: Record Member;
        Loan: Record Loans;
        firstDateOfPayrllPeriod: Date;
        StatutCategory: Enum PayrollStatutoryCategory;
        PRPeriodTrans: Record "Pr Period Transaction";
        AccBanking: Record "Account Banking";
        TotalMRepay: Decimal;
        CurBalance: Decimal;
        curHseLevy: Decimal;
        objPeriod: Record "Pr Payroll Period";
        EmpTrans: Record "Pr Employee Transaction";
        Loans: Record Loans;
        Trans: Record "Pr Transaction Code";
        TDate: Date;
        CurrDate: Date;
        CurrMonth: Date;
        JnlPostMgt: Codeunit "Journal Post Mngt.";
        HrSetup: Record "HR Setup";
        curHseRelief: Decimal;
        curHIFRelief: Decimal;
        curHseReliefPerc: Decimal;
        curHIFReliefPerc: Decimal;
        checkoffcutoffDay: DateFormula;
        DateFilter: Text[50];
        FromDates: Text[50];
        ToDates: Text[50];
        EmpTransObj: Record "Pr Employee Transaction";
        TaxOnExcess: Decimal;
        CurNonTxbleGross: Decimal;
        curHouseRelief: Decimal;
        CurMinTxblePwd: Decimal;
        ObjEmpL: Record "HR Employees";
        VoluntContrib: Decimal;
        PrsalCard: Record "Pr Salary Card";
        EmpSalary: Record "Pr Salary Card";
        CoopParameters: Enum CooParameter;
        HrEmployee: Record "HR Employees";
        EmpsalCard: Record "Pr Salary Card";
        PostingGroup: Record "Pr Employee Posting Group";
        VitalSetup: Record "Pr Vital Setup Info";
        Temp: Record "User Setup";
        HrObjtEmpl: Record "HR Employees";
        Dim1: Code[10];
        Dim2: Code[10];
        EmployeeMgt: Record Employee;
        PayingAccType: Enum "Gen. Journal Account Type";
        ErronOnMissingBankingAc: Label 'No Banking Account found for this related staff';

}
