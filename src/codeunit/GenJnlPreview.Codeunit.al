codeunit 50065 "Gen.Jnl.+Preview"
{

    trigger OnRun()
    begin

    end;

    var
        LoanApplication: Record Loans;
        OtherCommit: Record "Other Commitements Clearance";
        Notif: Codeunit "SMS Notification";
        BankMngt: Codeunit "Banking Procedure Mngt.";
        LoanRec: Record Loans;
        ApplicationLoan: Record "Loan Application";
        CredMgt: Codeunit "Credit Mgmt.";
        Temp: Record "Banking User Template";
        InterestLineEntry: Record "Interest Line";
        TopUpPosted: Record "Loans Top up Posted";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Post: Codeunit "Journal Post Mngt.";
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        Linenum: Integer;
        Text00002: Label 'Interest Charged-';
        TextDescription: Label 'Principal amount-';
        Amt: array[7] of Decimal;
        JournalLines: Record "Gen. Journal Line";
        TopUpRecord: Record "Loans Top up";
        InitPost: Codeunit "Initialize Gen. Jnl.-Post";
        LoansTopupPosted: Record "Loans Top up Posted";
        RecRef: Record Loans;
        TextTopup: Label 'Loan cleared-';
        GenLines: Record "Gen. Journal Line";
        LoanChargePosted: Record "Loan Charge Posted";
        GeneralSetUp: Record "General Set-Up";
        GenJournal: Record "Gen. Journal Line";
        AccBanking: Record "Account Banking";
        CredAcc: Record "Account Credit";
        TextE0009: Label 'Excise Duty on-';
        Text001Description: Label 'Loan Principal Amount-';
        Text002Description: Label 'Deposit Purchase-';
        NotificationTemplates: Record "Notification Template";
        SmsNotification: Codeunit "SMS Notification";
        Member: Record Member;
        DocsMngt: Codeunit "Doc. Mngt";
        PFact: Record "Product Factory";
        MonthCont: Record "Member Monthly Contribution";
        AcCatType: Enum ProductAccountCategory;
        AdviceType: Enum AdviseType;
        NotifSource: Enum NotifSourceType;
        VarVariant: Variant;
        LnApplic: Record "Loan Application";
        LnPostCharg: Record "Loan Application Charge";
        PLoan: Record Loans;

    procedure CodePost(LoanNo: Code[100]; CheckLine: Boolean; PostingDate: Date; DocumentNo: Code[100])
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: array[3] of Decimal;
        RecRef: Record Loans;
        PostedLoan: Record Loans;
        VarVariant: Variant;
        CustRecord: Record Customer;
        CreditAccounts: Record "Credit Account";
        StartDate: Date;
        EndDate: Date;
        AccruedInt: Decimal;
        IntDays: Integer;
        RegMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        GenLines: Record "Gen. Journal Line";
        LoanChrg: Record "Loan Charges";
        LoanProdCharges: Record "Loan Product Charges";
        Registry: Codeunit "Registry Mngt.";
        MonthCont: Record "Member Monthly Contribution";
        OutInterest: Decimal;
        AmountToDisburse: Decimal;
        PartialDisb: Record "Partial Disbursement Schedule";
        CrmApplic: Record "CRM Application";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        Mcontribution: Record "Member Monthly Contribution";
        Text016: Label 'You cannot Post %1-%2 because there is at least one posted entry related to this transaction.';
        LnPostCharges: Record "Loan Charge Posted";
        Applic: Record "Loan Application";
        LnAppCharges: Record "Loan Product Charges";
        PostedCharges: Record "Loan Charge Posted";
        TopupPosted: Record "Loans Top up Posted";
        TopUpLoan: Record "Loans Top up";
        FosaAc: Record "Account Banking";
        ErrorOnMissingCharges: Label 'Topup Charges details missing on this application which attracts topup charges.';

    begin
        RecRef.Reset();
        RecRef.SetRange("No.", LoanNo);
        if RecRef.FindFirst() then begin

            RecRef.fnTestFields;
            PassDocumentNo;
            AmountToDisburse := 0;

            if TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 0) then begin
                Error(Text016, RecRef."Account Name", RecRef."No.");
            end;

            AccBanking.Get(RecRef."Disbursement Account No.");

            Applic.Reset();
            Applic.SetRange("No.", RecRef."Application No.");
            if Applic.FindFirst() then begin
                Applic.CalcFields("Total TopUp");
                if Applic."Total TopUp" > 0 then begin
                    RecRef.CalcFields("Total TopUp");
                    LnPostCharges.Reset();
                    LnPostCharges.SetRange("Loan No.", RecRef."No.");
                    if not LnPostCharges.FindFirst() then begin
                        Error(ErrorOnMissingCharges);
                    end;
                end;
            end;

            CustRecord.Reset();
            CustRecord.SetRange("No.", RecRef."Loan Account");
            CustRecord.SetRange("Account Dimension", CustRecord."Account Dimension"::Repayment);
            if not CustRecord.Find('-') then begin

                CreditAccounts.Reset();
                CreditAccounts.SetRange("No.", RecRef."Loan Account");
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
                        AccDimension::Repayment, ProdCategory::" "
                    );
                end;
            end;

            Amt[1] := 0;
            Amt[2] := 0;

            RecRef.CalcFields("Amount to Post");
            case RecRef."Mode of Disbursement" of
                RecRef."Mode of Disbursement"::"Full Disbursement":
                    begin
                        AmountToDisburse := RecRef."Approved Amount"
                    end;
                RecRef."Mode of Disbursement"::"Partial Disbursement":
                    begin
                        PartialDisb.Reset();
                        PartialDisb.SetRange("Loan No.", RecRef."Application No.");
                        PartialDisb.SetRange("Suggested for Disbursement", true);
                        if not PartialDisb.FindFirst() then
                            Error('No Lines suggested for posting');
                        AmountToDisburse := RecRef."Amount to Post";
                    end
            end;

            GenJournal.LockTable;
            Linenum := Linenum + 1000;
            GenJournal.Init();
            GenJournal."Line No." := Linenum;
            GenJournal."Account Type" := GenJournal."Account Type"::Customer;
            GenJournal."External Document No." := RecRef."Account No.";
            GenJournal.Validate("Account No.", RecRef."Loan Account");
            GenJournal."Document No." := DocumentNo;
            GenJournal."Journal Template Name" := Jtemplate;
            GenJournal."Journal Batch Name" := JBatch;
            GenJournal."Posting Date" := PostingDate;
            GenJournal.Validate(Amount, AmountToDisburse);
            GenJournal.Description := CopyStr(TextDescription + DocumentNo, 1, 50);
            GenJournal."Transaction Type" := GenJournal."Transaction Type"::Loan;
            GenJournal.Validate("Loan No.", DocumentNo);
            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
            if GenJournal.Amount <> 0 then
                GenJournal.Insert(true);


            if RecRef."Mode of Disbursement" = RecRef."Mode of Disbursement"::"Full Disbursement" then begin

                Linenum := Linenum + 1000;
                GenJournal.Init();
                GenJournal."Line No." := Linenum;
                GenJournal."Journal Template Name" := Jtemplate;
                GenJournal."Journal Batch Name" := JBatch;
                GenJournal."Document No." := DocumentNo;
                GenJournal."Posting Date" := PostingDate;
                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                GenJournal."External Document No." := RecRef."Account No.";
                GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                GenJournal.Validate("Currency Code", '');
                GenJournal.Validate(Amount, AmountToDisburse * -1);
                GenJournal.Description := CopyStr(Text001Description + DocumentNo, 1, 50);
                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                if GenJournal.Amount <> 0 then
                    GenJournal.Insert(true);

            end else begin

                PartialDisb.Reset();
                PartialDisb.SetRange("Loan No.", RecRef."Application No.");
                PartialDisb.SetRange("Suggested for Disbursement", true);
                if PartialDisb.FindFirst() then begin
                    Linenum := Linenum + 1000;

                    GenJournal.Init();
                    GenJournal."Account Type" := PartialDisb."Account Type";
                    GenJournal."Document No." := DocumentNo;
                    GenJournal."External Document No." := RecRef."Account No.";
                    GenJournal.Validate("Account No.", PartialDisb."Account No.");
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Document No." := DocumentNo;
                    GenJournal.Validate(Amount, AmountToDisburse * -1);
                    GenJournal.Description := CopyStr(Text001Description + DocumentNo, 1, 50);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);
                end;
            end;

            LoanChargePosted.Reset;
            LoanChargePosted.SetRange("Loan No.", RecRef."No.");
            LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
            if not LoanChargePosted.Find('-') then begin

                LnAppCharges.Reset();
                LnAppCharges.SetRange("Product Code", RecRef."Product Type");
                LnAppCharges.SetRange("Charge Type", LnAppCharges."Charge Type"::General);
                if LnAppCharges.FindSet() then begin
                    repeat

                        PostedCharges.Init();
                        PostedCharges."Charge Code" := LnAppCharges."Charge Code";
                        PostedCharges."Account Type" := LnAppCharges."Account Type";
                        PostedCharges."Account No." := LnAppCharges."Charges Account";
                        PostedCharges."Charge Amount" := LnAppCharges."Charge Amount";
                        PostedCharges."Charge Type" := LnAppCharges."Charge Type";
                        PostedCharges."Use Percentage" := LnAppCharges."Use Percentage";
                        PostedCharges.Percentage := LnAppCharges.Percentage;
                        PostedCharges."Loan No." := RecRef."No.";
                        PostedCharges."Application No." := RecRef."Application No.";
                        PostedCharges."Charge Description" := LnAppCharges."Charge Description";
                        PostedCharges.Insert(true);

                    until LnAppCharges.Next() = 0;
                end;
            end;

            LoanChargePosted.Reset;
            LoanChargePosted.SetRange("Loan No.", RecRef."No.");
            LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
            if LoanChargePosted.Find('-') then begin
                repeat
                    LoanChargePosted.TestField("Account No.");
                    ChargeAmt[1] := 0;
                    ChargeAmt[2] := 0;

                    case LoanChargePosted."Charge Type" of
                        LoanChargePosted."Charge Type"::Boosting:
                            ChargeAmt[2] := RecRef."Deposit Purchase";
                        LoanChargePosted."Charge Type"::"Top up":
                            ChargeAmt[2] := RecRef."Total TopUp";
                        else
                            ChargeAmt[2] := AmountToDisburse
                    end;

                    Linenum := Linenum + 1000;
                    GenJournal.Init();
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                    GenJournal."External Document No." := RecRef."Account No.";
                    GenJournal."Document No." := DocumentNo;
                    GenJournal.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                    GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                    GenJournal."External Document No." := RecRef."Account No.";
                    if LoanChargePosted."Staggered Charge Code" = '' then begin
                        if not LoanChargePosted."Use Percentage" then begin
                            GenJournal.Validate(Amount, LoanChargePosted."Charge Amount");
                        end else begin
                            LoanChargePosted.TestField(Percentage);
                            if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                                GenJournal.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                            end else begin
                                GenJournal.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '='));
                            end;
                        end;

                    end else begin

                        TransType.Reset();
                        TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                        if TransType.FindFirst() then begin
                            TieredChargeLine.Reset();
                            TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                            if TieredChargeLine.FindSet() then begin
                                repeat
                                    if (RecRef."Approved Amount" >= TieredChargeLine."Lower Limit") and (RecRef."Approved Amount" <= TieredChargeLine."Upper Limit") then begin
                                        GenJournal.Validate(Amount, Round(RecRef."Approved Amount" * (TieredChargeLine.Percentage / 100), 1, '='));
                                    end;
                                until TieredChargeLine.Next() = 0;
                            end;
                        end;
                    end;

                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);

                    Linenum := Linenum + 1000;
                    GenJournal.Init();
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Account Type" := LoanChargePosted."Account Type";
                    GenJournal."External Document No." := RecRef."Account No.";
                    GenJournal."Document No." := DocumentNo;
                    GenJournal.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                    GenJournal.Validate("Account No.", LoanChargePosted."Account No.");
                    GenJournal."External Document No." := RecRef."Account No.";

                    if LoanChargePosted."Staggered Charge Code" = '' then begin
                        if not LoanChargePosted."Use Percentage" then begin
                            GenJournal.Validate(Amount, LoanChargePosted."Charge Amount" * -1);
                        end else begin
                            LoanChargePosted.TestField(Percentage);
                            if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                                GenJournal.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '=') * -1);
                            end else begin
                                GenJournal.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') * -1);
                            end;
                        end;

                    end else begin

                        TransType.Reset();
                        TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                        if TransType.FindFirst() then begin
                            TieredChargeLine.Reset();
                            TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                            if TieredChargeLine.FindSet() then begin
                                repeat
                                    if (RecRef."Approved Amount" >= TieredChargeLine."Lower Limit") and (RecRef."Approved Amount" <= TieredChargeLine."Upper Limit") then begin
                                        GenJournal.Validate(Amount, Round(RecRef."Approved Amount" * (TieredChargeLine.Percentage / 100), 1, '=') * -1);
                                    end;
                                until TieredChargeLine.Next() = 0;
                            end;
                        end;
                    end;
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);

                    ChargeAmt[1] := GenJournal.Amount;

                    case LoanChargePosted."Effect Excise Duty" of
                        LoanChargePosted."Effect Excise Duty"::Yes:
                            begin
                                Linenum := Linenum + 1000;
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal."External Document No." := RecRef."Account No.";
                                GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."External Document No." := RecRef."Account No.";
                                GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                GenJournal."External Document No." := RecRef."Account No.";
                                GenJournal.Validate(Amount, Round(((GeneralSetUp."Excise Duty (%)" / 100) * ChargeAmt[1]), 1, '='));
                                GenJournal.Description := CopyStr(TextE0009 + LoanChargePosted."Charge Description", 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                            end
                    end
                until LoanChargePosted.Next = 0;
            end;

            AccruedInt := 0;
            Linenum := Linenum + 1000;

            RecRef.CalcFields("Accrued Interest");

            case RecRef."Charge Interest on Posting" of
                RecRef."Charge Interest on Posting"::"Pro-rate":
                    begin
                        if LnApplic.Get(RecRef."Application No.") then
                            LnApplic.CalcFields("Accrued Interest");
                        AccruedInt := LnApplic."Accrued Interest";
                        Linenum := Linenum + 1000;
                        Linenum := PerformPostOnUpfrontInt(DocumentNo, DocumentNo,
                        PostingDate, Dim1, Dim2, Jtemplate, JBatch, AccruedInt,
                        RecRef."Account No.", Linenum, RecRef."Product Type", RecRef."Charge Interest on Posting")
                    end
            end;

            case RecRef."Charge Interest on Posting" of
                RecRef."Charge Interest on Posting"::"Full Interest":
                    begin

                        case RecRef."Interest Calculation Method" of
                            RecRef."Interest Calculation Method"::"Straight Line":
                                begin
                                    if RecRef."Deposits Appraisal Parameter" = RecRef."Deposits Appraisal Parameter"::Dividends then
                                        AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 100), 0.01, '>') else
                                        AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                                end else begin
                                if RecRef."Deposits Appraisal Parameter" = RecRef."Deposits Appraisal Parameter"::Dividends then
                                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 100), 0.01, '>') else
                                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                            end;
                        end;
                        Linenum := Linenum + 1000;
                        Linenum := PerformPostOnUpfrontInt(DocumentNo, DocumentNo,
                        PostingDate, Dim1, Dim2, Jtemplate, JBatch, AccruedInt,
                        RecRef."Account No.", Linenum, RecRef."Product Type", RecRef."Charge Interest on Posting");

                        AccBanking.Get(RecRef."Disbursement Account No.");
                        Linenum := Linenum + 1000;
                        GenJournal.Init();
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                        GenJournal."External Document No." := RecRef."Account No.";
                        GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                        GenJournal."Document No." := DocumentNo;
                        GenJournal.Validate(Amount, AccruedInt);
                        GenJournal.Description := CopyStr('Interest Paid on-' + DocumentNo, 1, 50);
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);

                        Linenum := Linenum + 1000;
                        GenJournal.Init();
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                        GenJournal."External Document No." := RecRef."Account No.";
                        GenJournal.Validate("Account No.", RecRef."Loan Account");
                        GenJournal."Document No." := DocumentNo;
                        GenJournal.Validate(Amount, AccruedInt * -1);
                        GenJournal.Description := CopyStr('Interest Paid On-' + DocumentNo, 1, 50);
                        GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Paid";
                        GenJournal.Validate("Loan No.", RecRef."No.");
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);

                    end
            end;

            if RecRef."Deposit Purchase" > 0 then begin
                if RecRef."Account Dimension" = RecRef."Account Dimension"::" " then begin
                    if Applic.Get(RecRef."Application No.") then begin
                        RecRef."Account Dimension" := Applic."Account Dimension";
                        RecRef.Modify(true)
                    end
                end;

                Linenum := Linenum + 1000;
                InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                GenJournal."Document No." := DocumentNo;
                GenJournal."Line No." := Linenum;
                GenJournal."Journal Template Name" := Jtemplate;
                GenJournal."Journal Batch Name" := JBatch;
                GenJournal."Posting Date" := PostingDate;
                GenJournal."Document No." := DocumentNo;
                GenJournal.Validate(Amount, RecRef."Deposit Purchase");
                GenJournal.Description := CopyStr(Text002Description + DocumentNo, 1, 50);
                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                if GenJournal.Amount <> 0 then
                    GenJournal.Insert(true);

                case RecRef."Account Dimension" of
                    RecRef."Account Dimension"::"Micro Credit",
                    RecRef."Account Dimension"::Credit:
                        begin
                            CredAcc.Get(RecRef."Deposit Purchase Account");
                            Linenum := Linenum + 1000;
                            InitPost.InitCreditEntry(CredAcc, GenJournal, 0);
                            GenJournal."Document No." := DocumentNo;
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := DocumentNo;
                            GenJournal.Validate(Amount, RecRef."Deposit Purchase" * -1);
                            GenJournal.Description := CopyStr(Text002Description + DocumentNo, 1, 50);
                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournal.Amount <> 0 then
                                GenJournal.Insert(true);

                        end;
                    RecRef."Account Dimension"::Banking:
                        begin
                            if FosaAc.Get(RecRef."Deposit Purchase Account") then begin
                                Linenum := Linenum + 1000;
                                InitPost.InitializeCreditEntry(FosaAc, GenJournal, 0);
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal.Validate(Amount, RecRef."Deposit Purchase" * -1);
                                GenJournal.Description := CopyStr(Text002Description + DocumentNo, 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                            end;
                        end;
                end;
            end;
            RecRef.CalcFields("Total TopUp");

            if RecRef."Total TopUp" > 0 then begin
                ChargeAmt[2] := 0;

                LoansTopupPosted.Reset;
                LoansTopupPosted.SetRange("Loan No.", RecRef."No.");
                LoansTopupPosted.SetRange("Account No.", RecRef."Account No.");
                if LoansTopupPosted.Find('-') then begin
                    repeat
                        ChargeAmt[2] := 0;

                        PLoan.Reset();
                        PLoan.SetRange("No.", LoansTopupPosted."Loan Top Up");
                        if PLoan.FindFirst() then begin
                            PLoan.CalcFields("Outstanding Principal", "Outstanding Bill",
                                  "Outstanding Interest", "Outstanding Insurance", "Outstanding Balance");
                            OutInterest := 0;

                            EndDate := Today;
                            StartDate := CalcDate('-CM', Today);
                            IntDays := (EndDate - StartDate) + 1;
                            // LoansTopupPosted."Untransfered Interest" := PeriodAct.fnIntEntriesonSpecificLoan(PLoan, Today, PLoan."No.", 1, IntDays, StartDate);
                            LoansTopupPosted."Outstanding Bill" := PLoan."Outstanding Bill";
                            LoansTopupPosted."Total Amount" := (LoansTopupPosted."Untransfered Interest" + PLoan."Outstanding Balance");
                            ChargeAmt[2] := PLoan."Outstanding Balance" + LoansTopupPosted."Settlement Fee" + PLoan."Outstanding Interest";
                            //  PeriodAct.fnIntEntriesonSpecificLoan(PLoan,Today, PLoan."No.", 1, IntDays, StartDate);
                            LoansTopupPosted.Modify(true);
                        end;

                        if RecRef.Get(LoansTopupPosted."Loan Top Up") then begin
                            RecRef.CalcFields("Outstanding Principal", "Outstanding Bill",
                                  "Outstanding Interest", "Outstanding Insurance");

                            if LoansTopupPosted."Untransfered Interest" > 0 then begin

                                PLoan.Reset();
                                PLoan.SetRange("No.", LoansTopupPosted."Loan Top Up");
                                if PLoan.FindFirst() then begin
                                    PLoan.CalcFields("Outstanding Principal", "Outstanding Bill",
                                          "Outstanding Interest", "Outstanding Insurance");

                                    if PFact.Get(PLoan."Product Type") then begin
                                        PFact.TestField("Interest Account (G/L)");
                                    end;

                                    Linenum := Linenum + 1000;
                                    GenJournal.Init();
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := PostingDate;
                                    GenJournal."Document No." := DocumentNo;
                                    GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                                    GenJournal.Validate("Account No.", PLoan."Loan Account");
                                    // GenJournal.Validate(Amount, LoansTopupPosted."Untransfered Interest");
                                    GenJournal.Validate(Amount, PLoan."Outstanding Interest");
                                    GenJournal.Description := CopyStr('Accrued Interest-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                    GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Due";
                                    GenJournal.Validate("Loan No.", LoansTopupPosted."Loan Top Up");
                                    GenJournal.Validate("Bal. Account No.", PFact."Interest Account (G/L)");
                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);
                                end;
                            end;
                            if (RecRef."Outstanding Interest") > 0 then begin

                                Linenum := Linenum + 1000;

                                GenJournal.Init();
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal.Validate("Account No.", AccBanking."No.");

                                GenJournal.Validate(Amount, (RecRef."Outstanding Interest"));
                                GenJournal.Description := CopyStr('Interest Paid-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                                'Interest Paid-' + LoansTopupPosted."Loan Top Up",
                                (RecRef."Outstanding Interest") * -1,
                                RecRef."Loan Account", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                RecRef."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Interest Paid",
                                LoansTopupPosted."Loan Top Up", RecRef."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                                RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                            end;

                            if RecRef."Outstanding Insurance" > 0 then begin

                                Linenum := Linenum + 1000;

                                GenJournal.Init();
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal.Validate("Account No.", AccBanking."No.");

                                GenJournal.Validate(Amount, RecRef."Outstanding Insurance");
                                GenJournal.Description := CopyStr('Insurance Paid-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);


                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch,
                                Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                DocumentNo, 'Insurance Paid' + LoansTopupPosted."Loan Top Up",
                                RecRef."Outstanding Insurance" * -1, RecRef."Loan Account", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                RecRef."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Insurance Paid",
                                LoansTopupPosted."Loan Top Up", RecRef."Group Code", '',
                                Enum::"Gen. Journal Document Type"::" ", RecRef."Currency Code",
                                Enum::"Gen. Journal Document Type"::" ");
                            end;

                            if RecRef."Outstanding Bill" > 0 then begin

                                Linenum := Linenum + 1000;
                                GenJournal.Init();
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal.Validate("Account No.", AccBanking."No.");

                                GenJournal.Validate(Amount, RecRef."Outstanding Bill");
                                GenJournal.Description := CopyStr('Bill Paid-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch,
                                Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                DocumentNo, 'Bills Paid' + LoansTopupPosted."Loan Top Up",
                                RecRef."Outstanding Bill" * -1, RecRef."Loan Account", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                RecRef."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Penalty Paid",
                                LoansTopupPosted."Loan Top Up", RecRef."Group Code", '',
                                Enum::"Gen. Journal Document Type"::" ", RecRef."Currency Code",
                                Enum::"Gen. Journal Document Type"::" ");
                            end;

                            if RecRef."Outstanding Principal" > 0 then begin

                                Linenum := Linenum + 1000;
                                GenJournal.Init();
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal.Validate("Account No.", AccBanking."No.");

                                GenJournal.Validate(Amount, RecRef."Outstanding Principal");
                                GenJournal.Description := CopyStr('Bill Paid-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch,
                                Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                DocumentNo, 'Principal Paid-' + LoansTopupPosted."Loan Top Up",
                                RecRef."Outstanding Principal" * -1, RecRef."Loan Account", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                RecRef."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::Repayment,
                                LoansTopupPosted."Loan Top Up", RecRef."Group Code", '',
                                Enum::"Gen. Journal Document Type"::" ", RecRef."Currency Code",
                                Enum::"Gen. Journal Document Type"::" ");

                            end;
                            ChargeAmt[1] := 0;

                            LoanProdCharges.Reset();
                            LoanProdCharges.SetRange("Product Code", LoansTopupPosted."Product Type");
                            LoanProdCharges.SetFilter("Charge Type", '%1', LoanProdCharges."Charge Type"::"Top up");
                            if LoanProdCharges.FindSet() then begin
                                LoanProdCharges.TestField("Charges Account");
                                RecRef.CalcFields("Total TopUp");

                                Linenum := Linenum + 1;
                                GenJournal.Init();
                                GenJournal."Line No." := Linenum;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                GenJournal.Validate("Account No.", AccBanking."No.");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal.Description := CopyStr(LoanProdCharges."Charge Description" + '-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal."External Document No." := RecRef."Account No.";
                                if LoanProdCharges."Staggered Charge Code" = '' then begin
                                    if LoanProdCharges."Use Percentage" then begin
                                        LoanProdCharges.TestField(Percentage);
                                        if ((LoanProdCharges.Percentage / 100) * ChargeAmt[2]) < LoanProdCharges.Minimum then begin
                                            GenJournal.Validate(Amount, (LoanProdCharges.Minimum));
                                        end else begin
                                            GenJournal.Validate(Amount, ((LoanProdCharges.Percentage / 100) * ChargeAmt[2]));
                                        end;
                                    end else begin
                                        GenJournal.Validate(Amount, LoanProdCharges."Charge Amount");
                                    end;
                                end else begin

                                    TieredChargeLine.Reset();
                                    TieredChargeLine.SetRange(Code, LoanProdCharges."Staggered Charge Code");
                                    if TieredChargeLine.FindSet() then begin
                                        repeat
                                            if (ChargeAmt[2] >= TieredChargeLine."Lower Limit") and (ChargeAmt[2] <= TieredChargeLine."Upper Limit") then begin
                                                if TieredChargeLine."Use Percentage" then
                                                    GenJournal.Validate(Amount, Round(ChargeAmt[2] * (TieredChargeLine.Percentage / 100), 0.05, '>')) else
                                                    GenJournal.Validate(Amount, TieredChargeLine."Charge Amount");
                                            end;
                                        until TieredChargeLine.Next() = 0;
                                    end;
                                end;
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);

                                ChargeAmt[1] := GenJournal.Amount;

                                Linenum := Linenum + 1;
                                GenJournal.Init();
                                GenJournal."Line No." := Linenum;
                                GenJournal."Document No." := DocumentNo;
                                GenJournal."Account Type" := LoanProdCharges."Account Type";
                                GenJournal.Validate("Account No.", LoanProdCharges."Charges Account");
                                GenJournal."Line No." := Linenum;
                                GenJournal."Journal Template Name" := Jtemplate;
                                GenJournal."Journal Batch Name" := JBatch;
                                GenJournal."Posting Date" := PostingDate;
                                GenJournal.Description := CopyStr(LoanProdCharges."Charge Description" + '-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal."External Document No." := RecRef."Account No.";

                                if LoanProdCharges."Staggered Charge Code" = '' then begin
                                    if LoanProdCharges."Use Percentage" then begin
                                        LoanProdCharges.TestField(Percentage);
                                        if ((LoanProdCharges.Percentage / 100) * ChargeAmt[2]) < LoanProdCharges.Minimum then begin
                                            GenJournal.Validate(Amount, LoanProdCharges.Minimum);
                                        end else begin
                                            GenJournal.Validate(Amount, ((LoanProdCharges.Percentage / 100) * ChargeAmt[2]) * -1);
                                        end;
                                    end else begin
                                        GenJournal.Validate(Amount, LoanProdCharges."Charge Amount" * -1);
                                    end;
                                end else begin

                                    TieredChargeLine.Reset();
                                    TieredChargeLine.SetRange(Code, LoanProdCharges."Staggered Charge Code");
                                    if TieredChargeLine.FindSet() then begin
                                        repeat
                                            if (ChargeAmt[2] >= TieredChargeLine."Lower Limit") and (ChargeAmt[2] <= TieredChargeLine."Upper Limit") then begin
                                                if TieredChargeLine."Use Percentage" then
                                                    GenJournal.Validate(Amount, ChargeAmt[2] * (TieredChargeLine.Percentage / 100) * -1) else
                                                    GenJournal.Validate(Amount, TieredChargeLine."Charge Amount" * -1);
                                            end;
                                        until TieredChargeLine.Next() = 0;
                                    end;
                                end;
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);


                                case LoanProdCharges."Effect Excise Duty" of
                                    LoanProdCharges."Effect Excise Duty"::Yes:
                                        begin

                                            Linenum := Linenum + 10;
                                            GenJournal.Init();
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                            GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Journal Template Name" := Jtemplate;
                                            GenJournal."Journal Batch Name" := JBatch;
                                            GenJournal."Posting Date" := PostingDate;
                                            GenJournal."Document No." := DocumentNo;
                                            GenJournal."External Document No." := RecRef."Account No.";
                                            GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                            GenJournal."External Document No." := RecRef."Account No.";
                                            GenJournal.Validate(Amount, Round(((GeneralSetUp."Excise Duty (%)" / 100) * ChargeAmt[1]), 1, '='));
                                            GenJournal.Description := CopyStr(TextE0009 + LoanProdCharges."Charge Description", 1, 50);
                                            GenJournal.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                        end;
                                end;

                                if LoansTopupPosted."Settlement Fee" > 0 then begin

                                    Linenum := Linenum + 10;
                                    GenJournal.Init();
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := PostingDate;
                                    GenJournal."Document No." := DocumentNo;
                                    GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                    GenJournal.Validate("Account No.", AccBanking."No.");
                                    GenJournal.Validate(Amount, LoansTopupPosted."Settlement Fee");
                                    GenJournal.Description := CopyStr('Accrued Settlement Fee Cleared-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                    GenJournal.Validate("Bal. Account No.", LoanProdCharges."Charges Account");
                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);

                                    Mcontribution.Reset();
                                    Mcontribution.SetRange(Type, Mcontribution.Type::Other);
                                    Mcontribution.SetRange("Account No.", RecRef."Account No.");
                                    if Mcontribution.Find('-') then begin
                                        Mcontribution."Amount Off" := Mcontribution.Amount;
                                        Mcontribution.Amount := 0;
                                        Mcontribution."Advise Type" := Mcontribution."Advise Type"::Stoppage;
                                        Mcontribution.Remarks := 'Loan Cleared by Topup';
                                        Mcontribution.Modify(true)
                                    end;
                                end;

                            end;

                            Mcontribution.Reset();
                            Mcontribution.SetRange(Type, Mcontribution.Type::" ");
                            Mcontribution.SetRange("Account No.", RecRef."Account No.");
                            Mcontribution.SetRange("Application No.", LoansTopupPosted."Loan Top Up");
                            if Mcontribution.Find('-') then begin
                                Mcontribution."Amount Off" := Mcontribution.Amount;
                                Mcontribution.Amount := 0;
                                Mcontribution."Advise Type" := Mcontribution."Advise Type"::Stoppage;
                                Mcontribution.Remarks := 'Loan Cleared by Topup';
                                Mcontribution.Modify(true)
                            end;

                            if LoansTopupPosted."Settlement Fee" > 0 then begin

                                Mcontribution.Reset();
                                Mcontribution.SetRange(Type, Mcontribution.Type::Other);
                                Mcontribution.SetRange("Account No.", RecRef."Account No.");
                                if Mcontribution.Find('-') then begin
                                    Mcontribution."Amount Off" := Mcontribution.Amount;
                                    Mcontribution.Amount := 0;
                                    Mcontribution."Advise Type" := Mcontribution."Advise Type"::Stoppage;
                                    Mcontribution.Remarks := 'Loan Cleared by Topup';
                                    Mcontribution.Modify(true)
                                end;
                            end;
                        end
                    until LoansTopupPosted.Next = 0;
                end;
            end;

            if CheckLine then begin

                Post.CompletePosting(Jtemplate, JBatch);

                CrmApplic.Reset();
                CrmApplic.SetRange("No.", RecRef."CRM Application No.");
                if CrmApplic.FindFirst() then begin
                    CrmApplic.Created := true;
                    CrmApplic."Approval Status" := CrmApplic."Approval Status"::Posted;
                    CrmApplic.Modify(true);
                end;

                PostedLoan.Reset();
                PostedLoan.SetRange("No.", RecRef."No.");
                if PostedLoan.FindFirst() then begin
                    Commit();
                    PostedLoan."Posted By" := UserId;
                    PostedLoan."Date Posted" := Today;
                    PostedLoan."Time Posted" := Time;
                    PostedLoan.Validate("Disbursement Date", Today);
                    PostedLoan."Interest Posting Date" := Today;
                    PostedLoan."Loan Status" := PostedLoan."Loan Status"::Issued;
                    PostedLoan."Approval Status" := PostedLoan."Approval Status"::Posted;
                    PostedLoan.Modify(true);
                    CredMgt.ValuePost(RecRef."No.", 0);

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
                  'Dear member, Your Loan Application of E ' + Format(RecRef."Approved Amount") + ' repayable in ' + format(RecRef.Installments) + ' at ' + Format(RecRef."Interest Rate") + ' P.A has been issued. Thank You', Member."No.",
                     Member."No.", false);
                    end;

                    if AccBanking.Get(RecRef."Disbursement Account No.") then begin
                        AccBanking.CalcFields("Balance (LCY)");
                        BankMngt.PostLien(AccBanking, AccBanking."Balance (LCY)",
                                   PostedLoan."Product Description", 1, PostedLoan."No.");
                    end;

                    InterestLineEntry.Reset();
                    InterestLineEntry.SetRange(No, PostedLoan."Application No.");
                    InterestLineEntry.ModifyAll(Posted, true);

                    case RecRef."Mode of Disbursement" of
                        RecRef."Mode of Disbursement"::"Partial Disbursement":
                            begin
                                PartialDisb.Reset();
                                PartialDisb.SetRange("Loan No.", RecRef."Application No.");
                                PartialDisb.SetRange("Suggested for Disbursement", true);
                                if PartialDisb.FindSet() then
                                    PartialDisb.ModifyAll(Posted, true);
                            end;
                    end;
                end;
            end else begin

                GenJournal.Reset();
                GenJournal.SetRange("Journal Template Name", Jtemplate);
                GenJournal.SetRange("Journal Batch Name", JBatch);
                if GenJournal.Find('-') then begin
                    Page.Run(Page::"Journal Test Batch", GenJournal, GenJournal."Journal Template Name");
                end;
            end;
        end;
    end;

    procedure CodePostPartialDisb(LoanNo: Code[100]; CheckLine: Boolean; PostingDate: Date; DocumentNo: Code[100]; ValuePost: Integer)
    var

        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: array[3] of Decimal;
        RecRef: Record Loans;
        PostedLoan: Record Loans;
        VarVariant: Variant;
        CustRecord: Record Customer;
        CreditAccounts: Record "Credit Account";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        RegMngt: Codeunit "Register Management";
        CustomerAccType: Enum CustAccountType;
        AccDimension: Enum AccountDimension;
        ProdCategory: Enum ProductAccountCategory;
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
        GenLines: Record "Gen. Journal Line";
        LoanChrg: Record "Loan Charges";
        LoanProdCharges: Record "Loan Product Charges";
        Registry: Codeunit "Registry Mngt.";
        MonthCont: Record "Member Monthly Contribution";
        AccruedInt: Decimal;
        AmountToDisburse: Decimal;
        PartialDisb: Record "Partial Disbursement Schedule";
        CrmApplic: Record "CRM Application";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        Mcontribution: Record "Member Monthly Contribution";
        Text016: Label 'You cannot Post %1-%2 because there is at least one posted entry related to this transaction.';
        LnPostCharges: Record "Loan Charge Posted";
        Applic: Record "Loan Application";
        LnAppCharges: Record "Loan Product Charges";
        PostedCharges: Record "Loan Charge Posted";
        TotalAmtPost: Decimal;
        ErrorOnEntryNotFound: Label 'No Entries found related to this partial disbursement';
        ErrorOnNullPartialDisbLine: Label 'No Partial Disbursement Lines suggested for posting';
        ErrorOnPartialAmt: Label 'Total Partial amount of %1 cannot be more than Approved amount of %2';
        ErrorOnMissingCharges: Label 'Topup Charges details missing on this application which attracts topup charges.';
        LoanApp: Record "Loan Application";
        TotalTopUp: Decimal;

    begin
        TotalTopUp := 0;

        RecRef.Reset();
        RecRef.SetRange("No.", LoanNo);
        if RecRef.FindFirst() then begin

            RecRef.CalcFields("Amount to Post", "Total TopUp", "Total Amount Disbursed");

            if LoanApp.Get(RecRef."Application No.") then
                LoanApp.CalcFields("Outstanding Total TopUp");
            TotalTopUp := LoanApp."Outstanding Total TopUp";

            RecRef.TestField("Mode of Disbursement", RecRef."Mode of Disbursement"::"Partial Disbursement");

            PassDocumentNo;
            AmountToDisburse := 0;
            TotalAmtPost := 0;

            PartialDisb.Reset();
            PartialDisb.SetRange("Loan No.", RecRef."No.");
            PartialDisb.SetRange("Approval Status", PartialDisb."Approval Status"::Approved);
            if PartialDisb.FindFirst() then begin
                PartialDisb.CalcSums(Amount);
                TotalAmtPost := PartialDisb.Amount
            end;

            if RecRef."Approved Amount" < TotalAmtPost then
                Error(ErrorOnPartialAmt, TotalAmtPost, RecRef."Approved Amount");

            if RecRef."Approved Amount" < RecRef."Total Amount Disbursed" then
                Error(ErrorOnPartialAmt, RecRef."Total Amount Disbursed", RecRef."Approved Amount");

            Applic.Reset();
            Applic.SetRange("No.", RecRef."Application No.");
            if Applic.FindFirst() then begin
                Applic.CalcFields("Total TopUp");
                if Applic."Total TopUp" > 0 then begin
                    RecRef.CalcFields("Total TopUp");
                    LnPostCharges.Reset();
                    LnPostCharges.SetRange("Loan No.", RecRef."No.");
                    if not LnPostCharges.FindFirst() then begin
                        Error(ErrorOnMissingCharges);
                    end;
                end;
            end;

            CustRecord.Reset();
            CustRecord.SetRange("No.", RecRef."Loan Account");
            CustRecord.SetRange("Account Dimension", CustRecord."Account Dimension"::Repayment);
            if not CustRecord.Find('-') then begin
                CreditAccounts.Reset();
                CreditAccounts.SetRange("No.", RecRef."Loan Account");
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
                        AccDimension::Repayment, ProdCategory::" "
                    );
                end;
            end;

            LoanChargePosted.Reset;
            LoanChargePosted.SetRange("Loan No.", RecRef."No.");
            LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
            if not LoanChargePosted.Find('-') then begin

                LnAppCharges.Reset();
                LnAppCharges.SetRange("Product Code", RecRef."Product Type");
                LnAppCharges.SetRange("Charge Type", LnAppCharges."Charge Type"::General);
                if LnAppCharges.FindSet() then begin
                    repeat

                        PostedCharges.Init();
                        PostedCharges."Charge Code" := LnAppCharges."Charge Code";
                        PostedCharges."Account Type" := LnAppCharges."Account Type";
                        PostedCharges."Account No." := LnAppCharges."Charges Account";
                        PostedCharges."Charge Amount" := LnAppCharges."Charge Amount";
                        PostedCharges."Charge Type" := LnAppCharges."Charge Type";
                        PostedCharges."Use Percentage" := LnAppCharges."Use Percentage";
                        PostedCharges.Percentage := LnAppCharges.Percentage;
                        PostedCharges."Loan No." := RecRef."No.";
                        PostedCharges."Application No." := RecRef."Application No.";
                        PostedCharges."Charge Description" := LnAppCharges."Charge Description";
                        PostedCharges.Insert(true);

                    until LnAppCharges.Next() = 0;
                end;
            end;

            Amt[1] := 0;
            Amt[2] := 0;

            case ValuePost of
                0:
                    begin

                        RecRef.TestField("Loan Status", RecRef."Loan Status"::"Partial Payment");
                        if not TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 3) then begin

                            PartialDisb.Reset();
                            PartialDisb.SetRange(Posted, false);
                            PartialDisb.SetRange("Loan No.", RecRef."No.");
                            PartialDisb.SetRange("Suggested for Disbursement", true);
                            PartialDisb.SetRange("Approval Status", PartialDisb."Approval Status"::Approved);
                            if PartialDisb.FindFirst() then begin

                                AmountToDisburse := PartialDisb.Amount;
                                GenJournal.LockTable;

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                                Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                                                CopyStr(TextDescription + DocumentNo, 1, 50), AmountToDisburse,
                                                RecRef."Loan Account", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                                '', PartialDisb."Entry No", Dim1, Dim2, Enum::"LoanTransactionType"::Loan, DocumentNo,
                                                RecRef."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                                                RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                                AccBanking.Get(RecRef."Disbursement Account No.");

                                Linenum := Linenum + 1000;
                                Post.PostJournal(Jtemplate, JBatch, Linenum,
                                                Enum::"Gen. Journal Account Type"::Vendor, DocumentNo,
                                                CopyStr(TextDescription + DocumentNo, 1, 50), AmountToDisburse * -1,
                                                RecRef."Disbursement Account No.", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                                '', PartialDisb."Entry No", Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                                RecRef."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                                                RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");
                            end else begin
                                Error(ErrorOnEntryNotFound);
                            end;
                        end
                    end;
                1:
                    begin
                        RecRef.CalcFields("Total TopUp");

                        if RecRef."Total TopUp" > 0 then begin
                            RecRef.fnTestFields;

                            AmountToDisburse := RecRef."Total TopUp";
                            if CheckLine then begin

                                if TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 0) then begin
                                    Error('Application No. %1 already posted', RecRef."No.");
                                end;
                            end;

                            ChargeAmt[2] := 0;
                            AccBanking.Get(RecRef."Disbursement Account No.");
                            LoanChargePosted.Reset;
                            LoanChargePosted.SetRange("Loan No.", RecRef."No.");
                            LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
                            if LoanChargePosted.Find('-') then begin
                                repeat
                                    LoanChargePosted.TestField("Account No.");
                                    ChargeAmt[1] := 0;
                                    ChargeAmt[2] := 0;

                                    case LoanChargePosted."Charge Type" of
                                        LoanChargePosted."Charge Type"::Boosting:
                                            ChargeAmt[2] := RecRef."Deposit Purchase";
                                        LoanChargePosted."Charge Type"::"Top up":
                                            ChargeAmt[2] := RecRef."Total TopUp";
                                        else
                                            ChargeAmt[2] := RecRef."Approved Amount"
                                    end;

                                    Linenum := Linenum + 1000;
                                    GenJournal.Init();
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := PostingDate;
                                    GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                                    GenJournal."External Document No." := RecRef."Account No.";
                                    GenJournal."Document No." := DocumentNo;
                                    GenJournal.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                                    GenJournal.Validate("Account No.", RecRef."Loan Account");
                                    GenJournal."External Document No." := RecRef."Account No.";
                                    if LoanChargePosted."Staggered Charge Code" = '' then begin
                                        if not LoanChargePosted."Use Percentage" then begin
                                            GenJournal.Validate(Amount, LoanChargePosted."Charge Amount");
                                        end else begin
                                            LoanChargePosted.TestField(Percentage);
                                            if ((LoanChargePosted.Percentage / 100) * ChargeAmt[2]) < LoanChargePosted.Minimum then begin
                                                GenJournal.Validate(Amount, (LoanChargePosted.Minimum));
                                            end else begin
                                                GenJournal.Validate(Amount, ((LoanChargePosted.Percentage / 100) * ChargeAmt[2]));
                                            end;
                                        end;

                                    end else begin

                                        TransType.Reset();
                                        TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                                        if TransType.FindFirst() then begin
                                            TieredChargeLine.Reset();
                                            TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                                            if TieredChargeLine.FindSet() then begin
                                                repeat
                                                    if (RecRef."Approved Amount" >= TieredChargeLine."Lower Limit") and (RecRef."Approved Amount" <= TieredChargeLine."Upper Limit") then begin
                                                        GenJournal.Validate(Amount, (RecRef."Approved Amount" * (TieredChargeLine.Percentage / 100)));
                                                    end;
                                                until TieredChargeLine.Next() = 0;
                                            end;
                                        end;
                                    end;

                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);

                                    Linenum := Linenum + 1000;
                                    GenJournal.Init();
                                    GenJournal."Line No." := Linenum;
                                    GenJournal."Journal Template Name" := Jtemplate;
                                    GenJournal."Journal Batch Name" := JBatch;
                                    GenJournal."Posting Date" := PostingDate;
                                    GenJournal."Account Type" := LoanChargePosted."Account Type";
                                    GenJournal."External Document No." := RecRef."Account No.";
                                    GenJournal."Document No." := DocumentNo;
                                    GenJournal.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                                    GenJournal.Validate("Account No.", LoanChargePosted."Account No.");
                                    GenJournal."External Document No." := RecRef."Account No.";

                                    if LoanChargePosted."Staggered Charge Code" = '' then begin
                                        if not LoanChargePosted."Use Percentage" then begin
                                            GenJournal.Validate(Amount, LoanChargePosted."Charge Amount" * -1);
                                        end else begin
                                            LoanChargePosted.TestField(Percentage);
                                            if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                                                GenJournal.Validate(Amount, (LoanChargePosted.Minimum) * -1);
                                            end else begin
                                                GenJournal.Validate(Amount, ((LoanChargePosted.Percentage / 100) * ChargeAmt[2]) * -1);
                                            end;
                                        end;

                                    end else begin

                                        TransType.Reset();
                                        TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                                        if TransType.FindFirst() then begin
                                            TieredChargeLine.Reset();
                                            TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                                            if TieredChargeLine.FindSet() then begin
                                                repeat
                                                    if (RecRef."Approved Amount" >= TieredChargeLine."Lower Limit") and (RecRef."Approved Amount" <= TieredChargeLine."Upper Limit") then begin
                                                        GenJournal.Validate(Amount, Round(RecRef."Approved Amount" * (TieredChargeLine.Percentage / 100), 1, '=') * -1);
                                                    end;
                                                until TieredChargeLine.Next() = 0;
                                            end;
                                        end;
                                    end;
                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJournal.Amount <> 0 then
                                        GenJournal.Insert(true);

                                    ChargeAmt[1] := Abs(GenJournal.Amount);

                                    case LoanChargePosted."Effect Excise Duty" of
                                        LoanChargePosted."Effect Excise Duty"::Yes:
                                            begin
                                                Linenum := Linenum + 1000;
                                                GenJournal."Line No." := Linenum;
                                                GenJournal."Journal Template Name" := Jtemplate;
                                                GenJournal."Journal Batch Name" := JBatch;
                                                GenJournal."Posting Date" := PostingDate;
                                                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                                GenJournal."External Document No." := RecRef."Account No.";
                                                GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                                GenJournal."Document No." := DocumentNo;
                                                GenJournal."External Document No." := RecRef."Account No.";
                                                GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                                GenJournal."External Document No." := RecRef."Account No.";
                                                GenJournal.Validate(Amount, Round(((GeneralSetUp."Excise Duty (%)" / 100) * ChargeAmt[1]), 1, '='));
                                                GenJournal.Description := CopyStr(TextE0009 + LoanChargePosted."Charge Description", 1, 50);
                                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                if GenJournal.Amount <> 0 then
                                                    GenJournal.Insert(true);
                                            end;
                                    end;

                                until LoanChargePosted.Next = 0;
                            end;

                            LoansTopupPosted.Reset;
                            LoansTopupPosted.SetRange("Loan No.", RecRef."No.");
                            LoansTopupPosted.SetRange("Account No.", RecRef."Account No.");
                            if LoansTopupPosted.Find('-') then begin
                                ChargeAmt[2] := LoansTopupPosted."Total Amount";
                                repeat

                                    PLoan.Reset();
                                    PLoan.SetRange("No.", LoansTopupPosted."Loan Top Up");
                                    if PLoan.FindFirst() then begin
                                        PLoan.CalcFields("Outstanding Principal", "Outstanding Bill",
                                              "Outstanding Interest", "Outstanding Insurance", "Outstanding Balance");

                                        EndDate := Today;
                                        StartDate := CalcDate('-CM', Today);
                                        IntDays := (EndDate - StartDate) + 1;
                                        LoansTopupPosted."Untransfered Interest" := PeriodAct.fnIntEntriesonSpecificLoan(PLoan, Today, PLoan."No.", 1, IntDays, StartDate);
                                        LoansTopupPosted."Outstanding Bill" := PLoan."Outstanding Bill";
                                        LoansTopupPosted."Total Amount" := (LoansTopupPosted."Untransfered Interest" + PLoan."Outstanding Balance");
                                        LoansTopupPosted.Modify(true);

                                    end;

                                    PLoan.Reset();
                                    PLoan.SetRange("No.", LoansTopupPosted."Loan Top Up");
                                    if PLoan.FindFirst() then begin
                                        PLoan.CalcFields("Outstanding Principal", "Outstanding Bill",
                                              "Outstanding Interest", "Outstanding Insurance");

                                        if LoansTopupPosted."Untransfered Interest" > 0 then begin

                                            if PFact.Get(PLoan."Product Type") then begin
                                                PFact.TestField("Interest Account (G/L)");
                                            end;

                                            Linenum := Linenum + 1000;

                                            GenJournal.Init();
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Journal Template Name" := Jtemplate;
                                            GenJournal."Journal Batch Name" := JBatch;
                                            GenJournal."Posting Date" := PostingDate;
                                            GenJournal."Document No." := DocumentNo;
                                            GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                                            GenJournal.Validate("Account No.", PLoan."Loan Account");
                                            GenJournal.Validate(Amount, LoansTopupPosted."Untransfered Interest");
                                            GenJournal.Description := CopyStr('Accrued Interest-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                            GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Due";
                                            GenJournal.Validate("Loan No.", LoansTopupPosted."Loan Top Up");
                                            GenJournal.Validate("Bal. Account No.", PFact."Interest Account (G/L)");
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                        end;

                                        if (PLoan."Outstanding Interest" + LoansTopupPosted."Untransfered Interest") > 0 then begin

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                                            Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                                            'Principal Amount-' + LoansTopupPosted."Loan Top Up",
                                            (PLoan."Outstanding Interest" + LoansTopupPosted."Untransfered Interest"),
                                            RecRef."Loan Account", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::Loan,
                                            RecRef."No.", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", RecRef."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                                            Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                                            'Interest Paid-' + LoansTopupPosted."Loan Top Up",
                                            (PLoan."Outstanding Interest" + LoansTopupPosted."Untransfered Interest") * -1,
                                            PLoan."Loan Account", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Interest Paid",
                                            LoansTopupPosted."Loan Top Up", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                                        end;

                                        if PLoan."Outstanding Insurance" > 0 then begin

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch,
                                            Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                            DocumentNo, 'Principal Amount' + LoansTopupPosted."Loan Top Up",
                                            PLoan."Outstanding Insurance", RecRef."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::Loan,
                                            RecRef."No.", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", PLoan."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch,
                                            Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                            DocumentNo, 'Insurance Paid' + LoansTopupPosted."Loan Top Up",
                                            PLoan."Outstanding Insurance" * -1, PLoan."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Insurance Paid",
                                            LoansTopupPosted."Loan Top Up", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", PLoan."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                        end;

                                        if PLoan."Outstanding Bill" > 0 then begin


                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch,
                                            Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                            DocumentNo, 'Principal Amount' + LoansTopupPosted."Loan Top Up",
                                            PLoan."Outstanding Bill", RecRef."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Penalty Paid",
                                            RecRef."No.", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", PLoan."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch,
                                            Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                            DocumentNo, 'Bills Paid' + LoansTopupPosted."Loan Top Up",
                                            PLoan."Outstanding Bill" * -1, PLoan."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::"Penalty Paid",
                                            LoansTopupPosted."Loan Top Up", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", PLoan."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                        end;

                                        if PLoan."Outstanding Principal" > 0 then begin

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch,
                                            Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                            DocumentNo, 'Principal Amount-' + LoansTopupPosted."Loan Top Up",
                                            PLoan."Outstanding Principal", RecRef."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::Loan,
                                            RecRef."No.", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", PLoan."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                            Linenum := Linenum + 1000;
                                            Post.PostJournal(Jtemplate, JBatch,
                                            Linenum, Enum::"Gen. Journal Account Type"::Customer,
                                            DocumentNo, 'Principal Paid-' + LoansTopupPosted."Loan Top Up",
                                            PLoan."Outstanding Principal" * -1, PLoan."Loan Account", PostingDate,
                                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                                            PLoan."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::Repayment,
                                            LoansTopupPosted."Loan Top Up", PLoan."Group Code", '',
                                            Enum::"Gen. Journal Document Type"::" ", PLoan."Currency Code",
                                            Enum::"Gen. Journal Document Type"::" ");

                                        end;

                                        ChargeAmt[1] := 0;

                                        LoanProdCharges.Reset();
                                        LoanProdCharges.SetRange("Product Code", LoansTopupPosted."Product Type");
                                        LoanProdCharges.SetRange("Charge Type", LoanProdCharges."Charge Type"::"Top up");
                                        if LoanProdCharges.FindSet() then begin
                                            LoanProdCharges.TestField("Charges Account");
                                            RecRef.CalcFields("Total TopUp");

                                            Linenum := Linenum + 1;
                                            GenJournal.Init();
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Document No." := DocumentNo;
                                            GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                                            GenJournal.Validate("Account No.", RecRef."Loan Account");
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Journal Template Name" := Jtemplate;
                                            GenJournal."Journal Batch Name" := JBatch;
                                            GenJournal."Posting Date" := PostingDate;
                                            GenJournal.Description := CopyStr(LoanProdCharges."Charge Description" + '-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                            GenJournal."External Document No." := PLoan."Account No.";

                                            if LoanProdCharges."Staggered Charge Code" = '' then begin
                                                if LoanProdCharges."Use Percentage" then begin
                                                    LoanProdCharges.TestField(Percentage);
                                                    if ((LoanProdCharges.Percentage / 100) * LoansTopupPosted."Total Amount") < LoanProdCharges.Minimum then begin
                                                        GenJournal.Validate(Amount, (LoanProdCharges.Minimum));
                                                    end else begin
                                                        GenJournal.Validate(Amount, ((LoanProdCharges.Percentage / 100) * ChargeAmt[2]));
                                                    end;
                                                end else begin
                                                    GenJournal.Validate(Amount, LoanProdCharges."Charge Amount");
                                                end;
                                            end else begin

                                                TieredChargeLine.Reset();
                                                TieredChargeLine.SetRange(Code, LoanProdCharges."Staggered Charge Code");
                                                if TieredChargeLine.FindSet() then begin
                                                    repeat
                                                        if (LoansTopupPosted."Total Amount" >= TieredChargeLine."Lower Limit") and (LoansTopupPosted."Total Amount" <= TieredChargeLine."Upper Limit") then begin
                                                            if TieredChargeLine."Use Percentage" then
                                                                GenJournal.Validate(Amount, (LoansTopupPosted."Total Amount" * (TieredChargeLine.Percentage / 100))) else
                                                                GenJournal.Validate(Amount, TieredChargeLine."Charge Amount");
                                                        end;
                                                    until TieredChargeLine.Next() = 0;
                                                end;
                                            end;

                                            GenJournal."Transaction Type" := GenJournal."Transaction Type"::Loan;
                                            GenJournal."Loan No." := RecRef."No.";
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                            ChargeAmt[1] := GenJournal.Amount;

                                            Linenum := Linenum + 1;
                                            GenJournal.Init();
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Document No." := DocumentNo;
                                            GenJournal."Account Type" := LoanProdCharges."Account Type";
                                            GenJournal.Validate("Account No.", LoanProdCharges."Charges Account");
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Journal Template Name" := Jtemplate;
                                            GenJournal."Journal Batch Name" := JBatch;
                                            GenJournal."Posting Date" := PostingDate;
                                            GenJournal.Description := CopyStr(LoanProdCharges."Charge Description" + '-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                            GenJournal.Validate("Account No.", LoanProdCharges."Charges Account");
                                            GenJournal."External Document No." := RecRef."Account No.";

                                            if LoanProdCharges."Staggered Charge Code" = '' then begin
                                                if LoanProdCharges."Use Percentage" then begin
                                                    LoanProdCharges.TestField(Percentage);
                                                    if ((LoanProdCharges.Percentage / 100) * LoansTopupPosted."Total Amount") < LoanProdCharges.Minimum then begin
                                                        GenJournal.Validate(Amount, (LoanProdCharges.Minimum) * -1);
                                                    end else begin
                                                        GenJournal.Validate(Amount, ((LoanProdCharges.Percentage / 100) * ChargeAmt[2]) * -1);
                                                    end;
                                                end else begin
                                                    GenJournal.Validate(Amount, LoanProdCharges."Charge Amount" * -1);
                                                end;
                                            end else begin

                                                TieredChargeLine.Reset();
                                                TieredChargeLine.SetRange(Code, LoanProdCharges."Staggered Charge Code");
                                                if TieredChargeLine.FindSet() then begin
                                                    repeat
                                                        if (LoansTopupPosted."Total Amount" >= TieredChargeLine."Lower Limit") and (LoansTopupPosted."Total Amount" <= TieredChargeLine."Upper Limit") then begin
                                                            if TieredChargeLine."Use Percentage" then
                                                                GenJournal.Validate(Amount, Round(LoansTopupPosted."Total Amount" * (TieredChargeLine.Percentage / 100), 0.05, '>') * -1) else
                                                                GenJournal.Validate(Amount, TieredChargeLine."Charge Amount" * -1);
                                                        end;
                                                    until TieredChargeLine.Next() = 0;
                                                end;
                                            end;

                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);

                                            case LoanProdCharges."Effect Excise Duty" of
                                                LoanProdCharges."Effect Excise Duty"::Yes:
                                                    begin

                                                        Linenum := Linenum + 10;
                                                        GenJournal.Init();
                                                        GenJournal."Line No." := Linenum;
                                                        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                                        GenJournal.Validate("Account No.", PLoan."Disbursement Account No.");
                                                        GenJournal."Line No." := Linenum;
                                                        GenJournal."Journal Template Name" := Jtemplate;
                                                        GenJournal."Journal Batch Name" := JBatch;
                                                        GenJournal."Posting Date" := PostingDate;
                                                        GenJournal."Document No." := DocumentNo;
                                                        GenJournal."External Document No." := PLoan."Account No.";
                                                        GenJournal.Validate("Account No.", PLoan."Disbursement Account No.");
                                                        GenJournal."External Document No." := PLoan."Account No.";
                                                        GenJournal.Validate(Amount, Round(((GeneralSetUp."Excise Duty (%)" / 100) * ChargeAmt[1]), 1, '='));
                                                        GenJournal.Description := CopyStr(TextE0009 + LoanProdCharges."Charge Description", 1, 50);
                                                        GenJournal.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                        if GenJournal.Amount <> 0 then
                                                            GenJournal.Insert(true);
                                                    end;
                                            end;
                                        end;

                                        Mcontribution.Reset();
                                        Mcontribution.SetRange(Type, Mcontribution.Type::" ");
                                        Mcontribution.SetRange("Account No.", RecRef."Account No.");
                                        Mcontribution.SetRange("Application No.", LoansTopupPosted."Loan Top Up");
                                        if Mcontribution.Find('-') then begin
                                            Mcontribution."Amount Off" := Mcontribution.Amount;
                                            Mcontribution.Amount := 0;
                                            Mcontribution."Advise Type" := Mcontribution."Advise Type"::Stoppage;
                                            Mcontribution.Remarks := 'Loan Cleared by Topup';
                                            Mcontribution.Modify(true)
                                        end;
                                    end
                                until LoansTopupPosted.Next = 0;
                            end;

                        end else begin
                            RecRef.fnTestFields;

                            if not TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 4) then begin

                                AmountToDisburse := getLoanCharge(RecRef."No.", RecRef."Approved Amount");
                                RecRef.TestField("Total Charges", AmountToDisburse);

                                LoanChargePosted.Reset;
                                LoanChargePosted.SetRange("Loan No.", RecRef."No.");
                                LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
                                if LoanChargePosted.Find('-') then begin
                                    repeat
                                        LoanChargePosted.TestField("Account No.");
                                        ChargeAmt[1] := 0;
                                        ChargeAmt[2] := 0;

                                        case LoanChargePosted."Charge Type" of
                                            LoanChargePosted."Charge Type"::Boosting:
                                                ChargeAmt[2] := RecRef."Deposit Purchase";
                                            LoanChargePosted."Charge Type"::"Top up":
                                                ChargeAmt[2] := RecRef."Total TopUp";
                                            else
                                                ChargeAmt[2] := AmountToDisburse
                                        end;

                                        Linenum := Linenum + 1000;

                                        GenJournal.Init();
                                        GenJournal."Line No." := Linenum;
                                        GenJournal."Journal Template Name" := Jtemplate;
                                        GenJournal."Journal Batch Name" := JBatch;
                                        GenJournal."Posting Date" := PostingDate;
                                        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                        GenJournal."External Document No." := RecRef."Account No.";
                                        GenJournal."Document No." := DocumentNo;
                                        GenJournal.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                                        GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                        GenJournal."External Document No." := RecRef."Account No.";
                                        if LoanChargePosted."Staggered Charge Code" = '' then begin
                                            if not LoanChargePosted."Use Percentage" then begin
                                                GenJournal.Validate(Amount, LoanChargePosted."Charge Amount");
                                            end else begin
                                                LoanChargePosted.TestField(Percentage);
                                                if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                                                    GenJournal.Validate(Amount, (LoanChargePosted.Minimum));
                                                end else begin
                                                    GenJournal.Validate(Amount, ((LoanChargePosted.Percentage / 100) * ChargeAmt[2]));
                                                end;
                                            end;
                                        end else begin

                                            TransType.Reset();
                                            TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                                            if TransType.FindFirst() then begin
                                                TieredChargeLine.Reset();
                                                TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                                                if TieredChargeLine.FindSet() then begin
                                                    repeat
                                                        if (AmountToDisburse >= TieredChargeLine."Lower Limit") and (AmountToDisburse <= TieredChargeLine."Upper Limit") then begin
                                                            GenJournal.Validate(Amount, (AmountToDisburse * (TieredChargeLine.Percentage / 100)));
                                                        end;
                                                    until TieredChargeLine.Next() = 0;
                                                end;
                                            end;
                                        end;

                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                        if GenJournal.Amount <> 0 then
                                            GenJournal.Insert(true);

                                        Linenum := Linenum + 1000;
                                        GenJournal.Init();
                                        GenJournal."Line No." := Linenum;
                                        GenJournal."Journal Template Name" := Jtemplate;
                                        GenJournal."Journal Batch Name" := JBatch;
                                        GenJournal."Posting Date" := PostingDate;
                                        GenJournal."Account Type" := LoanChargePosted."Account Type";
                                        GenJournal."External Document No." := RecRef."Account No.";
                                        GenJournal."Document No." := DocumentNo;
                                        GenJournal.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                                        GenJournal.Validate("Account No.", LoanChargePosted."Account No.");
                                        GenJournal."External Document No." := RecRef."Account No.";

                                        if LoanChargePosted."Staggered Charge Code" = '' then begin
                                            if not LoanChargePosted."Use Percentage" then begin
                                                GenJournal.Validate(Amount, LoanChargePosted."Charge Amount" * -1);
                                            end else begin
                                                LoanChargePosted.TestField(Percentage);
                                                if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                                                    GenJournal.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '=') * -1);
                                                end else begin
                                                    GenJournal.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') * -1);
                                                end;
                                            end;

                                        end else begin

                                            TransType.Reset();
                                            TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                                            if TransType.FindFirst() then begin
                                                TieredChargeLine.Reset();
                                                TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                                                if TieredChargeLine.FindSet() then begin
                                                    repeat
                                                        if (AmountToDisburse >= TieredChargeLine."Lower Limit") and (AmountToDisburse <= TieredChargeLine."Upper Limit") then begin
                                                            GenJournal.Validate(Amount, Round(AmountToDisburse * (TieredChargeLine.Percentage / 100), 1, '=') * -1);
                                                        end;
                                                    until TieredChargeLine.Next() = 0;
                                                end;
                                            end;
                                        end;
                                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                        if GenJournal.Amount <> 0 then
                                            GenJournal.Insert(true);

                                        ChargeAmt[1] := Abs(GenJournal.Amount);

                                        case LoanChargePosted."Effect Excise Duty" of
                                            LoanChargePosted."Effect Excise Duty"::Yes:
                                                begin
                                                    Linenum := Linenum + 1000;
                                                    GenJournal."Line No." := Linenum;
                                                    GenJournal."Journal Template Name" := Jtemplate;
                                                    GenJournal."Journal Batch Name" := JBatch;
                                                    GenJournal."Posting Date" := PostingDate;
                                                    GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                                    GenJournal."External Document No." := RecRef."Account No.";
                                                    GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                                    GenJournal."Document No." := DocumentNo;
                                                    GenJournal."External Document No." := RecRef."Account No.";
                                                    GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                                    GenJournal."External Document No." := RecRef."Account No.";
                                                    GenJournal.Validate(Amount, Round(((GeneralSetUp."Excise Duty (%)" / 100) * ChargeAmt[1]), 1, '='));
                                                    GenJournal.Description := CopyStr(TextE0009 + LoanChargePosted."Charge Description", 1, 50);
                                                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                                    if GenJournal.Amount <> 0 then
                                                        GenJournal.Insert(true);
                                                end
                                        end;

                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                                        Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                                                        CopyStr(TextDescription + DocumentNo, 1, 50), ChargeAmt[1],
                                                        RecRef."Loan Account", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                                        '', PartialDisb."Entry No", Dim1, Dim2, Enum::"LoanTransactionType"::Loan, DocumentNo,
                                                        RecRef."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                                                        RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                                        AccBanking.Get(RecRef."Disbursement Account No.");

                                        Linenum := Linenum + 1000;
                                        Post.PostJournal(Jtemplate, JBatch, Linenum,
                                                        Enum::"Gen. Journal Account Type"::Vendor, DocumentNo,
                                                        CopyStr(TextDescription + DocumentNo, 1, 50), ChargeAmt[1] * -1,
                                                        RecRef."Disbursement Account No.", PostingDate, Enum::"Gen. Journal Account Type"::"G/L Account",
                                                        '', PartialDisb."Entry No", Dim1, Dim2, Enum::"LoanTransactionType"::" ", '',
                                                        RecRef."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                                                        RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                                    until LoanChargePosted.Next = 0;
                                end;
                            end;

                        end;

                    end;
            end;

            AccruedInt := 0;
            Linenum := Linenum + 1000;

            RecRef.CalcFields("Accrued Interest");

            case RecRef."Charge Interest on Posting" of
                RecRef."Charge Interest on Posting"::"Pro-rate":
                    begin
                        if LnApplic.Get(RecRef."Application No.") then
                            LnApplic.CalcFields("Accrued Interest");
                        AccruedInt := LnApplic."Accrued Interest";
                        Linenum := Linenum + 1000;
                        Linenum := PerformPostOnUpfrontInt(DocumentNo, DocumentNo,
                        PostingDate, Dim1, Dim2, Jtemplate, JBatch, AccruedInt,
                        RecRef."Account No.", Linenum, RecRef."Product Type", RecRef."Charge Interest on Posting")
                    end
            end;

            case RecRef."Charge Interest on Posting" of
                RecRef."Charge Interest on Posting"::"Full Interest":
                    begin

                        case RecRef."Interest Calculation Method" of
                            RecRef."Interest Calculation Method"::"Straight Line":
                                begin
                                    if RecRef."Deposits Appraisal Parameter" = RecRef."Deposits Appraisal Parameter"::Dividends then
                                        AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 100), 0.01, '>') else
                                        AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                                end else begin
                                if RecRef."Deposits Appraisal Parameter" = RecRef."Deposits Appraisal Parameter"::Dividends then
                                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 100), 0.01, '>') else
                                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                            end;
                        end;
                        Linenum := Linenum + 1000;
                        Linenum := PerformPostOnUpfrontInt(DocumentNo, DocumentNo,
                        PostingDate, Dim1, Dim2, Jtemplate, JBatch, AccruedInt,
                        RecRef."Account No.", Linenum, RecRef."Product Type", RecRef."Charge Interest on Posting");

                        AccBanking.Get(RecRef."Disbursement Account No.");
                        Linenum := Linenum + 1000;
                        GenJournal.Init();
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                        GenJournal."External Document No." := RecRef."Account No.";
                        GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                        GenJournal."Document No." := DocumentNo;
                        GenJournal.Validate(Amount, AccruedInt);
                        GenJournal.Description := CopyStr('Interest Paid on-' + DocumentNo, 1, 50);
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);

                        Linenum := Linenum + 1000;
                        GenJournal.Init();
                        GenJournal."Line No." := Linenum;
                        GenJournal."Journal Template Name" := Jtemplate;
                        GenJournal."Journal Batch Name" := JBatch;
                        GenJournal."Posting Date" := PostingDate;
                        GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                        GenJournal."External Document No." := RecRef."Account No.";
                        GenJournal.Validate("Account No.", RecRef."Loan Account");
                        GenJournal."Document No." := DocumentNo;
                        GenJournal.Validate(Amount, AccruedInt * -1);
                        GenJournal.Description := CopyStr('Interest Paid On-' + DocumentNo, 1, 50);
                        GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Paid";
                        GenJournal.Validate("Loan No.", RecRef."No.");
                        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournal.Amount <> 0 then
                            GenJournal.Insert(true);
                    end
            end;

            if CheckLine then begin

                Post.CompletePosting(Jtemplate, JBatch);

                CrmApplic.Reset();
                CrmApplic.SetRange("No.", RecRef."CRM Application No.");
                if CrmApplic.FindFirst() then begin
                    CrmApplic.Created := true;
                    CrmApplic."Approval Status" := CrmApplic."Approval Status"::Posted;
                    CrmApplic.Modify(true);
                end;

                PostedLoan.Reset();
                PostedLoan.SetRange("No.", RecRef."No.");
                if PostedLoan.FindFirst() then begin
                    Commit();

                    if RecRef."Total Amount Disbursed" = RecRef."Approved Amount" then begin
                        PostedLoan."Posted By" := UserId;
                        PostedLoan."Date Posted" := Today;
                        PostedLoan."Time Posted" := Time;
                        PostedLoan.Validate("Disbursement Date", Today);
                        PostedLoan."Interest Posting Date" := Today;
                        PostedLoan."Loan Status" := PostedLoan."Loan Status"::Issued;
                        PostedLoan."Approval Status" := PostedLoan."Approval Status"::Posted;
                        PostedLoan.Modify(true);
                        CredMgt.ValuePost(RecRef."No.", 0);
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
                  'Dear member, Your Loan Application of KES ' + Format(RecRef."Approved Amount") + ' repayable in ' + format(RecRef.Installments) + ' at ' + Format(RecRef."Interest Rate") + ' P.A has been issued. Thank You', Member."No.",
                     Member."No.", false);
                    end;

                    if AccBanking.Get(RecRef."Disbursement Account No.") then begin
                        if RecRef."Amount to Post" > 0 then begin
                            AccBanking.CalcFields("Balance (LCY)");
                            if AccBanking."Balance (LCY)" > 0 then
                                BankMngt.PostLien(AccBanking, AccBanking."Balance (LCY)",
                                       PostedLoan."Product Description", 1, PostedLoan."No.");
                        end;

                    end;

                    InterestLineEntry.Reset();
                    InterestLineEntry.SetRange(No, PostedLoan."Application No.");
                    InterestLineEntry.ModifyAll(Posted, true);

                    case RecRef."Mode of Disbursement" of
                        RecRef."Mode of Disbursement"::"Partial Disbursement":
                            begin
                                PartialDisb.Reset();
                                PartialDisb.SetRange(Posted, false);
                                PartialDisb.SetRange("Loan No.", RecRef."No.");
                                PartialDisb.SetRange("Suggested for Disbursement", true);
                                PartialDisb.SetRange("Approval Status", PartialDisb."Approval Status"::Approved);
                                if PartialDisb.FindFirst() then begin
                                    PartialDisb.Posted := true;
                                    PartialDisb."Posted By" := UserId;
                                    PartialDisb."Date Posted" := Today;
                                    PartialDisb."Time Posted" := Time;
                                    PartialDisb."Approval Status" := PartialDisb."Approval Status"::Posted;
                                    PartialDisb.Modify(true);
                                end;
                            end;
                    end;
                end;

                LoanRec.Reset();
                LoanRec.SetRange("No.", RecRef."No.");
                LoanRec.SetRange("Approval Status", LoanRec."Approval Status"::Posted);
                if LoanRec.FindFirst() then begin
                    VarVariant := RecRef;
                    //Notif.SendEmailNotification(VarVariant, 0, RecRef."No.");
                end;
            end else begin
                VarVariant := RecRef;
                DocsMngt.DocPrintstatement(VarVariant, 0);
            end;

        end;
    end;

    local procedure PassDocumentNo()
    begin
        GeneralSetUp.Get;
        Temp.Get(UserId);
        Temp.TestField("Loans Template");
        Temp.TestField("Loans Batch");
        Jtemplate := Temp."Loans Template";
        JBatch := Temp."Loans Batch";

        Post.ClearJournalLines(Jtemplate, JBatch);
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
    end;


    procedure PerformPostOnUpfrontInt(LoanNo: Code[20]; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]; ChargeOption: Enum ChargeInterestDue): Integer
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
        LineNumber: Integer;
    begin
        if Loans.Get(LoanNo) then begin
            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");
            LineNumber := LineNo + 100;
            Post.PostJournal(GnlTemplate, GnlJBatch, LineNumber, Enum::"Gen. Journal Account Type"::Customer,
            DocumentNo, Text00002 + LoanNo, RunBal, Loans."Loan Account", PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", ProductType."Interest Account (G/L)",
            Loans."Account No.", DActivity, DBranch, Enum::"LoanTransactionType"::"Interest Due",
            Loans."No.", Loans."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
            Loans."Currency Code", Enum::"Gen. Journal Document Type"::" ");
            exit(LineNumber)
        end
    end;


    procedure PostDepositPrch(LoanNo: Code[20]; DocumentNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]): Integer
    var
        Loans: Record Loans;
        CredAc: Record "Account Credit";
    begin
        if Loans.Get(LoanNo) then begin
            if Loans."Deposit Purchase" > 0 then begin
                Loans.TestField("Deposit Purchase Account");
                if CredAc.Get(Loans."Deposit Purchase Account") then begin
                    LineNo := LineNo + 1000;
                    Post.PostJournal(GnlTemplate, GnlJBatch, LineNo,
                    Enum::"Gen. Journal Account Type"::Vendor, DocumentNo, Text00002 + LoanNo, RunBal,
                      Loans."Disbursement Account No.", PDate,
                      Enum::"Gen. Journal Account Type"::"G/L Account", '',
                      Loans."Account No.", DActivity, DBranch,
                      Enum::"LoanTransactionType"::" ",
                      Loans."No.", Loans."Group Code",
                    '', Enum::"Gen. Journal Document Type"::" ",
                    Loans."Currency Code",
                    Enum::"Gen. Journal Document Type"::" ");

                    LineNo := LineNo + 1000;
                    Post.PostJournal(GnlTemplate, GnlJBatch, LineNo,
                    Enum::"Gen. Journal Account Type"::Customer,
                    DocumentNo, Text00002 + LoanNo, RunBal * -1,
                    Loans."Deposit Purchase Account", PDate,
                    Enum::"Gen. Journal Account Type"::"G/L Account", '',
                    Loans."Account No.", DActivity, DBranch,
                    Enum::"LoanTransactionType"::" ",
                    Loans."No.", Loans."Group Code", '',
                    Enum::"Gen. Journal Document Type"::" ",
                    Loans."Currency Code",
                    Enum::"Gen. Journal Document Type"::" ");

                    LineNo := LineNo + 1000;
                    LineNo := fnPostLoanDepositCharges(Loans."No.", GnlTemplate,
                    GnlJBatch, LineNo, PDate,
                    DocumentNo, Loans."Account No.", Loans."Disbursement Account No.",
                    DActivity, DBranch,
                    RunBal, Loans."Account No.");

                end
            end;
            exit(LineNo)
        end;
    end;


    procedure fnPostCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocumentNo: Code[20]; ExtDocumentNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: Decimal;
    begin
        GeneralSetUp.Get;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", LoanNo);
        LoanChargePosted.SetFilter("Charge Type", '<>%1', LoanChargePosted."Charge Type"::Boosting);
        if LoanChargePosted.Find('-') then begin
            repeat
                LoanChargePosted.TestField("Account No.");
                ChargeAmt := 0;
                LineNo := LineNo + 1000;

                JournalLines.Init;
                JournalLines."Journal Template Name" := Gnltemplate;
                JournalLines."Journal Batch Name" := GnlJBatch;
                JournalLines."Line No." := LineNo;
                JournalLines."Posting Date" := PostDate;
                JournalLines."Document No." := DocumentNo;
                JournalLines."External Document No." := ExtDocumentNo;
                JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                JournalLines.Validate(JournalLines."Account No.", AccountNo);
                JournalLines.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
                if not LoanChargePosted."Use Percentage" then begin
                    JournalLines.Validate(Amount, LoanChargePosted."Charge Amount");
                end else begin
                    if Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '=') < LoanChargePosted.Minimum then begin
                        JournalLines.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                    end else begin
                        JournalLines.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '='));
                    end;
                end;
                JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                JournalLines.Validate("Bal. Account No.", LoanChargePosted."Account No.");
                JournalLines."Shortcut Dimension 1 Code" := Dim1;
                JournalLines."Shortcut Dimension 2 Code" := Dim2;
                if JournalLines.Amount <> 0 then
                    JournalLines.Insert(true);
                ChargeAmt := JournalLines.Amount;

                case LoanChargePosted."Effect Excise Duty" of
                    LoanChargePosted."Effect Excise Duty"::Yes:
                        begin
                            GeneralSetUp.TestField("Excise Duty (%)");
                            GeneralSetUp.TestField("Excise Duty G/L");
                            LineNo := LineNo + 1000;
                            JournalLines.Init;
                            JournalLines."Journal Template Name" := Gnltemplate;
                            JournalLines."Journal Batch Name" := GnlJBatch;
                            JournalLines."Line No." := LineNo;
                            JournalLines."Posting Date" := PostDate;
                            JournalLines."Document No." := DocumentNo;
                            JournalLines."External Document No." := ExtDocumentNo;
                            JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                            JournalLines.Validate(JournalLines."Account No.", AccountNo);
                            JournalLines.Description := CopyStr('Excise Duty on-' + LoanChargePosted."Charge Description", 1, 50);
                            JournalLines.Validate(Amount, Round((GeneralSetUp."Excise Duty (%)" / 100) * (ChargeAmt)));
                            JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                            JournalLines.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                            JournalLines."Shortcut Dimension 1 Code" := Dim1;
                            JournalLines."Shortcut Dimension 2 Code" := Dim2;
                            if JournalLines.Amount <> 0 then
                                JournalLines.Insert(true);
                        end;
                end;
            until LoanChargePosted.Next = 0;
            exit(LineNo);
        end;
    end;


    procedure fnPostRefCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocumentNo: Code[20]; ExtDocumentNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: Decimal;
        TransType: Record "Transaction Types";
        TieredChargeLine: Record "Tiered Charges Line";
    begin
        GeneralSetUp.Get;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", LoanNo);
        LoanChargePosted.SetFilter("Charge Type", '%1', LoanChargePosted."Charge Type"::"Top up");
        if LoanChargePosted.Find('-') then begin
            repeat
                LoanChargePosted.TestField("Account No.");
                ChargeAmt := 0;
                LineNo := LineNo + 1000;

                JournalLines.Init;
                JournalLines."Journal Template Name" := Gnltemplate;
                JournalLines."Journal Batch Name" := GnlJBatch;
                JournalLines."Line No." := LineNo;
                JournalLines."Posting Date" := PostDate;
                JournalLines."Document No." := DocumentNo;
                JournalLines."External Document No." := ExtDocumentNo;
                JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                JournalLines.Validate(JournalLines."Account No.", AccountNo);
                JournalLines.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);

                if LoanChargePosted."Staggered Charge Code" = '' then begin
                    if not LoanChargePosted."Use Percentage" then begin
                        JournalLines.Validate(Amount, LoanChargePosted."Charge Amount");
                    end else begin
                        if Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '=') < LoanChargePosted.Minimum then begin
                            JournalLines.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                        end else begin
                            JournalLines.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '='));
                        end;
                    end;
                end else begin

                    TransType.Reset();
                    TransType.SetRange(Code, LoanChargePosted."Staggered Charge Code");
                    if TransType.FindFirst() then begin
                        TieredChargeLine.Reset();
                        TieredChargeLine.SetRange(Code, TransType.Code);
                        if TieredChargeLine.FindSet() then begin
                            repeat
                                if (ApprovedAmt >= TieredChargeLine."Lower Limit") and (ApprovedAmt <= TieredChargeLine."Upper Limit") then begin
                                    JournalLines.Validate(Amount, Round(ApprovedAmt * (TieredChargeLine."Charge Amount" / 100), 1, '='));
                                end;
                            until TieredChargeLine.Next() = 0;
                        end;
                    end;
                end;
                JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                JournalLines.Validate("Bal. Account No.", LoanChargePosted."Account No.");
                JournalLines."Shortcut Dimension 1 Code" := Dim1;
                JournalLines."Shortcut Dimension 2 Code" := Dim2;
                if JournalLines.Amount <> 0 then
                    JournalLines.Insert(true);
                ChargeAmt := JournalLines.Amount;

                case LoanChargePosted."Effect Excise Duty" of
                    LoanChargePosted."Effect Excise Duty"::Yes:
                        begin
                            GeneralSetUp.TestField("Excise Duty (%)");
                            GeneralSetUp.TestField("Excise Duty G/L");
                            LineNo := LineNo + 1000;
                            JournalLines.Init;
                            JournalLines."Journal Template Name" := Gnltemplate;
                            JournalLines."Journal Batch Name" := GnlJBatch;
                            JournalLines."Line No." := LineNo;
                            JournalLines."Posting Date" := PostDate;
                            JournalLines."Document No." := DocumentNo;
                            JournalLines."External Document No." := ExtDocumentNo;
                            JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                            JournalLines.Validate(JournalLines."Account No.", AccountNo);
                            JournalLines.Description := CopyStr('Excise Duty on-' + LoanChargePosted."Charge Description", 1, 50);
                            JournalLines.Validate(Amount, Round((GeneralSetUp."Excise Duty (%)" / 100) * (ChargeAmt)));
                            JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                            JournalLines.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                            JournalLines."Shortcut Dimension 1 Code" := Dim1;
                            JournalLines."Shortcut Dimension 2 Code" := Dim2;
                            if JournalLines.Amount <> 0 then
                                JournalLines.Insert(true);
                        end;
                end;
            until LoanChargePosted.Next = 0;
            exit(LineNo);
        end;
    end;


    procedure fnPostLoanDepositCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocumentNo: Code[20]; ExtDocumentNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: Decimal;
    begin
        GeneralSetUp.Get;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", LoanNo);
        LoanChargePosted.SetFilter("Charge Type", '%1', LoanChargePosted."Charge Type"::Boosting);
        if LoanChargePosted.Find('-') then begin
            LoanChargePosted.TestField("Account No.");
            ChargeAmt := 0;
            LineNo := LineNo + 1000;

            JournalLines.Init;
            JournalLines."Journal Template Name" := Gnltemplate;
            JournalLines."Journal Batch Name" := GnlJBatch;
            JournalLines."Line No." := LineNo;
            JournalLines."Posting Date" := PostDate;
            JournalLines."Document No." := DocumentNo;
            JournalLines."External Document No." := ExtDocumentNo;
            JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
            JournalLines.Validate(JournalLines."Account No.", AccountNo);
            JournalLines.Description := CopyStr(LoanChargePosted."Charge Description", 1, 50);
            if not LoanChargePosted."Use Percentage" then begin
                JournalLines.Validate(Amount, LoanChargePosted."Charge Amount");
            end else begin
                if Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '=') < LoanChargePosted.Minimum then begin
                    JournalLines.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                end else begin
                    JournalLines.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ApprovedAmt), 1, '='));
                end;
            end;
            JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
            JournalLines.Validate("Bal. Account No.", LoanChargePosted."Account No.");
            JournalLines."Shortcut Dimension 1 Code" := Dim1;
            JournalLines."Shortcut Dimension 2 Code" := Dim2;
            if JournalLines.Amount <> 0 then
                JournalLines.Insert(true);
            ChargeAmt := JournalLines.Amount;

            case LoanChargePosted."Effect Excise Duty" of
                LoanChargePosted."Effect Excise Duty"::Yes:
                    begin
                        GeneralSetUp.TestField("Excise Duty (%)");
                        GeneralSetUp.TestField("Excise Duty G/L");

                        LineNo := LineNo + 1000;
                        JournalLines.Init;
                        JournalLines."Journal Template Name" := Gnltemplate;
                        JournalLines."Journal Batch Name" := GnlJBatch;
                        JournalLines."Line No." := LineNo;
                        JournalLines."Posting Date" := PostDate;
                        JournalLines."Document No." := DocumentNo;
                        JournalLines."External Document No." := ExtDocumentNo;
                        JournalLines."Account Type" := JournalLines."Account Type"::Vendor;
                        JournalLines.Validate(JournalLines."Account No.", AccountNo);
                        JournalLines.Description := CopyStr('Excise Duty on-' + LoanChargePosted."Charge Description", 1, 50);
                        JournalLines.Validate(Amount, Round((GeneralSetUp."Excise Duty (%)" / 100) * (ChargeAmt)));
                        JournalLines."Bal. Account Type" := LoanChargePosted."Account Type";
                        JournalLines.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                        JournalLines."Shortcut Dimension 1 Code" := Dim1;
                        JournalLines."Shortcut Dimension 2 Code" := Dim2;
                        if JournalLines.Amount <> 0 then
                            JournalLines.Insert(true);
                    end
            end;
            exit(LineNo)
        end;
    end;


    procedure PostLoanTopup(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocumentNo: Code[20]; ExtDocumentNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
    var
        LoansTopupPosted: Record "Loans Top up Posted";
        RecRef: Record Loans;
        TextTopup: Label 'Loan cleared-';
        GenLines: Record "Gen. Journal Line";
        LoanChargePosted: Record "Loan Charge Posted";
    begin
        LoansTopupPosted.Reset;
        LoansTopupPosted.SetRange("Loan No.", LoanNo);
        LoansTopupPosted.SetRange("Account No.", AccountNo);
        if LoansTopupPosted.Find('-') then begin
            repeat

                if RecRef.Get(LoansTopupPosted."Loan Top Up") then begin
                    RecRef.CalcFields("Outstanding Principal", "Outstanding Bill",
                          "Outstanding Interest", "Outstanding Insurance");

                    if RecRef."Outstanding Interest" > 0 then begin

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch, LineNo,
                        Enum::"Gen. Journal Account Type"::Vendor, DocumentNo,
                        'Interest Cleared on-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Interest",
                        RecRef."Disbursement Account No.", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account",
                        '', RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ", '',
                        RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch, LineNo,
                        Enum::"Gen. Journal Account Type"::Customer, DocumentNo,
                        'Interest Paid-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Interest" * -1,
                        RecRef."Loan Account", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Interest Paid",
                        RecRef."No.", RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");
                    end;

                    if RecRef."Outstanding Bill" > 0 then begin

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Vendor,
                        DocumentNo,
                        'Bills Cleared-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Bill",
                        RecRef."Disbursement Account No.", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ", '',
                        RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DocumentNo,
                        'Bills Paid' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Bill" * -1,
                        RecRef."Loan Account", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::"Penalty Paid",
                        RecRef."No.", RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");
                    end;

                    if RecRef."Outstanding Principal" > 0 then begin
                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Vendor,
                        DocumentNo,
                        'Principal Cleared-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Principal",
                        RecRef."Disbursement Account No.", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::" ",
                        '', RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");

                        GenLines.Reset();
                        GenLines.SetRange("Journal Template Name", Gnltemplate);
                        GenLines.SetRange("Journal Batch Name", GnlJBatch);
                        if GenLines.FindLast() then
                            LineNo := GenLines."Line No." + 1000;

                        Post.PostJournal(Gnltemplate, GnlJBatch,
                        LineNo,
                        Enum::"Gen. Journal Account Type"::Customer,
                        DocumentNo,
                        'Principal Paid-' + LoansTopupPosted."Loan Top Up",
                        RecRef."Outstanding Principal" * -1,
                        RecRef."Loan Account", PostDate,
                        Enum::"Gen. Journal Account Type"::"G/L Account", '',
                        RecRef."Account No.", Dim1, Dim2,
                        Enum::"LoanTransactionType"::Repayment,
                        RecRef."No.", RecRef."Group Code", '',
                        Enum::"Gen. Journal Document Type"::" ",
                        RecRef."Currency Code",
                        Enum::"Gen. Journal Document Type"::" ");
                    end;
                end
            until LoansTopupPosted.Next = 0;
        end
    end;

    procedure ValuePost(RecNo: Code[100]): Boolean
    var
        CreditLedger: Record "Cust. Ledger Entry";
        LoansT: Record Loans;
    begin
        CreditLedger.Reset();
        CreditLedger.SetRange("Loan No.", RecNo);
        CreditLedger.SetRange("Transaction Type", CreditLedger."Transaction Type"::Loan);
        if CreditLedger.FindFirst() then begin
            LoansT.Reset();
            LoansT.SetRange("No.", CreditLedger."Loan No.");
            if LoansT.FindFirst() then begin
                LoansT."Posted By" := CreditLedger."User ID";
                LoansT."Date Posted" := CreditLedger."Posting Date";
                LoansT."Time Posted" := Time;
                LoansT.Validate("Disbursement Date", CreditLedger."Posting Date");
                LoansT."Interest Posting Date" := CreditLedger."Posting Date";
                LoansT."Loan Status" := LoansT."Loan Status"::Issued;
                LoansT."Approval Status" := LoansT."Approval Status"::Posted;
                LoansT.Modify(true);
            end;
        end;
        exit(false)
    end;

    procedure getLoanCharge(RecRefNo: code[100]; AmountToDisburse: Decimal): Decimal
    var
        ChargeAmt: array[2] of Decimal;
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
    begin

        ChargeAmt[1] := 0;
        ChargeAmt[2] := 0;

        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", RecRefNo);
        LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
        if LoanChargePosted.Find('-') then begin
            repeat
                ChargeAmt[2] := 0;
                ChargeAmt[2] := AmountToDisburse;

                if LoanChargePosted."Staggered Charge Code" = '' then begin
                    if not LoanChargePosted."Use Percentage" then begin
                        ChargeAmt[1] := ChargeAmt[1] + LoanChargePosted."Charge Amount";
                    end else begin
                        LoanChargePosted.TestField(Percentage);
                        if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                            ChargeAmt[1] := ChargeAmt[1] + LoanChargePosted.Minimum;
                        end else begin
                            ChargeAmt[1] := ChargeAmt[1] + Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=');
                        end;
                    end;
                end else begin

                    TransType.Reset();
                    TransType.SetRange("Staggered Charge Code", LoanChargePosted."Staggered Charge Code");
                    if TransType.FindFirst() then begin
                        TieredChargeLine.Reset();
                        TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                        if TieredChargeLine.FindSet() then begin
                            repeat
                                if (ChargeAmt[2] >= TieredChargeLine."Lower Limit") and (ChargeAmt[2] <= TieredChargeLine."Upper Limit") then begin
                                    ChargeAmt[1] := ChargeAmt[1] + Round(AmountToDisburse * (TieredChargeLine.Percentage / 100), 1, '=');
                                end;
                            until TieredChargeLine.Next() = 0;
                        end;
                    end;
                end;
            until LoanChargePosted.Next = 0;
            exit(ChargeAmt[1])
        end;
    end;
}



