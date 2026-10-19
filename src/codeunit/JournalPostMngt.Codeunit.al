codeunit 50044 "Journal Post Mngt."
{

    trigger OnRun()
    begin
    end;

    var
        GenJnl: Record "Gen. Journal Line";
        LoanInt: Record "Buffer Lines";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";

    procedure PostJournal(Template: Code[20]; BatchName: Code[20]; LineNo: Integer; AcctType: Enum "Gen. Journal Account Type"; DocNo: Code[20]; Descr: Text[100]; Amount: Decimal; AccNo: Code[20]; PostingDate: Date; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; ExtDocNo: Code[20]; Dim1: Code[20]; Dim2: Code[20]; TransactionType: Enum "LoanTransactionType"; LoanNo: Code[20]; GroupCode: Code[20]; AppliesToDocNo: Code[20]; DocType: Enum "Gen. Journal Document Type"; CurrCode: Code[20]; AppliesToDocType: Enum "Gen. Journal Document Type")
    var
        GenBatches: Record "Gen. Journal Batch";
    begin
        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", Template);
        GenBatches.SetRange(GenBatches.Name, BatchName);
        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := Template;
            GenBatches.Name := BatchName;
            GenBatches.Description := Descr;
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;

        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := BatchName;
        GenJnl."Line No." := LineNo;
        GenJnl."Account Type" := AcctType;
        GenJnl."Document No." := CopyStr(DocNo, 1, 20);
        GenJnl."Posting Date" := PostingDate;
        GenJnl.Validate("Account No.", AccNo);
        GenJnl.Description := Descr;
        GenJnl.Validate("Currency Code", CurrCode);
        GenJnl.Validate(GenJnl.Amount, Amount);
        GenJnl."Bal. Account Type" := BalAccType;
        GenJnl.Validate(GenJnl."Bal. Account No.", BalAccNo);
        GenJnl.Validate("Loan No.", LoanNo);
        GenJnl."Transaction Type" := TransactionType;
        GenJnl."Applies-to Doc. No." := AppliesToDocNo;
        GenJnl."External Document No." := CopyStr(ExtDocNo, 1, 20);
        GenJnl.Validate(GenJnl."Applies-to Doc. No.");
        GenJnl."Document Type" := DocType;
        GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code", Dim1);
        GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code", Dim2);
        GenJnl."Applies-to Doc. Type" := AppliesToDocType;
        if GenJnl.Amount <> 0 then
            GenJnl.Insert(true);
    end;

    procedure CreateJnl(Template: Code[20]; BatchName: Code[20]; LineNo: Integer; AcctType: Enum "Gen. Journal Account Type"; DocNo: Code[20]; Descr: Text[100]; Amount: Decimal; AccNo: Code[20]; PostingDate: Date; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; ExtDocNo: Code[20]; Dim1: Code[20]; Dim2: Code[20]; TransactionType: Enum "LoanTransactionType"; LoanNo: Code[20]; GroupCode: Code[10]; AppliesToDocNo: Code[20]; DocType: Enum "Gen. Journal Document Type"; CurrCode: Code[20]; AppliesToDocType: Enum "Gen. Journal Document Type"; SourceNo: Code[20])
    var
        GenBatches: Record "Gen. Journal Batch";
    begin
        GenBatches.Reset;
        GenBatches.SetRange(GenBatches."Journal Template Name", Template);
        GenBatches.SetRange(GenBatches.Name, BatchName);
        if GenBatches.Find('-') = false then begin
            GenBatches.Init;
            GenBatches."Journal Template Name" := Template;
            GenBatches.Name := BatchName;
            GenBatches.Description := Descr;
            GenBatches.Validate(GenBatches."Journal Template Name");
            GenBatches.Validate(GenBatches.Name);
            GenBatches.Insert;
        end;

        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := BatchName;
        GenJnl."Line No." := LineNo;
        GenJnl."Account Type" := AcctType;
        GenJnl."Document No." := CopyStr(DocNo, 1, 20);
        GenJnl."Posting Date" := PostingDate;
        GenJnl.Validate(GenJnl."Account No.", AccNo);
        GenJnl.Description := Descr;
        GenJnl.Validate("Currency Code", CurrCode);
        GenJnl.Validate(GenJnl.Amount, Amount);
        GenJnl."Bal. Account Type" := BalAccType;
        GenJnl.Validate(GenJnl."Bal. Account No.", BalAccNo);
        GenJnl.Validate("Loan No.", LoanNo);
        GenJnl."Transaction Type" := TransactionType;
        GenJnl."External Document No." := CopyStr(ExtDocNo, 1, 20);
        GenJnl.Validate(GenJnl."Applies-to Doc. No.", AppliesToDocNo);
        GenJnl."Document Type" := DocType;
        GenJnl.Validate("Shortcut Dimension 1 Code", Dim1);
        GenJnl.Validate("Shortcut Dimension 2 Code", Dim2);
        GenJnl."Applies-to Doc. Type" := AppliesToDocType;
        GenJnl."Source No." := SourceNo;
        if GenJnl.Amount <> 0 then
            GenJnl.Insert(true);
    end;

    procedure CompletePostingAdjustJnl(Template: Code[20]; Batch: Code[20]; PayMode: Enum PaymentMode; CheckType: Enum ChequeType)
    begin

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", Template);
        GenJnl.SetRange("Journal Batch Name", Batch);
        if GenJnl.Find('-') then begin
            AdjustGenJnl.Run(GenJnl);
            if (PayMode = PayMode::Cheque) and (CheckType = CheckType::"Computer Check") then
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post (Yes/No)", GenJnl);
        end;
        if CheckType <> CheckType::"Computer Check" then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post (Yes/No)", GenJnl);
        end;
    end;



    procedure CompletePosting(Template: Code[20]; Batch: Code[20])
    begin
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", Template);
        GenJnl.SetRange("Journal Batch Name", Batch);
        if GenJnl.Find('-') then
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJnl);
    end;

    procedure ClearJournalLines(Template: Code[10]; Batch: Code[10])
    begin

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", Template);
        GenJnl.SetRange("Journal Batch Name", Batch);
        if GenJnl.FindSet() then
            GenJnl.DeleteAll;
    end;

    procedure LinesCompletePosting(Template: Code[20]; Batch: Code[20])
    begin
        GenJnl.Reset;
        GenJnl.SetRange(GenJnl."Journal Template Name", Template);
        GenJnl.SetRange(GenJnl."Journal Batch Name", Batch);
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJnl);
    end;


    procedure InsertIntoInterestLines(LineNo: Code[80]; MemberNo: Code[100]; LoanNo: Code[100]; LoanType: Code[50]; AccNo: Code[100]; AccType: Integer; Cashier: Code[100]; DateCaptured: Date; GlobalDim: Code[50]; ShortCutDim: Code[50]; IntAmt: Decimal; IntDate: Date; AccNoSusp: Code[100])
    begin

        LoanInt.Init;

        LoanInt.No := LineNo;
        LoanInt."Account No" := MemberNo;
        LoanInt."Loan No." := LoanNo;
        LoanInt."Loan Product type" := LoanType;
        LoanInt."Bal. Account No." := AccNo;
        LoanInt."Bal. Account Type" := AccType;
        LoanInt."Bal. Account No.(Suspended)" := AccNoSusp;
        LoanInt."User ID" := Cashier;
        LoanInt."Interest Amount" := IntAmt;
        LoanInt."Interest Date" := IntDate;
        LoanInt."Date Captured" := DateCaptured;
        LoanInt."Shortcut Dimension 1 Code" := GlobalDim;
        LoanInt."Shortcut Dimension 2 Code" := ShortCutDim;
        if LoanInt."Interest Amount" > 0 then
            LoanInt.Insert(true);
    end;


    procedure PostingRecurringJournals(Template: Code[20]; Batch: Code[20])
    var
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", Template);
        GenJnl.SetRange("Journal Batch Name", Batch);
        if GenJnl.Find('-') then begin
            repeat
                GLPosting.Run(GenJnl);
            until GenJnl.Next = 0;
        end;
    end;

    procedure getJournalLastLine(Template: Code[20]; Batchtemp: Code[20]): Integer
    var
        GenJournal: Record "Gen. Journal Line";
    begin
        GenJournal.Reset();
        GenJournal.SetCurrentKey("Line No.");
        GenJournal.Ascending(false);
        GenJournal.SetRange("Journal Template Name", Template);
        GenJournal.SetRange("Journal Batch Name", Batchtemp);
        if GenJournal.FindFirst() then begin
            exit(GenJournal."Line No.")
        end;
    end;
}




