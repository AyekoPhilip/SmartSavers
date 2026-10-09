report 50183 "Mod. Mgt Validation"
{
    ApplicationArea = All;
    Caption = 'Mod.Mgt Validation';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    Permissions = TableData "Cust. Ledger Entry" = rimd, TableData "Detailed Cust. Ledg. Entry" = rimd, tabledata "Access Control" = rimd, tabledata Member = rimd, tabledata "Account Banking" = rimd, tabledata "Account Credit" = rimd, tabledata Loans = rimd, tabledata "Gen. Journal Line" = rimd, tabledata "Guarantor & Security Posted" = rimd;
    dataset
    {
        dataitem(TempRec; "Temp Data")
        {
            trigger OnPreDataItem()
            var
            begin

                DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
                if not DoctMngt.RecordRestrictMngt(UserId, Database::"Temp Data", FunctionStrng::Administrator) then
                    Error(MsgOnPermissionTxt);

                if ClearData then begin
                   Loan.Reset();
                   Loan.SetFilter("Outstanding Balance", '<>0');
                   Loan.SetRange("Product Type", 'UB/L/111');
                   if Loan.FindSet() then begin
                      repeat
                      ProdFact.Get(Loan."Product Type");
                            Loan."Interest Calculation Method" := ProdFact."Interest Calculation Method";
                            Loan.Modify(true);
                        until Loan.Next() = 0;
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin

                case ValidationType of

                    ValidationType::"Update A/c No.":
                        begin
                            case AccDimension of
                                AccDimension::Banking:
                                    begin

                                        if AccBanking.Get("No.") then begin
                                            ProdFact.Get(AccBanking."Product Type");
                                            AccBanking."Old Account No." := ProdFact."Account No. Prefix" + DelChr(AccBanking."Member No.", '=', 'U') + ProdFact."Account No. Suffix";
                                            AccBanking.Modify(true)
                                        end;
                                    end;
                                AccDimension::Credit,
                                AccDimension::"Micro Credit":
                                    begin
                                        if CredAc.Get("No.") then begin
                                            ProdFact.Get(CredAc."Product Type");
                                            CredAc."Old Member No." := ProdFact."Account No. Prefix" + DelChr(CredAc."Member No.", '=', 'U') + ProdFact."Account No. Suffix";
                                            CredAc.Modify(true)
                                        end;
                                    end;
                            end;

                        end;

                    ValidationType::"Check Email":
                        begin
                            if CustApplication.Get("No.") then begin
                                VarVariant := CustApplication;
                                SmsNotification.SendEmailNotification(VarVariant, 0, 'UBf98575');
                            end;
                        end;
                    ValidationType::"Update Banking":
                        begin
                            case AccDimension of
                                AccDimension::Loan:
                                    begin
                                        Loan.Reset();
                                        Loan.SetRange("Account No.", "No.");
                                        if Loan.FindFirst() then begin
                                            Loan.ModifyAll("Old Account No.", Loan."Account No.");
                                            Loan.ModifyAll("Account No.", "Application No.");
                                        end;
                                    end;
                                AccDimension::"Micro Credit":
                                    begin

                                        LoanAcc.Reset();
                                        LoanAcc.SetRange("No.", "Application No.");
                                        if LoanAcc.Find('-') then begin
                                            if Loan.Get("No.") then begin
                                                LoanAcc."Member No." := Loan."Account No.";
                                                LoanAcc.Modify(true);

                                                if CustM.Get(LoanAcc."No.") then begin
                                                    CustM."Member No." := LoanAcc."Member No.";
                                                    CustM.Modify(true)
                                                end;
                                            end;
                                        end;
                                    end;
                                AccDimension::Repayment:
                                    begin
                                        if Loan.Get("No.") then begin
                                            Loan.Repayment := Amount;
                                            Loan.Modify(true);
                                        end;
                                    end;
                                AccDimension::Banking:
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", "No.");
                                        AccBanking.SetRange("Product Type", 'IE-00109');
                                        if AccBanking.Find('-') then begin
                                            AccBanking."Member No." := "Application No.";
                                            AccBanking."Staff/Payroll No." := "Client Code";
                                            AccBanking.Status := Status;
                                            AccBanking.Modify(true);

                                            Vend.Reset();
                                            Vend.SetRange("No.", AccBanking."No.");
                                            Vend.SetRange("Product Type", 'IE-00109');
                                            if Vend.FindFirst() then begin
                                                Vend."Member No." := AccBanking."Member No.";
                                                Vend.Status := AccBanking.Status;
                                                Vend."Staff No." := AccBanking."Staff/Payroll No.";
                                                Vend.Modify(true)
                                            end;
                                        end
                                    end;
                            end;
                        end;

                    ValidationType::"Update Status":
                        begin
                            if CustRec.Get("No.") then begin
                                case AccDimension of
                                    AccDimension::Banking:
                                        begin
                                            AccBanking.SetRange("Member No.", CustRec."No.");
                                            if AccBanking.FindSet() then
                                                AccBanking.ModifyAll(Status, CustRec.Status);
                                        end;
                                    AccDimension::Credit,
                                    AccDimension::"Micro Credit":
                                        begin
                                            CredAc.SetRange("Member No.", CustRec."No.");
                                            if CredAc.FindSet() then
                                                CredAc.ModifyAll(Status, CustRec.Status);
                                        end;
                                    AccDimension::Repayment:
                                        begin
                                            RepayAcc.SetRange("Member No.", CustRec."No.");
                                            if RepayAcc.FindSet() then
                                                RepayAcc.ModifyAll(Status, CustRec.Status);
                                        end;
                                    AccDimension::Loan:
                                        begin
                                            LAccount.SetRange("Member No.", CustRec."No.");
                                            if LAccount.FindSet() then
                                                LAccount.ModifyAll(Status, CustRec.Status);
                                        end;
                                end;
                            end;
                        end;
                    ValidationType::Account:
                        begin
                            if Loan.Get("No.") then begin
                                Loan.Validate("Account No.");
                                Loan.Modify(true);
                            end;
                        end;
                    ValidationType::"Field Type":
                        begin
                            if Loan.Get("No.") then begin
                                ProdFact.Reset();
                                if ProdFact.Get(Loan."Product Type") then
                                    Loan."Product Dimension" := ProdFact."Product Dimension";
                                Loan.Modify(true);
                            end;
                        end;
                    ValidationType::ProductType:
                        begin
                            if Loan.Get("No.") then begin
                                Loan.Validate("Product Type");
                                Loan.Modify(true);
                            end;
                        end;
                    ValidationType::ReqAmount:
                        begin
                            if Loan.Get("No.") then begin
                                Loan.Validate("Requested Amount", "Requested Amount");
                                Loan.Modify(true);
                            end;
                        end;
                    ValidationType::DisDate:
                        begin
                            if Loan.Get("No.") then begin
                                if loan."Disbursement Date" <> 0D THEN begin
                                    Loan.Validate("Disbursement Date");
                                    Loan.Modify(true);
                                end;

                            end;

                        end;
                    ValidationType::Installment:
                        begin
                            if Loan.Get("No.") then begin
                                Loan.Validate(Installments, Installment);
                                Loan.Modify(true);
                            end;
                        end;
                    ValidationType::"Gen. Repayment Schedule":
                        begin
                            if Loan.Get("No.") then begin
                                Loan.CalcFields("Outstanding Balance");
                                if Loan."Outstanding Balance" > 0 then
                                    CredMgt.fncreateRepayschedule(false, Loan."No.", 0);
                            end;
                        end;
                    ValidationType::"Loan Account":
                        begin
                            Custrecord.Reset();
                            Custrecord.SetRange("No.", "Client Code");
                            if Custrecord.FindFirst() then begin
                                "Account No." := "No.";
                                "Account Found" := true;
                                Modify(true)
                            end else begin
                                CustRec.Reset();
                                CustRec.SetRange("Union Member No.", "Client Code");
                                if CustRec.FindFirst() then begin
                                    "Account No." := CustRec."No.";
                                    "Account Found" := true;
                                    Modify(true)
                                end;
                            end;
                        end;
                    ValidationType::"Generate Batch":
                        begin
                            if AccountType = '' then begin
                                if Loan.Get("No.") then begin
                                    CreateLoanJournBatch("No.");

                                end;
                            end else begin
                                if CustRec.Get("No.") then begin
                                    CreateJournBatch(AccountType, CustRec."No.");
                                end else begin
                                end;
                            end;
                        end;
                    ValidationType::"Update Loan Details":
                        begin

                            Loan.Init();
                            Loan."No." := "No.";
                            Loan."Application Date" := "Application Date";
                            Loan."Account No." := "Account No.";
                            Loan."Product Type" := "Product Type";
                            Loan."Requested Amount" := "Requested Amount";
                            Loan."Approved Amount" := Amount;
                            Loan."Interest Rate" := Interest;
                            Loan.Installments := Installment;
                            Loan."Disbursement Date" := "Issued Date";
                            Loan."Repayment Start Date" := "Repayement Start Date";
                            Loan.Repayment := Repayment;
                            Loan."Interest Calculation Method" := "Interest Method";
                            Loan."Old Account No." := "Old Account No.";
                            Loan."Expected Date of Completion" := "Expected end Date";
                            Loan."Self Guarantee" := Selfguarant;
                            Loan."Interest Repayment" := "Interest Amount";
                            Loan."Principle Repayment" := "Principal Amount";
                            Loan."Approval Status" := Loan."Approval Status"::Posted;
                            Loan."Loan Status" := Loan."Loan Status"::Issued;
                            Loan.Insert(true)

                        end;
                    ValidationType::"Create Loan Category":
                        begin

                            if Loan.Get("No.") then begin
                                Loan.CalcFields("Outstanding Balance");
                                LoanCat.Reset();
                                LoanCat.SetRange("No.", "No.");
                                if not LoanCat.FindFirst() then begin
                                    CredMngt.CreateLoancategory(Loan);
                                end;
                            end;
                        end;
                    ValidationType::"Gen Closed Account":
                        begin
                            Loan.Reset();
                            Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
                            if Loan.FindSet() then begin
                                repeat
                                    if not LoancloasedAcc1.Get(Loan."No.") then begin
                                        Loan.CalcFields("Outstanding Balance");
                                        if Loan."Outstanding Balance" = 0 then begin
                                            LoancloasedAcc.Init();
                                            LoancloasedAcc.TransferFields(Loan);
                                            LoancloasedAcc.Insert(true)
                                        end;
                                    end
                                until Loan.Next() = 0;
                            end;
                        end;
                    ValidationType::"Clear Closed Account":
                        begin

                            Loan.Reset();
                            Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
                            if Loan.Find('-') then begin
                                repeat
                                    Loan.CalcFields("Outstanding Balance");
                                    if Loan."Outstanding Balance" = 0 then begin
                                        Loan.Delete()
                                    end;
                                until Loan.Next() = 0;
                            end;

                            Loancategory.Reset();
                            Loancategory.SetRange("Approval Status", Loancategory."Approval Status"::Posted);
                            if Loancategory.Find('-') then begin
                                repeat
                                    Loancategory.CalcFields("Outstanding Balance");
                                    if Loancategory."Outstanding Balance" = 0 then begin
                                        Loancategory.Delete()
                                    end;
                                until Loancategory.Next() = 0;
                            end;
                        end;
                    ValidationType::"Check Entry":
                        begin

                            CustLedger.Reset();
                            CustLedger.SetRange("Loan No.", "No.");
                            if CustLedger.FindSet() then begin
                                CustLedger.ModifyAll("Customer No.", "Client Code");
                            end;
                            CredLeger.Reset();
                            CredLeger.SetRange("Loan No.", "No.");
                            if CredLeger.FindSet() then begin
                                CredLeger.ModifyAll("Customer No.", "Client Code");
                            end;
                        end;
                end;
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(PostDate; PostDate)

                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }

                    field(ClearData; ClearData)

                    {
                        Caption = 'Clear Data';
                        ApplicationArea = All;
                    }
                    field(ValidationType; ValidationType)
                    {
                        Caption = 'Validation Type';
                        ApplicationArea = All;
                    }
                    field(AccountType; AccountType)
                    {
                        Caption = 'Account Type';
                        ApplicationArea = All;
                        TableRelation = "Product Factory";
                    }
                    field(AccDimension; AccDimension)
                    {
                        Caption = 'Account Dimension';
                        ApplicationArea = All;

                    }
                    field(TransTypeType; TransType)
                    {
                        Caption = 'Transaction Type';
                        ApplicationArea = All;
                    }

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    local procedure CreateLoanJournBatch(AcNo: Code[100])
    begin
        if Loan.Get(AcNo) then begin

            GenJournal.LockTable;
            Linenum := Linenum + 1000;
            PostPeriodic.InitializeDebitEntry(Loan, GenJournal, 0,
            Enum::"Gen. Journal Account Type"::"G/L Account",
            '', TransType);
            GenJournal."Line No." := Linenum;
            GenJournal."Journal Template Name" := 'GENERAL';
            GenJournal."Journal Batch Name" := 'OPENBAL';
            GenJournal."Posting Date" := PostDate;
            GenJournal."Document No." := 'OPENBAL' + Loan."No.";
            case TransType of
                TransType::Loan:
                    GenJournal.Validate(Amount, TempRec."Outstanding Bal");
                TransType::"Interest Due":
                    GenJournal.Validate(Amount, TempRec."Outstanding Interest");
                TransType::"Ledger Fee Due":
                    GenJournal.Validate(Amount, TempRec.Fee);
            end;
            GenJournal."Loan No." := Loan."No.";
            GenJournal.Description := CopyStr('Openning Balance -' + Format(TransType), 1, 100);
            GenJournal.Validate("Bal. Account No.", '200-150-018');
            GenJournal.Validate("Shortcut Dimension 1 Code", Loan."Global Dimension 1 Code");
            GenJournal.Validate("Shortcut Dimension 2 Code", Loan."Global Dimension 2 Code");
            GenJournal.Validate("Loan No.", Loan."No.");
            if GenJournal.Amount <> 0 then
                GenJournal.Insert(true);
        end;
    end;

    local procedure CreateJournBatch(ProdType: Code[10]; AcNo: Code[100])
    begin
        if ProdFact.Get(ProdType) then begin

            case ProdFact."Account Dimension" of
                ProdFact."Account Dimension"::Banking:
                    begin
                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", AcNo);
                        AccBanking.SetRange("Product Type", ProdFact."Product ID");
                        if AccBanking.FindFirst() then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := 'GENERAL';
                            GenJournal."Journal Batch Name" := 'OPENBAL';
                            GenJournal."Posting Date" := PostDate;
                            GenJournal."Document No." := 'OPENBAL' + AccBanking."Product Type";
                            GenJournal."External Document No." := AccBanking."Member No.";
                            GenJournal.Validate(Amount, TempRec.Amount * -1);
                            GenJournal.Description := CopyStr('Opening Balance-' + Format(AccBanking."Account Category"), 1, 100);
                            GenJournal.Validate("Bal. Account No.", '200-150-018');
                            GenJournal.Validate("Shortcut Dimension 1 Code", AccBanking."Global Dimension 1 Code");
                            GenJournal.Validate("Shortcut Dimension 2 Code", AccBanking."Global Dimension 2 Code");
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                        end;
                    end;
                ProdFact."Account Dimension"::Credit:
                    begin
                        CredAc.Reset();
                        CredAc.SetRange("Member No.", AcNo);
                        CredAc.SetRange("Product Type", ProdFact."Product ID");
                        if CredAc.FindFirst() then begin

                            GenJournal.LockTable;
                            Linenum := Linenum + 1000;
                            InitPost.InitCreditEntry(CredAc, GenJournal, 0);
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := 'GENERAL';
                            GenJournal."Journal Batch Name" := 'OPENBAL';
                            GenJournal."Posting Date" := PostDate;
                            GenJournal."Document No." := 'OPENBAL' + CredAc."Product Type";
                            GenJournal.Validate("Account No.", CredAc."No.");
                            GenJournal.Validate(Amount, TempRec.Amount * -1);
                            GenJournal.Description := CopyStr('Opening Balance-' + Format(CredAc."Account Category"), 1, 100);
                            GenJournal.Validate("Bal. Account No.", '200-150-018');
                            GenJournal.Validate("Shortcut Dimension 1 Code", CredAc."Global Dimension 1 Code");
                            GenJournal.Validate("Shortcut Dimension 2 Code", CredAc."Global Dimension 2 Code");
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);
                        end;
                    end;
            end;

        end;

    end;

    var
        ClearData: Boolean;
        RepayAcc: Record "Repayment Account";
        CredLeger: Record "Detailed Cust. Ledg. Entry";
        register: Record "G/L Register";
        CustLedger: Record "Cust. Ledger Entry";
        VENDLEDGER: Record "Vendor Ledger Entry";
        DVENDLEDGER: Record "Detailed Vendor Ledg. Entry";
        LoanCat: Record "Loans Categorization";
        Credit: Record "Credit Account";
        GS: Record "Guarantor & Security Posted";
        Member: Record Member;
        CustM: Record Customer;
        LoancloasedAcc: Record "Loans-Closed Account";
        LoancloasedAcc1: Record "Loans-Closed Account";
        Loancategory: Record "Loans Categorization";
        IsISESA: Boolean;
        BankAcc: Page "Bank Account Card";
        CredMngt: Codeunit "Credit Mgmt.";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TempCredAcc: Record "Account (Member)";
        CustAccType: Enum CustAccountType;
        CredMgt: Codeunit "Credit Mgmt.";
        Banking: Record "Account Banking";
        IsIESA: Boolean;
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        ProdCode: Code[20];
        Mycard: page "User Card";
        usercard: Record User;
        userlist: Page Users;
        Accesscontrol: Record "Access Control";
        TempBanking: Record "Account (Procedure)";
        RegistryMngt: Codeunit "Registry Mngt.";
        AccBanking: Record "Account Banking";
        TempData: Record Member;
        CredAc: Record "Account Credit";
        SmsNotification: Codeunit "SMS Notification";
        TempCred: Record "Account (Member)";
        TempsData: Record "Temp Data";
        ValuePost: Integer;
        BanlLedgerEntry: Record "Banking A/c Ledger Entry";
        bank: Record "Bank Account Ledger Entry";
        fal: Record "FA Ledger Entry";
        glentry: Record "G/L Entry";
        CUSTLEDGE: Record "Cust. Ledger Entry";
        DETACUSTLEDGE: Record "Detailed Cust. Ledg. Entry";
        LoanEntry: Record "Loans Categorization";
        MembCategory: Record "Member Category";
        LoanApp: Record "Loan Application";
        Directions: Option " ",Member,Loans,"Create Loan","Post Application","Modify Entry on Loan","Reverse Entry","Post Savings";
        Loan: Record Loans;
        Vend: Record Vendor;
        Guarantposted: Record "Guarantor & Security Posted";
        CustApplication: Record "Member Application";
        Debtor: Record Customer;
        LAccount: Record "Credit Account";
        Custrecord: Record Member;
        PostDate: Date;
        LoanAcc: Record "Credit Account";
        DocumentNo: Code[100];
        Contributions: Record "Member Monthly Contribution";
        AmtPost: Decimal;
        UseIDNo: Boolean;
        CustRec: Record Member;
        TransType: Enum "LoanTransactionType";
        RegtMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        ProdCategory: Enum ProductAccountCategory;
        AccDimension: Enum AccountDimension;
        CredtMngt: Codeunit "Credit Mgmt.";
        IntPeriod: Record "Loan Interest Periods";
        ProdFact: Record "Product Factory";
        GenJournal: Record "Gen. Journal Line";
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        Linenum: Integer;
        VarVariant: Variant;
        InitPost: Codeunit "Initialize Gen. Jnl.-Post";
        PostPeriodic: Codeunit "Gen.Jnl.-Post Periodic";
        AccountType: Code[10];
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        ValidationType: Enum ModFValidations;
        Page39: Page "General Journal";
        gentemp: Record "Gen. Journal Template";
        bankRec: page "Bank Acc. Reconciliation List";
        vendLedger2: Record "Vendor Ledger Entry";

        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

}



