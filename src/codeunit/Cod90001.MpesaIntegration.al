codeunit 90001 "Mpesa Integration"
{
    trigger OnRun()
    begin
        PostC2BTransactions();
    end;

    local procedure GetMemberNo(RefrenceNo: Code[20]) MemberNo: Code[20]
    var
        Members: Record Member;
    begin
        if Members.get(RefrenceNo) then
            exit(Members."No.");
        Members.Reset();
        Members.SetRange("ID No.", RefrenceNo);
        if Members.FindFirst() then
            exit(Members."No.");
        exit('NaN');
    end;

    local procedure isJournalBalancing(JournalTemplate: Code[20]; JournalBatch: Code[20]) Balanced: Boolean
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        GenJournalLine.SetFilter("Account No.", '<>%1', '');
        if GenJournalLine.FindSet() then begin
            GenJournalLine.CalcSums(Amount);
            exit(GenJournalLine.Amount = 0);
        end else
            exit(false);
    end;

    local procedure isDocumentPosted(DocumentNo: Code[20]) Posted: Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.Reset();
        GLEntry.SetRange("Document No.", DocumentNo);
        GLEntry.SetRange(Reversed, false);
        if GLEntry.FindSet() then
            exit(true);
        GLEntry.Reset();
        GLEntry.SetRange("External Document No.", DocumentNo);
        GLEntry.SetRange(Reversed, false);
        if GLEntry.FindSet() then
            exit(true);
        exit(false);
    end;

    procedure ConstructPostingAccounts(DocumentNo: Code[20]; var DebitAccount: Code[20]; var CreditAccount: Code[20]; var LoanNo: Code[20])
    var
        BankAccount: Record "Bank Account";
        KeyWordSetup: Record "Keyword Setup";
        SavingsAccount: Record "Account Credit";
        Loans: Record Loans;
        Refrence, KeyWord, MemberNo : Code[20];
        MpesaEntryLocal: Record "MPESA Transactions";
    begin
        DebitAccount := '';
        CreditAccount := '';
        LoanNo := '';
        if MpesaEntryLocal.get(DocumentNo) then begin
            BankAccount.Reset();
            BankAccount.SetRange("Bank Account No.", MpesaEntryLocal."Paybil Number");
            BankAccount.SetRange(Blocked, false);
            if BankAccount.FindFirst() then
                DebitAccount := BankAccount."No.";
            if StrLen(MpesaEntryLocal."Account No.") > 3 then begin
                KeyWord := '';
                Refrence := '';
                MemberNo := '';
                KeyWord := CopyStr(MpesaEntryLocal."Account No.", StrLen(MpesaEntryLocal."Account No.") - 2, 3);
                Refrence := CopyStr(MpesaEntryLocal."Account No.", 1, StrLen(MpesaEntryLocal."Account No.") - 3);
                MemberNo := GetMemberNo(Refrence);
                if KeyWordSetup.Get(KeyWord) then begin
                    case KeyWordSetup."Post-To Account Type" of
                        KeyWordSetup."Post-To Account Type"::"Loan Account":
                            begin
                                Loans.Reset();
                                Loans.SetFilter("Outstanding Balance", '>0');
                                Loans.SetRange("Product Type", KeyWordSetup."Post-To Account Code");
                                Loans.SetRange("Account No.", MemberNo);
                                if Loans.FindLast() then begin
                                    CreditAccount := Loans."Account No.";
                                    LoanNo := Loans."No.";
                                end;
                            end;
                        KeyWordSetup."Post-To Account Type"::"Savings Account":
                            begin
                                SavingsAccount.Reset();
                                SavingsAccount.SetRange("Product Type", KeyWordSetup."Post-To Account Code");
                                SavingsAccount.SetRange("Member No.", MemberNo);
                                SavingsAccount.SetRange(Blocked, SavingsAccount.Blocked::" ");
                                if SavingsAccount.FindFirst() then
                                    CreditAccount := SavingsAccount."No.";
                            end;
                    end;
                end;
            end;
        end;
    end;

    local procedure CompletePosting(JournalTemplate: Code[20]; JournalBatch: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatch);
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplate);
        IF GenJournalLine.FindSet() then Begin
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
            exit(true);
        end;
    end;

    local procedure PrepareJournal(JournalTemplate: Code[20]; JournalBatch: Code[20]; Description: Text[50]) LineNo: Integer
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        ok: Boolean;
    begin
        if not GenJournalTemplate.Get(JournalTemplate) then Begin
            GenJournalTemplate.Init();
            GenJournalTemplate.Name := JournalTemplate;
            GenJournalTemplate.Description := 'SACCO Batches';
            GenJournalTemplate.Type := GenJournalTemplate.Type::Payments;
            GenJournalTemplate."Page ID" := Page::"Payment Journal";
            ok := GenJournalTemplate.Insert();
        end;
        if not GenJournalBatch.Get(JournalTemplate, JournalBatch) then Begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JournalTemplate;
            GenJournalBatch.Name := JournalBatch;
            GenJournalBatch.Description := Description;
            ok := GenJournalBatch.Insert();
        end;
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindSet() then GenJournalLine.DeleteAll();
        LineNo := 1000;
        exit(LineNo);
    end;

    local procedure CreateJournalLine(AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; PostingDate: Date; PostingDescription: Text[50]; Amount: Decimal; Dimension1: Code[20]; Dimension2: Code[20]; MemberNo: Code[20]; LoanNo: Code[20]; DocumentNo: Code[20]; var LineNo: Integer; ExternalDocNo: code[20]; JournalTemplate: Code[20]; JournalBatch: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        LoanApp: Record "Loan Application";
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplate;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        LineNo += 1000;
        GenJournalLine."Posting Date" := PostingDate;
        case AccountType of
            AccountType::"Bank Account":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
            AccountType::Customer:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
            AccountType::Employee:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Employee;
            AccountType::"Fixed Asset":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
            AccountType::"G/L Account":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            AccountType::"IC Partner":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"IC Partner";
            AccountType::Vendor:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        end;
        GenJournalLine.VALIDATE("Account No.", AccountNo);
        GenJournalLine.VALIDATE(Amount, Amount);
        GenJournalLine."Message to Recipient" := PostingDescription;
        GenJournalLine.Description := PostingDescription;
        GenJournalLine."Due Date" := PostingDate;
        GenJournalLine."Payment Reference" := ExternalDocNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dimension1);
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dimension2);
        GenJournalLine.ValidateShortcutDimCode(1, Dimension1);
        GenJournalLine.ValidateShortcutDimCode(2, Dimension2);
        GenJournalLine."Loan No." := LoanNo;
        if LoanNo <> '' then
            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
        IF GenJournalLine.Amount <> 0 then
            GenJournalLine.INSERT;

    end;

    procedure PostC2BTransactions()
    var
        DebitAcc, CreditAcc, Dim1, Dim2, MemberNo, LoanNo, ExternalDocNo : Code[20];
        AccountType: Enum "Gen. Journal Account Type";
    begin
        JournalBatch := 'C2B';
        JournalTemplate := 'PAYMENT';
        MpesaEntry.Reset();
        MpesaEntry.SetRange("Processed", false);
        if MpesaEntry.FindSet() then begin
            repeat
                if not isDocumentPosted(MpesaEntry."Receipt No.") then begin
                    PostingAmount := MpesaEntry.Amount;
                    PostingDate := DT2Date(MpesaEntry."Received On");
                    ExternalDocNo := MpesaEntry."Receipt No.";
                    PostingDescription := 'Mpesa Receipt ' + MpesaEntry."Phone";
                    LineNo := PrepareJournal(JournalTemplate, JournalBatch, 'MPESA C2B Posting');
                    ConstructPostingAccounts(MpesaEntry."Receipt No.", DebitAcc, CreditAcc, LoanNo);
                    CreateJournalLine(AccountType::"Bank Account", DebitAcc, PostingDate, PostingDescription, PostingAmount, Dim1, Dim2, MemberNo
                    , LoanNo, MpesaEntry."Receipt No.", LineNo, ExternalDocNo, JournalTemplate, JournalBatch);
                    CreateJournalLine(AccountType::Customer, CreditAcc, PostingDate, PostingDescription, -1 * PostingAmount, Dim1, Dim2, MemberNo
                    , LoanNo, MpesaEntry."Receipt No.", LineNo, ExternalDocNo, JournalTemplate, JournalBatch);
                    if isJournalBalancing(JournalTemplate, JournalBatch) then begin
                        CompletePosting(JournalTemplate, JournalBatch);
                        MpesaEntry."Processed" := true;
                        MpesaEntry."Posted On" := CurrentDateTime;
                        MpesaEntry.Modify();
                    end;
                end else begin
                    MpesaEntry."Processed" := true;
                    MpesaEntry."Posted On" := CurrentDateTime;
                    MpesaEntry.Modify();
                end;
            until MpesaEntry.Next() = 0;
        end;
    end;

    procedure MpesaTransaction(ReceiptNo: Code[20]; Amount: Decimal; PhoneNo: Code[20]; Balance: Decimal; CustomerName: Text[250]; TransactionDate: Date; TransactionTime: Time; PaybillNo: Code[20]; AccountNumber: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    begin
        ResponseCode := '00';
        IF NOT MpesaEntry.GET(ReceiptNo) THEN BEGIN
            MpesaEntry.INIT;
            MpesaEntry."Receipt No." := ReceiptNo;
            MpesaEntry."Completion Time" := CurrentDateTime;
            MpesaEntry.Amount := Amount;
            MpesaEntry.Balance := Balance;
            MpesaEntry."Phone" := PhoneNo;
            MpesaEntry."Customer Name" := CustomerName;
            MpesaEntry."Received On" := CreateDateTime(TransactionDate, TransactionTime);
            MpesaEntry."Transaction Date" := TransactionDate;
            MpesaEntry.Status := MpesaEntry.Status::Completed;
            MpesaEntry."Customer Name" := CustomerName;
            MpesaEntry."Paybil Number" := PayBillNo;
            MpesaEntry."Account No." := AccountNumber;
            MpesaEntry.INSERT;
        END
        ELSE BEGIN
            ERROR('The Transaction Already Exists!');
        END;
    end;

    var
        MpesaEntry: Record "MPESA Transactions";
        JournalTemplate, JournalBatch, DocumentNo : Code[20];
        PostingDate: Date;
        PostingAmount: Decimal;
        PostingDescription: Text;
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
}
