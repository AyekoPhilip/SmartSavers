codeunit 50072 "Loan Post Mngt. (Yes/No)"
{
    TableNo = Loans;

    trigger OnRun()
    begin
        CreateJournalTemplate();
        InitPost(Rec, Jtemplate, JBatch, Dim1, Dim2, Rec."Check Line");
    end;

    var
        GeneralSetUp: Record "General Set-Up";
        LoanLiquidMgt: Record "Loans Liquidation";
        PostedLoan: Record Loans;
        InterestEntry: Record "Interest Line";
        PostPeriodic: Codeunit "Gen.Jnl.-Post Periodic";
        ApplicLoan: Record "Loan Application";
        CrmApplic: Record "CRM Application";
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        AccBanking: Record "Account Banking";
        ActionItem: Enum PageActionItem;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        AcctType: Enum "Gen. Journal Account Type";
        TransacType: Enum "LoanTransactionType";
        CredMgt: Codeunit "Credit Mgmt.";
        SmsNotification: Codeunit "SMS Notification";
        BankMngt: Codeunit "Banking Procedure Mngt.";
        AdviceType: Enum AdviseType;
        NotifSource: Enum NotifSourceType;
        VarVariant: Variant;
        DocType: Enum "Gen. Journal Document Type";
        AccCredit: Record "Account Credit";
        Prodfact: Record "Product Factory";
        variantRecRef: Variant;
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        InterestProgEntry: Record "Loan Progression Lines";
        Temp: Record "Banking User Template";
        Jtemplate: Code[10];
        JnPost: Codeunit "Journal Post Mngt.";
        GenLedgerSetup: Record "General Ledger Setup";
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        OtherCommit: Record "Other Commitements Clearance";
        AccruedInt: Decimal;
        Linenum: Integer;
        GenJournal: Record "Gen. Journal Line";
        RegMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        DocPostMngt: Codeunit "Doc-PostMgt";
        ExtDocNo: Code[50];
        DocsMngt: Codeunit "Doc. Mngt";
        AmountToDisburse: Decimal;
        PostChargeMngt: Codeunit "Post Transac. Charge Mngt.";
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        Text00002: Label 'Interest Charged-';
        TextDescription: Label 'Principal amount-';
        ErrorOnMissingMemberAcc: Label 'Member Corresponding Credit/ Banking Missing';
        Text016: Label 'You cannot Post %1-%2 because there is at least one posted entry related to this transaction.';

    procedure InitPost(RecRef: Record Loans; Template: Code[10]; TBatch: Code[10]; ShortDim1: Code[10]; ShortDim2: Code[10]; ValuePost: Boolean)
    begin

        RecRef.TestField("Disbursement Date");
        case RecRef."Mode of Disbursement" of
            RecRef."Mode of Disbursement"::"Full Disbursement":
                begin
                    if RecRef."Application Type" = RecRef."Application Type"::Normal then begin
                        CodePost(RecRef, ValuePost, RecRef."Disbursement Date", RecRef."No.", Template, TBatch, Dim1, Dim2)
                    end;
                    if RecRef."Application Type" = RecRef."Application Type"::"Loan Restructure" then begin
                        InitPerformPost(RecRef, Template, TBatch, Today, Dim1, Dim2);
                    end;
                end;
            RecRef."Mode of Disbursement"::"Partial Disbursement":
                begin
                    InitPerformPost(RecRef, Template, TBatch, Today, Dim1, Dim2);
                end;
        end;
    end;

    local procedure CreateJournalTemplate()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Loans Template");
        Temp.TestField("Loans Batch");
        Jtemplate := Temp."Loans Template";
        JBatch := Temp."Loans Batch";

        JnPost.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;

    procedure InitPostPartSched(RecRef: Record "Partial Disbursement Schedule")
    begin
        CreateJournalTemplate();
        if not TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."Entry No", 0) then begin
            CodePostPartLoan(RecRef, Today, Jtemplate, JBatch, Dim1, Dim2);
        end else begin
            Error(Text016, RecRef."Entry No", RecRef."Account Name");
        end;
    end;

    procedure InitPerformPost(RecRef: Record Loans; GTemplate: Code[10]; GBatch: Code[10]; PostDate: Date; ShortDim1: Code[10]; ShortDim2: Code[10])
    begin
        RecRef.fnTestFields();
        if not TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 0) then begin
            CreateEntryOnRefLoan(RecRef, GTemplate, GBatch, PostDate, ShortDim1, ShortDim2);
            if RecRef."Check Line" then begin

                JnPost.CompletePosting(GTemplate, GBatch);
                variantRecRef := RecRef;
                OnCompletePostMgt(0, RecRef."No.");

            end else begin
                VarVariant := RecRef;
                DocsMngt.DocPrintstatement(VarVariant, 0);
            end;
        end else begin
            Error(Text016, RecRef."No.", RecRef."Account Name");
        end;
    end;

    local procedure CodePostPartLoan(PartialDisb: Record "Partial Disbursement Schedule"; PostingDate: Date; TemplateTxt: Code[10]; BatchTxt: Code[10]; DActivity: Code[10]; DBranch: Code[10])
    var
        LineNo: array[19] of Integer;
        ReferenceRec: Record Loans;

    begin

        PartialDisb.fnCheckMinRequirement(ActionItem::"Post Application");

        ReferenceRec.Reset();
        ReferenceRec.SetRange("No.", PartialDisb."Loan No.");
        ReferenceRec.SetRange("Approval Status", ReferenceRec."Approval Status"::Posted);
        if ReferenceRec.FindFirst() then begin

            CreateInitialEntry(PostingDate, PartialDisb.Amount, PartialDisb."Entry No", JTemplate,
            JBatch, DActivity, DBranch, ReferenceRec."Currency Code", ReferenceRec."No.", ReferenceRec."Disbursement Account No.",
            TextDescription, ReferenceRec."Loan Account", ReferenceRec."No.");
            VarVariant := PartialDisb;

            if PartialDisb."Preview Journal" then begin
                DocsMngt.DocPrintstatement(VarVariant, 0);
            end else begin
                JnPost.CompletePosting(JTemplate, JBatch);
                OnCompletePostMgt(1, PartialDisb."Entry No");
            end;
        end;
    end;

    procedure CodePost(ReferenceRec: Record Loans; CheckLine: Boolean; PostingDate: Date;
    DocumentNo: Code[100]; JTemplate: Code[10]; JBatch: Code[10]; DActivity: Code[10]; DBranch: Code[10])
    var
        LineNo: array[19] of Integer;
        FactP: Record "Product Factory";
    begin
        AccruedInt := 0;
        AmountToDisburse := 0;
        ExtDocNo := '';
        ReferenceRec.fnTestFields();
        if ReferenceRec."TopUp Loan" = '' then begin
            if TellMngt.TestNoEntriesExist(ReferenceRec."Account Name", ReferenceRec."No.", 0) then begin
                Error(Text016, ReferenceRec."Account Name", ReferenceRec."No.");
            end;
        end else begin

            ApplicLoan.Reset();
            ApplicLoan.SetRange("TopUp Loan", ReferenceRec."No.");
            if ApplicLoan.FindFirst() then
                if TellMngt.TestExtDocNoEntriesExist(ApplicLoan."Account Name", ApplicLoan."No.", 0) then begin
                    Error(Text016, ReferenceRec."Account Name", ApplicLoan."No.");
                end;
        end;

        ReferenceRec.CalcFields("Total TopUp");

        if not CheckIfCustAccountExists(ReferenceRec."Loan Account") then
            CreateCustAccountIfNotExits(ReferenceRec."Loan Account");

        if ReferenceRec."TopUp Loan" = '' then begin
            AmountToDisburse := ReferenceRec."Approved Amount";
            ExtDocNo := ReferenceRec."Account No.";
        end else begin
            ApplicLoan.Reset();
            ApplicLoan.SetRange("TopUp Loan", ReferenceRec."No.");
            if ApplicLoan.FindFirst() then
                AmountToDisburse := ApplicLoan."Approved Amount";
            ExtDocNo := ApplicLoan."No.";
        end;

        LineNo[1] := CreateInitialEntry(PostingDate, AmountToDisburse,
        ReferenceRec."No.", JTemplate, JBatch, DActivity, DBranch, ReferenceRec."Currency Code", ExtDocNo,
         ReferenceRec."Disbursement Account No.", TextDescription, ReferenceRec."Loan Account", ReferenceRec."No.");

        if DocPostMngt.CalculateLoanInt(ReferenceRec."No.") > 0 then begin

            case ReferenceRec."Charge Interest on Posting" of

                ReferenceRec."Charge Interest on Posting"::"Pro-rate",
                ReferenceRec."Charge Interest on Posting"::"Full Interest":
                    begin
                        LineNo[2] := PostOnUpfrontInt(ReferenceRec."No.", ReferenceRec."No.",
              PostingDate, DActivity, DBranch, JTemplate, JBatch, DocPostMngt.CalculateLoanInt(ReferenceRec."No."),
              ReferenceRec."Account No.", LineNo[1] + 100, ReferenceRec."Product Type", 0);

                    end;
                ReferenceRec."Charge Interest on Posting"::"Interest Due":
                    begin
                        LineNo[2] := PostOnInterestDue(ReferenceRec."No.", ReferenceRec."No.",
              PostingDate, DActivity, DBranch, JTemplate, JBatch, DocPostMngt.CalculateLoanInt(ReferenceRec."No."),
              ReferenceRec."Account No.", LineNo[1] + 100, ReferenceRec."Product Type", 0);
                    end;
            end;
        end else begin
            LineNo[2] := LineNo[1]
        end;

        if ReferenceRec."Interest Calculation Method" <> ReferenceRec."Interest Calculation Method"::"Zero Interest" then begin

            LineNo[3] := PostChargeMngt.fnPostLoanCharge(ReferenceRec."No.",
            AmountToDisburse, ReferenceRec."Disbursement Account No.", DActivity, DBranch,
            JTemplate, JBatch, ReferenceRec."No.", PostingDate, LineNo[2] + 100, ReferenceRec."Account No.");
            if LineNo[3] = 0 then LineNo[3] := LineNo[2];
        end;

        LineNo[4] := CreatePurchaseGenJLine(ReferenceRec, DActivity, DBranch, JTemplate, JBatch, LineNo[3] + 100, PostingDate);
        if LineNo[4] = 0 then LineNo[4] := LineNo[3];

        LineNo[5] := PostLoanLiquidation(ReferenceRec, LineNo[4] + 100, PostingDate, JTemplate, JBatch, DActivity, DBranch);
        if LineNo[5] = 0 then LineNo[5] := LineNo[4];

        CreateRevolveFundJnLine(ReferenceRec, JTemplate, JBatch, DActivity, DBranch, LineNo[5] + 100, PostingDate);

        if CheckLine then begin
            JnPost.CompletePosting(JTemplate, JBatch);
            variantRecRef := ReferenceRec;
            OnCompletePostMgt(0, ReferenceRec."No.");

        end else begin
            VarVariant := ReferenceRec;
            DocsMngt.DocPrintstatement(VarVariant, 0);
        end;

    end;

    local procedure CheckIfCustAccountExists(LoanAccount: Code[100]): Boolean
    var
        CustRecord: Record Customer;
    begin
        CustRecord.Reset();
        CustRecord.SetRange("No.", LoanAccount);
        CustRecord.SetRange("Account Dimension", CustRecord."Account Dimension"::Loan);
        if CustRecord.Find('-') then begin
            exit(true)
        end;

        exit(false)
    end;

    local procedure CreateCustAccountIfNotExits(LoanAccount: Code[100])
    CreditAccounts: Record "Credit Account";
    begin
        CreditAccounts.Reset();
        CreditAccounts.SetRange("No.", LoanAccount);
        if CreditAccounts.FindFirst() then begin

            RegMngt.fnCreateCustMemberPostAc(CreditAccounts."No.",
                CreditAccounts.Name, '',
                CreditAccounts."Global Dimension 1 Code",
                CreditAccounts."Global Dimension 2 Code",
                CreditAccounts."Customer Posting Group", '',
                CreditAccounts.Status, CreditAccounts."Product Type",
                CreditAccounts."ID No.",
                CreditAccounts."Member No.",
                CustomerAccType::"Loan Account",
                AccDimension::Loan, ProdCategory::" ");
        end;
    end;

    local procedure CreateInitialEntry(PostingDate: Date; AmountToDisburse: Decimal; DocumentNo: Code[100]; JTemplate: Code[10]; JBatch: Code[10]; DActivity: Code[10]; DBranch: Code[10]; CurrencyCode: Code[10]; ExDocIDNo: Code[50]; AccountNo: Code[100]; TextDescription: Text[100]; LoanAcc: Code[100]; LoanNo: Code[100]): Integer
    begin
        GenJournal.LockTable();

        Linenum := 1;
        GenJournal."Line No." := Linenum;
        InitializeEntry(GenJournal, Linenum, JTemplate,
        JBatch, DocumentNo, CurrencyCode, PostingDate, DActivity, DBranch);
        GenJournal."External Document No." := ExDocIDNo;
        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
        GenJournal.Validate("Account No.", AccountNo);
        GenJournal.Description := CopyStr(TextDescription + DocumentNo, 1, 100);
        GenJournal.Validate(Amount, AmountToDisburse * -1);
        GenJournal.Validate("Shortcut Dimension 1 Code", DActivity);
        GenJournal.Validate("Shortcut Dimension 2 Code", DBranch);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);

        Linenum := Linenum + 1;
        GenJournal."Line No." := Linenum;
        InitializeEntry(GenJournal, Linenum, JTemplate,
        JBatch, DocumentNo, CurrencyCode, PostingDate, DActivity, DBranch);
        GenJournal."External Document No." := ExDocIDNo;
        GenJournal."Account Type" := GenJournal."Account Type"::Customer;
        GenJournal.Validate("Account No.", LoanAcc);
        GenJournal.Description := CopyStr(TextDescription + DocumentNo, 1, 100);
        GenJournal.Validate(Amount, AmountToDisburse);
        GenJournal."Transaction Type" := GenJournal."Transaction Type"::Loan;
        GenJournal.Validate("Loan No.", LoanNo);
        GenJournal.Validate("Shortcut Dimension 1 Code", DActivity);
        GenJournal.Validate("Shortcut Dimension 2 Code", DBranch);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);
        exit(Linenum)
    end;

    procedure InitializeEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
    begin
        RecRef.Init;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := TransactionDate;
        RecRef."Document No." := DocNo;
        RecRef.Validate("Currency Code", CurrencyCode);
        RecRef."Document Date" := TransactionDate;
        RecRef.Validate("Shortcut Dimension 1 Code", Dimension1);
        RecRef.Validate("Shortcut Dimension 2 Code", Dimension2);

    end;

    procedure PostOnUpfrontInt(LoanNo: Code[100]; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]; ChargeOption: Integer): Integer
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
        LineNumber: Integer;
        AmtPost: Decimal;
    begin
        LineNumber := LineNo;
        AmtPost := 0;
        AmtPost := RunBal * -1;

        if Loans.Get(LoanNo) then begin
            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");

            LineNumber := LineNumber + 10;
            JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
            Enum::"Gen. Journal Account Type"::Customer,
            DocumentNo, Text00002 + LoanNo, RunBal, Loans."Loan Account", PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", ProductType."Interest Account (G/L)",
            Loans."Account No.", DActivity, DBranch, Enum::"LoanTransactionType"::"Interest Due",
            Loans."No.", Loans."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
            Loans."Currency Code", Enum::"Gen. Journal Document Type"::" ");

            LineNumber := LineNumber + 10;
            JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
            Enum::"Gen. Journal Account Type"::Vendor, DocumentNo, Text00002 + LoanNo, RunBal,
            Loans."Disbursement Account No.", PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", '', Loans."Account No.", DActivity,
            DBranch, Enum::"LoanTransactionType"::" ", '', Loans."Group Code", '',
            Enum::"Gen. Journal Document Type"::" ", Loans."Currency Code",
            Enum::"Gen. Journal Document Type"::" ");

            LineNumber := LineNumber + 10;
            JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber, Enum::"Gen. Journal Account Type"::Customer,
            DocumentNo, Text00002 + LoanNo, AmtPost, Loans."Loan Account", PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", '',
            Loans."Account No.", DActivity, DBranch, Enum::"LoanTransactionType"::"Interest Paid",
            Loans."No.", Loans."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
            Loans."Currency Code", Enum::"Gen. Journal Document Type"::" ");

            exit(LineNumber)
        end
    end;

    procedure PostOnInterestDue(LoanNo: Code[100]; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]; ChargeOption: Integer): Integer
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
        LineNumber: Integer;
        AmtPost: Decimal;
    begin
        LineNumber := LineNo;
        AmtPost := 0;
        AmtPost := RunBal * -1;

        if Loans.Get(LoanNo) then begin
            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");

            LineNumber := LineNumber + 10;
            JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber, Enum::"Gen. Journal Account Type"::Customer,
            DocumentNo, Text00002 + LoanNo, RunBal, Loans."Loan Account", PDate, Enum::"Gen. Journal Account Type"::"G/L Account", ProductType."Interest Account (G/L)",
            Loans."Account No.", DActivity, DBranch, Enum::"LoanTransactionType"::"Interest Due", Loans."No.", Loans."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
            Loans."Currency Code", Enum::"Gen. Journal Document Type"::" ");

            exit(LineNumber)
        end
    end;

    procedure fnInitializeDebitCreditJnline(LoanNo: Code[100]; PDate: Date; LnTransType: Enum "LoanTransactionType";
    DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20];
    RunBal: Decimal; JLineNo: Integer; AccruedAmt: Decimal; AccFacility: Code[100];
    TopUp: Boolean; AccType: Enum "Gen. Journal Account Type"; AccToCredit: Code[100];
    Restructure: Boolean) LnInteger: Integer
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
        LineNumber: Integer;
        AmtPost: Decimal;
        LoanAcc: Code[100];
        LnTopUp: Record Loans;
        LoanTransType: Enum "LoanTransactionType";
        RestructAcc: Code[100];
        Descript: Text[150];

    begin
        AmtPost := 0;
        LoanAcc := '';
        LineNumber := JLineNo;
        case LnTransType of
            LnTransType::" ":
                begin
                    AmtPost := RunBal

                end else begin
                AmtPost := RunBal * -1
            end;
        end;

        case TopUp of
            true:
                begin
                    if LnTopUp.Get(AccFacility) then
                        LoanAcc := LnTopUp."Loan Account"
                end else begin
                LoanAcc := Loans."Loan Account"
            end;
        end;

        if Loans.Get(LoanNo) then begin

            case Restructure of
                true:
                    begin
                        LoanTransType := LoanTransType::Loan;
                        RestructAcc := Loans."No.";
                        Descript := 'Principal Amount-' + Loans."No.";
                    end else begin
                    LoanTransType := LoanTransType::" ";
                    RestructAcc := '';
                    Descript := Format(LnTransType) + '-' + LnTopUp."No.";
                end;
            end;

            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");

            if AccruedAmt > 0 then begin

                LineNumber := LineNumber + 100;

                JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
                Enum::"Gen. Journal Account Type"::Customer,
                Loans."No.", Text00002 + LnTopUp."No.", RunBal, LoanAcc, PDate,
                Enum::"Gen. Journal Account Type"::"G/L Account", ProductType."Interest Account (G/L)",
                LnTopUp."Account No.", DActivity, DBranch, LnTransType,
                LnTopUp."No.", LnTopUp."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                LnTopUp."Currency Code", Enum::"Gen. Journal Document Type"::" ");

            end;

            LineNumber := LineNumber + 100;

            JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
            AccType, Loans."No.", Descript, RunBal, AccToCredit, PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", '', LnTopUp."Account No.", DActivity,
            DBranch, LoanTransType, RestructAcc, LnTopUp."Group Code", '',
            Enum::"Gen. Journal Document Type"::" ", LnTopUp."Currency Code", Enum::"Gen. Journal Document Type"::" ");

            LineNumber := LineNumber + 100;
            JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber, Enum::"Gen. Journal Account Type"::Customer,
            Loans."No.", Format(LnTransType) + '- ' + LnTopUp."No.", AmtPost, LoanAcc, PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", '', LnTopUp."Account No.", DActivity, DBranch, LnTransType,
            LnTopUp."No.", Loans."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
            LnTopUp."Currency Code", Enum::"Gen. Journal Document Type"::" ");
            LnInteger := LineNumber;
            exit(LnInteger)

        end
    end;

    procedure InitDebitBankingAcc(AccNo: Code[100]; AmtoPost: Decimal; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; BalAccNo: Code[100]; LineNo: Integer; ExtDocNo: Code[100])
    var
        LoanT: Record Loans;
    begin
        JnPost.ClearJournalLines(GnlTemplate, GnlJBatch);
        AccBanking.Reset();
        AccBanking.SetRange("No.", AccNo);
        if AccBanking.FindFirst() then begin
            AccBanking.CalcFields("Balance (LCY)");
            if AccBanking."Balance (LCY)" > 0 then begin
                LineNo := LineNo + 100;
                JnPost.CreateJnl(GnlTemplate, GnlJBatch, LineNo,
                Enum::"Gen. Journal Account Type"::Vendor,
                DocumentNo, TextDescription + '-' + DocumentNo,
                AccBanking."Balance (LCY)", AccNo, PDate,
                Enum::"Gen. Journal Account Type"::"Bank Account",
                BalAccNo, ExtDocNo, DActivity, DBranch,
                Enum::"LoanTransactionType"::" ", '', '', '',
                Enum::"Gen. Journal Document Type"::" ",
                '', Enum::"Gen. Journal Document Type"::" ", DocumentNo);
                JnPost.CompletePosting(GnlTemplate, GnlJBatch);
            end else
                Error('No funds available for this transaction');
        end else
            Error('Account not found');
    end;

    procedure InitDebitBankingAccExt(AccNo: Code[100]; AmtoPost: Decimal; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; BalAccNo: Code[100]; LineNo: Integer; ExtDocNo: Code[100]; Totalcommit: Decimal)
    var
        LoanT: Record Loans;
        RunBal: Decimal;
        AmountPost: Decimal;
    begin

        RunBal := 0;
        AmountPost := 0;

        AccBanking.Reset();
        AccBanking.SetRange("No.", AccNo);
        if AccBanking.FindFirst() then begin
            AccBanking.CalcFields("Balance (LCY)");
            if AccBanking."Balance (LCY)" < Totalcommit then Error('No enough funds for this Transaction');
            RunBal := AccBanking."Balance (LCY)";
        end;

        JnPost.ClearJournalLines(GnlTemplate, GnlJBatch);

        OtherCommit.Reset();
        OtherCommit.SetRange("Loan No.", DocumentNo);
        if OtherCommit.FindSet() then begin
            repeat
                AmountPost := 0;
                if RunBal > 0 then begin

                    if OtherCommit.Amount >= RunBal then
                        AmountPost := RunBal else
                        AmountPost := OtherCommit.Amount;

                    LineNo := LineNo + 100;
                    JnPost.CreateJnl(GnlTemplate, GnlJBatch, LineNo, Enum::"Gen. Journal Account Type"::Vendor, DocumentNo,
                    TextDescription + '-' + DocumentNo, AmountPost, AccBanking."No.", PDate, OtherCommit."Account Type",
                    OtherCommit."Account No.", OtherCommit."Bankers Cheque No",
                    DActivity, DBranch, Enum::"LoanTransactionType"::" ", '', '', '',
                    Enum::"Gen. Journal Document Type"::" ", '',
                    Enum::"Gen. Journal Document Type"::" ", DocumentNo);
                    RunBal := (RunBal - AmountPost);
                end;

            until OtherCommit.Next() = 0;
            JnPost.CompletePosting(GnlTemplate, GnlJBatch);
        end;

        OtherCommit.Reset();
        OtherCommit.SetRange("Loan No.", DocumentNo);
        if OtherCommit.FindSet() then begin
            OtherCommit.ModifyAll(Posted, true);
            OtherCommit.ModifyAll("Posted By", UserId);
            OtherCommit.ModifyAll("Date Posted", Today);
            OtherCommit.ModifyAll("Time Posted", Time);
            OtherCommit.ModifyAll("Approval Status", OtherCommit."Approval Status"::Posted);
        end
    end;

    procedure PostPurchase(LoanNo: Code[100]): Boolean
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
        LineNumber: Integer;
    begin
        if Loans.Get(LoanNo) then begin
            if Loans."Deposit Purchase" > 0 then
                exit(true) else
                exit(false)
        end;
    end;

    procedure CreatePurchaseGenJLine(Loans: Record Loans; Dim1: Code[10]; Dim2: Code[10]; JTemp: Code[10]; JBatchTemp: Code[10]; GenJLine: Integer; PostDate: Date): Integer
    var
        JLineNo: Integer;
        LoanChargePosted: Record "Loan Charge Posted";
    begin
        JLineNo := GenJLine;

        if PostPurchase(Loans."No.") then begin

            case Loans."Account Dimension" of
                Loans."Account Dimension"::Banking:
                    begin
                        JLineNo := JLineNo + 1000;

                        AccBanking.Reset();
                        AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
                        AccBanking.SetRange("No.", Loans."Deposit Purchase Account");
                        if AccBanking.FindFirst() then begin
                            JnPost.CreateJnl(JTemp, JBatchTemp, JLineNo, AcctType::Vendor, Loans."No.",
                            Format(AccBanking."Account Category") + '-Purchase', Loans."Deposit Purchase" * -1,
                            AccBanking."No.", PostDate, AcctType::"G/L Account", '', Loans."Account No.", Dim1, Dim2,
                            TransacType::" ", '', '', '', DocType::" ", '', DocType::" ", Loans."Product Type");
                        end else begin
                            Error(ErrorOnMissingMemberAcc)
                        end;
                    end;
                Loans."Account Dimension"::Credit,
                Loans."Account Dimension"::"Micro Credit":
                    begin
                        JLineNo := JLineNo + 1000;
                        if AccCredit.Get(Loans."Deposit Purchase Account") then begin
                            JnPost.CreateJnl(JTemp, JBatchTemp, JLineNo, AcctType::Customer, Loans."No.",
                            Format(AccCredit."Account Category") + '-Purchase', Loans."Deposit Purchase" * -1,
                            AccCredit."No.", PostDate, AcctType::"G/L Account", '', Loans."Account No.", Dim1, Dim2,
                            TransacType::" ", '', '', '', DocType::" ", '', DocType::" ", Loans."Product Type");
                        end else begin
                            Error(ErrorOnMissingMemberAcc)
                        end;
                    end;
            end;

            JLineNo := JLineNo + 1000;
            AccBanking.Reset();
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("No.", Loans."Disbursement Account No.");
            if AccBanking.FindFirst() then begin

                JnPost.CreateJnl(JTemp, JBatchTemp, JLineNo, AcctType::Vendor,
                Loans."No.", Format(Loans."Account Dimension") + '-Purchase',
                Loans."Deposit Purchase", AccBanking."No.", PostDate, AcctType::"G/L Account", '',
                Loans."Account No.", Dim1, Dim2, TransacType::" ", '', '', '', DocType::" ", '', DocType::" ", Loans."Product Type");
            end else begin
                Error(ErrorOnMissingMemberAcc);
            end;
            JLineNo := JLineNo + 1000;

            LoanChargePosted.Reset();
            LoanChargePosted.SetRange("Loan No.", Loans."No.");
            LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::Boosting);
            if LoanChargePosted.FindFirst() then begin

                exit(PostChargeMngt.fnPostAlternateLoanCharge(Loans."Product Type",
                LoanChargePosted."Charge Type", Loans."Deposit Purchase", Loans."Disbursement Account No.",
                 Dim1, Dim2, JTemp, JBatchTemp, Loans."No.", PostDate, JLineNo, Loans."Account No.", 0,
                 Enum::"Gen. Journal Account Type"::Vendor, Enum::"LoanTransactionType"::" ", ''))
            end;
        end
    end;

    procedure PostRevolveFund(LoanNo: Code[100]): Boolean
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
        LineNumber: Integer;
    begin
        if Loans.Get(LoanNo) then begin
            Loans.CalcFields("Total TopUp");
            if Loans."Total TopUp" > 0 then
                exit(true) else
                exit(false)
        end;
    end;

    procedure getAccruedInt(LoanNo: Code[100]): Decimal
    var
        EndDate: Date;
        StartDate: Date;
        IntDays: Integer;
        PostedLoan: Record Loans;
    begin

        GeneralSetUp.Get();
        case GeneralSetUp."Interest Posting Method" of
            GeneralSetUp."Interest Posting Method"::"Charge Daily":
                begin
                    if PostedLoan.Get(LoanNo) then begin
                        EndDate := Today;
                        StartDate := CalcDate('-CM', Today);
                        IntDays := (EndDate - StartDate) + 1;
                        exit(PeriodActMngt.fnIntEntriesonSpecificLoan(PostedLoan, Today, PostedLoan."No.", 1, IntDays, StartDate));
                    end else
                        exit(0)
                end else begin
                exit(0)
            end;
        end;
    end;

    local procedure CreateLiquidationEntry(PostingDate: Date; AmountToDisburse: Decimal;
    DocumentNo: Code[100]; JTemplate: Code[10]; JBatch: Code[10]; DActivity: Code[10];
    DBranch: Code[10]; CurrencyCode: Code[10]; ExDocIDNo: Code[50]; AccountNo: Code[100];
    TextDescription: Text[100]; LoanAcc: Code[100]; LoanNo: Code[100]; Line_No: Integer): Integer
    begin
        GenJournal.LockTable();

        Line_No := Line_No + 1;
        GenJournal."Line No." := Line_No;
        InitializeEntry(GenJournal, Line_No, JTemplate,
        JBatch, DocumentNo, CurrencyCode, PostingDate, DActivity, DBranch);
        GenJournal."External Document No." := ExDocIDNo;
        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
        GenJournal.Validate("Account No.", AccountNo);
        GenJournal.Description := CopyStr(TextDescription + DocumentNo, 1, 100);
        GenJournal.Validate(Amount, AmountToDisburse * -1);
        GenJournal.Validate("Shortcut Dimension 1 Code", DActivity);
        GenJournal.Validate("Shortcut Dimension 2 Code", DBranch);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);

        Line_No := Line_No + 1;
        GenJournal."Line No." := Line_No;
        InitializeEntry(GenJournal, Line_No, JTemplate,
        JBatch, DocumentNo, CurrencyCode, PostingDate, DActivity, DBranch);
        GenJournal."External Document No." := ExDocIDNo;
        GenJournal."Account Type" := GenJournal."Account Type"::Customer;
        GenJournal.Validate("Account No.", LoanAcc);
        GenJournal.Description := CopyStr(TextDescription + DocumentNo, 1, 100);
        GenJournal.Validate(Amount, AmountToDisburse);
        GenJournal."Transaction Type" := GenJournal."Transaction Type"::Loan;
        GenJournal.Validate("Loan No.", LoanNo);
        GenJournal.Validate("Shortcut Dimension 1 Code", DActivity);
        GenJournal.Validate("Shortcut Dimension 2 Code", DBranch);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);
        exit(Linenum)
    end;

    procedure PostLoanLiquidation(Loan: Record Loans; GenLineNo: Integer; PostDate: Date;
    Jnltemp: Code[10]; JnlBatch: Code[10]; DActivity: Code[10]; DBranch: Code[10]): Integer
    var
        ProductType: Record "Product Factory";
        LoanLiquidMgt: Record "Loans Liquidation";
        PostedLoan: Record Loans;
        TotalAccruedInt: Decimal;
        AccruedInt: Decimal;
        PrncipBalance: Decimal;
        LoanChargePosted: Record "Loan Charge Posted";
        LineNumbr: array[19] of Integer;
        LnProdCharge: Record "Loan Product Charges";
        ChargeAmt: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AcctType: Enum "Gen. Journal Account Type";
        TransacType: Enum "LoanTransactionType";
    begin

        LoanLiquidMgt.Reset;
        LoanLiquidMgt.SetRange("No.", Loan."Application No.");
        LoanLiquidMgt.SetRange("Account No.", Loan."Account No.");
        if LoanLiquidMgt.FindSet() then begin
            repeat

                PostedLoan.Reset();
                PostedLoan.SetRange("No.", LoanLiquidMgt."Loan Top Up");
                PostedLoan.SetFilter("Outstanding Balance", '>0');
                if PostedLoan.FindFirst() then begin
                    PostedLoan.CalcFields("Outstanding Bill", "Outstanding Insurance",
                    "Outstanding Interest", "Outstanding Principal", "Outstanding Balance");

                    if PostedLoan."Outstanding Interest" > 0 then begin
                        JnlPostMngt.CreateJnl(Jnltemp, JnlBatch, GenLineNo, AcctType::Vendor,
                                                 Loan."No.", CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") +
                                                 '-Loan Liquidation-' + PostedLoan."No.", 1, 100),
                                                 LoanLiquidMgt."Outstanding Interest", PostedLoan."Disbursement Account No.",
                                                 PostDate, AcctType::"G/L Account",
                                                 GeneralSetUp."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::" ",
                                                 '', '', '', DocType::" ", '', DocType::" ", '');

                        GenLineNo := GenLineNo + 1;
                        JnlPostMngt.CreateJnl(Jnltemp, JnlBatch, GenLineNo, AcctType::Customer,
                                                 Loan."No.", CopyStr(Format(Enum::"LoanTransactionType"::"Interest Paid") +
                                                 '-Loan Liquidation-' + PostedLoan."No.", 1, 100),
                                                 LoanLiquidMgt."Outstanding Interest" * -1, PostedLoan."Loan Account",
                                                 PostDate, AcctType::"G/L Account",
                                                 GeneralSetUp."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::"Interest Paid",
                                                 PostedLoan."No.", '', '', DocType::" ", '', DocType::" ", '');
                    end;

                    if PostedLoan."Outstanding Principal" > 0 then begin
                        GenLineNo := GenLineNo + 1;
                        JnlPostMngt.CreateJnl(Jnltemp, JnlBatch, GenLineNo, AcctType::Vendor,
                                                 Loan."No.", CopyStr(Format(Enum::"LoanTransactionType"::Repayment) +
                                                 '-Loan Liquidation-' + PostedLoan."No.", 1, 100),
                                                 LoanLiquidMgt."Outstanding Principle", PostedLoan."Disbursement Account No.",
                                                 PostDate, AcctType::"G/L Account",
                                                 GeneralSetUp."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::" ",
                                                 '', '', '', DocType::" ", '', DocType::" ", '');

                        GenLineNo := GenLineNo + 1;
                        JnlPostMngt.CreateJnl(Jnltemp, JnlBatch, GenLineNo, AcctType::Customer,
                                                 Loan."No.", CopyStr(Format(Enum::"LoanTransactionType"::Repayment) +
                                                 '-Loan Liquidation-' + PostedLoan."No.", 1, 100),
                                                 LoanLiquidMgt."Outstanding Principle" * -1, PostedLoan."Loan Account",
                                                 PostDate, AcctType::"G/L Account",
                                                 GeneralSetUp."Excise Duty G/L", ExtDocNo, Dim1, Dim2, TransacType::Repayment,
                                                 PostedLoan."No.", '', '', DocType::" ", '', DocType::" ", '');

                    end;
                end;
            until LoanLiquidMgt.Next() = 0;
        exit(GenLineNo);
        end;
    end;

    procedure CreateRevolveFundJnLine(Loans: Record Loans; JTemp: Code[10];
    JBatchTemp: Code[10]; ShortDim1: Code[10]; ShortDim2: Code[10]; GenJLine: Integer; PostDate: Date)
    var
        ProductType: Record "Product Factory";
        LineNumber: Integer;
        LoansTopupPosted: Record "Loans Top up";
        PostedLoan: Record Loans;
        TotalAccruedInt: Decimal;
        AccruedInt: Decimal;
        PrncipBalance: Decimal;
        LoanChargePosted: Record "Loan Charge Posted";
        LineNumbr: array[19] of Integer;
        LnProdCharge: Record "Loan Product Charges";
        ChargeAmt: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AcctType: Enum "Gen. Journal Account Type";
        TransacType: Enum "LoanTransactionType";
    begin
        GeneralSetUp.Get();
        PrncipBalance := 0;
        ChargeAmt := 0;
        LineNumber := GenJLine;

        if PostRevolveFund(Loans."No.") then begin

            LoansTopupPosted.Reset;
            LoansTopupPosted.SetRange("No.", Loans."Application No.");
            LoansTopupPosted.SetRange("Account No.", Loans."Account No.");
            LoansTopupPosted.SetFilter("Total Total Up", '>0');
            if LoansTopupPosted.Find('-') then begin
                repeat


                    TotalAccruedInt := 0;
                    AccruedInt := 0;
                    PrncipBalance := 0;
                    ChargeAmount := 0;

                    PostedLoan.Reset();
                    if PostedLoan.Get(LoansTopupPosted."Loan Top Up") then begin
                        PostedLoan.CalcFields("Outstanding Bill", "Outstanding Insurance",
                        "Outstanding Interest", "Outstanding Principal", "Outstanding Balance");

                        case GeneralSetUp."Interest Posting Method" of
                            GeneralSetUp."Interest Posting Method"::"Charge Daily":
                                begin

                                    LnProdCharge.Reset();
                                    LnProdCharge.SetRange("Product Code", LoansTopupPosted."Product Type");
                                    LnProdCharge.SetRange("Charge Type", LnProdCharge."Charge Type"::"Top up");
                                    if LnProdCharge.FindFirst() then begin
                                        case LnProdCharge."Charging Option" of
                                            LnProdCharge."Charging Option"::"On Outstanding Balance":
                                                begin
                                                    TotalAccruedInt := (PostedLoan."Outstanding Balance" + getAccruedInt(PostedLoan."No."));
                                                end;
                                            LnProdCharge."Charging Option"::"On Principle Balance":
                                                begin
                                                    TotalAccruedInt := (PostedLoan."Outstanding Principal" + getAccruedInt(PostedLoan."No."));
                                                end;
                                        end;
                                    end;
                                    AccruedInt := getAccruedInt(PostedLoan."No.");
                                end else begin
                                TotalAccruedInt := PostedLoan."Outstanding Balance";
                                AccruedInt := 0;
                            end;
                        end;

                        if getAccruedInt(PostedLoan."No.") > 0 then begin

                            if Prodfact.Get(PostedLoan."Product Type") then
                                JnPost.CreateJnl(JTemp, JBatchTemp, LineNumber + 10000, AcctType::Customer, Loans."No.",
                                'Accrued Interest on-' + PostedLoan."No.", getAccruedInt(PostedLoan."No."),
                                PostedLoan."Loan Account", PostDate, AcctType::"G/L Account",
                                 Prodfact."Interest Account (G/L)", PostedLoan."Account No.", ShortDim1, ShortDim2,
                                 TransacType::"Interest Due", PostedLoan."No.", '', '', DocType::" ", '',
                                 DocType::" ", PostedLoan."Product Type");
                        end;

                        if (PostedLoan."Outstanding Interest" + AccruedInt) > 0 then begin

                            LineNumber := fnInitializeDebitCreditJnline(Loans."No.", PostDate,
                            TransacType::"Interest Paid", ShortDim1, ShortDim2, JTemp,
                            JBatchTemp, (PostedLoan."Outstanding Interest" + getAccruedInt(PostedLoan."No.")),
                            LineNumber + 10000, 0, PostedLoan."No.", true,
                            Enum::"Gen. Journal Account Type"::Vendor, PostedLoan."Disbursement Account No.", false);
                        end;

                        if PostedLoan."Outstanding Insurance" > 0 then begin

                            LineNumber := fnInitializeDebitCreditJnline(Loans."No.", PostDate,
                              TransacType::"Insurance Paid", ShortDim1, ShortDim2, JTemp, JBatchTemp,
                              PostedLoan."Outstanding Insurance", LineNumber + 10000, 0, PostedLoan."No.", true,
                              Enum::"Gen. Journal Account Type"::Vendor, PostedLoan."Disbursement Account No.", false);
                        end;

                        if PostedLoan."Outstanding Bill" > 0 then begin
                            LineNumber := fnInitializeDebitCreditJnline(Loans."No.", PostDate,
                            TransacType::"Penalty Paid", ShortDim1, ShortDim2, JTemp,
                            JBatchTemp, PostedLoan."Outstanding Bill", LineNumber + 10000, 0, PostedLoan."No.", true,
                            Enum::"Gen. Journal Account Type"::Vendor, PostedLoan."Disbursement Account No.", false);

                        end;

                        if PostedLoan."Outstanding Principal" > 0 then begin

                            case GeneralSetUp."Refinance Options" of
                                GeneralSetUp."Refinance Options"::"Full Refinance":
                                    begin
                                        PrncipBalance := PostedLoan."Outstanding Principal"
                                    end;
                                GeneralSetUp."Refinance Options"::"Partial Refinance":
                                    begin
                                        PrncipBalance := LoansTopupPosted."Outstanding Principle"
                                    end;
                            end;
                            LineNumber := fnInitializeDebitCreditJnline(Loans."No.", PostDate,
                             TransacType::Repayment, ShortDim1, ShortDim2, JTemp, JBatchTemp,
                             PrncipBalance, LineNumber + 10000, 0, PostedLoan."No.", true,
                             Enum::"Gen. Journal Account Type"::Vendor, PostedLoan."Disbursement Account No.", false);
                        end;

                        if not LoansTopupPosted."Ignore Charges" then begin
                            LoansTopupPosted.TestField(Commision);

                            LineNumbr[2] := LineNumber;
                            LoanChargePosted.Reset();
                            LoanChargePosted.SetRange("Loan No.", Loans."No.");
                            LoanChargePosted.SetFilter("Charge Type", '%1 | %2 | %3', LoanChargePosted."Charge Type"::"Top up",
                            LoanChargePosted."Charge Type"::Restructure, LoanChargePosted."Charge Type"::Prorate);
                            if LoanChargePosted.FindSet() then begin
                                repeat
                                    LoanChargePosted.TestField("Account No.");
                                    ChargeAmt := 0;

                                    case LoanChargePosted."Charge Method" of
                                        LoanChargePosted."Charge Method"::"Flat Amount":
                                            begin
                                                LoanChargePosted.TestField("Charge Amount");
                                                ChargeAmt := LoanChargePosted."Charge Amount";

                                            end;
                                        LoanChargePosted."Charge Method"::"% of Amount":
                                            begin
                                                LoanChargePosted.TestField(Percentage);
                                                ChargeAmt := Round((PostedLoan."Outstanding Principal" * (LoanChargePosted.Percentage / 100)), 0.5, '=');
                                            end;
                                        LoanChargePosted."Charge Method"::Staggered:
                                            begin
                                                LoanChargePosted.TestField("Staggered Charge Code");

                                                TariffDetails.Reset;
                                                TariffDetails.SetRange(TariffDetails.Code, LoanChargePosted."Staggered Charge Code");
                                                if TariffDetails.Find('-') then begin
                                                    repeat

                                                        if (PostedLoan."Outstanding Principal" >= TariffDetails."Lower Limit") and (PostedLoan."Outstanding Principal" <= TariffDetails."Upper Limit") then begin
                                                            if TariffDetails."Use Percentage" = true then begin
                                                                ChargeAmt := Round((PostedLoan."Outstanding Principal" * TariffDetails.Percentage * 0.01), 0.5, '=');
                                                            end else begin
                                                                ChargeAmt := TariffDetails."Charge Amount";
                                                            end;
                                                        end;
                                                    until TariffDetails.Next = 0;
                                                end;

                                            end;
                                    end;

                                    LineNumber := LineNumber + 11;
                                    JnlPostMngt.CreateJnl(JTemp, JBatchTemp, LineNumber,
                                    AcctType::Vendor, Loans."No.", LoanChargePosted."Charge Description",
                                    ChargeAmt, Loans."Disbursement Account No.", PostDate, AcctType::"G/L Account",
                                    LoanChargePosted."Account No.", ExtDocNo, ShortDim1, ShortDim2, TransacType::" ",
                                    '', '', '', DocType::" ", '', DocType::" ", '');

                                    case LoanChargePosted."Effect Excise Duty" of
                                        LoanChargePosted."Effect Excise Duty"::Yes:
                                            begin

                                                GeneralSetUp.TestField("Excise Duty (%)");
                                                GeneralSetUp.TestField("Excise Duty G/L");

                                                LineNumber := LineNumber + 11;
                                                JnlPostMngt.CreateJnl(JTemp, JBatchTemp, LineNumber, AcctType::Vendor,
                                                Loans."No.", LoanChargePosted."Charge Description",
                                                Round((ChargeAmt * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '='),
                                                Loans."Disbursement Account No.", PostDate, AcctType::"G/L Account",
                                                GeneralSetUp."Excise Duty G/L", ExtDocNo, ShortDim1, ShortDim2, TransacType::" ",
                                                '', '', '', DocType::" ", '', DocType::" ", '');
                                            end;
                                    end;
                                until LoanChargePosted.Next() = 0;
                            end;
                        end;
                    end;
                until LoansTopupPosted.Next() = 0;
            end;
        end;
    end;

    local procedure OnCompletePostMgt(Variantext: Integer; LoanNo: Code[100])
    var
        RecRef: RecordRef;
        PostedLoan: Record Loans;
        Member: Record Member;
        PLoanTxt: Record Loans;
        LoanCategory: Record "Loans Categorization";
        MonthlyContrib: Record "Member Monthly Contribution";
        LoanApplic: Record "Loan Application";
        PartSched: Record "Partial Disbursement Schedule";
        PartLoan: Record "Partial Disbursement Schedule";
        ChequeRegister: Record "Cheque Register";
        UnsupportedRecordTypeErr: Label 'Action Item %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
    begin

        case Variantext of
            0:
                begin

                    GeneralSetUp.Get();
                    PostedLoan.Reset();
                    PostedLoan.SetRange("No.", LoanNo);
                    if PostedLoan.FindFirst() then begin

                        CrmApplic.Reset();
                        CrmApplic.SetRange("No.", PostedLoan."CRM Application No.");
                        if CrmApplic.FindFirst() then begin
                            CrmApplic.Created := true;
                            CrmApplic."Approval Status" := CrmApplic."Approval Status"::Posted;
                            CrmApplic.Modify(true);
                        end;

                        OtherCommit.Reset();
                        OtherCommit.SetRange("Application No.", PostedLoan."Application No.");
                        if OtherCommit.FindSet() then begin
                            OtherCommit.ModifyAll("Time Posted", Time);
                            OtherCommit.ModifyAll("Date Posted", Today);
                            OtherCommit.ModifyAll("Disbursement Date", Today);
                            OtherCommit.ModifyAll("Approval Status", OtherCommit."Approval Status"::Posted);
                        end;

                        if Member.Get(PostedLoan."Account No.") then begin
                            Member."Loan Status" := Member."Loan Status"::Active;
                            Member.Modify(true);

                            SmsNotification.CreateSmsNotif(NotifSource::"Loan Posted", Member."Mobile Phone No",
                              'Dear member, Your Loan Application of ' + GenLedgerSetup."Local Currency Symbol" +
                              Format(PostedLoan."Approved Amount") +
                              ' repayable in ' + format(PostedLoan.Installments) + ' at ' + Format(PostedLoan."Interest Rate") +
                              ' P.A has been issued. Thank You', Member."No.",
                                 Member."No.", false);
                        end;

                        if PostedLoan."Application Type" = PostedLoan."Application Type"::Normal then begin
                            if PostedLoan."EFT Options" <> PostedLoan."EFT Options"::" " then begin

                                if AccBanking.Get(PostedLoan."Disbursement Account No.") then begin
                                    AccBanking.CalcFields("Balance (LCY)");
                                    if PostedLoan."Mode of Disbursement" = PostedLoan."Mode of Disbursement"::"Full Disbursement" then begin
                                        case PostedLoan."Payment Mode" of
                                            PostedLoan."Payment Mode"::Cheque:
                                                begin

                                                    if PostedLoan."Cheque Option" = PostedLoan."Cheque Option"::"Individual Cheque" then begin

                                                        CreateJournalTemplate();
                                                        InitDebitBankingAcc(AccBanking."No.",
                                                        AccBanking."Balance (LCY)", PostedLoan."No.", PostedLoan."Disbursement Date", Dim1, Dim2,
                                                        Jtemplate, JBatch, PostedLoan."Payment Destination Code", 100, PostedLoan."Cheque No");
                                                        if PostedLoan."Cheques Type" = PostedLoan."Cheques Type"::"Computer Check" then begin

                                                            ChequeRegister.Reset();
                                                            ChequeRegister.SetRange(ChequeRegister."Cheque No.", PostedLoan."Cheque No");
                                                            if ChequeRegister.FindFirst() then begin
                                                                ChequeRegister."Entry Status" := ChequeRegister."Entry Status"::Issued;
                                                                ChequeRegister."Issued By" := UserId;
                                                                ChequeRegister."Issued Doc No." := PostedLoan."No.";
                                                                ChequeRegister."Cheque Date" := Today;
                                                                ChequeRegister.Issued := true;
                                                                ChequeRegister.Modify();
                                                            end;
                                                        end;
                                                    end;
                                                    if PostedLoan."Cheque Option" = PostedLoan."Cheque Option"::"Multiple Cheque" then begin
                                                        PostedLoan.CalcFields("External Payment");
                                                        CreateJournalTemplate();
                                                        InitDebitBankingAccExt(AccBanking."No.", AccBanking."Balance (LCY)",
                                                        PostedLoan."No.", PostedLoan."Disbursement Date", Dim1, Dim2,
                                                        Jtemplate, JBatch, PostedLoan."Payment Destination Code", 100,
                                                        PostedLoan."Cheque No", PostedLoan."External Payment");
                                                    end;
                                                end;
                                            PostedLoan."Payment Mode"::EFT:
                                                begin
                                                    BankMngt.PostLien(AccBanking, AccBanking."Balance (LCY)", PostedLoan."Product Description", 1, PostedLoan."No.");
                                                end;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        PostedLoan."Posted By" := UserId;
                        PostedLoan."Date Posted" := Today;
                        PostedLoan."Time Posted" := Time;
                        if PostedLoan."TopUp Loan" = '' then
                            PostedLoan.Validate("Disbursement Date", Today);
                        PostedLoan."Interest Posting Date" := Today;
                        if PostedLoan."Mode of Disbursement" = PostedLoan."Mode of Disbursement"::"Full Disbursement" then
                            PostedLoan."Loan Status" := PostedLoan."Loan Status"::Issued else
                            PostedLoan."Loan Status" := PostedLoan."Loan Status"::"Partial Payment";
                        PostedLoan."Approval Status" := PostedLoan."Approval Status"::Posted;
                        if PostedLoan."TopUp Loan" <> '' then begin
                            PostedLoan.CalcFields("Outstanding Balance");

                            ApplicLoan.Reset();
                            ApplicLoan.SetRange("TopUp Loan", PostedLoan."No.");
                            if ApplicLoan.FindFirst() then
                                PostedLoan.Validate("Requested Amount", (PostedLoan."Outstanding Balance" + ApplicLoan."Approved Amount"));

                            if LoanCategory.Get(PostedLoan."No.") then begin
                                LoanCategory.Validate("Requested Amount", (PostedLoan."Outstanding Balance" + ApplicLoan."Approved Amount"));
                                LoanCategory.Modify(true);

                            end;
                        end;
                        PostedLoan.Modify(true);
                        CredMgt.ValuePost(PostedLoan."No.", 0);
                    end;

                end;
            1:
                begin

                    GeneralSetUp.Get();

                    PartLoan.Reset();
                    PartLoan.SetRange("Entry No", LoanNo);
                    if PartLoan.FindFirst() then begin

                        PartLoan.Validate(Posted, true);
                        PartLoan.Validate("Time Posted", Time);
                        PartLoan.Validate("Date Posted", Today);
                        PartLoan.Validate("Posted By", UserId);
                        PartLoan.Validate("Approval Status", PartLoan."Approval Status"::Posted);
                        PartLoan.Modify(true);

                        if Member.Get(PartLoan."Member No.") then begin
                            SmsNotification.CreateSmsNotif(NotifSource::"Loan Posted", Member."Mobile Phone No",
                      'Dear member, Your Partial Loan payment of ' + GenLedgerSetup."Local Currency Symbol" +
                      Format(PartLoan.Amount) + ' has been credited to your account. Thank You', Member."No.",
                         Member."No.", false);
                        end;
                    end;
                end;
        end;
    end;

    procedure CalculateChargeAmt(ChargeCode: Code[10]; AmtPost: Decimal; LoanType: Code[10]; LoanNo: Code[100]): Decimal
    var
        LoanChargePosted: Record "Loan Charge Posted";
        TransType: Record "Transaction Charge";
        ChargeAmt: Decimal;
        TieredChargeLine: Record "Tiered Charges Line";
        ProdCharge: Record "Loan Product Charges";
    begin

        ProdCharge.Reset();
        ProdCharge.SetRange("Charge Code", ChargeCode);
        ProdCharge.SetRange("Product Code", LoanType);
        if ProdCharge.Find('-') then begin
            case ProdCharge."Staggered Charge Code" of
                '':
                    begin
                        if ProdCharge."Use Percentage" then begin
                            ProdCharge.TestField(Percentage);
                            ChargeAmt := Round(((ProdCharge.Percentage / 100) * AmtPost), 0.5, '=');
                        end else begin
                            if ProdCharge."Charge Type" <> ProdCharge."Charge Type"::Prorate then
                                ProdCharge.TestField("Charge Amount");
                            ChargeAmt := ProdCharge."Charge Amount"
                        end;
                    end else begin

                    TransType.Reset();
                    TransType.SetRange("Staggered Charge Code", ProdCharge."Staggered Charge Code");
                    if TransType.FindFirst() then begin

                        TieredChargeLine.Reset();
                        TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                        if TieredChargeLine.FindSet() then begin
                            repeat
                                if (AmtPost >= TieredChargeLine."Lower Limit") and (AmtPost <= TieredChargeLine."Upper Limit") then begin
                                    if TieredChargeLine."Use Percentage" then begin
                                        ChargeAmt := Round((AmtPost * (TieredChargeLine.Percentage / 100)), 0.5, '=');
                                    end else begin
                                        ChargeAmt := TieredChargeLine."Charge Amount"
                                    end;
                                end;
                            until TieredChargeLine.Next() = 0;
                        end;
                    end;
                end;
            end;
            exit(ChargeAmt)
        end;
        exit(0)
    end;

    local procedure CreateEntryOnRefLoan(PostedLoan: Record Loans; GnlTemplate: Code[10]; GnlJBatch: Code[10]; PDate: Date; ShortDim1: Code[10]; ShortDim2: Code[10])
    var

        ProductType: Record "Product Factory";
        LineNumber: Integer;
        LoansTopupPosted: Record "Loans Top up Posted";
        AccruedInt: Decimal;
        LoanChargePosted: Record "Loan Charge Posted";
        LineNumbr: array[19] of Integer;
        ChargeAmt: Decimal;
        ApprvdAmt: Decimal;
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        RecRef: Record Loans;
        EndDate: Date;
        StartDate: Date;
        IntDays: Integer;
        TotalAccruedInt: Decimal;
    begin
        PostedLoan.CalcFields("Total TopUp");

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", PostedLoan."No.");
        LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
        if LoanChargePosted.Find('-') then begin
            repeat
                LoanChargePosted.TestField("Account No.");
                ChargeAmt := 0;
                ApprvdAmt := 0;

                case LoanChargePosted."Charge Type" of
                    LoanChargePosted."Charge Type"::Boosting:
                        ApprvdAmt := PostedLoan."Deposit Purchase";
                    LoanChargePosted."Charge Type"::"Top up":
                        ApprvdAmt := PostedLoan."Total TopUp";
                    else
                        ApprvdAmt := PostedLoan."Approved Amount"
                end;

                ChargeAmt := CalculateChargeAmt(LoanChargePosted."Charge Code",
                ApprvdAmt, LoanChargePosted."Product Code", PostedLoan."No.");

                LineNumber := LineNumber + 10;
                JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
                Enum::"Gen. Journal Account Type"::Customer, PostedLoan."No.",
                LoanChargePosted."Charge Description" + '- ' + PostedLoan."No.",
                ChargeAmt, PostedLoan."Loan Account", PDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                LoanChargePosted."Account No.", PostedLoan."Account No.",
                ShortDim1, ShortDim2, Enum::"LoanTransactionType"::Loan,
                PostedLoan."No.", PostedLoan."Group Code", '',
                Enum::"Gen. Journal Document Type"::" ", PostedLoan."Currency Code",
                Enum::"Gen. Journal Document Type"::" ");
            until LoanChargePosted.Next = 0;
        end;

        if PostRevolveFund(PostedLoan."No.") then begin

            LoansTopupPosted.Reset;
            LoansTopupPosted.SetRange("Loan No.", PostedLoan."No.");
            LoansTopupPosted.SetRange("Account No.", PostedLoan."Account No.");
            if LoansTopupPosted.Find('-') then begin
                repeat
                    AccruedInt := 0;
                    TotalAccruedInt := 0;

                    if RecRef.Get(LoansTopupPosted."Loan Top Up") then begin
                        RecRef.CalcFields("Outstanding Balance", "Outstanding Bill", "Outstanding Insurance",
                         "Outstanding Interest", "Outstanding Principal");

                        if RecRef."Outstanding Balance" > 0 then begin

                            TotalAccruedInt := (RecRef."Outstanding Balance" + getAccruedInt(RecRef."No."));

                            EndDate := Today;
                            StartDate := CalcDate('-CM', Today);
                            IntDays := (EndDate - StartDate) + 1;
                            AccruedInt := PeriodAct.fnIntEntriesonSpecificLoan(RecRef, Today, RecRef."No.", 1, IntDays, StartDate);

                            if AccruedInt > 0 then begin
                                if Prodfact.Get(RecRef."Product Type") then begin
                                    Prodfact.TestField("Interest Account (G/L)");

                                    LineNumber := LineNumber + 10;
                                    JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
                                    Enum::"Gen. Journal Account Type"::Customer,
                                    PostedLoan."No.", 'Accrued Interest on' + '- ' + RecRef."No.", AccruedInt,
                                    RecRef."Loan Account", PDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                    Prodfact."Interest Account (G/L)", PostedLoan."Account No.", ShortDim1, ShortDim2,
                                    Enum::"LoanTransactionType"::"Interest Due", RecRef."No.", PostedLoan."Group Code", '',
                                    Enum::"Gen. Journal Document Type"::" ", RecRef."Currency Code",
                                    Enum::"Gen. Journal Document Type"::" ");
                                end;
                            end;

                            LineNumber := LineNumber + 10;

                            if (RecRef."Outstanding Interest" + AccruedInt) > 0 then begin

                                fnInitializeDebitCreditJnline(PostedLoan."No.", Today,
                                TransacType::"Interest Paid", ShortDim1, ShortDim2, GnlTemplate, GnlJBatch,
                                (RecRef."Outstanding Interest" + AccruedInt), LineNumber, 0, RecRef."No.", true,
                                Enum::"Gen. Journal Account Type"::Customer, PostedLoan."Loan Account", true);
                            end;

                            if RecRef."Outstanding Insurance" > 0 then begin

                                LineNumber := fnInitializeDebitCreditJnline(PostedLoan."No.", Today,
                                 TransacType::"Insurance Paid", ShortDim1, ShortDim2, GnlTemplate, GnlJBatch,
                                 RecRef."Outstanding Insurance", LineNumber + 10, 0, RecRef."No.", true,
                                 Enum::"Gen. Journal Account Type"::Customer, PostedLoan."Loan Account", true);

                            end;

                            if RecRef."Outstanding Bill" > 0 then begin

                                LineNumber := fnInitializeDebitCreditJnline(PostedLoan."No.", Today,
                                 TransacType::"Penalty Paid", ShortDim1, ShortDim2, GnlTemplate, GnlJBatch,
                                 RecRef."Outstanding Bill", LineNumber + 10, 0, RecRef."No.", true,
                                 Enum::"Gen. Journal Account Type"::Customer, PostedLoan."Loan Account", true);

                            end;

                            if RecRef."Outstanding Principal" > 0 then begin

                                LineNumber := fnInitializeDebitCreditJnline(PostedLoan."No.", Today,
                                 TransacType::Repayment, ShortDim1, ShortDim2, GnlTemplate, GnlJBatch,
                                 RecRef."Outstanding Principal", LineNumber + 10, 0, RecRef."No.", true,
                                 Enum::"Gen. Journal Account Type"::Customer, PostedLoan."Loan Account", true);

                            end;

                            if PostedLoan."Mode of Disbursement" = PostedLoan."Mode of Disbursement"::"Full Disbursement" then begin
                                LineNumbr[2] := LineNumber;
                                LoanChargePosted.Reset();
                                LoanChargePosted.SetRange("Loan No.", PostedLoan."No.");
                                LoanChargePosted.SetFilter("Charge Type", '%1 | %2 | %3', LoanChargePosted."Charge Type"::"Top up",
                                LoanChargePosted."Charge Type"::Restructure, LoanChargePosted."Charge Type"::Prorate);
                                if LoanChargePosted.Find('-') then begin
                                    repeat

                                        ChargeAmt := 0;
                                        ApprvdAmt := 0;

                                        ApprvdAmt := TotalAccruedInt;
                                        if LoanChargePosted."Charge Type" = LoanChargePosted."Charge Type"::Prorate then
                                            ChargeAmt := LoanChargePosted."Charge Amount" else
                                            ChargeAmt := CalculateChargeAmt(LoanChargePosted."Charge Code",
                                            ApprvdAmt, LoanChargePosted."Product Code", PostedLoan."No.");

                                        LineNumber := LineNumber + 100;
                                        JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
                                        Enum::"Gen. Journal Account Type"::Customer, PostedLoan."No.",
                                        LoanChargePosted."Charge Description" + '- ' + RecRef."No.",
                                        ChargeAmt, PostedLoan."Loan Account", PDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                        LoanChargePosted."Account No.", PostedLoan."Account No.", ShortDim1, ShortDim2,
                                        Enum::"LoanTransactionType"::Loan, PostedLoan."No.", PostedLoan."Group Code", '',
                                        Enum::"Gen. Journal Document Type"::" ",
                                        PostedLoan."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                                    until LoanChargePosted.Next() = 0;
                                end;

                            end else begin
                                LineNumbr[2] := LineNumber;
                                LoanChargePosted.Reset();
                                LoanChargePosted.SetRange("Loan No.", PostedLoan."No.");
                                LoanChargePosted.SetFilter("Charge Type", '%1 | %2', LoanChargePosted."Charge Type"::"Top up", LoanChargePosted."Charge Type"::Prorate);
                                if LoanChargePosted.Find('-') then begin
                                    repeat

                                        ChargeAmt := 0;
                                        ApprvdAmt := 0;

                                        ApprvdAmt := TotalAccruedInt;
                                        if LoanChargePosted."Charge Type" = LoanChargePosted."Charge Type"::Prorate then
                                            ChargeAmt := LoanChargePosted."Charge Amount" else
                                            ChargeAmt := CalculateChargeAmt(LoanChargePosted."Charge Code",
                                            ApprvdAmt, LoanChargePosted."Product Code", PostedLoan."No.");

                                        LineNumber := LineNumber + 100;
                                        JnPost.PostJournal(GnlTemplate, GnlJBatch, LineNumber,
                                        Enum::"Gen. Journal Account Type"::Customer, PostedLoan."No.",
                                        LoanChargePosted."Charge Description" + '- ' + RecRef."No.",
                                        ChargeAmt, PostedLoan."Loan Account", PDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                        LoanChargePosted."Account No.", PostedLoan."Account No.", ShortDim1, ShortDim2,
                                        Enum::"LoanTransactionType"::Loan, PostedLoan."No.", PostedLoan."Group Code", '',
                                        Enum::"Gen. Journal Document Type"::" ",
                                        PostedLoan."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                                    until LoanChargePosted.Next() = 0;
                                end;
                            end;
                        end
                    end;
                until LoansTopupPosted.Next() = 0;
            end;
        end;
    end;

}
