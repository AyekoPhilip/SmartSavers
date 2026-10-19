codeunit 50038 "Gen.Jnl.-Post Periodic"
{

    TableNo = "Interest Header";

    trigger OnRun()
    begin
        RunWithCheck(Rec)
    end;

    var
        InterestHeader: Record "Interest Header";
        Temp: Record "Banking User Template";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Post: Codeunit "Journal Post Mngt.";
        Linenum: Integer;
        GeneralSetUp: Record "General Set-Up";
        GenJournal: Record "Gen. Journal Line";
        Loan: Record Loans;
        DocPostMgt: Codeunit "Doc-PostMgt";
        DepositAcc: Record "Account Credit";
        BenvAccount: Record "Account Credit";
        OnCompleteProcessTxt: Label 'Application successfully posted';
        InitGenjPost: Codeunit "Initialize Gen. Jnl.-Post";

    procedure RunWithCheck(var InterestHeader2: Record "Interest Header")
    begin
        InterestHeader.Copy(InterestHeader2);
        Code(InterestHeader, true, InterestHeader2."Posting Date", '');
        InterestHeader2 := InterestHeader
    end;

    procedure RunWithoutCheck(var InterestHeader2: Record "Interest Header")
    begin
        InterestHeader.Copy(InterestHeader2);
        Code(InterestHeader, false, InterestHeader2."Posting Date", '');
        InterestHeader2 := InterestHeader
    end;


    procedure "Code"(RecRef: Record "Interest Header"; CheckLine: Boolean; PostingDate: Date; HeaderNo: Code[20])
    var
        PurchLines: Record "Interest Line";
        Custmember: Record Member;
        PrIntPeriods: Record "Loan Interest Periods";
    begin

        RecRef.TestField(Posted, false);

        case RecRef."Application Type" of
            RecRef."Application Type"::"Ledger fee",
                RecRef."Application Type"::Insurance,
                    RecRef."Application Type"::"Loan Interest",
                    RecRef."Application Type"::"Interest+LedgerFee",
                    RecRef."Application Type"::"Interest+Insurance",
                    RecRef."Application Type"::"Interest or Ledger Fee",
                    RecRef."Application Type"::"Interest+Penalty":
                begin
                    RecRef.TestField("Posting Date");

                    PurchLines.Reset;
                    PurchLines.SetRange(No, RecRef."No.");
                    PurchLines.SetRange(Posted, false);
                    PurchLines.SetFilter(Amount, '>0');
                    if PurchLines.Find('-') then begin
                        repeat
                            PassDocumentNo;
                            if Loan.Get(PurchLines."Loan No.") then begin
                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitializeDebitEntry(Loan, GenJournal, 0, PurchLines."Bal. Account Type",
                                PurchLines."Bal. Account No.", PurchLines."Transaction Type");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := RecRef."Posting Date";
                                GenJournal."Document No." := RecRef."No.";
                                GenJournal.Validate(Amount, PurchLines.Amount);
                                GenJournal.Description := CopyStr(PurchLines.Description, 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                Post.CompletePosting(Jtemplate, JBatch);
                                Commit;
                                PurchLines.Posted := true;
                                PurchLines.Modify;
                            end;
                        until PurchLines.Next = 0;
                        DocPostMgt.fnIntPeriodClosure(RecRef."Start Date",
                        RecRef."End Date", RecRef."No.",RecRef."Application Type");
                        RecRef.Posted := true;
                        RecRef."Posted By" := UserId;
                        RecRef."Time Posted" := Time;
                        RecRef."Date Posted" := Today;
                        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
                        RecRef.Modify;
                        Message(OnCompleteProcessTxt);
                    end;
                end;
            RecRef."Application Type"::"Benevolent Recovery":
                begin
                    PurchLines.Reset;
                    PurchLines.SetRange(No, RecRef."No.");
                    PurchLines.SetRange(Posted, false);
                    PurchLines.SetFilter(Amount, '>0');
                    if PurchLines.Find('-') then begin
                        repeat
                            PassDocumentNo;
                            if DepositAcc.Get(PurchLines."Account No") then begin

                                GenJournal.LockTable;
                                Linenum := Linenum + 1000;
                                InitGenjPost.InitCreditEntry(DepositAcc, GenJournal, Linenum);
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := RecRef."Posting Date";
                                GenJournal."Document No." := RecRef."No.";
                                GenJournal.Validate(Amount, PurchLines.Amount);
                                GenJournal.Description := CopyStr(PurchLines.Description, 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                                if BenvAccount.Get(PurchLines."Bal. Account No.") then begin
                                    Linenum := Linenum + 1000;
                                    InitGenjPost.InitCreditEntry(BenvAccount, GenJournal, Linenum);
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := RecRef."Posting Date";
                                    GenJournal."Document No." := RecRef."No.";
                                    GenJournal.Validate(Amount, PurchLines.Amount * -1);
                                    GenJournal.Description := CopyStr(PurchLines.Description, 1, 50);
                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);
                                end;

                                Post.CompletePosting(Jtemplate, JBatch);
                                Commit;
                                PurchLines.Posted := true;
                                PurchLines.Modify;
                            end;
                        until PurchLines.Next = 0;
                        RecRef.Posted := true;
                        RecRef."Posted By" := UserId;
                        RecRef."Time Posted" := Time;
                        RecRef."Date Posted" := Today;
                        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
                        RecRef.Modify;
                        Message(OnCompleteProcessTxt);
                    end;
                end;
        end;
    end;

    local procedure PassDocumentNo()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Bills Template");
        Temp.TestField("Bills Batch");
        Jtemplate := Temp."Bills Template";
        JBatch := Temp."Bills Batch";
        Post.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;


    procedure InitializeDebitEntry(Loan: Record Loans; var RecRef: Record "Gen. Journal Line"; LineNo: Integer; BalAcType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20]; TransType: Enum "LoanTransactionType")
    begin
        RecRef.Init;
        RecRef.CopyFromLoan(Loan);
        RecRef."Bal. Account Type" := BalAcType;
        RecRef."Bal. Account No." := BalAccNo;
        RecRef."Transaction Type" := TransType;
        OnAfterInitDebitEntry(RecRef, Loan);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDebitEntry(var GenJournalLine: Record "Gen. Journal Line"; Loans: Record Loans)
    begin
    end;
}




