namespace DynamicsNav.DynamicsNav;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
codeunit 50005 "Post. Checkoff Mngt."
{
    TableNo = "Checkoff Header";
    trigger OnRun()
    begin
        InitializePost(Rec, Jtemplate, JBatch, Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
    end;

    procedure InitializePost(RecRef: Record "Checkoff Header"; Template: Code[10]; TBatch: Code[10]; ShortDim1: Code[10]; ShortDim2: Code[10])
    begin

        InitJournalTemplate();

        case RecRef."Posting Type" of
            RecRef."Posting Type"::"Post Application":
                begin
                    RecRef.TestField("Approval Status", RecRef."Approval Status"::Approved);
                    if RecRef."Account Type" = RecRef."Account Type"::"G/L Account" then begin
                        if TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 2) then
                            Error(Text016, RecRef."Account Name", RecRef."No.");
                    end;
                    if RecRef."Account Type" = RecRef."Account Type"::Customer then begin
                        if TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 4) then
                            Error(Text016, RecRef."Account Name", RecRef."No.");
                    end;
                end
        end;

        Purchline.Reset;
        Purchline.SetRange("No.", RecRef."No.");
        Purchline.SetRange("Account Found", true);
        Purchline.SetRange(Posted, false);
        if Purchline.FindSet() then begin
            repeat
                PostPurchLineNoPriority(Purchline, RecRef."Posting Date", RecRef.Description,
                RecRef."Cutoff Date", RecRef."Loan Deduction Type", RecRef."Deduction Type",
                RecRef."Post Business Loan", RecRef."Product Type");

                case RecRef."Posting Type" of
                    RecRef."Posting Type"::"Post Application":
                        begin
                            if RecRef."Post As" = RecRef."Post As"::"Post As Lines" then begin
                                Post.CompletePosting(Jtemplate, JBatch);
                                Commit;
                                Purchline.Posted := true;
                                Purchline."Poated By" := UserId;
                                Purchline."Date Posted" := CurrentDateTime;
                                Purchline.Modify(true);
                            end
                        end;
                end;
            until Purchline.Next() = 0;

            RecRef.TestField(Description);
            RecRef.CalcFields("Scheduled Amount", "Total Amount", "Total Interest");

            case RecRef."Post As" of
                RecRef."Post As"::"Post As Batch":
                    begin
                        Linenum := Linenum + 10;
                        CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2,
                        (RecRef."Scheduled Amount" + RecRef."Total Interest"),
                        RecRef."Posting Date", RecRef."No.", RecRef."Account No.", RecRef."Account No.",
                        RecRef."Account Type", CopyStr(RecRef.Description, 1, 100), '');
                        if RecRef."Posting Type" = RecRef."Posting Type"::"Post Application" then begin
                            Post.CompletePosting(Jtemplate, JBatch);
                            OnCompletePostMgt(0, RecRef."No.");
                        end;
                    end;
            end;

            case RecRef."Posting Type" of
                RecRef."Posting Type"::"Generate Batch":
                    begin
                        VarVariant := RecRef;
                        Commit();
                        Docx.DocPrintstatement(VarVariant, 0);
                    end else begin
                    OnCompletePostMgt(0, RecRef."No.");
                end;
            end
        end;
    end;

    procedure fnLastgenLine(Temps: Code[20]; LBatch: Code[20]; DocNo: Code[100]): Integer
    var
        GenJLine: Record "Gen. Journal Line";
    begin

        GenJLine.SetCurrentKey("Line No.");
        GenJLine.Ascending(false);
        GenJLine.SetRange("Journal Template Name", Temps);
        GenJLine.SetRange("Journal Batch Name", LBatch);
        GenJLine.SetRange("Document No.", DocNo);
        if GenJLine.FindLast() then
            exit(GenJLine."Line No.")

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

    local procedure InitJournalTemplate()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Check Off Template");
        Temp.TestField("Check Off Batch");
        Jtemplate := Temp."Check Off Template";
        JBatch := Temp."Check Off Batch";

        JnPost.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;


    procedure CreateBalancingAcc(LineNo: Integer; JTemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal; PDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; AccNo: Code[20]; AccType: Enum "Gen. Journal Account Type"; DescriptText: Text[150]; CurrCode: Code[20])
    begin
        Post.PostJournal(JTemplate, JBatch, LineNo, AccType, DocNo, DescriptText,
        Amt, AccNo, PDate, Enum::"Gen. Journal Account Type"::"G/L Account", '',
        ExtDocNo, Dim1, Dim2, Enum::"LoanTransactionType"::" ", '', '', '',
        Enum::"Gen. Journal Document Type"::" ", CurrCode, Enum::"Gen. Journal Document Type"::" ")
    end;

    procedure CreateBalancingRepayAcc(LineNo: Integer; JTemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal; PDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; AccNo: Code[100]; AccType: Enum "Gen. Journal Account Type"; DescriptText: Text[150]; CurrCode: Code[20])
    var
        RepayAcc: Record "Repayment Account";
    begin

        Post.PostJournal(JTemplate, JBatch, LineNo, AccType::Vendor, DocNo, DescriptText, Amt, AccNo, PDate,
        Enum::"Gen. Journal Account Type"::"G/L Account", '', ExtDocNo, Dim1, Dim2,
        Enum::"LoanTransactionType"::" ", '', '', '', Enum::"Gen. Journal Document Type"::" ", CurrCode,
        Enum::"Gen. Journal Document Type"::" ")


    end;

    procedure PostPurchLineNoPriority(Checkline: Record "Checkoff Receipt Lines";
    PostingDate: Date; TextDescription: Text[150]; CutoffDate: Date;
    LoanDeductType: Enum CheckoffLoanDeductType; DeductType: Enum CheckOffDeductType;
    PostBusLoan: Boolean; ProdType: Code[20]): Integer
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
        BlockedAc: Record "Repayment Account";
        RepayAcc: Record "Repayment Account";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
        NonExitAccount: Boolean;
        VendAc: Record Vendor;
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

        Checkline.TestField("Repayment Account");
        CreateRepayAc(Checkline."Repayment Account");

        case RcptHeader."Post As" of
            RcptHeader."Post As"::"Post As Lines":
                begin
                    Linenum := Linenum + 10;
                    CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2, (Checkline.Amount + Checkline."Interest Repayment"),
                    PostingDate, Checkline."No.", Checkline."Member No.", RcptHeader."Account No.",
                    RcptHeader."Account Type", CopyStr(Checkline.Name + '-' + TextDescription, 1, 100), '');
                end;
        end;

        Linenum := Linenum + 10;
        CreateBalancingRepayAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2, (Checkline.Amount + Checkline."Interest Repayment") * -1,
        PostingDate, Checkline."No.", Checkline."Member No.", Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
        CopyStr(Checkline.Name + '-' + TextDescription, 1, 100), '');

        CustAccount.Reset();
        CustAccount.SetRange("No.", Checkline."Member No.");
        CustAccount.SetFilter(Status, '%1|%2', CustAccount.Status::Withdrawn, CustAccount.Status::Deceased);
        if CustAccount.Find('-') then begin
            NonExitAccount := true;
        end;

        if not NonExitAccount then begin
            Linenum := Linenum + 10;

            case RcptHeader."Application Type" of
                RcptHeader."Application Type"::"Product Amount",
                    RcptHeader."Application Type"::"Allocated Amount":
                    begin
                        PostPurchLineAllocAmount(Checkline, PostingDate, TextDescription, CutoffDate, Linenum)
                    end;
                RcptHeader."Application Type"::"Consolidated Amount":
                    begin
                        case DeductType of

                            DeductType::"All Products":
                                begin
                                    PostPurchPriority(Checkline, PostingDate, TextDescription, CutoffDate, Checkline.Amount, PostBusLoan, ProdType, Linenum)
                                end;
                            DeductType::Account:
                                begin
                                    PostPurchAccountPriority(Checkline, PostingDate, TextDescription, CutoffDate, Checkline.Amount, Linenum)
                                end;
                            DeductType::Loan:
                                begin
                                    case LoanDeductType of
                                        LoanDeductType::"All loans":
                                            begin
                                                PostPurchLoanPriority(Checkline, PostingDate, TextDescription, CutoffDate, Checkline.Amount, Linenum);
                                            end;
                                        LoanDeductType::"Specified Loans",
                                        LoanDeductType::"Mobile Loans Only":
                                            begin
                                                PostSpecificLoanPriority(Checkline, PostingDate, TextDescription, CutoffDate, Checkline.Amount, ProdType, Linenum)
                                            end;
                                    end;
                                end;
                        end;

                    end;
            end;
        end;
    end;

    local procedure CheckIfRepayAccExist(AccountNo: Code[100]): Boolean
    var
        VendAc: Record Vendor;
    begin
        VendAc.SetRange("No.", AccountNo);
        if VendAc.FindFirst() then
            exit(true) else
            exit(false)
    end;

    local procedure CreateRepayAc(AccountNo: Code[100])
    Var
        RegisterManagement: codeunit "Register Management";
        Banking: Record "Repayment Account";
    begin

        if Banking.Get(AccountNo) then begin
            if not CheckIfRepayAccExist(Banking."No.") then begin
                RegisterManagement.fnCreateVendorPostAc(Banking."No.",
                                                            Banking.Name, Banking."Phone No.", Banking."Global Dimension 1 Code",
                                                            Banking."Global Dimension 2 Code", Banking."Customer Posting Group",
                                                            '', Banking.Status, Banking."Product Type",
                                                            '', Banking."Member No.", Banking."Account Category")
            end
        end;
    end;

    procedure PostSpecificLoanPriority(Checkline: Record "Checkoff Receipt Lines"; PostingDate: Date; TextDescription: Text[150]; CutoffDate: Date; AmtPost: Decimal; ProdType: Code[20]; LinesNo: Integer): Decimal
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
        BlockedAc: Record "Account Banking";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
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

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        InitJournalTemplate();

        DFilter := '..' + Format(CutoffDate);
        RunBal := AmtPost;
        Linenum := LinesNo;

        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Insurance", '>0');
        PLoans.SetRange("Product Type", ProdType);
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;

        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Interest", '>0');
        PLoans.SetRange("Product Type", ProdType);
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;


        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Bill", '>0');
        PLoans.SetRange("Product Type", ProdType);
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;

        PLoans.SetCurrentKey("No.");

        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Principal", '>0');
        PLoans.SetRange("Product Type", ProdType);
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;
        exit(RunBal)
    end;

    procedure PostPurchLoanPriority(Checkline: Record "Checkoff Receipt Lines"; PostingDate: Date; TextDescription: Text[150]; CutoffDate: Date; AmtPost: Decimal; LinesNo: Integer): Decimal
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
        BlockedAc: Record "Account Banking";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
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

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        InitJournalTemplate();

        DFilter := '..' + Format(CutoffDate);
        RunBal := AmtPost;

        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Insurance", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;

        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Interest", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;


        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Bill", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;

        PLoans.SetCurrentKey("No.");

        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Principal", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;

        exit(RunBal)
    end;

    procedure PostPurchAccountPriority(Checkline: Record "Checkoff Receipt Lines"; PostingDate: Date; TextDescription: Text[150]; CutoffDate: Date; AmtToPost: Decimal; LinesNo: Integer): Decimal
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
        BlockedAc: Record "Account Banking";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
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

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        InitJournalTemplate();

        DFilter := '..' + Format(CutoffDate);
        RunBal := AmtToPost;

        AccCred.Reset;
        AccCred.SetRange(Blocked, AccCred.Blocked::" ");
        AccCred.SetRange("Member No.", Checkline."Member No.");
        if AccCred.Find('-') then begin
            repeat
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

                case AccCred."Account Category" of
                    AccCred."Account Category"::"Registration Fee":
                        begin

                            if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > 0 then begin
                                if not AccCred."Registration Fee Paid" then begin
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

                                        Linenum := Linenum + 10;
                                        CreateBalancingRepayAcc(Linenum, Jtemplate,
                                        JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                                        Checkline."No.", Checkline."Member No.",
                                        Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                                        GenJournal.Description, '');

                                    end;
                                end;
                            end;
                        end;
                    AccCred."Account Category"::"Shares Capital":
                        begin
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

                                            Linenum := Linenum + 10;
                                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                                            JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                                            Checkline."No.", Checkline."Member No.",
                                            Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                                            GenJournal.Description, '');

                                        end;
                                    end;
                            end;

                        end else begin

                        MonthlyContrib.Reset();
                        MonthlyContrib.SetRange("Application No.", AccCred."No.");
                        MonthlyContrib.SetRange("Account No.", AccCred."Member No.");
                        MonthlyContrib.SetRange(Type, AccCred."Account Category");
                        if MonthlyContrib.Find('-') then begin
                            MonthlyContrib.TestField(Amount);

                            if ProdFact.Get(AccCred."Product Type") then
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
                                    RunBal := RunBal - Abs(GenJournal.Amount);

                                    Linenum := Linenum + 10;
                                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                                    Checkline."No.", Checkline."Member No.",
                                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                                    GenJournal.Description, '');

                                end;
                        end;
                    end;
                end;
            until AccCred.Next() = 0;
        end;

        AccBanking.Reset;
        AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
        AccBanking.SetRange("Member No.", Checkline."Member No.");
        AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::Junior);
        if AccBanking.Find('-') then begin
            repeat

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", AccBanking."Member No.");
                MonthlyContrib.SetRange("Application No.", AccBanking."No.");
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

                            Linenum := Linenum + 10;
                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                            JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                            Checkline."No.", Checkline."Member No.",
                            Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                            GenJournal.Description, '');

                        end;
                    end;
                end;
            until AccBanking.Next() = 0;
        end;
        exit(Linenum)
    end;

    procedure PostPurchPriority(Checkline: Record "Checkoff Receipt Lines"; 
    PostingDate: Date; TextDescription: Text[150]; CutoffDate: Date; 
    AmtPost: Decimal; PostBusLoan: Boolean; ProdType: Code[20]; 
    LinesNo: Integer): Decimal
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
        BlockedAc: Record "Account Banking";
        InterestLineEntry: Record "Interest Line";
        Rschedule: Record "Repayment Schedule";
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

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        InitJournalTemplate();

        DFilter := '..' + Format(CutoffDate);
        RunBal := AmtPost;

        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Insurance", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');

                end;
            until PLoans.Next = 0;
        end;

        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Interest", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;


        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Bill", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;


        PLoans.SetCurrentKey("No.");
        PLoans.Reset;
        PLoans.SetAscending("No.", true);
        PLoans.SetRange("Account No.", Checkline."Member No.");
        PLoans.SetFilter("Outstanding Principal", '>0');
        PLoans.SetFilter("Product Type", '<>%1', 'A106');
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
                    Linenum := Linenum + 10;
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

                    Linenum := Linenum + 10;
                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                    Checkline."No.", Checkline."Member No.",
                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                    GenJournal.Description, '');
                end;
            until PLoans.Next = 0;
        end;

        AccCred.Reset;
        AccCred.SetRange(Blocked, AccCred.Blocked::" ");
        AccCred.SetRange("Member No.", Checkline."Member No.");
        if AccCred.Find('-') then begin
            repeat
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

                case AccCred."Account Category" of
                    AccCred."Account Category"::"Registration Fee":
                        begin

                            if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > 0 then begin
                                if not AccCred."Registration Fee Paid" then begin
                                    if RunBal > 0 then begin

                                        GenJournal.LockTable;
                                        Linenum := Linenum + 10;
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

                                        Linenum := Linenum + 10;
                                        CreateBalancingRepayAcc(Linenum, Jtemplate,
                                        JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                                        Checkline."No.", Checkline."Member No.",
                                        Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                                        GenJournal.Description, '');

                                    end;
                                end;
                            end;
                        end;
                    AccCred."Account Category"::"Shares Capital":
                        begin
                            if getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > 0 then begin
                                if ProdFact.Get(AccCred."Product Type") then
                                    if ProdFact."Enforce Min. Share Rule" then begin

                                        if RunBal > 0 then begin

                                            GenJournal.LockTable;
                                            Linenum := Linenum + 10;
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

                                            Linenum := Linenum + 10;
                                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                                            JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                                            Checkline."No.", Checkline."Member No.",
                                            Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                                            GenJournal.Description, '');

                                        end;
                                    end;
                            end;

                        end else begin

                        MonthlyContrib.Reset();
                        MonthlyContrib.SetRange("Application No.", AccCred."No.");
                        MonthlyContrib.SetRange("Account No.", AccCred."Member No.");
                        MonthlyContrib.SetRange(Type, AccCred."Account Category");
                        if MonthlyContrib.Find('-') then begin
                            MonthlyContrib.TestField(Amount);

                            if ProdFact.Get(AccCred."Product Type") then
                                if RunBal > 0 then begin

                                    GenJournal.LockTable;
                                    Linenum := Linenum + 10;
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
                                    RunBal := RunBal - Abs(GenJournal.Amount);

                                    Linenum := Linenum + 10;
                                    CreateBalancingRepayAcc(Linenum, Jtemplate,
                                    JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                                    Checkline."No.", Checkline."Member No.",
                                    Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                                    GenJournal.Description, '');
                                end;
                        end;
                    end;
                end;
            until AccCred.Next() = 0;
        end;

        AccBanking.Reset;
        AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
        AccBanking.SetRange("Member No.", Checkline."Member No.");
        AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::Junior);
        if AccBanking.Find('-') then begin
            repeat

                MonthlyContrib.Reset();
                MonthlyContrib.SetRange("Account No.", AccBanking."Member No.");
                MonthlyContrib.SetRange("Application No.", AccBanking."No.");
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

                            Linenum := Linenum + 10;
                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                            JBatch, Dim1, Dim2, GenJournal.Amount, PostingDate,
                            Checkline."No.", Checkline."Member No.",
                            Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                            GenJournal.Description, '');
                        end;
                    end;
                end;
            until AccBanking.Next() = 0;
        end;
        Linenum := Linenum + 10;
        if PostBusLoan then begin
            PostSpecificLoanPriority(Checkline, PostingDate, TextDescription, CutoffDate, RunBal, ProdType, Linenum)
        end;
        exit(RunBal)
    end;

    local procedure OnCompletePostMgt(Variantext: Integer; DocNo: Code[100])
    var
        CheckHeader: Record "Checkoff Header";
        UnsupportedRecordTypeErr: Label 'Action Item %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
    begin
        if CheckHeader.Get(DocNo) then begin
            CheckHeader.Posted := true;
            CheckHeader."Approval Status" := CheckHeader."Approval Status"::Posted;
            CheckHeader."Posted By" := UserId;
            CheckHeader."Date Posted" := Today;
            CheckHeader.Modify;
        end;
    end;

    procedure PostPurchLineAllocAmount(Checkline: Record "Checkoff Receipt Lines"; PostingDate: Date; TextDescription: Text[150]; CutoffDate: Date; LinesNo: Integer): Integer
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
        BalancingAmt: Decimal;

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
        BalancingAmt := 0;

        DFilter := '..' + Format(CutoffDate);

        RcptHeader.Reset();
        RcptHeader.SetRange("No.", Checkline."No.");
        if RcptHeader.FindFirst() then begin
            AdviceType := RcptHeader."Advice Type"
        end;

        if Checkline.Amount > 0 then begin

            Checkline.TestField("Repayment Account");
            CreateRepayAc(Checkline."Repayment Account");
            RunBal := Checkline.Amount;

            case Checkline."Account Dimension" of
                Checkline."Account Dimension"::Credit,
                Checkline."Account Dimension"::"Micro Credit":
                    begin

                        BalancingAmt := 0;

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
                            BalancingAmt := Abs(GenJournal.Amount);

                            Linenum := Linenum + 10;
                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                            JBatch, Dim1, Dim2, BalancingAmt, PostingDate,
                            Checkline."No.", Checkline."Member No.", Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                            GenJournal.Description, '');

                        end else begin
                            Error(ErrorOnNotAccountFound, Checkline."Member No.", AccCred."Account Category")
                        end;
                    end;
                Checkline."Account Dimension"::Banking:
                    begin
                        BalancingAmt := 0;

                        AccBanking.Reset;
                        AccBanking.SetRange("No.", Checkline."Account No.");
                        AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
                        AccBanking.SetRange("Account Category", Checkline."Account Category");
                        if AccBanking.FindFirst() then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                            GenJournal.Validate("Account No.", AccBanking."No.");
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := Checkline."No.";
                            GenJournal."External Document No." := Checkline."Member No.";
                            GenJournal.Validate(Amount, CheckLine.Amount * -1);
                            GenJournal.Description := CopyStr(Format(AccBanking."Account Category") + '-' + TextDescription, 1, 100);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                            BalancingAmt := Abs(GenJournal.Amount);

                            Linenum := Linenum + 10;
                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                            JBatch, Dim1, Dim2, BalancingAmt, PostingDate,
                            Checkline."No.", Checkline."Member No.",
                            Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor,
                            GenJournal.Description, '');

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
                                            BalancingAmt := 0;
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
                                                    GenJournal.Validate(Amount, RunBal * -1) else
                                                    GenJournal.Validate(Amount, OutInterest * -1);
                                                GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + TextDescription, 1, 100);
                                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                GenJournal.Validate("Loan No.", PLoans."No.");
                                                if GenJournal.Amount <> 0 then
                                                    GenJournal.Insert(true);
                                                RunBal := RunBal - Abs(GenJournal.Amount);
                                                BalancingAmt := Abs(GenJournal.Amount);

                                                Linenum := Linenum + 10;
                                                CreateBalancingRepayAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2,
                                                BalancingAmt, PostingDate, Checkline."No.", Checkline."Member No.",
                                                Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor, GenJournal.Description, '');

                                            end;
                                        end;
                                        if RunBal > 0 then begin
                                            if PLoans."Outstanding Principal" > 0 then begin

                                                LRepayment := 0;
                                                ScheduleAmt := 0;
                                                BalancingAmt := 0;

                                                if PLoans."Outstanding Bill" < 0 then
                                                    Error(ErrorOnNegatedBalanceTxt, PLoans."No.");

                                                if (PLoans."Outstanding Interest" < 0) or (PLoans."Outstanding Insurance" < 0) then
                                                    Error(ErrorOnNegatedBalanceTxt, PLoans."No.");

                                                //LRepayment := (PLoans.Repayment - (PLoans."Outstanding Interest" + PLoans."Outstanding Insurance" + PLoans."Outstanding Bill"));
                                                LRepayment := PLoans."Outstanding Principal";

                                                if LRepayment < 0 then
                                                    LRepayment := 0;

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
                                                BalancingAmt := Abs(GenJournal.Amount);

                                                Linenum := Linenum + 10;
                                                CreateBalancingRepayAcc(Linenum, Jtemplate,
                                                JBatch, Dim1, Dim2, BalancingAmt, PostingDate, Checkline."No.", Checkline."Member No.",
                                                Checkline."Repayment Account", "Gen. Journal Account Type"::Vendor, GenJournal.Description, '');
                                            end
                                        end;

                                        if RunBal > 0 then begin

                                            AccCred.Reset;
                                            AccCred.SetRange("No.", PLoans."Account No.");
                                            AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                                            AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
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
                                                GenJournal.Validate(Amount, RunBal * -1);
                                                GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                if GenJournal.Amount <> 0 then
                                                    GenJournal.Insert(true);
                                                BalancingAmt := Abs(GenJournal.Amount);

                                                Linenum := Linenum + 10;
                                                CreateBalancingRepayAcc(Linenum, Jtemplate,
                                                JBatch, Dim1, Dim2, RunBal, PostingDate,
                                                Checkline."No.", Checkline."Member No.", Checkline."Repayment Account",
                                                "Gen. Journal Account Type"::Vendor,
                                                GenJournal.Description, '');
                                            end;
                                        end;
                                    end;
                                end else begin

                                BalancingAmt := 0;
                                RunBal := 0;
                                RunBal := Checkline."Interest Repayment";

                                PLoans.SetCurrentKey("No.");
                                PLoans.Reset;
                                PLoans.SetAscending("No.", true);
                                PLoans.SetRange("No.", Checkline."Loan No.");
                                PLoans.SetRange("Account No.", Checkline."Member No.");
                                if PLoans.FindFirst() then begin

                                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                    "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
                                    if RunBal > 0 then begin
                                        if PLoans."Outstanding Interest" > 0 then begin

                                            BalancingAmt := 0;
                                            OutInterest := 0;

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
                                            if OutInterest > RunBal then
                                                GenJournal.Validate(Amount, RunBal * -1) else
                                                GenJournal.Validate(Amount, OutInterest * -1);
                                            GenJournal.Description := CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") + '-' + TextDescription, 1, 100);
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            GenJournal.Validate("Loan No.", PLoans."No.");
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                            RunBal := RunBal - Abs(GenJournal.Amount);
                                            BalancingAmt := Abs(GenJournal.Amount);

                                            Linenum := Linenum + 10;
                                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                                            JBatch, Dim1, Dim2, BalancingAmt, PostingDate,
                                            Checkline."No.", Checkline."Member No.", Checkline."Repayment Account",
                                            "Gen. Journal Account Type"::Vendor, GenJournal.Description, '');
                                        end;
                                    end;

                                    if RunBal > 0 then begin

                                        AccCred.Reset;
                                        AccCred.SetRange("No.", PLoans."Account No.");
                                        AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
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
                                            GenJournal.Validate(Amount, RunBal * -1);
                                            GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                            BalancingAmt := Abs(GenJournal.Amount);

                                            Linenum := Linenum + 10;
                                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                                            JBatch, Dim1, Dim2, RunBal, PostingDate,
                                            Checkline."No.", Checkline."Member No.", Checkline."Repayment Account",
                                            "Gen. Journal Account Type"::Vendor,
                                            GenJournal.Description, '');
                                        end;
                                    end;

                                    RunBal := 0;
                                    RunBal := Checkline."Principle Repayment";

                                    if RunBal > 0 then begin
                                        if PLoans."Outstanding Principal" > 0 then begin

                                            BalancingAmt := 0;
                                            LRepayment := PLoans."Outstanding Principal";
                                            if LRepayment < 0 then
                                                LRepayment := 0;

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
                                            BalancingAmt := Abs(GenJournal.Amount);

                                            Linenum := Linenum + 10;
                                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                                            JBatch, Dim1, Dim2, BalancingAmt, PostingDate,
                                            Checkline."No.", Checkline."Member No.", Checkline."Repayment Account",
                                            "Gen. Journal Account Type"::Vendor, GenJournal.Description, '');
                                        end;
                                    end;
                                    if RunBal > 0 then begin

                                        AccCred.Reset;
                                        AccCred.SetRange("No.", PLoans."Account No.");
                                        AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
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
                                            GenJournal.Validate(Amount, RunBal * -1);
                                            GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                            BalancingAmt := Abs(GenJournal.Amount);

                                            Linenum := Linenum + 10;
                                            CreateBalancingRepayAcc(Linenum, Jtemplate,
                                            JBatch, Dim1, Dim2, RunBal, PostingDate,
                                            Checkline."No.", Checkline."Member No.", Checkline."Repayment Account",
                                            "Gen. Journal Account Type"::Vendor,
                                            GenJournal.Description, '');
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
            end;
            exit(Linenum)
        end;
    end;

    procedure PerfomValidate(CheckHeader: Record "Checkoff Header")
    var
        Purchline: Record "Checkoff Receipt Lines";
        ProgressWindow: Dialog;
    begin

        case CheckHeader."Application Type" of
            CheckHeader."Application Type"::"Allocated Amount":
                begin
                    Purchline.Reset;
                    Purchline.SetRange("No.", CheckHeader."No.");
                    if Purchline.Find('-') then begin
                        ProgressWindow.Open('Validating Lines #1########################');
                        repeat
                            ProgressWindow.Update(1, Purchline."Upload ID" + ':' + Format(Purchline.Amount));
                            fnvalidateReceiptAllocated(Purchline);

                        until Purchline.Next = 0;
                        ProgressWindow.Close
                    end
                end;
            CheckHeader."Application Type"::"Consolidated Amount":
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
            CheckHeader."Application Type"::"Product Amount":
                begin
                    Purchline.Reset;
                    Purchline.SetRange("No.", CheckHeader."No.");
                    if Purchline.Find('-') then begin
                        ProgressWindow.Open('Validating Lines #1########################');
                        repeat
                            ProgressWindow.Update(1, Purchline."Upload ID" + ':' + Format(Purchline.Amount));
                            ValidateReceiptProdType(Purchline, Purchline."Upload Response", CheckHeader."Application Type");

                        until Purchline.Next = 0;
                        ProgressWindow.Close
                    end
                end;
        end;

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
                                //CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
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

                end;
            ApplicType::"Product Amount":
                begin

                end;
        end;
    end;

    procedure fnvalidateReceiptAllocated(CheckLine: Record "Checkoff Receipt Lines")
    var
        CustRecord: Record Member;
        RepayAcc: Record "Repayment Account";
        CredAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
        Loans: Record Loans;
    begin

        case CheckLine."Upload Response" of
            1:
                begin
                    if CheckLine."Loan No." = '' then begin

                        case CheckLine."Account Category" of
                            CheckLine."Account Category"::Other,
                                CheckLine."Account Category"::"Registration Fee",
                                    CheckLine."Account Category"::"Shares Capital",
                                    CheckLine."Account Category"::"Shares Deposit",
                                    CheckLine."Account Category"::"Benevolent Fund",
                                    CheckLine."Account Category"::Insurance:
                                begin

                                    CustRecord.Reset;
                                    CustRecord.SetRange("No.", CheckLine."Upload ID");
                                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                    CustRecord.SetRange("Customer Type", CustRecord."Customer Type"::Individual);
                                    if CustRecord.Find('-') then begin

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
                                            CheckLine.Modify(true)
                                        end;
                                    end;
                                end;

                            CheckLine."Account Category"::"Money Market",
                            CheckLine."Account Category"::"Islamic Banking",
                        CheckLine."Account Category"::"Specialty Savings":
                                begin

                                    CustRecord.Reset;
                                    CustRecord.SetRange("No.", CheckLine."Upload ID");
                                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                    CustRecord.SetRange("Customer Type", CustRecord."Customer Type"::Individual);
                                    if CustRecord.Find('-') then begin

                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CustRecord."No.");
                                        AccBanking.SetRange("Account Category", CheckLine."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
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
                                            CheckLine.Modify(true)
                                        end;
                                    end;
                                end;
                        end;

                    end else begin

                        Loans.Reset();
                        Loans.SetRange("No.", CheckLine."Loan No.");
                        if Loans.FindFirst() then begin
                            Loans.CalcFields("Outstanding Balance");
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

                            if CustRecord.Get(Loans."Account No.") then begin
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
                                CheckLine.Modify(true)
                            end;
                        end;
                    end;
                end;

            2:
                begin
                    if CheckLine."Loan No." = '' then begin

                        case CheckLine."Account Category" of
                            CheckLine."Account Category"::Other,
                                CheckLine."Account Category"::"Registration Fee",
                                    CheckLine."Account Category"::"Shares Capital",
                                    CheckLine."Account Category"::"Shares Deposit",
                                    CheckLine."Account Category"::"Benevolent Fund",
                                    CheckLine."Account Category"::Insurance:
                                begin

                                    CustRecord.Reset;
                                    CustRecord.SetRange("ID No.", CheckLine."Upload ID");
                                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                    CustRecord.SetRange("Customer Type", CustRecord."Customer Type"::Individual);
                                    if CustRecord.Find('-') then begin

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
                                            CheckLine.Modify(true)
                                        end;
                                    end;
                                end;


                            CheckLine."Account Category"::"Money Market",
                            CheckLine."Account Category"::"Islamic Banking",
                        CheckLine."Account Category"::"Specialty Savings":
                                begin

                                    CustRecord.Reset;
                                    CustRecord.SetRange("ID No.", CheckLine."Upload ID");
                                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                    CustRecord.SetRange("Customer Type", CustRecord."Customer Type"::Individual);
                                    if CustRecord.Find('-') then begin

                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CustRecord."No.");
                                        AccBanking.SetRange("Account Category", CheckLine."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
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
                                            CheckLine.Modify(true)
                                        end;
                                    end;
                                end;
                        end;
                    end else begin

                        Loans.Reset();
                        Loans.SetRange("No.", CheckLine."Loan No.");
                        if Loans.FindFirst() then begin
                            Loans.CalcFields("Outstanding Balance");

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

                            if CustRecord.Get(Loans."Account No.") then begin
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
                                CheckLine.Modify(true)
                            end;
                        end;
                    end;
                end;
            3:
                begin
                    if CheckLine."Loan No." = '' then begin

                        case CheckLine."Account Category" of
                            CheckLine."Account Category"::Other,
                                CheckLine."Account Category"::"Registration Fee",
                                    CheckLine."Account Category"::"Shares Capital",
                                    CheckLine."Account Category"::"Shares Deposit",
                                    CheckLine."Account Category"::"Benevolent Fund",
                                    CheckLine."Account Category"::Insurance:
                                begin

                                    CustRecord.Reset;
                                    CustRecord.SetRange("Payroll/Staff No.", CheckLine."Upload ID");
                                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                    CustRecord.SetRange("Customer Type", CustRecord."Customer Type"::Individual);
                                    if CustRecord.Find('-') then begin

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
                                            CheckLine.Modify(true)
                                        end;
                                    end;
                                end;


                            CheckLine."Account Category"::"Money Market",
                            CheckLine."Account Category"::"Islamic Banking",
                        CheckLine."Account Category"::"Specialty Savings":
                                begin

                                    CustRecord.Reset;
                                    CustRecord.SetRange("Payroll/Staff No.", CheckLine."Upload ID");
                                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                                    CustRecord.SetRange("Customer Type", CustRecord."Customer Type"::Individual);
                                    if CustRecord.Find('-') then begin

                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", CustRecord."No.");
                                        AccBanking.SetRange("Account Category", CheckLine."Account Category");
                                        if AccBanking.FindFirst() then begin

                                            CheckLine."Account No." := AccBanking."No.";
                                            CheckLine.Name := AccBanking.Name;
                                            CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
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
                                            CheckLine.Modify(true)
                                        end;
                                    end;
                                end;
                        end;
                    end else begin


                        Loans.Reset();
                        Loans.SetRange("No.", CheckLine."Loan No.");
                        if Loans.FindFirst() then begin
                            Loans.CalcFields("Outstanding Balance");

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

                            if CustRecord.Get(Loans."Account No.") then begin
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
                                CheckLine.Modify(true)
                            end;
                        end;
                    end;
                end;
        end;
    end;

    procedure ValidateReceiptProdType(CheckLine: Record "Checkoff Receipt Lines"; Responce: Integer; ApplicType: Enum CheckoffTypes)
    var
        CustRecord: Record Member;
        RepayAcc: Record "Repayment Account";
        CredAccount: Record "Account Credit";
        AccBanking: Record "Account Banking";
        Loans: Record Loans;
    begin

        case
        Responce of
            0,
               4:
                begin
                    Error('Option not applicable')
                end;
            1:
                begin

                    CustRecord.Reset;
                    CustRecord.SetRange("No.", CheckLine."Upload ID");
                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                    if CustRecord.Find('-') then begin
                        CheckLine.Name := CustRecord.Name;
                        CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                        CheckLine."Member No." := CustRecord."No.";
                        CheckLine."ID No." := CustRecord."ID No.";
                        CheckLine.Status := CustRecord.Status;
                    end;
                end;
            2:
                begin
                    CustRecord.Reset;
                    CustRecord.SetRange("ID No.", CheckLine."Upload ID");
                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                    if CustRecord.Find('-') then begin
                        CheckLine.Name := CustRecord.Name;
                        CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                        CheckLine."Member No." := CustRecord."No.";
                        CheckLine."ID No." := CustRecord."ID No.";
                        CheckLine.Status := CustRecord.Status;

                    end;
                end;
            3:
                begin
                    CustRecord.Reset;
                    CustRecord.SetRange("Payroll/Staff No.", CheckLine."Upload ID");
                    CustRecord.SetRange("Employer Code", CheckLine."Employer Code");
                    if CustRecord.Find('-') then begin
                        CheckLine.Name := CustRecord.Name;
                        CheckLine."Payroll/Staff No." := CustRecord."Payroll/Staff No.";
                        CheckLine."Member No." := CustRecord."No.";
                        CheckLine."ID No." := CustRecord."ID No.";
                        CheckLine.Status := CustRecord.Status;
                    end;
                end;
        end;

        /// Start
        case CheckLine."Account Category" of
            CheckLine."Account Category"::Loan:
                begin

                    Loans.Reset();
                    Loans.SetFilter("Outstanding Balance", '>0');
                    Loans.SetRange("Account No.", CheckLine."Member No.");
                    Loans.SetRange("Product Type", CheckLine."Product Type");
                    if Loans.FindFirst() then begin
                        Loans.CalcFields("Outstanding Balance");
                        CheckLine."Loan No." := Loans."No.";
                        CheckLine."Account Dimension" := CheckLine."Account Dimension"::Loan;
                        CheckLine.Validate("Product Type", Loans."Product Type");
                        CheckLine."Account Found" := true;
                        CheckLine."Line Validated" := true;
                    end;

                end else begin
                CredAccount.Reset();
                CredAccount.SetRange("Member No.", CheckLine."Member No.");
                CredAccount.SetRange("Product Type", CheckLine."Product Type");
                if CredAccount.FindFirst() then begin

                    CheckLine.Blocked := CredAccount.Blocked;
                    CheckLine."Account Category" := CredAccount."Account Category";
                    CheckLine."Repayment Account" := getPrepaymentAc(CredAccount."Member No.");
                    CheckLine."Account Dimension" := CredAccount."Account Dimension";
                    CheckLine.Validate("Product Type", CredAccount."Product Type");
                    CheckLine."Account Found" := true;
                    CheckLine."Line Validated" := true;

                end else begin

                    AccBanking.Reset();
                    AccBanking.SetRange("Member No.", CheckLine."Member No.");
                    AccBanking.SetRange("Product Type", CheckLine."Product Type");
                    if AccBanking.FindFirst() then begin

                        CheckLine.Status := AccBanking.Status;
                        CheckLine.Blocked := AccBanking.Blocked;
                        CheckLine."Account Category" := AccBanking."Account Category";
                        CheckLine."Repayment Account" := getPrepaymentAc(AccBanking."Member No.");
                        CheckLine."Account No." := AccBanking."No.";
                        CheckLine."Account Dimension" := AccBanking."Account Dimension";
                        CheckLine.Validate("Product Type", AccBanking."Product Type");
                        CheckLine."Account Found" := true;
                        CheckLine."Line Validated" := true;
                    end;
                end;
            end;
        end;
        CheckLine.Modify(true)

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
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        Purchline: Record "Checkoff Receipt Lines";
        JnPost: Codeunit "Journal Post Mngt.";
        ErrorOnNotAccountFound: Label 'Member No. %1 have no existing %2 found.';
        Text016: Label 'You cannot Post %1-%2 because there is at least one posted entry related to this transaction.';
        ErrorOnNotApprovedApplic: Label 'This application not yet approved. Kindly have the document approved before you can continue';
        Notif: Codeunit "SMS Notification";

}
