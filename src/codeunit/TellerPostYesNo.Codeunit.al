codeunit 50056 "Teller-Post (Yes/No)"
{

    TableNo = "Teller Transaction";

    trigger OnRun()
    begin
        InitPost(Rec.Type, Rec, Rec."Journal Template Name",
        Rec."Journal Batch Name",
        Rec."Till Code", Rec."Global Dimension 1 Code",
        Rec."Global Dimension 2 Code", 1)
    end;

    var
        LineNo: Integer;
        Post: Boolean;
        CTransLine: Record "Cashier Transaction Line";
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        AccCred: Record "Account Credit";
        VarVariant: Variant;
        AccBnk: Record "Account Banking";
        JournlPosted: Codeunit "Jnl Mngt. Post Successful";
        Gensetup: Record "General Set-Up";
        SignInstruction: Record "Signing Instructions";
        SendSMS: Codeunit "SMS Notification";
        SourceType: Enum NotifSourceType;
        SavingsAcc: Record "Account Banking";
        MobileNo: Code[20];
        ConfirmDocApprovalTxt: Label 'Do you want to send this transaction for approval?';
        PostMngt: Codeunit "Journal Post Mngt.";
        CustomApproval: Codeunit "Approval Mgmt.";
        JuniorTransType: Code[10];
        Text00001: Label 'Till balance is below the minimum Reorder level. Kindly make sure you replenish';
        Text016: Label 'You cannot Post %1-%2 because there is at least one entry posted for this transaction.';
        CustomRecord: Record Member;

    procedure InitPost(PostInt: Enum TellerTypes; RecRef: Record "Teller Transaction"; Template: Code[10]; TBatch: Code[10]; BnkTillNo: Code[10]; ShortDim1: Code[10]; ShortDim2: Code[10]; ValuePost: Integer)
    begin
        case PostInt of
            PostInt::"Cash Deposit",
            PostInt::"Cash Withdrawal",
            PostInt::"Credit Receipt":
                PostCashDepWith(RecRef, Template, TBatch, BnkTillNo, ShortDim1, ShortDim2, ValuePost);
            PostInt::"Credit Cheque":
                PostChequeCredit(RecRef, Template, TBatch, ShortDim1, ShortDim2);
            PostInt::"Bankers Cheque":
                PostBankersCheq(RecRef, Template, TBatch, ShortDim1, ShortDim2);
            PostInt::"Cheque Deposit":
                PostChequeDep(RecRef, Template, TBatch, ShortDim1, ShortDim2);
            PostInt::"Account Zerolize":
                PostBankersChequeZerolize(RecRef, Template, TBatch, ShortDim1, ShortDim2);
            PostInt::Lien:
                fnPostLien(RecRef, '', '', '', '');
        end
    end;


    procedure PostCashDepWith(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; TillNo: Code[20]; DBranch: Code[20]; DActivity: Code[20]; PostInt: Integer)
    var
        GenSetup: Record "General Set-Up";
        Acc: Record "Account Banking";
        BankSetup: Record "Banking User Template";
        BankAccount: Record "Bank Account";
        CurrentTellerAmount: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        TellerMngtLine: Record "Cashier Transaction Line";
        LineNo: Integer;
        Account: Record "Account Banking";
        AccountTypes: Record "Product Factory";
        CustAccount: Record Member;
        Text0001: Label 'This account has been blocked from receiving payments.';
        Text0006: Label 'You cannot withdraw more than your allowed limit of %1 unless authorised.';
        Text0007: Label 'You cannot withdraw more than the available balance unless authorised.';
        Text0008: Label 'You cannot deposit more than your allowed limit of %1 unless authorised.';
        Text00009: Label 'You cannot deposit more than your allowed till limit of %1 unless authorised.';
        Text00019: Label 'Member has not fully paid %1.Kindly do a credit receipt';
        Text00020: Label 'Member has not fully paid registration fee.Kindly do a credit receipt';
        Text00021: Label 'Member has not fully paid %1, Kindly Make sure enough fund allocated to Registration fee Account';
        VarVariant: Variant;
        Text0009: Label 'You have done a transaction of KES. ';
        Text0010: Label ' of type ';
        Text0011: Label ' on ';
        Text0012: Label ' on your account ';
        Text0013: Label ' at ';
        Text0018: Label 'Transaction Aborted';
        PFact: Record "Product Factory";
        FAccount: Record "Account Banking";
        Temp: Record "Banking User Template";
        LoanTemp: Record Loans;
        GenJournal: Record "Gen. Journal Line";


    begin
        if TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 1) then
            Error(Text016, RecRef."Account Name", RecRef."No.");

        if (RecRef.Type = RecRef.Type::"Cash Deposit") or (RecRef.Type = RecRef.Type::"Credit Receipt") then begin

            AccCred.Reset;
            AccCred.SetRange("Member No.", RecRef."Member No.");
            AccCred.SetRange("Account Category", AccCred."Account Category"::"Registration Fee");
            if AccCred.Find('-') then begin
                AccCred.CalcFields("Balance (LCY)");
                if PFact.Get(AccCred."Product Type") then begin
                    if AccCred."Balance (LCY)" >= PFact."Minimum Balance" then begin
                        AccCred.Reset;
                        AccCred.SetRange("Member No.", RecRef."Member No.");
                        AccCred.SetRange(Blocked, AccCred.Blocked::" ");
                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Capital");
                        if AccCred.Find('-') then begin
                            AccCred.CalcFields("Balance (LCY)");
                            if PFact.Get(AccCred."Product Type") then begin
                                if AccCred."Balance (LCY)" < PFact."Minimum Balance" then begin
                                    TellerMngtLine.Reset();
                                    TellerMngtLine.SetRange("Transaction No.", RecRef."No.");
                                    TellerMngtLine.SetRange("Account No.", AccCred."No.");
                                    TellerMngtLine.SetRange("Account Category", TellerMngtLine."Account Category"::"Shares Capital");
                                    if TellerMngtLine.Find('-') then begin
                                        RecRef.CalcFields("Allocated Amount");
                                        if TellerMngtLine.Amount < RecRef."Allocated Amount" then
                                            if (TellerMngtLine.Amount + AccCred."Balance (LCY)") < PFact."Minimum Balance" then
                                                Error(Text00021, TellerMngtLine."Account Category");
                                    end else begin
                                        Error(Text00020);
                                    end;
                                end;
                            end;
                        end;
                    end else begin
                        GenSetup.Get();

                        if not GenSetup."Override Setup Control" then begin
                            TellerMngtLine.Reset();
                            TellerMngtLine.SetRange("Transaction No.", RecRef."No.");
                            TellerMngtLine.SetRange("Account No.", AccCred."No.");
                            TellerMngtLine.SetRange("Account Category", TellerMngtLine."Account Category"::"Registration Fee");
                            if TellerMngtLine.Find('-') then begin
                                RecRef.CalcFields("Allocated Amount");
                                if TellerMngtLine.Amount < RecRef."Allocated Amount" then
                                    if (TellerMngtLine.Amount + AccCred."Balance (LCY)") < PFact."Minimum Balance" then
                                        Error(Text00021, TellerMngtLine."Account Category");
                            end else begin
                                Error(Text00020);
                            end;
                        end;
                    end;
                end;
            end;
        end;

        if (RecRef.Type = RecRef.Type::"Credit Receipt") or (RecRef.Type = RecRef.Type::"Credit Cheque") then begin
            RecRef.CalcFields(RecRef."Allocated Amount");
            if RecRef.Amount <> 0 then begin
                if RecRef."Allocated Amount" > 0 then
                    RecRef.TestField(Amount, RecRef."Allocated Amount");
            end
        end;

        GenSetup.Get;
        case RecRef.Type of
            RecRef.Type::"Cash Withdrawal",
            RecRef.Type::"Bank Cheques":
                begin
                    SignInstruction.Reset();
                    SignInstruction.SetRange("No.", RecRef."No.");
                    if SignInstruction.FindSet() then begin
                        repeat
                            if (SignInstruction.Available = false) and (SignInstruction."Must be Present" = true) then
                                Error('Required Signatory not present');
                        until SignInstruction.Next() = 0;
                    end;
                end
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", TillNo);
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        if RecRef.Type = RecRef.Type::"Cash Withdrawal" then begin
            BankAccount.Reset;
            BankAccount.SetRange(BankAccount."No.", TillNo);
            if BankAccount.Find('-') then begin
                BankAccount.CalcFields(BankAccount."Balance (LCY)");
                if RecRef.Amount > BankAccount."Balance (LCY)" then
                    Error('This transaction will overdraw bank account. Transaction aborted.');
            end;

            if Acc.Get(RecRef."Account No.") then begin
                Acc.CalcFields("Balance (LCY)", Acc.Balance, Acc."ATM Transactions", Acc."Uncleared Cheques", Acc."Lien Placed");
                if Acc.Blocked = Acc.Blocked::All then
                    Error(Text0001);
                IF AccountTypes.Get(Acc."Product Type") then begin
                    IF RecRef.Amount >= Acc.Balance - (Acc."ATM Transactions" + Acc."Uncleared Cheques" + Acc."Lien Placed" + AccountTypes."Minimum Balance") then
                        Error('This transaction will overdraw customer account. Transaction aborted.');
                end;
            end;
            if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                if RecRef."Available Balance" < RecRef.Amount then begin
                    Message(Text0007);
                    Error(Text0018);
                    if Confirm(
                      ConfirmDocApprovalTxt)
                      then begin
                        VarVariant := RecRef;
                        CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                    end;
                    exit;
                end;
            end;
        end;

        BankSetup.Get(UserId);
        BankSetup.TestField("Reorder Level");
        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", TillNo);
        if BankAccount.Find('-') then begin
            BankAccount.CalcFields(BankAccount.Balance);
            CurrentTellerAmount := BankAccount.Balance;

            case RecRef.Type of
                RecRef.Type::"Cash Withdrawal",
                RecRef.Type::"Credit Receipt":
                    begin
                        if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                            if RecRef.Amount > BankSetup."Max. Withdrawal Limit" then begin
                                Message(Text0006, BankSetup."Max. Withdrawal Limit");
                                if Confirm(ConfirmDocApprovalTxt, false) = true then begin
                                    VarVariant := RecRef;
                                    CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                                end;
                                exit;
                            end;
                        end
                    end;
            end;
        end;

        if RecRef.Type = RecRef.Type::"Cash Deposit" then begin

            BankAccount.Reset;
            BankAccount.SetRange("No.", TillNo);
            if BankAccount.Find('-') then begin
                BankAccount.CalcFields("Balance (LCY)");
                if (RecRef.Amount + BankAccount."Balance (LCY)") > BankSetup."Max. Cashier Withholding" then
                    Error(Text00009, BankSetup."Max. Cashier Withholding");
            end;
        end;

        case RecRef.Type of
            RecRef.Type::"Cash Withdrawal",
            RecRef.Type::"Credit Receipt":
                begin

                    if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                        if RecRef.Amount > BankSetup."Max. Deposit Limit" then begin
                            Message(Text0008, BankSetup."Max. Deposit Limit");
                            if Confirm(ConfirmDocApprovalTxt, false) = true then begin
                                VarVariant := RecRef;
                                CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                            end;
                            exit;
                        end;
                    end;
                end
        end;

        PostMngt.ClearJournalLines(RecRef."Journal Template Name", RecRef."Journal Batch Name");
        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;
        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");

        GenJournalLine."External Document No." := RecRef."ID No";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.Validate("Account No.", RecRef."Account No.");
        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Remarks, 50);
        if (RecRef.Type = RecRef.Type::"Cash Deposit") then
            GenJournalLine.Validate(Amount, -RecRef.Amount)
        else
            GenJournalLine.Validate(Amount, RecRef.Amount);
        if (RecRef.Type = RecRef.Type::"Credit Receipt") then
            GenJournalLine.Validate(Amount, 0);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
        GenJournalLine.Validate("Bal. Account No.", TillNo);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);

        PostCharges(RecRef."Transaction Type", RecRef."Account No.", RecRef.Amount,
        RecRef."Global Dimension 1 Code", RecRef."Global Dimension 2 Code", RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef);

        JuniorTransType := '';
        JuniorTransType := getSubsiquenTransType(RecRef."Product Type");

        if RecRef.Type = RecRef.Type::"Cash Withdrawal" then begin
            AccountTypes.Get(RecRef."Product Type");
            if AccountTypes."Charge Subsiquent withdrawal" then begin
                AccountTypes.TestField("Withdrawal Interval");
                if JuniorTransType = '' then Error('No Charge type associated with this account.');
                if Account.Get(RecRef."Account No.") then begin

                    if Account."Next Withdrawal Date" = 0D then begin
                        Account."Last Withdrawal Date" := Today;
                        Account."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Today);
                        Account.Modify(true);
                    end else begin

                        if Today <= Account."Next Withdrawal Date" then begin
                            PostCharges(JuniorTransType, RecRef."Account No.", RecRef.Amount, RecRef."Global Dimension 1 Code",
                            RecRef."Global Dimension 2 Code", RecRef."Journal Template Name", RecRef."Journal Batch Name", RecRef);
                            Account."Last Withdrawal Date" := Today;
                            Account.Modify;
                        end else begin
                            Account."Last Withdrawal Date" := Today;
                            Account."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Account."Next Withdrawal Date");
                            Account.Modify(true)
                        end;
                    end;
                end;
            end;
        end;

        if RecRef.Type = RecRef.Type::"Credit Receipt" then begin
            PostCreditReceipt(RecRef, RecRef."Journal Template Name", RecRef."Journal Batch Name",
            TillNo, RecRef."Global Dimension 2 Code", RecRef."Global Dimension 1 Code");
        end;

        Case PostInt of
            1:
                begin

                    PostMngt.CompletePosting(RecRef."Journal Template Name", RecRef."Journal Batch Name");

                    Post := false;
                    Post := JournlPosted.PostedSuccessfully();
                    RecRef.Posted := true;
                    RecRef."Date Posted" := Today;
                    RecRef."Approval Status" := RecRef."Approval Status"::Posted;
                    RecRef."Time Posted" := Time;
                    RecRef."Posted By" := UserId;
                    RecRef.Modify;

                    if SavingsAcc.Get(RecRef."Account No.") then begin
                        MobileNo := SavingsAcc."Mobile No.";
                    end;
                    if RecRef.Type = RecRef.Type::"Cash Withdrawal" then
                        SendSMS.CreateSmsNotif(
                        SourceType::"Cash Withdrawal Confirm", MobileNo, Text0009 +
                        Format(RecRef.Amount) + Text0010 + Format(RecRef.Type) + Text0011 +
                                   Format(Today) + ' ' + Format(Time) +
                                   Text0012 + Text0013 +
                                   CompanyName, RecRef."Account No.", RecRef."Account No.", false)
                    else
                        SendSMS.CreateSmsNotif(
                        SourceType::"Deposit Confirmation", MobileNo, Text0009 +
                        Format(RecRef.Amount) + Text0010 + Format(RecRef.Type) + Text0011 +
                                   Format(Today) + ' ' + Format(Time) +
                                   Text0012 + Text0013 +
                                   CompanyName, RecRef."Account No.", RecRef."Account No.", false);

                    if RecRef.Type = RecRef.Type::"Credit Receipt" then begin

                        AccCred.Reset();
                        AccCred.SetRange("Member No.", RecRef."Member No.");
                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
                        if AccCred.FindFirst() then begin
                            AccCred.CalcFields("Balance (LCY)");
                            PFact.Reset();
                            PFact.SetRange("Product ID", AccCred."Product Type");
                            if PFact.FindFirst() then
                                if AccCred."Balance (LCY)" >= PFact."Minimum Balance" then begin
                                    if AccCred.Status = AccCred.Status::New then begin
                                        AccCred.Status := AccCred.Status::Active;
                                        AccCred.Modify(true);
                                    end;

                                    FAccount.Reset();
                                    FAccount.SetRange("Member No.", AccCred."Member No.");
                                    FAccount.SetRange("Account Category", FAccount."Account Category"::Savings);
                                    if FAccount.FindFirst() then begin
                                        if FAccount.Status = FAccount.Status::New then begin
                                            FAccount.Status := FAccount.Status::Active;
                                            FAccount.Modify(true)
                                        end;
                                    end;

                                    AccCred.Reset();
                                    AccCred.SetRange("Member No.", AccCred."Member No.");
                                    AccCred.SetRange(Status, AccCred.Status::New);
                                    if AccCred.FindFirst() then begin
                                        AccCred.CalcFields("Balance (LCY)");
                                        PFact.Reset();
                                        PFact.SetRange("Product ID", AccCred."Product Type");
                                        if PFact.FindFirst() then begin
                                            if AccCred."Balance (LCY)" >= PFact."Minimum Balance" then begin
                                                AccCred.ModifyAll(Status, AccCred.Status::Active);
                                            end;
                                        end;
                                    end;

                                    CustAccount.Reset();
                                    CustAccount.SetRange("No.", RecRef."Member No.");
                                    if CustAccount.FindFirst() then begin
                                        if CustAccount.Status = CustAccount.Status::New then begin
                                            CustAccount.Status := CustAccount.Status::Active;
                                            CustAccount.Modify(true);
                                        end;
                                    end;

                                    CTransLine.Reset;
                                    CTransLine.SetRange("Transaction No.", RecRef."No.");
                                    CTransLine.SetRange("Member No.", RecRef."Member No.");
                                    if CTransLine.Find('-') then begin
                                        repeat
                                            AccCred.Reset();
                                            AccCred.SetRange("No.", CTransLine."Account No.");
                                            if AccCred.FindFirst() then begin
                                                AccCred.CalcFields("Balance (LCY)");
                                                if AccCred.Status = AccCred.Status::New then begin
                                                    PFact.Reset();
                                                    PFact.SetRange("Product ID", AccCred."Product Type");
                                                    if PFact.FindFirst() then begin
                                                        if AccCred."Balance (LCY)" >= PFact."Minimum Balance" then begin
                                                            AccCred.Status := AccCred.Status::Active;
                                                            AccCred.Modify(true)
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        until CTransLine.Next() = 0
                                    end;
                                end;
                        end;
                    end;
                end;
            0:
                begin
                    VarVariant := RecRef;
                    GenJournal.Reset();
                    GenJournal.SetRange("Journal Template Name", RecRef."Journal Template Name");
                    GenJournal.SetRange("Journal Batch Name", RecRef."Journal Batch Name");
                    if GenJournal.FindFirst() then begin
                        Page.Run(Page::"Journal Test Batch", GenJournal);
                    end;

                end;
        end;
    end;

    procedure PostChequeDep(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        ChBank: Code[20];
        TextMsg0001: Label ' has been credited to your account on';
        TextMsg0002: Label 'of KES ';
        TextMsg0003: Label 'A ';
        TextMsg0004: Label ', at ';
        BankAccount: Record "Bank Account";
        Temps: Record "Banking User Template";
        ChequeType: Record "Cheque Type";

    begin

        if TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 1) then
            Error(Text016, RecRef."Account Name", RecRef."No.");

        Temps.Get(UserId);

        RecRef.TestField("Bank Account");
        RecRef.TestField("Cheque Type");
        GenSetup.Get;
        ChBank := RecRef."Bank Account";

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", ChBank);
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", Temps."Default  Bank");
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        PostMngt.ClearJournalLines(RecRef."Journal Template Name", RecRef."Journal Batch Name");
        if ChequeType.Get(RecRef."Cheque Type") then begin
            ChequeType.TestField("Cheque Time");

            if RecRef."Transaction Time" <= ChequeType."Cheque Time" then begin

                GenJournalLine.LockTable;
                LineNo := LineNo + 10000;
                InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                RecRef."Global Dimension 2 Code");

                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.Validate("Account No.", RecRef."Account No.");
                GenJournalLine."External Document No." := RecRef."Cheque No";
                GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Remarks, 50);
                GenJournalLine.Validate(Amount, -RecRef.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                GenJournalLine.LockTable;
                LineNo := LineNo + 10000;

                InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                RecRef."Global Dimension 2 Code");

                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                GenJournalLine.Validate("Account No.", ChBank);
                GenJournalLine."External Document No." := RecRef."Cheque No";
                GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Remarks, 50);
                GenJournalLine.Validate(Amount, RecRef.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);
                PostCharges(RecRef."Transaction Type", RecRef."Account No.", RecRef.Amount,
                RecRef."Global Dimension 1 Code", RecRef."Global Dimension 2 Code",
                RecRef."Journal Template Name", RecRef."Journal Batch Name", RecRef);

                PostMngt.CompletePosting(RecRef."Journal Template Name", RecRef."Journal Batch Name");
                Post := false;
                Post := JournlPosted.PostedSuccessfully();
                RecRef.Posted := true;
                RecRef."Date Posted" := Today;
                RecRef."Time Posted" := Time;
                RecRef."Posted By" := UserId;
                RecRef."Approval Status" := RecRef."Approval Status"::Posted;
                RecRef.Modify;
            end else begin
                RecRef."Date Posted" := Today;
                RecRef."Time Posted" := Time;
                RecRef."Posted By" := UserId;
                RecRef."Approval Status" := RecRef."Approval Status"::Deffered;
                RecRef.Modify;
            end;

            if SavingsAcc.Get(RecRef."Account No.") then begin
                MobileNo := SavingsAcc."Mobile No.";
            end;

            SendSMS.CreateSmsNotif(
            SourceType::"Deposit Confirmation", MobileNo, TextMsg0003 +
            Format(RecRef.Type) + TextMsg0002 + Format(RecRef.Amount) + TextMsg0001 +
            Format(Today) + TextMsg0004 + Format(Time) + '. ' +
            CompanyName + '.', RecRef."Member No.", RecRef."Account No.", false);
        end;
    end;

    procedure PostBankersChequeZerolize(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    var
        Acc: Record "Account Banking";
        BankingTemp: Record "Banking User Template";
        Text0001: Label 'This account has been blocked from receiving payments.';
        ChBank: Code[20];
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Text0002: Label 'You cannot issue a Bankers cheque more than the available balance unless authorised.';
        BRegister: Record "Bankers Cheques Register";
        TextMsg0001: Label ' has been debited to your account on';
        TextMsg0002: Label 'of KES ';
        TextMsg0003: Label 'A ';
        TextMsg0004: Label ', at ';
        Text0018: Label 'Transaction Aborted';
        Text0006: Label 'You cannot withdraw more than your allowed limit of %1 unless authorised.';
        Text0007: Label 'You cannot withdraw more than the available balance unless authorised.';
        Text0008: Label 'You cannot deposit more than your allowed limit of %1 unless authorised.';
        Text00009: Label 'You cannot deposit more than your allowed till limit of %1 unless authorised.';
        AccountTypes: Record "Product Factory";
        Account: Record "Account Banking";
        GenSetup: Record "General Set-Up";
        VarVariant: Variant;
        BankSetup: Record "Banking User Template";
        BankAccount: Record "Bank Account";
        CurrentTellerAmount: Decimal;
        ErrorOnInvalidEntry: Label 'Operation cannot be initited on member account whose status is %1';

    begin

        if TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 1) then
            Error(Text016, RecRef."Account Name", RecRef."No.");

        CustomRecord.Reset();
        CustomRecord.SetRange("No.", RecRef."Member No.");
        CustomRecord.SetFilter(Status, '%1|%2', CustomRecord.Status::Withdrawn, CustomRecord.Status::Deceased);
        if not CustomRecord.FindFirst() then begin
            Error(ErrorOnInvalidEntry, CustomRecord.Status);
        end;

        case RecRef.Type of
            RecRef.Type::"Cash Withdrawal",
            RecRef.Type::"Bank Cheques":
                begin
                    SignInstruction.Reset();
                    SignInstruction.SetRange("No.", RecRef."No.");
                    if SignInstruction.FindSet() then begin
                        repeat
                            if (SignInstruction.Available = false) and (SignInstruction."Must be Present" = true) then
                                Error('Required Signatory not present');
                        until SignInstruction.Next() = 0;
                    end;
                end
        end;
        if Acc.Get(RecRef."Account No.") then begin
            if Acc.Blocked = Acc.Blocked::All then
                Error(Text0001);
        end;

        if BankingTemp.Get(UserId) then begin
            BankingTemp.TestField("Bankers Cheque Account");
            ChBank := BankingTemp."Bankers Cheque Account";
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", BankingTemp."Default  Bank");
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", ChBank);
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        if RecRef.Type = RecRef.Type::"Account Zerolize" then begin
            if RecRef."Available Balance" < RecRef.Amount then begin
                Error(Text0002);
                exit;
            end;
        end;

        GenSetup.Get;

        if RecRef.Type = RecRef.Type::"Account Zerolize" then begin
            BankAccount.Reset;
            BankAccount.SetRange(BankAccount."No.", ChBank);
            if BankAccount.Find('-') then begin
                BankAccount.CalcFields(BankAccount."Balance (LCY)");
                if RecRef.Amount > BankAccount."Balance (LCY)" then
                    Error('This transaction will overdraw bank account. Transaction aborted.');
            end;

            if Acc.Get(RecRef."Account No.") then begin
                Acc.CalcFields("Balance (LCY)", Acc.Balance, Acc."ATM Transactions", Acc."Uncleared Cheques", Acc."Lien Placed");
                if Acc.Blocked = Acc.Blocked::All then
                    Error(Text0001);
                IF AccountTypes.Get(Acc."Product Type") then begin
                    IF RecRef.Amount >= Acc."Balance (LCY)" then
                        Error('This transaction will overdraw customer account. Transaction aborted.');
                end;
            end;
            if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                if RecRef."Available Balance" < RecRef.Amount then begin
                    Message(Text0007);
                    Error(Text0018);
                    if Confirm(
                      ConfirmDocApprovalTxt)
                      then begin
                        VarVariant := RecRef;
                        CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                    end;
                    exit;
                end;
            end;
        end;

        BankSetup.Get(UserId);
        BankSetup.TestField("Reorder Level");
        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", ChBank);
        if BankAccount.Find('-') then begin
            BankAccount.CalcFields(BankAccount.Balance);
            CurrentTellerAmount := BankAccount.Balance;

            if RecRef.Type = RecRef.Type::"Bankers Cheque" then begin
                if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                    if RecRef.Amount > BankSetup."Max. Withdrawal Limit" then begin
                        Message(Text0006, BankSetup."Max. Withdrawal Limit");
                        if Confirm(ConfirmDocApprovalTxt, false) = true then begin
                            VarVariant := RecRef;
                            CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                        end;
                        exit;
                    end;
                end;
            end;
        end;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
            if Confirm(ConfirmDocApprovalTxt, false) = true then begin
                VarVariant := RecRef;
                CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                exit
            end;
        end;

        CheckBankersNo(RecRef."Bankers Cheque No", RecRef."Global Dimension 2 Code", RecRef.Amount);
        PostMngt.ClearJournalLines(RecRef."Journal Template Name", RecRef."Journal Batch Name");

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;

        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");
        GenJournalLine.Validate(Amount, RecRef.Amount);
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.Validate("Account No.", RecRef."Account No.");
        GenJournalLine."External Document No." := RecRef."Bankers Cheque No";
        GenJournalLine.Description := PadStr(RecRef."Transaction Description" + '-' + RecRef.Payee, 50);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;

        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");
        GenJournalLine.Validate(Amount, -RecRef.Amount);
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine.Validate("Account No.", ChBank);
        GenJournalLine."External Document No." := RecRef."Cheque No";
        GenJournalLine.Description := PadStr(RecRef.Payee + '-' + RecRef."Cheque No", 50);

        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);
        PostCharges(RecRef."Transaction Type", RecRef."Account No.", RecRef.Amount,
          RecRef."Global Dimension 1 Code", RecRef."Global Dimension 2 Code",
          RecRef."Journal Template Name", RecRef."Journal Batch Name", RecRef);

        PostMngt.CompletePosting(RecRef."Journal Template Name", RecRef."Journal Batch Name");
        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        RecRef.Posted := true;
        RecRef."Date Posted" := Today;
        RecRef."Time Posted" := Time;
        RecRef."Posted By" := UserId;
        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
        RecRef.Modify;

        BRegister.Reset;
        BRegister.SetRange(BRegister."Cheque No.", RecRef."Bankers Cheque No");
        if BRegister.Find('-') then begin
            BRegister.Status := BRegister.Status::Approved;
            BRegister.Modify;
        end;

        AccBnk.Reset();
        AccBnk.SetRange("Member No.", RecRef."Member No.");
        if AccBnk.FindSet() then begin
            AccBnk.ModifyAll(Status, AccBnk.Status::Withdrawn);
        end;

        if SavingsAcc.Get(RecRef."Account No.") then begin
            MobileNo := SavingsAcc."Mobile No.";
        end;

        SendSMS.CreateSmsNotif(
        SourceType::"Deposit Confirmation", MobileNo, TextMsg0003 +
        Format(RecRef.Type) + TextMsg0002 + Format(RecRef.Amount) + TextMsg0001 +
        Format(Today) + TextMsg0004 + Format(Time) + '. ' +
        CompanyName + '.', RecRef."Member No.", RecRef."Account No.", false);
    end;


    procedure PostBankersCheq(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    var
        Acc: Record "Account Banking";
        BankingTemp: Record "Banking User Template";
        Text0001: Label 'This account has been blocked from receiving payments.';
        ChBank: Code[20];
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Text0002: Label 'You cannot issue a Bankers cheque more than the available balance unless authorised.';
        BRegister: Record "Bankers Cheques Register";
        TextMsg0001: Label ' has been debited to your account on';
        TextMsg0002: Label 'of KES ';
        TextMsg0003: Label 'A ';
        TextMsg0004: Label ', at ';
        Text0018: Label 'Transaction Aborted';
        Text0006: Label 'You cannot withdraw more than your allowed limit of %1 unless authorised.';
        Text0007: Label 'You cannot withdraw more than the available balance unless authorised.';
        Text0008: Label 'You cannot deposit more than your allowed limit of %1 unless authorised.';
        Text00009: Label 'You cannot deposit more than your allowed till limit of %1 unless authorised.';
        AccountTypes: Record "Product Factory";
        Account: Record "Account Banking";
        GenSetup: Record "General Set-Up";
        VarVariant: Variant;
        BankSetup: Record "Banking User Template";
        BankAccount: Record "Bank Account";
        CurrentTellerAmount: Decimal;
    begin
        if TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 1) then
            Error(Text016, RecRef."Account Name", RecRef."No.");

        case RecRef.Type of
            RecRef.Type::"Cash Withdrawal",
            RecRef.Type::"Bank Cheques":
                begin
                    SignInstruction.Reset();
                    SignInstruction.SetRange("No.", RecRef."No.");
                    if SignInstruction.FindSet() then begin
                        repeat
                            if (SignInstruction.Available = false) and (SignInstruction."Must be Present" = true) then
                                Error('Required Signatory not present');
                        until SignInstruction.Next() = 0;
                    end;
                end
        end;
        if Acc.Get(RecRef."Account No.") then begin
            if Acc.Blocked = Acc.Blocked::All then
                Error(Text0001);
        end;

        if BankingTemp.Get(UserId) then begin
            BankingTemp.TestField("Bankers Cheque Account");
            ChBank := BankingTemp."Bankers Cheque Account";
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", BankingTemp."Default  Bank");
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", ChBank);
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        if RecRef.Type = RecRef.Type::"Bankers Cheque" then begin
            if RecRef."Available Balance" < RecRef.Amount then begin
                Error(Text0002);
                exit;
            end;
        end;

        GenSetup.Get;

        if RecRef.Type = RecRef.Type::"Bankers Cheque" then begin
            BankAccount.Reset;
            BankAccount.SetRange(BankAccount."No.", ChBank);
            if BankAccount.Find('-') then begin
                BankAccount.CalcFields(BankAccount."Balance (LCY)");
                if RecRef.Amount > BankAccount."Balance (LCY)" then
                    Error('This transaction will overdraw bank account. Transaction aborted.');
            end;

            if Acc.Get(RecRef."Account No.") then begin
                Acc.CalcFields("Balance (LCY)", Acc.Balance, Acc."ATM Transactions", Acc."Uncleared Cheques", Acc."Lien Placed");
                if Acc.Blocked = Acc.Blocked::All then
                    Error(Text0001);
                IF AccountTypes.Get(Acc."Product Type") then begin
                    IF RecRef.Amount >= Acc.Balance - (Acc."ATM Transactions" + Acc."Uncleared Cheques" + Acc."Lien Placed" + AccountTypes."Minimum Balance") then
                        Error('This transaction will overdraw customer account. Transaction aborted.');
                end;
            end;
            if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                if RecRef."Available Balance" < RecRef.Amount then begin
                    Message(Text0007);
                    Error(Text0018);
                    if Confirm(
                      ConfirmDocApprovalTxt)
                      then begin
                        VarVariant := RecRef;
                        CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                    end;
                    exit;
                end;
            end;
        end;

        BankSetup.Get(UserId);
        BankSetup.TestField("Reorder Level");
        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", ChBank);
        if BankAccount.Find('-') then begin
            BankAccount.CalcFields(BankAccount.Balance);
            CurrentTellerAmount := BankAccount.Balance;

            if RecRef.Type = RecRef.Type::"Bankers Cheque" then begin
                if RecRef."Approval Status" <> RecRef."Approval Status"::Approved then begin
                    if RecRef.Amount > BankSetup."Max. Withdrawal Limit" then begin
                        Message(Text0006, BankSetup."Max. Withdrawal Limit");
                        if Confirm(ConfirmDocApprovalTxt, false) = true then begin
                            VarVariant := RecRef;
                            CustomApproval.OnSendTellerTransactionApprovalRequest(VarVariant);
                        end;
                        exit;
                    end;
                end;
            end;
        end;
        RecRef.TestField("Bankers Cheque No");

        CheckBankersNo(RecRef."Bankers Cheque No", RecRef."Global Dimension 2 Code", RecRef.Amount);
        PostMngt.ClearJournalLines(RecRef."Journal Template Name", RecRef."Journal Batch Name");

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;

        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");
        GenJournalLine.Validate(Amount, RecRef.Amount);
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.Validate("Account No.", RecRef."Account No.");
        GenJournalLine."External Document No." := RecRef."Bankers Cheque No";
        GenJournalLine.Description := PadStr(RecRef."Transaction Description" + '-' + RecRef.Payee, 50);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;

        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");
        GenJournalLine.Validate(Amount, -RecRef.Amount);
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine.Validate("Account No.", ChBank);
        GenJournalLine."External Document No." := RecRef."Cheque No";
        GenJournalLine.Description := PadStr(RecRef.Payee + '-' + RecRef."Cheque No", 50);

        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);
        PostCharges(RecRef."Transaction Type", RecRef."Account No.", RecRef.Amount,
          RecRef."Global Dimension 1 Code", RecRef."Global Dimension 2 Code",
          RecRef."Journal Template Name", RecRef."Journal Batch Name", RecRef);

        JuniorTransType := '';
        JuniorTransType := getSubsiquenTransType(RecRef."Product Type");

        AccountTypes.Get(RecRef."Product Type");
        if AccountTypes."Charge Subsiquent withdrawal" then begin
            AccountTypes.TestField("Withdrawal Interval");
            if Account.Get(RecRef."Account No.") then begin

                if Account."Next Withdrawal Date" = 0D then begin
                    Account."Last Withdrawal Date" := Today;
                    Account."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Today);
                    Account.Modify(true);
                end else begin
                    if Today <= Account."Next Withdrawal Date" then begin
                        PostCharges(JuniorTransType, RecRef."Account No.", RecRef.Amount, RecRef."Global Dimension 1 Code",
                        RecRef."Global Dimension 2 Code", RecRef."Journal Template Name", RecRef."Journal Batch Name", RecRef);
                        Account."Last Withdrawal Date" := Today;
                        Account.Modify;
                    end else begin
                        Account."Last Withdrawal Date" := Today;
                        Account."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Account."Next Withdrawal Date");
                        Account.Modify(true)
                    end;
                end;
            end;
        end;


        PostMngt.CompletePosting(RecRef."Journal Template Name", RecRef."Journal Batch Name");
        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        RecRef.Posted := true;
        RecRef."Date Posted" := Today;
        RecRef."Time Posted" := Time;
        RecRef."Posted By" := UserId;
        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
        RecRef.Modify;

        BRegister.Reset;
        BRegister.SetRange(BRegister."Cheque No.", RecRef."Bankers Cheque No");
        if BRegister.Find('-') then begin
            BRegister.Status := BRegister.Status::Approved;
            BRegister.Modify;
        end;

        if SavingsAcc.Get(RecRef."Account No.") then begin
            MobileNo := SavingsAcc."Mobile No.";
        end;

        SendSMS.CreateSmsNotif(
        SourceType::"Deposit Confirmation", MobileNo, TextMsg0003 +
        Format(RecRef.Type) + TextMsg0002 + Format(RecRef.Amount) + TextMsg0001 +
        Format(Today) + TextMsg0004 + Format(Time) + '. ' +
        CompanyName + '.', RecRef."Member No.", RecRef."Account No.", false);
    end;

    procedure PostCreditReceipt(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; TillNo: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    var
        CTransLines: Record "Cashier Transaction Line";
        GenJournalLine: Record "Gen. Journal Line";
        Loans: Record Loans;
        RunBal: Decimal;
        AccBank: Record "Account Banking";
        RegMngt: Codeunit "Register Management";
        CredAccount: Record "Account Credit";
        ProdFact: Record "Product Factory";
        NoMinBalance: Boolean;
        ReceiptLine: Record "Cashier Transaction Line";
        CustRec: Record Member;
    begin
        RecRef.CalcFields("Allocated Amount");
        RecRef.TestField("Allocated Amount", RecRef.Amount);

        CTransLines.Reset;
        CTransLines.SetRange("Transaction No.", RecRef."No.");
        if CTransLines.Find('-') then begin
            repeat
                RunBal := 0;

                if CTransLines."Transaction Type" = CTransLines."Transaction Type"::Repayment then begin
                    CTransLines.TestField("Loan No.");
                    if Loans.Get(CTransLines."Loan No.") then
                        Loans.CalcFields("Outstanding Principal", "Outstanding Interest", "Outstanding Bill");
                    RunBal := CTransLines.Amount;
                    if ProdFact.Get(Loans."Product Type") then
                        if CTransLines."Accrued Interest" > 0 then begin
                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                            RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                            RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                            RecRef."Global Dimension 2 Code");
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                            GenJournalLine."External Document No." := RecRef."ID No";
                            GenJournalLine.Validate(Amount, CTransLines."Accrued Interest");
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
                            GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + Format(GenJournalLine."Transaction Type"), 50);
                            GenJournalLine."Loan No." := CTransLines."Loan No.";
                            GenJournalLine.Validate("Bal. Account No.", ProdFact."Interest Account (G/L)");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                        end;

                    if (Loans."Outstanding Interest" + CTransLines."Accrued Interest") > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;

                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                        RecRef."Global Dimension 2 Code");
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                        GenJournalLine."External Document No." := RecRef."ID No";
                        if RunBal >= (Loans."Outstanding Interest" + CTransLines."Accrued Interest") then
                            GenJournalLine.Validate(Amount, (Loans."Outstanding Interest" + CTransLines."Accrued Interest") * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + Format(GenJournalLine."Transaction Type"), 50);
                        GenJournalLine."Loan No." := CTransLines."Loan No.";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - Abs(GenJournalLine.Amount);
                    end;

                    if Loans."Outstanding Bill" > 0 then begin
                        if RunBal > 0 then begin

                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                            RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                            RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                            RecRef."Global Dimension 2 Code");
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                            GenJournalLine."External Document No." := RecRef."ID No";
                            if RunBal >= Loans."Outstanding Bill" then
                                GenJournalLine.Validate(Amount, Loans."Outstanding Bill" * -1) else
                                GenJournalLine.Validate(Amount, RunBal * -1);
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                            GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + Format(GenJournalLine."Transaction Type"), 50);
                            GenJournalLine."Loan No." := CTransLines."Loan No.";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                        end;
                    end;

                    if Loans."Outstanding Principal" > 0 then begin
                        if RunBal > 0 then begin

                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                            RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                            RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                            RecRef."Global Dimension 2 Code");
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                            GenJournalLine."External Document No." := RecRef."ID No";
                            GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + Format(CTransLines."Transaction Type"), 50);
                            if RunBal >= Loans."Outstanding Principal" then
                                GenJournalLine.Validate(Amount, Loans."Outstanding Principal" * -1) else
                                GenJournalLine.Validate(Amount, RunBal * -1);
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                            GenJournalLine."Loan No." := CTransLines."Loan No.";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                        end;
                    end;

                    if RunBal > 0 then begin
                        AccBank.Reset();
                        AccBank.SetRange("Member No.", CTransLines."Member No.");
                        AccBank.SetRange("Account Category", AccBank."Account Category"::Savings);
                        if AccBank.FindFirst() then begin
                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                            RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                            RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                            RecRef."Global Dimension 2 Code");
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine.Validate("Account No.", AccBank."No.");
                            GenJournalLine."External Document No." := RecRef."ID No";
                            GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + AccBank."Product Type", 50);
                            GenJournalLine.Validate(Amount, RunBal * -1);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                        end;
                    end;
                end;

                if CTransLines."Transaction Type" = CTransLines."Transaction Type"::" " then begin

                    if CTransLines."Account Type" = CTransLines."Account Type"::Credit then begin
                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                        RecRef."Global Dimension 2 Code");
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                        GenJournalLine."External Document No." := RecRef."ID No";
                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + CTransLines."Product Type", 50);
                        GenJournalLine.Validate(Amount, -CTransLines.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;

                    if CTransLines."Account Type" = CTransLines."Account Type"::Saving then begin
                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                        RecRef."Global Dimension 2 Code");
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                        GenJournalLine."External Document No." := RecRef."ID No";
                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + CTransLines."Product Type", 50);
                        GenJournalLine.Validate(Amount, -CTransLines.Amount);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end;
            until CTransLines.Next = 0;
        end;

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;
        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");
        GenJournalLine.Validate(Amount, RecRef."Allocated Amount");
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine.Validate("Account No.", TillNo);
        GenJournalLine."External Document No." := RecRef."ID No";
        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Payee, 50);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);
    end;

    procedure PerformPostCreditCheque(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; TillNo: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    var
        CTransLines: Record "Cashier Transaction Line";
        GenJournalLine: Record "Gen. Journal Line";
        Loans: Record Loans;
        RunBal: Decimal;
        AccBank: Record "Account Banking";
        RegMngt: Codeunit "Register Management";
        CredAccount: Record "Account Credit";
        ProdFact: Record "Product Factory";
        NoMinBalance: Boolean;
        ReceiptLine: Record "Cashier Transaction Line";
        CustRec: Record Member;
        TextMsg0001: Label ' has been done to your account on';
        TextMsg0002: Label 'of KES ';
        TextMsg0003: Label 'A ';
        TextMsg0004: Label ', at ';
        TextMsg0005: Label 'This transaction will result in overdrawing the account.';
        TellerMngt: Codeunit "Teller-Post (Yes/No)";

    begin
        RecRef.CalcFields("Allocated Amount");
        RecRef.TestField("Allocated Amount", RecRef.Amount);
        if (RecRef.Posted) and (RecRef.Type = RecRef.Type::"Credit Cheque") then begin

            if not TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 0) then begin

                AccBnk.Reset();
                AccBnk.SetRange("No.", RecRef."Account No.");
                if AccBnk.FindFirst() then begin
                    AccBnk.CalcFields("Balance (LCY)");
                    if TellerMngt.CalcAvailableBal(AccBnk."No.") <= RecRef."Allocated Amount" then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                        RecRef."Global Dimension 2 Code");
                        GenJournalLine.Validate(Amount, RecRef."Allocated Amount");
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", RecRef."Account No.");
                        GenJournalLine."External Document No." := RecRef."ID No";
                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Payee, 50);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        CTransLines.Reset;
                        CTransLines.SetRange("Transaction No.", RecRef."No.");
                        if CTransLines.Find('-') then begin
                            repeat
                                RunBal := 0;

                                if CTransLines."Transaction Type" = CTransLines."Transaction Type"::Repayment then begin
                                    CTransLines.TestField("Loan No.");
                                    if Loans.Get(CTransLines."Loan No.") then
                                        Loans.CalcFields("Outstanding Principal", "Outstanding Interest");
                                    RunBal := CTransLines.Amount;

                                    if CTransLines."Outstanding Interest" > 0 then begin

                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                                        RecRef."Global Dimension 2 Code");
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                                        GenJournalLine."External Document No." := RecRef."ID No";
                                        if RunBal >= Loans."Outstanding Interest" then
                                            GenJournalLine.Validate(Amount, Loans."Outstanding Interest" * -1) else
                                            GenJournalLine.Validate(Amount, RunBal * -1);
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + Format(GenJournalLine."Transaction Type"), 50);
                                        GenJournalLine."Loan No." := CTransLines."Loan No.";
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);
                                        RunBal := RunBal - Abs(GenJournalLine.Amount);
                                    end;

                                    if RunBal > 0 then begin
                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                                        RecRef."Global Dimension 2 Code");
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                                        GenJournalLine."External Document No." := RecRef."ID No";
                                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + Format(CTransLines."Transaction Type"), 50);
                                        if RunBal >= Loans."Outstanding Principal" then
                                            GenJournalLine.Validate(Amount, Loans."Outstanding Principal" * -1) else
                                            GenJournalLine.Validate(Amount, RunBal * -1);
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                                        GenJournalLine."Loan No." := CTransLines."Loan No.";
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);
                                        RunBal := RunBal - Abs(GenJournalLine.Amount);
                                    end;

                                    if RunBal > 0 then begin
                                        AccBank.Reset();
                                        AccBank.SetRange("Member No.", CTransLines."Member No.");
                                        AccBank.SetRange("Account Category", AccBank."Account Category"::Savings);
                                        if AccBank.FindFirst() then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                                            RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                                            RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                                            RecRef."Global Dimension 2 Code");
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                            GenJournalLine.Validate("Account No.", AccBank."No.");
                                            GenJournalLine."External Document No." := RecRef."ID No";
                                            GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + AccBank."Product Type", 50);
                                            GenJournalLine.Validate(Amount, RunBal * -1);
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                        end;
                                    end;
                                end;

                                if CTransLines."Transaction Type" = CTransLines."Transaction Type"::" " then begin

                                    if CTransLines."Account Type" = CTransLines."Account Type"::Credit then begin
                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                                        RecRef."Global Dimension 2 Code");
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                                        GenJournalLine."External Document No." := RecRef."ID No";
                                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + CTransLines."Product Type", 50);
                                        GenJournalLine.Validate(Amount, -CTransLines.Amount);
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);
                                    end;

                                    if CTransLines."Account Type" = CTransLines."Account Type"::Saving then begin
                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
                                        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
                                        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
                                        RecRef."Global Dimension 2 Code");
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        GenJournalLine.Validate("Account No.", CTransLines."Account No.");
                                        GenJournalLine."External Document No." := RecRef."ID No";
                                        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + CTransLines."Product Type", 50);
                                        GenJournalLine.Validate(Amount, -CTransLines.Amount);
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);
                                    end;
                                end;
                            until CTransLines.Next = 0;
                            PostMngt.CompletePosting(RecRef."Journal Template Name", RecRef."Journal Batch Name");
                            Post := false;
                            Post := JournlPosted.PostedSuccessfully();
                            RecRef."Cheque Status" := RecRef."Cheque Status"::Honoured;
                            RecRef."Date Cleared" := Today;
                            RecRef."Cleared By" := UserId;
                            RecRef.Modify;

                            if SavingsAcc.Get(RecRef."Account No.") then begin
                                MobileNo := SavingsAcc."Mobile No.";
                            end;

                            SendSMS.CreateSmsNotif(
                            SourceType::"Deposit Confirmation", MobileNo, TextMsg0003 +
                            Format(RecRef.Type) + TextMsg0002 + Format(RecRef.Amount) + TextMsg0001 +
                            Format(Today) + TextMsg0004 + Format(Time) + '. ' +
                            CompanyName + '.', RecRef."Member No.", RecRef."Account No.", false);

                        end;
                    end
                end;
            end;
        end;
    end;

    procedure PostChequeCredit(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        ChBank: Code[20];
        TextMsg0001: Label ' has been credited to your account on';
        TextMsg0002: Label 'of KES ';
        TextMsg0003: Label 'A ';
        TextMsg0004: Label ', at ';
        BankAccount: Record "Bank Account";
        Temps: Record "Banking User Template";

    begin

        if TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 1) then
            Error(Text016, RecRef."Account Name", RecRef."No.");

        Temps.Get(UserId);

        RecRef.TestField("Bank Account");
        RecRef.TestField("Cheque Type");
        GenSetup.Get;
        ChBank := RecRef."Bank Account";

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", ChBank);
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        BankAccount.Reset;
        BankAccount.SetRange(BankAccount."No.", Temps."Default  Bank");
        BankAccount.SetRange(Blocked, false);
        if not BankAccount.Find('-') then begin
            Error('This account is blocked from transacting');
        end;

        PostMngt.ClearJournalLines(RecRef."Journal Template Name", RecRef."Journal Batch Name");

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;

        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");

        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.Validate("Account No.", RecRef."Account No.");
        GenJournalLine."External Document No." := RecRef."Cheque No";
        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Remarks, 50);
        GenJournalLine.Validate(Amount, -RecRef.Amount);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);

        GenJournalLine.LockTable;
        LineNo := LineNo + 10000;

        InitializeEntry(GenJournalLine, LineNo, RecRef."Journal Template Name",
        RecRef."Journal Batch Name", RecRef."No.", RecRef."Currency Code",
        RecRef."Transaction Date", RecRef."Global Dimension 1 Code",
        RecRef."Global Dimension 2 Code");

        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine.Validate("Account No.", ChBank);
        GenJournalLine."External Document No." := RecRef."Cheque No";
        GenJournalLine.Description := PadStr(Format(RecRef.Type) + '-' + RecRef.Remarks, 50);
        GenJournalLine.Validate(Amount, RecRef.Amount);
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert(true);
        PostCharges(RecRef."Transaction Type", RecRef."Account No.", RecRef.Amount,
        RecRef."Global Dimension 1 Code", RecRef."Global Dimension 2 Code",
        RecRef."Journal Template Name", RecRef."Journal Batch Name", RecRef);

        PostMngt.CompletePosting(RecRef."Journal Template Name", RecRef."Journal Batch Name");
        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        RecRef.Posted := true;
        RecRef."Date Posted" := Today;
        RecRef."Time Posted" := Time;
        RecRef."Posted By" := UserId;
        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
        RecRef.Modify;

        if SavingsAcc.Get(RecRef."Account No.") then begin
            MobileNo := SavingsAcc."Mobile No.";
        end;

        SendSMS.CreateSmsNotif(
        SourceType::"Deposit Confirmation", MobileNo, TextMsg0003 +
        Format(RecRef.Type) + TextMsg0002 + Format(RecRef.Amount) + TextMsg0001 +
        Format(Today) + TextMsg0004 + Format(Time) + '. ' +
        CompanyName + '.', RecRef."Member No.", RecRef."Account No.", false);
    end;

    local procedure PostCustomerEntry(var TellerTransaction: Record "Teller Transaction"; DimensionCode1: Code[10]; DimensionCode2: Code[10]; JournalTemp: Code[10]; JournalBatch: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Journal Template Name" := JournalTemp;
        GenJnlLine."Journal Batch Name" := JournalBatch;
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document No." := TellerTransaction."No.";
        GenJnlLine."External Document No." := TellerTransaction."ID No";
        GenJnlLine.Validate("Currency Code", TellerTransaction."Currency Code");
        GenJnlLine."Document Date" := TellerTransaction."Transaction Date";
        GenJnlLine.Validate("Shortcut Dimension 1 Code", DimensionCode1);
        GenJnlLine.Validate("Shortcut Dimension 2 Code", DimensionCode2);
    end;


    procedure InitializeEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
    begin
        RecRef.Init;
        RecRef."Line No." := LineNo + 1000;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := Today;
        RecRef."Document No." := DocNo;
        RecRef.Validate("Currency Code", CurrencyCode);
        RecRef."Document Date" := TransactionDate;
        RecRef.Validate("Shortcut Dimension 1 Code", Dimension1);
        RecRef.Validate("Shortcut Dimension 2 Code", Dimension2);

    end;

    procedure fnInitializeEntries(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20]; PDate: Date)
    begin
        RecRef.Init;
        RecRef."Line No." := LineNo + 1000;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := PDate;
        RecRef."Document No." := DocNo;
        RecRef.Validate("Currency Code", CurrencyCode);
        RecRef."Document Date" := TransactionDate;
        RecRef.Validate("Shortcut Dimension 1 Code", Dimension1);
        RecRef.Validate("Shortcut Dimension 2 Code", Dimension2);

    end;

    procedure InitializeEntries(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
    begin
        RecRef.Init;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := Today;
        RecRef."Document No." := DocNo;
        RecRef.Validate("Currency Code", CurrencyCode);
        RecRef."Document Date" := TransactionDate;
        RecRef.Validate("Shortcut Dimension 1 Code", Dimension1);
        RecRef.Validate("Shortcut Dimension 2 Code", Dimension2);

    end;

    procedure InitializeAccEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[100]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
    begin
        RecRef.Init;
        RecRef."Line No." := LineNo + 1000;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := TransactionDate;
        RecRef."Document No." := DocNo;
        RecRef."Document Date" := TransactionDate;
        RecRef.Validate("Shortcut Dimension 1 Code", Dimension1);
        RecRef.Validate("Shortcut Dimension 2 Code", Dimension2);

    end;


    procedure PostCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; TransTeller: Record "Teller Transaction")
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Teller Transaction";
    begin
        GenSetup.Get();

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                TransactionCharges.TestField("G/L Account");
                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Amt * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := (Amt * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;
                    JTemp := TransTeller."Journal Template Name";
                    JBatch := TransTeller."Journal Batch Name";

                    GenJournalLine.LockTable;
                    GenJournalLine.SetRange("Journal Template Name", TransTeller."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", TransTeller."Journal Batch Name");
                    IF GenJournalLine.FindLast() then
                        LineNo := GenJournalLine."Line No." + 10000;

                    InitializeEntry(GenJournalLine, LineNo, TransTeller."Journal Template Name",
                    TransTeller."Journal Batch Name", TransTeller."No.", TransTeller."Currency Code",
                    TransTeller."Transaction Date", TransTeller."Global Dimension 1 Code",
                    TransTeller."Global Dimension 2 Code");

                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.Validate("Account No.", TransTeller."Account No.");
                    GenJournalLine.Description := TransactionCharges.Description;
                    GenJournalLine.Validate(Amount, ChargeAmount);
                    GenJournalLine.Validate("Bal. Account No.", TransactionCharges."G/L Account");
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", TransTeller."Global Dimension 1 Code");
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", TransTeller."Global Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                    if TransactionCharges."Recover Excise Duty" then begin
                        GenSetup.TestField("Excise Duty (%)");
                        GenSetup.TestField("Excise Duty G/L");

                        GenJournalLine.LockTable;
                        GenJournalLine.SetRange("Journal Template Name", TransTeller."Journal Template Name");
                        GenJournalLine.SetRange("Journal Batch Name", TransTeller."Journal Batch Name");
                        IF GenJournalLine.FindLast() then
                            LineNo := GenJournalLine."Line No." + 10000;

                        InitializeEntry(GenJournalLine, LineNo, TransTeller."Journal Template Name",
                        TransTeller."Journal Batch Name", TransTeller."No.", TransTeller."Currency Code",
                        TransTeller."Transaction Date", TransTeller."Global Dimension 1 Code",
                        TransTeller."Global Dimension 2 Code");

                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", AccountNo);
                        GenJournalLine.Description := 'Excise Duty on-' + TransactionCharges.Description;
                        GenJournalLine.Validate(Amount, (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01);
                        GenJournalLine.Validate("Bal. Account No.", GenSetup."Excise Duty G/L");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", TransTeller."Global Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", TransTeller."Global Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;
    end;

    procedure fnPostTransactionCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date; GenLine: Integer)
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
    begin
        GenSetup.Get();

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                TransactionCharges.TestField("G/L Account");
                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Amt * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := (Amt * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;

                    GenJournalLine.LockTable;
                    GenJournalLine.SetRange("Journal Template Name", JTemp);
                    GenJournalLine.SetRange("Journal Batch Name", JBatch);
                    IF GenJournalLine.FindLast() then
                        LineNo := GenJournalLine."Line No." + 10000;
                    InitializeEntry(GenJournalLine, LineNo, JTemp, JBatch, DocNo, '',
                    TransactionDate, Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.Validate("Account No.", AccountNo);
                    GenJournalLine.Description := TransactionCharges.Description;
                    GenJournalLine.Validate(Amount, ChargeAmount);
                    GenJournalLine.Validate("Bal. Account No.", TransactionCharges."G/L Account");
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                    if TransactionCharges."Recover Excise Duty" then begin
                        GenSetup.TestField("Excise Duty (%)");
                        GenSetup.TestField("Excise Duty G/L");
                        GenJournalLine.LockTable;
                        GenJournalLine.SetRange("Journal Template Name", JTemp);
                        GenJournalLine.SetRange("Journal Batch Name", JBatch);
                        IF GenJournalLine.FindLast() then
                            LineNo := GenJournalLine."Line No." + 10000;
                        InitializeEntry(GenJournalLine, LineNo, JTemp, JBatch,
                        DocNo, '', TransactionDate, Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", AccountNo);
                        GenJournalLine.Description := 'Excise Duty on-' + TransactionCharges.Description;
                        GenJournalLine.Validate(Amount, (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01);
                        GenJournalLine.Validate("Bal. Account No.", GenSetup."Excise Duty G/L");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;
    end;


    procedure fnPostAccTransferCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date)
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
    begin
        GenSetup.Get();

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                TransactionCharges.TestField("G/L Account");
                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Amt * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := (Amt * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;

                    GenJournalLine.LockTable;
                    GenJournalLine.SetRange("Journal Template Name", JTemp);
                    GenJournalLine.SetRange("Journal Batch Name", JBatch);
                    IF GenJournalLine.FindLast() then
                        LineNo := GenJournalLine."Line No." + 10000;
                    InitializeEntry(GenJournalLine, LineNo, JTemp, JBatch, DocNo, '',
                    TransactionDate, Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.Validate("Account No.", AccountNo);
                    GenJournalLine.Description := TransactionCharges.Description;
                    GenJournalLine.Validate(Amount, ChargeAmount);
                    GenJournalLine.Validate("Bal. Account No.", TransactionCharges."G/L Account");
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                    if TransactionCharges."Recover Excise Duty" then begin
                        GenSetup.TestField("Excise Duty (%)");
                        GenSetup.TestField("Excise Duty G/L");
                        GenJournalLine.LockTable;
                        GenJournalLine.SetRange("Journal Template Name", JTemp);
                        GenJournalLine.SetRange("Journal Batch Name", JBatch);
                        IF GenJournalLine.FindLast() then
                            LineNo := GenJournalLine."Line No." + 10000;
                        InitializeEntry(GenJournalLine, LineNo, JTemp, JBatch,
                        DocNo, '', TransactionDate, Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", AccountNo);
                        GenJournalLine.Description := 'Excise Duty on-' + TransactionCharges.Description;
                        GenJournalLine.Validate(Amount, (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01);
                        GenJournalLine.Validate("Bal. Account No.", GenSetup."Excise Duty G/L");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;
    end;

    procedure fnPostAccCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date)
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
    begin
        GenSetup.Get();

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                TransactionCharges.TestField("G/L Account");
                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Amt * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := (Amt * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;

                    GenJournalLine.LockTable;
                    GenJournalLine.SetRange("Journal Template Name", JTemp);
                    GenJournalLine.SetRange("Journal Batch Name", JBatch);
                    IF GenJournalLine.FindLast() then
                        LineNo := GenJournalLine."Line No." + 1;
                    InitializeAccEntry(GenJournalLine, LineNo, JTemp, JBatch, DocNo, '',
                    TransactionDate, Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.Validate("Account No.", AccountNo);
                    GenJournalLine.Description := TransactionCharges.Description;
                    GenJournalLine.Validate(Amount, ChargeAmount);
                    GenJournalLine.Validate("Bal. Account No.", TransactionCharges."G/L Account");
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                    if TransactionCharges."Recover Excise Duty" then begin
                        GenSetup.TestField("Excise Duty (%)");
                        GenSetup.TestField("Excise Duty G/L");
                        GenJournalLine.LockTable;
                        GenJournalLine.SetRange("Journal Template Name", JTemp);
                        GenJournalLine.SetRange("Journal Batch Name", JBatch);
                        IF GenJournalLine.FindLast() then
                            LineNo := GenJournalLine."Line No." + 1;
                        InitializeAccEntry(GenJournalLine, LineNo, JTemp, JBatch,
                        DocNo, '', TransactionDate, Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", AccountNo);
                        GenJournalLine.Description := 'Excise Duty on-' + TransactionCharges.Description;
                        GenJournalLine.Validate(Amount, (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01);
                        GenJournalLine.Validate("Bal. Account No.", GenSetup."Excise Duty G/L");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;
    end;

    procedure ChargeOnUndefinedTransType(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatch: Code[10]; DocNo: code[20]; TransactionDate: Date)
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
    begin
        GenSetup.Get();

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                TransactionCharges.TestField("G/L Account");

                ChargeAmount := 0;

                GenJournalLine.LockTable;
                GenJournalLine.SetRange("Journal Template Name", JTemp);
                GenJournalLine.SetRange("Journal Batch Name", JBatch);
                IF GenJournalLine.FindLast() then
                    LineNo := GenJournalLine."Line No." + 10000;
                InitializeAccEntry(GenJournalLine, LineNo, JTemp, JBatch, DocNo, '',
                TransactionDate, Dim1, Dim2);
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.Validate("Account No.", AccountNo);
                GenJournalLine.Description := TransactionCharges.Description;
                GenJournalLine.Validate(Amount, ChargeAmount);
                GenJournalLine.Validate("Bal. Account No.", TransactionCharges."G/L Account");
                GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                if TransactionCharges."Recover Excise Duty" then begin
                    GenSetup.TestField("Excise Duty (%)");
                    GenSetup.TestField("Excise Duty G/L");
                    GenJournalLine.LockTable;
                    GenJournalLine.SetRange("Journal Template Name", JTemp);
                    GenJournalLine.SetRange("Journal Batch Name", JBatch);
                    IF GenJournalLine.FindLast() then
                        LineNo := GenJournalLine."Line No." + 10000;
                    InitializeAccEntry(GenJournalLine, LineNo, JTemp, JBatch,
                    DocNo, '', TransactionDate, Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.Validate("Account No.", AccountNo);
                    GenJournalLine.Description := 'Excise Duty on-' + TransactionCharges.Description;
                    GenJournalLine.Validate(Amount, (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01);
                    GenJournalLine.Validate("Bal. Account No.", GenSetup."Excise Duty G/L");
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);
                end;

            until TransactionCharges.Next = 0;
        end;
    end;


    procedure getBankingTransCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal) TotalChargeAmt: Decimal
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
        ExciseDuty: Decimal;
    begin
        GenSetup.Get();

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                TransactionCharges.TestField("G/L Account");
                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                    ChargeAmount := 0;
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := ChargeAmount + (Amt * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := ChargeAmount + TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := ChargeAmount + (Amt * TariffDetails.Percentage * 0.01);
                                    end else begin
                                        ChargeAmount := ChargeAmount + TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;

                    if TransactionCharges."Recover Excise Duty" then begin
                        ExciseDuty := ExciseDuty + Round((ChargeAmount * (GenSetup."Excise Duty (%)" / 100)));
                    end;
                end;
            until TransactionCharges.Next = 0;
            TotalChargeAmt := (ExciseDuty + ChargeAmount)
        end;
    end;

    local procedure CheckBankersNo(ChequeNo: Code[20]; GlobalDim2: Code[20]; TAmount: Decimal)
    var
        Bregister: Record "Bankers Cheques Register";
        Text00001: Label 'Bankers cheque no has already been used.';
        Text00002: Label 'Bankers cheque amount cannot be more than the leaf limit of %1.';
    begin
        Bregister.Reset;
        Bregister.SetRange(Bregister.Status, Bregister.Status::Pending);
        Bregister.SetRange(Bregister."Global Dimension 2 Code", GlobalDim2);
        Bregister.SetRange(Bregister."Cheque No.", ChequeNo);
        if not Bregister.Find('-') then
            Error(Text00001);

        Bregister.Reset;
        Bregister.SetRange(Bregister.Status, Bregister.Status::Pending);
        Bregister.SetRange(Bregister."Global Dimension 2 Code", GlobalDim2);
        Bregister.SetRange(Bregister."Cheque No.", ChequeNo);
        if Bregister.Find('-') then begin
            if Bregister."Leaf Limit Amount" < TAmount then
                Error(Text00002, Bregister."Leaf Limit Amount");
        end;
    end;

    local procedure fnPostLien(RecRef: Record "Teller Transaction"; JTemplate: Code[20]; JBatch: Code[20]; DBranch: Code[20]; DActivity: Code[20])
    begin

        RecRef.Posted := TRUE;
        RecRef."Date Posted" := TODAY;
        RecRef."Time Posted" := TIME;
        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
        RecRef."Posted By" := USERID;
        RecRef.MODIFY;

    end;

    procedure CalcAvailableBal(AccountNo: Code[100]) Amt: Decimal
    var
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
        ErrorOnAvailableBal: Label 'This account is below Min Balance of % and therefore subsiquent transactions not allowed';
    begin
        MinBalance := 0;
        if Account.Get(AccountNo) then begin
            Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques",
            Account."Authorised Over Draft", Account."Lien Placed", Account."ATM Transactions");
            ProdType.Reset;
            ProdType.SetRange(ProdType."Product ID", Account."Product Type");
            if ProdType.Find('-') then begin
                MinBalance := ProdType."Minimum Balance";
                Amt := Account."Balance (LCY)" - (MinBalance + Account."Uncleared Cheques" + Account."Lien Placed" + Account."ATM Transactions");
            end;
        end;
        exit(Amt)
    end;

    procedure getSubsiquenTransType(ProductType: Code[20]): Code[10]
    var
        TransTypes: Record "Transaction Types";
    begin
        TransTypes.Reset();
        TransTypes.SetRange("Product Type", ProductType);
        TransTypes.SetRange(Type, TransTypes.Type::"Sub Charges");
        if TransTypes.FindFirst() then begin
            exit(TransTypes.Code)
        end;
    end;

    procedure TestNoEntriesExistCust(CurrentFieldName: Code[100]; DocNo: Code[20]; PostEntryVal: Integer): Boolean
    var
        MemberLedgEntry: Record "Cust. Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        case PostEntryVal of
            0:
                begin
                    MemberLedgEntry.SetCurrentKey("Document No.");
                    MemberLedgEntry.SetRange("Document No.", DocNo);
                    MemberLedgEntry.SetRange("Customer No.", CurrentFieldName);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            1:
                begin
                    BankAccLedgEntry.SetCurrentKey("Document No.");
                    BankAccLedgEntry.SetRange("Document No.", DocNo);
                    if BankAccLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;

            2:
                begin
                    VendLedgerEntry.SetCurrentKey("Document No.");
                    VendLedgerEntry.SetRange("Document No.", DocNo);
                    VendLedgerEntry.SetRange(Reversed, true);
                    if VendLedgerEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            3:
                begin
                    MemberLedgEntry.SetCurrentKey("Document No.");
                    MemberLedgEntry.SetRange(Reversed, true);
                    MemberLedgEntry.SetRange("Document No.", DocNo);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)

                end;

        end;
    end;

    procedure TestExtDocNoEntriesExist(CurrentFieldName: Text[150]; DocNo: Code[20]; PostEntryVal: Integer): Boolean
    var
        MemberLedgEntry: Record "Cust. Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLentry: Record "G/L Entry";
    begin
        case PostEntryVal of
            0:
                begin
                    MemberLedgEntry.SetCurrentKey("External Document No.");
                    MemberLedgEntry.SetRange("External Document No.", DocNo);
                    MemberLedgEntry.SetFilter("Transaction Type", '%1', MemberLedgEntry."Transaction Type"::Loan);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            1:
                begin
                    BankAccLedgEntry.SetCurrentKey("External Document No.");
                    BankAccLedgEntry.SetRange("External Document No.", DocNo);
                    if BankAccLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            2:
                begin
                    GLentry.SetCurrentKey("External Document No.");
                    GLentry.Reset();
                    GLentry.SetRange("External Document No.", DocNo);
                    if GLentry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            3:
                begin
                    MemberLedgEntry.SetCurrentKey("External Document No.");
                    MemberLedgEntry.SetRange("External Document No.", DocNo);
                    MemberLedgEntry.SetFilter("Transaction Type", '%1', MemberLedgEntry."Transaction Type"::Loan);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            4:
                begin
                    MemberLedgEntry.SetCurrentKey("External Document No.");
                    MemberLedgEntry.SetRange("External Document No.", DocNo);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            5:
                begin
                    MemberLedgEntry.SetCurrentKey("Document No.");
                    MemberLedgEntry.SetRange("Document No.", DocNo);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;

        end;

    end;

    procedure TestNoEntriesExist(CurrentFieldName: Text[150]; DocNo: Code[20]; PostEntryVal: Integer): Boolean
    var
        MemberLedgEntry: Record "Cust. Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLentry: Record "G/L Entry";
    begin
        case PostEntryVal of
            0:
                begin
                    MemberLedgEntry.SetCurrentKey("Document No.");
                    MemberLedgEntry.SetRange("Document No.", DocNo);
                    MemberLedgEntry.SetRange(Reversed, false);
                    MemberLedgEntry.SetFilter("Transaction Type", '%1', MemberLedgEntry."Transaction Type"::Loan);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            1:
                begin
                    BankAccLedgEntry.SetCurrentKey("Document No.");
                    BankAccLedgEntry.SetRange("Document No.", DocNo);
                    if BankAccLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            2:
                begin
                    GLentry.SetCurrentKey("Document No.");
                    GLentry.Reset();
                    GLentry.SetRange("Document No.", DocNo);
                    if GLentry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            3:
                begin
                    MemberLedgEntry.SetCurrentKey("External Document No.");
                    MemberLedgEntry.SetRange("External Document No.", DocNo);
                    MemberLedgEntry.SetRange(Reversed, false);
                    MemberLedgEntry.SetFilter("Transaction Type", '%1', MemberLedgEntry."Transaction Type"::Loan);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            4:
                begin
                    MemberLedgEntry.SetCurrentKey("External Document No.");
                    MemberLedgEntry.SetRange("External Document No.", DocNo);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;

        end;

    end;

    procedure TestNoReversedEntriesExist(CurrentFieldName: Text[150]; DocNo: Code[20]; PostEntryVal: Integer): Boolean
    var
        MemberLedgEntry: Record "Cust. Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        case PostEntryVal of
            0:
                begin
                    MemberLedgEntry.SetCurrentKey("Document No.");
                    MemberLedgEntry.SetRange("Document No.", DocNo);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            1:
                begin
                    BankAccLedgEntry.SetCurrentKey("Document No.");
                    BankAccLedgEntry.SetRange("Document No.", DocNo);
                    if BankAccLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)

                end;
            2:
                begin
                    VendLedgerEntry.SetCurrentKey("Document No.");
                    VendLedgerEntry.SetRange("Document No.", DocNo);
                    VendLedgerEntry.SetRange(Reversed, true);
                    if VendLedgerEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)
                end;
            3:
                begin

                    MemberLedgEntry.SetCurrentKey("Document No.");
                    MemberLedgEntry.SetRange(Reversed, true);
                    MemberLedgEntry.SetRange("Document No.", DocNo);
                    MemberLedgEntry.SetRange("Transaction Type", MemberLedgEntry."Transaction Type"::Loan);
                    if MemberLedgEntry.FindFirst() then begin
                        exit(true)
                    end;
                    exit(false)

                end;

        end;

    end;

    procedure CheckAccWithdrawalInterval(ProdType: code[20]; AccountNo: Code[100]; AccountCategory: Enum ProductAccountCategory): Boolean
    var
        AccountTypes: Record "Product Factory";
        AccBanking: Record "Account Banking";

    begin

        if AccountTypes.GET(ProdType) then begin

            if AccountTypes."Charge Subsiquent withdrawal" then begin
                AccountTypes.TestField("Withdrawal Interval");

                AccBanking.Reset();
                AccBanking.SetRange("No.", AccountNo);
                if AccBanking.FindFirst() then begin

                    if AccBanking."Next Withdrawal Date" = 0D then begin
                        AccBanking."Last Withdrawal Date" := Today;
                        AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Today);
                        AccBanking.Modify(true);
                        exit(false);
                    end else begin
                        if Today <= AccBanking."Next Withdrawal Date" then begin
                            exit(true)
                        end else begin
                            exit(false)
                        end;
                    end;
                end;
            end else begin
                exit(false)
            end;
        end;
        exit(false)
    end;
}




