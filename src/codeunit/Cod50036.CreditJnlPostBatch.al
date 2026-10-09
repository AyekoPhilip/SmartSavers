codeunit 50036 "Credit. Jnl.-Post Batch"
{
    TableNo = "Loan Disbursement Header";

    trigger OnRun()
    begin
        RunWithCheck(Rec)
    end;

    procedure RunWithCheck(var DisbursementHeader2: Record "Loan Disbursement Header")
    begin
        DisbursementHeader.Copy(DisbursementHeader2);
        Code(DisbursementHeader, true);
        DisbursementHeader2 := DisbursementHeader
    end;

    procedure RunWithoutCheck(var DisbursementHeader2: Record "Loan Disbursement Header")
    begin
        DisbursementHeader.Copy(DisbursementHeader2);
        Code(DisbursementHeader, false);
        DisbursementHeader2 := DisbursementHeader
    end;

    local procedure InitJournalTemplate()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Jtemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        JnPost.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;

    procedure "Code"(var RecRef: Record "Loan Disbursement Header"; CheckLine: Boolean)
    var
        Loans: Record Loans;
    begin

        InitJournalTemplate();
        RecRef.TestField("Posting Date");

        case RecRef."Posting Type" of
            RecRef."Posting Type"::"Post Application":
                RecRef.TestField("Approval Status", RecRef."Approval Status"::Approved);
        end;

        case RecRef."Payment Type" of
            RecRef."Payment Type"::Loans:
                begin

                    RecRef.TestField(Date);
                    RecRef.TestField(Remarks);
                    Loans.Reset;
                    Loans.SetRange("Batch No.", RecRef."No.");
                    Loans.SetFilter("Approved Amount", '>0');
                    Loans.SetRange("Approval Status", Loans."Approval Status"::Approved);
                    if Loans.Find('-') then begin
                        repeat
                            InitJournalTemplate();
                            Codeunit.Run(Codeunit::"Loan Post Mngt. (Yes/No)", Loans)
                        until Loans.Next = 0;
                    end;
                end;
            RecRef."Payment Type"::Refund:
                begin

                    Purchline.Reset;
                    Purchline.SetRange(No, RecRef."No.");
                    Purchline.SetRange(Posted, false);
                    if Purchline.FindSet() then begin
                        repeat
                            InitJournalTemplate();
                            if not InitGenlPostMgt.ValuePost(Purchline.No, Purchline.No,
                                Purchline."Member No.", Enum::"Gen. Journal Source Type"::Savings) then begin
                                PurchLineNoPriority(Purchline, RecRef."Posting Date", RecRef.Remarks, Purchline."Default Account No.");

                                case RecRef."Posting Type" of
                                    RecRef."Posting Type"::"Post Application":
                                        begin
                                            Post.CompletePosting(Jtemplate, JBatch);
                                            Commit();

                                            Purchline.Validate(Posted, true);
                                            Purchline.Validate("Posted By", UserId);
                                            Purchline.Validate("Date Posted", Today);
                                            Purchline.Validate("Time Posted", Time);
                                            Purchline.Modify(true)
                                        end;
                                end;
                            end;
                        until Purchline.Next() = 0;
                    end;
                    case RecRef."Posting Type" of
                        RecRef."Posting Type"::"Post Application":
                            begin
                                OnCompletePostMgt(0, RecRef."No.");
                            end else begin
                            VarVariant := RecRef;
                            Commit();
                            Docx.DocPrintstatement(VarVariant, 0);
                        end;
                    end;
                end;
        end
    end;

    procedure CreateBatchLine(HeaderNo: Code[50]; BatchType: Enum BatchPaymentType; AccountNo: Code[100]; ProducType: Code[20]; Dim1: Code[10]; Dim2: Code[10])
    var
        BatchLine:
            Record "Loan Disbursement Lines";
    begin

        case BatchType of
            BatchType::Refund:
                begin

                    BatchLine.Reset();
                    BatchLine.SetRange(No, HeaderNo);
                    BatchLine.DeleteAll();

                    RepayAcc.Reset();
                    RepayAcc.SetRange(Status, RepayAcc.Status::Active);
                    RepayAcc.SetFilter("Balance (LCY)", '>0');
                    if RepayAcc.FindSet() then begin
                        ProgressWindow.Open(PayrollDialog);
                        repeat
                            RepayAcc.CalcFields("Balance (LCY)");

                            Sleep(100);
                            ProgressWindow.Update(1, RepayAcc."No." + '::' + RepayAcc.Name);

                            AccBanking.Reset();
                            AccBanking.SetRange("Member No.", RepayAcc."Member No.");
                            AccBanking.SetRange("Product Type", ProducType);
                            if AccBanking.FindFirst() then begin

                                LoanDisbLine.Init();
                                LoanDisbLine.No := HeaderNo;
                                LoanDisbLine."Line No." := RegMgt.InitNextLineEntryNo;
                                LoanDisbLine."Account No." := RepayAcc."No.";
                                LoanDisbLine."Account Name" := RepayAcc.Name;
                                LoanDisbLine.Amount := RepayAcc."Balance (LCY)";
                                LoanDisbLine."Default Account No." := AccBanking."No.";
                                LoanDisbLine."Member No." := AccBanking."Member No.";
                                LoanDisbLine."Global Dimension 1 Code" := Dim1;
                                LoanDisbLine."Global Dimension 2 Code" := Dim2;
                                LoanDisbLine.Insert(true)
                            end;
                        until RepayAcc.Next() = 0;
                        ProgressWindow.Close();
                    end;

                end;
        end;
    end;

    local procedure PurchLineNoPriority(Checkline: Record "Loan Disbursement Lines"; PostingDate: Date; TextDescription: Text[150]; DefAccountNo: Code[100])
    var
        BatchHeader: Record "Loan Disbursement Header";
        RunBal: Decimal;
        BalAccNo: Code[100];
        AccType: Enum "Gen. Journal Account Type";
    begin

        BatchHeader.Get(Checkline.No);
        RunBal := 0;
        BalAccNo := '';
        RunBal := Checkline.Amount;
        RepayAcc.Reset();
        RepayAcc.SetRange("No.", Checkline."Account No.");
        if RepayAcc.FindFirst() then begin
            RepayAcc.CalcFields("Balance (LCY)");
            if RepayAcc."Balance (LCY)" > 0 then begin

                Linenum := Linenum + 1000;
                InitGenlPostMgt.CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2,
                Checkline.Amount, PostingDate, Checkline.No, Checkline."Member No.", Checkline."Account No.",
                Enum::"Gen. Journal Account Type"::Vendor, TextDescription, '', Enum::"LoanTransactionType"::" ");


                AccCred.Reset;
                AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Capital");
                AccCred.SetRange("Member No.", Checkline."Member No.");
                if AccCred.Find('-') then begin
                    if PostCheckMgt.getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > 0 then begin
                        if BatchHeader."Enforce Min. Share Rule" then begin

                            if RunBal > 0 then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitPost.InitCreditEntry(AccCred, GenJournal, 0);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := Checkline.No;
                                GenJournal.Validate("Account No.", AccCred."No.");
                                if PostCheckMgt.getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") > RunBal then
                                    GenJournal.Validate(Amount, RunBal * -1) else
                                    GenJournal.Validate(Amount, PostCheckMgt.getAccountMinBalance(AccCred."Member No.", AccCred."Product Type") * -1);
                                GenJournal.Description := CopyStr(Format(AccCred."Account Category") + '-' + TextDescription, 1, 100);
                                GenJournal."External Document No." := Checkline."Member No.";
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                RunBal := RunBal - Abs(GenJournal.Amount);
                            end;
                        end;
                    end;
                end;

                if BatchHeader."Enforce Perform Loan Rule" then begin

                    PLoans.Reset;
                    PLoans.SetRange("Account No.", Checkline."Member No.");
                    PLoans.SetFilter("Outstanding Insurance", '>0');
                    if PLoans.Find('-') then begin
                        repeat

                            PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                            "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
                            if LoanCatgt.Get(PLoans."No.") then begin
                                if LoanCatgt."Amount In Arrears" > 0 then begin

                                    if RunBal > 0 then begin

                                        GenJournal.LockTable;
                                        Linenum := Linenum + 1000;
                                        PostPeriodic.InitializeDebitEntry(PLoans,
                                        GenJournal, 0, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        Enum::"LoanTransactionType"::"Insurance Paid");
                                        GenJournal."Line No." := Linenum;
                                        GenJournal."Journal Template Name" := Jtemplate;
                                        GenJournal."Journal Batch Name" := JBatch;
                                        GenJournal."Posting Date" := PostingDate;
                                        GenJournal."Document No." := Checkline.No;
                                        if PLoans."Outstanding Insurance" > RunBal then
                                            GenJournal.Validate(Amount, RunBal * -1) else
                                            GenJournal.Validate(Amount, PLoans."Outstanding Insurance" * -1);
                                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                        GenJournal.Validate("Loan No.", PLoans."No.");
                                        if GenJournal.Amount <> 0 then
                                            GenJournal.Insert(true);
                                        RunBal := RunBal - Abs(GenJournal.Amount);
                                    end
                                end
                            end
                        until PLoans.Next = 0;
                    end;

                    PLoans.Reset;
                    PLoans.SetRange("Account No.", Checkline."Member No.");
                    PLoans.SetFilter("Outstanding Interest", '>0');
                    if PLoans.Find('-') then begin
                        repeat

                            PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                            "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
                            if LoanCatgt.Get(PLoans."No.") then begin
                                if LoanCatgt."Amount In Arrears" > 0 then begin

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
                                        GenJournal."Document No." := Checkline.No;
                                        if PLoans."Outstanding Interest" > RunBal then
                                            GenJournal.Validate(Amount, RunBal * -1) else
                                            GenJournal.Validate(Amount, PLoans."Outstanding Interest" * -1);
                                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                        GenJournal.Validate("Loan No.", PLoans."No.");
                                        if GenJournal.Amount <> 0 then
                                            GenJournal.Insert(true);
                                        RunBal := RunBal - Abs(GenJournal.Amount);
                                    end
                                end
                            end
                        until PLoans.Next = 0;
                    end;

                    PLoans.Reset;
                    PLoans.SetRange("Account No.", Checkline."Member No.");
                    PLoans.SetFilter("Outstanding Bill", '>0');
                    if PLoans.Find('-') then begin
                        repeat

                            PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                            "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
                            if LoanCatgt.Get(PLoans."No.") then begin
                                if LoanCatgt."Amount In Arrears" > 0 then begin

                                    if RunBal > 0 then begin

                                        GenJournal.LockTable;
                                        Linenum := Linenum + 1000;
                                        PostPeriodic.InitializeDebitEntry(PLoans,
                                        GenJournal, 0, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        Enum::"LoanTransactionType"::"Penalty Paid");
                                        GenJournal."Line No." := Linenum;
                                        GenJournal."Journal Template Name" := Jtemplate;
                                        GenJournal."Journal Batch Name" := JBatch;
                                        GenJournal."Posting Date" := PostingDate;
                                        GenJournal."Document No." := Checkline.No;
                                        if PLoans."Outstanding Bill" > RunBal then
                                            GenJournal.Validate(Amount, RunBal * -1) else
                                            GenJournal.Validate(Amount, PLoans."Outstanding Bill" * -1);
                                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                        GenJournal.Validate("Loan No.", PLoans."No.");
                                        if GenJournal.Amount <> 0 then
                                            GenJournal.Insert(true);
                                        RunBal := RunBal - Abs(GenJournal.Amount);
                                    end
                                end
                            end
                        until PLoans.Next = 0;
                    end;

                    PLoans.Reset;
                    PLoans.SetRange("Account No.", Checkline."Member No.");
                    PLoans.SetFilter("Outstanding Principal", '>0');
                    if PLoans.Find('-') then begin
                        repeat

                            PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                            "Outstanding Interest", "Outstanding Balance", "Outstanding Insurance");
                            if LoanCatgt.Get(PLoans."No.") then begin
                                if LoanCatgt."Amount In Arrears" > 0 then begin

                                    if RunBal > 0 then begin

                                        GenJournal.LockTable;
                                        Linenum := Linenum + 1000;
                                        PostPeriodic.InitializeDebitEntry(PLoans,
                                        GenJournal, 0, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                        Enum::"LoanTransactionType"::Repayment);
                                        GenJournal."Line No." := Linenum;
                                        GenJournal."Journal Template Name" := Jtemplate;
                                        GenJournal."Journal Batch Name" := JBatch;
                                        GenJournal."Posting Date" := PostingDate;
                                        GenJournal."Document No." := Checkline.No;
                                        if PLoans."Outstanding Principal" > RunBal then
                                            GenJournal.Validate(Amount, RunBal * -1) else
                                            GenJournal.Validate(Amount, PLoans."Outstanding Principal" * -1);
                                        GenJournal.Description := CopyStr(Format(GenJournal."Transaction Type") + '-' + TextDescription, 1, 100);
                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                        GenJournal.Validate("Loan No.", PLoans."No.");
                                        if GenJournal.Amount <> 0 then
                                            GenJournal.Insert(true);
                                        RunBal := RunBal - Abs(GenJournal.Amount);
                                    end
                                end
                            end
                        until PLoans.Next = 0;
                    end;
                end;

                if RunBal > 0 then begin

                    case BatchHeader."Account Type" of

                        BatchHeader."Account Type"::"Bank Account",
                        BatchHeader."Account Type"::Vendor:
                            begin
                                BalAccNo := BatchHeader."Account No.";
                                AccType := BatchHeader."Account Type"
                            end;

                        BatchHeader."Account Type"::Saving:
                            begin
                                AccType := AccType::Vendor;
                                BalAccNo := DefAccountNo
                            end;
                    end;

                    Linenum := Linenum + 1000;
                    InitGenlPostMgt.CreateBalancingAcc(Linenum, Jtemplate, JBatch, Dim1, Dim2,
                    RunBal * -1, PostingDate, Checkline.No, Checkline."Member No.", BalAccNo,
                    AccType, TextDescription, '', Enum::"LoanTransactionType"::" ");
                end
            end
        end
    end;

    local procedure OnCompletePostMgt(Variantext: Integer; DocNo: Code[100])
    var
        RecRef: Record "Loan Disbursement Header";
        UnsupportedRecordTypeErr: Label 'Action Item %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';

    begin
        if RecRef.Get(DocNo) then begin
            RecRef."Date Posted" := CurrentDateTime;
            RecRef."Posted By" := UserId;
            RecRef.Posted := true;
            RecRef."Approval Status" := RecRef."Approval Status"::Posted;
            RecRef.Modify;
            Message(OnCompleteDialogTxt);
        end;
    end;

    local procedure PostAltChannelReversal(DocumentNo: Code[50]) Response: Text[150]
    var

        GLRegister: Record "G/L Register";
        ReversalEntry: Record "Reversal Entry";
        Text003: Label '00|Success The entries were successfully reversed.';
        Text004: Label '99|Failed The entries reversal failed.';
        Text005: Label '99|Failed No related entries found.';
        Text006: Label '99|Failed Null value posted.';
        BnkLedgerEntry: Record "Bank Account Ledger Entry";
        Trans: Record "ATM Transaction";

    begin
        if DocumentNo <> '' then begin

            GLRegister.Reset();
            GLRegister.SetRange(Reversed, false);
            GLRegister.SetRange("Document No.", DocumentNo);

            if GLRegister.Find('-') then begin
                GLRegister.TestField(GLRegister."No.");
                ReversalEntry.SetHideDialog(true);
                ReversalEntry.SetHideWarningDialogs();
                ReversalEntry.ReverseRegister(GLRegister."No.");
            end else begin
                Response := Text005;
                exit(Response)
            end;
        end else begin
            Response := Text006;
            exit(Response)
        end;
    end;

    procedure CreateReverseLine(HeaderNo: Code[50]; BatchType: Enum BatchPaymentType; AccountNo: Code[100]; ProducType: Code[20]; Dim1: Code[10]; Dim2: Code[10]; ObjectTypeTxt: Enum BCObjectTypes)
    var
        BatchLine: Record "Loan Disbursement Lines";
        CheckLine: Record "Checkoff Receipt Lines";
        IntLine: Record "Interest Line";
        ReverseDialog: Label 'Reverse entries for Account No. #1#######';
    begin

        case ObjectTypeTxt of
            ObjectTypeTxt::System:
                begin
                    case BatchType of
                        BatchType::Refund:
                            begin

                                BatchLine.Reset();
                                BatchLine.SetRange(No, HeaderNo);
                                BatchLine.SetRange(Posted, true);
                                BatchLine.SetRange("Line Status", BatchLine."Line Status"::Application);
                                if BatchLine.FindSet() then begin
                                    ProgressWindow.Open(PayrollDialog);
                                    repeat
                                        Sleep(100);
                                        ProgressWindow.Update(1, BatchLine."Account No." + '::' + BatchLine."Account Name");
                                        PostAltChannelReversal(BatchLine.No);
                                        Commit();
                                        BatchLine."Line Status" := BatchLine."Line Status"::Reversed;
                                        BatchLine.Modify(true)
                                    until BatchLine.Next() = 0;
                                    ProgressWindow.Close();
                                end;
                            end;
                        BatchType::Interest:
                            begin
                                IntLine.Reset();
                                IntLine.SetRange(No, HeaderNo);
                                IntLine.SetRange(Posted, true);
                                IntLine.SetRange("Line Status", IntLine."Line Status"::Application);
                                if IntLine.FindSet() then begin
                                    ProgressWindow.Open(PayrollDialog);
                                    repeat
                                        Sleep(100);
                                        ProgressWindow.Update(1, IntLine."Loan No." + '::' + IntLine."Account No");
                                        PostAltChannelReversal(IntLine.No);
                                        Commit();
                                        IntLine."Line Status" := IntLine."Line Status"::Reversed;
                                        IntLine.Modify(true)
                                    until IntLine.Next() = 0;
                                    ProgressWindow.Close();
                                end;
                            end;
                    end;
                end;

            ObjectTypeTxt::Execution:
                begin
                    CheckLine.Reset();
                    CheckLine.SetRange("No.", HeaderNo);
                    CheckLine.SetRange(Posted, true);
                    if CheckLine.FindSet() then begin
                        ProgressWindow.Open(PayrollDialog);
                        repeat
                            Sleep(100);
                            ProgressWindow.Update(1, CheckLine."Account No." + '::' + CheckLine.Name);
                            PostAltChannelReversal(CheckLine."No.");
                            Commit();
                            CheckLine."Approval Status" := CheckLine."Approval Status"::Reversed;
                            CheckLine.Modify(true)
                        until CheckLine.Next() = 0;
                        ProgressWindow.Close();
                    end;

                end;
        end;






    end;


    var
        DisbursementHeader: Record "Loan Disbursement Header";
        ErrOnNotApprovedDocTxt: Label 'Application %1 is not fully approved';
        JnlPostline: Codeunit "Gen.Jnl.-Post Line";
        RepayAcc: Record "Repayment Account";
        AccBanking: Record "Account Banking";
        OnCompleteDialogTxt: Label 'Application successfully posted.';
        LoanDisbLine: Record "Loan Disbursement Lines";
        ProgressWindow: Dialog;
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        PLoans: Record Loans;
        LoanCatgt: Record "Loans Categorization";
        PayrollDialog: Label 'Generating Refunds for Account No. #1#######';
        LoanPostMgt: Codeunit "Loan Post Mngt. (Yes/No)";
        GeneralSetUp: Record "General Set-Up";
        InterestEntry: Record "Interest Line";
        InterestProgEntry: Record "Loan Progression Lines";
        InitPost: Codeunit "Initialize Gen. Jnl.-Post";
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
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
        JnPost: Codeunit "Journal Post Mngt.";
        Purchline: Record "Loan Disbursement Lines";
        PostCheckMgt: Codeunit "Post. Checkoff Mngt.";
        InitGenlPostMgt: Codeunit "Initialize Gen. Jnl.-Post";
        AccCred: Record "Account Credit";
}




