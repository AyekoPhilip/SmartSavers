codeunit 50057 "CreditMgtEvents"
{

    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        CurrencyFactor: Decimal;
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
        GLSourceCode: Code[10];
        TempGLEntryBuf: Record "G/L Entry" temporary;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostCust', '', false, false)]
    local procedure OnAfterCustLedgEntryInsertCredit(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        SavAcc: Record "Account Credit";
        SavAccLedgEntry: Record "Credits A/c Ledger Entry";
        SavAccPostingGr: Record "Customer Posting Group";
        ReceivablesAccount: Code[20];
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        SalesSetup: Record "Sales & Receivables Setup";
        CreditsAcc: Record "Credit Account";
        CreditsAccLedgEntry: Record "Loan Ledger Entry";
        CreditsAccPostingGr: Record "Customer Posting Group";
        PFact: Record "Product Factory";
        PLoan: Record Loans;
        IsPostingSetupNotificationEnabled: Label 'Transaction Type blocked for %1-%2-%3';
    begin

        case GenJournalLine."Account Dimension" of
            GenJournalLine."Account Dimension"::Credit:
                begin

                    SavAcc.Get(GenJournalLine."Account No.");
                    SavAcc.CheckBlockedCustOnJnls(SavAcc, GenJournalLine."Document Type", true);
                    if GenJournalLine."Posting Group" = '' then begin
                        SavAcc.TestField("Customer Posting Group");
                        GenJournalLine."Posting Group" := SavAcc."Customer Posting Group";
                    end;
                    SavAccPostingGr.Get(GenJournalLine."Posting Group");
                    ReceivablesAccount := GetCustomerReceivablesAccount(GenJournalLine, SavAccPostingGr);

                    SavAccLedgEntry.LockTable;
                    InitCreditAccLedgEntryCust(GenJournalLine, SavAccLedgEntry, NextEntryNo, NextTransactionNo);
                    SavAccLedgEntry."Customer Posting Group" := SavAcc."Customer Posting Group";
                    SavAccLedgEntry."Currency Code." := SavAcc."Currency Code";
                    if SavAcc."Currency Code" <> '' then
                        SavAccLedgEntry.Amount := GenJournalLine.Amount
                    else
                        SavAccLedgEntry.Amount := GenJournalLine."Amount (LCY)";
                    SavAccLedgEntry."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    SavAccLedgEntry.Open := GenJournalLine.Amount <> 0;
                    SavAccLedgEntry."Remaining Amount" := SavAccLedgEntry.Amount;
                    SavAccLedgEntry.Positive := GenJournalLine.Amount > 0;
                    SavAccLedgEntry."Member No." := SavAcc."Member No.";
                    SavAccLedgEntry.UpdateDebitCredit(GenJournalLine.Correction);
                    SavAccLedgEntry.Insert(true);
                end;
            GenJournalLine."Account Dimension"::Loan:
                begin

                    CreditsAcc.Get(GenJournalLine."Account No.");
                    CreditsAcc.CheckBlockedCustOnJnls(CreditsAcc, GenJournalLine."Document Type", true);

                    if GenJournalLine."Currency Code" = '' then
                        CreditsAcc.TestField("Currency Code", '')
                    else
                        if CreditsAcc."Currency Code" <> '' then
                            GenJournalLine.TestField("Currency Code", CreditsAcc."Currency Code");

                    CreditsAcc.TestField("Customer Posting Group");
                    CreditsAccPostingGr.Get(GenJournalLine."Posting Group");
                    GenJournalLine.TestField("Loan No.");
                    PLoan.Reset;
                    PLoan.SetRange("No.", GenJournalLine."Loan No.");
                    if PLoan.Find('-') then
                        PLoan.TestField("Loan Account", GenJournalLine."Account No.");
                    ReceivablesAccount := PFact.fnReceivablesAccount(PLoan."Product Type", GenJournalLine."Transaction Type");

                    if ReceivablesAccount = '' then
                        Error(IsPostingSetupNotificationEnabled, GenJournalLine."Account No.", GenJournalLine."Line No.", GenJournalLine.Description);
                    CreditsAccLedgEntry.LockTable;
                    OnPostLoanAccOnBeforeInitLoanAccLedgEntry(GenJournalLine, CurrencyFactor,
                    NextEntryNo, NextTransactionNo);

                    InitLoanAccLedgEntry(GenJournalLine, CreditsAccLedgEntry, NextEntryNo, NextTransactionNo);
                    CreditsAccLedgEntry."Transaction Type" := GenJournalLine."Transaction Type";
                    CreditsAccLedgEntry."Loan No." := GenJournalLine."Loan No.";
                    CreditsAccLedgEntry."Customer Posting Group" := CreditsAcc."Customer Posting Group";
                    CreditsAccLedgEntry."Currency Code" := CreditsAcc."Currency Code";
                    if CreditsAcc."Currency Code" <> '' then
                        CreditsAccLedgEntry.Amount := GenJournalLine.Amount
                    else
                        CreditsAccLedgEntry.Amount := GenJournalLine."Amount (LCY)";
                    CreditsAccLedgEntry."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    CreditsAccLedgEntry.Open := GenJournalLine.Amount <> 0;
                    CreditsAccLedgEntry."Remaining Amount" := CreditsAccLedgEntry.Amount;
                    CreditsAccLedgEntry.Positive := GenJournalLine.Amount > 0;
                    CreditsAccLedgEntry.UpdateDebitCredit(GenJournalLine.Correction);
                    OnPostLoanAccOnBeforeLoanAccLedgEntryInsert(
                    CreditsAccLedgEntry, GenJournalLine, CreditsAcc);
                    CreditsAccLedgEntry.Insert(true);
                    OnPostLoanAccOnAfterLoanAccLedgEntryInsert(CreditsAccLedgEntry,
                    GenJournalLine, CreditsAcc);

                end;

        end

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterGetCustomerReceivablesAccount', '', false, false)]
    local procedure fnGetCustomerReceivableAccount(GenJournalLine: Record "Gen. Journal Line"; CustomerPostingGroup: Record "Customer Posting Group"; var ReceivablesAccount: Code[20])
    var
        SavAcc: Record Customer;
        SavAccPostingGr: Record "Customer Posting Group";
        PFact: Record "Product Factory";
        PLoan: Record Loans;
        IsPostingSetupNotificationEnabled: Label 'Transaction Type blocked for %1-%2-%3';
    begin
        case GenJournalLine."Account Dimension" of
            GenJournalLine."Account Dimension"::" ",
            GenJournalLine."Account Dimension"::Credit:
                begin

                    SavAcc.Get(GenJournalLine."Account No.");
                    SavAcc.CheckBlockedCustOnJnls(SavAcc, GenJournalLine."Document Type", true);
                    if GenJournalLine."Posting Group" = '' then begin
                        SavAcc.TestField("Customer Posting Group");
                        GenJournalLine."Posting Group" := SavAcc."Customer Posting Group";
                    end;

                    CustomerPostingGroup.Get(GenJournalLine."Posting Group");
                    ReceivablesAccount := GetCustomerReceivablesAccount(GenJournalLine, CustomerPostingGroup);

                end;
            GenJournalLine."Account Dimension"::Loan:
                begin

                    GenJournalLine.TestField("Loan No.");
                    PLoan.Reset;
                    PLoan.SetRange("No.", GenJournalLine."Loan No.");
                    if PLoan.Find('-') then
                        PLoan.TestField("Loan Account", GenJournalLine."Account No.");
                    ReceivablesAccount := PFact.fnReceivablesAccount(PLoan."Product Type", GenJournalLine."Transaction Type");
                    if ReceivablesAccount = '' then
                        Error(IsPostingSetupNotificationEnabled, GenJournalLine."Account No.", GenJournalLine."Line No.", GenJournalLine.Description);
                end;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostVend', '', false, false)]
    local procedure OnAfterVendLedgEntryInsertCredit(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        SavAcc: Record "Account Banking";
        SavAccLedgEntry: Record "Banking A/c Ledger Entry";
        SavAccPostingGr: Record "Vendor Posting Group";
        ReceivablesAccount: Code[20];
        IsHandled: Boolean;
    begin

        if SavAcc.Get(GenJournalLine."Account No.") then begin
            SavAcc.CheckBlockedCustOnJnls(SavAcc, GenJournalLine."Document Type", true);

            if GenJournalLine."Currency Code" = '' then
                SavAcc.TestField("Currency Code", '')
            else
                if SavAcc."Currency Code" <> '' then
                    GenJournalLine.TestField("Currency Code", SavAcc."Currency Code");

            SavAcc.TestField("Customer Posting Group");
            SavAccPostingGr.Get(SavAcc."Customer Posting Group");
            ReceivablesAccount := SavAccPostingGr."Payables Account";
            SavAccLedgEntry.LockTable;
            OnPostSavAccOnBeforeInitSavAccLedgEntry(GenJournalLine, CurrencyFactor, NextEntryNo, NextTransactionNo, SavAccPostingGr);
            InitSavAccLedgEntry(GenJournalLine, SavAccLedgEntry, NextEntryNo, NextTransactionNo);
            SavAccLedgEntry."Customer Posting Group" := SavAcc."Customer Posting Group";
            SavAccLedgEntry."Currency Code." := SavAcc."Currency Code";
            if SavAcc."Currency Code" <> '' then
                SavAccLedgEntry.Amount := GenJournalLine.Amount
            else
                SavAccLedgEntry.Amount := GenJournalLine."Amount (LCY)";
            SavAccLedgEntry."Amount (LCY)" := GenJournalLine."Amount (LCY)";
            SavAccLedgEntry.Open := GenJournalLine.Amount <> 0;
            SavAccLedgEntry."Remaining Amount" := SavAccLedgEntry.Amount;
            SavAccLedgEntry.Positive := GenJournalLine.Amount > 0;
            SavAccLedgEntry.UpdateDebitCredit(GenJournalLine.Correction);
            OnPostSavAccOnBeforeSavAccLedgEntryInsert(SavAccLedgEntry, GenJournalLine, SavAcc, TempGLEntryBuf, NextTransactionNo);
            SavAccLedgEntry.Insert(true);
            OnPostSavAccOnAfterSavAccLedgEntryInsert(SavAccLedgEntry, GenJournalLine, SavAcc);
            OnPostBankAccOnBeforeCreateGLEntryBalAcc(GenJournalLine, SavAccPostingGr, SavAcc, NextEntryNo, IsHandled);
        end;
    end;

    local procedure GetCustomerReceivablesAccount(GenJournalLine: Record "Gen. Journal Line"; CustomerPostingGroup: Record "Customer Posting Group") ReceivablesAccount: Code[20]
    begin
        ReceivablesAccount := CustomerPostingGroup.GetReceivablesAccount();
        OnAfterGetCustomerReceivablesAccount(GenJournalLine, CustomerPostingGroup, ReceivablesAccount);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCustomerReceivablesAccount(GenJournalLine: Record "Gen. Journal Line"; CustomerPostingGroup: Record "Customer Posting Group"; var ReceivablesAccount: Code[20])
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure fnCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        CustMemb: Record Customer;
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
            if CustMemb.get(GenJournalLine."Account No.") then begin
                CustLedgerEntry."Member No." := CustMemb."Member No.";
                CustLedgerEntry."Transaction Type" := GenJournalLine."Transaction Type";
                CustLedgerEntry."Loan No." := GenJournalLine."Loan No.";
            end
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Detailed CV Ledg. Entry Buffer", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure fnOnAfterCopyFromGenJnlLine(var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line")
    var
        CustMemb: Record Customer;
    begin
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
            if CustMemb.get(GenJnlLine."Account No.") then begin
                DtldCVLedgEntryBuffer."Member No." := CustMemb."Member No.";
                DtldCVLedgEntryBuffer."Transaction Type" := GenJnlLine."Transaction Type";
                DtldCVLedgEntryBuffer."Loan No." := GenJnlLine."Loan No.";
            end
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGenJnlLine', '', false, false)]
    local procedure PostCreditOnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        CreditPostMngt: Codeunit "Gen. Jnl.-Post Line";
    begin
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Saving:
                PostSavingsAcc(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::Credit:
                PostCreditAcc(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::Loan:
                PostLoanAcc(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::Prepayment:
                PostRepaymentAcc(GenJournalLine, Balancing);
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GenJnlManagement, 'OnAfterGetAccounts', '', false, false)]
    local procedure GetAccountNamesOnAfterGetAccounts(var GenJournalLine: Record "Gen. Journal Line"; var AccName: Text[100]; var BalAccName: Text[100])
    var
        AccountBanking: Record "Account Banking";
        AccountCredit: Record "Account Credit";
        CreditAccounts: Record "Credit Account";
        RepaymentAccount: Record "Repayment Account";
    begin
        if GenJournalLine."Account No." <> '' then
            case GenJournalLine."Account Type" of
                GenJournalLine."Account Type"::Saving:
                    if AccountBanking.Get(GenJournalLine."Account No.") then
                        AccName := AccountBanking.Name;
                GenJournalLine."Account Type"::Credit:
                    if AccountCredit.Get(GenJournalLine."Account No.") then
                        AccName := AccountCredit.Name;
                GenJournalLine."Account Type"::Loan:
                    if CreditAccounts.Get(GenJournalLine."Account No.") then
                        AccName := CreditAccounts.Name;
                GenJournalLine."Account Type"::Prepayment:
                    if RepaymentAccount.Get(GenJournalLine."Account No.") then
                        AccName := RepaymentAccount.Name;
            end
    end;

    local procedure PostSavingsAcc(GenJnlLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        SavAcc: Record "Account Banking";
        SavAccLedgEntry: Record "Banking A/c Ledger Entry";
        SavAccPostingGr: Record "Vendor Posting Group";
        ReceivablesAccount: Code[20];
        IsHandled: Boolean;
    begin

        SavAcc.Get(GenJnlLine."Account No.");
        SavAcc.CheckBlockedCustOnJnls(SavAcc, GenJnlLine."Document Type", true);

        if GenJnlLine."Currency Code" = '' then
            SavAcc.TestField("Currency Code", '')
        else
            if SavAcc."Currency Code" <> '' then
                GenJnlLine.TestField("Currency Code", SavAcc."Currency Code");


        SavAcc.TestField("Customer Posting Group");
        SavAccPostingGr.Get(SavAcc."Customer Posting Group");
        ReceivablesAccount := SavAccPostingGr."Payables Account";
        SavAccLedgEntry.LockTable;
        OnPostSavAccOnBeforeInitSavAccLedgEntry(GenJnlLine, CurrencyFactor, NextEntryNo, NextTransactionNo, SavAccPostingGr);
        InitSavAccLedgEntry(GenJnlLine, SavAccLedgEntry, NextEntryNo, NextTransactionNo);
        SavAccLedgEntry."Customer Posting Group" := SavAcc."Customer Posting Group";
        SavAccLedgEntry."Currency Code." := SavAcc."Currency Code";
        if SavAcc."Currency Code" <> '' then
            SavAccLedgEntry.Amount := GenJnlLine.Amount
        else
            SavAccLedgEntry.Amount := GenJnlLine."Amount (LCY)";
        SavAccLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        SavAccLedgEntry.Open := GenJnlLine.Amount <> 0;
        SavAccLedgEntry."Remaining Amount" := SavAccLedgEntry.Amount;
        SavAccLedgEntry.Positive := GenJnlLine.Amount > 0;
        SavAccLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        OnPostSavAccOnBeforeSavAccLedgEntryInsert(SavAccLedgEntry, GenJnlLine, SavAcc, TempGLEntryBuf, NextTransactionNo);
        SavAccLedgEntry.Insert(true);
        OnPostSavAccOnAfterSavAccLedgEntryInsert(SavAccLedgEntry, GenJnlLine, SavAcc);
        //OnPostBankAccOnBeforeCreateGLEntryBalAcc(GenJnlLine, SavAccPostingGr, SavAcc, NextEntryNo, IsHandled);

    end;

    [IntegrationEvent(true, false)]
    local procedure OnPostBankAccOnBeforeCreateGLEntryBalAcc(var GenJnlLine: Record "Gen. Journal Line"; BankAccPostingGr: Record "Vendor Posting Group"; BankAccount: Record "Account Banking"; NextEntryNo: Integer; var IsHandled: Boolean)
    begin
    end;

    local procedure InitSavAccLedgEntry(GenJnlLine: Record "Gen. Journal Line"; var SavAccLedgEntry: Record "Banking A/c Ledger Entry"; NextEntryNos: Integer; NextTransactionNos: Integer)
    begin
        SavAccLedgEntry.Init;
        SavAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        SavAccLedgEntry."Entry No." := NextEntryNos;
        SavAccLedgEntry."Transaction No." := NextTransactionNos;
        OnAfterInitSavAccLedgEntry(SavAccLedgEntry, GenJnlLine)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitSavAccLedgEntry(var BankAccountLedgerEntry: Record "Banking A/c Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostSavAccOnAfterSavAccLedgEntryInsert(var SavAccountLedgerEntry: Record "Banking A/c Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; SavAccount: Record "Account Banking")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostSavAccOnBeforeInitSavAccLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CurrencyFactor: Decimal; var NextEntryNo: Integer; var NextTransactionNo: Integer; var SavAccPostingGr: Record "Vendor Posting Group")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostSavAccOnBeforeSavAccLedgEntryInsert(var SavAccountLedgerEntry: Record "Banking A/c Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; SavAccount: Record "Account Banking"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextTransactionNo: Integer)
    begin
    end;

    local procedure PostCreditAcc(GenJnlLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        SavAcc: Record "Account Credit";
        SavAccLedgEntry: Record "Credits A/c Ledger Entry";
        SavAccPostingGr: Record "Customer Posting Group";
        ReceivablesAccount: Code[20];
    begin

        SavAcc.Get(GenJnlLine."Account No.");
        SavAcc.CheckBlockedCustOnJnls(SavAcc, GenJnlLine."Document Type", true);
        if GenJnlLine."Currency Code" = '' then
            SavAcc.TestField("Currency Code", '')
        else
            if SavAcc."Currency Code" <> '' then
                GenJnlLine.TestField("Currency Code", SavAcc."Currency Code");
        SavAcc.TestField("Customer Posting Group");
        SavAccPostingGr.Get(GenJnlLine."Posting Group");
        ReceivablesAccount := SavAccPostingGr.GetReceivablesAccount;

        SavAccLedgEntry.LockTable;
        OnPostCreditAccOnBeforeInitCreditAccLedgEntry(GenJnlLine, CurrencyFactor,
        NextEntryNo, NextTransactionNo);

        InitCreditAccLedgEntry(GenJnlLine, SavAccLedgEntry);
        SavAccLedgEntry."Customer Posting Group" := SavAcc."Customer Posting Group";
        SavAccLedgEntry."Currency Code." := SavAcc."Currency Code";
        if SavAcc."Currency Code" <> '' then
            SavAccLedgEntry.Amount := GenJnlLine.Amount
        else
            SavAccLedgEntry.Amount := GenJnlLine."Amount (LCY)";
        SavAccLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        SavAccLedgEntry.Open := GenJnlLine.Amount <> 0;
        SavAccLedgEntry."Remaining Amount" := SavAccLedgEntry.Amount;
        SavAccLedgEntry.Positive := GenJnlLine.Amount > 0;
        SavAccLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        OnPostCreditAccOnBeforeCreditAccLedgEntryInsert(SavAccLedgEntry, GenJnlLine, SavAcc);
        SavAccLedgEntry.Insert(true);
        OnPostCreditAccOnAfterCreditAccLedgEntryInsert(SavAccLedgEntry, GenJnlLine, SavAcc);
        GenJnlPostLine.CreateGLEntryBalAcc(
        GenJnlLine, ReceivablesAccount, GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount",
        GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");

    end;

    local procedure InitCreditAccLedgEntry(GenJnlLine: Record "Gen. Journal Line"; var SavAccLedgEntry: Record "Credits A/c Ledger Entry")
    begin
        SavAccLedgEntry.Init;
        SavAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        SavAccLedgEntry."Entry No." := NextEntryNo;
        SavAccLedgEntry."Transaction No." := NextTransactionNo;
        OnAfterInitCreditAccLedgEntry(SavAccLedgEntry, GenJnlLine)
    end;

    local procedure InitCreditAccLedgEntryCust(GenJnlLine: Record "Gen. Journal Line"; var SavAccLedgEntry: Record "Credits A/c Ledger Entry"; NextNumb: Integer; NextTransNo: Integer)
    begin
        SavAccLedgEntry.Init;
        SavAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        SavAccLedgEntry."Entry No." := NextNumb;
        SavAccLedgEntry."Transaction No." := NextTransNo;
        OnAfterInitCreditAccLedgEntry(SavAccLedgEntry, GenJnlLine)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCreditAccLedgEntry(var BankAccountLedgerEntry: Record "Credits A/c Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCreditAccOnAfterCreditAccLedgEntryInsert(var SavAccountLedgerEntry: Record "Credits A/c Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; SavAccount: Record "Account Credit")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCreditAccOnBeforeInitCreditAccLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CurrencyFactor: Decimal; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCreditAccOnBeforeCreditAccLedgEntryInsert(var SavAccountLedgerEntry: Record "Credits A/c Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; SavAccount: Record "Account Credit")
    begin
    end;

    local procedure PostLoanAcc(GenJnlLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        CreditsAcc: Record "Credit Account";
        CreditsAccLedgEntry: Record "Loan Ledger Entry";
        CreditsAccPostingGr: Record "Customer Posting Group";
        ReceivablesAccount: Code[20];
        PFact: Record "Product Factory";
        PLoan: Record Loans;
        IsPostingSetupNotificationEnabled: Label 'Transaction Type blocked for %1-%2-%3';
    begin

        CreditsAcc.Get(GenJnlLine."Account No.");
        CreditsAcc.CheckBlockedCustOnJnls(CreditsAcc, GenJnlLine."Document Type", true);

        if GenJnlLine."Currency Code" = '' then
            CreditsAcc.TestField("Currency Code", '')
        else
            if CreditsAcc."Currency Code" <> '' then
                GenJnlLine.TestField("Currency Code", CreditsAcc."Currency Code");

        CreditsAcc.TestField("Customer Posting Group");
        CreditsAccPostingGr.Get(GenJnlLine."Posting Group");
        GenJnlLine.TestField("Loan No.");
        PLoan.Reset;
        PLoan.SetRange("No.", GenJnlLine."Loan No.");
        if PLoan.Find('-') then
            ReceivablesAccount := PFact.fnReceivablesAccount(PLoan."Product Type", GenJnlLine."Transaction Type");

        if ReceivablesAccount = '' then
            Error(IsPostingSetupNotificationEnabled, GenJnlLine."Account No.", GenJnlLine."Line No.", GenJnlLine.Description);
        CreditsAccLedgEntry.LockTable;
        OnPostLoanAccOnBeforeInitLoanAccLedgEntry(GenJnlLine, CurrencyFactor,
        NextEntryNo, NextTransactionNo);

        InitLoanAccLedgEntry(GenJnlLine, CreditsAccLedgEntry, NextEntryNo, NextTransactionNo);

        CreditsAccLedgEntry."Transaction Type" := GenJnlLine."Transaction Type";
        CreditsAccLedgEntry."Loan No." := GenJnlLine."Loan No.";
        CreditsAccLedgEntry."Customer Posting Group" := GenJnlLine."Posting Group";
        CreditsAccLedgEntry."Customer Posting Group" := CreditsAcc."Customer Posting Group";
        CreditsAccLedgEntry."Currency Code" := CreditsAcc."Currency Code";
        if CreditsAcc."Currency Code" <> '' then
            CreditsAccLedgEntry.Amount := GenJnlLine.Amount
        else
            CreditsAccLedgEntry.Amount := GenJnlLine."Amount (LCY)";
        CreditsAccLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        CreditsAccLedgEntry.Open := GenJnlLine.Amount <> 0;
        CreditsAccLedgEntry."Remaining Amount" := CreditsAccLedgEntry.Amount;
        CreditsAccLedgEntry.Positive := GenJnlLine.Amount > 0;
        CreditsAccLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);

        OnPostLoanAccOnBeforeLoanAccLedgEntryInsert(CreditsAccLedgEntry, GenJnlLine, CreditsAcc);

        CreditsAccLedgEntry.Insert(true);
        OnPostLoanAccOnAfterLoanAccLedgEntryInsert(CreditsAccLedgEntry, GenJnlLine, CreditsAcc);

        GenJnlPostLine.CreateGLEntryBalAcc(GenJnlLine, ReceivablesAccount, GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount",
        GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");

    end;

    local procedure InitLoanAccLedgEntry(GenJnlLine: Record "Gen. Journal Line"; var CreditsAccLedgEntry: Record "Loan Ledger Entry"; NextEntryNos: Integer; NextTransactionNos: Integer)
    begin

        CreditsAccLedgEntry.Init;
        CreditsAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        CreditsAccLedgEntry."Entry No." := NextEntryNos;
        CreditsAccLedgEntry."Transaction No." := NextTransactionNos;
        OnAfterInitLoanAccLedgEntry(CreditsAccLedgEntry, GenJnlLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanAccLedgEntry(var CreditsAccountLedgerEntry: Record "Loan Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanAccOnAfterLoanAccLedgEntryInsert(var CreditsAccountLedgerEntry: Record "Loan Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; CreditsAccount: Record "Credit Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanAccOnBeforeInitLoanAccLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CurrencyFactor: Decimal; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanAccOnBeforeLoanAccLedgEntryInsert(var CreditsAccountLedgerEntry: Record "Loan Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; CreditsAccount: Record "Credit Account")
    begin
    end;

    local procedure PostRepaymentAcc(GenJnlLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        SavAcc: Record "Repayment Account";
        SavAccLedgEntry: Record "Repayment Ledger Entry";
        SavAccPostingGr: Record "Customer Posting Group";
        ReceivablesAccount: Code[20];
    begin

        SavAcc.Get(GenJnlLine."Account No.");
        SavAcc.CheckBlockedCustOnJnls(SavAcc, GenJnlLine."Document Type", true);
        if GenJnlLine."Currency Code" = '' then
            SavAcc.TestField("Currency Code", '')
        else
            if SavAcc."Currency Code" <> '' then
                GenJnlLine.TestField("Currency Code", SavAcc."Currency Code");
        SavAcc.TestField("Customer Posting Group");
        SavAccPostingGr.Get(GenJnlLine."Posting Group");
        ReceivablesAccount := SavAccPostingGr.GetReceivablesAccount;

        SavAccLedgEntry.LockTable;
        OnPostRepaymentAccOnBeforeInitRepayAccLedgEntry(GenJnlLine, CurrencyFactor,
        NextEntryNo, NextTransactionNo);

        InitRepaymentAccLedgEntry(GenJnlLine, SavAccLedgEntry);
        SavAccLedgEntry."Customer Posting Group" := SavAcc."Customer Posting Group";
        SavAccLedgEntry."Currency Code" := SavAcc."Currency Code";
        if SavAcc."Currency Code" <> '' then
            SavAccLedgEntry.Amount := GenJnlLine.Amount
        else
            SavAccLedgEntry.Amount := GenJnlLine."Amount (LCY)";
        SavAccLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        SavAccLedgEntry.Open := GenJnlLine.Amount <> 0;
        SavAccLedgEntry."Remaining Amount" := SavAccLedgEntry.Amount;
        SavAccLedgEntry.Positive := GenJnlLine.Amount > 0;
        SavAccLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        OnPostRepaymentAccOnBeforeRepayAccLedgEntryInsert(SavAccLedgEntry, GenJnlLine, SavAcc);
        SavAccLedgEntry.Insert(true);
        OnPostRepaymentAccOnAfterRepayAccLedgEntryInsert(SavAccLedgEntry, GenJnlLine, SavAcc);

        GenJnlPostLine.CreateGLEntryBalAcc(GenJnlLine, ReceivablesAccount, GenJnlLine."Amount (LCY)",
        GenJnlLine."Source Currency Amount", GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");

    end;

    local procedure InitRepaymentAccLedgEntry(GenJnlLine: Record "Gen. Journal Line"; var SavAccLedgEntry: Record "Repayment Ledger Entry")
    begin
        SavAccLedgEntry.Init;
        SavAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        SavAccLedgEntry."Entry No." := NextEntryNo;
        SavAccLedgEntry."Transaction No." := NextTransactionNo;
        OnAfterInitRepaymentAccLedgEntry(SavAccLedgEntry, GenJnlLine)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitRepaymentAccLedgEntry(var BankAccountLedgerEntry: Record "Repayment Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostRepaymentAccOnAfterRepayAccLedgEntryInsert(var SavAccountLedgerEntry: Record "Repayment Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; SavAccount: Record "Repayment Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostRepaymentAccOnBeforeInitRepayAccLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CurrencyFactor: Decimal; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostRepaymentAccOnBeforeRepayAccLedgEntryInsert(var SavAccountLedgerEntry: Record "Repayment Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; SavAccount: Record "Repayment Account")
    begin
    end;

    local procedure DeferralPosting(DeferralCode: Code[10]; SourceCode: Code[10]; AccountNo: Code[20]; var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnValidateAccountNoOnAfterAssignValue', '', false, false)]
    local procedure GetCreditAccounts(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line")
    begin
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Customer:
                GenJournalLine.GetCustMemberSavingsAccount();
            GenJournalLine."Account Type"::Saving:
                GenJournalLine.GetSavingsAccount();
            GenJournalLine."Account Type"::Credit:
                GenJournalLine.GetCreditAccount();
            GenJournalLine."Account Type"::Loan:
                GenJournalLine.GetLoanAccount();
            GenJournalLine."Account Type"::Prepayment:
                GenJournalLine.GetRepaymentAccount();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnValidateBalAccountNoOnAfterAssignValue', '', false, false)]
    local procedure GetCreditBalAccounts(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line")
    begin
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Saving:
                GenJournalLine.GetSavingsBalAccount();
            GenJournalLine."Account Type"::Credit:
                GenJournalLine.GetCreditBalAccount();
            GenJournalLine."Account Type"::Loan:
                GenJournalLine.GetLoanBalAccount();
            GenJournalLine."Account Type"::Prepayment:
                GenJournalLine.GetRepaymentBalAccount();
        end;
    end;


    local procedure InitNextEntryNo()
    var
        GLEntry: Record "G/L Entry";
        LastEntryNo: Integer;
        LastTransactionNo: Integer;
    begin
        /* GLEntry.LockTable();
        GLEntry.GetLastEntry(LastEntryNo, LastTransactionNo);
        NextEntryNo := LastEntryNo + 1;
        NextTransactionNo := LastTransactionNo + 1; */
    end;

}




