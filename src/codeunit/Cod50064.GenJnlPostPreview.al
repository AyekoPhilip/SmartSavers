codeunit 50064 "Gen.Jnl.-Post+Preview"
{
    TableNo = Loans;

    trigger OnRun()
    begin
        RunWithCheck(Rec)
    end;

    var
        LoanApplication: Record Loans;
        CredMgt: Codeunit "Credit Mgmt.";
        Temp: Record "Banking User Template";
        InterestLineEntry: Record "Interest Line";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Dim1: Code[10];
        Dim2: Code[10];
        Post: Codeunit "Journal Post Mngt.";
        Linenum: Integer;
        Text00002: Label 'Interest Charged-';
        TextDescription: Label 'Principal amount-';
        Amt: array[7] of Decimal;
        JournalLines: Record "Gen. Journal Line";
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
        Text001Description: Label 'Loan-';
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

    procedure RunWithCheck(var LoanApplic2: Record Loans)
    begin
        LoanApplication.Copy(LoanApplic2);
        Code(LoanApplication, true, Today);
        LoanApplic2 := LoanApplication
    end;

    procedure RunWithoutCheck(var LoanApplic2: Record Loans; PostInt: Boolean)
    begin
        LoanApplication.Copy(LoanApplic2);
        Code(LoanApplication, false, Today);
        LoanApplic2 := LoanApplication
    end;

    procedure "Code"(RecRef: Record Loans; CheckLine: Boolean; PostingDate: Date)
    var
        LoanChargePosted: Record "Loan Charge Posted";
        ChargeAmt: array[3] of Decimal;
        PostedLoan: Record Loans;
        VarVariant: Variant;
        CustRecord: Record Customer;
        CreditAccounts: Record "Credit Account";
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
        Text016: Label 'You cannot Post %1-%2 because there is at least one posted entry related to this transaction.';
        LnPostCharges: Record "Loan Charge Posted";
        Applic: Record "Loan Application";
        ErrorOnMissingCharges: Label 'Topup Charges details missing on this application which attracts topup charges.';

    begin
        RecRef.fnTestFields;
        PassDocumentNo;
        AmountToDisburse := 0;

        if TellMngt.TestNoEntriesExist(RecRef."Account Name", RecRef."No.", 0) then begin
            Error(Text016, RecRef."Account Name", RecRef."No.");
        end;

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
        InitPost.InitializeDebitEntry(RecRef, GenJournal, 0);
        GenJournal."Line No." := Linenum;
        GenJournal."Journal Template Name" := Jtemplate;
        GenJournal."Journal Batch Name" := JBatch;
        GenJournal."Posting Date" := PostingDate;
        GenJournal.Validate(Amount, AmountToDisburse);
        GenJournal.Description := CopyStr(TextDescription + RecRef."No.", 1, 50);
        GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
        GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
        if GenJournal.Amount <> 0 then
            GenJournal.Insert(true);

        if RecRef."Mode of Disbursement" = RecRef."Mode of Disbursement"::"Full Disbursement" then begin
            AccBanking.Get(RecRef."Disbursement Account No.");
            Linenum := Linenum + 1000;
            InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
            GenJournal."Line No." := Linenum;
            GenJournal."Journal Template Name" := Jtemplate;
            GenJournal."Journal Batch Name" := JBatch;
            GenJournal."Posting Date" := PostingDate;
            GenJournal."Document No." := RecRef."No.";
            GenJournal.Validate(Amount, AmountToDisburse * -1);
            GenJournal.Description := CopyStr(Text001Description + RecRef."No.", 1, 50);
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
                GenJournal."External Document No." := RecRef."Account No.";
                GenJournal.Validate("Account No.", PartialDisb."Account No.");
                GenJournal."Line No." := Linenum;
                GenJournal."Journal Template Name" := Jtemplate;
                GenJournal."Journal Batch Name" := JBatch;
                GenJournal."Posting Date" := PostingDate;
                GenJournal."Document No." := RecRef."No.";
                GenJournal.Validate(Amount, AmountToDisburse * -1);
                GenJournal.Description := CopyStr(Text001Description + RecRef."No.", 1, 50);
                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                if GenJournal.Amount <> 0 then
                    GenJournal.Insert(true);
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
                InitPost.InitChargesEntry(LoanChargePosted, GenJournal, 0);
                GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                GenJournal."Line No." := Linenum;
                GenJournal."Journal Template Name" := Jtemplate;
                GenJournal."Journal Batch Name" := JBatch;
                GenJournal."Posting Date" := PostingDate;
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
                                if (RecRef."Total TopUp" >= TieredChargeLine."Lower Limit") and (RecRef."Total TopUp" <= TieredChargeLine."Upper Limit") then begin
                                    GenJournal.Validate(Amount, Round(RecRef."Total TopUp" * (TieredChargeLine.Percentage / 100), 1, '='));
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
                            InitPost.InitGenSetupEntry(GeneralSetUp, GenJournal, 0);
                            GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal."Document No." := RecRef."No.";
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
                    Linenum := PerformPostOnUpfrontInt(RecRef."No.", RecRef."No.",
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
                                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate"), 0.01, '>') else
                                    AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                            end else begin
                            if RecRef."Deposits Appraisal Parameter" = RecRef."Deposits Appraisal Parameter"::Dividends then
                                AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate"), 0.01, '>') else
                                AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                        end;
                    end;
                    Linenum := Linenum + 1000;
                    Linenum := PerformPostOnUpfrontInt(RecRef."No.", RecRef."No.",
                    PostingDate, Dim1, Dim2, Jtemplate, JBatch, AccruedInt,
                    RecRef."Account No.", Linenum, RecRef."Product Type", RecRef."Charge Interest on Posting");

                    AccBanking.Get(RecRef."Disbursement Account No.");
                    Linenum := Linenum + 1000;
                    InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal."Document No." := RecRef."No.";
                    GenJournal.Validate(Amount, AccruedInt);
                    GenJournal.Description := CopyStr('Interest Paid on-' + RecRef."No.", 1, 50);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);

                    Linenum := Linenum + 1000;
                    InitPost.InitializeDebitEntryInt(RecRef, GenJournal, 0);
                    GenJournal."Line No." := Linenum;
                    GenJournal."Journal Template Name" := Jtemplate;
                    GenJournal."Journal Batch Name" := JBatch;
                    GenJournal."Posting Date" := PostingDate;
                    GenJournal.Validate(Amount, AccruedInt * -1);
                    GenJournal.Description := CopyStr('Interest Paid On-' + RecRef."No.", 1, 50);
                    GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournal.Amount <> 0 then
                        GenJournal.Insert(true);

                end
        end;

        if RecRef."Deposit Purchase" > 0 then begin
            Linenum := Linenum + 1000;
            InitPost.InitializeCreditEntry(AccBanking, GenJournal, 0);
            GenJournal."Line No." := Linenum;
            GenJournal."Journal Template Name" := Jtemplate;
            GenJournal."Journal Batch Name" := JBatch;
            GenJournal."Posting Date" := PostingDate;
            GenJournal."Document No." := RecRef."No.";
            GenJournal.Validate(Amount, RecRef."Deposit Purchase");
            GenJournal.Description := CopyStr(Text002Description + RecRef."No.", 1, 50);
            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
            if GenJournal.Amount <> 0 then
                GenJournal.Insert(true);

            CredAcc.Get(RecRef."Deposit Purchase Account");
            Linenum := Linenum + 1000;
            InitPost.InitCreditEntry(CredAcc, GenJournal, 0);
            GenJournal."Line No." := Linenum;
            GenJournal."Journal Template Name" := Jtemplate;
            GenJournal."Journal Batch Name" := JBatch;
            GenJournal."Posting Date" := PostingDate;
            GenJournal."Document No." := RecRef."No.";
            GenJournal.Validate(Amount, RecRef."Deposit Purchase" * -1);
            GenJournal.Description := CopyStr(Text002Description + RecRef."No.", 1, 50);
            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
            if GenJournal.Amount <> 0 then
                GenJournal.Insert(true);
        end;
        RecRef.CalcFields("Total TopUp");

        if RecRef."Total TopUp" > 0 then begin
            ChargeAmt[2] := 0;

            LoansTopupPosted.Reset;
            LoansTopupPosted.SetRange("Loan No.", RecRef."No.");
            LoansTopupPosted.SetRange("Account No.", RecRef."Account No.");
            if LoansTopupPosted.Find('-') then begin
                LoansTopupPosted.CalcSums("Total Amount");
                ChargeAmt[2] := LoansTopupPosted."Total Amount";
                repeat

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
                                GenJournal."Document No." := RecRef."No.";
                                GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                                GenJournal.Validate("Account No.", PLoan."Loan Account");
                                GenJournal.Validate(Amount, LoansTopupPosted."Untransfered Interest");
                                GenJournal.Description := CopyStr('Accrued Interest-' + LoansTopupPosted."Loan Top Up", 1, 50);
                                GenJournal."Transaction Type" := GenJournal."Transaction Type"::"Interest Due";
                                GenJournal.Validate("Loan No.", PLoan."No.");
                                GenJournal.Validate("Bal. Account No.", PFact."Interest Account (G/L)");
                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                            end;
                        end;
                        if (RecRef."Outstanding Interest" + LoansTopupPosted."Untransfered Interest") > 0 then begin

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor, RecRef."No.",
                            'Interest Cleared on-' + LoansTopupPosted."Loan Top Up",
                            (RecRef."Outstanding Interest" + LoansTopupPosted."Untransfered Interest"),
                            RecRef."Disbursement Account No.", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account",
                            '', RecRef."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '',
                            RecRef."Group Code", '',
                            Enum::"Gen. Journal Document Type"::" ",
                            RecRef."Currency Code",
                            Enum::"Gen. Journal Document Type"::" ");

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch, Linenum,
                            Enum::"Gen. Journal Account Type"::Customer, RecRef."No.",
                            'Interest Paid-' + LoansTopupPosted."Loan Top Up",
                            (RecRef."Outstanding Interest" + LoansTopupPosted."Untransfered Interest") * -1,
                            RecRef."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            RecRef."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Interest Paid",
                            RecRef."No.", RecRef."Group Code", '',
                            Enum::"Gen. Journal Document Type"::" ",
                            RecRef."Currency Code",
                            Enum::"Gen. Journal Document Type"::" ");
                        end;

                        if RecRef."Outstanding Bill" > 0 then begin

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch,
                            Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor,
                            RecRef."No.",
                            'Bills Cleared-' + LoansTopupPosted."Loan Top Up",
                            RecRef."Outstanding Bill",
                            RecRef."Disbursement Account No.", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            RecRef."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ", '',
                            RecRef."Group Code", '',
                            Enum::"Gen. Journal Document Type"::" ",
                            RecRef."Currency Code",
                            Enum::"Gen. Journal Document Type"::" ");

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch,
                            Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            RecRef."No.",
                            'Bills Paid' + LoansTopupPosted."Loan Top Up",
                            RecRef."Outstanding Bill" * -1,
                            RecRef."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            RecRef."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::"Penalty Paid",
                            RecRef."No.", RecRef."Group Code", '',
                            Enum::"Gen. Journal Document Type"::" ",
                            RecRef."Currency Code",
                            Enum::"Gen. Journal Document Type"::" ");
                        end;

                        if RecRef."Outstanding Principal" > 0 then begin

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch,
                            Linenum,
                            Enum::"Gen. Journal Account Type"::Vendor,
                            RecRef."No.",
                            'Principal Cleared-' + LoansTopupPosted."Loan Top Up",
                            RecRef."Outstanding Principal",
                            RecRef."Disbursement Account No.", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            RecRef."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::" ",
                            '', RecRef."Group Code", '',
                            Enum::"Gen. Journal Document Type"::" ",
                            RecRef."Currency Code",
                            Enum::"Gen. Journal Document Type"::" ");

                            Linenum := Linenum + 1000;
                            Post.PostJournal(Jtemplate, JBatch,
                            Linenum,
                            Enum::"Gen. Journal Account Type"::Customer,
                            RecRef."No.",
                            'Principal Paid-' + LoansTopupPosted."Loan Top Up",
                            RecRef."Outstanding Principal" * -1,
                            RecRef."Loan Account", PostingDate,
                            Enum::"Gen. Journal Account Type"::"G/L Account", '',
                            RecRef."Account No.", Dim1, Dim2,
                            Enum::"LoanTransactionType"::Repayment,
                            RecRef."No.", RecRef."Group Code", '',
                            Enum::"Gen. Journal Document Type"::" ",
                            RecRef."Currency Code",
                            Enum::"Gen. Journal Document Type"::" ");
                        end;
                        ChargeAmt[1] := 0;


                        LoanProdCharges.Reset();
                        LoanProdCharges.SetRange("Product Code", RecRef."Product Type");
                        LoanProdCharges.SetRange("Charge Type", LoanProdCharges."Charge Type"::"Top up");
                        if LoanProdCharges.FindSet() then begin
                            LoanProdCharges.TestField("Charges Account");
                            RecRef.CalcFields("Total TopUp");

                            if LoansTopupPosted."Settlement Fee" > 0 then begin

                                Linenum := Linenum + 1000;

                                Post.PostJournal(Jtemplate, JBatch,
                                Linenum, Enum::"Gen. Journal Account Type"::Vendor,
                                RecRef."No.", 'Accrued Settlement Fee Cleared-' + LoansTopupPosted."Loan Top Up",
                                LoansTopupPosted."Settlement Fee", RecRef."Disbursement Account No.", PostingDate,
                                Enum::"Gen. Journal Account Type"::"G/L Account", LoanProdCharges."Charges Account",
                                RecRef."Account No.", Dim1, Dim2, Enum::"LoanTransactionType"::" ",
                                '', RecRef."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
                                RecRef."Currency Code", Enum::"Gen. Journal Document Type"::" ");

                            end;

                            Linenum := Linenum + 1;
                            GenJournal.Init();
                            GenJournal."Line No." := Linenum;
                            GenJournal."Document No." := RecRef."No.";
                            GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                            GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                            GenJournal."Line No." := Linenum;
                            GenJournal."Journal Template Name" := Jtemplate;
                            GenJournal."Journal Batch Name" := JBatch;
                            GenJournal."Posting Date" := PostingDate;
                            GenJournal.Description := CopyStr(LoanProdCharges."Charge Description", 1, 50);
                            GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                            GenJournal."External Document No." := RecRef."Account No.";
                            if LoanProdCharges."Staggered Charge Code" = '' then begin
                                if LoanProdCharges."Use Percentage" then begin
                                    LoanProdCharges.TestField(Percentage);
                                    if Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '=') < LoanChargePosted.Minimum then begin
                                        GenJournal.Validate(Amount, Round((LoanChargePosted.Minimum), 1, '='));
                                    end else begin
                                        GenJournal.Validate(Amount, Round(((LoanChargePosted.Percentage / 100) * ChargeAmt[2]), 1, '='));
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
                                                GenJournal.Validate(Amount, Round(ChargeAmt[2] * (TieredChargeLine.Percentage / 100), 1, '=')) else
                                                GenJournal.Validate(Amount, TieredChargeLine."Charge Amount");
                                        end;
                                    until TieredChargeLine.Next() = 0;
                                end;

                                GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                GenJournal.Validate("Bal. Account No.", LoanProdCharges."Charges Account");
                                if GenJournal.Amount <> 0 then
                                    GenJournal.Insert(true);
                                ChargeAmt[1] := GenJournal.Amount;

                                case LoanProdCharges."Effect Excise Duty" of
                                    LoanProdCharges."Effect Excise Duty"::Yes:
                                        begin

                                            Linenum := Linenum + 10;
                                            GenJournal.Init();
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Document No." := RecRef."No.";
                                            GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                                            GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                            GenJournal."Line No." := Linenum;
                                            GenJournal."Journal Template Name" := Jtemplate;
                                            GenJournal."Journal Batch Name" := JBatch;
                                            GenJournal."Posting Date" := PostingDate;
                                            GenJournal."Document No." := RecRef."No.";
                                            GenJournal."External Document No." := RecRef."Account No.";
                                            GenJournal.Validate("Account No.", RecRef."Disbursement Account No.");
                                            GenJournal."External Document No." := RecRef."Account No.";
                                            GenJournal.Validate(Amount, Round(((GeneralSetUp."Excise Duty (%)" / 100) * ChargeAmt[1]), 1, '='));
                                            GenJournal.Description := CopyStr(TextE0009 + LoanChargePosted."Charge Description", 1, 50);
                                            GenJournal.Validate("Bal. Account No.", GeneralSetUp."Excise Duty G/L");
                                            GenJournal.Validate("Shortcut Dimension 1 Code", Dim1);
                                            GenJournal.Validate("Shortcut Dimension 2 Code", Dim2);
                                            if GenJournal.Amount <> 0 then
                                                GenJournal.Insert(true);
                                        end;
                                end;
                            end;
                        end;
                    end
                until LoansTopupPosted.Next = 0;
            end;
        end;
        VarVariant := RecRef;
        DocsMngt.DocPrintstatement(VarVariant, 0);
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


    procedure PerformPostOnUpfrontInt(LoanNo: Code[20]; DocNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]; ChargeOption: Enum ChargeInterestDue): Integer
    var
        Loans: Record Loans;
        ProductType: Record "Product Factory";
    begin
        if Loans.Get(LoanNo) then begin
            ProductType.Get(Loans."Product Type");
            ProductType.TestField("Interest Account (G/L)");
            Post.PostJournal(GnlTemplate, GnlJBatch, LineNo, Enum::"Gen. Journal Account Type"::Customer,
            DocNo, Text00002 + LoanNo, RunBal, Loans."Loan Account", PDate,
            Enum::"Gen. Journal Account Type"::"G/L Account", ProductType."Interest Account (G/L)",
            Loans."Account No.", DActivity, DBranch, Enum::"LoanTransactionType"::"Interest Due",
            Loans."No.", Loans."Group Code", '', Enum::"Gen. Journal Document Type"::" ",
            Loans."Currency Code", Enum::"Gen. Journal Document Type"::" ");
            exit(LineNo)
        end
    end;


    procedure PostDepositPrch(LoanNo: Code[20]; DocNo: Code[20]; PDate: Date; DActivity: Code[20]; DBranch: Code[20]; GnlTemplate: Code[20]; GnlJBatch: Code[20]; RunBal: Decimal; MemberNo: Code[20]; LineNo: Integer; LoanType: Code[20]): Integer
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
                    Enum::"Gen. Journal Account Type"::Vendor, DocNo, Text00002 + LoanNo, RunBal,
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
                    DocNo, Text00002 + LoanNo, RunBal * -1,
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
                    DocNo, Loans."Account No.", Loans."Disbursement Account No.",
                    DActivity, DBranch,
                    RunBal, Loans."Account No.");

                end
            end;
            exit(LineNo)
        end;
    end;


    procedure fnPostCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
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
                JournalLines."Document No." := DocNo;
                JournalLines."External Document No." := ExtDocNo;
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
                            JournalLines."Document No." := DocNo;
                            JournalLines."External Document No." := ExtDocNo;
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


    procedure fnPostRefCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
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
                JournalLines."Document No." := DocNo;
                JournalLines."External Document No." := ExtDocNo;
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
                            JournalLines."Document No." := DocNo;
                            JournalLines."External Document No." := ExtDocNo;
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


    procedure fnPostLoanDepositCharges(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
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
            JournalLines."Document No." := DocNo;
            JournalLines."External Document No." := ExtDocNo;
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
                        JournalLines."Document No." := DocNo;
                        JournalLines."External Document No." := ExtDocNo;
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


    procedure PostLoanTopup(LoanNo: Code[20]; Gnltemplate: Code[10]; GnlJBatch: Code[10]; LineNo: Integer; PostDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; DisbursementAcc: Code[20]; Dim1: Code[20]; Dim2: Code[20]; ApprovedAmt: Decimal; AccountNo: Code[20]): Integer
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
                        Enum::"Gen. Journal Account Type"::Vendor, DocNo,
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
                        Enum::"Gen. Journal Account Type"::Customer, DocNo,
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
                        DocNo,
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
                        DocNo,
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
                        DocNo,
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
                        DocNo,
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




}



