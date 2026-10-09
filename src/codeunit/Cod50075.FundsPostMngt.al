codeunit 50075 "Funds. Post Mngt."
{
    trigger OnRun()
    begin
    end;

    procedure fnInitialize(DocType: Enum CustomApprovalEntriesDocType)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        LoanApplication: Record "Loan Application";
        LoansR: Record "Loan Application";
        AppraisalParameter: Record "Loan Appraisal Parameter";
        RecHeader: Record "Receipts Header";
        PayHeader: Record "Payments Header";
        RecPayTypes: Record "Receipts and Payment Types";
    begin

        CompInfo.Get();
        Gensetup.Get();
        GenLedger.Get();
        CashOfficeSetup.Get();

        //Gensetup.TestField(Gensetup."Excise Duty (%)");
        // Gensetup.TestField(Gensetup."Excise Duty G/L");
        //ExciseDutyGL := Gensetup."Excise Duty G/L";

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        case DocType of
            DocType::Receipt:
                begin
                    Temp.TestField("Receipt Journal Template");
                    Temp.TestField("Receipt Journal Batch");
                    JTemplate := Temp."Receipt Journal Template";
                    JBatch := Temp."Receipt Journal Batch";

                end;
            DocType::"Petty Cash":
                begin
                    Temp.TestField("Petty Cash Template");
                    Temp.TestField("Petty Cash Batch");
                    JTemplate := Temp."Petty Cash Template";
                    JBatch := temp."Petty Cash Batch";

                end;
            DocType::"Payment Voucher":
                begin
                    Temp.TestField("Payment Journal Template");
                    Temp.TestField("Payment Journal Batch");
                    JTemplate := Temp."Payment Journal Template";
                    JBatch := Temp."Payment Journal Batch";
                end;
            DocType::Interbank:
                begin

                    Temp.TestField("Inter Bank Template Name");
                    Temp.TestField("Inter Bank Batch Name");
                    JTemplate := Temp."Inter Bank Template Name";
                    JBatch := Temp."Inter Bank Batch Name";
                end;
            DocType::Imprest:
                begin
                    Temp.TestField("Imprest Template");
                    Temp.TestField("Imprest  Batch");
                    JTemplate := Temp."Imprest Template";
                    JBatch := Temp."Imprest  Batch";
                end;
            DocType::Surrender:
                begin
                    Temp.TestField("Imprest Sur Template");
                    Temp.TestField("Imprest Sur Batch");
                    JTemplate := Temp."Imprest Sur Template";
                    JBatch := Temp."Imprest Sur Batch";
                end;
        end;
    end;

    procedure CalculateTax(Rec: Record "Payment Lines"; CalculationType: Enum TaxCalculationType) Amount: Decimal
    begin

        case CalculationType OF
            CalculationType::VAT:
                begin
                    Amount := (Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount;
                end;
            CalculationType::"W/Tax":
                begin
                    Amount := (Rec.Amount - ((Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount))
                    * (Rec."W/Tax Rate" / 100);
                end;
            CalculationType::Retention:
                begin
                    Amount := (Rec.Amount - ((Rec."VAT Rate" / (100 + Rec."VAT Rate")) * Rec.Amount))
                     * (Rec."Retention Rate" / 100);
                end;

            CalculationType::"W/VAT":
                begin
                    Amount := (Rec.Amount * Rec."VAT Withholding Rate" / (100 + Rec."VAT Rate"));
                end;
        end;
    end;

    procedure PostReceiptMngt(RecRef: Record "Receipts Header"; PostPrint: Boolean)
    var
        RunBal: Decimal;
        RepayAccount: Record "Repayment Account";
        LInterest: Decimal;
        LPrincipal: Decimal;
        LRepayment: Decimal;
        AccruedInt: Decimal;
        Loans: Record Loans;
    begin
        fnInitialize(CustomDocType::Receipt);
        RecRef.CheckMinRequiredItem();
        BnkProcMngt.CheckPaylineReqItems(RecRef."No.");
        JnlPostMngt.ClearJournalLines(RecRef."Receipt Journal Template", RecRef."Receipt Journal Batch");
        RecRef.CalcFields("Total Amount");

        if TellerMgt.TestNoEntriesExist(RecRef."Received From", RecRef."No.", 1) then begin
            Error(Text016, RecRef."Received From", RecRef."No.");
        end;

        LineNo := LineNo + 1000;
        JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, RecRef."Account Type", RecRef."No.",
        RecRef."Received From", RecRef."Total Amount", RecRef."Account No.", RecRef.Date,
        AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
        '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");

        case RecRef."Application Type" of

            RecRef."Application Type"::Member:
                begin
                    RepayAccount.Reset();
                    RepayAccount.SetRange("Member No.", RecRef."Member No.");
                    RepayAccount.SetRange("Account Dimension", RepayAccount."Account Dimension"::Repayment);
                    if RepayAccount.FindFirst() then begin

                        JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::Vendor, RecRef."No.",
                        RecRef."Received From", RecRef."Total Amount" * -1, RepayAccount."No.", RecRef.Date,
                        AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
                        '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");
                    end;

                    ReceiptLine.Reset;
                    ReceiptLine.SetFilter(Amount, '>0');
                    ReceiptLine.SetRange(ReceiptLine.No, RecRef."No.");
                    ReceiptLine.SetRange(ReceiptLine.Posted, false);
                    if ReceiptLine.Find('-') then begin
                        repeat
                            ReceiptLine.TestField("Account Name");
                            ReceiptLine.TestField("Account No.");
                            RunBal := 0;

                            case ReceiptLine."Transaction Type" of
                                ReceiptLine."Transaction Type"::" ":
                                    begin

                                        GenJnlLine.LockTable();
                                        LineNo := LineNo + 1000;
                                        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate, JBatch, RecRef."No.",
                                        RecRef."Currency Code",
                                        RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                        GenJnlLine."Source Code" := 'CASHRECJNL';
                                        GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                                        case ReceiptLine."Account Type" of
                                            ReceiptLine."Account Type"::Saving:
                                                begin
                                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                                                end;
                                            ReceiptLine."Account Type"::Loan,
                                            ReceiptLine."Account Type"::Credit:
                                                begin
                                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                                end else begin
                                                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                                            end;
                                        end;
                                        GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                        GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                                        GenJnlLine.Validate(GenJnlLine.Amount, ReceiptLine.Amount * -1);
                                        GenJnlLine.Description := ReceiptLine."Account Name";
                                        GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                                        GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                                        if GenJnlLine.Amount <> 0 then
                                            GenJnlLine.Insert(true);

                                        JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::Vendor, RecRef."No.",
                                         RecRef."Received From", ReceiptLine.Amount, RepayAccount."No.", RecRef.Date,
                                        AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
                                        '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");

                                    end else begin
                                    LInterest := 0;
                                    LPrincipal := 0;
                                    LRepayment := 0;
                                    AccruedInt := 0;

                                    RunBal := ReceiptLine.Amount;
                                    if Loans.Get(ReceiptLine."Loan No.") then begin
                                        Loans.CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Bill", "Outstanding Insurance");
                                        LInterest := Loans."Outstanding Interest";
                                        if RecRef."Accrue Interest" then begin
                                            AccruedInt := RegMngt.getaccruedLoanInterest(Loans."No.", Today);

                                            if ProdFact.Get(Loans."Product Type") then begin
                                                ProdFact.fnCheckPostAccount();

                                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo,
                                                AccountType::Customer, RecRef."No.",
                                               RecRef."Received From", AccruedInt, Loans."Loan Account",
                                               RecRef.Date, AccountType::"G/L Account", ProdFact."Interest Account (G/L)",
                                               RecRef."Cheque No.", Dim1, Dim2,
                                               TransactionType::"Interest Due", '', '', '', DocType::" ", RecRef."Currency Code",
                                               AppliesToDocType::" ");
                                            end;

                                        end else begin
                                            AccruedInt := 0;
                                        end;

                                        if (Loans."Outstanding Interest" + AccruedInt) > 0 then begin

                                            BnkProcMngt.
                                            InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                            JBatch, RecRef."No.", RecRef."Currency Code",
                                            RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                            GenJnlLine."Source Code" := 'CASHRECJNL';
                                            GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                            GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");

                                            if RunBal > Loans."Outstanding Interest" then
                                                GenJnlLine.Validate(GenJnlLine.Amount, (LInterest + AccruedInt) * -1) else
                                                GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                            GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                            GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                            GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::"Interest Paid";

                                            if GenJnlLine.Amount <> 0 then
                                                GenJnlLine.Insert(true);
                                            RunBal := RunBal - Abs(GenJnlLine.Amount);

                                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::Vendor, RecRef."No.",
                                            RecRef."Received From", Abs(GenJnlLine.Amount), RepayAccount."No.", RecRef.Date,
                                           AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
                                           '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");
                                        end;

                                        if Loans."Outstanding Insurance" > 0 then begin
                                            if RunBal > 0 then begin
                                                BnkProcMngt.
                                            InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                            JBatch, RecRef."No.", RecRef."Currency Code",
                                             RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                                GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                                GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                                if RunBal > Loans."Outstanding Insurance" then
                                                    GenJnlLine.Validate(GenJnlLine.Amount, Loans."Outstanding Insurance" * -1) else
                                                    GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                                GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                                GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                                GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::"Insurance Paid";
                                                if GenJnlLine.Amount <> 0 then
                                                    GenJnlLine.Insert(true);
                                                RunBal := RunBal - Abs(GenJnlLine.Amount);

                                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::Vendor, RecRef."No.",
                                           RecRef."Received From", Abs(GenJnlLine.Amount), RepayAccount."No.", RecRef.Date,
                                          AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
                                          '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");
                                            end;
                                        end;

                                        if Loans."Outstanding Bill" > 0 then begin
                                            BnkProcMngt.
                                            InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                            JBatch, RecRef."No.", RecRef."Currency Code",
                                            RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                            GenJnlLine."Source Code" := 'CASHRECJNL';
                                            GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                            GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                            if RunBal > Loans."Outstanding Bill" then
                                                GenJnlLine.Validate(GenJnlLine.Amount, Loans."Outstanding Bill" * -1) else
                                                GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                            GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                            GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                            GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::"Penalty Paid";
                                            if GenJnlLine.Amount <> 0 then
                                                GenJnlLine.Insert(true);
                                            RunBal := RunBal - Abs(GenJnlLine.Amount);

                                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::Vendor, RecRef."No.",
                                            RecRef."Received From", Abs(GenJnlLine.Amount), RepayAccount."No.", RecRef.Date,
                                             AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
                                             '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");

                                        end;
                                        LPrincipal := (ReceiptLine.Amount - (Loans."Outstanding Interest" + Loans."Outstanding Insurance" + Loans."Outstanding Bill"));

                                        if Loans."Outstanding Principal" > 0 then begin
                                            if RunBal > 0 then begin

                                                BnkProcMngt.
                                            InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                             JBatch, RecRef."No.", RecRef."Currency Code",
                                               RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                                GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                                GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                                if RunBal > Loans."Outstanding Principal" then
                                                    GenJnlLine.Validate(GenJnlLine.Amount, Loans."Outstanding Principal" * -1) else
                                                    GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                                GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                                GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                                GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::Repayment;
                                                if GenJnlLine.Amount <> 0 then
                                                    GenJnlLine.Insert(true);
                                                RunBal := RunBal - Abs(GenJnlLine.Amount);

                                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::Vendor, RecRef."No.",
                                           RecRef."Received From", Abs(GenJnlLine.Amount), RepayAccount."No.", RecRef.Date,
                                          AccountType::"G/L Account", '', RecRef."Cheque No.", Dim1, Dim2, TransactionType::" ", '',
                                          '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        until ReceiptLine.Next() = 0;
                    end;
                end else begin
                CreateJournalCreditEntry(RecRef);
            end;
        end;
        if RecRef."Check Line" then begin
            JnlPostMngt.CompletePosting(JTemplate, JBatch);
            OnCompletePostMgt(CustomDocType::Receipt, RecRef."No.");

            if PostPrint then begin
                Commit;
                RecRef.TestField(Posted, true);
                RecRef.Reset;
                RecRef.SetFilter("No.", RecRef."No.");
                REPORT.Run(Report::"Official Receipt", true, true, RecRef);
                RecRef.Reset;
            end else begin
                Message(OncompleteDialog);
            end;

        end else begin
            fnJournalPreviewMngt(CustomDocType::Receipt, RecRef."No.", JTemplate, JBatch);
        end;
    end;

    procedure PostInterBankTransfer(RecRef: Record "Interbank Transfer"; PostPrint: Boolean)
    begin
        fnInitialize(CustomDocType::Interbank);
        RecRef.CheckRequiredItem(1);
        if ApprovlsMgt.CheckBlockedDocsOnJnls(RecRef."No.", Database::"Interbank Transfer") then begin

            LineNo := LineNo + 1000;

            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::"Bank Account", RecRef."No.",
                                               RecRef."Received From", RecRef."Amount Recieved", RecRef."Account No.", RecRef.Date,
                                              AccountType::"G/L Account", '', RecRef."No.", Dim1, Dim2, TransactionType::" ", '',
                                              '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");
            LineNo := LineNo + 1000;

            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AccountType::"Bank Account", RecRef."No.",
                                               RecRef."Received From", RecRef."Amount Recieved" * -1, RecRef."Paying Account No.", RecRef.Date,
                                              AccountType::"G/L Account", '', RecRef."No.", Dim1, Dim2, TransactionType::" ", '',
                                              '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");
            if RecRef."Check Line" then begin
                JnlPostMngt.CompletePosting(JTemplate, JBatch);
                OnCompletePostMgt(CustomDocType::Interbank, RecRef."No.");
                if PostPrint then begin
                    Commit;
                    RecRef.TestField(Posted, true);
                    RecRef.Reset;
                    RecRef.SetFilter("No.", RecRef."No.");
                    //REPORT.Run(Report::"Official Receipt", true, true, RecRef);
                    RecRef.Reset;
                end else begin
                    Message(OncompleteDialog);
                end;
            end else begin
                fnJournalPreviewMngt(CustomDocType::Interbank, RecRef."No.", JTemplate, JBatch);
            end;
        end;

    end;

    procedure PostPaymentVoucher(RecRef: Record "Payments Header"; PostPrint: Boolean)
    var
        Payments: Record "Payments Header";
    begin
        fnInitialize(CustomDocType::"Payment Voucher");
        RecRef.CheckPVRequiredItems();
        JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

        if ApprovlsMgt.CheckBlockedDocsOnJnls(RecRef."No.", Database::"Payments Header") then begin
            fnPostPaymentHeader(RecRef);

            if RecRef."Check Line" then begin
                JnlPostMngt.CompletePostingAdjustJnl(JTemplate, JBatch, RecRef."Pay Mode", RecRef."Cheque Type");
                OnCompletePostMgt(CustomDocType::"Payment Voucher", RecRef."No.");
                if PostPrint then begin
                    Commit();
                    RecRef.Reset;
                    RecRef.SetFilter("No.", RecRef."No.");
                    Report.Run(Report::"Payment Voucher", true, true, RecRef);
                    RecRef.Reset;
                end;
            end else begin
                fnJournalPreviewMngt(CustomDocType::"Payment Voucher", RecRef."No.", JTemplate, JBatch);
            end;
        end;
    end;

    procedure fnPostPaymentHeader(var Payment: Record "Payments Header")
    begin
        Payment.CheckRequiredItem();
        Payment.CalcFields("Total Net Amount", "Total VAT Amount");

        if TellerMgt.TestNoEntriesExist(Payment."Account Name", Payment."No.", 1) then begin
            Error(Text016, Payment."Account Name", Payment."No.");
        end;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JTemplate);
        GenJnlLine.SetRange("Journal Batch Name", JBatch);
        if GenJnlLine.FindLast() then begin
            LineNo := GenJnlLine."Line No." + 10;
        end else begin
            LineNo := 10;
        end;

        GenJnlLine.LockTable();
        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
        JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
        Dim2, Payment."Payment Release Date");
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."External Document No." := Payment."Cheque No";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
        GenJnlLine.Validate("Account No.", Payment."Paying Bank Account");
        GenJnlLine.Validate(GenJnlLine.Amount, Payment."Total Net Amount" * -1);
        GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
        GenJnlLine.Description := CopyStr(Payment."Payment Narration", 1, 50);
        case Payment."Pay Mode" of
            Payment."Pay Mode"::Cheque:
                begin
                    if Payment."Cheque Type" = Payment."Cheque Type"::"Computer Check" then
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check" else
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                end else begin
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
            end;
        end;
        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert(true);
        fnPostPv(Payment);
    end;
    procedure fnPostPv(var Payment: Record "Payments Header")
    var
        PayLine: Record "Payment Lines";
        CashierLinks: Record "Cash Office User Template";
    begin
        PayLine.Reset();
        PayLine.SetRange(No, Payment."No.");
        if PayLine.FindSet() then begin
            repeat
                Payment.TestField(Payment.Payee);
                PayLine.TestField(PayLine.Amount);

                if Payment."Pay Mode" = Payment."Pay Mode"::Cash then begin
                    CashierLinks.Reset();
                    CashierLinks.SetRange(UserID, UserId);
                end;

                LineNo := LineNo + 100;

                GenJnlLine.LockTable();
                BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                Dim2, Payment."Payment Release Date");
                GenJnlLine."Source Code" := 'PAYMENTJNL';
                GenJnlLine."External Document No." := Payment."Cheque No";
                case PayLine."Account Type" of
                    PayLine."Account Type"::Saving:
                        begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                        end;
                    PayLine."Account Type"::Credit,
                    PayLine."Account Type"::Loan:
                        begin
                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer
                        end else begin
                        GenJnlLine."Account Type" := PayLine."Account Type";
                    end;
                end;
                GenJnlLine.Validate("Account No.", PayLine."Account No.");
                case Payment."Payment Type" of
                    Payment."Payment Type"::Normal:
                        GenJnlLine.Validate(GenJnlLine.Amount, (PayLine."Net Amount" + PayLine."VAT Amount"));
                    Payment."Payment Type"::"Petty Cash":
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Net Amount");
                end;

                GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                GenJnlLine.Validate("VAT Bus. Posting Group", PayLine."VAT Prod. Posting Group");
                GenJnlLine.Description := CopyStr(PayLine."Account Name", 1, 50);
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                GenJnlLine.Validate("Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                GenJnlLine."Applies-to ID" := PayLine."Applies-to ID";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert(true);

                LineNo := LineNo + 1000;
                CreateCreditBalancingEntry(PayLine, Payment, LineNo);
            until PayLine.Next() = 0;
        end;
    end;

    procedure CreateCreditBalancingEntry(var PayLine: Record "Payment Lines"; Payment: Record "Payments Header"; Linecode: Integer)
    var
        CashierLinks: Record "Cash Office User Template";
    begin

        case Payment."Payment Type" of
            Payment."Payment Type"::"Petty Cash":
                begin

                    TarriffCodes.Reset();
                    TarriffCodes.SetRange(Code, PayLine."VAT Code");
                    if TarriffCodes.Find('-') then begin

                        TarriffCodes.TestField("Account No.");
                        LineNo := Linecode + 100;
                        GenJnlLine.LockTable();
                        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                        JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                        Dim2, Payment."Payment Release Date");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."External Document No." := Payment."Cheque No";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";
                        GenJnlLine.Validate("Account No.", TarriffCodes."Account No.");
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."VAT Amount" * -1);
                        GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                        GenJnlLine.Description := CopyStr('VAT: ' + Format(PayLine."Account Type") + '-' + PayLine."Account Name", 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                        GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");

                        GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                        GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                        GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert(true);
                    end;

                    TarriffCodes.Reset();
                    TarriffCodes.SetRange(Code, PayLine."Withholding Tax Code");
                    if TarriffCodes.Find('-') then begin
                        TarriffCodes.TestField("Account No.");
                        LineNo := LineNo + 100;

                        GenJnlLine.LockTable();
                        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                        JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                        Dim2, Payment."Payment Release Date");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."External Document No." := Payment."Cheque No";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";
                        GenJnlLine.Validate("Account No.", TarriffCodes."Account No.");
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Withholding Tax Amount" * -1);
                        GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                        GenJnlLine.Description := CopyStr('W/Tax: ' + Format(PayLine."Account Type") + '-' + PayLine."Account Name", 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                        GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                        GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                        GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                        GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert(true);
                    end;

                    LineNo := LineNo + 100;

                    GenJnlLine.LockTable();
                    BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                    JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                    Dim2, Payment."Payment Release Date");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."External Document No." := Payment."Cheque No";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine.Validate("Account No.", PayLine."Account No.");
                    if PayLine."VAT Code" = '' then
                        GenJnlLine.Validate(Amount, 0) else
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."VAT Amount");
                    GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                    GenJnlLine.Description := CopyStr('VAT-' + PayLine."Account Name", 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                    GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine.Validate("Bal. Account No.", TarriffCodes."Account No.");
                    GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                    GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert(true);


                    LineNo := LineNo + 100;

                    GenJnlLine.LockTable();
                    BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                    JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                    Dim2, Payment."Payment Release Date");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."External Document No." := Payment."Cheque No";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine.Validate("Account No.", PayLine."Account No.");
                    GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Withholding Tax Amount");
                    GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                    GenJnlLine.Description := CopyStr('W/Tax-' + PayLine."Account Name", 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                    GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                    GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                    GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert(true);


                end;
            Payment."Payment Type"::Normal:
                begin

                    //Post W/Tax +W/Vat to respective GL Account
                    TarriffCodes.Reset();
                    TarriffCodes.SetRange(Code, PayLine."W/T VAT Code");
                    if TarriffCodes.Find('-') then begin

                        TarriffCodes.TestField("Account No.");
                        LineNo := Linecode + 100;
                        GenJnlLine.LockTable();
                        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                        JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                        Dim2, Payment."Payment Release Date");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."External Document No." := Payment."Cheque No";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";
                        GenJnlLine.Validate("Account No.", TarriffCodes."Account No.");
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."W/T VAT Amount" * -1);
                        GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                        GenJnlLine.Description := CopyStr('VAT: ' + Format(PayLine."Account Type") + '-' + PayLine."Account Name", 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                        GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                        GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                        GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                        GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert(true);
                    end;

                    //Post W/TAX to Respective W/TAX GL Account
                    TarriffCodes.Reset();
                    TarriffCodes.SetRange(Code, PayLine."Withholding Tax Code");
                    if TarriffCodes.Find('-') then begin
                        TarriffCodes.TestField("Account No.");
                        LineNo := LineNo + 100;

                        GenJnlLine.LockTable();
                        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                        JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                        Dim2, Payment."Payment Release Date");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."External Document No." := Payment."Cheque No";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";
                        GenJnlLine.Validate("Account No.", TarriffCodes."Account No.");
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Withholding Tax Amount" * -1);
                        GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                        GenJnlLine.Description := CopyStr('W/Tax: ' + Format(PayLine."Account Type") + '-' + PayLine."Account Name", 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                        GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                        GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                        GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                        GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert(true);
                    end;

                    //Post retention to Respective retention GL Account

                    TarriffCodes.Reset();
                    TarriffCodes.SetRange(Code, PayLine."Retention Code");
                    if TarriffCodes.Find('-') then begin
                        TarriffCodes.TestField("Account No.");
                        LineNo := LineNo + 100;

                        GenJnlLine.LockTable();
                        BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                        JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                        Dim2, Payment."Payment Release Date");
                        GenJnlLine."Source Code" := 'PAYMENTJNL';
                        GenJnlLine."External Document No." := Payment."Cheque No";
                        GenJnlLine."Account Type" := TarriffCodes."Account Type";
                        GenJnlLine.Validate("Account No.", TarriffCodes."Account No.");
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Retention Amount" * -1);
                        GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                        GenJnlLine.Description := CopyStr('Retention: ' + Format(PayLine."Account Type") + '-' + PayLine."Account Name", 1, 50);
                        GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                        GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                        GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                        GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                        GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                        GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                        GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                        GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert(true);
                    end;

                    //Retention balancing account

                    LineNo := LineNo + 100;

                    GenJnlLine.LockTable();
                    BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                    JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                    Dim2, Payment."Payment Release Date");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."External Document No." := Payment."Cheque No";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine.Validate("Account No.", PayLine."Account No.");
                    if PayLine."VAT Code" = '' then
                        GenJnlLine.Validate(Amount, 0) else
                        GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Retention Amount");
                    GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                    GenJnlLine.Description := CopyStr('Retention-' + PayLine."Account Name", 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                    GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                    GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert(true);

                    //Post W/TAX Balancing Entry Goes to Vendor
                    LineNo := LineNo + 100;
                    GenJnlLine.LockTable();
                    BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                    JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                    Dim2, Payment."Payment Release Date");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."External Document No." := Payment."Cheque No";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine.Validate("Account No.", PayLine."Account No.");
                    GenJnlLine.Validate(GenJnlLine.Amount, PayLine."Withholding Tax Amount");
                    GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                    GenJnlLine.Description := CopyStr('W/Tax-' + PayLine."Account Name", 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                    GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                    GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                    GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert(true);

                    //Post W/Vat Balancing Entry Goes to Vendor
                    LineNo := LineNo + 100;
                    GenJnlLine.LockTable();
                    BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                    JBatch, Payment."No.", Payment.Currency, Payment."Document Date", Dim1,
                    Dim2, Payment."Payment Release Date");
                    GenJnlLine."Source Code" := 'PAYMENTJNL';
                    GenJnlLine."External Document No." := Payment."Cheque No";
                    GenJnlLine."Account Type" := PayLine."Account Type";
                    GenJnlLine.Validate("Account No.", PayLine."Account No.");
                    GenJnlLine.Validate(GenJnlLine.Amount, PayLine."W/T VAT Amount");
                    GenJnlLine.Validate("Currency Factor", Payment."Currency Factor");
                    GenJnlLine.Description := CopyStr('W/VAT Tax-' + PayLine."Account Name", 1, 50);
                    GenJnlLine.Validate(GenJnlLine."Gen. Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."Gen. Prod. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Bus. Posting Group", '');
                    GenJnlLine.Validate(GenJnlLine."VAT Prod. Posting Group");
                    GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::" ";
                    GenJnlLine."Dimension Set ID" := PayLine."Dimension Set ID";
                    GenJnlLine.Validate(GenJnlLine."Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
                    GenJnlLine."Applies-to Doc. Type" := PayLine."Applies-to Doc. Type";
                    GenJnlLine.Validate(GenJnlLine."Applies-to Doc. No.", PayLine."Applies-to Doc. No.");
                    GenJnlLine.Validate("Applies-to ID", PayLine."Applies-to ID");
                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert(true);
                end;
        end;

    end;

    procedure CustomerPayLinesExist(DocNo: Code[50]): Boolean
    var
        PayLine: Record "Payment Lines";

    begin
        PayLine.RESET;
        PayLine.SETRANGE(PayLine.No, DocNo);
        PayLine.SETRANGE(PayLine."Account Type", PayLine."Account Type"::Customer);
        exit(PayLine.FindFirst());
    end;

    procedure DocPrintPostMngt(var Variant: Variant; PostInt: Integer)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        LoanApplication: Record "Loan Application";
        LoansR: Record "Loan Application";
        AppraisalParameter: Record "Loan Appraisal Parameter";
        RecHeader: Record "Receipts Header";
        PayHeader: Record "Payments Header";
        RecPayTypes: Record "Receipts and Payment Types";

    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    procedure CreateJournalCreditEntry(RecRef: Record "Receipts Header")
    begin
        ReceiptLine.Reset;
        ReceiptLine.SetFilter(Amount, '>0');
        ReceiptLine.SetRange(ReceiptLine.Posted, false);
        ReceiptLine.SetRange(ReceiptLine.No, RecRef."No.");
        ReceiptLine.SetRange("Transaction Type", ReceiptLine."Transaction Type"::" ");
        if ReceiptLine.Find('-') then begin
            repeat
                ReceiptLine.TestField("Account Name");
                ReceiptLine.TestField("Account No.");

                GenJnlLine.LockTable();
                LineNo := LineNo + 1000;
                BnkProcMngt.InitializeEntry(GenJnlLine, LineNo, Jtemplate,
           JBatch, RecRef."No.", RecRef."Currency Code",
           RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                GenJnlLine."Source Code" := 'CASHRECJNL';
                GenJnlLine."External Document No." := ReceiptLine."Cheque/Deposit Slip No";
                GenJnlLine."Account Type" := ReceiptLine."Account Type";
                GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                GenJnlLine.Validate(GenJnlLine.Amount, ReceiptLine.Amount * -1);
                GenJnlLine.Description := ReceiptLine."Account Name";
                GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert(true);
            Until ReceiptLine.Next() = 0;
        end;
    end;

    procedure OnCompletePostMgt(Variantext: Enum CustomApprovalEntriesDocType; DocNo: Code[100])
    var
        RecRef: RecordRef;
        PostedLoan: Record Loans;
        Member: Record Member;
        PLoanTxt: Record Loans;
        ReceiptHeader: Record "Receipts Header";
        LoanCategory: Record "Loans Categorization";
        MonthlyContrib: Record "Member Monthly Contribution";
        LoanApplic: Record "Loan Application";
        PartSched: Record "Partial Disbursement Schedule";
        PartLoan: Record "Partial Disbursement Schedule";
        MemberCust: Record Member;
        AccountClosure: Record "Membership closure";
        PayLine: Record "Payment Lines";
        InterBankTrans: Record "Interbank Transfer";
        PayHeader: Record "Payments Header";
        Account: Record "Account Banking";
        InterestBuffer: Record "Interest Buffer";
        RegMngt: Codeunit "Register Management";
        CheckHeader: Record "Checkoff Header";
        Purchline: Record "Checkoff Receipt Lines";
        RecoveryHeader: Record "Recovery Header";
        Recoveryline: Record "Loan Disbursement Lines";
        CredAc: Record "Account Credit";
        AccountBanking: Record "Account Banking";
        Loan: Record Loans;
        Ploan: Record "Loans Categorization";
        CustMember: Record Member;
        NoticeRec: Record "Member withdrawal Notice";
        Accredit: Record "Account Credit";
        RepayAcc: Record "Repayment Account";
        LnPostYesNoMgt: Codeunit "Loan Post Mngt. (Yes/No)";
        ProcedureAcc: Record "Account (Procedure)";
        FDText0001: Label 'You Fixed Deposit of ';
        FDText0002: Label ' been processed and posted into your account. ';
        UnsupportedRecordTypeErr: Label 'Action Item %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
    begin
        case Variantext of
            Variantext::Interbank:
                begin
                    InterBankTrans.Reset();
                    InterBankTrans.SetRange("No.", DocNo);
                    if InterBankTrans.FindFirst() then begin
                        InterBankTrans.Posted := true;
                        InterBankTrans."Posted By" := UserId;
                        InterBankTrans."Date Posted" := Today;
                        InterBankTrans."Time Posted" := Time;
                        InterBankTrans."Approval Status" := InterBankTrans."Approval Status"::Posted;
                        InterBankTrans.Modify(true)
                    end;

                end;
            Variantext::Receipt:
                begin
                    ReceiptHeader.Reset();
                    ReceiptHeader.SetRange("No.", DocNo);
                    if ReceiptHeader.FindFirst() then begin
                        ReceiptHeader.CalcFields("Total Amount");

                        MemberCust.Reset();
                        MemberCust.SetRange("No.", ReceiptHeader."Member No.");
                        if MemberCust.FindFirst() then begin
                            Notific.CreateSmsNotif(NotifSource::Receipt, MemberCust."Mobile Phone No", 'Your have done a payment of ' +
                             GenLedger."Local Currency Symbol" + Format(ReceiptHeader."Total Amount") + '. If in dispute call' + ' ' +
                             CompInfo."Phone No.", ReceiptHeader."No.", MemberCust."No.", false);
                        end;

                        ReceiptLine.Reset;
                        ReceiptLine.SetRange(ReceiptLine.No, ReceiptHeader."No.");
                        if ReceiptLine.Find('-') then begin
                            repeat
                                ReceiptLine.ModifyAll(Posted, true);
                                ReceiptLine.ModifyAll("Posted By", UserId);
                                ReceiptLine.ModifyAll("Date Posted", Today);
                                ReceiptLine.ModifyAll("Time Posted", Time);
                                ReceiptLine.ModifyAll(ReceiptLine.Status, ReceiptLine.Status::Posted);
                            until ReceiptLine.Next() = 0;
                        end;

                        ReceiptHeader."Posted By" := UserId;
                        ReceiptHeader.Posted := true;
                        ReceiptHeader."Date Posted" := Today;
                        ReceiptHeader."Time Posted" := Time;
                        ReceiptHeader."Posted By" := UserId;
                        ReceiptHeader."Approval Status" := ReceiptHeader."Approval Status"::Posted;
                        ReceiptHeader.Modify(true);

                    end;
                end;
            Variantext::"Payment Voucher":
                begin
                    PayHeader.Reset();
                    PayHeader.SetRange("No.", DocNo);
                    if PayHeader.FindFirst() then begin
                        PayLine.Reset();
                        PayLine.SetRange(No, PayHeader."No.");
                        if PayLine.FindSet() then begin
                            PayLine.ModifyAll(Posted, true);
                            PayLine.ModifyAll("Posted Date", Today);
                            PayLine.ModifyAll("Posted Time", Time);
                        end;
                        PayHeader.Posted := true;
                        PayHeader."Posted By" := UserId;
                        PayHeader."Posted Date" := Today;
                        PayHeader."Time Posted" := Time;
                        PayHeader."Approval Status" := PayHeader."Approval Status"::Posted;
                        PayHeader.Modify(true)

                    end;
                end;
            Variantext::Checkoff:
                begin
                    CheckHeader.SetRange("No.", DocNo);
                    if CheckHeader.FindFirst() then begin
                        if CheckHeader."Value Post" then begin
                            CheckHeader.Posted := true;
                            CheckHeader."Posted By" := UserId;
                            CheckHeader."Date Posted" := Today;
                            CheckHeader.Modify;
                        end else begin

                            Purchline.Reset;
                            Purchline.SetRange("Account Found", true);
                            Purchline.SetRange("No.", CheckHeader."No.");
                            if Purchline.Find('-') then begin
                                Purchline.ModifyAll("Approval Status", Purchline."Approval Status"::"Pending Approval");
                            end;
                        end;
                    end;
                end;
            Variantext::PostAccount:
                begin
                    Account.SetRange("No.", DocNo);
                    if Account.FindFirst() then begin
                        Notific.CreateSmsNotif(NotifSource::"Fixed Deposit Maturity", Account."Mobile No.",
                            FDText0001 + Format(Account."Balance (LCY)") + FDText0002
                            + Format(Today) + '- ' + Format(Time), Account."No.", Account."No.", false);

                        InterestBuffer.Reset();
                        InterestBuffer.SetRange("Account No", Account."No.");
                        InterestBuffer.ModifyAll(InterestBuffer.Transferred, true);
                        Account.Status := Account.Status::Closed;
                        Account."Approval Status" := Account."Approval Status"::Posted;
                        Account."Fixed Deposit Status" := Account."Fixed Deposit Status"::Closed;
                        Account.Modify(true);
                        RegMngt.CreateFDEntry(Account."No.", Account."Registration Date",
                        Account."Fixed Deposit Type", Account."FD Maturity Date",
                        Account."Neg. Interest Rate", Account."FD Duration",
                        Account."FD Maturity Instructions",
                        Account."Fixed Deposit Amount");
                    end
                end;
            Variantext::Recovery:
                begin
                    RecoveryHeader.SetRange("No.", DocNo);
                    if RecoveryHeader.FindFirst() then begin

                        case RecoveryHeader."Application Type" of
                            RecoveryHeader."Application Type"::"Recovery from Shares":
                                begin
                                    CredAc.Reset();
                                    CredAc.SetRange("Member No.", RecoveryHeader."Account No.");
                                    CredAc.SetRange("Account Category", CredAc."Account Category"::"Shares Deposit");
                                    if CredAc.FindSet() then begin
                                        if Loan.Get(RecoveryHeader."Loan No.") then begin
                                            DocMngt.CreateRecovLine(CredAc."No.",
                                            CredAc."Member No.",
                                            RecoveryHeader."Shares Deposits",
                                            Loan."Approved Amount",
                                            RecoveryHeader."Outstanding Interest",
                                            RecoveryHeader."Outstanding Principal",
                                            Loan."Product Type", RecoveryHeader."Shares Deductable",
                                            2, Loan."No.", RecoveryHeader."No.");
                                        end;
                                    end;
                                end;
                            RecoveryHeader."Application Type"::"Fosa Recovery":
                                begin
                                    AccountBanking.Reset();
                                    AccountBanking.SetRange("No.", RecoveryHeader."Account to Debit");
                                    if AccountBanking.FindFirst() then begin
                                        if Loan.Get(RecoveryHeader."Loan No.") then begin
                                            DocMngt.CreateRecovLine(AccountBanking."No.",
                                            RecoveryHeader."Account No.",
                                            Purchline.Amount,
                                            Loan."Approved Amount",
                                            RecoveryHeader."Outstanding Interest",
                                            RecoveryHeader."Outstanding Principal",
                                            Loan."Product Type", RecoveryHeader."Shares Deductable",
                                            1, Loan."No.", RecoveryHeader."No.");
                                        end;
                                    end;
                                end;

                            RecoveryHeader."Application Type"::"Recover from guarantors":
                                begin
                                    Recoveryline.Reset();
                                    Recoveryline.SetRange(No, RecoveryHeader."No.");
                                    if Recoveryline.FindSet() then begin
                                        repeat
                                            CreateLonRecvMngt(RecoveryHeader, Recoveryline."Shares Deposit", Recoveryline.Amount);
                                        until Recoveryline.Next() = 0;
                                    end;
                                end;
                        end;

                        if CustMember.Get(RecoveryHeader."Account No.") then begin
                            CustMember."Loan Status" := CustMember."Loan Status"::Defaulter;
                            CustMember.Modify(true)
                        end;

                        Ploan.Reset();
                        Ploan.SetRange("No.", RecoveryHeader."Loan No.");
                        if Ploan.FindFirst() then begin
                            Ploan."Performance Indicator" := Ploan."Performance Indicator"::"Defaulted Account";
                            Ploan.Modify(true);
                        end;

                        Recoveryline.Reset;
                        Recoveryline.SetRange(No, RecoveryHeader."No.");
                        Recoveryline.SetRange("Default Account No.", RecoveryHeader."Account No.");
                        if Recoveryline.FindSet() then begin

                            Recoveryline.ModifyAll(Posted, true);
                            Recoveryline.ModifyAll("Posted By", UserId);
                            Recoveryline.ModifyAll("Date Posted", Today);
                            Recoveryline.ModifyAll("Time Posted", Time);
                        end;

                        RecoveryHeader.Posted := true;
                        RecoveryHeader."Posted By" := UserId;
                        RecoveryHeader."Approval Status" := RecoveryHeader."Approval Status"::Posted;
                        RecoveryHeader."Date Posted" := Today;
                        RecoveryHeader.Modify(true);
                    end;
                end;
            Variantext::"Account Closure":
                begin

                    AccountClosure.Reset();
                    AccountClosure.SetRange("No.", DocNo);
                    if AccountClosure.FindFirst() then begin

                        case AccountClosure."Document Type" of
                            AccountClosure."Document Type"::"Account Closure":
                                begin

                                    Accredit.Reset();
                                    Accredit.SetRange("No.", AccountClosure."Account No.");
                                    if Accredit.FindFirst() then begin
                                        Accredit.Blocked := Accredit.Blocked::All;
                                        Accredit."Withdrawal Date" := Today;
                                        Accredit.Status := Accredit.Status::Closed;
                                        Accredit.Modify(true)

                                    end else begin

                                        AccountBanking.Reset();
                                        AccountBanking.SetRange("No.", AccountClosure."Account No.");
                                        AccountBanking.SetFilter("Account Category", '<>%1', AccountBanking."Account Category"::Savings);
                                        if AccountBanking.FindFirst() then begin
                                            AccountBanking.Blocked := AccountBanking.Blocked::All;
                                            AccountBanking."Withdrawal Date" := Today;
                                            AccountBanking.Status := AccountBanking.Status::Closed;
                                            AccountBanking.Modify(true)
                                        end;
                                    end;
                                end;
                            AccountClosure."Document Type"::"Membership Closure":
                                begin

                                    case AccountClosure."Closure Type" of
                                        AccountClosure."Closure Type"::"Withdrawal - Normal":
                                            begin

                                                AccountBanking.Reset();
                                                AccountBanking.SetRange("Member No.", AccountClosure."Member No.");
                                                if AccountBanking.FindFirst() then begin
                                                    AccountBanking.ModifyAll(Blocked, AccountBanking.Blocked::All);
                                                    AccountBanking.ModifyAll("Withdrawal Date", Today);
                                                    AccountBanking.ModifyAll(Status, AccountBanking.Status::Withdrawn);
                                                end;


                                                ProcedureAcc.Reset();
                                                ProcedureAcc.SetRange("Member No.", AccountClosure."Member No.");
                                                if ProcedureAcc.FindFirst() then begin
                                                    ProcedureAcc."Card Status" := ProcedureAcc."Card Status"::Rejected;
                                                    ProcedureAcc.ModifyAll(Blocked, ProcedureAcc.Blocked::All);
                                                    ProcedureAcc.ModifyAll(Status, ProcedureAcc.Status::Withdrawn);
                                                    ProcedureAcc."Mobile Transaction Status" := ProcedureAcc."Mobile Transaction Status"::Deactived;
                                                end;

                                                RepayAcc.Reset();
                                                RepayAcc.SetRange("Member No.", AccountClosure."Member No.");
                                                if RepayAcc.FindFirst() then begin
                                                    RepayAcc.ModifyAll(Blocked, RepayAcc.Blocked::All);
                                                    RepayAcc.ModifyAll(Status, RepayAcc.Status::Withdrawn);
                                                end;

                                                Accredit.Reset();
                                                Accredit.SetRange("Member No.", AccountClosure."Member No.");
                                                if Accredit.FindFirst() then begin
                                                    Accredit.ModifyAll("Withdrawal Date", Today);
                                                    Accredit.ModifyAll(Blocked, Accredit.Blocked::All);
                                                    Accredit.ModifyAll(Status, Accredit.Status::Withdrawn);
                                                end;
                                                if CustMember.Get(AccountClosure."Member No.") then begin
                                                    CustMember.Blocked := CustMember.Blocked::All;
                                                    CustMember."Withdrawal Date" := Today;
                                                    CustMember.Status := CustMember.Status::Withdrawn;
                                                    CustMember.Modify(true)
                                                end;

                                            end;
                                        AccountClosure."Closure Type"::"Withdrawal - Death":
                                            begin
                                                AccountBanking.Reset();
                                                AccountBanking.SetRange("Member No.", AccountClosure."Member No.");
                                                if AccountBanking.FindFirst() then begin
                                                    AccountBanking.ModifyAll(Blocked, AccountBanking.Blocked::All);
                                                    AccountBanking.ModifyAll("Withdrawal Date", Today);
                                                    AccountBanking.ModifyAll(Status, AccountBanking.Status::Deceased);
                                                end;

                                                ProcedureAcc.Reset();
                                                ProcedureAcc.SetRange("Member No.", AccountClosure."Member No.");
                                                if ProcedureAcc.FindFirst() then begin
                                                    ProcedureAcc."Card Status" := ProcedureAcc."Card Status"::Rejected;
                                                    ProcedureAcc.ModifyAll(Blocked, ProcedureAcc.Blocked::All);
                                                    ProcedureAcc.ModifyAll(Status, ProcedureAcc.Status::Deceased);
                                                    ProcedureAcc."Mobile Transaction Status" := ProcedureAcc."Mobile Transaction Status"::Deactived;
                                                end;

                                                RepayAcc.Reset();
                                                RepayAcc.SetRange("Member No.", AccountClosure."Member No.");
                                                if RepayAcc.FindFirst() then begin
                                                    RepayAcc.ModifyAll(Blocked, RepayAcc.Blocked::All);
                                                    RepayAcc.ModifyAll(Status, RepayAcc.Status::Deceased);
                                                end;

                                                Accredit.Reset();
                                                Accredit.SetRange("Member No.", AccountClosure."Member No.");
                                                if Accredit.FindFirst() then begin
                                                    Accredit.ModifyAll("Withdrawal Date", Today);
                                                    Accredit.ModifyAll(Blocked, Accredit.Blocked::All);
                                                    Accredit.ModifyAll(Status, Accredit.Status::Deceased);
                                                end;

                                                if CustMember.Get(AccountClosure."Member No.") then begin
                                                    CustMember.Blocked := CustMember.Blocked::All;
                                                    CustMember."Withdrawal Date" := Today;
                                                    CustMember.Status := CustMember.Status::Deceased;
                                                    CustMember.Modify(true)
                                                end;
                                            end;
                                    end;
                                end;
                        end;

                        NoticeRec.Reset();
                        NoticeRec.SetRange("No.", AccountClosure."No.");
                        if NoticeRec.FindFirst() then begin
                            NoticeRec.Paid := true;
                            NoticeRec."Approval Status" := NoticeRec."Approval Status"::Posted;
                            NoticeRec.Modify(true)
                        end;

                        MonthlyContrib.Reset();
                        MonthlyContrib.SetRange("Account No.", AccountClosure."Member No.");
                        if MonthlyContrib.FindSet() then begin
                            MonthlyContrib.ModifyAll(Amount, 0);
                            MonthlyContrib.ModifyAll("Advise Type", MonthlyContrib."Advise Type"::Stoppage);
                        end;
                        if CustMember.Get(AccountClosure."Member No.") then begin
                            Notific.CreateSmsNotif(NotifSource::Other,
                                CustMember."Mobile Phone No", 'Dear ' + CustMember."First Name" +
                                ', your membership withdrawal has been processed. Consider rejoining again. ',
                                AccountClosure."No.", CustMember."No.", false);
                        end;
                        AccountClosure.Posted := true;
                        AccountClosure."Posted By" := UserId;
                        AccountClosure."Time Posted" := Time;
                        AccountClosure."Date Posted" := Today;
                        AccountClosure."Approval Status" := AccountClosure."Approval Status"::Posted;
                        AccountClosure.Modify(true)
                    end;
                end;
        end;

    end;

    procedure fnJournalPreviewMngt(Variantext: Enum CustomApprovalEntriesDocType; DocNo: Code[100]; RecJournalTemplate: Code[20]; RecJournalBatch: Code[20])
    var
        JournalLine: Record "Gen. Journal Line";

    begin

        JournalLine.Reset();
        JournalLine.SetRange("Document No.", DocNo);
        JournalLine.SetRange("Journal Batch Name", RecJournalBatch);
        JournalLine.SetRange("Journal Template Name", RecJournalTemplate);
        if JournalLine.Find('-') then
            Page.Run(Page::"Journal Test Batch", JournalLine, JournalLine."Document No.");

    end;

    local procedure CreateLonRecvMngt(var RecoveryHeader: Record "Recovery Header"; ShareDeposit: Decimal; Amt: Decimal)
    var
        Loan: Record Loans;
    begin

        if Loan.Get(RecoveryHeader."Loan No.") then begin
            DocMngt.CreateRecovLine(Loan."Account No.",
            Loan."Account No.", ShareDeposit, Loan."Approved Amount",
            RecoveryHeader."Outstanding Interest", RecoveryHeader."Outstanding Principal",
            Loan."Product Type", Amt, 3, Loan."No.", RecoveryHeader."No.");
        end;

    end;


    var
        PaymentHeader: Record "Payments Header";
        PaymentLine: Record "Payment Lines";
        ReceiptHeader: Record "Receipts Header";
        TarriffCodes: Record "Tariff Codes";
        ImprestHeader: Record "Imprest Header";
        DocMngt: Codeunit "Doc-PostMgt";
        GenLedger: Record "General Ledger Setup";
        InterBankTransfer: Record "Interbank Transfer";
        Gensetup: Record "General Set-Up";
        CompInfo: Record "Company Information";
        ExciseDutyGL: Code[10];
        ExciseDutyPerc: Code[10];
        Temp: Record "Cash Office User Template";
        CashOfficeSetup: Record "Cash Management Setups";
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record "Receipt Line";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        ProdFact: Record "Product Factory";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        LineNo: Integer;
        Dim1: Code[10];
        Dim2: Code[10];
        JTemplate: Code[20];
        JBatch: Code[20];
        ApprovlsMgt: Codeunit "Approval Mgmt.";
        CustomDocType: Enum CustomApprovalEntriesDocType;
        UserMgt: Codeunit "User Setup Management BR";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        BnkProcMngt: Codeunit "Banking Procedure Mngt.";
        RegMngt: Codeunit "Register Management";
        OncompleteDialog: Label 'Application sucessfully Posted';
        Text016: Label 'You cannot Post %1-%2 because there is at least one posted entry related to this transaction.';


}
