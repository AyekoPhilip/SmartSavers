codeunit 50040 "Banking Procedure Mngt."
{

    trigger OnRun()
    begin
    end;

    var
        Temp: Record "Banking User Template";
        Jtemplate: Code[10];
        JBatch: Code[10];
        Text000011: Label 'EFT File No. %1 already generated';
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        OnConfirmReversalMsg: label 'This action will mark this record as Reversed. Are you sure you want to continue?';
        Loans: Record Loans;
        RunBal: Decimal;

        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        BalAccountType: Enum "Gen. Journal Account Type";
        GenJLine: Record "Gen. Journal Line";
        Post: Boolean;
        JournlPosted: Codeunit "Jnl Mngt. Post Successful";
        Gensetup: Record "General Set-Up";
        STORegister: Record "Standing Order Register";
        SendSMS: Codeunit "SMS Notification";
        SourceType: Enum NotifSourceType;
        SavingsAcc: Record "Account Banking";
        AccTypes: Enum "Gen. Journal Account Type";
        AccNo: Code[20];
        Genrating: Label 'Posting Salaries';
        CreateNotif: Codeunit "SMS Notification";
        ApprovalMgmt: Codeunit "Approval Mgmt.";
        VarVariant: Variant;
        DocMngt: Codeunit "Doc. Mngt";
        JnlPost: Codeunit "Journal Post Mngt.";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        FixedDepType: Record "Fixed Deposit Type";
        FDInterestCalc: Record "FD Interest Calculation Rules";
        FDType: Record "Fixed Deposit Type";
        InterestBuffer: Record "Interest Buffer";
        Text0001: Label 'Your Fixed deposit of ';
        Text0002: Label 'has matured and transfered to your savings account ';
        DivMngt: Codeunit "Dividend Process";
        DividendProgression: Record "Dividend Progression";
        DividendSetUp: Record "Dividend SetUp";
        StartDate: Date;
        EndDate: Date;
        TransChargeCode: Code[10];
        DivDiscount: Boolean;
        DefaulterRecov: Boolean;
        LoanArrear: Boolean;
        DivCapitalize: Boolean;
        Ploan: Record "Loans Categorization";
        ActiveLoan: Record Loans;

    procedure PostTCIssue(TCTrans: Record "Treasury Cashier Transaction")
    var
        Text0004: Label 'The money has already been issued.';
        BankingSetup: Record "Banking User Template";
        Text0005: Label 'You do not have permission to transact on this teller till/Account.';
        Banks: Record "Bank Account";
        BankBal: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        Temp: Record "Banking User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        TillNo: Code[20];
        DBranch: Code[20];
        DActivity: Code[20];
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
        Text0003: Label 'Ensure the Default Bank is set up in User Setup';
        UserSetup: Record "User Setup";
        Text0007: Label 'Please specify an amount greater than zero.';
        ToAccount: Code[20];
        FromAccount: Code[20];
        Text0008: Label 'Coinage Amount must be equal to the amount';
    begin

        Temp.Get(UserId);
        Temp.TestField("Treasury Journal Template");
        Temp.TestField("Treasury Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Responsibility Centre");

        JTemplate := Temp."Treasury Journal Template";
        JBatch := Temp."Treasury Journal Batch";
        TillNo := Temp."Default  Bank";

        CheckTillCurrency(TillNo, TCTrans."Currency Code");

        UserSetup.get(UserId);
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Global Dimension 1 Code");
        DBranch := UserSetup."Global Dimension 2 Code";
        DActivity := UserSetup."Global Dimension 1 Code";


        TCTrans.TestField(Amount);
        TCTrans.TestField("From Account");
        TCTrans.TestField("To Account");

        if TCTrans.Amount <= 0 then
            Error(Text0007);

        if (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Issue To Teller") or
        (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Return To Treasury") or
        (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Inter Teller Transfers") or
        (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Branch Treasury Transactions") or
        (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"End of Day Return to Treasury")
         then begin

            TCTrans.TestField(Issued, TCTrans.Issued::No);

            BankingSetup.Reset;
            BankingSetup.SetRange(BankingSetup."Account ID", TCTrans."From Account");
            if BankingSetup.Find('-') then begin
                if UpperCase(UserId) <> BankingSetup."Account ID" then
                    Error(Text0005);
            end;

            if Confirm('Are you sure you want to make this issue?', false) = true then begin
                TCTrans.Issued := TCTrans.Issued::Yes;
                TCTrans."Date Issued" := Today;
                TCTrans."Time Issued" := Time;
                TCTrans."Issued By" := UpperCase(UserId);
                TCTrans.Modify;
            end;
            Message('Money successfully issued/Returned.');
        end else

            if TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Return To Bank" then begin
                TCTrans.TestField(Amount);
                TCTrans.TestField("From Account");
                TCTrans.TestField("To Account");

                BankingSetup.Reset;
                BankingSetup.SetRange(BankingSetup."Account ID", TCTrans."From Account");
                if BankingSetup.Find('-') then begin
                    FromAccount := BankingSetup."Default  Bank";
                end;
                ToAccount := TCTrans."To Account";

                Banks.Reset;
                Banks.SetRange(Banks."No.", TCTrans."From Account");
                if Banks.Find('-') then begin
                    Banks.CalcFields("Balance (LCY)");
                    if TCTrans.Amount > Banks."Balance (LCY)" then
                        Error('You cannot receive more than balance in ' + TCTrans."From Account")
                end;


                if Confirm('Are you sure you want to make this return?', false) = false then
                    exit;
                JnlPost.ClearJournalLines(JTemplate, JBatch);
                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := JTemplate;
                GenJournalLine."Journal Batch Name" := JBatch;
                GenJournalLine."Document No." := TCTrans.No;
                GenJournalLine."External Document No." := TCTrans."External Document No.";
                GenJournalLine."Line No." := 10000;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                GenJournalLine."Account No." := FromAccount;
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine.Description := TCTrans.Description;
                GenJournalLine."Currency Code" := TCTrans."Currency Code";
                GenJournalLine.Validate(GenJournalLine."Currency Code");
                GenJournalLine.Amount := -TCTrans.Amount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine."Bal. Account No." := ToAccount;
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                GenJournalLine.Reset;
                GenJournalLine.SetRange(GenJournalLine."Journal Template Name", JTemplate);
                GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", JBatch);
                if GenJournalLine.Find('-') then
                    Post := false;
                Post := JournlPosted.PostedSuccessfully();

                TCTrans.Posted := true;
                TCTrans."Date Posted" := Today;
                TCTrans."Time Posted" := Time;
                TCTrans."Posted By" := UpperCase(UserId);
                TCTrans.Received := TCTrans.Received::Yes;
                TCTrans."Date Received" := Today;
                TCTrans."Time Received" := Time;
                TCTrans."Received By" := UpperCase(UserId);
            end else
                Message('Only applicable for teller, treasury & Bank Issues/Returns.');
    end;


    procedure PostTCReceive(TCTrans: Record "Treasury Cashier Transaction")
    var
        CurrentTellerAmount: Decimal;
        BankingSetup: Record "Banking User Template";
        Banks: Record "Bank Account";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Temp: Record "Banking User Template";
        JTemplate: Code[20];
        JBatch: Code[20];
        TillNo: Code[20];
        DBranch: Code[20];
        DActivity: Code[20];
        UserSetup: Record "User Setup";
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
        Text0003: Label 'Ensure the Default Bank is set up in User Setup';
        Text0007: Label 'Please specify an amount greater than zero.';
        ToAccount: Code[20];
        FromAccount: Code[20];
        ShortageAcc: Code[20];
        ExcessAcc: Code[20];
    begin

        Temp.Get(UserId);
        Temp.TestField("Treasury Journal Template");
        Temp.TestField("Treasury Journal Batch");
        Temp.TestField("Default  Bank");

        JTemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";
        TillNo := Temp."Default  Bank";

        CheckTillCurrency(TillNo, TCTrans."Currency Code");

        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UpperCase(UserId));
        if UserSetup.Find('-') then begin
            UserSetup.TestField("Global Dimension 1 Code");
            UserSetup.TestField("Global Dimension 2 Code");
            DBranch := UserSetup."Global Dimension 2 Code";
            DActivity := UserSetup."Global Dimension 1 Code";

        end;

        TCTrans.TestField(Amount);
        TCTrans.TestField("From Account");
        TCTrans.TestField("To Account");

        if TCTrans.Amount <= 0 then
            Error(Text0007);


        if TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Issue From Bank" then begin
            TCTrans.TestField("External Document No.");

            BankingSetup.Reset;
            BankingSetup.SetRange(BankingSetup."Account ID", TCTrans."To Account");
            if BankingSetup.Find('-') then begin
                ToAccount := BankingSetup."Default  Bank";
            end;
            FromAccount := TCTrans."From Account";

        end;
        CurrentTellerAmount := 0;

        if TCTrans.Posted then
            Error('The transaction has already been received and posted.');


        if (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Issue To Teller") or
           (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Branch Treasury Transactions") or
          (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Return To Treasury") or
          (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"End of Day Return to Treasury") or
           (TCTrans."Transaction Type" = TCTrans."Transaction Type"::"Inter Teller Transfers")

           then begin
            if TCTrans.Issued = TCTrans.Issued::No then
                Error('The issue has not yet been made and therefore you cannot continue with this transaction.');
            BankingSetup.Reset;
            BankingSetup.SetRange(BankingSetup."Account ID", TCTrans."To Account");
            if BankingSetup.Find('-') then begin
                ToAccount := BankingSetup."Default  Bank";

                case TCTrans."Transaction Type" of
                    TCTrans."Transaction Type"::"Issue To Teller",
                    TCTrans."Transaction Type"::"Inter Teller Transfers":
                        begin

                            Banks.Reset;
                            Banks.SetRange(Banks."No.", ToAccount);
                            if Banks.Find('-') then begin
                                Banks.CalcFields(Banks."Balance (LCY)");
                                CurrentTellerAmount := Banks."Balance (LCY)";
                                if CurrentTellerAmount + TCTrans.Amount > BankingSetup."Max. Cashier Withholding" then
                                    Error('The transaction will result in the teller having a balance more than the maximum allowable therefor terminated.');
                            end;
                        end;
                end;
            end;

            BankingSetup.Reset;
            BankingSetup.SetRange(BankingSetup."Account ID", TCTrans."From Account");
            if BankingSetup.Find('-') then begin
                BankingSetup.TestField("Excess Account");
                BankingSetup.TestField("Shortage Account");
                FromAccount := BankingSetup."Default  Bank";
                ExcessAcc := BankingSetup."Excess Account";
                ShortageAcc := BankingSetup."Shortage Account";
            end;
        end;
        if Confirm('Are you sure you want to make this receipt?', false) = false then exit;

        GenJournalLine.Reset;
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", JTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", JBatch);
        GenJournalLine.DeleteAll;


        //Posting Excess
        if TCTrans.Type = TCTrans.Type::Excess then begin

            LineNo += 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := JTemplate;
            GenJournalLine."Journal Batch Name" := JBatch;
            GenJournalLine."Document No." := TCTrans.No;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
            GenJournalLine."Account No." := FromAccount;
            GenJournalLine."External Document No." := TCTrans."External Document No.";
            GenJournalLine."Posting Date" := Today;
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine.Description := 'Excess From Cashier';
            GenJournalLine."Currency Code" := TCTrans."Currency Code";
            GenJournalLine.Validate(GenJournalLine."Currency Code");
            GenJournalLine.Amount := TCTrans."Excess/Shortage Amount";
            GenJournalLine.Validate(GenJournalLine.Amount);
            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine.Validate("Bal. Account No.", ExcessAcc);
            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert(true);
        end;
        //Posting Excess

        //Posting Shortage
        if TCTrans.Type = TCTrans.Type::Shortage then begin

            LineNo += 10000;
            GenJournalLine.Init;
            GenJournalLine."Journal Template Name" := JTemplate;
            GenJournalLine."Journal Batch Name" := JBatch;
            GenJournalLine."Document No." := TCTrans.No;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
            GenJournalLine."Account No." := FromAccount;
            GenJournalLine."External Document No." := TCTrans."External Document No.";
            GenJournalLine."Posting Date" := Today;
            GenJournalLine.Validate(GenJournalLine."Account No.");
            GenJournalLine.Description := 'Shortage From Cashier';
            GenJournalLine."Currency Code" := TCTrans."Currency Code";
            GenJournalLine.Validate(GenJournalLine."Currency Code");
            GenJournalLine.Amount := TCTrans."Excess/Shortage Amount" * -1;
            GenJournalLine.Validate(GenJournalLine.Amount);
            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
            GenJournalLine.Validate("Bal. Account No.", ShortageAcc);
            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
            GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
            GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert(true);
        end;
        //Posting Shortage

        LineNo += 10000;
        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := JTemplate;
        GenJournalLine."Journal Batch Name" := JBatch;
        GenJournalLine."Document No." := TCTrans.No;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine."Account No." := FromAccount;
        GenJournalLine."External Document No." := TCTrans."External Document No.";
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine.Description := TCTrans.Description;
        GenJournalLine."Currency Code" := TCTrans."Currency Code";
        GenJournalLine.Validate(GenJournalLine."Currency Code");
        case TCTrans.Type of
            TCTrans.Type::" ":
                GenJournalLine.Amount := -TCTrans.Amount;
            TCTrans.Type::Shortage:
                GenJournalLine.Amount := -(TCTrans."Till/Treasury Balance" - TCTrans."Excess/Shortage Amount");
            TCTrans.Type::Excess:
                GenJournalLine.Amount := -(TCTrans."Till/Treasury Balance" + TCTrans."Excess/Shortage Amount")
        end;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
        GenJournalLine."Bal. Account No." := ToAccount;
        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
        GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        GenJournalLine.Reset;
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", JTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", JBatch);
        if GenJournalLine.Find('-') then
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJournalLine);

        Post := false;
        Post := JournlPosted.PostedSuccessfully();
        TCTrans.Posted := true;
        TCTrans."Date Posted" := Today;
        TCTrans."Time Posted" := Time;
        TCTrans."Posted By" := UpperCase(UserId);
        TCTrans.Received := TCTrans.Received::Yes;
        TCTrans."Date Received" := Today;
        TCTrans."Time Received" := Time;
        TCTrans."Received By" := UpperCase(UserId);
        TCTrans.Modify;
    end;

    procedure ClearCheques(Transactions: Record "Teller Transaction")
    var
        TellMngt: Codeunit "Teller-Post (Yes/No)";
    begin
        if Transactions."Expected Maturity Date" <= Today then begin
            case Transactions.Type of
                Transactions.Type::"Cheque Deposit":
                    begin
                        Transactions."Cheque Status" := Transactions."Cheque Status"::Honoured;
                        Transactions."Date Cleared" := Today;
                        Transactions."Cleared By" := UserId;
                        Transactions.Modify(true);
                    end;
                Transactions.Type::"Credit Cheque":
                    begin
                        TellMngt.PerformPostCreditCheque(
                        Transactions, Transactions."Journal Template Name",
                        Transactions."Journal Batch Name", '',
                        Transactions."Global Dimension 2 Code",
                        Transactions."Global Dimension 1 Code");
                    end;
            end
        end;
    end;

    procedure MarkChequeAsReversed(CashierTrans: Record "Teller Transaction")
    var
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
        GenJournalLine: Record "Gen. Journal Line";
        ChargeAmount: Decimal;
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TChargeAmount: Decimal;
        TransType: Record "Transaction Types";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        ExciseDuty: Decimal;
        VendLedgerEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        if TellerMngt.TestNoReversedEntriesExist(CashierTrans."Account Name", CashierTrans."No.", 2) then begin
            CashierTrans."Cheque Status" := CashierTrans."Cheque Status"::Reversed;
            CashierTrans."Date Cleared" := Today;
            CashierTrans."Cleared By" := UserId;
            CashierTrans.Modify;
        end;
    end;

    procedure MarkLoanAsReversed(Loan: Record Loans)
    var
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
        GenJournalLine: Record "Gen. Journal Line";
        ChargeAmount: Decimal;
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TChargeAmount: Decimal;
        TransType: Record "Transaction Types";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        ExciseDuty: Decimal;
        VendLedgerEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        if confirm(OnConfirmReversalMsg, true) = false then exit;
        if TellerMngt.TestNoReversedEntriesExist(Loan."Account Name", Loan."No.", 3) then begin
            Loan."Loan Status" := Loan."Loan Status"::Reversed;

            Loan.Modify(true)
        end else begin
            error('No Reversed entry found on this entry')
        end;
    end;

    procedure StopCheque(CashierTrans: Record "Teller Transaction")
    var
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
        GenJournalLine: Record "Gen. Journal Line";
        ChargeAmount: Decimal;
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TChargeAmount: Decimal;
        TransType: Record "Transaction Types";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        PFact: Record "Product Factory";
        ExciseDuty: Decimal;
    begin

        Temp.Get(UserId);
        Temp.TestField("Cashier Journal Template");
        Temp.TestField("Cashier Journal Batch");

        Gensetup.Get;
        Gensetup.TestField("Excise Duty (%)");
        Gensetup.TestField("Excise Duty G/L");

        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";

        if CashierTrans.Type <> CashierTrans.Type::"Cheque Deposit" then
            Error('Only applicable to cheques');

        if CashierTrans."Cheque Status" <> CashierTrans."Cheque Status"::Pending then
            Error('Cheque already processed.');

        if TellerMngt.CalcAvailableBal(CashierTrans."Account No.") < 0 then
            error('No enough amount to enable this transaction. Kindly Place a Lien to effect this transaction.');

        if Confirm('Are you sure you want to stop the Cheque? reversal charges will apply', true) = false then
            exit;

        JnlPostMngt.ClearJournalLines(Jtemplate, JBatch);
        ExciseDuty := 0;

        //Reverse Entry
        LineNo := LineNo + 10000;

        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := Jtemplate;
        GenJournalLine."Journal Batch Name" := JBatch;
        GenJournalLine."Document No." := CashierTrans."No.";
        GenJournalLine."External Document No." := CashierTrans."Cheque No";
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine."Account No." := CashierTrans."Account No.";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := 'Unpaid Cheque Reversal';
        GenJournalLine.Validate(GenJournalLine."Currency Code");
        GenJournalLine.Amount := CashierTrans.Amount;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := CashierTrans."Global Dimension 1 Code";
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine."Shortcut Dimension 2 Code" := CashierTrans."Global Dimension 2 Code";
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        LineNo := LineNo + 10000;

        GenJournalLine.Init;
        GenJournalLine."Journal Template Name" := Jtemplate;
        GenJournalLine."Journal Batch Name" := JBatch;
        GenJournalLine."Document No." := CashierTrans."No.";
        GenJournalLine."External Document No." := CashierTrans."Cheque No";
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine."Account No." := CashierTrans."Bank Account";
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Posting Date" := Today;
        GenJournalLine.Description := CopyStr(CashierTrans."Member No." + ' ' + CashierTrans."Account Name", 1, 30);
        GenJournalLine.Validate(GenJournalLine."Currency Code");
        GenJournalLine.Amount := -CashierTrans.Amount;
        GenJournalLine.Validate(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := CashierTrans."Global Dimension 1 Code";
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine."Shortcut Dimension 2 Code" := CashierTrans."Global Dimension 2 Code";
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert;

        TCharges := 0;

        TransType.Reset;
        TransType.SetRange(TransType.Type, TransType.Type::"Bounced Cheque");
        if TransType.Find('-') then begin


            TransactionCharges.Reset;
            TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransType.Code);
            if TransactionCharges.Find('-') then begin
                repeat

                    if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                    (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                        LineNo := LineNo + 10000;

                        ChargeAmount := 0;
                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                            ChargeAmount := (CashierTrans.Amount * TransactionCharges."Percentage of Amount") * 0.01
                        else
                            ChargeAmount := TransactionCharges."Charge Amount";

                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                            TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                            TariffDetails.Reset;
                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                            if TariffDetails.Find('-') then begin
                                repeat
                                    if (CashierTrans.Amount >= TariffDetails."Lower Limit") and (CashierTrans.Amount <= TariffDetails."Upper Limit") then begin
                                        if TariffDetails."Use Percentage" = true then begin
                                            ChargeAmount := CashierTrans.Amount * TariffDetails.Percentage * 0.01;
                                        end else begin
                                            ChargeAmount := TariffDetails."Charge Amount";
                                        end;
                                    end;
                                until TariffDetails.Next = 0;
                            end;
                        end;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Document No." := CashierTrans."No.";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."Account No." := CashierTrans."Account No.";
                        GenJournalLine."External Document No." := CashierTrans."ID No";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := CashierTrans."Transaction Date";
                        GenJournalLine.Description := TransactionCharges.Description;
                        GenJournalLine."Currency Code" := CashierTrans."Currency Code";
                        GenJournalLine.Validate(GenJournalLine."Currency Code");
                        GenJournalLine.Amount := ChargeAmount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := TransactionCharges."G/L Account";
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := CashierTrans."Global Dimension 1 Code";
                        GenJournalLine."Shortcut Dimension 2 Code" := CashierTrans."Global Dimension 2 Code";
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        if (TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty")
                          and (TransactionCharges."Recover Excise Duty" = true) then begin

                            LineNo := LineNo + 10000;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Document No." := CashierTrans."No.";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine."Account No." := CashierTrans."Account No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := CashierTrans."Transaction Date";
                            GenJournalLine.Description := 'Excise Duty';
                            GenJournalLine."Currency Code" := CashierTrans."Currency Code";
                            GenJournalLine.Validate(GenJournalLine."Currency Code");
                            GenJournalLine.Amount := ChargeAmount * (Gensetup."Excise Duty (%)" * 0.01);
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            ExciseDuty := GenJournalLine.Amount;
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := Gensetup."Excise Duty G/L";
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := CashierTrans."Global Dimension 1 Code";
                            GenJournalLine."Shortcut Dimension 2 Code" := CashierTrans."Global Dimension 2 Code";
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                            TChargeAmount := TChargeAmount + ChargeAmount;
                        end;

                    end;
                until TransactionCharges.Next = 0;
            end;
        end;
        if PFact.Get(CashierTrans."Product Type") then
            PFact.TestField("Minimum Balance");

        if TellerMngt.CalcAvailableBal(CashierTrans."Account No.") > (ChargeAmount + ExciseDuty) then begin
            JnlPostMngt.CompletePosting(Jtemplate, JBatch);
            CashierTrans."Cheque Status" := CashierTrans."Cheque Status"::Stopped;
            CashierTrans."Date Cleared" := Today;
            CashierTrans."Cleared By" := UserId;
            CashierTrans.Modify;
        end else begin
            error('No enough amount to enable this transaction. Kindly Place a Lien to effect this transaction.')
        end;
    end;

    procedure CheckTillCurrency(BankAcc: Code[20]; CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
    begin
        BankAcct.Reset;
        BankAcct.SetRange(BankAcct."No.", BankAcc);
        if BankAcct.Find('-') then begin
            if BankAcct."Currency Code" <> CurrCode then begin
                if BankAcct."Currency Code" = '' then
                    Error('This bank [%1:- %2] can only transact in LOCAL Currency', BankAcct."No.", BankAcct.Name)
                else
                    Error('This bank [%1:- %2] can only transact in %3', BankAcct."No.", BankAcct.Name, BankAcct."Currency Code");
            end;
        end;
    end;

    local procedure CheckBankersNo(ChequeNo: Code[20]; GlobalDim2: Code[20]; TAmount: Decimal)
    var
        Bregister: Record "Bankers Cheques Register";
    begin
        Bregister.Reset;
        Bregister.SetRange(Bregister.Status, Bregister.Status::Pending);
        Bregister.SetRange(Bregister."Global Dimension 2 Code", GlobalDim2);
        Bregister.SetRange(Bregister."Cheque No.", ChequeNo);
        if Bregister.Find('-') = false then
            Error('Bankers cheque no has already been used');

        Bregister.Reset;
        Bregister.SetRange(Bregister.Status, Bregister.Status::Pending);
        Bregister.SetRange(Bregister."Global Dimension 2 Code", GlobalDim2);
        Bregister.SetRange(Bregister."Cheque No.", ChequeNo);
        if Bregister.Find('-') then begin
            if Bregister."Leaf Limit Amount" < TAmount then
                Error('Bankers cheque amount cannot be more than the leaf limit of %1', Bregister."Leaf Limit Amount");
        end;
    end;


    procedure PostTransfers(ACTransfer: Record "Account Transfer Header"; ValuePosting: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
        BSched: Record "Account Transfer Source";
        BSchedDestin: Record "Account Transfer Destination";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        AccBanking: Record "Account Banking";
        AccountTypes: Record "Product Factory";
        SendSMS: Codeunit "SMS Notification";
        Text0003: Label 'A fund Transfer of';
        Text0005: Label ' has been effected on your account at ';
        AccSource: Record "Account Credit";
        AccDestination: Record "Account Credit";
        CustMember: Record Member;
        JuniorTransType: Code[10];
        CustomerEntry: Record Customer;
        RegistryMngt: Codeunit "Register Management";
        CustAccType: Enum CustAccountType;
        ProdFact: Record "Product Factory";
        AccCred: Record "Account Credit";
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        TempFile: Record "Temp. Files";
        AccruedInt: Decimal;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        TotalCharge: Decimal;
        LoanCharges: Record "Loan Product Charges";
        Text0008: Label 'No enough funds for this transaction';
        ErrorOnNonDebitAmt: Label 'Total Credits of %1 must be equal to Total Debits of %2';
        ErroroOnCharge: Label 'No Charge type found associated with this account. Confirm with administrator to setup the charge';
        ErrorOnLastWithdrawalTxt: Label 'Member last withdrawal date was %1. The next withdrawal date must be on or after %2';

    begin

        AcTransfer.TestField(Posted, false);
        AcTransfer.TestField(Remarks);

        if ValuePosting = 1 then
            AcTransfer.TestField(Status, AcTransfer.Status::Approved);
        ACTransfer.TestField(Remarks);

        Temp.GET(UserId);
        Temp.TestField("Transfer Journal Template");
        Temp.TestField("Transfer Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Jtemplate := Temp."Transfer Journal Template";
        JBatch := Temp."Transfer Journal Batch";

        if Round(ACTransfer."Total Credits") <> Round(ACTransfer."Total Debits") then
            Error(ErrorOnNonDebitAmt, ACTransfer."Total Credits", ACTransfer."Total Debits");
        if ValuePosting = 1 then
            IF CONFIRM('Are you sure you want to transfer schedule?', true) = false then exit;

        JnlPostMngt.ClearJournalLines(Jtemplate, JBatch);

        BSched.RESET;
        BSched.SETRANGE("No.", ACTransfer."No.");
        BSched.SetRange("Member No.", ACTransfer."Member No");
        IF BSched.Find('-') then begin
            repeat

                GenJournalLine.LockTable();
                LineNo := LineNo + 1;
                TellerMgt.InitializeEntry(GenJournalLine, LineNo, Jtemplate,
                JBatch, AcTransfer."No.", '', Today, AcTransfer."Global Dimension 1 Code",
                AcTransfer."Global Dimension 2 Code");
                GenJournalLine."External Document No." := BSched."External Document No.";
                case BSched."Account Type" of
                    BSched."Account Type"::Savings:
                        begin
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        end;
                    BSched."Account Type"::Loan,
                    BSched."Account Type"::Credit:
                        begin
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        end;
                end;
                GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                GenJournalLine.Validate("Account No.", BSched."Account No.");
                GenJournalLine.Description := ACTransfer.Remarks + '-' + BSched."Account Name";
                GenJournalLine.Validate(Amount, BSched.Amount);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);
            UNTIL BSched.Next() = 0;

            JuniorTransType := '';

            BSchedDestin.RESET;
            BSchedDestin.SETRANGE("No.", ACTransfer."No.");
            BSchedDestin.SetRange("Member No.", ACTransfer."Member No");
            IF BSchedDestin.Find('-') then begin
                repeat

                    if BSchedDestin."Account Type" = BSchedDestin."Account Type"::Credit then begin
                        CustomerEntry.Reset();
                        CustomerEntry.SetRange("No.", BSchedDestin."Account No.");
                        if not CustomerEntry.FindFirst() then begin
                            if AccCred.Get(BSchedDestin."Account No.") then begin
                                if ProdFact.Get(AccCred."Product Type") then begin
                                    RegistryMngt.fnCreateCustMemberPostAc(AccCred."No.",
                                     AccCred.Name, AccCred."Mobile No.",
                                         AccCred."Global Dimension 1 Code",
                                            AccCred."Global Dimension 2 Code",
                                            AccCred."Customer Posting Group",
                                            '', AccCred.Status, AccCred."Product Type",
                                            AccCred."ID/Passport No.",
                                             AccCred."Member No.",
                                            CustAccType::"Credit Account",
                                            ProdFact."Account Dimension",
                                ProdFact."Account Category");
                                end;
                            end;
                        end;
                    end;

                    GenJournalLine.LockTable();

                    Case BSchedDestin."Account Type" of
                        BSchedDestin."Account Type"::Savings,
                        BSchedDestin."Account Type"::Credit:
                            begin

                                LineNo := LineNo + 10;
                                TellerMgt.InitializeEntry(GenJournalLine, LineNo, Jtemplate, JBatch,
                                AcTransfer."No.", '', Today, AcTransfer."Global Dimension 1 Code",
                                AcTransfer."Global Dimension 2 Code");

                                case BSchedDestin."Account Type" of
                                    BSchedDestin."Account Type"::Savings:
                                        begin
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        end;
                                    BSchedDestin."Account Type"::Loan,
                                    BSchedDestin."Account Type"::Credit:
                                        begin
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        end;
                                end;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                GenJournalLine."External Document No." := BSchedDestin."External Document No.";
                                GenJournalLine.Validate("Account No.", BSchedDestin."Account No.");
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := ACTransfer.Remarks;
                                GenJournalLine.Validate(Amount, BSchedDestin.Amount * -1);
                                GenJournalLine."Transaction Type" := BSchedDestin."Transaction Type";
                                GenJournalLine.Validate("Loan No.", BSchedDestin."Loan No.");
                                IF GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);
                            end;

                        BSchedDestin."Account Type"::Loan:
                            begin
                                AccruedInt := 0;

                                if Loans.Get(BSchedDestin."Loan No.") then begin
                                    Loans.CalcFields("Outstanding Principal", "Outstanding Interest",
                                    "Outstanding Bill", "Outstanding Insurance", "Outstanding Balance");

                                    RunBal := BSchedDestin.Amount;
                                    GenJournalLine.LockTable;

                                    if BSchedDestin."Clear Loan" then begin
                                        if ProdFact.Get(Loans."Product Type") then
                                            if BSchedDestin."Settlement Fee" > 0 then begin

                                                LoanCharges.Reset();
                                                LoanCharges.SetRange("Product Code", Loans."Product Type");
                                                LoanCharges.SetRange("Charging Option", LoanCharges."Charging Option"::"Pro Rate");
                                                if LoanCharges.Findfirst() then begin
                                                    LoanCharges.TestField("Charges Account");
                                                    LineNo := LineNo + 100;

                                                    TellerMgt.InitializeEntries(GenJournalLine, LineNo, Jtemplate, JBatch, ACTransfer."No.", '', Today,
                                                    ACTransfer."Global Dimension 1 Code", ACTransfer."Global Dimension 2 Code");
                                                    GenJournalLine."Line No." := LineNo;
                                                    GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                                    GenJournalLine."Account Type" := LoanCharges."Account Type";
                                                    GenJournalLine.Validate("Account No.", LoanCharges."Charges Account");
                                                    GenJournalLine."External Document No." := Loans."Account No.";
                                                    if BSchedDestin."Settlement Fee" >= BSched.Amount then
                                                        GenJournalLine.Validate(Amount, BSched.Amount * -1) else
                                                        GenJournalLine.Validate(Amount, BSchedDestin."Settlement Fee" * -1);
                                                    GenJournalLine.Description := PadStr(Format(LoanCharges."Charge Description"), 50);
                                                    if GenJournalLine.Amount <> 0 then
                                                        GenJournalLine.Insert(true);

                                                    RunBal := RunBal - Abs(GenJournalLine.Amount);

                                                end else begin
                                                    Error('No account Related or attached to settlement fee')
                                                end;
                                            end;



                                        EndDate := Today;
                                        StartDate := CalcDate('-CM', Today);
                                        IntDays := (EndDate - StartDate) + 1;
                                        AccruedInt := PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, StartDate);

                                        LineNo := LineNo + 10000;
                                        TellerMgt.InitializeEntries(GenJournalLine, LineNo, Jtemplate,
                                         JBatch, ACTransfer."No.", '', Today, ACTransfer."Global Dimension 1 Code",
                                         ACTransfer."Global Dimension 2 Code");

                                        GenJournalLine."Line No." := LineNo;
                                        GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine.Validate("Account No.", BSchedDestin."Account No.");
                                        GenJournalLine."External Document No." := Loans."Account No.";
                                        GenJournalLine.Validate(Amount, AccruedInt);
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
                                        GenJournalLine.Description := PadStr(Format(ACTransfer.Remarks), 50);
                                        GenJournalLine."Loan No." := Loans."No.";
                                        GenJournalLine.Validate("Bal. Account No.", ProdFact."Interest Account (G/L)");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);

                                    end else begin
                                        AccruedInt := 0;
                                    end;


                                    if (Loans."Outstanding Interest" + AccruedInt) > 0 then begin
                                        if RunBal > 0 then begin

                                            LineNo := LineNo + 10000;
                                            TellerMgt.InitializeEntries(GenJournalLine, LineNo, Jtemplate,
                                             JBatch, ACTransfer."No.", '', Today, ACTransfer."Global Dimension 1 Code",
                                             ACTransfer."Global Dimension 2 Code");

                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine.Validate("Account No.", BSchedDestin."Account No.");
                                            GenJournalLine."External Document No." := Loans."Account No.";
                                            if RunBal >= (Loans."Outstanding Interest" + AccruedInt) then
                                                GenJournalLine.Validate(Amount, (Loans."Outstanding Interest" + AccruedInt) * -1) else
                                                GenJournalLine.Validate(Amount, RunBal * -1);
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                            GenJournalLine.Description := PadStr(Format(ACTransfer.Remarks), 50);
                                            GenJournalLine."Loan No." := Loans."No.";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                        end;
                                    end;

                                    if Loans."Outstanding Insurance" > 0 then begin
                                        if RunBal > 0 then begin

                                            LineNo := LineNo + 10000;
                                            TellerMgt.InitializeEntries(GenJournalLine, LineNo, Jtemplate,
                                             JBatch, ACTransfer."No.", '', Today,
                                             ACTransfer."Global Dimension 1 Code",
                                             ACTransfer."Global Dimension 2 Code");
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine.Validate("Account No.", BSchedDestin."Account No.");
                                            GenJournalLine."External Document No." := Loans."Account No.";
                                            if RunBal >= Loans."Outstanding Insurance" then
                                                GenJournalLine.Validate(Amount, Loans."Outstanding Insurance" * -1) else
                                                GenJournalLine.Validate(Amount, RunBal * -1);
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Insurance Paid";
                                            GenJournalLine.Description := PadStr(Format(ACTransfer.Remarks), 50);
                                            GenJournalLine."Loan No." := Loans."No.";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                        end;
                                    end;

                                    if Loans."Outstanding Bill" > 0 then begin
                                        if RunBal > 0 then begin

                                            LineNo := LineNo + 10000;
                                            TellerMgt.InitializeEntries(GenJournalLine, LineNo, Jtemplate,
                                             JBatch, ACTransfer."No.", '', Today, ACTransfer."Global Dimension 1 Code",
                                             ACTransfer."Global Dimension 2 Code");

                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine.Validate("Account No.", BSchedDestin."Account No.");
                                            GenJournalLine."External Document No." := Loans."Account No.";
                                            if RunBal >= Loans."Outstanding Bill" then
                                                GenJournalLine.Validate(Amount, Loans."Outstanding Bill" * -1) else
                                                GenJournalLine.Validate(Amount, RunBal * -1);
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                                            GenJournalLine.Description := PadStr(Format(ACTransfer.Remarks), 50);
                                            GenJournalLine."Loan No." := Loans."No.";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                        end;
                                    end;

                                    if Loans."Outstanding Principal" > 0 then begin

                                        if RunBal > 0 then begin

                                            LineNo := LineNo + 10000;
                                            TellerMgt.InitializeEntries(GenJournalLine, LineNo, Jtemplate,
                                             JBatch, ACTransfer."No.", '', Today, ACTransfer."Global Dimension 1 Code",
                                             ACTransfer."Global Dimension 2 Code");
                                            GenJournalLine."Line No." := LineNo;
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine.Validate("Account No.", BSchedDestin."Account No.");
                                            GenJournalLine."External Document No." := Loans."Account No.";
                                            if RunBal >= Loans."Outstanding Principal" then
                                                GenJournalLine.Validate(Amount, Loans."Outstanding Principal" * -1) else
                                                GenJournalLine.Validate(Amount, RunBal * -1);
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                                            GenJournalLine.Description := PadStr(Format(ACTransfer.Remarks), 50);
                                            GenJournalLine."Loan No." := Loans."No.";
                                            GenJournalLine."Document Date" := ACTransfer."Transaction Date";
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);

                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                        end;
                                    end
                                end;
                            end;
                    end;
                until BSchedDestin.Next() = 0;
            end;

            case ACTransfer."Transfer Type" of
                ACTransfer."Transfer Type"::"Share Transfer",
            ACTransfer."Transfer Type"::"Share Transfer(Close Account)":
                    begin

                        ACTransfer.TestField("Transaction Type");
                        AccBanking.Reset();
                        AccBanking.SetRange("Member No.", ACTransfer."Member No");
                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                        if AccBanking.FindFirst() then begin
                            TellerMgt.fnPostAccTransferCharges(ACTransfer."Transaction Type",
                            AccBanking."No.", BSched.Amount, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code", Jtemplate, JBatch,
                            ACTransfer."No.", ACTransfer."Transaction Date");
                        end;

                    end;
            end;

            if ValuePosting = 1 then begin

                AccountTypes.Get(BSched."Product Code");

                if AccountTypes."Charge Subsiquent withdrawal" then begin

                    TotalCharge := 0;

                    JuniorTransType := TellerMgt.getSubsiquenTransType(AccountTypes."Product ID");
                    TotalCharge := CalculateTransactCharges(BSched.Amount, JuniorTransType, 1, true);
                    if JuniorTransType = '' then Error(ErroroOnCharge);

                    AccBanking.Reset();
                    AccBanking.SetRange("No.", BSched."Account No.");
                    if AccBanking.FindFirst() then begin

                        if AccBanking."Next Withdrawal Date" = 0D then begin
                            AccBanking."Last Withdrawal Date" := Today;
                            AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Today);
                            AccBanking.Modify(true);

                        end else begin

                            if Today <= AccBanking."Next Withdrawal Date" then begin
                                if (TotalCharge + BSched.Amount) > TellerMgt.CalcAvailableBal(AccBanking."No.") then
                                    Error(Text0008);

                                TellerMgt.fnPostAccTransferCharges(JuniorTransType,
                                 AccBanking."No.", BSched.Amount, Temp."Shortcut Dimension 1 Code",
                                Temp."Shortcut Dimension 2 Code", Jtemplate, JBatch, ACTransfer."No.",
                                ACTransfer."Transaction Date");
                                AccBanking."Last Withdrawal Date" := Today;
                                AccBanking.Modify(true)
                            end else begin
                                AccBanking."Last Withdrawal Date" := Today;
                                AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", AccBanking."Next Withdrawal Date");
                                AccBanking.Modify(true)
                            end;
                        end;
                    end;
                end;

                JnlPostMngt.CompletePosting(Jtemplate, JBatch);
                AcTransfer.CalcFields("Total Debits");
                SendSMS.CreateSmsNotif(SourceType::"InterAccount Transfer", AccBanking."Mobile No.",
                 Text0003 + FORMAT(AcTransfer."Total Debits") + Text0005 + COMPANYNAME + ' '
                + FORMAT(Today) + ' ' + FORMAT(Time), AcTransfer."Member No", AcTransfer."Member No", false);

                case ACTransfer."Transfer Type" of
                    ACTransfer."Transfer Type"::"Share Transfer(Close Account)":
                        begin
                            ACTransfer.CalcFields("Total Credits");
                            if BSched.Amount = BSched.Balance then begin

                                CustMember.Reset();
                                CustMember.SetRange("No.", ACTransfer."Member No");
                                if CustMember.FindFirst() then begin
                                    CustMember.Status := CustMember.Status::Closed;
                                    CustMember.Modify(true);
                                end;

                                AccBanking.Reset();
                                AccBanking.SetRange("Member No.", ACTransfer."Member No");
                                if AccBanking.FindSet() then begin
                                    AccBanking.ModifyAll(Blocked, AccBanking.Blocked::All);
                                    AccBanking.ModifyAll(Status, AccBanking.Status::Closed);
                                end;

                                AccSource.Reset();
                                AccSource.SetRange("Member No.", ACTransfer."Member No");
                                if AccSource.FindSet() then begin
                                    AccSource.ModifyAll(Blocked, AccSource.Blocked::All);
                                    AccSource.ModifyAll(Status, AccSource.Status::Closed);
                                end

                            end;
                        end;
                end;

                BSched.Reset();
                BSched.SetRange("No.", ACTransfer."No.");
                IF BSched.FindSet() then begin
                    BSched.ModifyAll(Posted, true);
                    BSched.ModifyAll("Date Posted", Today);
                end;

                BSchedDestin.Reset();
                BSchedDestin.SetRange("No.", ACTransfer."No.");
                If BSchedDestin.FindSet() then begin
                    if BSchedDestin."Settlement Fee" > 0 then begin

                        TempFile.Reset();
                        TempFile.SetRange(Posted, false);
                        TempFile.SetRange("Loan No.", BSchedDestin."Loan No.");
                        if TempFile.FindFirst() then begin
                            TempFile.Posted := true;
                            TempFile.Modify(true);
                        end;

                    end;
                    BSchedDestin.ModifyAll(Posted, true);
                    BSchedDestin.ModifyAll("Date Posted", Today);
                end;

                AcTransfer."Posted By" := UserId;
                AcTransfer."Date Posted" := CurrentDateTime;
                AcTransfer.Posted := true;
                AcTransfer.Modify(true);

            end else begin
                VarVariant := ACTransfer;
                Commit();
                Docx.DocPrintstatement(VarVariant, 0);
            end;
        end;
    end;

    procedure CalculateTransactCharges(Amt: Decimal; TransactionType: Code[20]; ValuePost: Integer; IsMoneyTransfer: Boolean): Decimal
    var
        GeneralSetUp: Record "General Set-Up";
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TCharges: Decimal;
        ExciseDuty: Decimal;
        ChargeAmount: Decimal;
        TotChargeAmount: Decimal;
    begin
        GeneralSetUp.Get();
        GeneralSetUp.TestField("Excise Duty (%)");

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin

            ChargeAmount := 0;
            TotChargeAmount := 0;
            case TransactionCharges."Charge Type" of

                TransactionCharges."Charge Type"::"Flat Amount":
                    begin
                        TransactionCharges.TestField("Charge Amount");
                        ChargeAmount := TransactionCharges."Charge Amount";
                        if IsMoneyTransfer then
                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=') else
                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=');
                        if TransactionCharges."Recover Excise Duty" then
                            TotChargeAmount := (ChargeAmount + ExciseDuty) else
                            TotChargeAmount := ChargeAmount;
                    end;
                TransactionCharges."Charge Type"::"% of Amount":
                    begin
                        TransactionCharges.TestField("Percentage of Amount");
                        ChargeAmount := Amt * (TransactionCharges."Percentage of Amount" * 0.01);
                        if IsMoneyTransfer then
                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=') else
                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=');
                        if TransactionCharges."Recover Excise Duty" then
                            TotChargeAmount := (ChargeAmount + ExciseDuty) else
                            TotChargeAmount := ChargeAmount;

                    end;
                TransactionCharges."Charge Type"::Staggered:
                    begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" then begin
                                        ChargeAmount := (Amt * (TariffDetails.Percentage / 100));
                                        if IsMoneyTransfer then
                                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=') else
                                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=');
                                        if TransactionCharges."Recover Excise Duty" then
                                            TotChargeAmount := (ChargeAmount + ExciseDuty) else
                                            TotChargeAmount := ChargeAmount;

                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                        if IsMoneyTransfer then
                                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=') else
                                            ExciseDuty := Round((ChargeAmount * (GeneralSetUp."Excise Duty (%)" / 100)), 0.5, '=');
                                        if TransactionCharges."Recover Excise Duty" then
                                            TotChargeAmount := (ChargeAmount + ExciseDuty) else
                                            TotChargeAmount := ChargeAmount;
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;

                    end;
            end;
            case ValuePost of
                0:
                    exit(ChargeAmount);
                1:
                    exit(TotChargeAmount);
                2:
                    exit(ExciseDuty);
            end;
        end else begin
            exit(0)
        end;
        exit(0)
    end;

    procedure PostLien(Accbanking: Record "Account Banking"; Amt: Decimal; RemarksTxt: Text[100]; PostInt: Integer; ExtDocNo: code[100])
    var
        TellerTrans: Record "Teller Transaction";
        TransType: Record "Transaction Types";

    begin
        if PostInt = 0 then begin
            if Confirm('Are you sure you want to place lien on this account?', true) = false then exit;
        end;

        TellerTrans.Init();
        TellerTrans.Validate("Account No.", Accbanking."No.");

        TransType.Reset();
        TransType.SetRange(Type, TransType.Type::Lien);
        TransType.SetRange("Product Type", Accbanking."Product Type");
        if TransType.FindFirst() then begin
            TellerTrans.Validate("Transaction Type", TransType.Code);
        end else begin
            Error('Lien Transaction Type not found');
        end;

        TellerTrans.Validate(Amount, Amt);
        TellerTrans.Remarks := RemarksTxt;
        TellerTrans."Transaction Description" := RemarksTxt;
        TellerTrans."External Document No." := ExtDocNo;
        TellerTrans.Posted := true;
        TellerTrans."Date Posted" := TODAY;
        TellerTrans."Time Posted" := TIME;
        TellerTrans."Posted By" := USERID;
        TellerTrans.Insert(true);

    end;

    procedure ClearLien()
    var
        Transactions: Record "Teller Transaction";
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
    begin
        Temp.Get(UserId);
        Gensetup.Get;
        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";
        if Jtemplate = '' then begin
            Error(Text0001);
        end;
        if JBatch = '' then begin
            Error(Text0002);
        end;

        Transactions.Reset;
        Transactions.SetRange(Transactions."Cheque Status", Transactions."Cheque Status"::Pending);
        Transactions.SetRange(Transactions.Type, Transactions.Type::Lien);
        if Transactions.Find('-') then begin
            repeat

                if Transactions."Expected Maturity Date" <= Today then begin
                    Transactions."Cheque Status" := Transactions."Cheque Status"::Honoured;
                    Transactions."Date Cleared" := Today;
                    Transactions."Cleared By" := UserId;
                    Transactions.Modify;
                end;

            until Transactions.Next = 0;
        end;
    end;

    procedure CheckExistingCredDestinationLine(TransferNo: code[50]): Boolean
    var
        BSchedDestin: Record "Account Transfer Destination";
    begin
        BSchedDestin.RESET;
        BSchedDestin.SETRANGE("No.", TransferNo);
        IF BSchedDestin.FIND('-') then begin
            repeat
                Case BSchedDestin."Account Type" of
                    BSchedDestin."Account Type"::Savings,
                    BSchedDestin."Account Type"::Credit:
                        begin
                            exit(true)
                        end
                end
            until BSchedDestin.Next() = 0;
        end;
        exit(false)
    end;

    procedure PostBankChequeCharges(BankCheque: Record "Cheque Book Application")
    var
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        LineNo: Integer;
        ChargeAmount: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Cashier Journal Batch is set up in Banking User Setup';
        AvailBal: Decimal;
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
        Vend: Record "Account Banking";
        MobNo: Code[20];
        Text0003: Label 'Your account has insufficient funds to cater for cheque book charges ';
    begin
        Temp.Get(UserId);

        Gensetup.Get;
        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";

        if Jtemplate = '' then begin
            Error(Text0001);
        end;

        if JBatch = '' then begin
            Error(Text0002);
        end;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.DeleteAll;

        TCharges := 0;

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", BankCheque."Transaction Type");
        if TransactionCharges.Find('-') then begin
            repeat

                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                    LineNo := LineNo + 10000;

                    ChargeAmount := 0;

                    ChargeAmount := TransactionCharges."Charge Amount";

                    AvailBal := 0;
                    MinBalance := 0;

                    if Account.Get(BankCheque."Account No.") then begin
                        Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques", Account."Authorised Over Draft", Account."Lien Placed");

                        ProdType.Reset;
                        ProdType.SetRange(ProdType."Product ID", Account."Product Type");
                        if ProdType.Find('-') then begin
                            MinBalance := ProdType."Minimum Balance";

                            AvailBal := (Account."Balance (LCY)" + Account."Authorised Over Draft") - (MinBalance + Account."Uncleared Cheques" + Account."Lien Placed");

                            if AvailBal < ChargeAmount then
                                Error('The transaction will result in overdrawing account %1', BankCheque."Account No.");
                            MobNo := '';

                            if Vend.Get(BankCheque."Account No.") then begin
                                MobNo := Vend."Mobile No.";
                            end;
                            SendSMS.CreateSmsNotif(SourceType::Other, MobNo, Text0003 + Format(Today) + ' ' + Format(Time)
                            + ' ' + CompanyName, BankCheque."No.", BankCheque."No.", false);

                        end;
                    end;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := Jtemplate;
                    GenJournalLine."Journal Batch Name" := JBatch;
                    GenJournalLine."Document No." := BankCheque."No.";
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                    GenJournalLine."Account No." := BankCheque."Account No.";
                    GenJournalLine."External Document No." := BankCheque."ID No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := TransactionCharges.Description;

                    GenJournalLine.Amount := ChargeAmount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine."Bal. Account No." := TransactionCharges."G/L Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    if (TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty") and
                      (TransactionCharges."Recover Excise Duty" = true) then begin
                        //Excise Duty

                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Document No." := BankCheque."No.";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                        GenJournalLine."Account No." := BankCheque."Account No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Excise Duty';
                        GenJournalLine.Amount := (ChargeAmount * Gensetup."Excise Duty (%)") * 0.01;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := Gensetup."Excise Duty G/L";
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                    end;
                end;
            until TransactionCharges.Next = 0;
        end;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        if GenJournalLine.Find('-') then begin
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJournalLine);
        end;
        BankCheque."Cheque Book charges Posted" := true;
        BankCheque.Modify;

        Message('Charges posted successfully');
    end;


    procedure PostSalary(SalHeaD: Record "Salary Header")
    var
        SalLines: Record "Salary Lines";
        GenJournalLine: Record "Gen. Journal Line";
        Temp: Record "Banking User Template";
        Jtemplate: Code[20];
        JBatch: Code[20];
        RunBal: Decimal;
        Gensetup: Record "General Set-Up";
        LineNo: Integer;
        PDate: Date;
        DocNo: Code[20];
        PostingRemarks: Text[50];
        DActivity2: Code[20];
        DBranch2: Code[20];
        Account: Record "Account Banking";
        AvailableBal: Decimal;
        ProductF: Record "Product Factory";
        SalProcessingHeader: Record "Salary Header";
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        MemberNo: Code[20];
        Salaccno: Code[20];
        Text0005: Label 'Your Salary of ';
        Text0006: Label ' has been credited to your account at ';
        Text0007: Label ' on ';
        intProgressTotal: Integer;
        diaProgress: Dialog;
        intProgressI: Integer;
        intProgress: Integer;
        TimeProgress: Time;
        NoOfProgressed: Integer;
        NoOfRecsProgress: Integer;
    begin
        SalHeaD.TestField(Posted, false);
        SalHeaD.TestField(Status, SalHeaD.Status::Approved);

        Temp.Get(UserId);
        Temp.TestField("Salary Journal Template");
        Temp.TestField("Salary Journal Batch");

        Jtemplate := Temp."Salary Journal Template";
        JBatch := Temp."Salary Journal Batch";

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.DeleteAll;

        SalHeaD.CalcFields("Total Count", "Scheduled Amount");

        RunBal := 0;

        intProgressTotal := SalHeaD.Count;
        diaProgress.Open(Genrating + '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', intProgress);
        intProgressI := 0;
        TimeProgress := Time;
        NoOfRecsProgress := intProgressTotal div 100;
        NoOfProgressed := 0;

        Gensetup.Get;

        LineNo := LineNo + 10000;

        SalHeaD.TestField(Remarks);
        SalHeaD.TestField("Document No");
        SalHeaD.TestField("Posting date");
        SalHeaD.TestField(Amount);
        if SalHeaD."Scheduled Amount" <> SalHeaD.Amount then
            Error('Scheduled amount and Amount must be the same');

        PDate := SalHeaD."Posting date";
        DocNo := SalHeaD."Document No";
        PostingRemarks := SalHeaD.Remarks;
        if Confirm('Are you sure you want to post Salaries?', false) = false then
            exit;

        SalLines.Reset;
        SalLines.SetRange(SalLines."Salary Header No.", SalHeaD.No);
        SalLines.SetRange("Account Not Found", false);
        SalLines.SetRange(Posted, false);
        if SalLines.Find('-') then begin
            repeat

                intProgressI += 1;
                if (intProgressI >= NoOfRecsProgress) or (Time - TimeProgress > 1000) then begin
                    NoOfProgressed := NoOfProgressed + intProgressI;
                    diaProgress.Update(1, Round(NoOfProgressed / intProgressTotal * 10000, 1));
                    intProgressI := 0;
                    TimeProgress := Time;
                end;

                MemberNo := '';
                Salaccno := '';

                MemberNo := SalLines."Member No.";
                Salaccno := SalLines."Account No.";

                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                GenJournalLine.SetRange("Journal Batch Name", JBatch);
                GenJournalLine.DeleteAll;


                Account.Reset;
                Account.SetRange("No.", SalLines."Account No.");
                Account.SetRange("Account Category", Account."Account Category"::Savings);
                if Account.Find('-') then begin

                    DActivity2 := Account."Global Dimension 1 Code";
                    DBranch2 := Account."Global Dimension 2 Code";


                    AvailableBal := 0;
                    Account.CalcFields(Account."Balance (LCY)", Account."Authorised Over Draft", Account."Uncleared Cheques");
                    AvailableBal := ((Account."Balance (LCY)" + Account."Authorised Over Draft") - (Account."ATM Transactions" + Account."Uncleared Cheques"));
                    if ProductF.Get(Account."Withdrawal Option") then
                        AvailableBal := AvailableBal - ProductF."Minimum Balance";

                    RunBal := AvailableBal + SalLines.Amount;


                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := Jtemplate;
                    GenJournalLine."Journal Batch Name" := JBatch;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := CopyStr(DocNo, 1, 14);

                    GenJournalLine."Posting Date" := PDate;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                    GenJournalLine."Account No." := SalLines."Account No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine.Description := PostingRemarks;

                    GenJournalLine.Amount := -SalLines.Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity2;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch2;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := Jtemplate;
                    GenJournalLine."Journal Batch Name" := JBatch;
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := CopyStr(DocNo, 1, 14);

                    GenJournalLine."Posting Date" := PDate;
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine.Description := PostingRemarks;
                    GenJournalLine."Account Type" := SalHeaD."Account Type";
                    if SalProcessingHeader.Get(SalLines."Salary Header No.") then begin
                        GenJournalLine."Account No." := SalProcessingHeader."Account No";
                    end;
                    GenJournalLine.Amount := SalLines.Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity2;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch2;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;


                    TCharges := 0;
                    TransactionCharges.Reset;
                    TransactionCharges.SetRange(TransactionCharges."Transaction Type", SalHeaD."Transaction Type");
                    if TransactionCharges.Find('-') then begin
                        repeat

                            LineNo := LineNo + 10000;
                            ChargeAmount := 0;

                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                ChargeAmount := (SalHeaD.Amount * TransactionCharges."Percentage of Amount") * 0.01
                            else
                                ChargeAmount := TransactionCharges."Charge Amount";
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (SalHeaD.Amount >= TariffDetails."Lower Limit") and (SalHeaD.Amount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" = true then begin
                                                ChargeAmount := SalHeaD.Amount * TariffDetails.Percentage * 0.01;
                                            end else begin
                                                ChargeAmount := TariffDetails."Charge Amount";
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;

                            GenJournalLine.Init;
                            GenJournalLine."Journal Template Name" := Jtemplate;
                            GenJournalLine."Journal Batch Name" := JBatch;
                            GenJournalLine."Document No." := CopyStr(DocNo, 1, 14);
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                            GenJournalLine."Account No." := SalLines."Account No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.");
                            GenJournalLine."Posting Date" := PDate;
                            GenJournalLine.Description := TransactionCharges.Description;
                            GenJournalLine.Validate(GenJournalLine."Currency Code");
                            GenJournalLine.Amount := ChargeAmount;
                            GenJournalLine.Validate(GenJournalLine.Amount);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                            GenJournalLine."Bal. Account No." := TransactionCharges."G/L Account";
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                            GenJournalLine."Shortcut Dimension 1 Code" := DActivity2;
                            GenJournalLine."Shortcut Dimension 2 Code" := DBranch2;
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert;
                            RunBal := RunBal - GenJournalLine.Amount;

                            if (TransactionCharges."Transaction Charge Category" <>
                              TransactionCharges."Transaction Charge Category"::"Stamp Duty") and
                            (TransactionCharges."Recover Excise Duty" = true) then begin

                                //Excise Duty

                                LineNo := LineNo + 10000;

                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := Jtemplate;
                                GenJournalLine."Journal Batch Name" := JBatch;
                                GenJournalLine."Document No." := CopyStr(DocNo, 1, 14);
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                                GenJournalLine."Account No." := SalLines."Account No.";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := PDate;
                                GenJournalLine.Description := 'Excise Duty';
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                GenJournalLine.Amount := (ChargeAmount * Gensetup."Excise Duty (%)") * 0.01;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                GenJournalLine."Bal. Account No." := Gensetup."Excise Duty G/L";
                                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                                GenJournalLine."Shortcut Dimension 1 Code" := DActivity2;
                                GenJournalLine."Shortcut Dimension 2 Code" := DBranch2;
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                                RunBal := RunBal - GenJournalLine.Amount;

                                TCharges := TCharges + ChargeAmount;
                            end;
                        until TransactionCharges.Next = 0;
                    end;
                    //PostSalaryLoans(SalHeaD,DocNo,PDate,DActivity2,DBranch2,Jtemplate,JBatch,RunBal,MemberNo,LineNo,Salaccno);
                end;

                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                GenJournalLine.SetRange("Journal Batch Name", JBatch);
                if GenJournalLine.Find('-') then begin
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJournalLine);
                end;

                SalLines.Posted := true;
                SalLines."Posted By" := UserId;
                SalLines."Posting Date" := Today;
                SalLines."Posting Time" := Time;
                SalLines.Modify;
                Commit;

                if Account.Get(SalLines."Account No.") then begin
                    SendSMS.CreateSmsNotif(SourceType::"Salary Processing", Account."Mobile No.",
                    Text0005 + Format(SalLines.Amount) + Text0006 + CompanyName + Text0007 + Format(Today) + ' '
                    + Format(Time), SalLines."Account No.", SalLines."Account No.", false);
                end;
            until SalLines.Next = 0;
        end;
        SalHeaD.Posted := true;
        SalHeaD."Posted By" := UserId;
        SalHeaD.Modify;
        Message('The salary batch has been posted successfully');
        diaProgress.Close;
    end;


    procedure UpdateStandingOrderRegister(RNo: Code[10]; RDateProcessed: Date; RSourceAccountNo: Code[20]; RSourceAccountName: Text; RMemberNo: Code[20]; RDeductionStatus: Option " ",Successfull,"Partial Deduction",Failed; RDeductionAmount: Decimal; RAmountDeducted: Decimal; RStartDate: Date; FosaBal: Decimal)
    var
        StandingOrdSRegister: Record "Standing Order Register";
    begin

        StandingOrdSRegister.Init;
        StandingOrdSRegister."Entry No." := RegMngt.InitNextEntryStandingOrder();
        StandingOrdSRegister."No." := RNo;
        StandingOrdSRegister."Date Processed" := RDateProcessed;
        StandingOrdSRegister."Source Account No." := RSourceAccountNo;
        StandingOrdSRegister."Source Account Name" := RSourceAccountName;
        StandingOrdSRegister."Member No" := RMemberNo;
        StandingOrdSRegister."Deduction Status" := RDeductionStatus;
        StandingOrdSRegister.Amount := RDeductionAmount;
        StandingOrdSRegister."Amount Deducted" := RAmountDeducted;
        StandingOrdSRegister."Effective/Start Date" := RStartDate;
        StandingOrdSRegister."Fosa Balance" := FosaBal;
        StandingOrdSRegister.Insert(true);
    end;


    procedure PostOverDraft(Overdraft: Record "Over Draft Authorisation")
    var
        Text0001: Label 'Ensure the Overdraft Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Overdraft Journal Batch is set up in Banking User Setup';
        Text0004: Label 'The transaction has already been posted.';
        TCharges: Integer;
        TransactionCharges: Record "Transaction Charge";
        LineNo: Integer;
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        GenJournalLine: Record "Gen. Journal Line";
        TChargeAmount: Decimal;
        GenSetup: Record "General Set-Up";
    begin

        if Overdraft.Posted = true then
            Error(Text0004);

        Temp.Get(UserId);
        GenSetup.Get;

        Jtemplate := Temp."Over Draft Template";
        JBatch := Temp."Over Draft Batch";


        if Jtemplate = '' then begin
            Error(Text0001);
        end;

        if JBatch = '' then begin
            Error(Text0002);
        end;


        if Overdraft.Status <> Overdraft.Status::Approved then
            Error('You cannot post an application being processed.');

        Overdraft.TestField("Account No.");
        Overdraft.TestField("Effective/Start Date");
        Overdraft.TestField(Duration);
        Overdraft.TestField("Expiry Date");
        Overdraft.TestField("Requested Amount");
        Overdraft.TestField("Approved Amount");
        Overdraft.TestField("Overdraft Interest %");


        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.DeleteAll;

        if Confirm('Are you sure you want to charge overdraft issue fee.', false) = false then
            exit;

        //Charges
        TCharges := 0;

        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", Overdraft."Transaction Type");
        if TransactionCharges.Find('-') then begin
            repeat
                LineNo := LineNo + 10000;

                ChargeAmount := 0;
                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                    ChargeAmount := (Overdraft."Approved Amount" * TransactionCharges."Percentage of Amount") * 0.01
                else
                    ChargeAmount := TransactionCharges."Charge Amount";

                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin

                    TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                    TariffDetails.Reset;
                    TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                    if TariffDetails.Find('-') then begin
                        repeat
                            if (Overdraft."Approved Amount" >= TariffDetails."Lower Limit") and (Overdraft."Approved Amount" <= TariffDetails."Upper Limit") then begin
                                if TariffDetails."Use Percentage" = true then begin
                                    ChargeAmount := Overdraft."Approved Amount" * TariffDetails.Percentage * 0.01;
                                end else begin
                                    ChargeAmount := TariffDetails."Charge Amount";
                                end;
                            end;
                        until TariffDetails.Next = 0;
                    end;
                end;



                GenJournalLine.Init;
                GenJournalLine."Journal Template Name" := Jtemplate;
                GenJournalLine."Journal Batch Name" := JBatch;
                GenJournalLine."Document No." := Overdraft."No.";
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                GenJournalLine."Account No." := Overdraft."Account No.";
                GenJournalLine."External Document No." := Overdraft."Account No.";
                GenJournalLine.Validate(GenJournalLine."Account No.");
                GenJournalLine."Posting Date" := Today;
                GenJournalLine.Description := TransactionCharges.Description;
                GenJournalLine.Validate(GenJournalLine."Currency Code");
                GenJournalLine.Amount := ChargeAmount;
                GenJournalLine.Validate(GenJournalLine.Amount);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine."Bal. Account No." := TransactionCharges."G/L Account";
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                GenJournalLine."Shortcut Dimension 1 Code" := Overdraft."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := Overdraft."Global Dimension 2 Code";
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert;

                //IF NOT TransactionCharges."Transaction Charge Category" THEN  BEGIN

                if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin



                    LineNo := LineNo + 10000;

                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := Jtemplate;
                    GenJournalLine."Journal Batch Name" := JBatch;
                    GenJournalLine."Document No." := Overdraft."No.";
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                    GenJournalLine."Account No." := Overdraft."Account No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine.Description := 'Excise Duty';
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    GenJournalLine.Amount := (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine."Bal. Account No." := GenSetup."Excise Duty G/L";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Shortcut Dimension 1 Code" := Overdraft."Global Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := Overdraft."Global Dimension 2 Code";
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    TChargeAmount := TChargeAmount + ChargeAmount;
                end;
            until TransactionCharges.Next = 0;
        end;


        //Post New
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        if GenJournalLine.Find('-') then begin
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJournalLine);
        end;

        //Post New

        Overdraft.Posted := true;
        Overdraft.Modify;

        Message('Overdraft charges posted successfully.');
    end;

    local procedure ClearOverDraft()
    var
        OverDraft: Record "Over Draft Authorisation";
    begin

        OverDraft.Reset;
        OverDraft.SetRange(OverDraft.Expired, false);
        if OverDraft.Find('-') then begin
            if OverDraft."Expiry Date" <= Today then begin
                OverDraft.Expired := true;
                OverDraft.Modify;
            end;
        end;
    end;

    procedure CalculateFDInterest(Account: Record "Account Banking"; RunDate: Date; PostInt: Integer): Decimal
    var
        InterestAmount: Decimal;
        InterestBuffer: Record "Interest Buffer";
        IntBufferNo: Integer;
        AccountTypes: Record "Product Factory";
        FixedDepType: Record "Fixed Deposit Type";
        FDInterestCalc: Record "FD Interest Calculation Rules";
        IntRate: Decimal;
        FDDays: Integer;
    begin

        if AccountTypes.Get(Account."Product Type") then begin
            if AccountTypes."Account Category" = AccountTypes."Account Category"::"Certificates of Deposit" then begin
                if FixedDepType.Get(Account."Fixed Deposit Type") then begin

                    FDInterestCalc.Reset;
                    FDInterestCalc.SetRange(Code, Account."Fixed Deposit Type");
                    if FDInterestCalc.Find('-') then begin
                        Account.CalcFields("Balance (LCY)");
                        repeat
                            if (FDInterestCalc."Minimum Amount" <= Account."Balance (LCY)") and
                            (Account."Balance (LCY)" <= FDInterestCalc."Maximum Amount") then
                                if Account."Neg. Interest Rate" = 0 then begin
                                    IntRate := FDInterestCalc."Interest Rate";
                                end else begin
                                    IntRate := Account."Neg. Interest Rate";
                                end;
                        until FDInterestCalc.Next = 0;
                    end;
                    FDDays := CalcDate(FixedDepType.Duration, RunDate) - RunDate;

                    InterestAmount := Round((Account."Balance (LCY)" * IntRate * 0.01 * (FDDays / 365)), 1, '=');

                    if PostInt = 1 then begin
                        RegMngt.CreateIntBufferEntry(Account."No.",
                        AccountTypes."Product ID", RunDate,
                        InterestAmount, Account."FD Maturity Date");
                    end;
                end;
                exit(InterestAmount)
            end;
        end;
    end;

    procedure PostUnrefunded(Account: Record "Account Banking"; RunDate: Date; Jtemplate: Code[10]; Jbatch: Code[10]; RunBal: Decimal)
    var

        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        FDBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        Application: Record "Account Application";
        InterestAmt: Decimal;
    begin

        //Transfer to savings
        GenJournaline.LockTable();
        LineNo := LineNo + 1000;
        GenJournaline."Line No." := LineNo;
        TellerMngt.InitializeEntry(GenJournaline, LineNo,
        Jtemplate, Jbatch,
        Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
        Temp."Shortcut Dimension 2 Code");
        GenJournaline."External Document No." := Account."Member No.";
        GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
        ' <Day,2>-<Month Text,3>-<Year4> ');
        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
        GenJournaline.Validate("Account No.", Account."No.");
        GenJournaline.Validate(Amount, RunBal);
        if GenJournaline.Amount <> 0 then
            GenJournaline.Insert(true);

        GenJournaline.LockTable();
        LineNo := LineNo + 1000;
        GenJournaline."Line No." := LineNo;
        TellerMngt.InitializeEntry(GenJournaline, LineNo,
        Jtemplate, Jbatch,
        Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
        Temp."Shortcut Dimension 2 Code");
        GenJournaline."External Document No." := Account."Member No.";
        GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
        ' <Day,2>-<Month Text,3>-<Year4> ');
        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
        GenJournaline.Validate("Account No.", Account."Savings Account No.");
        GenJournaline.Validate(Amount, RunBal * -1);
        if GenJournaline.Amount <> 0 then
            GenJournaline.Insert(true);

    end;

    procedure RollOver(Account: Record "Account Banking"; RunDate: Date; Jtemplate: Code[10]; Jbatch: Code[10]; PostInt: Integer; PostPreMature: Boolean)
    var
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        FDBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        Application: Record "Account Application";
        InterestAmt: Decimal;
        WthTax: Decimal;
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        Jtemplate := Temp."Periodic Journal Template";
        Jbatch := Temp."Periodic Journal Batch";

        Gensetup.Get();
        JnlPostMngt.ClearJournalLines(Jtemplate, Jbatch);

        if Account.Blocked = Account.Blocked::" " then begin
            Account.CalcFields("Balance (LCY)");
            WthTax := 0;

            if AccountTypes.GET(Account."Product Type") then begin
                AccountTypes.TestField("Interest Payable Account");
                AccountTypes.TestField("WithHolding Tax");
                AccountTypes.TestField("Withholding Tax Account");
                if AccountTypes."Account Category" = AccountTypes."Account Category"::"Certificates of Deposit" then begin
                    Account.TestField(Account."FD Maturity Date");
                    Account.TestField("Savings Account No.");

                    if Account."FD Maturity Date" <= RunDate then begin
                        if FDType.GET(Account."Fixed Deposit Type") then
                            InterestAmt := CalculateFDInterest(Account, RunDate, 1);

                        Account.CalcFields("Untranferred Interest");
                        if Account."Untranferred Interest" > 0 then begin
                            WthTax := Account."Untranferred Interest" * (AccountTypes."WithHolding Tax" / 100);

                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch, Account."No.", '', RunDate,
                            Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");

                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, Account."Untranferred Interest" * -1);
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", AccountTypes."Interest Payable Account");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            //Withholding tax
                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch, Account."No.", '', RunDate,
                            Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'Withholding Tax on - ' + Account."No.";
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, Account."Untranferred Interest" * (AccountTypes."WithHolding Tax" / 100));
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", AccountTypes."Withholding Tax Account");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            //Transfer to savings
                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch, Account."No.", '', RunDate,
                            Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, (Account."Balance (LCY)" + Account."Untranferred Interest") - WthTax);
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch, Account."No.", '', RunDate,
                            Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");

                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."Savings Account No.");
                            GenJournaline.Validate(Amount, ((Account."Balance (LCY)" + Account."Untranferred Interest") - WthTax) * -1);
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);
                        end
                    end else begin
                        if PostPreMature then begin
                            PostUnrefunded(Account, RunDate, Jtemplate, Jbatch, Account."Balance (LCY)");
                        end;
                    end;

                    Case PostInt of
                        1:
                            begin

                                JnlPostMngt.CompletePosting(Jtemplate, Jbatch);
                                SendSMS.CreateSmsNotif(SourceType::"Fixed Deposit Maturity", Account."Mobile No.",
                                Text0001 + Format(Account."Balance (LCY)") + Text0002
                                + Format(Today) + ' ' + Format(Time), Account."No.", Account."No.", false);

                                InterestBuffer.Reset();
                                InterestBuffer.SetRange("Account No", Account."No.");
                                InterestBuffer.ModifyAll(InterestBuffer.Transferred, true);
                                Account."FD Maturity Date" := CalcDate(FDType.Duration, Account."FD Maturity Date");
                                Account.Status := Account.Status::Closed;
                                Account."Fixed Deposit Status" := Account."Fixed Deposit Status"::Closed;
                                Account.Modify(true);
                                RegMngt.CreateFDEntry(Account."No.", Account."Registration Date",
                                Account."Fixed Deposit Type", Account."FD Maturity Date",
                                Account."Neg. Interest Rate", Account."FD Duration",
                                Account."FD Maturity Instructions",
                                Account."Fixed Deposit Amount");
                            end
                    end
                end;
            end;
        end;
    end;

    procedure Renew(Account: Record "Account Banking"; RunDate: Date; Jtemplate: Code[10]; Jbatch: Code[10]; PostInt: Integer; PostPreMature: Boolean)
    var
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        FDBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        Application: Record "Account Application";
        InterestAmt: Decimal;
        WthTax: Decimal;
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        Jtemplate := Temp."Periodic Journal Template";
        Jbatch := Temp."Periodic Journal Batch";

        Gensetup.Get();
        JnlPostMngt.ClearJournalLines(Jtemplate, Jbatch);

        if Account.Blocked = Account.Blocked::" " then begin
            Account.CalcFields("Balance (LCY)");
            WthTax := 0;

            if AccountTypes.GET(Account."Product Type") then begin
                AccountTypes.TestField("Interest Payable Account");
                AccountTypes.TestField("WithHolding Tax");
                AccountTypes.TestField("Withholding Tax Account");
                if AccountTypes."Account Category" = AccountTypes."Account Category"::"Certificates of Deposit" then begin
                    Account.TestField(Account."FD Maturity Date");
                    Account.TestField("Savings Account No.");

                    if Account."FD Maturity Date" <= RunDate then begin
                        if FDType.GET(Account."Fixed Deposit Type") then
                            InterestAmt := CalculateFDInterest(Account, RunDate, 1);
                        Account.CalcFields("Untranferred Interest");

                        if Account."Untranferred Interest" > 0 then begin
                            WthTax := Account."Untranferred Interest" * (AccountTypes."WithHolding Tax" / 100);

                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch,
                            Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, Account."Untranferred Interest" * -1);
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", AccountTypes."Interest Payable Account");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            //Withholding tax
                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch,
                            Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'Withholding Tax on - ' + Account."No.";
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, WthTax);
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", AccountTypes."Withholding Tax Account");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            //Transfer to savings
                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch,
                            Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, (Account."Untranferred Interest" - WthTax));
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch,
                            Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."Savings Account No.");
                            GenJournaline.Validate(Amount, (Account."Untranferred Interest" - WthTax) * -1);
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                        end;
                    end else begin
                        if PostPreMature then
                            PostUnrefunded(Account, RunDate, Jtemplate, Jbatch, Account."Balance (LCY)");
                    end;
                    case PostInt of
                        1:
                            begin

                                JnlPostMngt.CompletePosting(Jtemplate, Jbatch);
                                SendSMS.CreateSmsNotif(SourceType::"Fixed Deposit Maturity", Account."Mobile No.",
                                Text0001 + FORMAT(Account."Balance (LCY)") + Text0002
                                  + FORMAT(TODAY) + ' ' + FORMAT(TIME), Account."No.", Account."No.", false);
                                InterestBuffer.Reset();
                                InterestBuffer.SetRange("Account No", Account."No.");
                                InterestBuffer.ModifyAll(InterestBuffer.Transferred, true);
                                Account."FD Maturity Date" := CalcDate(FDType.Duration, Account."FD Maturity Date");
                                Account."FD Date Renewed" := Today;
                                Account.Status := Account.Status::Active;
                                Account."Fixed Deposit Status" := Account."Fixed Deposit Status"::Active;
                                Account.Modify(true);
                                RegMngt.CreateFDEntry(Account."No.", Account."Registration Date",
                                Account."Fixed Deposit Type", Account."FD Maturity Date",
                                Account."Neg. Interest Rate", Account."FD Duration",
                                Account."FD Maturity Instructions",
                                Account."Fixed Deposit Amount");
                            end
                    end
                end;
            end;
        end;
    end;


    procedure CloseNonRenewable(Account: Record "Account Banking"; RunDate: Date; Jtemplate: Code[10]; Jbatch: Code[10]; PostInt: Integer; PostPreMature: Boolean)
    var
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        FDBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        Application: Record "Account Application";
        InterestAmt: Decimal;
        WthTax: Decimal;
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        Jtemplate := Temp."Periodic Journal Template";
        Jbatch := Temp."Periodic Journal Batch";

        Gensetup.Get();
        JnlPostMngt.ClearJournalLines(Jtemplate, Jbatch);

        if Account.Blocked = Account.Blocked::" " then begin
            Account.CalcFields("Balance (LCY)");
            WthTax := 0;

            if AccountTypes.GET(Account."Product Type") then begin
                AccountTypes.TestField("Interest Payable Account");
                AccountTypes.TestField("WithHolding Tax");
                AccountTypes.TestField("Withholding Tax Account");
                if AccountTypes."Account Category" = AccountTypes."Account Category"::"Certificates of Deposit" then begin
                    Account.TestField(Account."FD Maturity Date");
                    Account.TestField("Savings Account No.");

                    if Account."FD Maturity Date" <= RunDate then begin
                        if FDType.GET(Account."Fixed Deposit Type") then
                            InterestAmt := CalculateFDInterest(Account, RunDate, 1);
                        Account.CalcFields("Untranferred Interest");

                        if Account."Untranferred Interest" > 0 then begin
                            WthTax := Account."Untranferred Interest" * (AccountTypes."WithHolding Tax" / 100);

                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch,
                            Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'FD Interest - ' + FORMAT(Account."FD Maturity Date", 0,
                            ' <Day,2>-<Month Text,3>-<Year4> ');
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, Account."Untranferred Interest" * -1);
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", AccountTypes."Interest Payable Account");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            /// Withholding tax
                            GenJournaline.LockTable();
                            LineNo := LineNo + 1000;
                            GenJournaline."Line No." := LineNo;
                            TellerMngt.InitializeEntry(GenJournaline, LineNo,
                            Jtemplate, Jbatch,
                            Account."No.", '', RunDate, Temp."Shortcut Dimension 1 Code",
                            Temp."Shortcut Dimension 2 Code");
                            GenJournaline."External Document No." := Account."Member No.";
                            GenJournaline.Description := 'Withholding Tax on - ' + Account."No.";
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, WthTax);
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", AccountTypes."Withholding Tax Account");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);
                        end

                    end else begin
                        if PostPreMature then
                            PostUnrefunded(Account, RunDate, Jtemplate, Jbatch, Account."Balance (LCY)");
                    end;

                    case PostInt of
                        1:
                            begin

                                JnlPostMngt.CompletePosting(Jtemplate, Jbatch);
                                SendSMS.CreateSmsNotif(SourceType::"Fixed Deposit Maturity", Account."Mobile No.",
                                Text0001 + FORMAT(Account."Balance (LCY)") + Text0002
                                + FORMAT(TODAY) + ' ' + FORMAT(TIME), Account."No.", Account."No.", false);
                                InterestBuffer.Reset();
                                InterestBuffer.SetRange("Account No", Account."No.");
                                InterestBuffer.ModifyAll(InterestBuffer.Transferred, true);
                                Account."FD Maturity Date" := CalcDate(FDType.Duration, Account."FD Maturity Date");
                                Account."FD Date Renewed" := Today;
                                Account.Status := Account.Status::Active;
                                Account."Fixed Deposit Status" := Account."Fixed Deposit Status"::Active;
                                Account.Modify(true);
                                RegMngt.CreateFDEntry(Account."No.", Account."Registration Date",
                                Account."Fixed Deposit Type", Account."FD Maturity Date",
                                Account."Neg. Interest Rate", Account."FD Duration",
                                Account."FD Maturity Instructions",
                                Account."Fixed Deposit Amount");
                            end
                    end
                end;
            end;
        end;
    end;

    procedure FixedHistory(Account: Record "Account Banking")
    begin
        /*
          FixedHistory.RESET;
          IF FixedHistory.FIND('+') THEN
          FixedHistNo:=FixedHistory.No;
        
          FixedHistNo:=FixedHistNo+1;
        
          FixedHistory.INIT;
          FixedHistory.No:=FixedHistNo;
          FixedHistory."Account No.":=Account."No.";
          FixedHistory."Interest Earned":=Account."Untranfered Interest";
          FixedHistory."Fixed Deposit Type":=Account."Fixed Deposit Type";
          FixedHistory."Fixed Amount":=Account.Status;
          FixedHistory."FD Maturity Date":=Account."FD Maturity Date";
          FixedHistory."FD Duration":=Account."FD Duration";
          FixedHistory."FD Maturity Instructions":=Account."FD Maturity Instructions";
          FixedHistory."Registration Date":=Account."Registration Date";
          FixedHistory."Neg. Interest Rate":=Account."Neg. Interest Rate";
          FixedHistory.INSERT;
        */

    end;


    procedure PostCheques(ChReceiptH: Record "Cheque Receipt")
    var
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Salary Journal Batch is set up in Banking User Setup';
        GenJournalLine: Record "Gen. Journal Line";
        ChqRecLines: Record "Cheque Issue Line";
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        CheqReg: Record "Cheques Register";
        AvailBal: Decimal;
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
        MobNo: Code[20];
        Text0003: Label 'Your Cheque of Amount ';
        Text0004: Label ' has been paid ';
    begin

        Temp.Get(UserId);
        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";

        if Jtemplate = '' then begin
            Error(Text0001);
        end;

        if JBatch = '' then begin
            Error(Text0002);
        end;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.DeleteAll;

        if Confirm('Are you sure you want post cheques', true) = true then begin
            ChqRecLines.Reset;
            ChqRecLines.SetRange(ChqRecLines."Chq Receipt No", ChReceiptH."No.");
            ChqRecLines.SetRange(ChqRecLines.Status, ChqRecLines.Status::Pending);

            if ChqRecLines.Find('-') then begin
                repeat

                    if ChqRecLines."Un pay Code" = '' then begin


                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Document No." := ChReceiptH."No.";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                        GenJournalLine."Account No." := ChqRecLines."Account No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := ChReceiptH."Transaction Date";
                        GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                        GenJournalLine.Description := 'Cheque Issued' + ChqRecLines."Cheque Serial No";
                        GenJournalLine.Amount := ChqRecLines.Amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);

                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                        GenJournalLine."Bal. Account No." := ChReceiptH."Clearing Bank";

                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;


                        //Charges
                        TCharges := 0;
                        TransactionCharges.Reset;
                        TransactionCharges.SetRange(TransactionCharges."Transaction Type", ChReceiptH."Transaction Type");
                        if TransactionCharges.Find('-') then begin
                            repeat
                                LineNo := LineNo + 10000;
                                ChargeAmount := 0;
                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                    ChargeAmount := (ChqRecLines.Amount * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    ChargeAmount := TransactionCharges."Charge Amount";
                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                    TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                    TariffDetails.Reset;
                                    TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                    if TariffDetails.Find('-') then begin
                                        repeat
                                            if (ChqRecLines.Amount >= TariffDetails."Lower Limit") and (ChqRecLines.Amount <= TariffDetails."Upper Limit") then begin
                                                if TariffDetails."Use Percentage" = true then begin
                                                    ChargeAmount := ChqRecLines.Amount * TariffDetails.Percentage * 0.01;
                                                end else begin
                                                    ChargeAmount := TariffDetails."Charge Amount";
                                                end;
                                            end;
                                        until TariffDetails.Next = 0;
                                    end;
                                end;

                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := Jtemplate;
                                GenJournalLine."Journal Batch Name" := JBatch;
                                GenJournalLine."Document No." := ChReceiptH."No.";
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                                GenJournalLine."Account No." := ChqRecLines."Account No.";

                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := ChReceiptH."Transaction Date";
                                GenJournalLine.Description := TransactionCharges.Description;
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                GenJournalLine.Amount := ChargeAmount;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                GenJournalLine."Bal. Account No." := TransactionCharges."G/L Account";
                                GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                if (TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty") and
                                (TransactionCharges."Recover Excise Duty" = true) then begin

                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := Jtemplate;
                                    GenJournalLine."Journal Batch Name" := JBatch;
                                    GenJournalLine."Document No." := ChReceiptH."No.";
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                                    GenJournalLine."Account No." := ChqRecLines."Account No.";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := ChReceiptH."Transaction Date";
                                    GenJournalLine.Description := 'Excise Duty';
                                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                                    GenJournalLine.Amount := (ChargeAmount * Gensetup."Excise Duty (%)") * 0.01;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                    GenJournalLine."Bal. Account No." := Gensetup."Excise Duty G/L";
                                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.");

                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    TCharges := TCharges + ChargeAmount;
                                end;
                            until TransactionCharges.Next = 0;
                        end;


                        AvailBal := 0;
                        MinBalance := 0;

                        if Account.Get(ChqRecLines."Account No.") then begin
                            Account.CalcFields(Account."Balance (LCY)", Account."Uncleared Cheques", Account."Authorised Over Draft", Account."Lien Placed");

                            ProdType.Reset;
                            ProdType.SetRange(ProdType."Product ID", Account."Product Type");
                            if ProdType.Find('-') then begin
                                MinBalance := ProdType."Minimum Balance";

                                AvailBal := (Account."Balance (LCY)" + Account."Authorised Over Draft") - (MinBalance + Account."Uncleared Cheques" + Account."Lien Placed");

                                if AvailBal < ChqRecLines.Amount then
                                    Error('The transaction will result in overdrawing account %1', ChqRecLines."Account No.");
                            end;
                        end;
                    end;
                until ChqRecLines.Next = 0;
            end;

            GenJournalLine.Reset;
            GenJournalLine.SetRange("Journal Template Name", Jtemplate);
            GenJournalLine.SetRange("Journal Batch Name", JBatch);
            if GenJournalLine.Find('-') then begin
                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJournalLine);
            end;

            ChqRecLines.Reset;
            ChqRecLines.SetRange(ChqRecLines."Chq Receipt No", ChReceiptH."No.");
            ChqRecLines.SetRange(ChqRecLines.Status, ChqRecLines.Status::Pending);
            if ChqRecLines.Find('-') then begin
                repeat
                    CheqReg.Reset;
                    CheqReg.SetRange(CheqReg."Cheque No.", ChqRecLines."Cheque Serial No");
                    if CheqReg.Find('-') then begin
                        CheqReg.Status := CheqReg.Status::Approved;
                        CheqReg."Approval Date" := Today;
                        CheqReg.Modify;
                    end;
                    if Account.Get(ChqRecLines."Account No.") then begin
                        MobNo := Account."Mobile No.";
                    end;
                    SendSMS.CreateSmsNotif(SourceType::Other, MobNo, Text0003 + Format(ChqRecLines.Amount) + Text0004 + Format(Today) + ' ' + Format(Time)
                    + ' ' + CompanyName, ChReceiptH."No.", ChReceiptH."No.", false);
                until ChqRecLines.Next = 0;
            end;
            ChReceiptH.Posted := true;
            ChReceiptH."Posted By" := UserId;
            ChReceiptH.Modify;
            Message('Transaction Posted Successfully');
        end;
    end;


    procedure PostUnpayCheques(ChReceiptH: Record "Cheque Receipt")
    var
        Text0001: Label 'Ensure the Cashier Journal Template is set up in Banking User Setup';
        Text0002: Label 'Ensure the Salary Journal Batch is set up in Banking User Setup';
        GenJournalLine: Record "Gen. Journal Line";
        ChqRecLines: Record "Cheque Issue Line";
        ChequeCodes: Record "Cheque Return Code";
        MobNo: Code[20];
        Account: Record "Account Banking";
        Text0003: Label 'Your Cheque of Amount ';
        Text0004: Label ' has been bounced ';
    begin

        Temp.Get(UserId);
        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";

        if Jtemplate = '' then begin
            Error(Text0001);
        end;

        if JBatch = '' then begin
            Error(Text0002);
        end;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.DeleteAll;

        if Confirm('Are you sure you want to unpay accounts', false) = true then begin

            if UpperCase(UserId) = UpperCase(ChReceiptH."Posted By") then
                Error('This must be done by another user');

            if ChReceiptH.Posted = false then
                Error('It must be posted first');

            GenJournalLine.Reset;
            GenJournalLine.SetRange("Journal Template Name", Jtemplate);
            GenJournalLine.SetRange("Journal Batch Name", JBatch);
            GenJournalLine.DeleteAll;

            ChqRecLines.Reset;
            ChqRecLines.SetRange(ChqRecLines."Chq Receipt No", ChReceiptH."No.");
            ChqRecLines.SetRange(ChqRecLines.Status, ChqRecLines.Status::Pending);
            if ChqRecLines.Find('-') then begin
                repeat

                    if ChqRecLines."Un pay Code" <> '' then begin


                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Document No." := ChReceiptH."No.";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                        GenJournalLine."Account No." := ChqRecLines."Account No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := ChReceiptH."Transaction Date";
                        GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                        GenJournalLine.Description := 'Cheque Issued' + ChqRecLines."Cheque Serial No";
                        GenJournalLine.Amount := ChqRecLines.Amount * -1;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                        GenJournalLine."Bal. Account No." := ChReceiptH."Clearing Bank";
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Post cheque processing charges

                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Document No." := ChReceiptH."No.";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                        GenJournalLine."Account No." := ChqRecLines."Account No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := ChReceiptH."Transaction Date";
                        GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                        GenJournalLine.Description := 'Cheque unpay Commision';
                        GenJournalLine.Amount := ChqRecLines."Un Pay Charge Amount";
                        GenJournalLine.Validate(GenJournalLine.Amount);

                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                        if ChequeCodes.Get(ChqRecLines."Un pay Code") then begin
                            ChequeCodes.TestField(ChequeCodes."Bounced Charges GL Account");
                            GenJournalLine."Bal. Account No." := ChequeCodes."Bounced Charges GL Account";
                        end;
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        //Excise duty
                        Gensetup.Get;

                        LineNo := LineNo + 10000;

                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := JBatch;
                        GenJournalLine."Document No." := ChReceiptH."No.";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Saving;
                        GenJournalLine."Account No." := ChqRecLines."Account No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := ChReceiptH."Transaction Date";
                        GenJournalLine."External Document No." := ChqRecLines."Cheque Serial No";
                        GenJournalLine.Description := 'Excise Duty';
                        GenJournalLine.Amount := ChqRecLines."Un Pay Charge Amount" * (Gensetup."Excise Duty (%)" / 100);
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := Gensetup."Excise Duty G/L";
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;
                    end;
                    if Account.Get(ChqRecLines."Account No.") then begin
                        MobNo := Account."Mobile No.";
                    end;
                    SendSMS.CreateSmsNotif(SourceType::Other, MobNo, Text0003 + Format(ChqRecLines.Amount) + Text0004 + Format(Today) + ' ' + Format(Time)
                    + ' ' + CompanyName, ChReceiptH."No.", ChReceiptH."No.", false);
                until ChqRecLines.Next = 0;
            end;

            GenJournalLine.Reset;
            GenJournalLine.SetRange("Journal Template Name", Jtemplate);
            GenJournalLine.SetRange("Journal Batch Name", JBatch);
            if GenJournalLine.Find('-') then begin
                CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post (Yes/No)", GenJournalLine);
            end;
            ChReceiptH."Unpaid By" := UserId;
            ChReceiptH.Unpaid := true;
            ChReceiptH.Modify;
        end;
    end;

    procedure EFTAccountClosureProcessing(ElectronicFundsH: Record "EFT Transfer Header"; PostInt: Integer)
    var
        Text002: Label 'Your application for fund transfer has been effect by ';
        Text003: Label 'Follow up using Reference No. ';
        Text004: Label 'The transaction has already been Processed.';
        ElectronicFundsL: Record "EFT Transfer Lines";
        Text005: Label 'Destnation account name of staff no %1 more than 28 characters.';
        Text006: Label 'Destnation account of staff no %1 more than 14 characters.';
        Text007: Label 'Posted successfully.';
        ChargeAmount: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TCharges: Decimal;
        FundTransfer: Label 'Fund Transfer';
        MobileNo: Code[20];
        CashierTransactions: Record "Teller Transaction";
        ChargesNet: Decimal;
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        ElectronicF: Record "EFT Transfer Header";
        AccBanking: Record "Account Banking";
        LnTransType: Enum "LoanTransactionType";
        DocsType: enum "Gen. Journal Document Type";
        BosaAc: Record "Account Credit";
        CustRec: Record Member;
    begin

        Gensetup.Get();
        Temp.Get(UserId);
        Temp.TestField(Temp."Cashier Journal Template");
        Temp.TestField(Temp."Cashier Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");

        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";
        JnlPostMngt.ClearJournalLines(Jtemplate, JBatch);
        ElectronicFundsH.TestField("Approval Status", ElectronicFundsH."Approval Status"::Approved);

        if ElectronicFundsH."Approval Status" = ElectronicFundsH."Approval Status"::Transferred then
            Error(Text004);
        ElectronicFundsH.CalcFields(ElectronicFundsH."Record Total");

        ElectronicFundsL.Reset;
        ElectronicFundsL.SetRange(ElectronicFundsL."Document No.", ElectronicFundsH."No.");
        ElectronicFundsL.SetRange("Account Type", ElectronicFundsL."Account Type"::Savings);
        if ElectronicFundsL.Find('-') then begin
            repeat
                ElectronicFundsL.TestField(ElectronicFundsL."Account No.");
                ElectronicFundsL.TestField(ElectronicFundsL."Account Name");
                ElectronicFundsL.TestField(ElectronicFundsL.Amount);
                ElectronicFundsL.TestField(ElectronicFundsL."Bank Code");
                ElectronicFundsL.TestField(ElectronicFundsL."Bank Name");

                if SavingsAcc.Get(ElectronicFundsL."Account No.") then begin
                    BosaAc.Reset();
                    BosaAc.SetRange("Member No.", SavingsAcc."Member No.");
                    if BosaAc.Findset() then begin
                        repeat
                            Bosaac.TestField("Balance (LCY)", 0);
                        until BosaAc.Next() = 0;
                    end;

                    AccBanking.Reset();
                    AccBanking.SetRange("Member No.", SavingsAcc."Member No.");
                    AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::Savings);
                    if AccBanking.FindSet() then begin
                        repeat
                            AccBanking.TestField("Balance (LCY)", 0);
                        until AccBanking.Next() = 0;

                    end;
                end;

                if StrLen(ElectronicFundsL."Account Name") > 150 then
                    Error(Text005, ElectronicFundsL."Account No.");

                if StrLen(ElectronicFundsL."External Account No.") > 100 then
                    Error(Text006, ElectronicFundsL."External Account No.");

                if ElectronicFundsL."Standing Order No" <> '' then begin
                    AccNo := Gensetup."External STO Account No.";
                    AccTypes := AccTypes::"G/L Account";
                end else begin
                    AccNo := ElectronicFundsL."Account No.";
                    AccTypes := AccTypes::Vendor;
                end;
                LineNo := LineNo + 10000;
                if AccBanking.Get(ElectronicFundsL."Account No.") then begin
                    AccBanking.CalcFields("Balance (LCY)");
                    JnlPostMngt.PostJournal(Temp."Cashier Journal Template", Temp."Cashier Journal Batch",
                    LineNo, AccTypes::Vendor, ElectronicFundsH."No.", PadStr('EFT To-' + ElectronicFundsL."Account Name", 50),
                     AccBanking."Balance (LCY)", AccBanking."No.", Today, BalAccountType::"Bank Account",
                     ElectronicFundsH."Account No.", AccBanking."Member No.",
                     Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                     LnTransType::" ", '', '', '', DocsType, '', DocsType);
                    if not ElectronicFundsL."Don't Charge" then begin
                        ChargeAmount := 0;
                        ChargesNet := 0;
                        TransactionCharges.Reset;
                        TransactionCharges.SetRange("Transaction Type", ElectronicFundsH."Transaction Type");
                        if TransactionCharges.Find('-') then begin
                            repeat
                                ChargeAmount := 0;
                                ChargesNet := 0;
                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                                    ChargeAmount += (ElectronicFundsL.Amount * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    ChargeAmount += TransactionCharges."Charge Amount";

                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                    TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                    TariffDetails.Reset;
                                    TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                    if TariffDetails.Find('-') then begin
                                        repeat
                                            if (ElectronicFundsL.Amount >= TariffDetails."Lower Limit") and (ElectronicFundsL.Amount <= TariffDetails."Upper Limit") then begin
                                                if TariffDetails."Use Percentage" then
                                                    ChargeAmount += ElectronicFundsL.Amount * TariffDetails.Percentage * 0.01
                                                else
                                                    ChargeAmount += TariffDetails."Charge Amount";
                                            end;
                                        until TariffDetails.Next = 0;
                                    end;
                                end;

                                //DEBIT ACCOUNT
                                ElectronicFundsJournal(Jtemplate, JBatch, Today, ElectronicFundsH."No.", '',
                                AccTypes, ElectronicFundsL."Account No.",
                                        PadStr(TransactionCharges.Description, 50),
                                        ChargeAmount,
                                         ElectronicFundsH."Shortcut Dimension 1 Code",
                                        ElectronicFundsH."Shortcut Dimension 2 Code",
                                         AccTypes::"G/L Account", TransactionCharges."G/L Account");
                                ChargesNet := ChargeAmount;
                                //CREDIT Excise Duty GL
                                Gensetup.Get;
                                Gensetup.TestField("Excise Duty (%)");
                                Gensetup.TestField("Excise Duty G/L");
                                ElectronicFundsJournal(Jtemplate, JBatch, Today, ElectronicFundsH."No.", '',
                                AccTypes, ElectronicFundsL."Account No.", PadStr(FundTransfer + ' :- ' + 'Excise Duty', 50),
                                    ChargeAmount * (Gensetup."Excise Duty (%)" / 100),
                                    ElectronicFundsH."Shortcut Dimension 1 Code",
                                    ElectronicFundsH."Shortcut Dimension 2 Code",
                                    AccTypes::"G/L Account", Gensetup."Excise Duty G/L");
                            until TransactionCharges.Next = 0;
                            TCharges := ChargeAmount;
                        end;
                    end;
                end;
            until ElectronicFundsL.Next = 0;
        end;

        JnlPostMngt.CompletePosting(Jtemplate, JBatch);

        Post := false;
        Post := JournlPosted.PostedSuccessfully;

        ElectronicFundsL.Reset;
        ElectronicFundsL.SetRange(ElectronicFundsL."Document No.", ElectronicFundsH."No.");
        ElectronicFundsL.SetRange(ElectronicFundsL.Transferred, false);
        if ElectronicFundsL.Find('-') then begin
            repeat
                ElectronicFundsL.Posted := true;
                ElectronicFundsL."Date Posted" := Today;
                ElectronicFundsL."Posted By" := UserId;
                ElectronicFundsL.Modify(true);

                case ElectronicFundsL."Account Type" of
                    ElectronicFundsL."Account Type"::Savings:
                        begin

                            if SavingsAcc.Get(ElectronicFundsL."Account No.") then begin
                                BosaAc.Reset();
                                BosaAc.SetRange("Member No.", SavingsAcc."Member No.");
                                if BosaAc.Findset() then begin
                                    Bosaac.ModifyAll(Status, BosaAc.Status::Closed);
                                end;

                                AccBanking.Reset();
                                AccBanking.SetRange("Member No.", SavingsAcc."Member No.");
                                if AccBanking.FindSet() then begin
                                    AccBanking.ModifyAll(Status, AccBanking.Status::Closed);
                                    if CustRec.Get(AccBanking."Member No.") then
                                        CustRec.Status := CustRec.Status::Closed;
                                    CustRec.Modify(true);
                                end;
                                if SavingsAcc."Mobile No." <> '' then
                                    MobileNo := SavingsAcc."Mobile No.";
                                SendSMS.CreateSmsNotif(SourceType::"EFT Effected", MobileNo, Text002 + CompanyName + ', ' + Text003 +
                                ElectronicFundsH."No.", ElectronicFundsH."No.", SavingsAcc."No.", false);
                            end;
                        end;
                end;
            until ElectronicFundsL.Next = 0;
        end;

        ElectronicFundsH."Approval Status" := ElectronicFundsH."Approval Status"::Transferred;
        ElectronicFundsH."Date Transferred" := Today;
        ElectronicFundsH."Time Transferred" := Time;
        ElectronicFundsH."Transferred By" := UserId;
        ElectronicFundsH.Modify;

        if PostInt = 1 then begin
            Commit();

            ElectronicF.Reset();
            ElectronicF.SetRange("No.", ElectronicFundsH."No.");
            if ElectronicF.FindFirst() then begin
                Report.Run(Report::"EFT Report", true, false, ElectronicF);
            end;
        end;
        Message(Text007);
    end;

    procedure CreateEftLines(EftHeaderNo: Code[50]; ProductID: Code[20]; AppDate: Date; ValuePost: Integer)
    var
        EftHeader: Record "EFT Transfer Header";
        EftLine: Record "EFT Transfer Lines";
        EftTransferLine: Record "EFT Transfer Lines";
        PLoan: Record Loans;
        LnApplication: Record "Loan Application";
        CustBank: Record "Cust. Bank Account";
        BanksList: Record Banks;
        CustRec: Record Member;
        Text0001: Label 'This action will clear all entries on EFT Transfer Lines. Are you want to continue?';
        Text0002: Label 'This action will suggest Loans on EFT Transfer Lines. Are you want to continue?';
        Text0003: Label 'Loan No. %1 already attached to EFT No. %2';
        DFilter: Text[50];
        PartialDisb: Record "Partial Disbursement Schedule";
        OtherCommitment: Record "Other Commitements Clearance";
        EftScheduleLine: Record "EFT Transfer Lines";
        TotalCommittment: Decimal;
        ExternalCommitment: Record "Other Commitements Clearance";
        LoanApplic: Record "Loan Application";
        PostLoan: Record Loans;

    begin
        DFilter := '';

        case ValuePost of
            0:
                begin
                    if Confirm(Text0001, true) = false then exit;

                    EftHeader.Reset();
                    EftHeader.SetRange("No.", EftHeaderNo);
                    EftHeader.SetRange("Approval Status", EftHeader."Approval Status"::Open);
                    EftHeader.SetRange("Source of funds", EftHeader."Source of funds"::"Loan Proceed");
                    if EftHeader.FindFirst() then begin
                        EftLine.reset();
                        EftLine.SetRange("Document No.", EftHeader."No.");
                        EftLine.DeleteAll();
                    end else begin
                        Error('Application Status must -Open');
                    end;
                end;
            1:
                begin
                    if Confirm(Text0002, true) = false then exit;

                    EftHeader.Reset();
                    EftHeader.SetRange("No.", EftHeaderNo);
                    EftHeader.SetRange("Approval Status", EftHeader."Approval Status"::Open);
                    EftHeader.SetRange("Source of funds", EftHeader."Source of funds"::"Loan Proceed");
                    if EftHeader.FindFirst() then begin
                        DFilter := Format(EftHeader."Start Date") + '..' + Format(EftHeader."End Date");

                        if EftHeader."Loan No." <> '' then begin
                            PostLoan.Reset();
                            PostLoan.SetRange("No.", EftHeader."Loan No.");
                            if PostLoan.FindFirst() then begin
                                if PostLoan."Topup Loan" <> '' then begin
                                    if PostLoan."EFT Options" = PostLoan."EFT Options"::" " then begin
                                        LoanApplic.Reset();
                                        LoanApplic.SetRange("TopUp Loan", PostLoan."No.");
                                        if LoanApplic.FindFirst() then begin
                                            PostLoan."EFT Options" := LoanApplic."EFT Options";
                                            PostLoan.Modify(true)
                                        end
                                    end
                                end
                            end
                        end;
                        Loans.Reset();
                        if not EftHeader."Suggest All Product" then begin
                            case EftHeader."EFT Options" of
                                EftHeader."EFT Options"::"Bank Account",
                                EftHeader."EFT Options"::"Mobile Money":
                                    begin
                                        Loans.SetRange("Product Type", EftHeader."Product Type");
                                        Loans.SetRange("EFT Options", EftHeader."EFT Options");
                                    end;
                                EftHeader."EFT Options"::"Money Wallet":
                                    begin
                                        Loans.SetRange("EFT Options", EftHeader."EFT Options");
                                    end;
                            end;
                        end;

                        if EftHeader."Suggest Single Loan" then begin
                            Loans.SetRange("No.", EftHeader."Loan No.");
                        end else begin
                            Loans.SetFilter("Disbursement Date", DFilter);
                        end;
                        Loans.SetFilter("Approval Status", '%1 | %2', Loans."Approval Status"::Approved, Loans."Approval Status"::Posted);
                        if Loans.FindSet() then begin
                            repeat

                                Loans.CalcFields("Outstanding Balance");
                                if Loans."Outstanding Balance" > 0 then begin

                                    if Loans."Batch No." <> '' then begin
                                        EftHeader.TestField("Re-suggest Application", true);
                                        EftHeader.TestField("Reason for Re-suggestion");
                                    end;

                                    if Loans."Mode of Disbursement" = Loans."Mode of Disbursement"::"Full Disbursement" then begin

                                        EftTransferLine.Reset();
                                        EftTransferLine.SetRange("Loan No.", Loans."No.");
                                        if not EftTransferLine.FindFirst() then begin

                                            EftLine.Init();
                                            EftLine.No := '';
                                            EftLine."Document No." := EftHeader."No.";
                                            EftLine."Product Type" := Loans."Product Type";
                                            EftLine."Application Source" := EftHeader."Application Source";
                                            EftLine."EFT Options" := Loans."EFT Options";
                                            EftLine."Disbursement Date" := Loans."Disbursement Date";
                                            EftLine.Type := EftLine.Type::Loan;
                                            EftLine.Validate("Loan No.", Loans."No.");
                                            EftLine."Account Type" := EftLine."Account Type"::Savings;
                                            EftLine.Validate("Account No.", Loans."Disbursement Account No.");
                                            EftLine.Validate("Bank Code", Loans."Payment Destination Code");

                                            BanksList.Reset();
                                            BanksList.Setrange(Code, Loans."Payment Destination Code");
                                            if BanksList.FindFirst() then begin

                                                if BanksList."Institution Type" = BanksList."Institution Type"::Bank then begin
                                                    EftLine.Validate("External Account No.", Loans."Payment Destination");
                                                    EftLine."Institution Type" := EftLine."Institution Type"::Bank;
                                                    EftLine."Recipient Reference" := Loans."Product Description";
                                                    EftLine."Own Reference" := EftLine."Member No.";
                                                    EftLine."Society Code" := '';
                                                end else begin

                                                    EftLine.Validate("External Account No.", BanksList."Society Code");
                                                    EftLine."Institution Type" := EftLine."Institution Type"::"Building Society";
                                                    EftLine."Society Code" := BanksList."Society Code";
                                                    EftLine."Own Reference" := EftLine."Member No.";
                                                    EftLine."Recipient Reference" := Loans."Payment Destination";
                                                end;
                                                EftLine.Validate("Branch Code", BanksList."Bank No.");
                                            end;

                                            if LnApplication.Get(Loans."Application No.") then
                                                EftLine."IBAN No." := LnApplication."Swift Code";
                                            EftLine."Mobile Phone No." := LnApplication."Mobile Phone No.";
                                            if EftLine."Mobile Phone No." = '' then begin
                                                if CustRec.Get(EftLine."Member No.") then
                                                    EftLine."Mobile Phone No." := CustRec."Mobile Phone No";
                                            end;
                                            EftLine.insert(true);
                                        end else begin

                                            if (Loans."TopUp Loan" <> '') or (EftHeader."Re-suggest Application") then begin

                                                EftLine.Init();
                                                EftLine.No := '';
                                                EftLine."Document No." := EftHeader."No.";
                                                EftLine."Product Type" := Loans."Product Type";
                                                EftLine."Application Source" := EftHeader."Application Source";
                                                EftLine."EFT Options" := Loans."EFT Options";
                                                EftLine."Disbursement Date" := Loans."Disbursement Date";
                                                EftLine.Type := EftLine.Type::Loan;
                                                EftLine.Validate("Loan No.", Loans."No.");
                                                EftLine."Account Type" := EftLine."Account Type"::Savings;
                                                EftLine.Validate("Account No.", Loans."Disbursement Account No.");
                                                EftLine.Validate("Bank Code", Loans."Payment Destination Code");

                                                BanksList.Reset();
                                                BanksList.Setrange(Code, Loans."Payment Destination Code");
                                                if BanksList.FindFirst() then begin

                                                    if BanksList."Institution Type" = BanksList."Institution Type"::Bank then begin
                                                        EftLine.Validate("External Account No.", Loans."Payment Destination");
                                                        EftLine."Institution Type" := EftLine."Institution Type"::Bank;
                                                        EftLine."Recipient Reference" := Loans."Product Description";
                                                        EftLine."Own Reference" := EftLine."Member No.";
                                                        EftLine."Society Code" := '';
                                                    end else begin

                                                        EftLine.Validate("External Account No.", BanksList."Society Code");
                                                        EftLine."Institution Type" := EftLine."Institution Type"::"Building Society";
                                                        EftLine."Society Code" := BanksList."Society Code";
                                                        EftLine."Own Reference" := EftLine."Member No.";
                                                        EftLine."Recipient Reference" := Loans."Payment Destination";
                                                    end;
                                                    EftLine.Validate("Branch Code", BanksList."Bank No.");
                                                end;

                                                if LnApplication.Get(Loans."Application No.") then
                                                    EftLine."IBAN No." := LnApplication."Swift Code";
                                                EftLine."Mobile Phone No." := LnApplication."Mobile Phone No.";
                                                if EftLine."Mobile Phone No." = '' then begin
                                                    if CustRec.Get(EftLine."Member No.") then
                                                        EftLine."Mobile Phone No." := CustRec."Mobile Phone No";
                                                end;
                                                EftLine.insert(true);

                                            end;
                                        end;

                                        ExternalCommitment.Reset();
                                        ExternalCommitment.SetRange("Application No.", Loans."Application No.");
                                        if ExternalCommitment.Find('-') then begin
                                            repeat

                                                EftScheduleLine.Reset();
                                                EftScheduleLine.SetRange("External Committment No.", ExternalCommitment."Entry No.");
                                                if not EftScheduleLine.Find('-') then begin

                                                    RegMngt.CreateEFTLineEntry(0, EftHeader."No.", Loans."No.",
                                                    ExternalCommitment."Entry No.", ExternalCommitment."Payment Destination Code",
                                                    ExternalCommitment."External Account No.",
                                                    ExternalCommitment."Recipient Reference", ExternalCommitment."Branch Code",
                                                    ExternalCommitment."Mobile Phone No.", ExternalCommitment.Amount,
                                                    ExternalCommitment."External Account Name", true, '');
                                                end;
                                            until ExternalCommitment.Next() = 0
                                        end;

                                    end else begin
                                        PartialDisb.Reset();
                                        PartialDisb.SetRange("Loan No.", Loans."No.");
                                        PartialDisb.SetRange("Approval Status", PartialDisb."Approval Status"::Posted);
                                        if PartialDisb.FindSet() then begin
                                            repeat
                                                EftScheduleLine.Reset();
                                                EftScheduleLine.SetRange("Partial Loan No.", PartialDisb."Entry No");
                                                if not EftScheduleLine.Find('-') then begin

                                                    RegMngt.CreateEFTLineEntry(0, EftHeader."No.",
                                                    Loans."No.", 0, PartialDisb."Payment Destination Code",
                                                    PartialDisb."External Account No.", PartialDisb."Recipient Reference",
                                                    PartialDisb."Branch Code", PartialDisb."Mobile Phone No.",
                                                    PartialDisb.Amount, PartialDisb."External Account Name", true, PartialDisb."Entry No");
                                                end;
                                            Until PartialDisb.Next() = 0;
                                        end;
                                    end;

                                end;
                            until Loans.Next() = 0;
                        end
                    end else begin
                        Error('Application Status must be equal to Open');
                    end;
                end;
            2:
                begin
                    EftHeader.Reset();
                    EftHeader.SetRange("No.", EftHeaderNo);
                    EftHeader.SetRange("Approval Status", EftHeader."Approval Status"::Approved);
                    EftHeader.SetRange("Source of funds", EftHeader."Source of funds"::"Loan Proceed");
                    if EftHeader.FindFirst() then begin
                        EftLine.Reset();
                        EftLine.SetRange("Document No.", EftHeader."No.");
                        if EftLine.FindSet() then begin
                            repeat
                            until EftLine.Next() = 0;
                        end;
                    end;
                end;
        end;
    end;

    procedure CreateEftLineOnSingleEntry(EftHeaderNo: Code[50]; ProductID: Code[20]; AppDate: Date; ValuePost: Integer)
    var
        EftHeader: Record "EFT Transfer Header";
        EftLine: Record "EFT Transfer Lines";
        EftTransferLine: Record "EFT Transfer Lines";
        PLoan: Record Loans;
        LnApplication: Record "Loan Application";
        CustBank: Record "Cust. Bank Account";
        BanksList: Record Banks;
        CustRec: Record Member;
        Text0001: Label 'This action will clear all entries on EFT Transfer Lines. Are you want to continue?';
        Text0002: Label 'This action will suggest Loans on EFT Transfer Lines. Are you want to continue?';
        Text0003: Label 'Loan No. %1 already attached to EFT No. %2';
        DFilter: Text[50];
        PartialDisb: Record "Partial Disbursement Schedule";
        OtherCommitment: Record "Other Commitements Clearance";
        ExternalCommitment: Record "Other Commitements Clearance";
        EftScheduleLine: Record "EFT Transfer Lines";
        TotalCommittment: Decimal;
        RegMngt: Codeunit "Register Management";
        LoanApp: Record "Loan Application";
        AccBanking: Record "Account Banking";

    begin
        DFilter := '';

        case ValuePost of
            0:
                begin
                    if Confirm(Text0001, true) = false then exit;

                    EftHeader.Reset();
                    EftHeader.SetRange("No.", EftHeaderNo);
                    EftHeader.SetRange("Approval Status", EftHeader."Approval Status"::Open);
                    EftHeader.SetRange("Source of funds", EftHeader."Source of funds"::"Loan Proceed");
                    if EftHeader.FindFirst() then begin
                        EftLine.reset();
                        EftLine.SetRange("Document No.", EftHeader."No.");
                        EftLine.DeleteAll();
                    end else begin
                        Error('Application Status must equal to -Open');
                    end;
                end;
            1:
                begin
                    if Confirm(Text0002, true) = false then exit;

                    EftHeader.Reset();
                    EftHeader.SetRange("No.", EftHeaderNo);
                    EftHeader.SetRange("Approval Status", EftHeader."Approval Status"::Open);
                    EftHeader.SetRange("Source of funds", EftHeader."Source of funds"::"Loan Proceed");
                    if EftHeader.FindFirst() then begin

                        DFilter := Format(EftHeader."Start Date") + '..' + Format(EftHeader."End Date");

                        ExternalCommitment.Reset();
                        ExternalCommitment.SetFilter("Disbursement Date", DFilter);
                        ExternalCommitment.SetRange("EFT Options", EftHeader."EFT Options");
                        ExternalCommitment.SetRange("Approval Status", ExternalCommitment."Approval Status"::Posted);
                        if ExternalCommitment.Find('-') then begin

                            LoanApp.Reset();
                            LoanApp.SetRange("No.", ExternalCommitment."Application No.");
                            if LoanApp.FindFirst() then begin

                                PLoan.Reset();
                                PLoan.SetRange("EFT Options", EftHeader."EFT Options");
                                PLoan.SetRange("Application No.", LoanApp."No.");
                                if PLoan.Find('-') then begin

                                    if AccBanking.Get(PLoan."Disbursement Account No.") then
                                        AccBanking.CalcFields("Balance (LCY)");

                                    EftScheduleLine.Reset();
                                    EftScheduleLine.SetRange("External Committment No.", ExternalCommitment."Entry No.");
                                    if not EftScheduleLine.Find('-') then begin

                                        RegMngt.CreateEFTLineEntry(1, EftHeader."No.", PLoan."No.", 0, '', '', '', '', '',
                                        (AccBanking."Balance (LCY)" - ExternalCommitment.GetTotalCommit(LoanApp."No.")),
                                         '', true, '');
                                    end;
                                end;
                            end;

                            repeat
                                if LoanApp.Get(ExternalCommitment."Application No.") then begin
                                    PLoan.Reset();
                                    PLoan.SetRange("Application No.", LoanApp."No.");
                                    if PLoan.FindFirst() then begin

                                        EftScheduleLine.Reset();
                                        EftScheduleLine.SetRange("External Committment No.", ExternalCommitment."Entry No.");
                                        if not EftScheduleLine.Find('-') then begin
                                            RegMngt.CreateEFTLineEntry(0, EftHeader."No.", PLoan."No.", ExternalCommitment."Entry No.",
                                            ExternalCommitment."Payment Destination Code", ExternalCommitment."External Account No.",
                                            ExternalCommitment."Recipient Reference", ExternalCommitment."Branch Code",
                                            ExternalCommitment."Mobile Phone No.", ExternalCommitment.Amount,
                                            ExternalCommitment."External Account Name", true, '');
                                        end;
                                    end
                                end;

                            Until ExternalCommitment.Next() = 0;
                        end else begin

                            Loans.Reset();
                            Loans.SetFilter("Disbursement Date", DFilter);
                            if not EftHeader."Suggest All Product" then begin
                                if EftHeader."EFT Options" = EftHeader."EFT Options"::"Bank Account" then begin
                                    Loans.SetRange("Product Type", EftHeader."Product Type");
                                    Loans.SetRange("EFT Options", EftHeader."EFT Options");
                                end else begin
                                    Loans.SetRange("EFT Options", EftHeader."EFT Options");
                                end;
                            end;
                            Loans.SetRange("Approval Status", Loans."Approval Status"::Posted);
                            if Loans.Find('-') then begin
                                repeat

                                    Loans.CalcFields("Outstanding Balance");
                                    if Loans."Outstanding Balance" > 0 then begin

                                        if Loans."EFT Options" = EftHeader."EFT Options" then begin

                                            case Loans."Mode of Disbursement" of
                                                Loans."Mode of Disbursement"::"Full Disbursement":
                                                    begin
                                                        RegMngt.CheckEFTExistLine(EftHeader, Loans."No.");
                                                        RegMngt.CreateEFTLineEntry(1, EftHeader."No.", Loans."No.",
                                                         0, '', '', '', '', '', 0, '', false, '');
                                                    end;
                                                Loans."Mode of Disbursement"::"Partial Disbursement":
                                                    begin

                                                        PartialDisb.Reset();
                                                        PartialDisb.SetRange("Loan No.", Loans."No.");
                                                        PartialDisb.SetRange("EFT Options", EftHeader."EFT Options");
                                                        PartialDisb.SetRange("Approval Status", PartialDisb."Approval Status"::Posted);
                                                        if PartialDisb.FindFirst() then begin
                                                            repeat
                                                                EftScheduleLine.Reset();
                                                                EftScheduleLine.SetRange("Partial Loan No.", PartialDisb."Entry No");
                                                                if not EftScheduleLine.Find('-') then begin

                                                                    RegMngt.CreateEFTLineEntry(0, EftHeader."No.", Loans."No.", 0,
                                                                    PartialDisb."Payment Destination Code", PartialDisb."External Account No.",
                                                                    PartialDisb."Recipient Reference", PartialDisb."Branch Code",
                                                                    PartialDisb."Mobile Phone No.", PartialDisb.Amount,
                                                                    PartialDisb."External Account Name", true, PartialDisb."Entry No");
                                                                end;
                                                            until PartialDisb.Next() = 0;
                                                        end;
                                                    end;
                                            end
                                        end;
                                    end;
                                until Loans.Next() = 0;
                            end;
                        end;
                    end else begin
                        Error('Application Status must be equal to Open');
                    end;
                end;
        end;
    end;

    procedure ElectronicFundsProcessing(ElectronicFundsH: Record "EFT Transfer Header"; PostInt: Integer; PrintInteger: Boolean)
    var
        Text002: Label 'Your application for fund transfer has been effect by ';
        Text003: Label 'Follow up using Reference No. ';
        Text004: Label 'The transaction has already been Processed.';
        ElectronicFundsL: Record "EFT Transfer Lines";
        Text005: Label 'Destnation account name of staff no %1 more than 28 characters.';
        Text006: Label 'Destnation account of staff no %1 more than 14 characters.';
        Text007: Label 'Posted successfully.';
        ChargeAmount: Decimal;
        TransactionCharges: Record "Transaction Charge";
        TariffDetails: Record "Tiered Charges Line";
        TCharges: Decimal;
        FundTransfer: Label 'Fund Transfer';
        MobileNo: Code[20];
        CashierTransactions: Record "Teller Transaction";
        ChargesNet: Decimal;
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        ElectronicF: Record "EFT Transfer Header";
        RecLoan: Record Loans;
        VarVariant: Variant;
        Docx: Codeunit "Doc. Mngt";
        OtherCommittment: Record "Other Commitements Clearance";
        PartialDisb: Record "Partial Disbursement Schedule";
        ProdFact: Record "Product Factory";
        AccountTypes: Record "Product Factory";
        AccBanking: Record "Account Banking";
        JuniorTransType: code[10];
        TotalCharge: Decimal;
        Text0008: Label 'No enough funds for this transaction';
    begin

        Gensetup.Get();
        Temp.Get(UserId);
        Temp.TestField(Temp."Cashier Journal Template");
        Temp.TestField(Temp."Cashier Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");

        Jtemplate := Temp."Cashier Journal Template";
        JBatch := Temp."Cashier Journal Batch";
        JnlPostMngt.ClearJournalLines(Jtemplate, JBatch);
        ElectronicFundsH.TestField("Approval Status", ElectronicFundsH."Approval Status"::Approved);

        if ElectronicFundsH."Approval Status" = ElectronicFundsH."Approval Status"::Transferred then
            Error(Text004);
        ElectronicFundsH.CalcFields(ElectronicFundsH."Record Total");

        ElectronicFundsJournal(Jtemplate, JBatch, Today, ElectronicFundsH."No.", '',
        ElectronicFundsH."Account Type", ElectronicFundsH."Account No.",
                        PadStr('EFT To-' + format(ElectronicFundsH."EFT Options"), 50),
                        -ElectronicFundsH."Record Total", ElectronicFundsH."Shortcut Dimension 1 Code",
                        ElectronicFundsH."Shortcut Dimension 2 Code", BalAccountType, '');

        ElectronicFundsL.Reset;
        ElectronicFundsL.SetRange(Posted, false);
        ElectronicFundsL.SetRange(ElectronicFundsL."Document No.", ElectronicFundsH."No.");
        if ElectronicFundsL.Find('-') then begin
            repeat

                ElectronicFundsL.TestField(ElectronicFundsL."Account No.");
                ElectronicFundsL.TestField(ElectronicFundsL."Account Name");
                ElectronicFundsL.TestField(ElectronicFundsL.Amount);
                ElectronicFundsL.TestField(ElectronicFundsL."Bank Code");
                ElectronicFundsL.TestField(ElectronicFundsL."Bank Name");

                if StrLen(ElectronicFundsL."Account Name") > 150 then
                    Error(Text005, ElectronicFundsL."Account No.");

                if StrLen(ElectronicFundsL."External Account No.") > 100 then
                    Error(Text006, ElectronicFundsL."External Account No.");

                case ElectronicFundsH."Application Source" of

                    ElectronicFundsH."Application Source"::Credit:
                        begin
                            AccNo := ElectronicFundsL."Account No.";
                            AccTypes := AccTypes::Vendor;

                        end;
                    ElectronicFundsH."Application Source"::Teller,
                    ElectronicFundsH."Application Source"::Benefits,
                ElectronicFundsH."Application Source"::Finance:
                        begin
                            if ProdFact.Get(ElectronicFundsH."Product Type") then begin

                                if ProdFact."Account Dimension" = ProdFact."Account Dimension"::Banking then begin
                                    AccNo := ElectronicFundsL."Account No.";
                                    AccTypes := AccTypes::Vendor;

                                end;
                                if ProdFact."Account Dimension" = ProdFact."Account Dimension"::Credit then begin
                                    AccNo := ElectronicFundsL."Account No.";
                                    AccTypes := AccTypes::Customer;

                                end;

                            end;

                        end;
                end;

                ElectronicFundsJournal(Jtemplate, JBatch, Today,
                ElectronicFundsH."No.", '', AccTypes, AccNo,
                 PadStr('EFT To Account ' + format(ElectronicFundsH."EFT Options"), 50),
                 ElectronicFundsL.Amount, '', '', BalAccountType, '');

                if ElectronicFundsH."Application Source" = ElectronicFundsH."Application Source"::Credit then begin

                    //Charge Posting
                    if not ElectronicFundsL."Don't Charge" then begin
                        ChargeAmount := 0;
                        ChargesNet := 0;
                        TransactionCharges.Reset;
                        TransactionCharges.SetRange("Transaction Type", ElectronicFundsH."Transaction Type");
                        if TransactionCharges.Find('-') then begin
                            repeat
                                ChargeAmount := 0;
                                ChargesNet := 0;
                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" then
                                    ChargeAmount += (ElectronicFundsL.Amount * TransactionCharges."Percentage of Amount") * 0.01
                                else
                                    ChargeAmount += TransactionCharges."Charge Amount";

                                if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                    TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                    TariffDetails.Reset;
                                    TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                    if TariffDetails.Find('-') then begin
                                        repeat
                                            if (ElectronicFundsL.Amount >= TariffDetails."Lower Limit") and (ElectronicFundsL.Amount <= TariffDetails."Upper Limit") then begin
                                                if TariffDetails."Use Percentage" then
                                                    ChargeAmount += ElectronicFundsL.Amount * TariffDetails.Percentage * 0.01
                                                else
                                                    ChargeAmount += TariffDetails."Charge Amount";
                                            end;
                                        until TariffDetails.Next = 0;
                                    end;
                                end;

                                //DEBIT ACCOUNT
                                ElectronicFundsJournal(Jtemplate, JBatch, Today, ElectronicFundsH."No.", '',
                                AccTypes, ElectronicFundsL."Account No.",
                                        PadStr(TransactionCharges.Description, 50),
                                        ChargeAmount,
                                         ElectronicFundsH."Shortcut Dimension 1 Code",
                                        ElectronicFundsH."Shortcut Dimension 2 Code",
                                         AccTypes::"G/L Account", TransactionCharges."G/L Account");
                                ChargesNet := ChargeAmount;

                                //CREDIT Excise Duty GL
                                Gensetup.Get;
                                Gensetup.TestField("Excise Duty (%)");
                                Gensetup.TestField("Excise Duty G/L");
                                ElectronicFundsJournal(Jtemplate, JBatch, Today, ElectronicFundsH."No.", '',
                                AccTypes, ElectronicFundsL."Account No.", PadStr(FundTransfer + ' :- ' + 'Excise Duty', 50),
                                    ChargeAmount * (Gensetup."Excise Duty (%)" / 100),
                                    ElectronicFundsH."Shortcut Dimension 1 Code",
                                    ElectronicFundsH."Shortcut Dimension 2 Code",
                                    AccTypes::"G/L Account", Gensetup."Excise Duty G/L");
                            until TransactionCharges.Next = 0;
                            TCharges := ChargeAmount;
                        end;
                    end;

                    JuniorTransType := '';

                    AccountTypes.Get(ElectronicFundsL."Product Type");
                    if PostInt = 1 then begin

                        if AccountTypes."Charge Subsiquent withdrawal" then begin

                            TotalCharge := 0;
                            JuniorTransType := TellMngt.getSubsiquenTransType(AccountTypes."Product ID");
                            TotalCharge := CalculateTransactCharges(ElectronicFundsL.Amount, JuniorTransType, 1, true);
                            if JuniorTransType = '' then Error('No Charge type found associated with this account.');

                            AccBanking.Reset();
                            AccBanking.SetRange("No.", ElectronicFundsL."Account No.");
                            if AccBanking.FindFirst() then begin

                                if AccBanking."Next Withdrawal Date" = 0D then begin
                                    AccBanking."Last Withdrawal Date" := Today;
                                    AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Today);
                                    AccBanking.Modify(true);

                                end else begin

                                    if Today <= AccBanking."Next Withdrawal Date" then begin
                                        if (TotalCharge + ElectronicFundsL.Amount) > TellMngt.CalcAvailableBal(AccBanking."No.") then
                                            Error(Text0008);

                                        TellMngt.fnPostAccTransferCharges(JuniorTransType,
                                         AccBanking."No.", ElectronicFundsL.Amount, Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code", Jtemplate, JBatch, ElectronicFundsH."No.",
                                        Today);

                                        AccBanking."Last Withdrawal Date" := Today;
                                        AccBanking.Modify(true)
                                    end else begin

                                        AccBanking."Last Withdrawal Date" := Today;
                                        AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", AccBanking."Next Withdrawal Date");
                                        AccBanking.Modify(true)
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            until ElectronicFundsL.Next = 0;
        end;

        if PostInt = 1 then begin

            JnlPostMngt.CompletePosting(Jtemplate, JBatch);
            Post := false;
            Post := JournlPosted.PostedSuccessfully;

            ElectronicFundsL.Reset;
            ElectronicFundsL.SetRange(ElectronicFundsL."Document No.", ElectronicFundsH."No.");
            ElectronicFundsL.SetRange(ElectronicFundsL.Transferred, false);
            if ElectronicFundsL.Find('-') then begin
                repeat

                    Commit();
                    ElectronicFundsL.Posted := true;
                    ElectronicFundsL."Date Posted" := Today;
                    ElectronicFundsL."Posted By" := UserId;
                    ElectronicFundsL.Modify(true);

                    if AccBanking.Get(ElectronicFundsL."Account No.") then begin
                        if ElectronicFundsH."Source of funds" = ElectronicFundsH."Source of funds"::Refunds then begin
                            if AccBanking.Status = AccBanking.Status::Withdrawn then begin
                                AccBanking.Blocked := AccBanking.Blocked::All;
                            end
                        end;

                        if AccountTypes.GET(AccBanking."Product Type") then begin
                            if AccountTypes."Charge Subsiquent withdrawal" then begin
                                AccountTypes.TestField("Withdrawal Interval");
                                AccBanking."Last Withdrawal Date" := Today;
                                if AccBanking."Next Withdrawal Date" = 0D then
                                    AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", Today) else
                                    AccBanking."Next Withdrawal Date" := CalcDate(AccountTypes."Withdrawal Interval", AccBanking."Next Withdrawal Date");
                                AccBanking.Modify(true);
                            end;
                        end
                    end;
                    if RecLoan.Get(ElectronicFundsL."Loan No.") then begin
                        RecLoan."Batch No." := ElectronicFundsL."Document No.";
                        RecLoan.Modify(true);
                    end;

                    PartialDisb.Reset();
                    PartialDisb.SetRange("Entry No", ElectronicFundsL."Partial Loan No.");
                    if PartialDisb.Find('-') then begin
                        PartialDisb.Posted := true;
                        PartialDisb.Modify(true);
                        PartialDisb."Approval Status" := PartialDisb."Approval Status"::Posted;
                    end;

                    OtherCommittment.Reset();
                    OtherCommittment.SetRange("Entry No.", ElectronicFundsL."External Committment No.");
                    if OtherCommittment.Find('-') then begin
                        OtherCommittment."EFT No." := ElectronicFundsL."Document No.";
                        OtherCommittment."EFT Line No." := ElectronicFundsL.No;
                        OtherCommittment.Modify(true)
                    end;

                    case ElectronicFundsL."Account Type" of
                        ElectronicFundsL."Account Type"::Savings:
                            begin
                                if SavingsAcc.Get(ElectronicFundsL."Account No.") then
                                    if SavingsAcc."Mobile No." <> '' then
                                        MobileNo := SavingsAcc."Mobile No.";
                                SendSMS.CreateSmsNotif(SourceType::"EFT Effected", MobileNo, Text002 + CompanyName + ', ' + Text003 +
                                ElectronicFundsH."No.", ElectronicFundsH."No.", SavingsAcc."No.", false);
                            end;
                    end;
                until ElectronicFundsL.Next = 0;
            end;

            ElectronicFundsH."Approval Status" := ElectronicFundsH."Approval Status"::Posted;
            ElectronicFundsH."Date Transferred" := Today;
            ElectronicFundsH."Time Transferred" := Time;
            ElectronicFundsH."Transferred By" := UserId;
            ElectronicFundsH.Modify;

            if PrintInteger then begin
                Commit();
                ElectronicF.Reset();
                ElectronicF.SetRange("No.", ElectronicFundsH."No.");
                if ElectronicF.FindFirst() then begin
                    Report.Run(Report::"EFT Report", true, false, ElectronicF);
                end;
            end;
            Message(Text007);
        end else begin
            VarVariant := ElectronicFundsH;
            Commit();
            Docx.DocPrintstatement(VarVariant, 0);
        end;
    end;

    procedure ElectronicFundsJournal(Jtemplate: Code[10]; JBatch: Code[10]; PostingDate: Date; DocNo: Code[20]; ExtDocNo: Code[20]; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; Desc: Text; JnlAmount: Decimal; GlobalDim1: Code[20]; GlobalDim2: Code[20]; BalAccountType: Enum "Gen. Journal Account Type"; BalAccountNo: Code[20])
    begin
        LineNo += 10000;
        GenJLine.Init;
        GenJLine."Journal Template Name" := Jtemplate;
        GenJLine."Journal Batch Name" := JBatch;
        GenJLine."Line No." := LineNo;
        GenJLine."Posting Date" := PostingDate;
        GenJLine."Document No." := DocNo;
        GenJLine."External Document No." := ExtDocNo;
        GenJLine."Account Type" := AccountType;
        GenJLine.Validate(GenJLine."Account No.", AccountNo);
        GenJLine.Description := Desc;
        GenJLine.Validate(GenJLine.Amount, JnlAmount);
        GenJLine.Validate(GenJLine."Shortcut Dimension 1 Code", GlobalDim1);
        GenJLine.Validate(GenJLine."Shortcut Dimension 2 Code", GlobalDim2);
        GenJLine."Bal. Account Type" := BalAccountType;
        GenJLine.Validate(GenJLine."Bal. Account No.", BalAccountNo);
        if GenJLine.Amount <> 0 then
            GenJLine.Insert(true);
    end;

    procedure ActionPane(var Variant: Variant; ActionItem: Integer)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Action Item %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        TellerTransaction: Record "Teller Transaction";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Teller Transaction":
                begin
                    RecRef.SetTable(TellerTransaction);
                    case ActionItem of
                        0:
                            begin
                                ApprovalMgmt.OnSendTellerTransactionApprovalRequest(TellerTransaction);
                            end;
                        1:
                            begin
                                ApprovalMgmt.OnCancelTellerTransactionApprovalRequest(TellerTransaction, true, true)
                            end;
                        2:
                            begin
                                ApprovalMgmt.OnOpenTellerTransactionApprovalRequest(TellerTransaction, true, true)
                            end;
                        3:
                            begin
                                ApprovalMgmt.OpenApprovalEntriesPage(TellerTransaction."No.", 52147202);
                            end;
                        4:
                            begin
                                VarVariant := TellerTransaction;
                                DocMngt.DocPrintstatement(VarVariant, 0);
                            end;
                        5:
                            begin
                            end;
                    end;
                    Variant := TellerTransaction
                end;
            else
                Error(UnsupportedRecordTypeErr, ActionItem);
        end
    end;



    procedure PerformPostOnStandingOrder(IncomeType: Option Periodic,Salary,Pension,Milk,Tea,Coffee; StoNo: Code[50]; PostInt: Integer)
    var
        RunBal: Decimal;
        StandingRegister: Record "Standing Order Register";
        OrderLines: Record "Standing Order Lines";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        AmtPosted: Decimal;
        LoanApps: Record Loans;
        InitGenPost: Codeunit "Initialize Gen. Jnl.-Post";
        PostType: Enum "LoanTransactionType";
        LoanRep: Decimal;
        Journaline: Record "Gen. Journal Line";
        AccCredit: Record "Account Credit";
        LInterest: Decimal;
        LPrincipal: Decimal;
        LRepayment: Decimal;
        LBalance: Decimal;
        DeductionStatus: Option " ",Successfull,"Partial Deduction",Failed;
        AmounDeduct: Decimal;
        AvailAmt: Decimal;
        FosaBal: Decimal;
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("STO Journal Template");
        Temp.TestField("STO Journal Batch");
        Gensetup.Get();

        JnlPostMngt.ClearJournalLines(Temp."STO Journal Template", Temp."STO Journal Batch");

        StandingOrderH.Reset();
        StandingOrderH.SetCurrentKey("No.");
        StandingOrderH.SetRange("Income Type", IncomeType);
        StandingOrderH.SetRange("No.", STONo);
        StandingOrderH.SetRange("Approval Status", StandingOrderH."Approval Status"::Approved);
        if StandingOrderH.FindFirst() then begin

            StandingOrderH.CalcFields("Allocated Amount");
            StandingOrderH.TestField(Amount, StandingOrderH."Allocated Amount");

            RunBal := 0;
            AvailAmt := 0;
            AmtPosted := 0;
            AmounDeduct := 0;
            FosaBal := 0;

            AccBanking.Reset();
            AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
            AccBanking.SetRange("No.", StandingOrderH."Source Account No.");
            if AccBanking.FindFirst() then begin
                AccBanking.CalcFields(Balance, "Balance (LCY)");
                RunBal := TellerMngt.CalcAvailableBal(AccBanking."No.");
                FosaBal := TellerMngt.CalcAvailableBal(AccBanking."No.");
                StandingOrderH.CalcFields("Allocated Amount");

                if RunBal >= StandingOrderH."Allocated Amount" then
                    RunBal := StandingOrderH."Allocated Amount" else
                    RunBal := RunBal;
                AvailAmt := RunBal;

                if StandingOrderH."Transaction Type" <> '' then begin
                    if RunBal > 0 then begin
                        TellerMngt.fnPostAccTransferCharges(StandingOrderH."Transaction Type",
                        AccBanking."No.", StandingOrderH."Allocated Amount",
                        Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                        Temp."STO Journal Template", Temp."STO Journal Batch",
                        StandingOrderH."No.", Today);
                    end;
                end;

                OrderLines.Reset();
                OrderLines.SetRange("Document No.", StandingOrderH."No.");
                //OrderLines.SetRange(Status, OrderLines.Status::"Approved");
                if OrderLines.Find('-') then begin
                    repeat

                        case OrderLines."Destination Account Type" of
                            Orderlines."Destination Account Type"::Savings,
                            Orderlines."Destination Account Type"::"Bank Account",
                            Orderlines."Destination Account Type"::"G/L Account":
                                begin
                                    if RunBal > 0 then begin

                                        GenJournaline.LockTable();
                                        LineNo := LineNo + 10;
                                        GenJournaline.Init();
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                        GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                        GenJournaline."Posting Date" := Today;
                                        GenJournaline."Document No." := StandingOrderH."No.";
                                        GenJournaline.Validate("Currency Code", '');
                                        GenJournaline."Document Date" := Today;
                                        GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' + StandingOrderH.Description, 1, 50);
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                        GenJournaline.Validate("Account No.", StandingOrderH."Source Account No.");
                                        if RunBal > OrderLines.Amount then
                                            GenJournaline.Validate(Amount, OrderLines.Amount) else
                                            GenJournaline.Validate(Amount, RunBal);
                                        GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                        GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);


                                        GenJournaline.Init();
                                        LineNo := LineNo + 1000;
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                        GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                        GenJournaline."Posting Date" := Today;
                                        GenJournaline."Document No." := StandingOrderH."No.";
                                        GenJournaline.Validate("Currency Code", '');
                                        GenJournaline."Document Date" := Today;
                                        GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' + OrderLines."Destination Account Name", 1, 50);
                                        if OrderLines."Destination Account Type" = OrderLines."Destination Account Type"::Savings then
                                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor else
                                            GenJournaline."Account Type" := OrderLines."Destination Account Type";
                                        GenJournaline.Validate("Account No.", OrderLines."Destination Account No.");
                                        if RunBal > OrderLines.Amount then
                                            GenJournaline.Validate(Amount, OrderLines.Amount * -1) else
                                            GenJournaline.Validate(Amount, RunBal * -1);
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);
                                        RunBal := RunBal - Abs(GenJournaline.Amount);
                                        AmounDeduct := AmounDeduct + Abs(GenJournaline.Amount);
                                    end;
                                end;

                            OrderLines."Destination Account Type"::Credit:
                                begin
                                    if RunBal > 0 then begin
                                        GenJournaline.Init();
                                        LineNo := LineNo + 10;
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                        GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                        GenJournaline."Posting Date" := Today;
                                        GenJournaline."Document No." := StandingOrderH."No.";
                                        GenJournaline.Validate("Currency Code", '');
                                        GenJournaline."Document Date" := Today;
                                        GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' + format(OrderLines."Destination Account Type"), 1, 50);
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                        GenJournaline.Validate("Account No.", StandingOrderH."Source Account No.");
                                        if RunBal > OrderLines.Amount then
                                            GenJournaline.Validate(Amount, OrderLines.Amount) else
                                            GenJournaline.Validate(Amount, RunBal);
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);

                                        LineNo := LineNo + 10;
                                        GenJournaline.Init();
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                        GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                        GenJournaline."Posting Date" := Today;
                                        GenJournaline."Document No." := StandingOrderH."No.";
                                        GenJournaline.Validate("Currency Code", '');
                                        GenJournaline."Document Date" := Today;
                                        GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' + OrderLines."Destination Account Name", 1, 50);
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                        GenJournaline.Validate("Account No.", OrderLines."Destination Account No.");
                                        if RunBal > OrderLines.Amount then
                                            GenJournaline.Validate(Amount, OrderLines.Amount * -1) else
                                            GenJournaline.Validate(Amount, RunBal * -1);
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);
                                        RunBal := RunBal - Abs(GenJournaline.Amount);
                                        AmounDeduct := AmounDeduct + Abs(GenJournaline.Amount);
                                    end;
                                end;

                            OrderLines."Destination Account Type"::Loan:
                                begin
                                    LInterest := 0;
                                    LPrincipal := 0;
                                    LRepayment := 0;

                                    if RunBal > 0 then begin

                                        LoanApps.Reset();
                                        LoanApps.SetRange(LoanApps."No.", OrderLines."Loan No.");
                                        LoanApps.SetFilter("Outstanding Balance", '>0');
                                        IF LoanApps.Find('-') then begin

                                            LoanApps.CalcFields(LoanApps."Outstanding Interest",
                                            LoanApps."Outstanding Balance", "Outstanding Principal");
                                            if LoanApps."Outstanding Interest" > 0 then begin

                                                LInterest := LoanApps."Outstanding Interest";
                                                LPrincipal := (OrderLines.Amount - LInterest);
                                                if LPrincipal < 0 then
                                                    LPrincipal := 0;

                                                if OrderLines.Amount > LInterest then
                                                    OrderLines.Amount := LInterest else
                                                    OrderLines.Amount := OrderLines.Amount;
                                                LineNo := LineNo + 1000;
                                                GenJournaline.Init();
                                                GenJournaline."Line No." := LineNo;
                                                GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                                GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                                GenJournaline."Posting Date" := Today;
                                                GenJournaline."Document No." := StandingOrderH."No.";
                                                GenJournaline.Validate("Currency Code", '');
                                                GenJournaline."Document Date" := Today;
                                                GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' +
                                                format(PostType::"Interest Paid") + '-' + LoanApps."No.", 1, 50);
                                                GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                                GenJournaline.Validate("Account No.", StandingOrderH."Source Account No.");
                                                if RunBal > LInterest then
                                                    GenJournaline.Validate(Amount, LInterest) else
                                                    GenJournaline.Validate(Amount, RunBal);
                                                GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                                GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                                if GenJournaline.Amount <> 0 then
                                                    GenJournaline.Insert(true);

                                                GenJournaline.LockTable();
                                                LineNo := LineNo + 10000;
                                                GenJournaline.Init();
                                                GenJournaline."Line No." := LineNo;
                                                GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                                GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                                GenJournaline."Posting Date" := Today;
                                                GenJournaline."Document No." := StandingOrderH."No.";
                                                GenJournaline.Validate("Currency Code", '');
                                                GenJournaline."Document Date" := Today;
                                                GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                                GenJournaline.Validate("Account No.", LoanApps."Loan Account");
                                                if RunBal > LInterest then
                                                    GenJournaline.Validate(Amount, LInterest * -1) else
                                                    GenJournaline.Validate(Amount, RunBal * -1);
                                                GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' +
                                                Format(GenJournaline."Transaction Type") + '-' + LoanApps."No.", 1, 50);
                                                GenJournaline."Transaction Type" := GenJournaline."Transaction Type"::"Interest Paid";
                                                GenJournaline.Validate("Loan No.", LoanApps."No.");
                                                GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                                GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                                if GenJournaline.Amount <> 0 then
                                                    GenJournaline.Insert(true);
                                                RunBal := RunBal - Abs(GenJournaline.Amount);
                                                AmounDeduct := AmounDeduct + Abs(GenJournaline.Amount);
                                            end else begin
                                                LPrincipal := OrderLines.Amount;
                                            end;

                                            if RunBal > 0 then begin

                                                if LoanApps."Outstanding Principal" > 0 then begin
                                                    if LoanApps."Outstanding Principal" > LPrincipal then
                                                        LRepayment := LPrincipal else
                                                        LRepayment := LoanApps."Outstanding Principal";

                                                    GenJournaline.LockTable();
                                                    LineNo := LineNo + 1;
                                                    GenJournaline.Init();
                                                    GenJournaline."Line No." := LineNo;
                                                    GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                                    GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                                    GenJournaline."Posting Date" := Today;
                                                    GenJournaline."Document No." := StandingOrderH."No.";
                                                    GenJournaline.Validate("Currency Code", '');
                                                    GenJournaline."Document Date" := Today;
                                                    GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' +
                                                    format(PostType::Repayment) + '-' + LoanApps."No.", 1, 50);
                                                    GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                                    GenJournaline.Validate("Account No.", StandingOrderH."Source Account No.");
                                                    if RunBal > LRepayment then
                                                        GenJournaline.Validate(Amount, LRepayment) else
                                                        GenJournaline.Validate(Amount, RunBal);
                                                    GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                                    GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                                    if GenJournaline.Amount <> 0 then
                                                        GenJournaline.Insert(true);

                                                    LineNo := LineNo + 1;
                                                    GenJournaline.Init();
                                                    GenJournaline."Line No." := LineNo;
                                                    GenJournaline."Journal Template Name" := Temp."STO Journal Template";
                                                    GenJournaline."Journal Batch Name" := Temp."STO Journal Batch";
                                                    GenJournaline."Posting Date" := Today;
                                                    GenJournaline."Document No." := StandingOrderH."No.";
                                                    GenJournaline.Validate("Currency Code", '');
                                                    GenJournaline."Document Date" := Today;
                                                    GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                                    GenJournaline.Validate("Account No.", LoanApps."Loan Account");
                                                    if RunBal > LRepayment then
                                                        GenJournaline.Validate(Amount, LRepayment * -1) else
                                                        GenJournaline.Validate(Amount, RunBal * -1);
                                                    Genjournaline.Validate("Loan No.", LoanApps."No.");
                                                    GenJournaline.Description := CopyStr(StandingOrderH."No." + '-' +
                                                    Format(GenJournaline."Transaction Type") + '-' + LoanApps."No.", 1, 50);
                                                    GenJournaline.Validate("Loan No.", LoanApps."No.");
                                                    GenJournaline."Transaction Type" := GenJournaline."Transaction Type"::Repayment;
                                                    GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                                    GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                                    if GenJournaline.Amount <> 0 then
                                                        GenJournaline.Insert(true);
                                                    RunBal := RunBal - Abs(GenJournaline.Amount);
                                                    AmounDeduct := AmounDeduct + Abs(GenJournaline.Amount);
                                                end;
                                            end
                                        end
                                    end
                                end;
                        end;
                    until OrderLines.Next() = 0;
                end;
            end;
            if PostInt = 1 then begin
                if StandingOrderH."Next Run Date" <= Today then begin
                    JnlPostMngt.CompletePosting(Temp."STO Journal Template", Temp."STO Journal Batch");
                    JnlPostMngt.ClearJournalLines(Temp."STO Journal Template", Temp."STO Journal Batch");
                    StandingOrderH.Effected := true;
                    StandingOrderH.CalcFields("Allocated Amount");
                    LBalance := (StandingOrderH."Allocated Amount" - RunBal);
                    AmounDeduct := 0;

                    IF AvailAmt > 0 then begin
                        if AvailAmt >= StandingOrderH."Allocated Amount" then begin

                            StandingOrderH.Unsuccessfull := false;
                            DeductionStatus := DeductionStatus::Successfull;
                            AmounDeduct := StandingOrderH."Allocated Amount";
                            StandingOrderH."Deduction Status" := StandingOrderH."Deduction Status"::Successfull;
                            StandingOrderH."Next Run Date" := CalcDate(StandingOrderH."Frequency (Months)", StandingOrderH."Next Run Date");

                        end else
                            if StandingOrderH."Allocated Amount" > RunBal then begin
                                StandingOrderH.Unsuccessfull := true;
                                DeductionStatus := DeductionStatus::"Partial Deduction";
                                StandingOrderH."Deduction Status" := StandingOrderH."Deduction Status"::"Partial Deduction";
                                AmounDeduct := RunBal;
                            end;
                    end else
                        if Runbal = 0 then begin
                            StandingOrderH.Unsuccessfull := true;
                            DeductionStatus := DeductionStatus::Failed;
                            StandingOrderH."Deduction Status" := StandingOrderH."Deduction Status"::Failed;
                            AmounDeduct := 0;
                        end;

                    StandingOrderH.Modify(true);
                    UpdateStandingOrderRegister(StandingOrderH."No.", Today,
                    StandingOrderH."Source Account No.",
                    StandingOrderH."Source Account Name",
                    StandingOrderH."Member No.", DeductionStatus,
                    StandingOrderH."Allocated Amount", Abs(AmounDeduct),
                    StandingOrderH."Next Run Date", FosaBal);

                end;
            end; // end effective date
        end;//end start of standing order
    end;

    procedure InitializeEntry(var RecRef: Record "Gen. Journal Line"; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
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

    procedure PerformPostOnCertDepositAc(AccountNo: Code[100])
    var
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        FDBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        Application: Record "Account Application";
    begin
        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Gensetup.Get();
        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
        Temp."Periodic Journal Batch");

        FDBanking.Reset();
        FDBanking.SetRange("No.", AccountNo);
        FDBanking.SetRange(Blocked, FDBanking.Blocked::" ");
        if FDBanking.FindFirst() then begin

            Application.Reset();
            Application.SetRange("No.", FDBanking."Application No.");
            if Application.FindFirst() then begin
                Application.fnCheckDetails();

                AccBanking.Reset();
                AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
                AccBanking.SetRange("No.", Application."Savings Account No.");
                if AccBanking.FindFirst() then begin
                    AccBanking.CalcFields(Balance, "Balance (LCY)");
                    RunBal := TellerMngt.CalcAvailableBal(AccBanking."No.");


                    if RunBal > Application."Fixed Deposit Amount" then begin

                        if Application."Transaction Type" <> '' then begin

                            TellerMngt.fnPostAccTransferCharges(Application."Transaction Type",
                            AccBanking."No.", Application."Fixed Deposit Amount",
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                            Application."No.", Today);
                        end;

                        GenJournaline.LockTable();
                        LineNo += 1000;
                        InitializeEntry(GenJournaline,
                        Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch",
                        FDBanking."No.", '', Today,
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code");
                        GenJournaline."Line No." := LineNo;
                        GenJournaline.Description := CopyStr('Fixed Deposit-' + FDBanking."No.", 1, 50);
                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                        GenJournaline.Validate("Account No.", AccBanking."No.");
                        GenJournaline.Validate(Amount, Application."Fixed Deposit Amount");
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);

                        GenJournaline.LockTable();
                        LineNo += 1000;

                        InitializeEntry(GenJournaline,
                        Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch",
                        FDBanking."No.", '', Today,
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code");
                        GenJournaline."Line No." := LineNo;
                        GenJournaline.Description := CopyStr('Fixed Deposit-' + FDBanking."No.", 1, 50);
                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                        GenJournaline.Validate("Account No.", FDBanking."No.");
                        GenJournaline.Validate(Amount, Application."Fixed Deposit Amount" * -1);
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);

                        JnlPostMngt.CompletePosting(Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch");

                    end;
                end;

            end
        end
    end;

    procedure PerformPostReceipt(RecRef: Record "Receipts Header"; JTemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; PostInt: Integer; PostingType: Integer)
    var
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record "Receipt Line";
        TAmount: Decimal;
        DefaultBatch: Record "Gen. Journal Batch";
        Rcpt: Record "Receipts Header";
        RunPeriodic: Codeunit "Credit Mgmt.";
        RcptNo: Code[20];
        DimVal: Record "Dimension Value";
        BankAcc: Record "Bank Account";
        GLine: Record "Gen. Journal Line";
        LineNo: Integer;
        SavingsAc: Record "Account Banking";
        BAmount: Decimal;
        LInterest: Decimal;
        SRSetup: Record "Sales & Receivables Setup";
        Post: Boolean;
        USetup: Record "Cash Office User Template";
        RegMgt: Codeunit "Register Management";
        RegisterNumber: Integer;
        PrdFac: Record "Product Factory";
        FactPrd: Record "Product Factory";
        FromNumber: Integer;
        ToNumber: Integer;
        StrInvoices: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        Line: Integer;
        SavingsAccounts: Record "Account Banking";
        CreditAccounts: Record "Credit Account";
        BosaAcc: Record "Account Credit";
        Loans: Record Loans;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        MgtUnit: Codeunit "Periodic Activities Mgt.";
        CustEmployer: Record Customer;
        DAmount: Decimal;
        LoanCharges: Record "Loan Product Charges";
        ReceiptHeader: Record "Receipts Header";
        Filename: Text[50];
        MailContents: Text[200];
        MailContents2: Text[100];
        MailContent: Text;
        SavingsAccountsRec: Record "Account Banking";
        SavingsLedgerEntryRec: Record "Banking A/c Ledger Entry";
        CreditLedgerEntryRec: Record "Loan Ledger Entry";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        Temp: Record "User Setup";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        RunBal: Decimal;
        LPrincipal: Decimal;
        LRepayment: Decimal;
        CuatRec: Record Customer;
        RegisterMngt: Codeunit "Register Management";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        CompInfo: Record "Company Information";
        MemberCust: Record Member;
        JournalLine: Record "Gen. Journal Line";
        i: Integer;
        DiffAmt: array[7] of Decimal;
        CredAccount: Record "Account Credit";
        ProdFact: Record "Product Factory";
        NoMinBalance: Boolean;
        CustRec: Record Customer;
        ProductFactory: Record "Product Factory";
        Cust: Record Member;
        CustomerAccType: Enum CustAccountType;
        ProdCategory: Enum ProductAccountCategory;
        AccDimension: Enum AccountDimension;
        TempFile: Record "Temp. Files";

    begin

        RecRef.CheckMinRequiredItem();
        CheckPaylineReqItems(RecRef."No.");

        TAmount := 0;
        JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

        RecRef.CalcFields("Total Amount");
        NoMinBalance := false;

        if RecRef."Application Type" = RecRef."Application Type"::Member then begin

            CredAccount.Reset();
            CredAccount.SetRange("Member No.", RecRef."Member No.");
            CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Capital");
            if CredAccount.FindFirst() then begin
                CredAccount.CalcFields("Balance (LCY)");
                if ProdFact.Get(CredAccount."Product Type") then begin
                    ProdFact.TestField("Minimum Balance");
                    if CredAccount."Balance (LCY)" < ProdFact."Minimum Balance" then
                        NoMinBalance := true else
                        NoMinBalance := false;
                end
            end else begin
                // Error('No Related Shares capital account found');
            end;

        end;

        LineNo := LineNo + 1000;

        JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo,
        RecRef."Account Type", RecRef."No.",
        RecRef."Received From", RecRef."Total Amount",
        RecRef."Account No.", RecRef.Date,
        AccountType::"G/L Account", '', RecRef."Member No.",
        Dim1, Dim2, TransactionType::" ", '',
        '', '', DocType::" ", RecRef."Currency Code", AppliesToDocType::" ");

        ReceiptLine.Reset;
        ReceiptLine.SetFilter(Amount, '>0');
        ReceiptLine.SetRange(ReceiptLine.No, RecRef."No.");
        ReceiptLine.SetRange(ReceiptLine.Posted, false);
        if ReceiptLine.Find('-') then begin
            repeat
                ReceiptLine.TestField("Account Name");
                RunBal := 0;

                if ReceiptLine."Transaction Type" = ReceiptLine."Transaction Type"::" " then begin

                    BosaAcc.Reset();
                    BosaAcc.SetRange("No.", ReceiptLine."Account No.");
                    if BosaAcc.FindFirst() then begin

                        CustRec.Reset();
                        CustRec.SetRange("No.", ReceiptLine."Account No.");
                        if not CustRec.FindFirst() then begin
                            RegisterMngt.fnCreateCustMemberPostAc(BosaAcc."No.",
                            BosaAcc.Name, '',
                            BosaAcc."Global Dimension 1 Code",
                            BosaAcc."Global Dimension 2 Code",
                            BosaAcc."Customer Posting Group", '',
                            BosaAcc.Status, BosaAcc."Product Type",
                            BosaAcc."ID/Passport No.",
                            BosaAcc."Member No.",
                            CustomerAccType::"Credit Account",
                            AccDimension::Credit, BosaAcc."Account Category");
                        end;
                    end;

                    GenJnlLine.LockTable();
                    LineNo := LineNo + 1000;
                    InitializeEntry(GenJnlLine, LineNo, Jtemplate,
               JBatch, RecRef."No.", RecRef."Currency Code",
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
                    GenJnlLine."Source Code" := 'CASHRECJNL';
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert(true);
                    DiffAmt[1] := 0;

                    CredAccount.Reset();
                    CredAccount.SetRange("No.", ReceiptLine."Account No.");
                    CredAccount.SetFilter(Status, '<>%1|<>%2', CredAccount.Status::Deceased, CredAccount.Status::"Withdrawal Application");
                    CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Capital");
                    if CredAccount.FindFirst() then begin
                        CredAccount.CalcFields("Balance (LCY)");
                        if ProdFact.Get(CredAccount."Product Type") then begin
                            ProdFact.TestField("Minimum Balance");
                            if CredAccount."Balance (LCY)" < ProdFact."Minimum Balance" then begin
                                DiffAmt[1] := (ProdFact."Minimum Balance" - CredAccount."Balance (LCY)");
                                if (DiffAmt[1] + Abs(GenJnlLine.Amount)) >= ProdFact."Minimum Balance" then begin
                                    ActivateCredAcc(CredAccount."Member No.");
                                end;
                            end;
                        end;
                    end;
                end;

                if ReceiptLine."Transaction Type" = ReceiptLine."Transaction Type"::Repayment then begin

                    CreditAccounts.Reset();
                    CreditAccounts.SetRange("No.", ReceiptLine."Account No.");
                    if CreditAccounts.FindFirst() then begin
                        CustRec.Reset();
                        CustRec.SetRange("No.", ReceiptLine."Account No.");
                        if not CustRec.FindFirst() then begin
                            RegisterMngt.fnCreateCustMemberPostAc(CreditAccounts."No.",
                            CreditAccounts.Name, '',
                            CreditAccounts."Global Dimension 1 Code",
                            CreditAccounts."Global Dimension 2 Code",
                            CreditAccounts."Customer Posting Group", '',
                            CreditAccounts.Status, CreditAccounts."Product Type",
                            CreditAccounts."ID No.",
                            CreditAccounts."Member No.",
                            CustomerAccType::"Loan Account",
                            AccDimension::Credit, ProdCategory::" ");
                        end;
                    end;

                    LInterest := 0;
                    LPrincipal := 0;
                    LRepayment := 0;

                    RunBal := ReceiptLine.Amount;

                    if Loans.Get(ReceiptLine."Loan No.") then begin
                        Loans.CalcFields("Outstanding Interest", "Outstanding Principal", "Outstanding Insurance");

                        if ReceiptLine."Settlement Fee" > 0 then begin

                            LoanCharges.Reset();
                            LoanCharges.SetRange("Product Code", Loans."Product Type");
                            LoanCharges.SetRange("Charge Type", LoanCharges."Charge Type"::Prorate);
                            LoanCharges.SetRange("Charging Option", LoanCharges."Charging Option"::"Pro Rate");
                            if LoanCharges.Findfirst() then begin
                                LoanCharges.TestField("Charges Account");
                                LineNo := LineNo + 1000;
                                InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                JBatch, RecRef."No.", RecRef."Currency Code",
                                RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                GenJnlLine."Account Type" := LoanCharges."Account Type";
                                GenJnlLine.Validate("Account No.", LoanCharges."Charges Account");
                                GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                                if RunBal > ReceiptLine."Settlement Fee" then
                                    GenJnlLine.Validate(GenJnlLine.Amount, ReceiptLine."Settlement Fee" * -1) else
                                    GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert(true);
                                RunBal := RunBal - Abs(GenJnlLine.Amount);
                            end else begin
                                Error('No account Related or attached to settlement fee')
                            end;
                        end;

                        if Loans."Outstanding Insurance" > 0 then begin
                            if RunBal > 0 then begin

                                LineNo := LineNo + 1000;
                                InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                JBatch, RecRef."No.", RecRef."Currency Code",
                                RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                case ReceiptLine."Account Type" of
                                    ReceiptLine."Account Type"::Saving:
                                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                                    ReceiptLine."Account Type"::Loan,
                                ReceiptLine."Account Type"::Credit:
                                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                end;
                                GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                                if RunBal > Loans."Outstanding Insurance" then
                                    GenJnlLine.Validate(GenJnlLine.Amount, Loans."Outstanding Insurance" * -1) else
                                    GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::"Insurance Paid";
                                GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert(true);
                                RunBal := RunBal - Abs(GenJnlLine.Amount);
                            end;
                        end;

                        if (Loans."Outstanding Interest" + ReceiptLine."Accrued Intrest") > 0 then begin

                            if RunBal > 0 then begin

                                LInterest := (Loans."Outstanding Interest" + ReceiptLine."Accrued Intrest");
                                LPrincipal := (ReceiptLine.Amount - (LInterest + ReceiptLine."Settlement Fee"));
                                if LPrincipal < 0 then
                                    LPrincipal := 0;

                                GenJnlLine.LockTable();

                                if ProdFact.Get(Loans."Product Type") then begin
                                    ProdFact.TestField("Interest Account (G/L)");

                                    LineNo := LineNo + 1000;
                                    InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                    JBatch, RecRef."No.", RecRef."Currency Code",
                                    RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                    GenJnlLine."Source Code" := 'CASHRECJNL';
                                    GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                    GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                    case ReceiptLine."Account Type" of
                                        ReceiptLine."Account Type"::Saving:
                                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                                        ReceiptLine."Account Type"::Loan,
                                    ReceiptLine."Account Type"::Credit:
                                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                    end;
                                    GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                    GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                                    GenJnlLine.Validate(GenJnlLine.Amount, ReceiptLine."Accrued Intrest");
                                    GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                    GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::"Interest Due";
                                    GenJnlLine.Validate("Bal. Account No.", ProdFact."Interest Account (G/L)");
                                    GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                                    GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                                    if GenJnlLine.Amount <> 0 then
                                        GenJnlLine.Insert(true);
                                end;

                                LineNo := LineNo + 1000;
                                InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                JBatch, RecRef."No.", RecRef."Currency Code",
                                RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                case ReceiptLine."Account Type" of
                                    ReceiptLine."Account Type"::Saving:
                                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                                    ReceiptLine."Account Type"::Loan,
                                ReceiptLine."Account Type"::Credit:
                                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                end;
                                GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                                if RunBal > LInterest then
                                    GenJnlLine.Validate(GenJnlLine.Amount, LInterest * -1) else
                                    GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::"Interest Paid";
                                GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert(true);
                                RunBal := RunBal - Abs(GenJnlLine.Amount);
                            end;
                        end else begin
                            LPrincipal := (ReceiptLine.Amount - ReceiptLine."Settlement Fee");
                        end;

                        if Loans."Outstanding Principal" > 0 then begin

                            if RunBal > 0 then begin

                                if LPrincipal > Loans."Outstanding Principal" then
                                    LRepayment := LPrincipal else
                                    LRepayment := Loans."Outstanding Principal";

                                GenJnlLine.LockTable();
                                LineNo := LineNo + 1000;
                                InitializeEntry(GenJnlLine, LineNo, Jtemplate,
                                JBatch, RecRef."No.", RecRef."Currency Code",
                                RecRef."Document Date", Dim1, Dim2, RecRef.Date);
                                GenJnlLine."Source Code" := 'CASHRECJNL';
                                GenJnlLine."External Document No." := ReceiptLine."Loan No.";
                                GenJnlLine.Description := ReceiptLine."Account Name" + '-' + ReceiptLine."Member No.";
                                case ReceiptLine."Account Type" of
                                    ReceiptLine."Account Type"::Saving:
                                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
                                    ReceiptLine."Account Type"::Loan,
                                ReceiptLine."Account Type"::Credit:
                                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                end;
                                GenJnlLine.Validate("Account No.", ReceiptLine."Account No.");
                                GenJnlLine.Validate("Currency Code", RecRef."Currency Code");
                                if RunBal > LRepayment then
                                    GenJnlLine.Validate(GenJnlLine.Amount, LRepayment * -1) else
                                    GenJnlLine.Validate(GenJnlLine.Amount, RunBal * -1);
                                GenJnlLine.Validate("Loan No.", ReceiptLine."Loan No.");
                                GenJnlLine."Transaction Type" := GenJnlLine."Transaction Type"::Repayment;
                                GenJnlLine.Validate("Shortcut Dimension 1 Code", Dim1);
                                GenJnlLine.Validate("Shortcut Dimension 2 Code", Dim2);
                                if GenJnlLine.Amount <> 0 then
                                    GenJnlLine.Insert(true);
                            end;
                        end;
                    end;
                end;
            until ReceiptLine.Next() = 0
        end;

        if PostingType = 1 then begin
            JnlPostMngt.CompletePosting(JTemplate, JBatch);
            RecRef.CalcFields("Total Amount");

            CompInfo.Get();
            MemberCust.Reset();
            MemberCust.SetRange("No.", ReceiptLine."Member No.");
            if MemberCust.FindFirst() then begin
                Notific.CreateSmsNotif(NotifSource::"InterAccount Transfer",
                MemberCust."Mobile Phone No", 'Your have done a payment of KES  ' + Format(RecRef."Total Amount") +
                '. If in dispute call' + ' ' + CompInfo."Phone No.", RecRef."No.", MemberCust."No.", false);
            end;
            RecRef.Cashier := UserId;
            RecRef.Posted := true;
            RecRef."Approval Status" := RecRef."Approval Status"::Posted;
            RecRef."Date Posted" := Today;
            RecRef."Time Posted" := Time;
            RecRef."Posted By" := UserId;
            RecRef.Modify;

            ReceiptLine.Reset;
            ReceiptLine.SetFilter(Amount, '>0');
            ReceiptLine.SetRange(ReceiptLine.No, RecRef."No.");
            if ReceiptLine.Find('-') then begin
                ReceiptLine.ModifyAll(Posted, true);
                ReceiptLine.ModifyAll("Posted By", UserId);
                ReceiptLine.ModifyAll("Date Posted", Today);
                ReceiptLine.ModifyAll("Time Posted", Time);
                ReceiptLine.ModifyAll(ReceiptLine.Status, ReceiptLine.Status::Posted);
            end;
            onAfterPostReceipt(RecRef);

        end else begin

            JournalLine.Reset();
            JournalLine.SetRange("Document No.", RecRef."No.");
            JournalLine.SetRange("Journal Batch Name", RecRef."Receipt Journal Batch");
            JournalLine.SetRange("Journal Template Name", RecRef."Receipt Journal Template");
            if JournalLine.Find('-') then
                Page.Run(Page::"Journal Test Batch", JournalLine, JournalLine."Document No.");
        end;
        if PostInt = 1 then begin
            Commit;
            RecRef.TestField(Posted, true);
            RecRef.Reset;
            RecRef.SetFilter("No.", RecRef."No.");
            REPORT.Run(Report::"Official Receipt", true, true, RecRef);
            RecRef.Reset;
        end;
    end;

    [IntegrationEvent(false, false)]

    procedure onAfterPostReceipt(ReceiptHader: Record "Receipts Header")
    begin

    end;

    procedure InitializeEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20]; PDate: Date)
    begin
        RecRef.Init;
        RecRef."Line No." := LineNo;
        RecRef."Journal Template Name" := JTemplate;
        RecRef."Journal Batch Name" := JBatche;
        RecRef."Posting Date" := PDate;
        RecRef."Document No." := DocNo;
        RecRef.Validate("Currency Code", CurrencyCode);
        RecRef."Document Date" := TransactionDate;
        RecRef."Shortcut Dimension 1 Code" := Dimension1;
        RecRef."Shortcut Dimension 2 Code" := Dimension2;

    end;

    procedure CheckPaylineReqItems(DocNo: Code[20])
    var
        ReceiptLine: Record "Receipt Line";
    begin
        ReceiptLine.RESET;
        ReceiptLine.SETRANGE(ReceiptLine.No, DocNo);
        if ReceiptLine.FIND('-') then begin
            repeat
                ReceiptLine.TESTFIELD("Account Name");
                ReceiptLine.TestField("Pay Mode");
                IF ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::"Deposit Slip" then begin
                    ReceiptLine.TestField("Cheque/Deposit Slip No");
                    ReceiptLine.TestField("Cheque/Deposit Slip Date");
                    ReceiptLine.TestField("Transaction No.");
                    ReceiptLine.TestField(Type);
                end;
                if ReceiptLine."Pay Mode" = ReceiptLine."Pay Mode"::Cheque then begin
                    ReceiptLine.TestField("Cheque/Deposit Slip No");
                    ReceiptLine.TestField("Cheque/Deposit Slip Date");
                end;
            until ReceiptLine.Next() = 0
        end;
    end;



    procedure ChargeAccountStatement(AccRecord: Code[100]; ChargeAcc: Boolean; NoOfPage: Integer)
    var
        TransType: Record "Transaction Types";
        TransCharge: Record "Transaction Charge";
        AccBanking: Record "Account Banking";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        ChargeAmt: Decimal;
        TellerPostMngt: Codeunit "Teller-Post (Yes/No)";
        GenJournaline: Record "Gen. Journal Line";
    begin

        if ChargeAcc then begin

            Temp.Get(UserId);
            Temp.TestField("Shortcut Dimension 1 Code");
            Temp.TestField("Shortcut Dimension 2 Code");
            Temp.TestField("Periodic Journal Template");
            Temp.TestField("Periodic Journal Batch");

            Gensetup.Get();
            Gensetup.TestField("Excise Duty (%)");
            Gensetup.TestField("Excise Duty G/L");

            JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
            Temp."Periodic Journal Batch");

            ChargeAmt := 0;

            TransType.Reset();
            TransType.SetRange(Type, TransType.Type::Statement);
            if TransType.FindFirst() then begin
                TransCharge.Reset();
                TransCharge.SetRange("Transaction Type", TransType.Code);
                if TransCharge.FindFirst() then
                    ChargeAmt := TransCharge."Charge Amount" * NoOfPage;

                AccBanking.Reset();
                AccBanking.SetRange("No.", AccRecord);
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin

                    GenJournaline.LockTable();
                    LineNo += 10000;
                    InitializeEntry(GenJournaline,
                    Temp."Periodic Journal Template",
                    Temp."Periodic Journal Batch",
                    AccBanking."No.", '', Today,
                    Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code");
                    GenJournaline."Line No." := LineNo;
                    GenJournaline.Description := TransCharge.Description;
                    GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                    GenJournaline.Validate("Account No.", AccBanking."No.");
                    GenJournaline.Validate(Amount, ChargeAmt);
                    GenJournaline."Bal. Account No." := TransCharge."G/L Account";
                    if GenJournaline.Amount <> 0 then
                        GenJournaline.Insert(true);

                    if TransCharge."Recover Excise Duty" then begin

                        GenJournaline.LockTable();
                        LineNo += 10000;
                        InitializeEntry(GenJournaline,
                        Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch",
                        AccBanking."No.", '', Today,
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code");
                        GenJournaline."Line No." := LineNo;
                        GenJournaline.Description := 'Excise Duty on -' + TransCharge.Description;
                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                        GenJournaline.Validate("Account No.", AccBanking."No.");
                        GenJournaline.Validate(Amount, ChargeAmt * (Gensetup."Excise Duty (%)" / 100));
                        GenJournaline."Bal. Account No." := Gensetup."Excise Duty G/L";
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);
                    end;
                end;
                if TellerPostMngt.CalcAvailableBal(AccBanking."No.") > ((ChargeAmt * (Gensetup."Excise Duty (%)" / 100)) + ChargeAmt) then begin
                    JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");
                end else begin
                    Error('No enough fund for this transaction');
                end;
            end else begin
                Error('No Charge available for this type of transaction');
            end;
        end
    end;


    procedure ChargeAccountBankerLetters(AccRecord: Code[100]; ChargeAcc: Boolean; NoOfPage: Integer; LetterType: Option " ","Financial","Non-Financial")
    var
        TransType: Record "Transaction Types";
        TransCharge: Record "Transaction Charge";
        AccBanking: Record "Account Banking";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        ChargeAmt: Decimal;
        TellerPostMngt: Codeunit "Teller-Post (Yes/No)";
        GenJournaline: Record "Gen. Journal Line";
    begin

        if ChargeAcc then begin

            Temp.Get(UserId);
            Temp.TestField("Shortcut Dimension 1 Code");
            Temp.TestField("Shortcut Dimension 2 Code");
            Temp.TestField("Periodic Journal Template");
            Temp.TestField("Periodic Journal Batch");

            Gensetup.Get();
            Gensetup.TestField("Excise Duty (%)");
            Gensetup.TestField("Excise Duty G/L");

            JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
            Temp."Periodic Journal Batch");

            ChargeAmt := 0;

            TransType.Reset();
            TransType.SetRange(Type, TransType.Type::"Bank Letters");
            if TransType.FindFirst() then begin

                TransCharge.Reset();
                TransCharge.SetRange("Transaction Type", TransType.Code);
                if TransCharge.FindFirst() then begin

                    case LetterType of
                        LetterType::Financial:
                            begin
                                TransCharge.TestField("Charge Amount");
                                ChargeAmt := TransCharge."Charge Amount" * NoOfPage;
                            end;
                        LetterType::"Non-Financial":
                            begin
                                TransCharge.TestField("ATM Fee. %");
                                ChargeAmt := TransCharge."ATM Fee. %" * NoOfPage;
                            end;
                    end;
                end;

                AccBanking.Reset();
                AccBanking.SetRange("No.", AccRecord);
                AccBanking.SetRange(Blocked, AccBanking.Blocked::" ");
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin

                    GenJournaline.LockTable();
                    LineNo += 10000;
                    InitializeEntry(GenJournaline,
                    Temp."Periodic Journal Template",
                    Temp."Periodic Journal Batch",
                    AccBanking."No.", '', Today,
                    Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code");
                    GenJournaline."Line No." := LineNo;
                    GenJournaline.Description := TransCharge.Description;
                    GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                    GenJournaline.Validate("Account No.", AccBanking."No.");
                    GenJournaline.Validate(Amount, ChargeAmt);
                    GenJournaline."Bal. Account No." := TransCharge."G/L Account";
                    if GenJournaline.Amount <> 0 then
                        GenJournaline.Insert(true);

                    if TransCharge."Recover Excise Duty" then begin

                        GenJournaline.LockTable();
                        LineNo += 10000;
                        InitializeEntry(GenJournaline,
                        Temp."Periodic Journal Template",
                        Temp."Periodic Journal Batch",
                        AccBanking."No.", '', Today,
                        Temp."Shortcut Dimension 1 Code",
                        Temp."Shortcut Dimension 2 Code");
                        GenJournaline."Line No." := LineNo;
                        GenJournaline.Description := 'Excise Duty on -' + TransCharge.Description;
                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                        GenJournaline.Validate("Account No.", AccBanking."No.");
                        GenJournaline.Validate(Amount, ChargeAmt * (Gensetup."Excise Duty (%)" / 100));
                        GenJournaline."Bal. Account No." := Gensetup."Excise Duty G/L";
                        if GenJournaline.Amount <> 0 then
                            GenJournaline.Insert(true);
                    end;
                    if TellerPostMngt.CalcAvailableBal(AccBanking."No.") > ((ChargeAmt * (Gensetup."Excise Duty (%)" / 100)) + ChargeAmt) then begin
                        JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");
                    end else begin
                        Error('No enough fund for this transaction');
                    end;
                end else begin
                    Error('No Transaction account found');
                end;
            end else begin
                Error('No Charge available for this type of transaction');
            end;
        end
    end;

    procedure PerformPostOnSafeCustody(ReferenceRecord: Record "Collateral Register"; Jtemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal)
    var
        SavingsAccountsRec: Record "Account Banking";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        Temp: Record "User Setup";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        CompInfo: Record "Company Information";
        MemberCust: Record Member;
        GenJnlLine: Record "Gen. Journal Line";
        TransType: Record "Transaction Charge";
        ExciseDuty: Decimal;
        RefRecord: Record "Collateral Register";
        RegmntAcc: Record "Account (Procedure)";
        CTransType: Record "Transaction Types";
        Bmngt: Codeunit "Banking Procedure Mngt.";
        TellerTrans: Record "Teller Transaction";
        AccountFosa: Record "Account Banking";
    begin
        Gensetup.Get();
        CompInfo.Get();

        TellerTrans.Reset();

        TellerTrans.SetRange(Posted, true);
        TellerTrans.SetRange(Type, TellerTrans.Type::Lien);
        TellerTrans.SetRange("Cheque Status", TellerTrans."Cheque Status"::Pending);
        TellerTrans.SetRange("External Document No.", ReferenceRecord."No.");
        if TellerTrans.FindFirst() then begin
            if AccountFosa.Get(ReferenceRecord."Savings Account No.") then begin
                TellerTrans."Cheque Status" := TellerTrans."Cheque Status"::Honoured;
                TellerTrans."Date Cleared" := Today;
                TellerTrans."Cleared By" := UserId;
                TellerTrans.Modify;
            end;
        end;

        TransType.Reset();
        TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
        if TransType.FindFirst() then begin
            if TransType."Charge Amount" <> 0 then begin
                if TransType."Charge Amount" > TellerMgt.CalcAvailableBal(ReferenceRecord."Savings Account No.") then begin

                    SavingsAccountsRec.Reset();
                    SavingsAccountsRec.SetRange("No.", ReferenceRecord."Savings Account No.");
                    if SavingsAccountsRec.FindFirst() then begin
                        Bmngt.PostLien(SavingsAccountsRec, TransType."Charge Amount", TransType.Description, 0, ReferenceRecord."No.");
                    end;
                end else begin

                    SavingsAccountsRec.Reset();
                    SavingsAccountsRec.SetRange("No.", ReferenceRecord."Savings Account No.");
                    if SavingsAccountsRec.FindFirst() then begin
                        TransType.Reset();
                        TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
                        if TransType.FindFirst() then begin
                            TellerMgt.fnPostAccTransferCharges(TransType."Transaction Type",
                            SavingsAccountsRec."No.",
                            0, Dim1, Dim2, Jtemplate, JBatch, ReferenceRecord."No.", Today);
                        end;

                        JnlPostMngt.CompletePosting(Jtemplate, JBatch);

                        if RefRecord.Get(ReferenceRecord."No.") then begin
                            RefRecord."Posted By" := UserId;
                            RefRecord."Date Posted" := CurrentDateTime;
                            RefRecord."Inward/Outward" := RefRecord."Inward/Outward"::"In-Store";
                            RefRecord."Approval Status" := RefRecord."Approval Status"::Posted;
                            RefRecord.Modify(true);
                            Notific.CreateSmsNotif(NotifSource::"ATM Collection",
                            SavingsAccountsRec."Mobile No.", 'Your safe custody application has been successfully processed.' +
                            '. If in dispute call' + ' ' + CompInfo."Phone No.", SavingsAccountsRec."No.",
                            SavingsAccountsRec."Member No.", false);
                        end;
                    end;
                end;
            end;
            Message('Application posted successfully');
        end;
    end;

    procedure PerformPostOnSafeCustodyRenew(ReferenceRecord: Record "Collateral Register"; Jtemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal)
    var
        SavingsAccountsRec: Record "Account Banking";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        Temp: Record "User Setup";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        CompInfo: Record "Company Information";
        MemberCust: Record Member;
        GenJnlLine: Record "Gen. Journal Line";
        TransType: Record "Transaction Charge";
        ExciseDuty: Decimal;
        RefRecord: Record "Collateral Register";
        RegmntAcc: Record "Account (Procedure)";
        CTransType: Record "Transaction Types";


    begin
        Gensetup.Get();
        CompInfo.Get();

        TransType.Reset();
        TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
        if TransType.FindFirst() then begin
            if TransType."Charge Amount" <> 0 then begin
                if TransType."Charge Amount" > TellerMgt.CalcAvailableBal(ReferenceRecord."Savings Account No.") then begin
                    SavingsAccountsRec.Reset();
                    SavingsAccountsRec.SetRange("No.", ReferenceRecord."Savings Account No.");
                    if SavingsAccountsRec.FindFirst() then begin
                        PostLien(SavingsAccountsRec, TransType."Charge Amount", TransType.Description, 1, ReferenceRecord."No.");
                    end;
                end else begin

                    SavingsAccountsRec.Reset();
                    SavingsAccountsRec.SetRange("No.", ReferenceRecord."Savings Account No.");
                    if SavingsAccountsRec.FindFirst() then begin
                        TransType.Reset();
                        TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
                        if TransType.FindFirst() then begin
                            TellerMgt.fnPostAccTransferCharges(TransType."Transaction Type",
                            SavingsAccountsRec."No.",
                            0, Dim1, Dim2, Jtemplate, JBatch, ReferenceRecord."No.", Today);
                        end;

                        JnlPostMngt.CompletePosting(Jtemplate, JBatch);

                        if RefRecord.Get(ReferenceRecord."No.") then begin
                            RefRecord."Posted By" := UserId;
                            RefRecord."Date Posted" := CurrentDateTime;
                            RefRecord."Maturity Date" := CalcDate(RefRecord."SC Duration", RefRecord."Maturity Date");
                            RefRecord.Modify(true);
                            Notific.CreateSmsNotif(NotifSource::"ATM Collection",
                            SavingsAccountsRec."Mobile No.", 'Your safe custody application has been successfully processed.' +
                            '. If in dispute call' + ' ' + CompInfo."Phone No.", SavingsAccountsRec."No.",
                            SavingsAccountsRec."Member No.", false);
                        end;
                        Message('Application posted successfully');
                    end;
                end;
            end else begin
                Error('Transaction charge must have a value in transaction type %1. It cannot be null', ReferenceRecord."Transaction Type");
            end;
        end else begin
            Error('No related Transaction type attached to this application');
        end;
    end;

    procedure PerformPostOnCustodyCollection(ReferenceRecord: Record "Security Collection"; Jtemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal)
    var
        SavingsAccountsRec: Record "Account Banking";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        Temp: Record "User Setup";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        CompInfo: Record "Company Information";
        MemberCust: Record Member;
        GenJnlLine: Record "Gen. Journal Line";
        TransType: Record "Transaction Charge";
        ExciseDuty: Decimal;
        RefRecord: Record "Security Collection";
        RegmntAcc: Record "Account (Procedure)";
        CollatRegmgt: Record "Collateral Register";

    begin
        Gensetup.Get();
        CompInfo.Get();

        TransType.Reset();
        TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
        if TransType.FindFirst() then begin
            if TransType."Charge Amount" <> 0 then begin
                if TransType."Charge Amount" > TellerMgt.CalcAvailableBal(ReferenceRecord."Savings Account No.") then
                    Error('No enough in member account for this transaction');
            end;
        end;

        SavingsAccountsRec.Reset();
        SavingsAccountsRec.SetRange("No.", ReferenceRecord."Savings Account No.");
        if SavingsAccountsRec.FindFirst() then begin

            TransType.Reset();
            TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
            if TransType.FindFirst() then begin

                TellerMgt.fnPostAccTransferCharges(TransType."Transaction Type",
                SavingsAccountsRec."No.",
                0, Dim1, Dim2, Jtemplate, JBatch, ReferenceRecord."No.", Today);
            end;

            JnlPostMngt.CompletePosting(Jtemplate, JBatch);

            if RefRecord.Get(ReferenceRecord."No.") then begin
                RefRecord."Posted By" := UserId;
                RefRecord."Date Posted" := CurrentDateTime;
                RefRecord."Approval Status" := RefRecord."Approval Status"::Posted;
                RefRecord.Modify(true);

                if RefRecord."Operation Type" = RefRecord."Operation Type"::Collection then begin
                    CollatRegmgt.Reset();
                    CollatRegmgt.SetRange("No.", RefRecord."Collateral Register No.");
                    if CollatRegmgt.FindFirst() then begin
                        CollatRegmgt."Inward/Outward" := CollatRegmgt."Inward/Outward"::"In-Store";
                        CollatRegmgt.Modify(true);
                    end;
                end;

                Notific.CreateSmsNotif(NotifSource::"ATM Collection",
                SavingsAccountsRec."Mobile No.", 'Your safe custody retrieval has been successfully processed.' +
                '. If in dispute call' + ' ' + CompInfo."Phone No.", SavingsAccountsRec."No.",
                SavingsAccountsRec."Member No.", false);
            end;
            Message('Application posted successfully');
        end;
    end;

    procedure MarkCustodyCollectionAsReturned(ReferenceRecord: Record "Security Collection"; Jtemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal)
    var
        SavingsAccountsRec: Record "Account Banking";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        Temp: Record "User Setup";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        CompInfo: Record "Company Information";
        MemberCust: Record Member;
        GenJnlLine: Record "Gen. Journal Line";
        TransType: Record "Transaction Charge";
        ExciseDuty: Decimal;
        RefRecord: Record "Security Collection";
        RegmntAcc: Record "Account (Procedure)";
        CollatRegmgt: Record "Collateral Register";
    begin
        Gensetup.Get();
        CompInfo.Get();

        SavingsAccountsRec.Reset();
        SavingsAccountsRec.SetRange("No.", ReferenceRecord."Savings Account No.");
        if SavingsAccountsRec.FindFirst() then begin

            if RefRecord.Get(ReferenceRecord."No.") then begin
                RefRecord."Posted By" := UserId;
                RefRecord."Date Posted" := CurrentDateTime;
                RefRecord."Inward/Outward" := RefRecord."Inward/Outward"::Returned;
                RefRecord."Approval Status" := RefRecord."Approval Status"::Posted;
                RefRecord.Modify(true);

                if RefRecord."Operation Type" = RefRecord."Operation Type"::Collection then begin
                    CollatRegmgt.Reset();
                    CollatRegmgt.SetRange("No.", RefRecord."Collateral Register No.");
                    if CollatRegmgt.FindFirst() then begin
                        CollatRegmgt."Inward/Outward" := CollatRegmgt."Inward/Outward"::Returned;
                        CollatRegmgt.Modify(true);
                    end;
                end;
                Notific.CreateSmsNotif(NotifSource::"ATM Collection",
                SavingsAccountsRec."Mobile No.", 'Your safe custody collection has been successfully processed.' +
                '. If in dispute call' + ' ' + CompInfo."Phone No.", SavingsAccountsRec."No.",
                SavingsAccountsRec."Member No.", false);
            end;
            Message('Application posted successfully');
        end;
    end;

    procedure CardLinkAccount(ReferenceRecord: Record "Member Changes"; Jtemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; Amt: Decimal)
    var
        SavingsAccountsRec: Record "Account Banking";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        Temp: Record "User Setup";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        AccountType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        NotifSource: Enum NotifSourceType;
        Notific: Codeunit "SMS Notification";
        CompInfo: Record "Company Information";
        MemberCust: Record Member;
        GenJnlLine: Record "Gen. Journal Line";
        TransType: Record "Transaction Charge";
        ExciseDuty: Decimal;
        RefRecord: Record "Member Changes";
        RegmntAcc: Record "Account (Procedure)";


    begin
        Gensetup.Get();
        CompInfo.Get();

        TransType.Reset();
        TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
        if TransType.FindFirst() then begin
            if TransType."Charge Amount" <> 0 then begin
                if TransType."Charge Amount" > TellerMgt.CalcAvailableBal(ReferenceRecord."Account No.") then
                    Error('No enough in member account for this transaction');
                if SavingsAccountsRec.Get() then begin
                    PostLien(SavingsAccountsRec, TransType."Charge Amount", TransType.Description, 0, ReferenceRecord."No.");
                end;
            end;
        end;

        SavingsAccountsRec.Reset();
        SavingsAccountsRec.SetRange("No.", ReferenceRecord."Account No.");
        if SavingsAccountsRec.FindFirst() then begin
            TransType.Reset();
            TransType.SetRange("Transaction Type", ReferenceRecord."Transaction Type");
            if TransType.FindFirst() then begin
                TellerMgt.fnPostAccTransferCharges(TransType."Transaction Type",
                SavingsAccountsRec."No.",
                0, Dim1, Dim2, Jtemplate, JBatch, ReferenceRecord."No.", Today);
            end;

            JnlPostMngt.CompletePosting(Jtemplate, JBatch);
            SavingsAccountsRec.Validate("ATM No.", ReferenceRecord."ATM Card No.");
            SavingsAccountsRec.Validate("Expiry Date (Card)", ReferenceRecord."Expiry Date (Card)");
            SavingsAccountsRec.Modify(true);

            RegmntAcc.Reset();
            RegmntAcc.SetRange("No.", SavingsAccountsRec."No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            if RegmntAcc.FindFirst() then begin
                RegmntAcc.Validate("Expiry Date (Card)", ReferenceRecord."Expiry Date (Card)");
                RegmntAcc.Validate("Card Status", RegmntAcc."Card Status"::Approved);
                RegmntAcc.Modify(true);
            end;

            if RefRecord.Get(ReferenceRecord."No.") then begin
                RefRecord."Posted By" := UserId;
                RefRecord."Date Posted" := CurrentDateTime;
                RefRecord."Approval Status" := RefRecord."Approval Status"::Posted;
                RefRecord.Modify(true);
                Notific.CreateSmsNotif(NotifSource::"ATM Collection",
                SavingsAccountsRec."Mobile No.", 'Your ATM Card Linking has been successfully processed.' +
                '. If in dispute call' + ' ' + CompInfo."Phone No.", SavingsAccountsRec."No.",
                SavingsAccountsRec."Member No.", false);
            end;
            Message('Application posted successfully');
        end;
    end;

    procedure ActivateCredAcc(MemberNo: Code[100])
    var
        Acc: Record "Account Credit";
        CustM: Record Member;
    begin
        if CustM.Get(MemberNo) then begin
            Acc.Reset();
            Acc.SetRange("Member No.", CustM."No.");
            if Acc.FindSet() then begin
                Acc.ModifyAll(Status, Acc.Status::Active);
            end;
            CustM.Status := CustM.Status::Active;
            CustM.Modify(true);
        end;
    end;

    procedure GetDividendSetup()
    begin
        DividendSetUp.Get();
        DividendSetUp.TestField(DividendSetUp."Start Date");
        DividendSetUp.TestField(DividendSetUp."End Date");
        //DividendSetUp.TestField("Transaction Type");
        StartDate := DividendSetUp."Start Date";
        EndDate := DividendSetUp."End Date";

        TransChargeCode := DividendSetUp."Transaction Type";
        DivCapitalize := DividendSetUp."Dividend Instructions";
        LoanArrear := DividendSetUp."Loan Arrears Recovery";
        DivDiscount := DividendSetUp."Dividend Discounting";
        DefaulterRecov := DividendSetUp."Defaulter Recovery";
    end;

    Procedure InitPost(SimDivHeader: Record "Dividend Simulation Header"; ValuePost: Integer)
    var
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        StandingOrderH: Record "Standing Order Header";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        MsgNotification: Codeunit "SMS Notification";
        Temp: Record "Banking User Template";
        AccBanking: Record "Account Banking";
        FDBanking: Record "Account Banking";
        GenJournaline: Record "Gen. Journal Line";
        LineNo: Integer;
        CredMngt: Codeunit "Credit Mgmt.";
        Application: Record "Account Application";
        InterestAmt: Decimal;
        WthTax: Decimal;
        TransCharge: Record "Transaction Charge";
        TransType: Record "Transaction Types";
        AccountType: Record "Product Factory";
        RunDate: Date;
        PostInt: Integer;
        GrossAmt: Decimal;
        Descript: Text[50];
        DocumentNo: Code[50];
        ProdType: Code[10];
        SavingsAcc: Record "Account Banking";
        DividendLine: Record "Simulation Line";
        Account: Record "Account Banking";
        CredAccount: Record "Account Credit";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Account Transfer Header";
        BalAccount: Code[20];
        LRepayment: Decimal;
        Notif: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        ObjtMember: Record Member;
        Expr1: Integer;
        RefDateTxt: Text[100];
        PostDate: Date;
        DescripTxt: Text[150];
        PFact: Record "Product Factory";
        DocPostMgt: Codeunit "Doc. Mngt";
        varvariant: variant;
    begin

        Temp.Get(UserId);
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");

        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
        Temp."Periodic Journal Batch");

        Gensetup.Get();
        GetDividendSetup();
        WthTax := 0;
        RunBal := 0;
        LineNo := 0;
        RunDate := SimDivHeader."Posting Date";
        LoanArrear := false;
        DivDiscount := false;
        BalAccount := '';

        DocumentNo := SimDivHeader."No.";
        LoanArrear := SimDivHeader."Deduct Non-Performing Loans";
        DivDiscount := SimDivHeader."Deduct Dividend Loan";

        DividendLine.Reset();
        DividendLine.SetRange(Posted, false);
        DividendLine.SetFilter("Gross Dividends", '>0');
        DividendLine.SetRange("No.", SimDivHeader."No.");
        if DividendLine.FindSet() then begin

            repeat
                DividendLine.TestField("Member No.");
                DividendLine.TestField("Account No.");

                RunBal := 0;
                GrossAmt := 0;
                PostDate := Calcdate('-CY', today);
                Expr1 := Date2DMY(SimDivHeader."End Date", 3);
                GrossAmt := DividendLine."Gross Dividends";
                RunBal := DividendLine."Gross Dividends";

                if PFact.Get(DividendLine."Product Type") then begin
                    PFact.TestField("Interest Payable Account");

                    case PFact."Account Category" of

                        PFact."Account Category"::"Shares Capital":
                            begin
                                Descript := 'Dividends on-';
                                DescripTxt := 'Dividends';
                                BalAccount := PFact."Interest Payable Account";
                                PFact.TestField("WithHolding Tax");
                                PFact.TestField("Withholding Tax Account");
                                WthTax := GrossAmt * (PFact."WithHolding Tax" / 100);
                            end else begin
                            Descript := 'Interest On-';
                            DescripTxt := 'Interest';
                            BalAccount := PFact."Interest Payable Account";
                            PFact.TestField("WithHolding Tax");
                            PFact.TestField("Withholding Tax Account");
                            WthTax := GrossAmt * (PFact."WithHolding Tax" / 100);
                        end;
                    end;

                    Account.Reset();
                    Account.SetRange(Blocked, Account.Blocked::" ");
                    Account.SetRange("Member No.", DividendLine."Member No.");
                    Account.SetRange("Account Category", Account."Account Category"::Savings);
                    if Account.FindFirst() then begin

                        Account.CalcFields("Balance (LCY)");
                        if SimDivHeader."Posting Type" = SimDivHeader."Posting Type"::All then begin

                            ///Post into Fosa Gross Amount
                            LineNo := LineNo + 10000;
                            GenJournaline.Init();
                            GenJournaline."Journal Template Name" := Temp."Periodic Journal Template";
                            GenJournaline."Journal Batch Name" := Temp."Periodic Journal Batch";
                            GenJournaline."Document No." := DocumentNo;
                            GenJournaline."Line No." := LineNo;
                            GenJournaline."Posting Date" := RunDate;
                            GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                            GenJournaline.Description := Descript + DividendLine."Product Name" + '-' + Format(Expr1) + '-' + DividendLine."Account No.";
                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                            GenJournaline.Validate("Account No.", Account."No.");
                            GenJournaline.Validate(Amount, RunBal * -1);
                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                            GenJournaline.Validate("Bal. Account No.", PFact."Interest Payable Account");
                            GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                            GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                            if GenJournaline.Amount <> 0 then
                                GenJournaline.Insert(true);

                            //Withholding tax
                            if not SimDivHeader."Ignore Withholding Tax" then begin

                                LineNo := LineNo + 10000;
                                GenJournaline.Init();
                                GenJournaline."Journal Template Name" := Temp."Periodic Journal Template";
                                GenJournaline."Journal Batch Name" := Temp."Periodic Journal Batch";
                                GenJournaline."Document No." := DocumentNo;
                                GenJournaline."Line No." := LineNo;
                                GenJournaline."Posting Date" := RunDate;
                                GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                GenJournaline.Description := 'Withholding Tax on - ' + DescripTxt;
                                GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                GenJournaline.Validate("Account No.", Account."No.");
                                if RunBal > WthTax then
                                    GenJournaline.Validate(Amount, WthTax) else
                                    GenJournaline.Validate(Amount, RunBal);
                                GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                                GenJournaline.Validate("Bal. Account No.", PFact."Withholding Tax Account");
                                GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournaline.Amount <> 0 then
                                    GenJournaline.Insert(true);
                                RunBal := (RunBal - GenJournaline.Amount);
                            end;

                            TransactionCharges.Reset;
                            TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransChargeCode);
                            if TransactionCharges.Find('-') then begin

                                TransactionCharges.TestField("G/L Account");
                                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin

                                    ChargeAmount := 0;
                                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                        ChargeAmount := (DividendLine."Gross Dividends" * TransactionCharges."Percentage of Amount") * 0.01
                                    else
                                        ChargeAmount := TransactionCharges."Charge Amount";

                                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if (DividendLine."Gross Dividends" >= TariffDetails."Lower Limit") and (DividendLine."Gross Dividends" <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin
                                                        ChargeAmount := (DividendLine."Gross Dividends" * TariffDetails.Percentage * 0.01);
                                                    end else begin
                                                        ChargeAmount := TariffDetails."Charge Amount";
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end;
                                    end;

                                    if RunBal > 0 then begin

                                        LineNo := LineNo + 10000;
                                        TellerMngt.InitializeEntry(GenJournaline, LineNo, Temp."Periodic Journal Template",
                                        Temp."Periodic Journal Batch", DocumentNo, '', Today, Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code");
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                        GenJournaline.Validate("Account No.", Account."No.");
                                        GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                        GenJournaline.Description := TransactionCharges.Description;
                                        GenJournaline.Validate(Amount, ChargeAmount);
                                        GenJournaline.Validate("Bal. Account No.", TransactionCharges."G/L Account");
                                        GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                        GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);
                                        RunBal := RunBal - GenJournaline.Amount;
                                    end;

                                    if TransactionCharges."Recover Excise Duty" then begin

                                        GenSetup.TestField("Excise Duty (%)");
                                        GenSetup.TestField("Excise Duty G/L");
                                        if RunBal > 0 then begin

                                            LineNo := LineNo + 10000;
                                            TellerMngt.InitializeEntry(GenJournaline, LineNo, Temp."Periodic Journal Template",
                                            Temp."Periodic Journal Batch", DocumentNo, '', Today, Temp."Shortcut Dimension 1 Code",
                                            Temp."Shortcut Dimension 2 Code");
                                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                            GenJournaline.Validate("Account No.", Account."No.");
                                            GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                            GenJournaline.Description := 'Excise Duty on-' + TransactionCharges.Description;
                                            GenJournaline.Validate(Amount, (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01);
                                            GenJournaline.Validate("Bal. Account No.", GenSetup."Excise Duty G/L");
                                            GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                            GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                            if GenJournaline.Amount <> 0 then
                                                GenJournaline.Insert(true);
                                            RunBal := RunBal - GenJournaline.Amount;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        // Div Discount
                        if DivDiscount then begin

                            Ploan.Reset();
                            Ploan.SetRange("Account No.", Account."Member No.");
                            Ploan.SetFilter("Outstanding Balance", '>0');
                            Ploan.SetRange("Product Type", 'DIVIDEND');
                            if Ploan.FindFirst() then begin
                                repeat
                                    Ploan.CalcFields("Outstanding Balance", "Outstanding Principal");

                                    if RunBal > 0 then begin

                                        GenJournaline.LockTable();
                                        LineNo := LineNo + 10000;
                                        TellerMngt.InitializeEntries(GenJournaline, LineNo,
                                        Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                                        DocumentNo, '', RunDate, Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code");
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                        GenJournaline.Description := Ploan."Product Description" + ' Repayment';
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                        GenJournaline.Validate("Account No.", Account."No.");
                                        if RunBal > Ploan."Outstanding Principal" then
                                            GenJournaline.Validate(Amount, Ploan."Outstanding Principal") else
                                            GenJournaline.Validate(Amount, RunBal);
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);

                                        GenJournaline.LockTable();
                                        LineNo := LineNo + 10000;

                                        TellerMngt.InitializeEntries(GenJournaline, LineNo,
                                        Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                                        DocumentNo, '', RunDate, Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code");
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                        GenJournaline.Description := Ploan."Product Description" + ' Repayment';
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                        GenJournaline.Validate("Account No.", Ploan."Loan Account");
                                        if RunBal > Ploan."Outstanding Principal" then
                                            GenJournaline.Validate(Amount, Ploan."Outstanding Principal" * -1) else
                                            GenJournaline.Validate(Amount, RunBal * -1);
                                        GenJournaline."Transaction Type" := GenJournaline."Transaction Type"::Repayment;
                                        GenJournaline.Validate("Loan No.", Ploan."No.");
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);
                                        RunBal := (RunBal - Abs(GenJournaline.Amount));
                                    end;
                                until Ploan.Next() = 0;
                            end;
                        end;
                        // end div Discounting
                        /// Loans With Arrears
                        if LoanArrear then begin
                            // Loan Principal
                            Ploan.Reset();
                            Ploan.SetRange("Account No.", Account."Member No.");
                            Ploan.SetFilter("Outstanding Principal", '>0');
                            Ploan.SetFilter("Amount In Arrears", '>0');
                            if Ploan.FindFirst() then begin
                                repeat
                                    Ploan.CalcFields("Outstanding Balance", "Outstanding Principal", "Outstanding Interest");
                                    LRepayment := 0;
                                    LRepayment := Ploan."Amount In Arrears";

                                    if LRepayment >= Ploan."Outstanding Principal" then
                                        LRepayment := Ploan."Outstanding Principal";

                                    if RunBal > 0 then begin

                                        GenJournaline.LockTable();
                                        LineNo := LineNo + 10000;
                                        TellerMngt.InitializeEntries(GenJournaline, LineNo,
                                        Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                                        DocumentNo, '', RunDate, Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code");
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                        GenJournaline.Description := Ploan."Product Description" + ' Repayment';
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                        GenJournaline.Validate("Account No.", Account."No.");
                                        if RunBal > LRepayment then
                                            GenJournaline.Validate(Amount, LRepayment) else
                                            GenJournaline.Validate(Amount, RunBal);
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);

                                        GenJournaline.LockTable();

                                        LineNo := LineNo + 10000;
                                        TellerMngt.InitializeEntries(GenJournaline, LineNo,
                                        Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                                        DocumentNo, '', RunDate, Temp."Shortcut Dimension 1 Code",
                                        Temp."Shortcut Dimension 2 Code");
                                        GenJournaline."Line No." := LineNo;
                                        GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                        GenJournaline.Description := Ploan."Product Description" + 'Repayment';
                                        GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                        GenJournaline.Validate("Account No.", Ploan."Loan Account");
                                        if RunBal > LRepayment then
                                            GenJournaline.Validate(Amount, LRepayment * -1) else
                                            GenJournaline.Validate(Amount, RunBal * -1);
                                        GenJournaline."Transaction Type" := GenJournaline."Transaction Type"::Repayment;
                                        GenJournaline.Validate("Loan No.", Ploan."No.");
                                        if GenJournaline.Amount <> 0 then
                                            GenJournaline.Insert(true);
                                        RunBal := (RunBal - Abs(GenJournaline.Amount));
                                    end;
                                until Ploan.Next() = 0;
                            end; // End Principal
                        end; // End Loan Arrears

                        if SimDivHeader."Deduct QC Recovery" then begin

                            ObjtMember.Reset();
                            ObjtMember.SetRange("No.", DividendLine."Member No.");
                            if ObjtMember.FindFirst() then begin
                                if ObjtMember."Gross Dividends" > 0 then begin

                                    CredAccount.Reset();
                                    CredAccount.SetRange("Member No.", DividendLine."Member No.");
                                    CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Deposit");
                                    if CredAccount.FindFirst() then begin
                                        if RunBal > 0 then begin

                                            LineNo := LineNo + 10000;
                                            GenJournaline.Init();
                                            GenJournaline."Journal Template Name" := Temp."Periodic Journal Template";
                                            GenJournaline."Journal Batch Name" := Temp."Periodic Journal Batch";
                                            GenJournaline."Document No." := DocumentNo;
                                            GenJournaline."Line No." := LineNo;
                                            GenJournaline."Posting Date" := RunDate;
                                            GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                            GenJournaline.Description := 'Quick Cash Loan Recovery';
                                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                            GenJournaline.Validate("Account No.", Account."No.");
                                            if RunBal > ObjtMember."Gross Dividends" then
                                                GenJournaline.Validate(Amount, ObjtMember."Gross Dividends") else
                                                GenJournaline.Validate(Amount, RunBal);
                                            GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                                            GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                            GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                            if GenJournaline.Amount <> 0 then
                                                GenJournaline.Insert(true);

                                            LineNo := LineNo + 10000;
                                            TellerMngt.InitializeEntries(GenJournaline, LineNo,
                                            Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                                            DocumentNo, '', RunDate, Temp."Shortcut Dimension 1 Code",
                                            Temp."Shortcut Dimension 2 Code");
                                            GenJournaline."Line No." := LineNo;
                                            GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                            GenJournaline.Description := 'Quick Cash Loan Recovery';
                                            GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                            GenJournaline.Validate("Account No.", CredAccount."No.");
                                            if RunBal > ObjtMember."Gross Dividends" then
                                                GenJournaline.Validate(Amount, ObjtMember."Gross Dividends" * -1) else
                                                GenJournaline.Validate(Amount, RunBal * -1);
                                            if GenJournaline.Amount <> 0 then
                                                GenJournaline.Insert(true);
                                            RunBal := (RunBal - Abs(GenJournaline.Amount));
                                        end;
                                    end;
                                end;
                            end;
                        end;





                        if SimDivHeader."Post Capitalization" then begin

                            AccountType.Get(SimDivHeader."Product Type");
                            case AccountType."Account Category" of
                                AccountType."Account Category"::"Money Market":
                                    begin

                                        SavingsAcc.Reset();
                                        SavingsAcc.SetRange(Blocked, Account.Blocked::" ");
                                        SavingsAcc.SetRange("Member No.", DividendLine."Member No.");
                                        SavingsAcc.SetRange("Product Type", SimDivHeader."Product Type");
                                        if SavingsAcc.FindFirst() then begin

                                            ///Post into Capitalization On banking Account
                                            LineNo := LineNo + 10000;
                                            GenJournaline.Init();
                                            GenJournaline."Journal Template Name" := Temp."Periodic Journal Template";
                                            GenJournaline."Journal Batch Name" := Temp."Periodic Journal Batch";
                                            GenJournaline."Document No." := DocumentNo;
                                            GenJournaline."Line No." := LineNo;
                                            GenJournaline."Posting Date" := RunDate;
                                            GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                            GenJournaline.Description := Descript + DividendLine."Product Name" + '-' + Format(Expr1) + '-' + DividendLine."Account No.";
                                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                            GenJournaline.Validate("Account No.", SavingsAcc."No.");
                                            GenJournaline.Validate(Amount, RunBal * -1);
                                            GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                            GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                            if GenJournaline.Amount <> 0 then
                                                GenJournaline.Insert(true);

                                            ///Post into Fosa Gross Amount
                                            LineNo := LineNo + 10000;
                                            GenJournaline.Init();
                                            GenJournaline."Journal Template Name" := Temp."Periodic Journal Template";
                                            GenJournaline."Journal Batch Name" := Temp."Periodic Journal Batch";
                                            GenJournaline."Document No." := DocumentNo;
                                            GenJournaline."Line No." := LineNo;
                                            GenJournaline."Posting Date" := RunDate;
                                            GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                            GenJournaline.Description := Descript + DividendLine."Product Name" + '-' + Format(Expr1) + '-' + DividendLine."Account No.";
                                            GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                            GenJournaline.Validate("Account No.", Account."No.");
                                            GenJournaline.Validate(Amount, RunBal);
                                            GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                            GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                            if GenJournaline.Amount <> 0 then
                                                GenJournaline.Insert(true);
                                        end
                                    end else begin

                                    ObjtMember.Reset();
                                    ObjtMember.SetRange("No.", DividendLine."Member No.");
                                    ObjtMember.SetRange(Status, ObjtMember.Status::Withdrawn);
                                    if ObjtMember.FindFirst() then begin

                                        CredAccount.Reset();
                                        CredAccount.SetRange("Member No.", DividendLine."Member No.");
                                        CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Capital");
                                        if CredAccount.FindFirst() then begin
                                            if RunBal > 0 then begin

                                                LineNo := LineNo + 10000;
                                                GenJournaline.Init();
                                                GenJournaline."Journal Template Name" := Temp."Periodic Journal Template";
                                                GenJournaline."Journal Batch Name" := Temp."Periodic Journal Batch";
                                                GenJournaline."Document No." := DocumentNo;
                                                GenJournaline."Line No." := LineNo;
                                                GenJournaline."Posting Date" := RunDate;
                                                GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                                GenJournaline.Description := 'Dividends Capilization';
                                                GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                                                GenJournaline.Validate("Account No.", Account."No.");
                                                GenJournaline.Validate(Amount, RunBal);
                                                GenJournaline."Bal. Account Type" := GenJournaline."Bal. Account Type"::"G/L Account";
                                                GenJournaline.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                                GenJournaline.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                                if GenJournaline.Amount <> 0 then
                                                    GenJournaline.Insert(true);

                                                LineNo := LineNo + 10000;
                                                TellerMngt.InitializeEntries(GenJournaline, LineNo,
                                                Temp."Periodic Journal Template", Temp."Periodic Journal Batch",
                                                DocumentNo, '', RunDate, Temp."Shortcut Dimension 1 Code",
                                                Temp."Shortcut Dimension 2 Code");
                                                GenJournaline."Line No." := LineNo;
                                                GenJournaline."External Document No." := 'DIVIDEND' + '-' + format(Expr1);
                                                GenJournaline.Description := 'Dividends Capilization';
                                                GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                                                GenJournaline.Validate("Account No.", CredAccount."No.");
                                                GenJournaline.Validate(Amount, RunBal * -1);
                                                if GenJournaline.Amount <> 0 then
                                                    GenJournaline.Insert(true);
                                                RunBal := (RunBal - Abs(GenJournaline.Amount));
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        Case ValuePost of
                            1:
                                begin

                                    JnlPostMngt.CompletePosting(Temp."Periodic Journal Template", Temp."Periodic Journal Batch");
                                    Commit();
                                    DividendLine.Posted := true;
                                    DividendLine.Modify(true);

                                    if ObjtMember.Get(DividendLine."Member No.") then begin
                                        Notif.CreateSmsNotif(NotifSource::"Account Status",
                                        ObjtMember."Mobile Phone No", 'Dear ' + ObjtMember."First Name" +
                                        ',  Dividends & Interest on Deposits for the year ' + format(Expr1) +
                                         'have been credited to your FOSA account. Access funds via Mobile', DocumentNo, ObjtMember."No.", false);
                                    end;
                                end;
                        end;
                    end;
                end;

            until DividendLine.Next() = 0;

            Case ValuePost of
                0:
                    begin
                        varvariant := SimDivHeader;
                        DocPostMgt.DocPrintRepayschedule(varvariant, 0);
                    end;
                1:
                    begin
                        SimDivHeader.Status := SimDivHeader.Status::Posted;
                        SimDivHeader.Modify(true);
                        OnAfterPostDiviend(SimDivHeader);
                        Message('Process Complete');
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostDiviend(DividendHeader: Record "Dividend Simulation Header")
    begin

    end;

    procedure CreateCredReceiptLine(TellTransact: Record "Teller Transaction"; SuggestSource: Integer; OptionCreditReceipt: Enum OptionsCreditReceipts)
    var
        PurchLine: Record "Cashier Transaction Line";
        CreditAcc: Record "Account Credit";
        Loans: Record Loans;
        TellerLine: Record "Cashier Transaction Line";
        Accredit: Record "Account Credit";
        Loan: Record Loans;
        ProductType: Record "Product Factory";
        MemberContribt: Record "Member Monthly Contribution";
        RunBal: Decimal;
        DiffAmt: Decimal;
        MonthlyContrib: Decimal;
        LRepayment: Decimal;
    begin
        RunBal := 0;
        MonthlyContrib := 0;
        RegMngt.InitializeTellerLines(TellTransact."No.");
        TellTransact.TestField(Amount);
        RunBal := TellTransact.Amount;

        Gensetup.Get();

        case OptionCreditReceipt of

            OptionCreditReceipt::Loans:
                begin
                    RegMngt.InitializeTellerLines(TellTransact."No.");
                    Loan.Reset();
                    Loan.SetRange("Account No.", TellTransact."Member No.");
                    if Loan.FindSet() then begin
                        repeat
                            LRepayment := 0;
                            Loan.CalcFields("Outstanding Balance", "Outstanding Principal");
                            if Loan."Outstanding Balance" > 0 then begin
                                LRepayment := Loan.Repayment;
                                if LRepayment > Loan."Outstanding Principal" then
                                    LRepayment := Loan."Outstanding Principal";

                                if RunBal > 0 then begin
                                    TellerLine."Transaction No." := TellTransact."No.";
                                    TellerLine."Member No." := TellTransact."Member No.";
                                    TellerLine."Account Type" := TellerLine."Account Type"::Loan;
                                    TellerLine."Transaction Type" := TellerLine."Transaction Type"::Repayment;
                                    TellerLine.Validate("Account No.", Loan."Loan Account");
                                    TellerLine.Validate("Loan No.", Loan."No.");
                                    if RunBal > LRepayment then
                                        TellerLine.Validate(Amount, LRepayment) else
                                        TellerLine.Validate(Amount, RunBal);
                                    TellerLine."Amount (LCY)" := TellerLine.Amount;
                                    TellerLine."Account Category" := TellerLine."Account Category"::" ";
                                    if TellerLine.Amount > 0 then
                                        TellerLine.Insert(true);
                                    RunBal := (RunBal - TellerLine.Amount);
                                end;
                            end;
                        until Loan.Next() = 0;
                    end;
                end;

            OptionCreditReceipt::Deposit:
                begin
                    RegMngt.InitializeTellerLines(TellTransact."No.");

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                    if Accredit.FindSet() then begin

                        Accredit.CalcFields("Balance (LCY)");
                        MemberContribt.Reset();
                        MemberContribt.SetRange("Application No.", Accredit."No.");
                        MemberContribt.SetRange(Type, Accredit."Account Category");
                        if MemberContribt.FindFirst() then
                            MonthlyContrib := MemberContribt.Amount else
                            Error('Member monthly contribution information on amount is not Available');

                        if RunBal > 0 then begin
                            TellerLine.Init();
                            TellerLine."Transaction No." := TellTransact."No.";
                            TellerLine."Member No." := TellTransact."Member No.";
                            TellerLine."Account Type" := TellerLine."Account Type"::Credit;
                            TellerLine.Validate("Account No.", Accredit."No.");
                            TellerLine.Validate(Amount, RunBal);
                            TellerLine."Loan No." := '';
                            TellerLine."Transaction Type" := TellerLine."Transaction Type"::" ";
                            TellerLine."Account Category" := Accredit."Account Category";
                            if TellerLine.Amount > 0 then
                                TellerLine.Insert(true);
                            RunBal := (RunBal - TellerLine.Amount);
                        end;
                    end;

                end;

            OptionCreditReceipt::"Share Capital":
                begin
                    RegMngt.InitializeTellerLines(TellTransact."No.");

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Capital");
                    if Accredit.FindSet() then begin
                        repeat
                            Accredit.CalcFields("Balance (LCY)");
                            if ProductType.Get(Accredit."Product Type") then begin
                                DiffAmt := 0;
                                DiffAmt := (ProductType."Minimum Balance" - Accredit."Balance (LCY)");
                                if DiffAmt > 0 then begin
                                    TellerLine.Init();
                                    TellerLine."Transaction No." := TellTransact."No.";
                                    TellerLine."Member No." := TellTransact."Member No.";
                                    TellerLine."Account Type" := TellerLine."Account Type"::Credit;
                                    TellerLine.Validate("Account No.", Accredit."No.");
                                    TellerLine.Validate(Amount, RunBal);
                                    if TellerLine.Amount > 0 then
                                        TellerLine.Insert(true);
                                    RunBal := (RunBal - TellerLine.Amount);
                                end
                            end;
                        until Accredit.Next() = 0;
                    end;

                end;
            OptionCreditReceipt::"All Accounts":
                begin
                    RegMngt.InitializeTellerLines(TellTransact."No.");

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Registration Fee");
                    if Accredit.FindSet() then begin
                        Accredit.CalcFields("Balance (LCY)");
                        if ProductType.Get(Accredit."Product Type") then begin
                            DiffAmt := 0;
                            if Accredit."Balance (LCY)" < ProductType."Minimum Balance" then begin
                                DiffAmt := (ProductType."Minimum Balance" - Accredit."Balance (LCY)");
                                if RunBal > 0 then begin

                                    TellerLine.Init();
                                    TellerLine."Transaction No." := TellTransact."No.";
                                    TellerLine."Member No." := TellTransact."Member No.";
                                    TellerLine."Account Type" := TellerLine."Account Type"::Credit;
                                    TellerLine.Validate("Account No.", Accredit."No.");
                                    if RunBal > DiffAmt then
                                        TellerLine.Validate(Amount, DiffAmt) else
                                        TellerLine.Validate(Amount, RunBal);
                                    if TellerLine.Amount > 0 then
                                        TellerLine.Insert(true);
                                    RunBal := (RunBal - TellerLine.Amount);
                                end;

                            end
                        end;
                    end;

                    Loan.Reset();
                    Loan.SetRange("Account No.", TellTransact."Member No.");
                    if Loan.FindSet() then begin
                        repeat
                            LRepayment := 0;
                            Loan.CalcFields("Outstanding Balance", "Outstanding Principal");
                            if Loan."Outstanding Balance" > 0 then begin
                                LRepayment := Loan.Repayment;
                                if LRepayment > Loan."Outstanding Principal" then
                                    LRepayment := Loan."Outstanding Principal";

                                if RunBal > 0 then begin
                                    TellerLine."Transaction No." := TellTransact."No.";
                                    TellerLine."Member No." := TellTransact."Member No.";
                                    TellerLine."Account Type" := TellerLine."Account Type"::Loan;
                                    TellerLine."Transaction Type" := TellerLine."Transaction Type"::Repayment;
                                    TellerLine.Validate("Account No.", Loan."Loan Account");
                                    TellerLine.Validate("Loan No.", Loan."No.");
                                    if RunBal > LRepayment then
                                        TellerLine.Validate(Amount, LRepayment) else
                                        TellerLine.Validate(Amount, RunBal);
                                    TellerLine."Amount (LCY)" := TellerLine.Amount;
                                    TellerLine."Account Category" := TellerLine."Account Category"::" ";
                                    if TellerLine.Amount > 0 then
                                        TellerLine.Insert(true);
                                    RunBal := (RunBal - TellerLine.Amount);
                                end;
                            end;
                        until Loan.Next() = 0;
                    end;

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetFilter("Account Category", '%1 | %2', Accredit."Account Category"::"Shares Deposit", Accredit."Account Category"::"Shares Capital");
                    if Accredit.FindSet() then begin
                        repeat
                            Accredit.CalcFields("Balance (LCY)");

                            if ProductType.Get(Accredit."Product Type") then
                                MemberContribt.Reset();
                            MemberContribt.SetRange("Application No.", Accredit."No.");
                            MemberContribt.SetRange(Type, Accredit."Account Category");
                            if MemberContribt.FindFirst() then
                                MonthlyContrib := MemberContribt.Amount else
                                MonthlyContrib := ProductType."Minimum Contribution";

                            if RunBal > 0 then begin
                                TellerLine.Init();
                                TellerLine."Transaction No." := TellTransact."No.";
                                TellerLine."Member No." := TellTransact."Member No.";
                                TellerLine."Account Type" := TellerLine."Account Type"::Credit;
                                TellerLine.Validate("Account No.", Accredit."No.");
                                if RunBal > MonthlyContrib then
                                    TellerLine.Validate(Amount, MonthlyContrib) else
                                    TellerLine.Validate(Amount, RunBal);
                                TellerLine."Loan No." := '';
                                TellerLine."Transaction Type" := TellerLine."Transaction Type"::" ";
                                TellerLine."Account Category" := Accredit."Account Category";
                                if TellerLine.Amount > 0 then
                                    TellerLine.Insert(true);
                                RunBal := (RunBal - TellerLine.Amount);
                            end;
                        until Accredit.Next() = 0;
                    end;

                end;
        end;
    end;

    procedure CreateFinanceReceiptLine(TellTransact: Record "Receipts Header"; SuggestSource: Integer; OptionCreditReceipt: Enum OptionsCreditReceipts)
    var
        PurchLine: Record "Receipt Line";
        CreditAcc: Record "Account Credit";
        Loans: Record Loans;
        TellerLine: Record "Receipt Line";
        Accredit: Record "Account Credit";
        Loan: Record Loans;
        ProductType: Record "Product Factory";
        MemberContribt: Record "Member Monthly Contribution";
        RunBal: Decimal;
        DiffAmt: Decimal;
        MonthlyContrib: Decimal;
        LRepayment: Decimal;
        RecType: Record "Receipts and Payment Types";
        AccBanking: Record "Account Banking";
    begin
        RunBal := 0;
        MonthlyContrib := 0;
        RegMngt.InitializeReceiptLines(TellTransact."No.");
        TellTransact.TestField("Amount Recieved");
        RunBal := TellTransact."Amount Recieved";
        Gensetup.Get();

        case OptionCreditReceipt of

            OptionCreditReceipt::Loans:
                begin
                    RegMngt.InitializeReceiptLines(TellTransact."No.");
                    RecType.Reset();
                    RecType.SetRange(Type, RecType.Type::Receipt);
                    RecType.SetRange("Account Type", RecType."Account Type"::Loan);
                    if RecType.FindFirst() then begin

                        Loan.Reset();
                        Loan.SetRange("Account No.", TellTransact."Member No.");
                        if Loan.FindSet() then begin
                            repeat
                                LRepayment := 0;
                                Loan.CalcFields("Outstanding Balance", "Outstanding Principal");
                                if Loan."Outstanding Balance" > 0 then begin
                                    LRepayment := Loan.Repayment;
                                    if LRepayment > Loan."Outstanding Principal" then
                                        LRepayment := Loan."Outstanding Principal";

                                    if RunBal > 0 then begin
                                        TellerLine.No := TellTransact."No.";
                                        TellerLine."Transaction No." := TellTransact."No.";
                                        TellerLine."Member No." := TellTransact."Member No.";
                                        TellerLine.Validate(Type, RecType.Code);
                                        TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                                        TellerLine."Transaction Type" := TellerLine."Transaction Type"::Repayment;
                                        TellerLine.Validate("Account No.", Loan."Loan Account");
                                        TellerLine.Validate("Loan No.", Loan."No.");
                                        if RunBal > LRepayment then
                                            TellerLine.Validate(Amount, LRepayment) else
                                            TellerLine.Validate(Amount, RunBal);
                                        TellerLine."Product Category" := TellerLine."Product Category"::" ";
                                        if TellerLine.Amount > 0 then
                                            TellerLine.Insert(true);
                                        RunBal := (RunBal - TellerLine.Amount);
                                    end;
                                end;
                            until Loan.Next() = 0;
                        end;
                    end;
                end;

            OptionCreditReceipt::Deposit:
                begin

                    RegMngt.InitializeReceiptLines(TellTransact."No.");

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                    if Accredit.FindSet() then begin
                        Accredit.CalcFields("Balance (LCY)");

                        RecType.Reset();
                        RecType.SetRange(Type, RecType.Type::Receipt);
                        RecType.SetRange("Account Type", RecType."Account Type"::Credit);
                        RecType.SetRange("Default Grouping", Accredit."Customer Posting Group");
                        if RecType.FindFirst() then begin

                            TellerLine.Init();
                            TellerLine.No := TellTransact."No.";
                            TellerLine."Transaction No." := TellTransact."No.";
                            TellerLine."Member No." := TellTransact."Member No.";
                            TellerLine.Validate(Type, RecType.Code);
                            TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                            TellerLine.Validate("Account No.", Accredit."No.");
                            TellerLine.Validate(Amount, RunBal);
                            TellerLine."Loan No." := '';
                            TellerLine."Transaction Type" := TellerLine."Transaction Type"::" ";
                            TellerLine."Product Category" := Accredit."Account Category";
                            TellerLine.Insert(true);
                        end;
                    end;
                end;

            OptionCreditReceipt::Accounts:
                begin

                    RegMngt.InitializeReceiptLines(TellTransact."No.");

                    AccBanking.Reset();
                    AccBanking.SetRange("Member No.", TellTransact."Member No.");
                    AccBanking.SetFilter("Account Category", '%1| %2 | %3', AccBanking."Account Category"::"Islamic Banking",
                    AccBanking."Account Category"::"Money Market", AccBanking."Account Category"::"Specialty Savings");
                    if AccBanking.FindSet() then begin
                        repeat
                            AccBanking.CalcFields("Balance (LCY)");
                            if ProductType.Get(AccBanking."Product Type") then begin

                                RecType.Reset();
                                RecType.SetRange(Type, RecType.Type::Receipt);
                                RecType.SetRange("Account Type", RecType."Account Type"::Saving);
                                RecType.SetRange("Default Grouping", AccBanking."Customer Posting Group");
                                if RecType.FindFirst() then begin

                                    TellerLine.Init();
                                    TellerLine.No := TellTransact."No.";
                                    TellerLine."Transaction No." := TellTransact."No.";
                                    TellerLine."Member No." := TellTransact."Member No.";
                                    TellerLine.Validate(Type, RecType.Code);
                                    TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                                    TellerLine.Validate("Account No.", AccBanking."No.");
                                    TellerLine.Insert(true);
                                end;
                            end;
                        until AccBanking.Next() = 0;
                    end
                end;

            OptionCreditReceipt::"Share Capital":
                begin

                    RegMngt.InitializeReceiptLines(TellTransact."No.");

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Capital");
                    if Accredit.FindSet() then begin

                        Accredit.CalcFields("Balance (LCY)");
                        RecType.Reset();
                        RecType.SetRange(Type, RecType.Type::Receipt);
                        RecType.SetRange("Account Type", RecType."Account Type"::Credit);
                        RecType.SetRange("Default Grouping", Accredit."Customer Posting Group");
                        if RecType.FindFirst() then begin

                            if ProductType.Get(Accredit."Product Type") then begin
                                DiffAmt := 0;
                                DiffAmt := (ProductType."Minimum Balance" - Accredit."Balance (LCY)");
                                if RunBal > 0 then begin
                                    TellerLine.Init();
                                    TellerLine.No := TellTransact."No.";
                                    TellerLine."Transaction No." := TellTransact."No.";
                                    TellerLine."Member No." := TellTransact."Member No.";
                                    TellerLine.Validate(Type, RecType.Code);
                                    TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                                    TellerLine.Validate("Account No.", Accredit."No.");
                                    TellerLine.Validate(Amount, RunBal);
                                    if TellerLine.Amount > 0 then
                                        TellerLine.Insert(true);
                                    RunBal := (RunBal - TellerLine.Amount);
                                end
                            end;
                        end
                    end;
                end;

            OptionCreditReceipt::"All Accounts":
                begin

                    RegMngt.InitializeReceiptLines(TellTransact."No.");
                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetFilter("Account Category", '%1|%2', Accredit."Account Category"::"Shares Capital", Accredit."Account Category"::"Registration Fee");
                    if Accredit.FindSet() then begin
                        repeat

                            RecType.Reset();
                            RecType.SetRange(Type, RecType.Type::Receipt);
                            RecType.SetRange("Account Type", RecType."Account Type"::Credit);
                            RecType.SetRange("Default Grouping", Accredit."Customer Posting Group");
                            if RecType.FindFirst() then begin
                                Accredit.CalcFields("Balance (LCY)");
                                if ProductType.Get(Accredit."Product Type") then begin
                                    DiffAmt := 0;

                                    if Accredit."Balance (LCY)" < ProductType."Minimum Balance" then begin
                                        DiffAmt := (ProductType."Minimum Balance" - Accredit."Balance (LCY)");

                                        if RunBal > 0 then begin

                                            TellerLine.Init();
                                            TellerLine.No := TellTransact."No.";
                                            TellerLine."Transaction No." := TellTransact."No.";
                                            TellerLine."Member No." := TellTransact."Member No.";
                                            TellerLine.Validate(Type, RecType.Code);
                                            TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                                            TellerLine.Validate("Account No.", Accredit."No.");
                                            if RunBal > DiffAmt then
                                                TellerLine.Validate(Amount, DiffAmt) else
                                                TellerLine.Validate(Amount, RunBal);
                                            if TellerLine.Amount > 0 then
                                                TellerLine.Insert(true);
                                            RunBal := (RunBal - TellerLine.Amount);
                                        end
                                    end;
                                end;
                            end;
                        until Accredit.Next() = 0;
                    end;

                    Loan.Reset();
                    Loan.SetRange("Account No.", TellTransact."Member No.");
                    if Loan.FindSet() then begin
                        repeat

                            RecType.Reset();
                            RecType.SetRange(Type, RecType.Type::Receipt);
                            RecType.SetRange("Account Type", RecType."Account Type"::Loan);
                            if RecType.FindFirst() then begin
                                LRepayment := 0;
                                Loan.CalcFields("Outstanding Balance", "Outstanding Principal");
                                if Loan."Outstanding Balance" > 0 then begin
                                    LRepayment := Loan.Repayment;
                                    if LRepayment > Loan."Outstanding Principal" then
                                        LRepayment := Loan."Outstanding Principal";

                                    if RunBal > 0 then begin
                                        TellerLine.No := TellTransact."No.";
                                        TellerLine."Transaction No." := TellTransact."No.";
                                        TellerLine."Member No." := TellTransact."Member No.";
                                        TellerLine.Validate(Type, RecType.Code);
                                        TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                                        TellerLine."Transaction Type" := TellerLine."Transaction Type"::Repayment;
                                        TellerLine.Validate("Account No.", Loan."Loan Account");
                                        TellerLine.Validate("Loan No.", Loan."No.");
                                        if RunBal > LRepayment then
                                            TellerLine.Validate(Amount, LRepayment) else
                                            TellerLine.Validate(Amount, RunBal);
                                        TellerLine."Product Category" := TellerLine."Product Category"::" ";
                                        if TellerLine.Amount > 0 then
                                            TellerLine.Insert(true);
                                        RunBal := (RunBal - TellerLine.Amount);
                                    end;
                                end;
                            end;
                        until Loan.Next() = 0;
                    end;

                    Accredit.Reset();
                    Accredit.SetRange("Member No.", TellTransact."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                    if Accredit.FindSet() then begin

                        RecType.Reset();
                        RecType.SetRange(Type, RecType.Type::Receipt);
                        RecType.SetRange("Account Type", RecType."Account Type"::Credit);
                        RecType.SetRange("Default Grouping", Accredit."Customer Posting Group");
                        if RecType.FindFirst() then begin

                            Accredit.CalcFields("Balance (LCY)");

                            TellerLine.Init();
                            TellerLine.No := TellTransact."No.";
                            TellerLine."Transaction No." := TellTransact."No.";
                            TellerLine."Member No." := TellTransact."Member No.";
                            TellerLine.Validate(Type, RecType.Code);
                            TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                            TellerLine.Validate("Account No.", Accredit."No.");
                            TellerLine.Validate(Amount, RunBal);
                            TellerLine."Loan No." := '';
                            TellerLine."Transaction Type" := TellerLine."Transaction Type"::" ";
                            TellerLine."Product Category" := Accredit."Account Category";
                            TellerLine."Pay Mode" := TellerLine."Pay Mode"::EFT;
                            TellerLine.Insert(true);
                        end;
                    end;
                end;
        end;
    end;

    procedure GenerateEFTClosureFile(PaymentRec: Record "Membership closure")
    EftFile: Record "EFT File";
    begin

        PaymentRec.CheckMinRequirement(2);
        if not CheckExistGeneratedFile(PaymentRec."No.") then begin

            GenerateAccountClose(PaymentRec);
            EftFile.Reset();
            EftFile.SetRange("EFT No.", PaymentRec."No.");
            if EftFile.FindFirst() then begin
                PaymentRec."Approval Status" := PaymentRec."Approval Status"::Transferred;
                PaymentRec.Modify(true)
            end;
        end else begin
            Error(Text000011, PaymentRec."No.");
        end;
    end;

    procedure GenerateEFTFile(PaymentRec: Record "EFT Transfer Header")
    EftFile: Record "EFT File";
    begin

        PaymentRec.CheckMinRequired(1);

        if not CheckExistGeneratedFile(PaymentRec."No.") then begin
            case PaymentRec."EFT Options" of
                PaymentRec."EFT Options"::"Mobile Money":
                    begin
                        GenerateEFT(PaymentRec);
                        EftFile.Reset();
                        EftFile.SetRange("EFT No.", PaymentRec."No.");
                        if EftFile.FindFirst() then begin
                            PaymentRec."Approval Status" := PaymentRec."Approval Status"::Transferred;
                            PaymentRec.Modify(true)
                        end;
                    end;
                PaymentRec."EFT Options"::"Bank Account":
                    begin
                        GenerateEftBankTemplate(PaymentRec);
                        EftFile.Reset();
                        EftFile.SetRange("EFT No.", PaymentRec."No.");
                        if EftFile.FindFirst() then begin
                            PaymentRec."Approval Status" := PaymentRec."Approval Status"::Transferred;
                            PaymentRec.Modify(true)
                        end;
                    end;

                PaymentRec."EFT Options"::"Money Wallet":
                    begin
                        GenerateEftEWalletTemplate(PaymentRec);
                        EftFile.Reset();
                        EftFile.SetRange("EFT No.", PaymentRec."No.");
                        if EftFile.FindFirst() then begin
                            PaymentRec."Approval Status" := PaymentRec."Approval Status"::Transferred;
                            PaymentRec.Modify(true)
                        end;
                    end;
            end;
        end else begin
            Error(Text000011, PaymentRec."No.");
        end;
    end;

    procedure GenerateEFT(PaymentRec: Record "EFT Transfer Header"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "EFT Transfer Lines";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_EFT-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin
        CreateEFTHeader(PaymentRec, TempExcelBuffer);

        case PaymentRec."Application Source" of

            PaymentRec."Application Source"::Credit:
                begin
                    PaymentLines.reset();
                    PaymentLines.SetRange("Document No.", PaymentRec."No.");
                    if PaymentLines.findset() then
                        repeat
                            SerialNo := SerialNo + 1;
                            CreateEFTLine(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
                        until PaymentLines.Next() = 0;
                end;
            PaymentRec."Application Source"::Teller,
            PaymentRec."Application Source"::Benefits,
            PaymentRec."Application Source"::Finance:
                begin
                    PaymentLines.reset();
                    PaymentLines.SetRange("Document No.", PaymentRec."No.");
                    if PaymentLines.findset() then
                        repeat
                            SerialNo := SerialNo + 1;
                            CreateEFTLineSchoolFee(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
                        until PaymentLines.Next() = 0;
                end;
        end;

        CreateStoreFile(PaymentRec, StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."Product Type"));

        TempExcelBuffer.CreateNewBook(PaymentRec.TableCaption());
        TempExcelBuffer.WriteSheet(PaymentRec.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."Product Type");
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));
    end;

    local procedure CreateEFTHeader(PaymentRec: Record "EFT Transfer Header"; var TempExcelBuffer: Record "Excel Buffer")
    var
        FileBuffer: Record "EFT File";
        LastNum: Integer;
        FactProduct: Record "Product Factory";
    begin

        PaymentRec.CalcFields("Record Count", "Record Total");

        case PaymentRec."Application Source" of

            PaymentRec."Application Source"::Credit:
                begin
                    LastNum := 0;
                    FileBuffer.Reset();
                    FileBuffer.SetRange("EFT Options", FileBuffer."EFT Options"::"Mobile Money");
                    if FileBuffer.FindLast() then
                        LastNum := FileBuffer."Sequence No." + 1;

                    TempExcelBuffer.Reset();
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('HDR', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('SL ' + DelChr(format(PaymentRec."Date Entered"), '=', '/') + ' ' + Format(LastNum), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Format(PaymentRec."Record Count"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Format(PaymentRec."Record Total", 0, '<Precision,2:2><Standard Format,2>'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

                end;
            PaymentRec."Application Source"::Teller,
            PaymentRec."Application Source"::Benefits,
            PaymentRec."Application Source"::Finance:
                begin

                    FactProduct.Get(PaymentRec."Product Type");
                    LastNum := 0;
                    FileBuffer.Reset();
                    FileBuffer.SetRange("EFT Options", FileBuffer."EFT Options"::"Mobile Money");
                    if FileBuffer.FindLast() then
                        LastNum := FileBuffer."Sequence No." + 1;

                    TempExcelBuffer.Reset();
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('HDR', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(FactProduct.Description, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Format(PaymentRec."Record Count"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Format(PaymentRec."Record Total", 0, '<Precision,2:2><Standard Format,2>'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                end;
        end;
    end;

    local procedure CreateEFTLine(Payments: record "EFT Transfer Header"; PaymentLine: Record "EFT Transfer Lines"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        Loans: Record Loans;
    begin
        if Loans.Get(PaymentLine."Loan No.") then
            TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn(EntryNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('MSISDN', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Mobile Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Format(PaymentLine.Amount, 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Loans."Product Description" + ' ' + Loans."Account No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateEFTLineSchoolFee(Payments: record "EFT Transfer Header"; PaymentLine: Record "EFT Transfer Lines"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        Loans: Record Loans;
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(EntryNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('MSISDN', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Mobile Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Format(PaymentLine.Amount, 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SNATCOOP' + ' ' + PaymentLine."Member No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure GenerateEftBankTemplate(PaymentRec: Record "EFT Transfer Header"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "EFT Transfer Lines";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_EFT-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin

        CreateEFTHeaderBankTemplate(PaymentRec, TempExcelBuffer);
        PaymentLines.reset();
        PaymentLines.SetRange("Document No.", PaymentRec."No.");
        if PaymentLines.findset() then
            repeat
                PaymentLines.TestField("Member No.");
                CreateEFTLineBankTemplate(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
            until PaymentLines.Next() = 0;
        CreateStoreFile(PaymentRec, StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."Product Type"));

        TempExcelBuffer.CreateNewBook(PaymentRec.TableCaption());
        TempExcelBuffer.WriteSheet(PaymentRec.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."Product Type");
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));

    end;

    local procedure CreateEFTHeaderBankTemplate(PaymentRec: Record "EFT Transfer Header"; var TempExcelBuffer: Record "Excel Buffer")
    var
        BankDetails: Record "Bank Account";
    begin
        PaymentRec.CalcFields("Record Count", "Record Total");
        if BankDetails.Get(PaymentRec."Account No.") then;
        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('BInSol - U ver 1.00', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(format(PaymentRec."Date Entered", 10, '<Day,2>/<Month,2>/<Year4>'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(BankDetails."Bank Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('RECIPIENT NAME', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT ACCOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT ACCOUNT TYPE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BRANCHCODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AMOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OWN REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateEFTLineBankTemplate(Payments: record "EFT Transfer Header"; PaymentLine: Record "EFT Transfer Lines"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        AccName: Text[150];
    begin
        AccName := '';
        if PaymentLine."Source of funds" = PaymentLine."Source of funds"::Junior then
            AccName := PaymentLine."External Account Name" else
            AccName := PaymentLine."Account Name";

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(AccName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."External Account No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(PaymentLine."Branch Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(PaymentLine.Amount, 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Member No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Recipient Reference", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure GenerateEftEWalletTemplate(PaymentRec: Record "EFT Transfer Header"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "EFT Transfer Lines";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_EFT-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin

        CreateEFTHeaderEWalletTemplate(PaymentRec, TempExcelBuffer);
        PaymentLines.reset();
        PaymentLines.SetRange("Document No.", PaymentRec."No.");
        if PaymentLines.findset() then
            repeat
                CreateEFTLineEWalletTemplate(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
            until PaymentLines.Next() = 0;

        CreateStoreFile(PaymentRec, StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."Product Type"));

        TempExcelBuffer.CreateNewBook(PaymentRec.TableCaption());
        TempExcelBuffer.WriteSheet(PaymentRec.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."Product Type");
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));

    end;

    local procedure CreateEFTHeaderEWalletTemplate(PaymentRec: Record "EFT Transfer Header"; var TempExcelBuffer: Record "Excel Buffer")
    var
        BankDetails: Record "Bank Account";
    begin
        PaymentRec.CalcFields("Record Count", "Record Total");
        if BankDetails.Get(PaymentRec."Account No.") then;

        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('BInSol - U ver 1.00', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(format(PaymentRec."Date Entered", 10, '<Day,2>/<Month,2>/<Year4>'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(BankDetails."Bank Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('PAYEE NAME', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TO ACCOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TO', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BRANCHCODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AMOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OWN REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateEFTLineEWalletTemplate(Payments: record "EFT Transfer Header"; PaymentLine: Record "EFT Transfer Lines"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        CustRec: Record Member;
        MobilePhoneNo: code[20];
        Loans: Record Loans;
    begin

        MobilePhoneNo := '';
        case PaymentLine."EFT Options" of
            PaymentLine."EFT Options"::"Money Wallet":
                begin
                    if CustRec.Get(PaymentLine."Member No.") then begin
                        CustRec.TestField("Mobile Phone No");
                        MobilePhoneNo := DelChr(CustRec."Mobile Phone No", '=', '+')
                    end;
                end;
        end;

        if Loans.Get(PaymentLine."Loan No.") then
            TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(PaymentLine."Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(MobilePhoneNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('S', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(PaymentLine."Branch Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(PaymentLine.Amount, 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Member No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Loans."Product Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure GeneratePVBankTemplate(PaymentRec: Record "Payments Header"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "Payment Lines";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_EFT-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin

        CreatePVHeaderBankTemplate(PaymentRec, TempExcelBuffer);
        PaymentLines.reset();
        PaymentLines.SetRange(No, PaymentRec."No.");
        if PaymentLines.findset() then
            repeat
                CreatePVLineBankTemplate(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
            until PaymentLines.Next() = 0;

        CreateStoreFilePV(PaymentRec, StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."No."));

        TempExcelBuffer.CreateNewBook(PaymentRec.TableCaption());
        TempExcelBuffer.WriteSheet(PaymentRec.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."No.");
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));

    end;


    local procedure CreatePVHeaderBankTemplate(PaymentRec: Record "Payments Header"; var TempExcelBuffer: Record "Excel Buffer")
    var
        BankDetails: Record "Bank Account";
    begin
        PaymentRec.CalcFields("Total Amount");
        if BankDetails.Get(PaymentRec."Account No.") then;
        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('BInSol - U ver 1.00', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(format(PaymentRec."Payment Release Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(BankDetails."Bank Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('RECIPIENT NAME', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT ACCOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT ACCOUNT TYPE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BRANCHCODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AMOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OWN REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

    end;

    local procedure CreatePVLineBankTemplate(Payments: record "Payments Header"; PaymentLine: Record "Payment Lines"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record "Vendor Bank Account";
        Vendor: Record Vendor;
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(PaymentLine."Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Account No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(PaymentLine."Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(PaymentLine.Amount, 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateStoreFileAclosure(PaymentRec: Record "Membership closure"; FileNo: Text[250])
    var
        RegisterMngt: Codeunit "Register Management";
        EftOption: Enum EFTPaymentOptions;
    begin
        RegisterMngt.CreateEftFile(PaymentRec."No.", FileNo, EftOption::"Bank Account", 1,
        PaymentRec."Deposit Refundable");
    end;

    procedure CreateStoreFile(PaymentRec: Record "EFT Transfer Header"; FileNo: Text[250])
    var
        RegisterMngt: Codeunit "Register Management";
    begin
        PaymentRec.CalcFields("Record Count", "Record Total");
        RegisterMngt.CreateEftFile(PaymentRec."No.", FileNo, PaymentRec."EFT Options",
        PaymentRec."Record Count", PaymentRec."Record Total");
    end;

    procedure CreateStoreFilePV(PaymentRec: Record "Payments Header"; FileNo: Text[250])
    var
        RegisterMngt: Codeunit "Register Management";
        EftOption: Enum EFTPaymentOptions;
    begin
        PaymentRec.CalcFields("Total Amount");
        RegisterMngt.CreateEftFile(PaymentRec."No.", FileNo,
           EftOption::"Bank Account", 1, PaymentRec."Total Amount");
    end;

    procedure CheckExistGeneratedFile(EftNo: code[100]): Boolean
    var
        EFTFile: Record "EFT File";
    begin
        EFTFile.Reset();
        EFTFile.SetRange("EFT No.", EftNo);
        if EFTFile.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure GenerateAccountClose(PaymentRec: Record "Membership closure"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "Account Closure Line";
        TempBlob: Codeunit "Temp Blob";
        ExternalCommitment: Record "External Payment";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_EFT-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin

        case PaymentRec."EFT Options" of
            PaymentRec."EFT Options"::"Bank Account":
                begin
                    CreateClosureHeaderBankTemplate(PaymentRec, TempExcelBuffer);
                    PaymentRec.TestField("Approval Status", PaymentRec."Approval Status"::Posted);

                    case PaymentRec."Closure Type" of
                        PaymentRec."Closure Type"::"Withdrawal - Normal":
                            begin
                                PaymentLines.reset();
                                PaymentLines.SetRange("No.", PaymentRec."No.");
                                PaymentLines.SetRange("Account Category", PaymentLines."Account Category"::Savings);
                                if PaymentLines.FindFirst() then begin
                                    SerialNo := SerialNo + 1;
                                    CreateClosureLineTemplate(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
                                end;
                            end;
                        PaymentRec."Closure Type"::"Withdrawal - Death":
                            begin
                                SerialNo := SerialNo + 1;
                                CreateClosureLineExtnlTemplate(PaymentRec, PaymentLines, TempExcelBuffer, SerialNo);
                            end;
                    end;

                    CreateStoreFileAclosure(PaymentRec, StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."No."));
                    TempExcelBuffer.CreateNewBook(PaymentRec.TableCaption());
                    TempExcelBuffer.WriteSheet(PaymentRec.TableCaption(), CompanyName(), UserId());
                    TempExcelBuffer.CloseBook();

                    TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
                    TempExcelBuffer.SaveToStream(XlsxOutStream, true);
                    TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
                    FileName := StrSubstNo(FileNameTok, CurrentDateTime(), PaymentRec."No.");
                    exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));

                end;
        end;
    end;

    local procedure CreateClosureLineExtnlTemplate(Payments: record "Membership closure"; PaymentLine: Record "Account Closure Line"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record Banks;
        Vendor: Record "Account Banking";
        ExternalCommitment: Record "External Payment";

    begin

        ExternalCommitment.Reset();
        ExternalCommitment.SetRange("Application No.", Payments."No.");
        ExternalCommitment.SetRange("Member No.", Payments."Member No.");
        ExternalCommitment.SetRange("Account Type", ExternalCommitment."Account Type"::"Bank Account");
        if ExternalCommitment.Find('-') then begin
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(ExternalCommitment."External Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ExternalCommitment."External Account No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(ExternalCommitment."Branch Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(ExternalCommitment.Amount, 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ExternalCommitment."Member No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('COOP', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

            Until ExternalCommitment.Next() = 0;
        end;
    end;

    local procedure CreateClosureLineTemplate(Payments: record "Membership closure"; PaymentLine: Record "Account Closure Line"; var TempExcelBuffer: Record "Excel Buffer"; EntryNo: Integer)
    var
        VendorBank: Record Banks;
        Vendor: Record "Account Banking";
    begin
        Vendor.Reset();
        Vendor.SetRange("Member No.", Payments."Member No.");
        Vendor.SetRange("Account Category", Vendor."Account Category"::Savings);
        if Vendor.FindFirst() then
            Vendor.CalcFields("Balance (LCY)");

        VendorBank.Reset();
        VendorBank.SetRange(Code, Payments."Payment Destination Code");
        if VendorBank.FindFirst() then
            TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Payments."Member Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Payments."Payment Destination", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(VendorBank."Bank No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(PaymentLine."Net Amount", 0, '<Precision,2:2><Standard Format,2>'), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PaymentLine."Member No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('COOP', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

    end;

    local procedure CreateClosureHeaderBankTemplate(PaymentRec: Record "Membership closure"; var TempExcelBuffer: Record "Excel Buffer")
    var
        BankDetails: Record "Bank Account";
    begin

        if BankDetails.Get(PaymentRec."EFT Bank Account") then;

        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('BInSol - U ver 1.00', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(format(PaymentRec."Closing Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(BankDetails."Bank Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('RECIPIENT NAME', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT ACCOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT ACCOUNT TYPE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BRANCHCODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AMOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OWN REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECIPIENT REFERENCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 1 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 2 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 3 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 4 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 ADDRESS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EMAIL 5 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 1 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FAX 2 SUBJECT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 1 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 NOTIFY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 CODE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SMS 2 NUMBER', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure GenerateLoanArrearFile(LoanRec: Record "Loans Categorization"): Boolean
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PaymentLines: Record "EFT Transfer Lines";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        SerialNo: Integer;
        XlsxOutStream: OutStream;
        XlsxInStream: InStream;
        DialogTitleTok: Label 'Generate EFT as csv';
        XlsxFilterTok: Label 'Xlsx Files (*.csv)|*.csv';
        FileNameTok: Label '%1_EFT-%2.csv', Comment = '%1 = File no. %2 = Current Date', Locked = true;
    begin

        TempExcelBuffer.CreateNewBook(LoanRec.TableCaption());
        TempExcelBuffer.WriteSheet(LoanRec.TableCaption(), CompanyName(), UserId());
        TempExcelBuffer.CloseBook();

        TempBlob.CreateOutStream(XlsxOutStream, TextEncoding::UTF8);
        TempExcelBuffer.SaveToStream(XlsxOutStream, true);
        TempBlob.CreateInStream(XlsxInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(FileNameTok, CurrentDateTime(), LoanRec."Product Type");
        exit(File.DownloadFromStream(XlsxInStream, DialogTitleTok, '', XlsxFilterTok, FileName));
    end;

    local procedure CreateLoanArrearTemplate(LoanRec: Record "Loans Categorization"; var TempExcelBuffer: Record "Excel Buffer"; CutoffDate: Date; AccruedInt: Decimal)
    var
        BankDetails: Record "Bank Account";
        CompInfo: Record "Company Information";
    begin
        CompInfo.Get();

        TempExcelBuffer.Reset();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('LOAN ARREARS - U ver 1.00', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(format(CutOffDate, 10, '<Day,2>/<Month,2>/<Year4>'), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CompInfo.Name, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('NO.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ACCOUNT NO.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('NAME', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PRODUCT TYPE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DISBURSEMENT DATE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('REPAYMENT START DATE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('COMPLETION DATE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PERIOD', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('APPROVED AMOUNT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('REPAYMENT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EXPECTED REPAYMENT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EXPECTED BALANCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DAYS IN ARREARS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AMOUNT IN ARREARS', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ACCRUED INTEREST', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OUTSTANDING INSURANCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OUTSTANDING INTEREST', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('OUTSTANDING BALANCE', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PERFORMANCE INDICATOR', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;
}






