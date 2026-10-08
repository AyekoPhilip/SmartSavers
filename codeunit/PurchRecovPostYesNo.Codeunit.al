codeunit 50066 "Purch. Recov.-Post (Yes/No)"
{
    TableNo = "Recovery Header";
    trigger OnRun()
    begin
        InitializePost(Rec, Rec."Post Journal", Rec."Posting Date");
    end;

    procedure InitializePost(RecRef: Record "Recovery Header"; CheckLine: Boolean; PostingDate: Date)
    var
        RecLine: Record "Checkoff Receipt Lines";
    begin
        fnInitialize();
        RecRef.fnCheckMinRequirement();
        fnPostRecHeader(RecRef);
        if RecRef."Post Journal" then begin
            Post.CompletePosting(Jtemplate, JBatch);
            OnCompletePostMgt(RecRef."No.");
        end else begin
            VarVariant := RecRef;
            Commit();
            Docx.DocPrintstatement(VarVariant, 0);
        end;
    end;

    local procedure fnPostRecHeader(var RecHeader: Record "Recovery Header")
    begin
        PostPurchline(RecHeader);
    end;

    local procedure PostPurchline(var RecRef: Record "Recovery Header")
    var
        DisbursementLine: Record "Loan Disbursement Lines";
        PostingDate: Date;
        NextLine: Integer;
        RunningBal: Decimal;
        OutInt: Decimal;
        OutIns: Decimal;
        OutBill: Decimal;
        OutPrinc: Decimal;
    begin

        fnInitialize();
        PostingDate := RecRef."Posting Date";

        case RecRef."Acrued Interest Options" of
            RecRef."Acrued Interest Options"::"Charge Accrued Interest":
                begin
                    if RecRef."Application Type" = RecRef."Application Type"::"Recovery from Shares" then
                        AccruedInt := fnAccruedInt(LoanEntry, Today, RecRef."Loan No.", 1, IntDays, StartDate) else
                        AccruedInt := fnAccruedInt(LoanEntry, Today, RecRef."Loan No.", 1, IntDays, StartDate) / DisbursementLine."No. of Guarantors";
                end else begin
                AccruedInt := 0;
            end;
        end;


        case RecRef."Application Type" of
            RecRef."Application Type"::"Recovery from Shares",
            RecRef."Application Type"::"Recover from guarantors":
                begin
                    case RecRef."Guarantor Recovery Options" of
                        RecRef."Guarantor Recovery Options"::" ",
                        RecRef."Guarantor Recovery Options"::"Recovery Shares":
                            begin

                                DisbursementLine.Reset();
                                DisbursementLine.SetRange(No, RecRef."No.");
                                if DisbursementLine.FindSet() then begin
                                    repeat
                                        initEntry();

                                        AccountCredit.Reset();
                                        AccountCredit.SetRange("No.", DisbursementLine."Account No.");
                                        AccountCredit.SetRange(Blocked, AccountCredit.Blocked::" ");
                                        if AccountCredit.FindFirst() then begin
                                            AccountCredit.CalcFields("Balance (LCY)");
                                            if AccountCredit."Balance (LCY)" > 0 then begin
                                                RunBal[1] := DisbursementLine.Amount;
                                                if RunBal[1] > AccountCredit."Balance (LCY)" then
                                                    Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountCredit."Balance (LCY)");

                                                Linenum := Linenum + 1000;
                                                CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2, RunBal[1], PostingDate,
                                                DisbursementLine.No, DisbursementLine."Account No.", AccountCredit."No.",
                                                GenAccType::Customer, Format(RecRef."Application Type") + '-' +
                                                DisbursementLine."Loan No.", '');
                                            end;
                                        end;

                                    until DisbursementLine.Next() = 0
                                end;
                            end;
                    end;
                end;

            RecRef."Application Type"::"Fosa Recovery":
                begin
                    DisbursementLine.Reset();
                    DisbursementLine.SetRange(No, RecRef."No.");
                    if DisbursementLine.FindSet() then begin
                        repeat
                            initEntry();
                            AccountBanking.Reset();
                            AccountBanking.SetRange("No.", DisbursementLine."Account No.");
                            AccountBanking.SetRange(Blocked, AccountBanking.Blocked::" ");
                            if AccountBanking.FindFirst() then begin

                                if AccountBanking."Balance (LCY)" > 0 then begin
                                    RunBal[1] := DisbursementLine.Amount;
                                    RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                                    if RunBal[1] > RunBal[3] then
                                        Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");

                                    Linenum := Linenum + 1000;
                                    CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2, RunBal[1], PostingDate,
                                    DisbursementLine.No, DisbursementLine."Account No.", AccountBanking."No.",
                                    GenAccType::Vendor, Format(RecRef."Application Type") + '-' +
                                    DisbursementLine."Loan No.", '');
                                end;
                            end;
                        until DisbursementLine.Next() = 0
                    end;
                end;

            RecRef."Application Type"::"Place Lien":
                begin

                    DisbursementLine.Reset();
                    DisbursementLine.SetRange(No, RecRef."No.");
                    if DisbursementLine.FindSet() then begin
                        repeat
                            initEntry();

                            AccountBanking.Reset();
                            AccountBanking.SetRange("No.", DisbursementLine."Account No.");
                            AccountBanking.SetRange(Blocked, AccountBanking.Blocked::" ");
                            if AccountBanking.FindFirst() then begin
                                if AccountBanking."Balance (LCY)" > 0 then begin
                                    RunBal[1] := DisbursementLine.Amount;
                                    RunBal[3] := TellMngt.CalcAvailableBal(AccountBanking."No.");
                                    if RunBal[1] > RunBal[3] then
                                        Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountBanking."Balance (LCY)");
                                    BnkMngt.PostLien(AccountBanking, DisbursementLine.Amount,
                                    DisbursementLine."Account Name", 0, DisbursementLine.No);
                                end else begin
                                    Error(ErrorOnNonAvailBal);
                                end;
                            end;
                        until DisbursementLine.Next() = 0
                    end;
                end;
        end;

        case RecRef."Guarantor Recovery Options" of
            RecRef."Guarantor Recovery Options"::" ",
            RecRef."Guarantor Recovery Options"::"Recovery Shares":
                begin

                    DisbursementLine.Reset();
                    DisbursementLine.SetRange(No, RecRef."No.");
                    DisbursementLine.SetRange("Loan No.", RecRef."Loan No.");
                    if DisbursementLine.FindSet() then begin
                        repeat
                            initEntry();
                            RunBal[1] := 0;

                            AccountCredit.Reset();
                            AccountCredit.SetRange("No.", DisbursementLine."Account No.");
                            AccountCredit.SetRange(Blocked, AccountCredit.Blocked::" ");
                            if AccountCredit.FindFirst() then begin
                                AccountCredit.CalcFields("Balance (LCY)");
                                if AccountCredit."Balance (LCY)" > 0 then begin
                                    RunBal[1] := DisbursementLine.Amount;
                                    if RunBal[1] > AccountCredit."Balance (LCY)" then
                                        Error(ErrorNonMatchingAmount, DisbursementLine.Amount, AccountCredit."Balance (LCY)");

                                    if DisbursementLine."Loan No." <> '' then begin

                                        LoanEntry.Reset();
                                        LoanEntry.SetRange("No.", DisbursementLine."Loan No.");
                                        LoanEntry.SetFilter("Outstanding Balance", '>0');
                                        if LoanEntry.FindFirst() then begin

                                            LoanEntry.CalcFields("Outstanding Interest",
                                            "Outstanding Insurance",
                                            "Outstanding Bill",
                                            "Outstanding Principal",
                                            "Outstanding Balance");

                                            if AccruedInt > 0 then begin
                                                Linenum := Linenum + 1000;
                                                NextLine := PostLnIntDue(LoanEntry."No.", RecRef."No.", PostingDate, Dim1, Dim2,
                                                Jtemplate, JBatch, AccruedInt, LoanEntry."Account No.", Linenum, LoanEntry."Product Type");
                                            end;

                                            if NextLine = 0 then
                                                Linenum := Linenum + 1000 else
                                                Linenum := NextLine;

                                            if (LoanEntry."Outstanding Interest" + AccruedInt) > 0 then begin
                                                RunBal[2] := 0;

                                                if RunBal[1] > (LoanEntry."Outstanding Interest" + AccruedInt) then
                                                    RunBal[2] := (LoanEntry."Outstanding Interest" + AccruedInt) else
                                                    RunBal[2] := RunBal[1];

                                                Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                                DisbursementLine.No, CopyStr(RecRef.Name + '-' + LoanEntry."No.", 1, 50),
                                                RunBal[2] * -1, LoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                                LoanEntry."Account No.", Dim1, Dim2, RepayType::"Interest Paid", LoanEntry."No.",
                                                '', '', GenDocTye::" ", '', GenDocTye::" ");
                                                RunBal[1] := RunBal[1] - Abs((RunBal[2]))
                                            end;

                                            if RunBal[1] > 0 then begin
                                                if LoanEntry."Outstanding Insurance" > 0 then begin
                                                    RunBal[2] := 0;
                                                    if RunBal[1] > LoanEntry."Outstanding Principal" then
                                                        RunBal[2] := LoanEntry."Outstanding Principal" else
                                                        RunBal[2] := RunBal[1];
                                                    Linenum := Linenum + 1000;

                                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                                    DisbursementLine.No,
                                                    CopyStr(RecRef.Name + '-' + LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                                    LoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                                    LoanEntry."Account No.", Dim1, Dim2, RepayType::"Insurance Paid", LoanEntry."No.",
                                                    '', '', GenDocTye::" ", '', GenDocTye::" ");
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
                                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                                    DisbursementLine.No, CopyStr(RecRef.Name + '-' + LoanEntry."No.", 1, 50), RunBal[2] * -1,
                                                    LoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                                    LoanEntry."Account No.", Dim1, Dim2, RepayType::"Penalty Paid", LoanEntry."No.", '', '', GenDocTye::" ", '',
                                                    GenDocTye::" ");
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
                                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                                    DisbursementLine.No, CopyStr(RecRef.Name + '-' + LoanEntry."No.", 1, 50),
                                                    RunBal[2] * -1, LoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                                    LoanEntry."Account No.", Dim1, Dim2, RepayType::Repayment, LoanEntry."No.", '', '',
                                                    GenDocTye::" ", '', GenDocTye::" ");
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        until DisbursementLine.Next() = 0
                    end;
                end;

            RecRef."Guarantor Recovery Options"::"Create Loan":
                begin

                    DisbursementLine.Reset();
                    DisbursementLine.SetRange(No, RecRef."No.");
                    DisbursementLine.SetRange("Loan No.", RecRef."Loan No.");
                    if DisbursementLine.FindSet() then begin
                        repeat

                            initEntry();

                            LoanEntry.Reset();
                            LoanEntry.SetRange("No.", DisbursementLine."Loan No.");
                            LoanEntry.SetFilter("Outstanding Balance", '>0');
                            if LoanEntry.FindFirst() then begin
                                LoanEntry.CalcFields("Outstanding Interest",
                                "Outstanding Insurance",
                                "Outstanding Bill",
                                    "Outstanding Principal", "Outstanding Balance");

                                OutBill := 0;
                                OutIns := 0;
                                OutInt := 0;
                                OutPrinc := 0;
                                RunningBal := 0;

                                if LoanEntry."Outstanding Interest" > 0 then begin

                                    OutInt := LoanEntry."Outstanding Interest";
                                    Linenum := Linenum + 1000;
                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                        DisbursementLine.No, CopyStr(DisbursementLine."Account Name" + '-' +
                                        LoanEntry."No.", 1, 50), Round(DisbursementLine."Interest Balance") * -1, LoanEntry."Loan Account", PostingDate,
                                        GenAccType::"G/L Account", '', LoanEntry."Account No.", Dim1, Dim2, RepayType::"Interest Paid", LoanEntry."No.",
                                        '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    RunningBal := RunningBal + Abs(DisbursementLine."Interest Balance");

                                    DefLoanEntry.Reset();
                                    DefLoanEntry.SetRange("Recovery No.", DisbursementLine.No);
                                    DefLoanEntry.SetRange("No.", DisbursementLine."Buff.Loan Entry No.");
                                    if DefLoanEntry.FindFirst() then begin
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                               DefLoanEntry."Recovery No.", CopyStr(DefLoanEntry."Account Name" + '-' +
                                               DefLoanEntry."No.", 1, 150), DisbursementLine."Interest Balance", DefLoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                               DefLoanEntry."Account No.", Dim1, Dim2, RepayType::Loan, DefLoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    end;
                                end;

                                if LoanEntry."Outstanding Insurance" > 0 then begin

                                    Linenum := Linenum + 1000;
                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                        DisbursementLine.No, CopyStr(DisbursementLine."Account Name" + '-' +
                                        LoanEntry."No.", 1, 50),
                                        Round(DisbursementLine."Outstanding Insurance") * -1, LoanEntry."Loan Account",
                                PostingDate, GenAccType::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2, RepayType::"Insurance Paid",
                                        LoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    RunningBal := RunningBal + Abs(DisbursementLine."Outstanding Insurance");
                                    DefLoanEntry.Reset();
                                    DefLoanEntry.SetRange("Recovery No.", DisbursementLine.No);
                                    DefLoanEntry.SetRange("No.", DisbursementLine."Buff.Loan Entry No.");
                                    if DefLoanEntry.FindFirst() then begin
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                               DefLoanEntry."Recovery No.", CopyStr(DefLoanEntry."Account Name" + '-' +
                                               DefLoanEntry."No.", 1, 150), DisbursementLine."Outstanding Insurance", DefLoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                               DefLoanEntry."Account No.", Dim1, Dim2, RepayType::Loan, DefLoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    end;
                                end;

                                if LoanEntry."Outstanding Bill" > 0 then begin

                                    Linenum := Linenum + 1000;
                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                        DisbursementLine.No, CopyStr(DisbursementLine."Account Name" + '-' +
                                        LoanEntry."No.", 1, 50), Round(DisbursementLine."Outstanding Bills") * -1,
                                        LoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2, RepayType::"Penalty Paid",
                                        LoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    RunningBal := RunningBal + Abs(DisbursementLine."Outstanding Bills");

                                    DefLoanEntry.Reset();
                                    DefLoanEntry.SetRange("Recovery No.", DisbursementLine.No);
                                    DefLoanEntry.SetRange("No.", DisbursementLine."Buff.Loan Entry No.");
                                    if DefLoanEntry.FindFirst() then begin
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                               DefLoanEntry."Recovery No.", CopyStr(DefLoanEntry."Account Name" + '-' +
                                               DefLoanEntry."No.", 1, 150), DisbursementLine."Outstanding Bills", DefLoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                               DefLoanEntry."Account No.", Dim1, Dim2, RepayType::Loan, DefLoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    end;
                                end;

                                if LoanEntry."Outstanding Principal" > 0 then begin
                                    Linenum := Linenum + 1000;

                                    Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                        DisbursementLine.No, CopyStr(DisbursementLine."Account Name" + '-' +
                                        LoanEntry."No.", 1, 50), DisbursementLine."Principal Balance" * -1,
                                        LoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                        LoanEntry."Account No.", Dim1, Dim2, RepayType::Repayment,
                                        LoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    RunningBal := RunningBal + Abs(DisbursementLine."Principal Balance");

                                    DefLoanEntry.Reset();
                                    DefLoanEntry.SetRange("Recovery No.", DisbursementLine.No);
                                    DefLoanEntry.SetRange("No.", DisbursementLine."Buff.Loan Entry No.");
                                    if DefLoanEntry.FindFirst() then begin
                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum, GenAccType::Customer,
                                               DefLoanEntry."Recovery No.", CopyStr(DefLoanEntry."Account Name" + '-' +
                                               DefLoanEntry."No.", 1, 150), DisbursementLine."Principal Balance", DefLoanEntry."Loan Account", PostingDate, GenAccType::"G/L Account", '',
                                               DefLoanEntry."Account No.", Dim1, Dim2, RepayType::Loan, DefLoanEntry."No.", '', '', GenDocTye::" ", '', GenDocTye::" ");
                                    end;
                                end;
                            end;

                        Until DisbursementLine.Next() = 0;
                    end;
                end;
        end
    end;

    local procedure fnInitialize()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Post.ClearJournalLines(Jtemplate, JBatch);

        EndDate := Today;
        StartDate := CalcDate('-CM', Today);
        IntDays := (EndDate - StartDate) + 1;
    end;

    local procedure initEntry()
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
    end;

    local procedure CreateBalancingAcc(LineNo: Integer;
    JTemplate:
        Code[10];
    JBatch:
        Code[10];
    Dim1:
        Code[10];
    Dim2:
        Code[10];
    Amt:
        Decimal;
    PDate:
        Date;
    DocNo:
        Code[20];
    ExtDocNo:
        Code[20];
    AccNo:
        Code[20];
    AccType:
        Enum "Gen. Journal Account Type";
    DescriptText:
        Text[100];
    CurrCode:
        Code[20])
    begin
        Post.PostJournal(JTemplate, JBatch, LineNo, AccType, DocNo, DescriptText,
        Amt, AccNo, PDate, Enum::"Gen. Journal Account Type"::"G/L Account", '', ExtDocNo, Dim1, Dim2,
        Enum::"LoanTransactionType"::" ", '', '', '', Enum::"Gen. Journal Document Type"::" ", CurrCode, Enum::"Gen. Journal Document Type"::" ")
    end;

    procedure PostLnIntDue(LoanNo: Code[100];
            DocumentNo:
                Code[20];
            PDate:
                Date;
            DActivity:
                Code[20];
            DBranch:
                Code[20];
            GnlTemplate:
                Code[20];
            GnlJBatch:
                Code[20];
            RunBal:
                Decimal;
            MemberNo:
                Code[20];
            LineNo:
                Integer;
            LoanType:
                Code[20]):
            Integer
    var
        Loans: Record Loans;
        ProductType:
                Record "Product Factory";
    begin

        if Loans.Get(LoanNo) then begin
            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");

            Post.PostJournal(GnlTemplate, GnlJBatch, LineNo, GenAccType::Customer, DocumentNo,
            Text00002 + LoanNo, RunBal, Loans."Loan Account", PDate, GenAccType::"G/L Account",
            ProductType."Interest Account (G/L)", Loans."Account No.", DActivity, DBranch, RepayType::"Interest Due",
            Loans."No.", Loans."Group Code", '', GenDocTye::" ", Loans."Currency Code", GenDocTye::" ");
            exit(LineNo + 1000)
        end
    end;




    procedure fnAccruedInt(VarVariant: Record Loans; IntPostDate: Date; CodeNo: Code[20]; PostInt: Integer; IntDays: Integer; intStartDate: Date) OutInt: Decimal
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

    procedure OnCompletePostMgt(DocNo: Code[100])
    var
        RecoveryHeader: Record "Recovery Header";
        PostLoan: Record Loans;
    begin
        RecoveryHeader.Reset();
        if RecoveryHeader.Get(DocNo) then begin
            case RecoveryHeader."Post Journal" of
                true:
                    begin
                        case RecoveryHeader."Application Type" of
                            RecoveryHeader."Application Type"::"Recovery from Shares":
                                begin

                                    if CustMember.Get(RecoveryHeader."Account No.") then begin
                                        CustMember."Loan Status" := CustMember."Loan Status"::Defaulter;
                                        CustMember.Modify(true);
                                    end;

                                    CredAc.Reset();
                                    CredAc.SetRange("Member No.", RecoveryHeader."Account No.");
                                    CredAc.SetRange("Account Category", CredAc."Account Category"::"Shares Deposit");
                                    if CredAc.FindSet() then begin

                                        if Loan.Get(RecoveryHeader."Loan No.") then
                                            DocMngt.CreateRecovLine(CredAc."No.",
                                            CredAc."Member No.", RecoveryHeader."Shares Deposits",
                                            Loan."Approved Amount", RecoveryHeader."Outstanding Interest",
                                            RecoveryHeader."Outstanding Principal", Loan."Product Type",
                                            RecoveryHeader."Shares Deductable", 2, Loan."No.", RecoveryHeader."No.");
                                    end;
                                end;

                            RecoveryHeader."Application Type"::"Fosa Recovery":
                                begin
                                    AccountBanking.Reset();
                                    AccountBanking.SetRange("No.", RecoveryHeader."Account to Debit");
                                    if AccountBanking.FindFirst() then begin
                                        if Loan.Get(RecoveryHeader."Loan No.") then
                                            DocMngt.CreateRecovLine(AccountBanking."No.", RecoveryHeader."Account No.",
                                            Purchline.Amount, Loan."Approved Amount", RecoveryHeader."Outstanding Interest",
                                            RecoveryHeader."Outstanding Principal", Loan."Product Type", Purchline."Shares Deposit", 1,
                                            Loan."No.", RecoveryHeader."No.");
                                    end;
                                end;
                        end;

                        Ploan.Reset();
                        Ploan.SetRange("No.", RecoveryHeader."Loan No.");
                        if Ploan.FindFirst() then begin
                            Ploan."Performance Indicator" := Ploan."Performance Indicator"::"Defaulted Account";
                            Ploan.Modify(true);
                        end;

                        Purchline.Reset;
                        Purchline.SetRange(No, RecoveryHeader."No.");
                        if Purchline.FindSet() then begin
                            repeat

                                case RecoveryHeader."Application Type" of
                                    RecoveryHeader."Application Type"::"Recover from guarantors":
                                        begin
                                            DocMngt.CreateRecovLine(Loan."Account No.",
                                            Loan."Account No.", Purchline."Shares Deposit",
                                            Loan."Approved Amount", RecoveryHeader."Outstanding Interest",
                                            RecoveryHeader."Outstanding Principal",
                                            Loan."Product Type", Purchline.Amount, 3,
                                            Loan."No.", RecoveryHeader."No.");

                                            PostLoan.Reset();
                                            PostLoan.SetRange("Recovery No.", Purchline.No);
                                            if PostLoan.FindSet() then begin
                                                PostLoan.ModifyAll("Posted By", UserId);
                                                PostLoan.ModifyAll("Date Posted", Today);
                                                PostLoan.ModifyAll("Time Posted", Time);
                                                PostLoan.ModifyAll("Loan Status", PostLoan."Loan Status"::Issued);
                                                PostLoan.ModifyAll("Approval Status", PostLoan."Approval Status"::Posted);
                                            end;
                                        end
                                end;

                                Purchline.Posted := true;
                                Purchline."Posted By" := UserId;
                                Purchline."Date Posted" := Today;
                                Purchline."Time Posted" := Time;
                                Purchline.Modify(true)
                            until Purchline.Next() = 0;
                        end;

                        RecoveryHeader.Posted := true;
                        RecoveryHeader."Posted By" := UserId;
                        RecoveryHeader."Date Posted" := Today;
                        RecoveryHeader."Approval Status" := RecoveryHeader."Approval Status"::Posted;
                        RecoveryHeader.Modify(true)

                    end else begin

                    VarVariant := RecoveryHeader;
                    Commit();
                    Docx.DocPrintstatement(VarVariant, 0);
                end;
            end;
        end;
    end;

    procedure CreatLoanAcc(RecRef: Record "Recovery Header")
    var
        LoanDisLine: Record "Loan Disbursement Lines";
        LoanApp: Record "Loan Application";
        DocPostMgt: Codeunit "Doc-PostMgt";
    begin

        case RecRef."Approval Status" of
            RecRef."Approval Status"::Approved:
                begin
                    if RecRef."Guarantor Recovery Options" = RecRef."Guarantor Recovery Options"::"Create Loan" then begin

                        LoanApp.Reset();
                        LoanApp.SetRange("Recovery Header No.", RecRef."No.");
                        LoanApp.SetRange("Approval Status", LoanApp."Approval Status"::Approved);
                        LoanApp.SetRange("Application Type", LoanApp."Application Type"::Defaulter);
                        if LoanApp.FindSet() then begin
                            repeat
                                DocPostMgt.LoanRegistration(LoanApp, 0);
                            until LoanApp.Next() = 0;
                        end;
                    end;
                end;
        end;
    end;

    procedure fngetLoanBalance(RecRef: Record "Recovery Header"; PostInt: Integer)
    var
        Loans: Record Loans;
    begin
        case PostInt of
            0:
                begin
                    exit
                end;
            1:
                begin

                    Loans.Reset;
                    Loans.SetRange("No.", RecRef."Loan No.");
                    if Loans.Find('-') then begin

                        Loans.CalcFields("Outstanding Interest", "Outstanding Bill",
                        "Outstanding Insurance", "Outstanding Principal",
                        "Outstanding Balance", "Outstanding Insurance");
                        RecRef."Outstanding Insurance" := Loans."Outstanding Insurance";
                        RecRef."Outstanding Balance" := Loans."Outstanding Balance";
                        RecRef."Outstanding Bill" := Loans."Outstanding Bill";
                        RecRef."Outstanding Interest" := Loans."Outstanding Interest";
                        RecRef."Outstanding Principal" := Loans."Outstanding Principal";

                    end
                end;
            2:
                begin
                    Loans.Reset;
                    Loans.SetRange("Account No.", RecRef."Account No.");
                    Loans.SetFilter("Outstanding Balance", '>0');
                    Loans.SetFilter("Deposits Appraisal Parameter", '<>%1', Loans."Deposits Appraisal Parameter"::Collateral);
                    if Loans.Find('-') then begin
                        repeat
                            Loans.CalcFields("Outstanding Interest", "Outstanding Bill",
                            "Outstanding Insurance", "Outstanding Principal",
                            "Outstanding Balance", "Outstanding Insurance");
                            RecRef."Outstanding Insurance" := Loans."Outstanding Insurance";
                            RecRef."Outstanding Balance" := (RecRef."Outstanding Balance" + Loans."Outstanding Balance");
                            RecRef."Outstanding Bill" := (RecRef."Outstanding Bill" + Loans."Outstanding Bill");
                            RecRef."Outstanding Interest" := (RecRef."Outstanding Interest" + Loans."Outstanding Interest");
                            RecRef."Outstanding Principal" := (RecRef."Outstanding Principal" + Loans."Outstanding Principal");
                        until Loans.Next = 0;
                    end
                end;
        end
    end;

    procedure fnClearLines(Recv: Record "Recovery Header")
    var
        DisburseLine: Record "Loan Disbursement Lines";
    begin
        DisburseLine.Reset;
        DisburseLine.SetRange(No, Recv."No.");
        DisburseLine.DeleteAll;
    end;

    var
        RecovHeader: Record "Recovery Header";
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
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
        TextDescriptTxt: Text[150];
        IntDays: Integer;
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        RegisterMngt: Codeunit "Register Management";
        AvailBalance: Decimal;
        BalanceLCY: Decimal;
        RepayType: Enum "LoanTransactionType";
        GenAccType: Enum "Gen. Journal Account Type";
        GenDocTye: Enum "Gen. Journal Document Type";
        DeductionStatus: Enum MobileDeductionStatus;
        TempEntry: Record "Transaction Types-Mobile";
        CredMgt: Codeunit "Credit Mgmt.";
        RecLoan: Record Loans;
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        PFact: Record "Product Factory";
        AccruedInt: Decimal;
        NoOfGuarant: Integer;
        PeriodicMgt: Codeunit "Periodic Activities Mgt.";
        GeneralSetUp: Record "General Set-Up";
        InterestEntry: Record "Interest Line";
        InterestProgEntry: Record "Loan Progression Lines";
        InitPost: Codeunit "Initialize Gen. Jnl.-Post";
        Temp: Record "Banking User Template";
        Linenum: Integer;
        RunBal: array[7] of Decimal;
        GenJournal: Record "Gen. Journal Line";
        PostPeriodic: Codeunit "Gen.Jnl.-Post Periodic";
        Post: Codeunit "Journal Post Mngt.";
        RegMgt: Codeunit "Register Management";
        LoanEntry: Record Loans;
        DefLoanEntry: Record Loans;
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
        Text00002: Label 'Interest Charged-';
        TextLoanEntry: Label 'Defaulter Recovery-';
        ErrorOnNonAvailBal: Label 'No enough fund for this application';
        ErrorOnPostedEntry: Label 'Entry already Posted';
        ErrorNonMatchingAmount: Label 'Running balance of Kshs %1 cannot be less than available account balance of Kshs %2.';
        ErrorOnNotAccountFound: Label 'Member No. %1 have no existing %2 found.';
        ErrorOnNotApprovedApplic: Label 'This application not yet approved. Kindly have the document approved before you can continue';
        Notif: Codeunit "SMS Notification";
}



