tableextension 50050 "Gen_JournalExt" extends "Gen. Journal Line"
{
    fields
    {

        modify("Account No.")
        {

            TableRelation = if ("Account Type" = const(Vendor), "Account Dimension" = const(" ")) Vendor where("Account Type" = const(" "))
            else
            if ("Account Type" = const(Vendor), "Account Dimension" = const(Banking)) Vendor where("Account Type" = const(Banking))
            else
            if ("Account Type" = const(Customer), "Account Dimension" = const(" ")) Customer where("Account Type" = const(" "))
            ELSE
            IF ("Account Type" = CONST(Customer), "Account Dimension" = CONST(Banking)) Customer WHERE("Account Type" = CONST("Credit Account"))
            ELSE
            IF ("Account Type" = CONST(Customer), "Account Dimension" = CONST(Repayment)) Customer WHERE("Account Type" = CONST("Loan Account"))
            else
            if ("Account Type" = const(Saving)) "Account Banking" where(Blocked = CONST(" "), Status = CONST(Active))
            else
            if ("Account Type" = const(Credit)) "Account Credit" where(Blocked = CONST(" "), Status = CONST(Active))
            else
            if ("Account Type" = const(Loan)) "Credit Account" where(Blocked = CONST(" "), Status = CONST(Active))
            else
            if ("Account Type" = const(Prepayment)) "Repayment Account" where(Blocked = CONST(" "), Status = CONST(Active));
        }

        field(50011; "EFT Reference"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'EFT Reference';
        }
        field(50012; "Employee Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Code';
        }
        field(50013; "Period Reference"; Date)
        {
            DataClassification = CustomerContent;
            TableRelation = "Accounting Period"."Starting Date";
            Caption = 'Period Reference';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50014; "Apportioned"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Apportioned';
        }
        field(50015; "Emp Payroll Period"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Emp Payroll Period';
        }
        field(50016; "Emp Payroll Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Emp Payroll Code';
        }

        field(50017; "Payroll Loan No."; Code[50])
        {
            Caption = 'Payroll Loan No';
            DataClassification = CustomerContent;
        }

        field(50009; "No. Of Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Of Units';
        
            trigger OnValidate()
            begin

            end;
        }

        field(50010; "Nominal Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Nominal Value';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50018; "Balancing Entry"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Balancing Entry';
        }
        field(50019; "Transaction Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
        }
        field(50020; "Loan No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Loans."No." where("Loan Account" = field("Account No."));
            Caption = 'Loan No.';
        }
        field(50021; "Account Category"; Enum "ProductAccountCategory")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Category';
        }
        field(50022; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
    }
    procedure CopyFromLoanChargesHeader(LoanApplicationCharges: Record "Loan Application Charge")
    begin
        "Bal. Account Type" := LoanApplicationCharges."Account Type";
        "Bal. Account No." := LoanApplicationCharges."Account No.";
        Description := LoanApplicationCharges."Charge Description";
        OnAfterCopyGenJnlLineFromLoanChargeHeader(LoanApplicationCharges, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromLoanChargeHeader(ApplicationCharges: Record "Loan Application Charge"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure GetSavingsAccount()
    var
        SavAcc: Record "Account Banking";
    begin
        SavAcc.Get("Account No.");
        SavAcc.TestField("Customer Posting Group");
        SavAcc.CheckBlockedCustOnJnls(SavAcc, "Document Type", false);
        UpdateDescription(SavAcc.Name);
        "Posting Group" := SavAcc."Customer Posting Group";
        "Account Category" := SavAcc."Account Category";
        "Account Dimension" := SavAcc."Account Dimension";
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := SavAcc."Currency Code";
        ClearPostingGroups;
        OnAfterAccountNoOnValidateGetSavingsAccount(Rec, SavAcc, CurrFieldNo);
    end;

    procedure GetCustMemberSavingsAccount()
    var
        SavAcc: Record Customer;
        CredAc: Record "Account Credit";
    begin
        if SavAcc.Get("Account No.") then begin
            "Account Dimension" := SavAcc."Account Dimension";
            "Account Category" := SavAcc."Account Category";
        end;
    end;

    procedure GetSavingsBalAccount()
    var
        SavAcc: Record "Account Banking";
    begin
        SavAcc.Get("Bal. Account No.");
        SavAcc.CheckBlockedCustOnJnls(SavAcc, "Document Type", false);
        if "Account No." = '' then
            Description := SavAcc.Name;
        "Posting Group" := SavAcc."Customer Posting Group";
        "Account Dimension" := SavAcc."Account Dimension";
        if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := SavAcc."Currency Code";
        if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := SavAcc."Currency Code";
        ClearBalancePostingGroups;
        OnAfterAccountNoOnValidateGetSavingsBalAccount(Rec, SavAcc, CurrFieldNo);
    end;

    procedure GetCreditAccount()
    var
        CreditAcc: Record "Account Credit";
    begin
        CreditAcc.Get("Account No.");
        CreditAcc.TestField("Customer Posting Group");
        CreditAcc.CheckBlockedCustOnJnls(CreditAcc, "Document Type", false);
        UpdateDescription(CreditAcc.Name);
        "Posting Group" := CreditAcc."Customer Posting Group";
        "Account Category" := CreditAcc."Account Category";
        "Account Dimension" := CreditAcc."Account Dimension";
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := CreditAcc."Currency Code";
        ClearPostingGroups;
        OnAfterAccountNoOnValidateGetCreditAccount(Rec, CreditAcc, CurrFieldNo);
    end;

    procedure GetCreditBalAccount()
    var
        CreditAcc: Record "Account Credit";
    begin
        CreditAcc.Get("Bal. Account No.");
        CreditAcc.CheckBlockedCustOnJnls(CreditAcc, "Document Type", false);
        if "Account No." = '' then
            Description := CreditAcc.Name;
        "Posting Group" := CreditAcc."Customer Posting Group";
        if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := CreditAcc."Currency Code";
        if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := CreditAcc."Currency Code";
        ClearBalancePostingGroups;
        OnAfterAccountNoOnValidateGetCreditBalAccount(Rec, CreditAcc, CurrFieldNo);
    end;

    procedure GetLoanAccount()
    var
        CreditAcc: Record "Credit Account";
    begin
        CreditAcc.Get("Account No.");
        CreditAcc.TestField("Customer Posting Group");
        CreditAcc.CheckBlockedCustOnJnls(CreditAcc, "Document Type", false);
        UpdateDescription(CreditAcc.Name);
        "Posting Group" := CreditAcc."Customer Posting Group";
        "Account Category" := "Account Category"::Loan;
        "Account Dimension" := "Account Dimension"::Loan;
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := CreditAcc."Currency Code";
        ClearPostingGroups;
        OnAfterAccountNoOnValidateGetLoanAccount(Rec, CreditAcc, CurrFieldNo);
    end;

    procedure GetLoanBalAccount()
    var
        CreditAcc: Record "Credit Account";
    begin
        CreditAcc.Get("Bal. Account No.");
        CreditAcc.CheckBlockedCustOnJnls(CreditAcc, "Document Type", false);
        if "Account No." = '' then
            Description := CreditAcc.Name;
        "Posting Group" := CreditAcc."Customer Posting Group";
        "Account Dimension" := "Account Dimension"::Loan;
        if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := CreditAcc."Currency Code";
        if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := CreditAcc."Currency Code";
        ClearBalancePostingGroups;
        OnAfterAccountNoOnValidateGetLoanBalAccount(Rec, CreditAcc, CurrFieldNo);
    end;

    procedure GetRepaymentAccount()
    var
        CreditAcc: Record "Repayment Account";
    begin

        CreditAcc.Get("Account No.");
        CreditAcc.TestField("Customer Posting Group");
        CreditAcc.CheckBlockedCustOnJnls(CreditAcc, "Document Type", false);
        UpdateDescription(CreditAcc.Name);
        "Account Category" := CreditAcc."Account Category";
        "Account Dimension" := "Account Dimension"::Repayment;
        "Posting Group" := CreditAcc."Customer Posting Group";
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := CreditAcc."Currency Code";
        ClearPostingGroups;
        OnAfterAccountNoOnValidateGetRepaymentAccount(Rec, CreditAcc, CurrFieldNo);

    end;

    procedure GetRepaymentBalAccount()
    var
        CreditAcc: Record "Repayment Account";
    begin
        CreditAcc.Get("Bal. Account No.");
        CreditAcc.CheckBlockedCustOnJnls(CreditAcc, "Document Type", false);
        if "Account No." = '' then
            Description := CreditAcc.Name;
        "Posting Group" := CreditAcc."Customer Posting Group";
        if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := CreditAcc."Currency Code";
        if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := CreditAcc."Currency Code";
        ClearBalancePostingGroups;
        OnAfterAccountNoOnValidateGetRepaymentBalAccount(Rec, CreditAcc, CurrFieldNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetSavingsAccount(var GenJournalLine: Record "Gen. Journal Line"; var Savings: Record "Account Banking"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetSavingsBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Savings: Record "Account Banking"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetCreditAccount(var GenJournalLine: Record "Gen. Journal Line"; var Credits: Record "Account Credit"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetCreditBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Credits: Record "Account Credit"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetLoanAccount(var GenJournalLine: Record "Gen. Journal Line"; var Credits: Record "Credit Account"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetLoanBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Credits: Record "Credit Account"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetRepaymentAccount(var GenJournalLine: Record "Gen. Journal Line"; var Credits: Record "Repayment Account"; FieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAccountNoOnValidateGetRepaymentBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Credits: Record "Repayment Account"; FieldNo: Integer)
    begin
    end;

    procedure CopyFromLoansHeader(Loans: Record Loans)
    begin
        "Document No." := Loans."No.";
        "Account Type" := "Account Type"::Customer;
        "External Document No." := Loans."Account No.";
        Validate("Account No.", Loans."Loan Account");
        "Transaction Type" := "Transaction Type"::Loan;
        Validate("Loan No.", Loans."No.");
        Validate("Currency Code", Loans."Currency Code");
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        Validate("Bal. Account No.", '');
        OnAfterCopyGenJnlLineFromLoansHeader(Loans, Rec);
    end;

    procedure CopyFromLoansHeaderInt(Loans: Record Loans)
    begin
        "Document No." := Loans."No.";
        "Account Type" := "Account Type"::Customer;
        "External Document No." := Loans."Account No.";
        Validate("Account No.", Loans."Loan Account");
        "Transaction Type" := "Transaction Type"::"Interest Paid";
        Validate("Loan No.", Loans."No.");
        Validate("Currency Code", Loans."Currency Code");
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        Validate("Bal. Account No.", '');
        OnAfterCopyGenJnlLineFromLoansHeader(Loans, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromLoansHeader(Loans: Record Loans; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure CopyFromBankingHeader(AccountBanking: Record "Account Banking")
    begin
        "Account Type" := "Account Type"::Vendor;
        "External Document No." := AccountBanking."Member No.";
        Validate("Account No.", AccountBanking."No.");
        Validate("Currency Code", AccountBanking."Currency Code");
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        Validate("Bal. Account No.", '');
        OnAfterCopyGenJnlLineFromBankingHeader(AccountBanking, Rec);
    end;

    procedure CopyFromPrepaymentHeader(RepaymentAcc: Record "Repayment Account")
    begin
        "Account Type" := "Account Type"::Vendor;
        "External Document No." := RepaymentAcc."Member No.";
        Validate("Account No.", RepaymentAcc."No.");
        Validate("Currency Code", RepaymentAcc."Currency Code");
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        Validate("Bal. Account No.", '');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromBankingHeader(AccountBanking: Record "Account Banking"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure CopyFromCredAccHeader(AccountBanking: Record "Account Credit")
    begin
        "Account Type" := "Account Type"::Customer;
        "External Document No." := AccountBanking."Member No.";
        Validate("Account No.", AccountBanking."No.");
        Validate("Currency Code", AccountBanking."Currency Code");
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        Validate("Bal. Account No.", '');
        OnAfterCopyGenJnlLineFromCredAccHeader(AccountBanking, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromCredAccHeader(AccountBanking: Record "Account Credit"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure CopyFromLoanCharges(LoanCharge: Record "Loan Charge Posted")
    begin
        "Account Type" := "Account Type"::Vendor;
        Validate("Document No.", LoanCharge."Loan No.");
        Validate("Currency Code", '');
        "Bal. Account Type" := LoanCharge."Account Type";
        Validate("Bal. Account No.", LoanCharge."Account No.");
        OnAfterCopyGenJnlLineFromLoanCharges(LoanCharge, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromLoanCharges(LoanCharge: Record "Loan Charge Posted"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure CopyFromGeneralsetup(GeneralSetUp: Record "General Set-Up")
    begin
        GeneralSetUp.TestField("Excise Duty (%)");
        GeneralSetUp.TestField("Excise Duty G/L");
        "Account Type" := "Account Type"::Vendor;
        Validate("Currency Code", '');
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
        OnAfterCopyGenJnlLineFromGensetup(GeneralSetUp, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromGensetup(GeneralSetUp: Record "General Set-Up"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure CopyFromLoan(Loan: Record Loans)
    begin
        "Account Type" := "Account Type"::Customer;
        "External Document No." := Loan."Account No.";
        Validate("Account No.", Loan."Loan Account");
        Validate("Loan No.", Loan."No.");
        Validate("Currency Code", Loan."Currency Code");
        OnAfterCopyGenJnlLineFromLoan(Loan, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGenJnlLineFromLoan(Loans: Record Loans; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    local procedure UpdateDescription(Name: Text[100])
    begin
        if not IsAdHocDescription then
            Description := Name;
    end;

    local procedure IsAdHocDescription(): Boolean
    var
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        Employee: Record Employee;
        Savings: Record "Account Banking";
        Credits: Record "Account Credit";
        LoanAc: Record "Credit Account";
        RepaymentAccount: Record "Repayment Account";
    begin
        if Description = '' then
            exit(false);
        if xRec."Account No." = '' then
            exit(true);

        case xRec."Account Type" of
            xRec."Account Type"::"G/L Account":
                exit(GLAccount.Get(xRec."Account No.") and (GLAccount.Name <> Description));
            xRec."Account Type"::Customer:
                exit(Customer.Get(xRec."Account No.") and (Customer.Name <> Description));
            xRec."Account Type"::Vendor:
                exit(Vendor.Get(xRec."Account No.") and (Vendor.Name <> Description));
            xRec."Account Type"::"Bank Account":
                exit(BankAccount.Get(xRec."Account No.") and (BankAccount.Name <> Description));
            xRec."Account Type"::"Fixed Asset":
                exit(FixedAsset.Get(xRec."Account No.") and (FixedAsset.Description <> Description));
            xRec."Account Type"::"IC Partner":
                exit(ICPartner.Get(xRec."Account No.") and (ICPartner.Name <> Description));
            xRec."Account Type"::Employee:
                exit(Employee.Get(xRec."Account No.") and (Employee.FullName <> Description));
            xRec."Account Type"::Saving:
                exit(Savings.Get(xRec."Account No.") and (Savings.Name <> Description));
            xRec."Account Type"::Credit:
                exit(Credits.Get(xRec."Account No.") and (Credits.Name <> Description));
            xRec."Account Type"::Loan:
                exit(LoanAc.Get(xRec."Account No.") and (LoanAc.Name <> Description));
            xRec."Account Type"::Prepayment:
                exit(RepaymentAccount.Get(xRec."Account No.") and (RepaymentAccount.Name <> Description));
        end;
        exit(false);
    end;

    local procedure SetCurrencyCode(AccType2: Enum "Gen. Journal Account Type"; AccNo2: Code[20]): Boolean
    var
        BankAcc: Record "Bank Account";
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
            if AccType2 = AccType2::"Bank Account" then
                if BankAcc.Get(AccNo2) then
                    "Currency Code" := BankAcc."Currency Code";
        exit("Currency Code" <> '');
    end;

    local procedure ClearPostingGroups()
    begin
        "Gen. Posting Type" := "Gen. Posting Type"::" ";
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
    end;

    local procedure ClearBalancePostingGroups()
    begin
        "Bal. Gen. Posting Type" := "Bal. Gen. Posting Type"::" ";
        "Bal. Gen. Bus. Posting Group" := '';
        "Bal. Gen. Prod. Posting Group" := '';
        "Bal. VAT Bus. Posting Group" := '';
        "Bal. VAT Prod. Posting Group" := '';
    end;
}


