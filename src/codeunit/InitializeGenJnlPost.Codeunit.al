codeunit 50046 "Initialize Gen. Jnl.-Post"
{

    trigger OnRun()
    begin
    end;

    var
        Post: Codeunit "Journal Post Mngt.";

    procedure InitializeDebitEntry(Loans: Record Loans; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromLoansHeader(Loans);
        OnAfterInitDebitEntry(RecRef, Loans);
    end;

    procedure InitializeDebitEntryInt(Loans: Record Loans; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromLoansHeaderInt(Loans);
        OnAfterInitDebitEntry(RecRef, Loans);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDebitEntry(var GenJournalLine: Record "Gen. Journal Line"; Loans: Record Loans)
    begin
    end;


    procedure InitializeCreditEntry(AccountBanking: Record "Account Banking"; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromBankingHeader(AccountBanking);
        OnAfterInitCreditEntry(RecRef, AccountBanking);
    end;

    procedure InitializeRepayAccEntry(RepayAcc: Record "Repayment Account"; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromPrepaymentHeader(RepayAcc);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCreditEntry(var GenJournalLine: Record "Gen. Journal Line"; AccountBanking: Record "Account Banking")
    begin
    end;

    procedure InitCreditEntry(AccountBanking: Record "Account Credit"; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromCredAccHeader(AccountBanking);
        OnAfterInitializeCreditEntry(RecRef, AccountBanking);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitializeCreditEntry(var GenJournalLine: Record "Gen. Journal Line"; AccountBanking: Record "Account Credit")
    begin
    end;


    procedure InitChargesEntry(LoanCharge: Record "Loan Charge Posted"; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromLoanCharges(LoanCharge);
        OnAfterInitializeChargesEntry(RecRef, LoanCharge);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitializeChargesEntry(var GenJournalLine: Record "Gen. Journal Line"; LoanCharge: Record "Loan Charge Posted")
    begin
    end;


    procedure InitGenSetupEntry(GeneralSetUp: Record "General Set-Up"; var RecRef: Record "Gen. Journal Line"; LineNo: Integer)
    begin
        RecRef.Init;
        RecRef.CopyFromGeneralsetup(GeneralSetUp);
        OnAfterInitializeGenSetupEntry(RecRef, GeneralSetUp);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitializeGenSetupEntry(var GenJournalLine: Record "Gen. Journal Line"; GeneralSetUp: Record "General Set-Up")
    begin
    end;

    procedure InitializeCreditEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20]; LoanNo: Code[50]; TransType: Enum "LoanTransactionType")
    begin
        RecRef.Init;
        RecRef."Line No." := LineNo;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := Today;
        RecRef."Document No." := DocNo;
        RecRef.Validate("Currency Code", CurrencyCode);
        RecRef."Document Date" := TransactionDate;
        RecRef.Validate("Shortcut Dimension 1 Code", Dimension1);
        RecRef.Validate("Shortcut Dimension 2 Code", Dimension2);

    end;

    procedure CreateBalancingAcc(LineNo: Integer; JTemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal; PDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; AccNo: Code[20]; AccType: Enum "Gen. Journal Account Type"; DescriptText: Text[150]; CurrCode: Code[20]; TransType: Enum "LoanTransactionType")
    begin
        Post.PostJournal(JTemplate, JBatch, LineNo, AccType, DocNo, DescriptText,
        Amt, AccNo, PDate, Enum::"Gen. Journal Account Type"::"G/L Account", '', ExtDocNo, Dim1, Dim2, TransType, '', '', '',
        Enum::"Gen. Journal Document Type"::" ", CurrCode, Enum::"Gen. Journal Document Type"::" ")
    end;

    procedure ValuePost(RecNo: Code[100]; DocNo: Code[20]; ExtDocNo: Code[20]; SourceType: Enum "Gen. Journal Source Type"): Boolean
    var
        CreditLedger: Record "Loan Ledger Entry";
        LoansT: Record Loans;
        OtherCommit: Record "Other Commitements Clearance";
        AccBanking: Record "Account Banking";
        LoanApplication: Record "Loan Application";
        LoanCategory: Record "Loans Categorization";
        MonthlyContrib: Record "Member Monthly Contribution";
        LoanApplic: Record "Loan Application";
        VendLedger: Record "Vendor Ledger Entry";
        CustLedger: Record "Cust. Ledger Entry";
        BankAccLedger: Record "Bank Account Ledger Entry";
        SavingsLedger: Record "Banking A/c Ledger Entry";
        CreditAccLedger: Record "Credits A/c Ledger Entry";
        RepayLedger: Record "Repayment Ledger Entry";

    begin

        case SourceType of
            SourceType::Vendor:
                begin
                    VendLedger.Reset();
                    VendLedger.SetRange("Document No.", DocNo);
                    VendLedger.SetRange("External Document No.", ExtDocNo);
                    if VendLedger.FindFirst() then
                        exit(true)
                end;
            SourceType::Customer:
                begin
                    CustLedger.Reset();
                    CustLedger.SetRange("Document No.", DocNo);
                    CustLedger.SetRange("External Document No.", ExtDocNo);
                    if CustLedger.FindFirst() then
                        exit(true)
                end;
            SourceType::"Bank Account":
                begin
                    BankAccLedger.Reset();
                    BankAccLedger.SetRange("Document No.", DocNo);
                    BankAccLedger.SetRange("External Document No.", ExtDocNo);
                    if BankAccLedger.FindFirst() then
                        exit(true)
                end;
            SourceType::Savings:
                begin
                    SavingsLedger.Reset();
                    SavingsLedger.SetRange("Document No.", DocNo);
                    SavingsLedger.SetRange("External Document No.", ExtDocNo);
                    if SavingsLedger.FindFirst() then
                        exit(true)

                end;
            SourceType::Credit:
                begin
                    CreditAccLedger.Reset();
                    CreditAccLedger.SetRange("Document No.", DocNo);
                    CreditAccLedger.SetRange("External Document No.", ExtDocNo);
                    if CreditAccLedger.FindFirst() then
                        exit(true)
                end;
            SourceType::Repayment:
                begin
                    RepayLedger.Reset();
                    RepayLedger.SetRange("Document No.", DocNo);
                    RepayLedger.SetRange("External Document No.", ExtDocNo);
                    if RepayLedger.FindFirst() then
                        exit(true)

                end;
            SourceType::Loan:
                begin
                    CreditLedger.Reset();
                    CreditLedger.SetRange("Loan No.", RecNo);
                    CreditLedger.SetRange("Document No.", DocNo);
                    CreditLedger.SetRange("Transaction Type", CreditLedger."Transaction Type"::Loan);
                    if CreditLedger.FindFirst() then begin
                        exit(true)
                    end
                end;
        end;
    end;





}




