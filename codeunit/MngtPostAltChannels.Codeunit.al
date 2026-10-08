codeunit 50023 "Mngt. Post Alt. Channels"
{
    trigger OnRun()
    begin
    end;

    var
        AccountTypes: Record "Product Factory";
        GenJournalLine: Record "Gen. Journal Line";
        Temp: Record "Banking User Template";
        LoanGradMngt: Codeunit "Loan Graduation/Downgrade Mngt";
        Dim1: Code[10];
        Dim2: Code[10];
        JTemplate: Code[10];
        JBatch: Code[10];
        MTrans: Record "Mobile Loan Transaction";
        Loans: record Loans;
        NotifSource: Enum NotifSourceType;
        Member: Record Member;
        Comp: Record "Company Information";
        Gensetup: Record "General Set-Up";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        RegMngt: Codeunit "Register Management";
        LineNo: Integer;
        Source: Option "New Member","New Account","Loan Account Approval","Deposit Confirmation","Cash Withdrawal Confirm","Loan Application","Loan Appraisal","Loan Guarantors","Loan Rejected","Loan Posted","Loan defaulted","Salary Processing","Teller Cash Deposit"," Teller Cash Withdrawal","Teller Cheque Deposit","Fixed Deposit Maturity","InterAccount Transfer","Account Status","Status Order","EFT Effected"," ATM Application Failed","ATM Collection",MSACCO,"Member Changes","Cashier Below Limit","Cashier Above Limit",InternetBanking,CRM,"Loan Repayment",Bithday,"Balance Enquiry";
        Docs: Codeunit "SMS Notification";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        PostAs: Option "Post Amount","Post Less Charges";
        TransCharges: Record "Transaction Charge";
        ExciseDutyPerc: Decimal;
        ExciseDutyOnCharge: Decimal;
        ExciseDutyGL: Code[20];
        TempB2C: Code[20];
        TempBank2C: Code[20];
        TempC2C: Code[20];
        TempExtBank: Code[20];
        AltChannelMngt: Codeunit "Alt. Channel (Mobile Mngt.)";

    procedure fnInitialize()
    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty (%)");
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyPerc := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Default Bank C2B");
        Temp.TestField("Default Bank C2C");
        Temp.TestField("Bank C2B");
        Temp.TestField("Mobile Corporate A/c");
        Temp.TestField("Mobile Transaction In. A/c");
        Temp.TestField("Vendor Comms. %");
        Temp.TestField("Vendor Comms. A/c");
        Temp.TestField("Bank C2B");
        PostAs := Temp."Post As";
        TempBank2C := Temp."Bank C2B";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";
        TempExtBank := Temp."Bank C2B";

    end;

    procedure CreateMobileLines(ReceiptNo: Code[20]; Descript: Text[150]; VendorNo: Code[100]; AmtPost: Decimal; TransactionType: Integer; Posted: Boolean)
    begin


    end;

    Procedure MarkAsDocPosted(ReceiptNo: Code[20]; Posted: Text[100])
    Var
        altchnmgt: Record "ATM Transaction";
    begin
        altchnmgt.Reset();
        altchnmgt.SetRange("Trace ID", ReceiptNo);
        IF altchnmgt.FindFirst() then begin
            altchnmgt.Posted := true;
            altchnmgt."Posted By" := UserId;
            altchnmgt."Posting Date" := Today;
            altchnmgt.Modify(true);
        end;
    end;

    procedure PerformPostBalanceEnquiryTxt(ReceiptNo: Code[20]) Response: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
    begin
        Comp.GET();
        Gensetup.GET();
        Gensetup.TESTFIELD(Gensetup."Excise Duty (%)");
        Gensetup.TESTFIELD(Gensetup."Excise Duty G/L");

        Temp.GET(USERID);
        Temp.TESTFIELD("Periodic Journal Template");
        Temp.TESTFIELD("Periodic Journal Batch");
        Temp.TESTFIELD("Shortcut Dimension 1 Code");
        Temp.TESTFIELD("Shortcut Dimension 2 Code");
        Temp.TESTFIELD("Default  Bank");

        JTemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := FALSE;

        UnclearedEffects.RESET;
        UnclearedEffects.SETFILTER(Amount, '>0');
        UnclearedEffects.SETRANGE(Posted, FALSE);
        UnclearedEffects.SETRANGE("Transaction Type", UnclearedEffects."Transaction Type"::"Balance Enquiry");
        UnclearedEffects.SETRANGE("Trace ID", ReceiptNo);
        IF UnclearedEffects.FINDFIRST THEN BEGIN

            TellerTill.RESET;
            TellerTill.SETRANGE("No.", Temp."Default  Bank");
            IF TellerTill.FIND('-') THEN BEGIN
                TellerTill.CALCFIELDS(TellerTill.Balance);

                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");

                IF Continue THEN BEGIN
                    Response := '0 | Entry already exists-' + UnclearedEffects."Trace ID";
                    EXIT(Response);
                END;

                IF UnclearedEffects.Amount > TellerTill."Min. Balance" THEN BEGIN
                    Response := '0 | Low Till balance';
                    EXIT(Response);
                END;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

                Account.RESET;
                Account.SETRANGE("No.", UnclearedEffects."Account No");
                Account.SETRANGE(Blocked, Account.Blocked::" ");
                IF Account.FIND('-') THEN BEGIN

                    TellerMngt.fnPostAccTransferCharges(UnclearedEffects."Transaction Charge Code",
                    Account."No.", UnclearedEffects.Amount, Dim1, Dim2, JTemplate, JBatch,
                    UnclearedEffects."Trace ID", UnclearedEffects."Transaction Date");

                    JnlPostMngt.CompletePosting(JTemplate, JBatch);

                    UnclearedEffects.Posted := TRUE;
                    UnclearedEffects.MODIFY(TRUE);
                    UnclearedEffects."Customer Names" := Account.Name;
                    UnclearedEffects."Posting Date" := Today;
                    UnclearedEffects."Posted By" := USERID;
                    ReturnedVal := 0;
                    ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                    Response := '1 |' + DELCHR(FORMAT(ReturnedVal), '=', ';');

                    IF UnclearedEffects."Transaction Type" = UnclearedEffects."Transaction Type"::"Balance Enquiry" THEN BEGIN
                        Docs.CreateSmsNotif(NotifSource::"Balance Enquiry", Account."Mobile No.",
                        'You have done a balance Enquiry on your account.' + 'Date: ' +
                        FORMAT(TODAY) + 'Time: ' + FORMAT(TIME) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);

                    END ELSE BEGIN
                        Docs.CreateSmsNotif(NotifSource::"Balance Enquiry", Account."Mobile No.",
                        'You have done a balance Enquiry on your account.' + 'Date: ' +
                        FORMAT(TODAY) + 'Time: ' + FORMAT(TIME) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                    END;
                END ELSE BEGIN
                    Response := '0 | Failed. Account Blocked/Not found'
                END;
            END
        END
    end;

    procedure PostAccountDepositSaccoLink(ReceiptNo: Code[20]) ReturnstringTxt: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        MobileTrans: Record "ATM Transaction";
        FosaAcc: Record "Account Banking";
        BalanceLCY: Decimal;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        BosaAcc: Record "Account Credit";
        MobilePhone: Code[20];
        AccountNo: Code[100];
    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty (%)");
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyPerc := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Coop Clearing Bank");

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        Continue := false;
        MobilePhone := '';
        BalanceLCY := 0;
        AccountNo := '';

        Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");
        IF Continue then begin
            ReturnstringTxt := '99|Entry already exists' + UnclearedEffects."Trace ID";
            EXIT(ReturnstringTxt);
        end;
        JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

        MobileTrans.Reset();
        MobileTrans.SetRange(Posted, false);
        MobileTrans.SetRange("Trace ID", ReceiptNo);
        IF MobileTrans.FindFirst() then begin

            Account.Reset();
            Account.SetRange("No.", MobileTrans."Account No");
            Account.SetRange(Blocked, Account.Blocked::" ");
            if Account.Find('-') then begin

                Account.CalcFields("Balance (LCY)");

                MobilePhone := Account."Mobile No.";
                AccountNo := Account."No.";

                LineNo := LineNo + 10000;
                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                    JTemplate, JBatch, MobileTrans."Document No.", '',
                    MobileTrans."Transaction Date", Dim1, Dim2);
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.Validate("Account No.", Account."No.");
                GenJournalLine."Document No." := MobileTrans."Document No.";
                GenJournalLine."External Document No." := MobileTrans."Trace ID";
                GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                GenJournalLine.Validate(GenJournalLine.Amount, MobileTrans.Amount * -1);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.Validate("Bal. Account No.", Temp."Coop Clearing Bank");
                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                JnlPostMngt.CompletePosting(JTemplate, JBatch);

                Commit();
                MobileTrans.Posted := true;
                MobileTrans."Posting Date" := Today;
                MobileTrans."Posted By" := UserId;
                MobileTrans.Modify(true);
                /* Docs.CreateSmsNotif(NotifSource::"Deposit Confirmation", MobilePhone,
                'You have done a deposit transaction of Kshs. '
                + Format(MobileTrans.Amount) + ' on ' + Format(Today) + ' '
                + Format(Time) + ' to your Account at ' + Comp.Name,
                AccountNo, MobileTrans."Trace ID", false); */
                BalanceLCY := 0;
                BalanceLCY := TellPostMngt.CalcAvailableBal(Account."No.");
                ReturnstringTxt := '00|Success|' + Format(BalanceLCY, 0, '<Precision,2:2><Standard Format,2>');

            end else begin
                ReturnstringTxt := '99|Account Not Found';
            end;

        end else begin
            ReturnstringTxt := '99|Invalid string';
        end;
    end;

    procedure PostAccountDeposits(ReceiptNo: Code[20]) ReturnstringTxt: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        MobileTrans: Record "ATM Transaction";
        FosaAcc: Record "Account Banking";
        BalanceLCY: Decimal;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        BosaAcc: Record "Account Credit";
        MobilePhone: Code[20];
        AccountNo: Code[100];
        RunBal: array[7] of Decimal;
        CredAccount: Record "Account Credit";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty (%)");
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyPerc := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Default Bank C2B");
        Temp.TestField("Default Bank C2C");
        Temp.TestField("Mobile Corporate A/c");
        Temp.TestField("Mobile Transaction In. A/c");
        Temp.TestField("Vendor Comms. %");
        Temp.TestField("Vendor Comms. A/c");

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        Continue := false;
        MobilePhone := '';
        BalanceLCY := 0;
        AccountNo := '';

        Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");
        IF Continue then begin
            ReturnstringTxt := '99|Entry already exists' + UnclearedEffects."Trace ID";
            EXIT(ReturnstringTxt);
        end;
        JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

        MobileTrans.Reset();
        MobileTrans.SetRange(Posted, false);
        MobileTrans.SetFilter(Amount, '>0');
        MobileTrans.SetRange("Trace ID", ReceiptNo);
        IF MobileTrans.FindFirst() then begin
            RunBal[1] := 0;
            RunBal[1] := MobileTrans.Amount;

            Account.Reset();
            Account.SetRange("No.", MobileTrans."Account No");
            Account.SetRange(Blocked, Account.Blocked::" ");
            if Account.Find('-') then begin

                Account.CalcFields("Balance (LCY)");
                BalanceLCY := TellerMngt.CalcAvailableBal(Account."No.");
                MobilePhone := Account."Mobile No.";
                AccountNo := Account."No.";

                CredAccount.Reset();
                CredAccount.SetRange("Member No.", Account."Member No.");
                CredAccount.SetRange(Blocked, CredAccount.Blocked::" ");
                CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Registration Fee");
                if CredAccount.FindFirst() then begin
                    if not CredAccount."Registration Fee Paid" then begin
                        if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") > 0 then begin

                            LineNo := LineNo + 10000;
                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, MobileTrans."Trace ID", '',
                                MobileTrans."Transaction Date", Dim1, Dim2);
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine.Validate("Account No.", CredAccount."No.");
                            GenJournalLine."Document No." := MobileTrans."Trace ID";
                            GenJournalLine."External Document No." := CredAccount."ID/Passport No.";
                            GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                            if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") >= RunBal[1] then
                                GenJournalLine.Validate(GenJournalLine.Amount, RunBal[1] * -1) else
                                GenJournalLine.Validate(GenJournalLine.Amount, PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") * -1);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                            GenJournalLine.Validate("Bal. Account No.", Temp."Default Bank C2B");
                            GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                            RunBal[1] := (RunBal[1] - Abs(GenJournalLine.Amount));
                        end;
                    end;
                end;

                if RunBal[1] > 0 then begin
                    CredAccount.Reset();
                    CredAccount.SetRange("Member No.", Account."Member No.");
                    CredAccount.SetRange(Blocked, CredAccount.Blocked::" ");
                    CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Capital");
                    if CredAccount.FindFirst() then begin

                        if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") > 0 then begin

                            LineNo := LineNo + 10000;
                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, MobileTrans."Trace ID", '',
                                MobileTrans."Transaction Date", Dim1, Dim2);
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine.Validate("Account No.", CredAccount."No.");
                            GenJournalLine."Document No." := MobileTrans."Trace ID";
                            GenJournalLine."External Document No." := CredAccount."ID/Passport No.";
                            GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                            if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") >= RunBal[1] then
                                GenJournalLine.Validate(GenJournalLine.Amount, RunBal[1] * -1) else
                                GenJournalLine.Validate(GenJournalLine.Amount, PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") * -1);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                            GenJournalLine.Validate("Bal. Account No.", Temp."Default Bank C2B");
                            GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                            RunBal[1] := (RunBal[1] - Abs(GenJournalLine.Amount));
                        end;
                    end;
                end;

                if RunBal[1] > 0 then begin

                    LineNo := LineNo + 10000;
                    TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Trace ID", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.Validate("Account No.", Account."No.");
                    GenJournalLine."Document No." := MobileTrans."Trace ID";
                    GenJournalLine."External Document No." := Account."ID/Passport No.";
                    GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                    GenJournalLine.Validate(GenJournalLine.Amount, RunBal[1] * -1);
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                    GenJournalLine.Validate("Bal. Account No.", Temp."Default Bank C2B");
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                end;

            end else begin

                BosaAcc.Reset();
                BosaAcc.SetRange("No.", MobileTrans."Account No");
                BosaAcc.SetRange(Blocked, BosaAcc.Blocked::" ");
                if BosaAcc.Find('-') then begin
                    BosaAcc.CalcFields("Balance (LCY)");
                    BalanceLCY := BosaAcc."Balance (LCY)";
                    MobilePhone := BosaAcc."Mobile No.";
                    AccountNo := BosaAcc."No.";

                    CredAccount.Reset();
                    CredAccount.SetRange("Member No.", BosaAcc."Member No.");
                    CredAccount.SetRange(Blocked, CredAccount.Blocked::" ");
                    CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Registration Fee");
                    if CredAccount.FindFirst() then begin
                        if not CredAccount."Registration Fee Paid" then begin
                            if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") > 0 then begin

                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                    JTemplate, JBatch, MobileTrans."Trace ID", '',
                                    MobileTrans."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                GenJournalLine.Validate("Account No.", CredAccount."No.");
                                GenJournalLine."Document No." := MobileTrans."Trace ID";
                                GenJournalLine."External Document No." := CredAccount."ID/Passport No.";
                                GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                                if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") >= RunBal[1] then
                                    GenJournalLine.Validate(GenJournalLine.Amount, RunBal[1] * -1) else
                                    GenJournalLine.Validate(GenJournalLine.Amount, PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") * -1);
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                                GenJournalLine.Validate("Bal. Account No.", Temp."Default Bank C2B");
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);
                                RunBal[1] := (RunBal[1] - Abs(GenJournalLine.Amount));
                            end;
                        end;
                    end;

                    if RunBal[1] > 0 then begin

                        CredAccount.Reset();
                        CredAccount.SetRange("Member No.", BosaAcc."Member No.");
                        CredAccount.SetRange(Blocked, CredAccount.Blocked::" ");
                        CredAccount.SetRange("Account Category", CredAccount."Account Category"::"Shares Capital");
                        if CredAccount.FindFirst() then begin

                            if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") > 0 then begin

                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                    JTemplate, JBatch, MobileTrans."Trace ID", '',
                                    MobileTrans."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                GenJournalLine.Validate("Account No.", CredAccount."No.");
                                GenJournalLine."Document No." := MobileTrans."Trace ID";
                                GenJournalLine."External Document No." := CredAccount."ID/Passport No.";
                                GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                                if PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") >= RunBal[1] then
                                    GenJournalLine.Validate(GenJournalLine.Amount, RunBal[1] * -1) else
                                    GenJournalLine.Validate(GenJournalLine.Amount, PeriodicMngt.getAccountMinBalance(CredAccount."Member No.", CredAccount."Product Type") * -1);
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                                GenJournalLine.Validate("Bal. Account No.", Temp."Default Bank C2B");
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);
                                RunBal[1] := (RunBal[1] - Abs(GenJournalLine.Amount));
                            end;
                        end;
                    end;

                    if RunBal[1] > 0 then begin
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Trace ID", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine.Validate("Account No.", BosaAcc."No.");
                        GenJournalLine."Document No." := MobileTrans."Trace ID";
                        GenJournalLine."External Document No." := BosaAcc."ID/Passport No.";
                        GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                        GenJournalLine.Validate(GenJournalLine.Amount, RunBal[1] * -1);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                        GenJournalLine.Validate("Bal. Account No.", Temp."Default Bank C2B");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end else begin
                    ReturnstringTxt := '99|Account Not Found';
                end;
            end;

            JnlPostMngt.CompletePosting(JTemplate, JBatch);

            Commit();
            MobileTrans.Posted := true;
            MobileTrans."Posting Date" := Today;
            MobileTrans.Modify(true);
            Docs.CreateSmsNotif(NotifSource::"Deposit Confirmation", MobilePhone,
            'You have done a deposit transaction of Kshs. '
            + Format(MobileTrans.Amount) + ' on ' + Format(Today) + ' '
            + Format(Time) + ' to your Account at ' + Comp.Name,
            AccountNo, MobileTrans."Trace ID", false);

            ReturnstringTxt := '00|' + 'Success' + '|' + Format(BalanceLCY);

        end else begin
            ReturnstringTxt := '99|Invalid string';
        end;
    end;

    procedure PostBnkIntConfiguration(ReceiptNo: Code[20]) ReturnstringTxt: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        FosaAcc: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        MobileTrans: Record "ATM Transaction";
        Loans: Record Loans;
        RunBal: Decimal;
        PFact: Record "Product Factory";
        BosaAcc: Record "Account Credit";
        CredAcc: Record "Account Credit";
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        PostedLn: Record Loans;
        BalanceLCY: Decimal;
        JuniorAcc: Code[20];
    begin


        Gensetup.GET();
        Gensetup.TESTFIELD(Gensetup."Excise Duty (%)");
        Gensetup.TESTFIELD(Gensetup."Excise Duty G/L");

        Temp.GET(USERID);
        Temp.TESTFIELD("Alt. Journal Template");
        Temp.TESTFIELD("Alt. Journal Batch");
        Temp.TESTFIELD("Shortcut Dimension 1 Code");
        Temp.TESTFIELD("Shortcut Dimension 2 Code");
        Temp.TESTFIELD("Bank C2B");

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";
        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");
        IF Continue then begin
            ReturnstringTxt := '99|Entry already exists' + UnclearedEffects."Trace ID";
            exit(ReturnstringTxt);
        end;
        JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

        MobileTrans.Reset();
        MobileTrans.SetRange(Posted, false);
        MobileTrans.SetRange("Trace ID", ReceiptNo);
        IF MobileTrans.FindFirst() then begin

            RunBal := 0;
            RunBal := MobileTrans.Amount;

            Loans.Reset();
            Loans.SetRange("No.", MobileTrans."Account No");
            Loans.SetFilter("Outstanding Balance", '>0');
            if Loans.FindFirst() then begin
                Loans.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal", "Outstanding Bill");
                if Loans."Outstanding Interest" > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Trace ID", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine.Validate("Account No.", Loans."Loan Account");
                        GenJournalLine."Document No." := MobileTrans."Trace ID";
                        GenJournalLine."External Document No." := Account."ID/Passport No.";
                        GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                        if Loans."Outstanding Interest" > RunBal then
                            GenJournalLine.Validate(GenJournalLine.Amount, RunBal * -1) else
                            GenJournalLine.Validate(GenJournalLine.Amount, Loans."Outstanding Interest" * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - Abs(GenJournalLine.Amount);
                    end;
                end;

                if Loans."Outstanding Bill" > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Trace ID", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine.Validate("Account No.", Loans."Loan Account");
                        GenJournalLine."Document No." := MobileTrans."Trace ID";
                        GenJournalLine."External Document No." := Account."ID/Passport No.";
                        GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                        if Loans."Outstanding Bill" > RunBal then
                            GenJournalLine.Validate(GenJournalLine.Amount, RunBal * -1) else
                            GenJournalLine.Validate(GenJournalLine.Amount, Loans."Outstanding Bill" * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - Abs(GenJournalLine.Amount)
                    end;
                end;

                if Loans."Outstanding Principal" > 0 then begin
                    if RunBal > 0 then begin

                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Trace ID", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine.Validate("Account No.", Loans."Loan Account");
                        GenJournalLine."Document No." := MobileTrans."Trace ID";
                        GenJournalLine."External Document No." := Account."ID/Passport No.";
                        GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                        if Loans."Outstanding Principal" > RunBal then
                            GenJournalLine.Validate(GenJournalLine.Amount, RunBal * -1) else
                            GenJournalLine.Validate(GenJournalLine.Amount, Loans."Outstanding Principal" * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - Abs(GenJournalLine.Amount)
                    end;
                end;
                if RunBal > 0 then begin

                    Account.Reset();
                    Account.SetRange("No.", Loans."Disbursement Account No.");
                    Account.SetRange(Blocked, Account.Blocked::" ");
                    if Account.FindFirst() then begin

                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Trace ID", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine.Validate("Account No.", Account."No.");
                        GenJournalLine."Document No." := MobileTrans."Trace ID";
                        GenJournalLine."External Document No." := Account."ID/Passport No.";
                        GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                        GenJournalLine.Validate(GenJournalLine.Amount, RunBal * -1);
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                    end;
                end;

                LineNo := LineNo + 10000;
                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                    JTemplate, JBatch, MobileTrans."Trace ID", '',
                    MobileTrans."Transaction Date", Dim1, Dim2);
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                GenJournalLine.Validate("Account No.", Temp."Bank C2B");
                GenJournalLine."Document No." := MobileTrans."Trace ID";
                GenJournalLine."External Document No." := Account."ID/Passport No.";
                GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                GenJournalLine.Validate(GenJournalLine.Amount, MobileTrans.Amount);
                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                JnlPostMngt.CompletePosting(JTemplate, JBatch);

                Commit();
                MobileTrans.Posted := true;
                MobileTrans."Posting Date" := Today;
                MobileTrans.Modify(true);
                if PostedLn.Get(Loans."No.") then
                    PostedLn.CalcFields("Outstanding Balance");
                ReturnstringTxt := '00|' + '|' + Format(PostedLn."Outstanding Balance", 0, '<Precision,2:2><Standard Format,2>');
            end else begin

                if (MobileTrans."Search Code" = 'FS') or (MobileTrans."Search Code" = 'JR') then begin
                    JuniorAcc := '';

                    PFact.Reset();
                    PFact.SetRange("Search Code", MobileTrans."Search Code");
                    if PFact.FindFirst() then begin

                        if PFact."Search Code" = 'JR' then begin
                            JuniorAcc := MobileTrans."Account No";
                        end;

                        Account.Reset();
                        Account.SetRange("No.", MobileTrans."Account No");
                        Account.SetRange(Blocked, Account.Blocked::" ");
                        if Account.FindFirst() then begin

                            LineNo := LineNo + 10000;
                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, MobileTrans."Trace ID", '',
                                MobileTrans."Transaction Date", Dim1, Dim2);
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine.Validate("Account No.", Account."No.");
                            GenJournalLine."Document No." := MobileTrans."Trace ID";
                            GenJournalLine."External Document No." := Account."ID/Passport No.";
                            GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                            GenJournalLine.Validate(GenJournalLine.Amount, MobileTrans.Amount * -1);
                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                            GenJournalLine.Validate("Bal. Account No.", Temp."Bank C2B");
                            GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                            GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                            JnlPostMngt.CompletePosting(JTemplate, JBatch);

                            Commit();
                            MobileTrans.Posted := true;
                            MobileTrans."Posting Date" := Today;
                            MobileTrans.Modify(true);
                            /* Docs.CreateSmsNotif(NotifSource::"Deposit Confirmation", Account."Mobile No.",
                            'You have done a deposit transaction of Kshs. '
                            + Format(MobileTrans.Amount) + ' on ' + Format(Today) + ' '
                            + Format(Time) + ' to your Account at ' + Comp.Name,
                            Account."No.", MobileTrans."Trace ID", false); */
                            BalanceLCY := 0;
                            BalanceLCY := TellerMngt.CalcAvailableBal(Account."No.");
                            ReturnstringTxt := '00|' + 'Transaction Successful' + '|' + Format(BalanceLCY, 0, '<Precision,2:2><Standard Format,2>');
                        end else begin
                            ReturnstringTxt := '99|Failed.Account not found';
                        end;
                    end;

                end else begin

                    if (MobileTrans."Search Code" = 'DP') or (MobileTrans."Search Code" = 'SC') then begin

                        PFact.Reset();
                        PFact.SetRange("Search Code", MobileTrans."Search Code");
                        if PFact.FindFirst() then begin

                            BosaAcc.Reset();
                            BosaAcc.SetRange("No.", MobileTrans."Account No");
                            BosaAcc.SetRange(Blocked, BosaAcc.Blocked::" ");
                            if BosaAcc.FindFirst() then begin

                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                    JTemplate, JBatch, MobileTrans."Trace ID", '',
                                    MobileTrans."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                GenJournalLine.Validate("Account No.", BosaAcc."No.");
                                GenJournalLine."Document No." := MobileTrans."Trace ID";
                                GenJournalLine."External Document No." := BosaAcc."ID/Passport No.";
                                GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                                GenJournalLine.Validate(GenJournalLine.Amount, MobileTrans.Amount * -1);
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                                GenJournalLine.Validate("Bal. Account No.", Temp."Bank C2B");
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);
                                JnlPostMngt.CompletePosting(JTemplate, JBatch);

                                Commit();
                                MobileTrans.Posted := true;
                                MobileTrans."Posting Date" := Today;
                                MobileTrans.Modify(true);
                                Docs.CreateSmsNotif(NotifSource::"Deposit Confirmation", BosaAcc."Mobile No.",
                                'You have done a deposit transaction of Kshs. '
                                + Format(MobileTrans.Amount) + ' on ' + Format(Today) + ' '
                                + Format(Time) + ' to your Account at ' + Comp.Name,
                                BosaAcc."No.", MobileTrans."Trace ID", false);
                                if CredAcc.Get(BosaAcc."No.") then
                                    CredAcc.CalcFields("Balance (LCY)");
                                ReturnstringTxt := '00|' + 'success' + '|' + Format(CredAcc."Balance (LCY)", 0, '<Precision,2:2><Standard Format,2>');
                            end else begin
                                ReturnstringTxt := '99|Failed.Account not found';
                            end;
                        end;
                    end else begin
                        ReturnstringTxt := '99|Failed.Search Code not found';

                    end;
                end;
            end;

        end else begin
            ReturnstringTxt := '99|Invalid string';
        end;
    end;

    procedure PostCustSharesDeposits(ReceiptNo: Code[20]) ReturnstringTxt: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        MobileTrans: Record "Mobile Money Transaction";
        CustAccount: Record "Account Credit";
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
    begin
        Temp.GET(USERID);
        Temp.TESTFIELD("Alt. Journal Template");
        Temp.TESTFIELD("Alt. Journal Batch");
        Temp.TESTFIELD("Shortcut Dimension 1 Code");
        Temp.TESTFIELD("Shortcut Dimension 2 Code");
        Temp.TESTFIELD("Default Bank C2B");

        JTemplate := Temp."Periodic Journal Template";
        JBatch := Temp."Periodic Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");
        IF Continue then begin
            ReturnstringTxt := '0 | Entry already exists-' + UnclearedEffects."Trace ID";
            EXIT(ReturnstringTxt);
        end;
        JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

        MobileTrans.RESET;
        MobileTrans.SETRANGE(MobileTrans.Posted, FALSE);
        MobileTrans.SETRANGE(MobileTrans."Document No.", ReceiptNo);
        IF MobileTrans.FindFirst() then begin

            CustAccount.RESET;
            CustAccount.SETRANGE("No.", MobileTrans."Account No.");
            CustAccount.SETRANGE(Blocked, CustAccount.Blocked::" ");
            IF CustAccount.FIND('-') then begin
                LineNo := LineNo + 10000;
                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                    JTemplate, JBatch, MobileTrans."Document No.", '',
                    MobileTrans."Transaction Date", Dim1, Dim2);

                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                GenJournalLine.VALIDATE(GenJournalLine."Account No.", CustAccount."No.");
                GenJournalLine."External Document No." := CustAccount."ID/Passport No.";
                GenJournalLine.Description := COPYSTR(MobileTrans.Description, 1, 50);
                GenJournalLine.VALIDATE(GenJournalLine.Amount, MobileTrans.Amount * -1);
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.validate("Bal. Account No.", Temp."Mobile B2C A/c");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                JnlPostMngt.CompletePosting(JTemplate, JBatch);
                ReturnstringTxt := '99|Success';
                COMMIT;
                MobileTrans.Posted := TRUE;
                MobileTrans."Date Posted" := TODAY;
                MobileTrans."Time Posted" := TIME;
                MobileTrans.Message := 'Posted successfully';
                MobileTrans.Modify(true);

                Docs.CreateSmsNotif(NotifSource::"Deposit Confirmation", CustAccount."Mobile No.",
                'You have done a ' + CustAccount."Product Name" + ' transaction of Kshs. '
                + FORMAT(MobileTrans.Amount) + ' on ' + FORMAT(TODAY) + ' '
                + FORMAT(TIME) + ' to your Account at ' + Comp.Name,
                CustAccount."No.", MobileTrans."Document No.", false);
            END ELSE BEGIN
                ReturnstringTxt := '0|Failed.Account not found';
            END
        END ELSE BEGIN
            ReturnstringTxt := '0|Invalid String';
        end;
    end;

    procedure PostLnRepaymentBankTxt(DocumentNo: Code[20]) Responce: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        MobileTrans: Record "Mobile Loan Transaction";
        CustAccount: Record "Account Credit";
        GenBatch: Record "Gen. Journal Batch";
        RunBal: Decimal;
        Vend: Record "Account Banking";
        Acc: Record "Account Banking";
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        AccruedInt: Decimal;
        EndDate: Date;
        StartDate: Date;
        IntDays: Integer;
        Member: Record Member;
        PFact: Record "Product Factory";
        RegMngt: Codeunit "Register Management";
        QCdirection: Enum QCQualificationDirection;
        CustRecord: Record Member;
        QcQualifyAmt: Record "QC. Grad. Qualification";
        QcQualifyMngt: Record "QC. Grad. Qualification";
        RegistryMngt: Codeunit "Registry Mngt.";
        AccCred: Record "Account Credit";
        QCLoanMgt: Codeunit "Loan Graduation/Downgrade Mngt";
        LoanType: Record "Product Factory";


    begin
        fnInitialize();

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        MobileTrans.Reset();
        MobileTrans.SetRange(Posted, false);
        MobileTrans.SetRange("Document No.", DocumentNo);
        IF MobileTrans.FindFirst() then begin

            JnlPostMngt.ClearJournalLines(JTemplate, JBatch);
            Continue := RegMngt.TestNoEntriesExist(MobileTrans."Document No.");

            if Continue then begin
                Responce := '99|Entry already Posted' + MobileTrans."Document No.";
                exit(Responce);
            end;

            AccruedInt := 0;
            RunBal := 0;
            RunBal := MobileTrans.Amount;

            Vend.Reset();
            Vend.SetRange("Member No.", MobileTrans."Account No.");
            Vend.SetRange("Account Category", Vend."Account Category"::Savings);
            Vend.SetRange(Blocked, Vend.Blocked::" ");
            if Vend.FindFirst() then begin

                GenJournalLine.LockTable;
                LineNo := LineNo + 10000;
                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                JTemplate, JBatch, MobileTrans."Document No.", '',
                MobileTrans."Transaction Date", Dim1, Dim2);
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."External Document No." := Loans."No.";
                GenJournalLine.Validate(GenJournalLine."Account No.", Vend."No.");
                GenJournalLine.Validate(Amount, MobileTrans.Amount * -1);
                GenJournalLine.Description := MobileTrans.Description + '-' + MobileTrans."Loan No.";
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TempBank2C);
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                Loans.Reset();
                Loans.SetFilter("Outstanding Balance", '>0');
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Balance");
                    if PFact.Get(Loans."Product Type") then
                        EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;
                    if MobileTrans.Amount >= Loans."Outstanding Balance" then begin

                        if PFact."Loan Span" = PFact."Loan Span"::"Mobile Loan" then
                            AccruedInt := 0 else
                            AccruedInt := PeriodicMngt.fnIntEntriesonSpecificLoan(Loans, Today,
                              Loans."No.", 1, IntDays, StartDate);

                        if AccruedInt > 0 then begin

                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Document No.", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine."External Document No." := Loans."No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.", Loans."Loan Account");
                            GenJournalLine.Description := 'Interest Accrued-' + Loans."No.";
                            GenJournalLine.Validate(Amount, AccruedInt);
                            GenJournalLine.Validate("Bal. Account No.", PFact."Interest Account (G/L)");
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
                            GenJournalLine.Validate("Loan No.", Loans."No.");
                            GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);

                        end;

                    end else begin
                        AccruedInt := 0;
                    end;
                end;

                Loans.Reset();
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields(Loans."Outstanding Interest");
                    if (Loans."Outstanding Interest" + AccruedInt) > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Loans."Loan Account");
                        GenJournalLine.Description := 'Interest Payment-' + Loans."No.";
                        if RunBal > Loans."Outstanding Interest" then
                            GenJournalLine.Validate(Amount, (Loans."Outstanding Interest" + AccruedInt) * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Vend."No.");
                        GenJournalLine.Validate("Currency Code", '');
                        if RunBal > Loans."Outstanding Interest" then
                            GenJournalLine.Validate(Amount, (Loans."Outstanding Interest" + AccruedInt)) else
                            GenJournalLine.Validate(Amount, RunBal);
                        GenJournalLine.Description := 'Interest Payment-' + Loans."No.";
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - (GenJournalLine.Amount);
                    end;
                end;

                Loans.Reset();
                Loans.SetFilter("Outstanding Bill", '>0');
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Bill");

                    if RunBal > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Loans."Loan Account");
                        GenJournalLine.Description := 'Penalty Repayment-' + Loans."No.";
                        if RunBal > Loans."Outstanding Bill" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Bill" * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Vend."No.");
                        if RunBal > Loans."Outstanding Bill" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Bill") else
                            GenJournalLine.Validate(Amount, RunBal);
                        GenJournalLine.Description := 'Penalty Repayment-' + Loans."No.";
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - (GenJournalLine.Amount);
                    end;
                end;

                Loans.Reset();
                Loans.SetFilter("Outstanding Principal", '>0');
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Principal");

                    if RunBal > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.",
                        Loans."Loan Account");
                        GenJournalLine.Description := 'Principal Repayment-' + Loans."No.";
                        if RunBal > Loans."Outstanding Principal" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Principal" * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.",
                        Vend."No.");
                        if RunBal > Loans."Outstanding Principal" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Principal") else
                            GenJournalLine.Validate(Amount, RunBal);
                        GenJournalLine.Description := 'Principal Repayment-' + Loans."No.";
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - (GenJournalLine.Amount);
                    end;
                end;

                JnlPostMngt.CompletePosting(JTemplate, JBatch);

                Commit();
                MobileTrans.Posted := true;
                MobileTrans."Date Posted" := Today;
                MobileTrans."Time Posted" := Time;
                MobileTrans.Comments := 'Posted Successfully';
                MobileTrans.Status := MobileTrans.Status::Posted;
                MobileTrans.Modify(true);
                Loans.CalcFields("Outstanding Balance");

                IF Acc.Get(Loans."Disbursement Account No.") then begin
                    Docs.CreateSmsNotif(NotifSource::"Loan Posted", Acc."Mobile No.",
                        'Your Loan repayment of Kes ' + ' ' + Format(MobileTrans.Amount) +
                        '  has been successfully proccessed. Your loan balance is ' +
                            Format(Loans."Outstanding Balance"), Acc."No.",
                    Loans."No.", false);
                end;

                if Member.Get(Loans."Account No.") then begin

                    if QCLoanMgt.CheckLoanQualifiedRepayment(Loans."No.", Loans."Account No.", Loans."Product Type") then begin

                        QcQualifyMngt.LockTable();
                        LoanGradMngt.InitializeQcGradQualAmount(Member, QcQualifyMngt);

                        AccCred.Reset();
                        AccCred.SetRange("Member No.", Member."No.");
                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
                        if AccCred.FindFirst() then
                            QcQualifyMngt."Account No." := AccCred."No.";
                        QcQualifyMngt.Validate("Qualifying Amount", LoanGradMngt.fnGetGraduatedAmt(Loans."No.", Member."No.",
                                    Loans."Product Type", QCdirection::Graduate));

                        QcQualifyMngt."Product Type" := Loans."Product Type";
                        QcQualifyMngt."Loan No." := Loans."No.";
                        QcQualifyMngt."Qualifying Direction" := QcQualifyMngt."Qualifying Direction"::Graduate;
                        QcQualifyMngt.Insert(true);
                    end

                end;

                Responce := '00|' + Format(Loans."Outstanding Balance")
            end else begin
                Responce := '99|Account not found or Blocked for transacting'
            end;
        end else begin
            Responce := '99|Document No. not found'

        end;
    end;

    procedure PostLoanRepaymentTxt(DocumentNo: Code[20]) Responce: Text
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        MobileTrans: Record "Mobile Loan Transaction";
        CustAccount: Record "Account Credit";
        GenBatch: Record "Gen. Journal Batch";
        RunBal: Decimal;
        Vend: Record "Account Banking";
        Acc: Record "Account Banking";
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        AccruedInt: Decimal;
        EndDate: Date;
        StartDate: Date;
        IntDays: Integer;
        Member: Record Member;
        PFact: Record "Product Factory";
        RegMngt: Codeunit "Register Management";
        QCdirection: Enum QCQualificationDirection;
        CustRecord: Record Member;
        QcQualifyAmt: Record "QC. Grad. Qualification";
        QcQualifyMngt: Record "QC. Grad. Qualification";
        RegistryMngt: Codeunit "Registry Mngt.";
        AccCred: Record "Account Credit";
        QCLoanMgt: Codeunit "Loan Graduation/Downgrade Mngt";
        LoanType: Record "Product Factory";


    begin
        fnInitialize();

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";

        MobileTrans.Reset();
        MobileTrans.SetRange(Posted, false);
        MobileTrans.SetRange("Document No.", DocumentNo);
        IF MobileTrans.FindFirst() then begin

            JnlPostMngt.ClearJournalLines(JTemplate, JBatch);
            Continue := RegMngt.TestNoEntriesExist(MobileTrans."Document No.");

            if Continue then begin
                Responce := '99|Entry already Posted' + MobileTrans."Document No.";
                exit(Responce);
            end;

            AccruedInt := 0;
            RunBal := 0;
            RunBal := MobileTrans.Amount;

            Vend.Reset();
            Vend.SetRange("Member No.", MobileTrans."Account No.");
            Vend.SetRange("Account Category", Vend."Account Category"::Savings);
            Vend.SetRange(Blocked, Vend.Blocked::" ");
            if Vend.FindFirst() then begin

                GenJournalLine.LockTable;
                LineNo := LineNo + 10000;
                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                JTemplate, JBatch, MobileTrans."Document No.", '',
                MobileTrans."Transaction Date", Dim1, Dim2);
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine."External Document No." := Loans."No.";
                GenJournalLine.Validate(GenJournalLine."Account No.", Vend."No.");
                GenJournalLine.Validate(Amount, MobileTrans.Amount * -1);
                GenJournalLine.Description := MobileTrans.Description + '-' + MobileTrans."Loan No.";
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                case MobileTrans."Application Source" of
                    MobileTrans."Application Source"::Mobile:
                        begin
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TempB2C)
                        end;
                    MobileTrans."Application Source"::"External Bank":
                        begin
                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TempExtBank)
                        end;
                end;
                if GenJournalLine.Amount <> 0 then
                    GenJournalLine.Insert(true);

                Loans.Reset();
                Loans.SetFilter("Outstanding Balance", '>0');
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Balance");
                    if PFact.Get(Loans."Product Type") then
                        EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;
                    if MobileTrans.Amount >= Loans."Outstanding Balance" then begin

                        if PFact."Loan Span" = PFact."Loan Span"::"Mobile Loan" then
                            AccruedInt := 0 else
                            AccruedInt := PeriodicMngt.fnIntEntriesonSpecificLoan(Loans, Today,
                              Loans."No.", 1, IntDays, StartDate);

                        if AccruedInt > 0 then begin

                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, MobileTrans."Document No.", '',
                            MobileTrans."Transaction Date", Dim1, Dim2);
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                            GenJournalLine."External Document No." := Loans."No.";
                            GenJournalLine.Validate(GenJournalLine."Account No.", Loans."Loan Account");
                            GenJournalLine.Description := 'Interest Accrued-' + Loans."No.";
                            GenJournalLine.Validate(Amount, AccruedInt);
                            GenJournalLine.Validate("Bal. Account No.", PFact."Interest Account (G/L)");
                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
                            GenJournalLine.Validate("Loan No.", Loans."No.");
                            GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                            GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);

                        end;

                    end else begin
                        AccruedInt := 0;
                    end;
                end;

                Loans.Reset();
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields(Loans."Outstanding Interest");
                    if (Loans."Outstanding Interest" + AccruedInt) > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Loans."Loan Account");
                        GenJournalLine.Description := 'Interest Payment-' + Loans."No.";
                        if RunBal > Loans."Outstanding Interest" then
                            GenJournalLine.Validate(Amount, (Loans."Outstanding Interest" + AccruedInt) * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Vend."No.");
                        GenJournalLine.Validate("Currency Code", '');
                        if RunBal > Loans."Outstanding Interest" then
                            GenJournalLine.Validate(Amount, (Loans."Outstanding Interest" + AccruedInt)) else
                            GenJournalLine.Validate(Amount, RunBal);
                        GenJournalLine.Description := 'Interest Payment-' + Loans."No.";
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - (GenJournalLine.Amount);
                    end;
                end;

                Loans.Reset();
                Loans.SetFilter("Outstanding Bill", '>0');
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Bill");

                    if RunBal > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Loans."Loan Account");
                        GenJournalLine.Description := 'Penalty Repayment-' + Loans."No.";
                        if RunBal > Loans."Outstanding Bill" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Bill" * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.", Vend."No.");
                        if RunBal > Loans."Outstanding Bill" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Bill") else
                            GenJournalLine.Validate(Amount, RunBal);
                        GenJournalLine.Description := 'Penalty Repayment-' + Loans."No.";
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - (GenJournalLine.Amount);
                    end;
                end;

                Loans.Reset();
                Loans.SetFilter("Outstanding Principal", '>0');
                Loans.SetRange("No.", MobileTrans."Loan No.");
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Principal");

                    if RunBal > 0 then begin

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.",
                        Loans."Loan Account");
                        GenJournalLine.Description := 'Principal Repayment-' + Loans."No.";
                        if RunBal > Loans."Outstanding Principal" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Principal" * -1) else
                            GenJournalLine.Validate(Amount, RunBal * -1);
                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine.Validate("Loan No.", Loans."No.");
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);

                        GenJournalLine.LockTable;
                        LineNo := LineNo + 10000;
                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                        JTemplate, JBatch, MobileTrans."Document No.", '',
                        MobileTrans."Transaction Date", Dim1, Dim2);
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                        GenJournalLine."External Document No." := Loans."No.";
                        GenJournalLine.Validate(GenJournalLine."Account No.",
                        Vend."No.");
                        if RunBal > Loans."Outstanding Principal" then
                            GenJournalLine.Validate(Amount, Loans."Outstanding Principal") else
                            GenJournalLine.Validate(Amount, RunBal);
                        GenJournalLine.Description := 'Principal Repayment-' + Loans."No.";
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert(true);
                        RunBal := RunBal - (GenJournalLine.Amount);
                    end;
                end;

                JnlPostMngt.CompletePosting(JTemplate, JBatch);

                Commit();
                MobileTrans.Posted := true;
                MobileTrans."Date Posted" := Today;
                MobileTrans."Time Posted" := Time;
                MobileTrans.Comments := 'Posted Successfully';
                MobileTrans.Status := MobileTrans.Status::Posted;
                MobileTrans.Modify(true);
                Loans.CalcFields("Outstanding Balance");

                IF Acc.Get(Loans."Disbursement Account No.") then begin
                    Docs.CreateSmsNotif(NotifSource::"Loan Posted", Acc."Mobile No.",
                        'Your Loan repayment of Kes ' + ' ' + Format(MobileTrans.Amount) +
                        '  has been successfully proccessed. Your loan balance is ' +
                            Format(Loans."Outstanding Balance"), Acc."No.",
                    Loans."No.", false);
                end;

                if Member.Get(Loans."Account No.") then begin

                    if QCLoanMgt.CheckLoanQualifiedRepayment(Loans."No.", Loans."Account No.", Loans."Product Type") then begin

                        QcQualifyMngt.LockTable();
                        LoanGradMngt.InitializeQcGradQualAmount(Member, QcQualifyMngt);

                        AccCred.Reset();
                        AccCred.SetRange("Member No.", Member."No.");
                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
                        if AccCred.FindFirst() then
                            QcQualifyMngt."Account No." := AccCred."No.";
                        QcQualifyMngt.Validate("Qualifying Amount", LoanGradMngt.fnGetGraduatedAmt(Loans."No.", Member."No.",
                                    Loans."Product Type", QCdirection::Graduate));

                        QcQualifyMngt."Product Type" := Loans."Product Type";
                        QcQualifyMngt."Loan No." := Loans."No.";
                        QcQualifyMngt."Qualifying Direction" := QcQualifyMngt."Qualifying Direction"::Graduate;
                        QcQualifyMngt.Insert(true);
                    end

                end;

                Responce := '00|' + Format(Loans."Outstanding Balance")
            end else begin
                Responce := '99|Account not found or Blocked for transacting'
            end;
        end else begin
            Responce := '99|Document No. not found'

        end;
    end;

    procedure PerformPostOnBillUtility(ReceiptNo: Code[20]) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyOnCharge := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Default Bank C2B");
        Temp.TestField("Default Bank C2C");
        Temp.TestField("Mobile Corporate A/c");
        Temp.TestField("Mobile Transaction In. A/c");
        Temp.TestField("Vendor Comms. %");
        Temp.TestField("Vendor Comms. A/c");
        Temp.TestField("Utilities Account");

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);
        if UnclearedEffects.FindFirst() then begin

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Default Bank C2B");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);

                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Trace ID";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    if UnclearedEffects.Amount > 0 then begin

                        case UnclearedEffects."Transaction Type" of
                            UnclearedEffects."Transaction Type"::Airtime,
                            UnclearedEffects."Transaction Type"::Bill:
                                begin

                                    GenJournalLine.LockTable;
                                    LineNo := LineNo + 10000;
                                    TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                    JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                    UnclearedEffects."Transaction Date", Dim1, Dim2);
                                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                    GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                    GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                    GenJournalLine.Validate(Amount, UnclearedEffects.Amount);
                                    GenJournalLine.Description := UnclearedEffects.Description;
                                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.", Temp."Utilities Account");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert(true);
                                end;
                        end;

                        case UnclearedEffects."Transaction Type Charges" of
                            UnclearedEffects."Transaction Type Charges"::"Mini Statement":
                                PostAs := PostAs::"Post Less Charges" else
                                                                          PostAs := PostAs::"Post Amount"
                        end;

                        if UnclearedEffects."Charge Code" <> '' then begin
                            case PostAs of
                                PostAs::"Post Amount":
                                    begin

                                        TransCharges.Reset();
                                        TransCharges.SetRange("Transaction Type", UnclearedEffects."Charge Code");
                                        if TransCharges.FindFirst() then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                            GenJournalLine.Validate(Amount, UnclearedEffects."Charge Amount");
                                            GenJournalLine.Description := TransCharges.Description;
                                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TransCharges."G/L Account");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                            GenJournalLine.Validate(Amount, UnclearedEffects."Charge Amount" * (ExciseDutyOnCharge / 100));
                                            GenJournalLine.Description := CopyStr('Excise Duty on-' + TransCharges.Description, 1, 100);
                                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.", ExciseDutyGL);
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                        end;
                                    end;
                                PostAs::"Post Less Charges":
                                    begin
                                        TellerMngt.fnPostAccCharges(UnclearedEffects."Charge Code",
                                            Account."No.", UnclearedEffects."Charge Amount", Dim1, Dim2, JTemplate, JBatch,
                                            UnclearedEffects."Trace ID", UnclearedEffects."Transaction Date");
                                    end;
                            end;
                        end;
                        JnlPostMngt.CompletePosting(JTemplate, JBatch);
                        Commit();
                        UnclearedEffects.Posted := true;
                        UnclearedEffects."Customer Names" := Account.Name;
                        UnclearedEffects."Posting Date" := Today;
                        UnclearedEffects."Posted By" := UserId;
                        UnclearedEffects.Modify(true);
                        ReturnedVal := 0;
                        ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                        Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');
                    end else begin

                        Commit();
                        UnclearedEffects.Posted := true;
                        UnclearedEffects."Customer Names" := Account.Name;
                        UnclearedEffects."Posting Date" := Today;
                        UnclearedEffects."Posted By" := UserId;
                        UnclearedEffects.Modify(true);
                        ReturnedVal := 0;
                        ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                        Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');
                    end;

                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Account found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;
    end;

    procedure PerformPostCashWithdrawalTxt(ReceiptNo: Code[20]) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty G/L");

        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyOnCharge := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("Default Bank C2B");
        Temp.TestField("Default Bank C2C");
        Temp.TestField("Mobile Corporate A/c");
        Temp.TestField("Mobile Transaction In. A/c");
        Temp.TestField("Vendor Comms. %");
        Temp.TestField("Vendor Comms. A/c");

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);
        if UnclearedEffects.FindFirst() then begin

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Default Bank C2B");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);

                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Trace ID";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    if UnclearedEffects.Amount > 0 then begin

                        case UnclearedEffects."Transaction Type" of
                            UnclearedEffects."Transaction Type"::Airtime,
                            UnclearedEffects."Transaction Type"::Bill:
                                begin

                                    GenJournalLine.LockTable;
                                    LineNo := LineNo + 10000;
                                    TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                    JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                    UnclearedEffects."Transaction Date", Dim1, Dim2);
                                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                    GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                    GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                    GenJournalLine.Validate(Amount, UnclearedEffects.Amount);
                                    GenJournalLine.Description := UnclearedEffects.Description;
                                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TellerTill."No.");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert(true);
                                end;
                        end;

                        case UnclearedEffects."Transaction Type Charges" of
                            UnclearedEffects."Transaction Type Charges"::"Mini Statement":
                                PostAs := PostAs::"Post Less Charges" else
                                                                          PostAs := PostAs::"Post Amount"
                        end;

                        if UnclearedEffects."Charge Code" <> '' then begin
                            case PostAs of
                                PostAs::"Post Amount":
                                    begin

                                        TransCharges.Reset();
                                        TransCharges.SetRange("Transaction Type", UnclearedEffects."Charge Code");
                                        if TransCharges.FindFirst() then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                            GenJournalLine.Validate(Amount, UnclearedEffects."Charge Amount");
                                            GenJournalLine.Description := TransCharges.Description;
                                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TransCharges."G/L Account");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                            GenJournalLine.Validate(Amount, UnclearedEffects."Charge Amount" * (ExciseDutyOnCharge / 100));
                                            GenJournalLine.Description := CopyStr('Excise Duty on-' + TransCharges.Description, 1, 100);
                                            GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                            GenJournalLine.Validate(GenJournalLine."Bal. Account No.", ExciseDutyGL);
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                        end;
                                    end;
                                PostAs::"Post Less Charges":
                                    begin
                                        TellerMngt.fnPostAccCharges(UnclearedEffects."Charge Code",
                                            Account."No.", UnclearedEffects."Charge Amount", Dim1, Dim2, JTemplate, JBatch,
                                            UnclearedEffects."Trace ID", UnclearedEffects."Transaction Date");
                                    end;
                            end;
                        end;
                        JnlPostMngt.CompletePosting(JTemplate, JBatch);
                        Commit();
                        UnclearedEffects.Posted := true;
                        UnclearedEffects."Customer Names" := Account.Name;
                        UnclearedEffects."Posting Date" := Today;
                        UnclearedEffects."Posted By" := UserId;
                        UnclearedEffects.Modify(true);
                        ReturnedVal := 0;
                        ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                        Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');
                    end else begin

                        Commit();
                        UnclearedEffects.Posted := true;
                        UnclearedEffects."Customer Names" := Account.Name;
                        UnclearedEffects."Posting Date" := Today;
                        UnclearedEffects."Posted By" := UserId;
                        UnclearedEffects.Modify(true);
                        ReturnedVal := 0;
                        ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                        Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');
                    end;

                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;
    end;

    procedure PerformPostATM(ReceiptNo: Code[20]) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        clearedEffects: Record "Link Transactions";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        AcctType: Enum "Gen. Journal Account Type";
        AppliesToDocNo: Code[20];
        DocType: Enum "Gen. Journal Document Type";
        LnTransType: Enum "LoanTransactionType";
        JournalDocType: Enum "Gen. Journal Document Type";

    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty (%)");
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyPerc := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("ATM Clearing Account Comms. %");
        Temp.TestField("ATM Fee. %");
        Temp.TestField("Coop Clearing Bank");

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetFilter(Amount, '>0');
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);
        UnclearedEffects.SetRange(Source, UnclearedEffects.Source::ATM);
        if UnclearedEffects.FindFirst() then begin

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Coop Clearing Bank");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);

                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Document No.");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Document No.";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);
                ChargeAmount := 0;

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    LineNo := LineNo + 10000;

                    JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::Vendor,
                    UnclearedEffects."Document No.", UnclearedEffects.Description,
                    UnclearedEffects.Amount, Account."No.", UnclearedEffects."Transaction Date",
                    AcctType::"Bank Account", TellerTill."No.", CopyStr(UnclearedEffects."Trace ID", 1, 20),
                    Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                    LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                    if UnclearedEffects."Charge Code" <> '' then begin

                        TransactionCharges.Reset();
                        TransactionCharges.SetRange("Transaction Type", UnclearedEffects."Charge Code");
                        if TransactionCharges.FindFirst() then begin

                            TransactionCharges.TestField("G/L Account");
                            TransactionCharges.TestField("ATM Clearing Account");
                            TransactionCharges.TestField("ATM Fee (Income)");

                            case TransactionCharges."Charge Type" of
                                TransactionCharges."Charge Type"::"Flat Amount":
                                    begin
                                        ChargeAmount := TransactionCharges."Charge Amount"

                                    end;
                                TransactionCharges."Charge Type"::"% of Amount":
                                    begin
                                        TransactionCharges.TestField("Percentage of Amount");
                                        ChargeAmount := UnclearedEffects."Charge Amount" * (TransactionCharges."Percentage of Amount" / 100)

                                    end;
                                TransactionCharges."Charge Type"::Staggered:
                                    begin

                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if (UnclearedEffects.Amount >= TariffDetails."Lower Limit") and (UnclearedEffects.Amount <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin
                                                        ChargeAmount := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);
                                                    end else begin
                                                        ChargeAmount := TariffDetails."Charge Amount";
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end;

                                    end;
                            end;

                            LineNo := LineNo + 10000;

                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::Vendor,
                            UnclearedEffects."Document No.", TransactionCharges.Description,
                            ChargeAmount, Account."No.", UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                            LineNo := LineNo + 10000;

                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, TransactionCharges."Account Type",
                            UnclearedEffects."Document No.", TransactionCharges.Description,
                            TransactionCharges."ATM Clearing Account Comms. %" * -1, TransactionCharges."G/L Account", UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");
                            LineNo := LineNo + 10000;

                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::"G/L Account",
                            UnclearedEffects."Document No.", TransactionCharges.Description,
                            TransactionCharges."ATM Fee. %" * -1, TransactionCharges."ATM Fee (Income)", UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                            LineNo := LineNo + 10000;
                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::"G/L Account",
                            UnclearedEffects."Document No.", 'Excise Duty on -' + TransactionCharges.Description,
                            TransactionCharges."ATM Fee. %" * (ExciseDutyPerc / 100) * -1, ExciseDutyGL, UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");
                        end;

                    end;

                    JnlPostMngt.CompletePosting(JTemplate, JBatch);

                    Commit();
                    UnclearedEffects.Posted := true;
                    UnclearedEffects."Customer Names" := Account.Name;
                    UnclearedEffects."Posting Date" := Today;
                    UnclearedEffects."Posted By" := UserId;
                    UnclearedEffects.Modify(true);

                    clearedEffects.Reset();
                    clearedEffects.SetRange("Trace ID", UnclearedEffects."Trace ID");
                    if clearedEffects.FindFirst() then begin
                        clearedEffects.Posted := true;
                        clearedEffects."Posted By" := UserId;
                        clearedEffects."Posting Date" := Today;
                        clearedEffects."Customer Names" := Account.Name;
                        clearedEffects.Modify(true);

                    end;

                    ReturnedVal := 0;
                    ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                    Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');

                    if UnclearedEffects."Transaction Type" = UnclearedEffects."Transaction Type"::"Balance Enquiry" then begin
                        Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                        'You have done a balance enquiry on your account.' + 'Date: ' +
                        Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                    end else begin
                        Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                        'You have done a ' + Format(UnclearedEffects.Source) + ' transaction on your account.' + 'Date: ' +
                        Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                    end;
                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;
    end;

    procedure PerformPostWithdrawalSaccoLinkTxt(ReceiptNo: Code[20]) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "Link Transactions";
        clearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        AcctType: Enum "Gen. Journal Account Type";
        AppliesToDocNo: Code[20];
        DocType: Enum "Gen. Journal Document Type";
        LnTransType: Enum "LoanTransactionType";
        JournalDocType: Enum "Gen. Journal Document Type";

    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty (%)");
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyPerc := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("ATM Clearing Account Comms. %");
        Temp.TestField("ATM Fee. %");
        Temp.TestField("Coop Clearing Bank");

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetFilter(Amount, '>0');
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);
        UnclearedEffects.SetRange(Source, UnclearedEffects.Source::ATM);
        if UnclearedEffects.FindFirst() then begin

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Coop Clearing Bank");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);

                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Document No.");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Document No.";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);
                ChargeAmount := 0;

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin
                    if UnclearedEffects.Amount > 0 then begin

                        LineNo := LineNo + 10000;

                        JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::Vendor,
                        UnclearedEffects."Document No.", UnclearedEffects.Description,
                        UnclearedEffects.Amount, Account."No.", UnclearedEffects."Transaction Date",
                        AcctType::"Bank Account", TellerTill."No.", CopyStr(UnclearedEffects."Trace ID", 1, 20),
                        Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                        LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                        if UnclearedEffects."Charge Code" <> '' then begin

                            TransactionCharges.Reset();
                            TransactionCharges.SetRange("Transaction Type", UnclearedEffects."Charge Code");
                            if TransactionCharges.FindFirst() then begin

                                TransactionCharges.TestField("G/L Account");
                                TransactionCharges.TestField("ATM Clearing Account");
                                TransactionCharges.TestField("ATM Fee (Income)");

                                case TransactionCharges."Charge Type" of
                                    TransactionCharges."Charge Type"::"Flat Amount":
                                        begin
                                            ChargeAmount := TransactionCharges."Charge Amount"

                                        end;
                                    TransactionCharges."Charge Type"::"% of Amount":
                                        begin
                                            TransactionCharges.TestField("Percentage of Amount");
                                            ChargeAmount := UnclearedEffects."Charge Amount" * (TransactionCharges."Percentage of Amount" / 100)

                                        end;
                                    TransactionCharges."Charge Type"::Staggered:
                                        begin

                                            TariffDetails.Reset;
                                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                            if TariffDetails.Find('-') then begin
                                                repeat
                                                    if (UnclearedEffects.Amount >= TariffDetails."Lower Limit") and (UnclearedEffects.Amount <= TariffDetails."Upper Limit") then begin
                                                        if TariffDetails."Use Percentage" = true then begin
                                                            ChargeAmount := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);
                                                        end else begin
                                                            ChargeAmount := TariffDetails."Charge Amount";
                                                        end;
                                                    end;
                                                until TariffDetails.Next = 0;
                                            end;

                                        end;
                                end;

                                LineNo := LineNo + 10000;

                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::Vendor,
                                UnclearedEffects."Document No.", TransactionCharges.Description,
                                ChargeAmount, Account."No.", UnclearedEffects."Transaction Date",
                                AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                                Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                                LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                                LineNo := LineNo + 10000;

                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, TransactionCharges."Account Type",
                                UnclearedEffects."Document No.", TransactionCharges.Description,
                                TransactionCharges."ATM Clearing Account Comms. %" * -1, TransactionCharges."G/L Account", UnclearedEffects."Transaction Date",
                                AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                                Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                                LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");
                                LineNo := LineNo + 10000;

                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::"G/L Account",
                                UnclearedEffects."Document No.", TransactionCharges.Description,
                                TransactionCharges."ATM Fee. %" * -1, TransactionCharges."ATM Fee (Income)", UnclearedEffects."Transaction Date",
                                AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                                Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                                LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                                LineNo := LineNo + 10000;
                                JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::"G/L Account",
                                UnclearedEffects."Document No.", 'Excise Duty on -' + TransactionCharges.Description,
                                TransactionCharges."ATM Fee. %" * (ExciseDutyPerc / 100) * -1, ExciseDutyGL, UnclearedEffects."Transaction Date",
                                AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                                Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                                LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");
                            end;

                        end;

                        JnlPostMngt.CompletePosting(JTemplate, JBatch);

                        Commit();
                        UnclearedEffects.Posted := true;
                        UnclearedEffects."Customer Names" := Account.Name;
                        UnclearedEffects."Posting Date" := Today;
                        UnclearedEffects."Posted By" := UserId;
                        UnclearedEffects.Modify(true);

                        clearedEffects.Reset();
                        clearedEffects.SetRange("Trace ID", UnclearedEffects."Trace ID");
                        if clearedEffects.FindFirst() then begin
                            clearedEffects.Posted := true;
                            clearedEffects."Posted By" := UserId;
                            clearedEffects."Posting Date" := Today;
                            clearedEffects."Customer Names" := Account.Name;
                            clearedEffects.Modify(true);

                        end;

                        ReturnedVal := 0;
                        ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                        Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');

                    end else begin
                        Commit();
                        UnclearedEffects.Posted := true;
                        UnclearedEffects."Customer Names" := Account.Name;
                        UnclearedEffects."Posting Date" := Today;
                        UnclearedEffects."Posted By" := UserId;
                        UnclearedEffects.Modify(true);

                        clearedEffects.Reset();
                        clearedEffects.SetRange("Trace ID", UnclearedEffects."Trace ID");
                        if clearedEffects.FindFirst() then begin
                            clearedEffects.Posted := true;
                            clearedEffects."Posted By" := UserId;
                            clearedEffects."Posting Date" := Today;
                            clearedEffects."Customer Names" := Account.Name;
                            clearedEffects.Modify(true);
                        end;
                    end;
                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;
    end;

    procedure PerformTestPostWithdrawalSaccoLinkTxt(ReceiptNo: Code[20]) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        AcctType: Enum "Gen. Journal Account Type";
        AppliesToDocNo: Code[20];
        DocType: Enum "Gen. Journal Document Type";
        LnTransType: Enum "LoanTransactionType";
        JournalDocType: Enum "Gen. Journal Document Type";

    begin

        Comp.Get();
        Gensetup.Get();
        Gensetup.TestField(Gensetup."Excise Duty (%)");
        Gensetup.TestField(Gensetup."Excise Duty G/L");
        ExciseDutyGL := Gensetup."Excise Duty G/L";
        ExciseDutyPerc := Gensetup."Excise Duty (%)";

        Temp.Get(UserId);
        Temp.TestField("Alt. Journal Template");
        Temp.TestField("Alt. Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        Temp.TestField("ATM Clearing Account Comms. %");
        Temp.TestField("ATM Fee. %");
        Temp.TestField("Coop Clearing Bank");

        PostAs := Temp."Post As";
        TempB2C := Temp."Default Bank C2B";
        TempC2C := Temp."Default Bank C2C";

        JTemplate := 'GENERAL';
        JBatch := 'TEMPDATA';

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetFilter(Amount, '>0');
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);
        UnclearedEffects.SetRange(Source, UnclearedEffects.Source::ATM);
        if UnclearedEffects.FindFirst() then begin

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Coop Clearing Bank");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);

                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Trace ID";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);
                ChargeAmount := 0;

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    LineNo := LineNo + 10000;

                    JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::Vendor,
                    UnclearedEffects."Document No.", UnclearedEffects.Description,
                    UnclearedEffects.Amount, Account."No.", UnclearedEffects."Transaction Date",
                    AcctType::"Bank Account", TellerTill."No.", CopyStr(UnclearedEffects."Trace ID", 1, 20),
                    Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                    LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                    if UnclearedEffects."Charge Code" <> '' then begin

                        TransactionCharges.Reset();
                        TransactionCharges.SetRange("Transaction Type", UnclearedEffects."Charge Code");
                        if TransactionCharges.FindFirst() then begin

                            TransactionCharges.TestField("G/L Account");
                            TransactionCharges.TestField("ATM Clearing Account");
                            TransactionCharges.TestField("ATM Fee (Income)");

                            case TransactionCharges."Charge Type" of
                                TransactionCharges."Charge Type"::"Flat Amount":
                                    begin
                                        ChargeAmount := TransactionCharges."Charge Amount"

                                    end;
                                TransactionCharges."Charge Type"::"% of Amount":
                                    begin
                                        TransactionCharges.TestField("Percentage of Amount");
                                        ChargeAmount := UnclearedEffects."Charge Amount" * (TransactionCharges."Percentage of Amount" / 100)

                                    end;
                                TransactionCharges."Charge Type"::Staggered:
                                    begin

                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if (UnclearedEffects.Amount >= TariffDetails."Lower Limit") and (UnclearedEffects.Amount <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin
                                                        ChargeAmount := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);
                                                    end else begin
                                                        ChargeAmount := TariffDetails."Charge Amount";
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end;

                                    end;
                            end;

                            LineNo := LineNo + 10000;

                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::Vendor,
                    UnclearedEffects."Document No.", TransactionCharges.Description,
                    ChargeAmount, Account."No.", UnclearedEffects."Transaction Date",
                    AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                    Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                    LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                            LineNo := LineNo + 10000;

                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, TransactionCharges."Account Type",
                            UnclearedEffects."Document No.", TransactionCharges.Description,
                            TransactionCharges."ATM Clearing Account Comms. %" * -1, TransactionCharges."G/L Account", UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");
                            LineNo := LineNo + 10000;

                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::"G/L Account",
                            UnclearedEffects."Document No.", TransactionCharges.Description,
                            TransactionCharges."ATM Fee. %" * -1, TransactionCharges."ATM Fee (Income)", UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");

                            LineNo := LineNo + 10000;
                            JnlPostMngt.PostJournal(JTemplate, JBatch, LineNo, AcctType::"G/L Account",
                            UnclearedEffects."Document No.", 'Excise Duty on -' + TransactionCharges.Description,
                            TransactionCharges."ATM Fee. %" * (ExciseDutyPerc / 100) * -1, ExciseDutyGL, UnclearedEffects."Transaction Date",
                            AcctType::"G/L Account", '', CopyStr(UnclearedEffects."Trace ID", 1, 20),
                            Temp."Shortcut Dimension 1 Code", Temp."Shortcut Dimension 2 Code",
                            LnTransType::" ", '', '', '', JournalDocType::" ", '', JournalDocType::" ");
                        end;

                    end;

                    //JnlPostMngt.CompletePosting(JTemplate, JBatch);
                    //Commit();
                    //UnclearedEffects.Posted := true;
                    //UnclearedEffects."Customer Names" := Account.Name;
                    //UnclearedEffects."Posting Date" := Today;
                    //UnclearedEffects."Posted By" := UserId;
                    //UnclearedEffects.Modify(true);
                    ReturnedVal := 0;
                    ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                    Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');

                    /*  if UnclearedEffects."Transaction Type" = UnclearedEffects."Transaction Type"::"Balance Enquiry" then begin
                         Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                         'You have done a balance enquiry on your account.' + 'Date: ' +
                         Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                         UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                     end else begin
                         Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                         'You have done a ' + Format(UnclearedEffects.Source) + ' transaction on your account.' + 'Date: ' +
                         Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                         UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                     end; */
                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;
    end;

    procedure PerformPostCashWithdrawalcallbackTxt(ReceiptNo: Code[20]; PostInt: Enum JournalPreview) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "Alt. Channel Entry";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        TransT: Record "ATM Transaction";
        GrossIncome: Decimal;
        ExciseDuty: Decimal;
        MobTransactionInc: Decimal;
        VendorInc: Decimal;
        OperatorCharger: Decimal;
        NetIncome: Decimal;
        ChargeableAmt: Decimal;
        VendorChargeableAmt: Decimal;
        MaxChargeable: Decimal;
        PercentCharged: Decimal;
        ExciseDutyChargeTxt: Decimal;
        AltChannelTemp: Record "Temp. Alt. Channels";
        ErrorOnMobRefNo: Label 'Mobile Reference Must have a value. It cannot be empty';
        ExciseDutyMobile: array[2] of Decimal;

    begin

        fnInitialize();
        Gensetup.Get();
        Gensetup.TestField("Excise Duty (%)");
        Gensetup.TestField("Excise Duty G/L");

        ExciseDutyChargeTxt := 0;
        ExciseDutyChargeTxt := Gensetup."Excise Duty (%)";
        GrossIncome := 0;
        ExciseDuty := 0;
        ExciseDutyMobile[1] := 0;
        MobTransactionInc := 0;
        VendorInc := 0;
        OperatorCharger := 0;
        NetIncome := 0;
        ChargeableAmt := 0;
        VendorChargeableAmt := 0;
        MaxChargeable := 0;
        PercentCharged := 0;

        ExciseDutyMobile[1] := Gensetup."Excise Duty (%)";

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetFilter(Amount, '>0');
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);

        if UnclearedEffects.FindFirst() then begin
            if UnclearedEffects."Reference No" = '' then begin
                Response := ErrorOnMobRefNo;
                exit(Response);
            end;

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Default Bank C2B");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);
                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Reference No");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Reference No";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    GenJournalLine.LockTable;
                    LineNo := LineNo + 10000;
                    TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo, JTemplate, JBatch,
                    UnclearedEffects."Reference No", '', UnclearedEffects."Transaction Date", Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                    GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                    GenJournalLine.Validate(Amount, UnclearedEffects.Amount);
                    GenJournalLine.Description := UnclearedEffects.Description;
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TellerTill."No.");

                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                    if UnclearedEffects."Charge Code" <> '' then begin

                        TransactionCharges.Reset();
                        TransactionCharges.SetRange("Transaction Type", 'MOBWITHD');
                        if TransactionCharges.FindFirst() then begin

                            OperatorCharger := 0;
                            NetIncome := 0;
                            TransactionCharges.TestField("G/L Account");
                            case TransactionCharges."Charge Type" of
                                TransactionCharges."Charge Type"::"% of Amount":
                                    begin
                                        TransactionCharges.TestField("Percentage of Amount");
                                        MaxChargeable := Round((UnclearedEffects.Amount * (TransactionCharges."Percentage of Amount" / 100)), 1, '>');
                                        OperatorCharger := Round((UnclearedEffects.Amount * (TransactionCharges."Percentage of Amount" / 100)), 1, '>');
                                    end;
                                TransactionCharges."Charge Type"::"Flat Amount":
                                    begin

                                        TransactionCharges.TestField("Charge Amount");
                                        OperatorCharger := TransactionCharges."Charge Amount";
                                        MaxChargeable := TransactionCharges."Charge Amount";
                                    end;
                                TransactionCharges."Charge Type"::Staggered:
                                    begin
                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if (UnclearedEffects.Amount >= TariffDetails."Lower Limit") and (UnclearedEffects.Amount <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin

                                                        OperatorCharger := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);
                                                        MaxChargeable := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);

                                                    end else begin

                                                        OperatorCharger := TariffDetails."Charge Amount";
                                                        MaxChargeable := TariffDetails."Charge Amount";
                                                        PercentCharged := TariffDetails.Percentage;
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end
                                    end;
                            end;

                            GrossIncome := (MaxChargeable);
                            NetIncome := (GrossIncome - PercentCharged);

                            ChargeableAmt := Round((NetIncome * (100 / (ExciseDutyMobile[1] + 100))));

                            if GrossIncome > 0 then begin

                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo, JTemplate, JBatch,
                                UnclearedEffects."Reference No", '', UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                GenJournalLine.Validate(Amount, GrossIncome);
                                GenJournalLine.Description := TransactionCharges.Description;
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);


                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo, JTemplate, JBatch,
                                UnclearedEffects."Reference No", '', UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", Temp."Mobile Corporate A/c");
                                GenJournalLine.Validate(Amount, PercentCharged * -1);
                                GenJournalLine.Description := 'Charge on-' + UnclearedEffects.Description;
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);

                                // Excise on NetIncome
                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo, JTemplate, JBatch,
                                UnclearedEffects."Reference No", '', UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine.Validate("Account No.", Gensetup."Excise Duty G/L");
                                GenJournalLine.Validate(Amount, ChargeableAmt * (ExciseDutyMobile[1] / 100) * -1);
                                GenJournalLine.Description := CopyStr('Excise Duty on-' + TransactionCharges.Description, 1, 100);
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);

                                VendorChargeableAmt := (ChargeableAmt * (Temp."Vendor Comms. %" / 100));

                                // Income to Client
                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, UnclearedEffects."Reference No", '',
                                UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", Temp."Mobile Transaction In. A/c");
                                GenJournalLine.Validate(Amount, VendorChargeableAmt * -1);
                                GenJournalLine.Description := CopyStr(TransactionCharges.Description, 1, 100);
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);

                                // Income to Vendor
                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo, JTemplate, JBatch,
                                UnclearedEffects."Reference No", '', UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", Temp."Vendor Comms. A/c");
                                GenJournalLine.Validate(Amount, (ChargeableAmt - VendorChargeableAmt) * -1);
                                GenJournalLine.Description := CopyStr(TransactionCharges.Description, 1, 100);
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);
                            end;
                        end;
                    end;

                    case PostInt of
                        PostInt::"Post Applicatiion":
                            begin

                                JnlPostMngt.CompletePosting(JTemplate, JBatch);
                                Commit();
                                UnclearedEffects.Posted := true;
                                UnclearedEffects."Customer Names" := Account.Name;
                                UnclearedEffects."Posting Date" := Today;
                                UnclearedEffects."Posted By" := UserId;
                                UnclearedEffects.Modify(true);
                                ReturnedVal := 0;

                                TransT.Reset();
                                TransT.SetRange("Trace ID", UnclearedEffects."Trace ID");
                                if TransT.FindFirst() then begin
                                    TransT.Posted := true;
                                    TransT."Customer Names" := Account.Name;
                                    TransT."Posting Date" := Today;
                                    TransT."Posted By" := UserId;
                                    TransT.Modify(true);
                                end;

                                AltChannelTemp.Reset();
                                AltChannelTemp.SetRange("Trace ID", UnclearedEffects."Trace ID");
                                if AltChannelTemp.FindFirst() then begin
                                    AltChannelTemp.Posted := true;
                                    AltChannelTemp."Customer Names" := Account.Name;
                                    AltChannelTemp."Posting Date" := Today;
                                    AltChannelTemp."Posted By" := UserId;
                                    AltChannelTemp.Modify(true);
                                end;

                                ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                                Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');

                                if UnclearedEffects."Transaction Type" = UnclearedEffects."Transaction Type"::"Balance Enquiry" then begin
                                    Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                                    'You have done a balance enquiry on your account.' + 'Date: ' +
                                    Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                                    UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                                end
                            end else begin

                            GenJournalLine.Reset();
                            GenJournalLine.SetRange("Document No.", '');
                            GenJournalLine.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                            GenJournalLine.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                            if GenJournalLine.Find('-') then begin
                                Page.Run(Page::"Journal Test Batch", GenJournalLine);
                            end;

                        end;
                    end;
                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;
    end;





    procedure PerformPostCashWithdrawalcallbackTxt(ReceiptNo: Code[20]) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "Alt. Channel Entry";
        Account: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        TransT: Record "ATM Transaction";
        GrossIncome: Decimal;
        ExciseDuty: Decimal;
        MobTransactionInc: Decimal;
        VendorInc: Decimal;
        OperatorCharger: Decimal;
        NetIncome: Decimal;
        ChargeableAmt: Decimal;
        VendorChargeableAmt: Decimal;
        MaxChargeable: Decimal;
        PercentCharged: Decimal;
        ExciseDutyChargeTxt: Decimal;
        AltChannelTemp: Record "Temp. Alt. Channels";
        ErrorOnMobRefNo: Label 'Mobile Reference Must have a value. It cannot be empty';

    begin

        fnInitialize();
        Gensetup.Get();
        Gensetup.TestField("Excise Duty (%)"); //Exvise Duty %
        Gensetup.TestField("Excise Duty G/L");//G/L Account
        ExciseDutyChargeTxt := 0;
        ExciseDutyChargeTxt := Gensetup."Excise Duty (%)";
        GrossIncome := 0;
        ExciseDuty := 0;
        MobTransactionInc := 0;
        VendorInc := 0;
        OperatorCharger := 0;
        NetIncome := 0;
        ChargeableAmt := 0;
        VendorChargeableAmt := 0;
        MaxChargeable := 0;
        PercentCharged := 0;

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;

        UnclearedEffects.Reset();
        UnclearedEffects.SetFilter(Amount, '>0');
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);

        if UnclearedEffects.FindFirst() then begin
            if UnclearedEffects."Reference No" = '' then begin
                Response := ErrorOnMobRefNo;
                exit(Response);
            end;

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Default Bank C2B");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);
                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Reference No");

                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Reference No";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    GenJournalLine.LockTable;
                    LineNo := LineNo + 10000;
                    TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                    JTemplate, JBatch, UnclearedEffects."Reference No", '',
                    UnclearedEffects."Transaction Date", Dim1, Dim2);
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                    GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                    GenJournalLine.Validate(Amount, UnclearedEffects.Amount);
                    GenJournalLine.Description := UnclearedEffects.Description;
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                    GenJournalLine.Validate(GenJournalLine."Bal. Account No.", TellerTill."No.");

                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert(true);

                    if UnclearedEffects."Charge Code" <> '' then begin

                        TransactionCharges.Reset();
                        TransactionCharges.SetRange("Transaction Type", 'MOBWITHD');
                        if TransactionCharges.FindFirst() then begin

                            OperatorCharger := 0;
                            NetIncome := 0;
                            TransactionCharges.TestField("G/L Account");
                            case TransactionCharges."Charge Type" of

                                TransactionCharges."Charge Type"::"% of Amount":
                                    begin
                                        TransactionCharges.TestField("Percentage of Amount");
                                        MaxChargeable := Round((UnclearedEffects.Amount * (TransactionCharges."Percentage of Amount" / 100)), 1, '>');
                                        OperatorCharger := Round((UnclearedEffects.Amount * (TransactionCharges."Percentage of Amount" / 100)), 1, '>');
                                    end;
                                TransactionCharges."Charge Type"::"Flat Amount":
                                    begin
                                        TransactionCharges.TestField("Charge Amount");
                                        OperatorCharger := TransactionCharges."Charge Amount";
                                        MaxChargeable := TransactionCharges."Charge Amount";
                                    end;
                                TransactionCharges."Charge Type"::Staggered:
                                    begin
                                        TariffDetails.Reset;
                                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                        if TariffDetails.Find('-') then begin
                                            repeat
                                                if (UnclearedEffects.Amount >= TariffDetails."Lower Limit") and (UnclearedEffects.Amount <= TariffDetails."Upper Limit") then begin
                                                    if TariffDetails."Use Percentage" = true then begin
                                                        OperatorCharger := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);
                                                        MaxChargeable := (UnclearedEffects.Amount * TariffDetails.Percentage * 0.01);
                                                    end else begin
                                                        OperatorCharger := TariffDetails."Charge Amount";
                                                        MaxChargeable := TariffDetails."Charge Amount";
                                                        PercentCharged := TariffDetails.Percentage;
                                                    end;
                                                end;
                                            until TariffDetails.Next = 0;
                                        end
                                    end;
                            end;

                            GrossIncome := (MaxChargeable);

                            NetIncome := (GrossIncome - PercentCharged);
                            ChargeableAmt := (NetIncome * (100 / 115));

                            if GrossIncome > 0 then begin

                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, UnclearedEffects."Reference No", '',
                                UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                GenJournalLine.Validate(Amount, GrossIncome);
                                GenJournalLine.Description := TransactionCharges.Description;
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);


                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, UnclearedEffects."Reference No", '',
                                UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", Temp."Mobile Corporate A/c");
                                GenJournalLine.Validate(Amount, PercentCharged * -1);
                                GenJournalLine.Description := 'Charge on-' + UnclearedEffects.Description;
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);

                                // Excise on NetIncome
                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, UnclearedEffects."Reference No", '',
                                UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine.Validate("Account No.", Gensetup."Excise Duty G/L");

                                GenJournalLine.Validate(Amount, ChargeableAmt * (ExciseDutyChargeTxt / 100) * -1);
                                GenJournalLine.Description := CopyStr('Excise Duty on-' + TransactionCharges.Description, 1, 100);
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);

                                VendorChargeableAmt := (ChargeableAmt * (Temp."Vendor Comms. %" / 100));

                                // Income to Client
                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, UnclearedEffects."Reference No", '',
                                UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", Temp."Mobile Transaction In. A/c");
                                GenJournalLine.Validate(Amount, VendorChargeableAmt * -1);
                                GenJournalLine.Description := CopyStr(TransactionCharges.Description, 1, 100);
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);

                                // Income to Vendor
                                GenJournalLine.LockTable;
                                LineNo := LineNo + 10000;
                                TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                JTemplate, JBatch, UnclearedEffects."Reference No", '',
                                UnclearedEffects."Transaction Date", Dim1, Dim2);
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine."External Document No." := UnclearedEffects."Trace ID";
                                GenJournalLine.Validate(GenJournalLine."Account No.", Temp."Vendor Comms. A/c");
                                GenJournalLine.Validate(Amount, (ChargeableAmt - VendorChargeableAmt) * -1);
                                GenJournalLine.Description := CopyStr(TransactionCharges.Description, 1, 100);
                                GenJournalLine.Validate("Shortcut Dimension 1 Code", Temp."Shortcut Dimension 1 Code");
                                GenJournalLine.Validate("Shortcut Dimension 2 Code", Temp."Shortcut Dimension 2 Code");
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert(true);
                            end;
                        end;

                    end;

                    JnlPostMngt.CompletePosting(JTemplate, JBatch);
                    Commit();
                    UnclearedEffects.Posted := true;
                    UnclearedEffects."Customer Names" := Account.Name;
                    UnclearedEffects."Posting Date" := Today;
                    UnclearedEffects."Posted By" := UserId;
                    UnclearedEffects.Modify(true);
                    ReturnedVal := 0;

                    TransT.Reset();
                    TransT.SetRange("Trace ID", UnclearedEffects."Trace ID");
                    if TransT.FindFirst() then begin
                        TransT.Posted := true;
                        TransT."Customer Names" := Account.Name;
                        TransT."Posting Date" := Today;
                        TransT."Posted By" := UserId;
                        TransT.Modify(true);
                    end;

                    AltChannelTemp.Reset();
                    AltChannelTemp.SetRange("Trace ID", UnclearedEffects."Trace ID");
                    if AltChannelTemp.FindFirst() then begin
                        AltChannelTemp.Posted := true;
                        AltChannelTemp."Customer Names" := Account.Name;
                        AltChannelTemp."Posting Date" := Today;
                        AltChannelTemp."Posted By" := UserId;
                        AltChannelTemp.Modify(true);
                    end;

                    ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                    Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');

                    if UnclearedEffects."Transaction Type" = UnclearedEffects."Transaction Type"::"Balance Enquiry" then begin
                        Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                        'You have done a balance enquiry on your account.' + 'Date: ' +
                        Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                    end else begin
                        //Commented because SMS is sending twice
                        /* Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                        'You have done a ' + Format(UnclearedEffects."Transaction Type") + ' on your account.' + 'Date: ' +
                        Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false); */
                    end;
                end else begin
                    Response := '99|Failed.Account Blocked or Not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found';
                exit(Response)
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found';
            exit(Response)
        end;

    end;

    procedure PerformPostOnAccountTransfers(ReceiptNo: Code[20]; IntPost: Integer;PostPreview: Boolean) Response: Text[6048]
    var
        TellerTill: Record "Bank Account";
        UnclearedEffects: Record "ATM Transaction";
        Account: Record "Account Banking";
        FosaAccount: Record "Account Banking";
        TCharges: Decimal;
        TransactionTypes: Record "Transaction Types";
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TransTypes: Record "Transaction Types";
        TariffDetails: Record "Tiered Charges Line";
        ReturnedVal: Decimal;
        Continue: Boolean;
        TellPostMngt: Codeunit "Teller-Post (Yes/No)";
        AccountCredit: Record "Account Credit";
        RunBal: Decimal;
        AmtBal: Decimal;
        Ploans: Record Loans;
        OutInterest: Decimal;
        LRepayment: Decimal;
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        PeriodicMgt: Codeunit "Periodic Activities Mgt.";
        AccruedInt: Decimal;
        AccountType: Record "Product Factory";
        AccBanking: Record "Account Banking";
        TotalCharge: Decimal;
        JuniorTransType: Code[20];
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        ErrorOnExistNoCharge: Label '99|No Charge type found associated with this account.';
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        Text0008: Label '99|No enough funds for this transaction';
        OutBill: Decimal;
        OutInsurance: Decimal;

    begin

        fnInitialize();

        JTemplate := Temp."Alt. Journal Template";
        JBatch := Temp."Alt. Journal Batch";

        Dim1 := Temp."Shortcut Dimension 1 Code";
        Dim2 := Temp."Shortcut Dimension 2 Code";
        Continue := false;
        RunBal := 0;
        OutInterest := 0;
        OutBill := 0;
        OutInsurance := 0;
        LRepayment := 0;
        AccruedInt := 0;

        UnclearedEffects.Reset();
        UnclearedEffects.SetFilter(Amount, '>0');
        UnclearedEffects.SetRange(Posted, false);
        UnclearedEffects.SetRange("Trace ID", ReceiptNo);
        if UnclearedEffects.FindFirst() then begin

            TellerTill.Reset();
            TellerTill.SetRange(Blocked, false);
            TellerTill.SetRange("No.", Temp."Default Bank C2B");
            IF TellerTill.FindFirst() then begin
                TellerTill.CalcFields(TellerTill.Balance);
                Continue := RegMngt.TestNoEntriesExist(UnclearedEffects."Trace ID");
                if Continue then begin
                    Response := '99|Entry already Posted' + UnclearedEffects."Trace ID";
                    exit(Response);
                end;

                if TellerTill."Min. Balance" < 0 then begin
                    Response := '99 |Low Till balance';
                    exit(Response);
                end;

                JnlPostMngt.ClearJournalLines(JTemplate, JBatch);
                AmtBal := 0;

                Account.Reset();
                Account.SetRange(Blocked, Account.Blocked::" ");
                Account.SetRange("No.", UnclearedEffects."Account No");
                if Account.FindFirst() then begin

                    if AccountType.Get(Account."Product Type") then
                        if AccountType."Charge Subsiquent withdrawal" then begin
                            JuniorTransType := TellerMgt.getSubsiquenTransType(AccountType."Product ID");

                            if JuniorTransType = '' then exit(ErrorOnExistNoCharge);
                            TotalCharge := BnkMngt.CalculateTransactCharges(UnclearedEffects.Amount, JuniorTransType, 1, true);
                            if Account."Next Withdrawal Date" <> 0D then begin

                                if Today <= Account."Next Withdrawal Date" then begin

                                    if UnclearedEffects.Amount < TellerMgt.CalcAvailableBal(Account."No.") then begin

                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                        JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                        UnclearedEffects."Transaction Date", Dim1, Dim2);
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                                        GenJournalLine.Validate(Amount, (UnclearedEffects.Amount - TotalCharge));
                                        GenJournalLine.Description := UnclearedEffects.Description;
                                        GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);

                                        TellerMgt.fnPostAccTransferCharges(JuniorTransType, Account."No.", UnclearedEffects.Amount,
                                        Dim1, Dim2, JTemplate, JBatch, UnclearedEffects."Trace ID", UnclearedEffects."Transaction Date");

                                    end else begin
                                        exit(Text0008)
                                    end;
                                end;
                            end
                        end else begin
                            TotalCharge := 0;

                            GenJournalLine.LockTable;
                            LineNo := LineNo + 10000;
                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                            GenJournalLine.Validate(GenJournalLine."Account No.", UnclearedEffects."Account No");
                            GenJournalLine.Validate(Amount, UnclearedEffects.Amount);
                            GenJournalLine.Description := UnclearedEffects.Description;
                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                            if GenJournalLine.Amount <> 0 then
                                GenJournalLine.Insert(true);
                        end;

                    AmtBal := (UnclearedEffects.Amount - TotalCharge);

                    case IntPost of
                        1:
                            begin

                                FosaAccount.Reset();
                                FosaAccount.SetRange(Blocked, FosaAccount.Blocked::" ");
                                FosaAccount.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                if FosaAccount.FindFirst() then begin
                                    if FosaAccount.Blocked = FosaAccount.Blocked::" " then begin

                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                        JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                        UnclearedEffects."Transaction Date", Dim1, Dim2);
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                        GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                        GenJournalLine.Validate(GenJournalLine."Account No.", FosaAccount."No.");
                                        GenJournalLine.Validate(Amount, AmtBal * -1);
                                        GenJournalLine.Description := UnclearedEffects.Description;
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);

                                    end else begin
                                        Response := '99|Failed.Account Blocked or Not found';
                                        exit(Response)
                                    end;

                                end else begin

                                    AccountCredit.Reset();
                                    AccountCredit.SetRange(Blocked, AccountCredit.Blocked::" ");
                                    AccountCredit.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                    if AccountCredit.FindFirst() then begin

                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                        JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                        UnclearedEffects."Transaction Date", Dim1, Dim2);
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                        GenJournalLine.Validate(GenJournalLine."Account No.", AccountCredit."No.");
                                        GenJournalLine.Validate(Amount, AmtBal * -1);
                                        GenJournalLine.Description := UnclearedEffects.Description;
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);
                                    end else begin
                                        Response := '99|Failed.Account Blocked or Not found';
                                        exit(Response)
                                    end;
                                end;
                            end;
                        2:
                            begin

                                RunBal := (UnclearedEffects.Amount - TotalCharge);

                                PLoans.Reset;
                                Ploans.SetFilter("Outstanding Balance", '>0');
                                PLoans.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                if PLoans.Find('-') then begin
                                    Ploans.CalcFields("Outstanding Balance");

                                    EndDate := Today;
                                    StartDate := CalcDate('-CM', Today);
                                    IntDays := (EndDate - StartDate) + 1;

                                    if RunBal >= Ploans."Outstanding Balance" then begin
                                        if AccountType.Get(Ploans."Product Type") then
                                            AccountType.TestField("Interest Account (G/L)");

                                        if AccountType."Loan Span" = AccountType."Loan Span"::"Mobile Loan" then
                                            AccruedInt := 0 else
                                            AccruedInt := PeriodicMgt.fnIntEntriesonSpecificLoan(Ploans, Today, Ploans."No.", 1, IntDays, StartDate);

                                        GenJournalLine.LockTable;
                                        LineNo := LineNo + 10000;
                                        TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                        JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                        UnclearedEffects."Transaction Date", Dim1, Dim2);
                                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                        GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                        GenJournalLine.Validate(GenJournalLine."Account No.", Ploans."Loan Account");
                                        GenJournalLine.Validate(Amount, AccruedInt);
                                        GenJournalLine.Description := UnclearedEffects.Description;
                                        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Due";
                                        GenJournalLine.Validate("Loan No.", Ploans."No.");
                                        GenJournalLine.Validate("Bal. Account No.", AccountType."Interest Account (G/L)");
                                        if GenJournalLine.Amount <> 0 then
                                            GenJournalLine.Insert(true);
                                    end else begin
                                        AccruedInt := 0

                                    end;
                                end;

                                PLoans.Reset;
                                PLoans.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                if PLoans.Find('-') then begin
                                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                    "Outstanding Interest", "Outstanding Balance");

                                    if (Ploans."Outstanding Interest" + AccruedInt) > 0 then begin

                                        if RunBal > 0 then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", Ploans."Loan Account");
                                            if PLoans."Outstanding Interest" > RunBal then
                                                GenJournalLine.Validate(Amount, RunBal * -1) else
                                                GenJournalLine.Validate(Amount, (Ploans."Outstanding Interest" + AccruedInt) * -1);
                                            GenJournalLine.Description := UnclearedEffects.Description;
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                            GenJournalLine.Validate("Loan No.", Ploans."No.");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);

                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                            OutInterest := Abs(GenJournalLine.Amount);
                                        end;
                                    end;
                                end else begin
                                    Response := '99|Failed.Loan Account Not found';
                                    exit(Response)
                                end;

                                PLoans.Reset;
                                PLoans.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                if PLoans.Find('-') then begin
                                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                    "Outstanding Interest", "Outstanding Balance");

                                    if Ploans."Outstanding Bill" > 0 then begin

                                        if RunBal > 0 then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", Ploans."Loan Account");
                                            if PLoans."Outstanding Bill" > RunBal then
                                                GenJournalLine.Validate(Amount, RunBal * -1) else
                                                GenJournalLine.Validate(Amount, (Ploans."Outstanding Bill") * -1);
                                            GenJournalLine.Description := UnclearedEffects.Description;
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                                            GenJournalLine.Validate("Loan No.", Ploans."No.");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);

                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                            OutBill := Abs(GenJournalLine.Amount);
                                        end;
                                    end;
                                end else begin
                                    Response := '99|Failed.Loan Account Not found';
                                    exit(Response)
                                end;

                                PLoans.Reset;
                                PLoans.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                if PLoans.Find('-') then begin
                                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                    "Outstanding Interest", "Outstanding Balance");

                                    if Ploans."Outstanding Insurance" > 0 then begin

                                        if RunBal > 0 then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", Ploans."Loan Account");
                                            if PLoans."Outstanding Insurance" > RunBal then
                                                GenJournalLine.Validate(Amount, RunBal * -1) else
                                                GenJournalLine.Validate(Amount, (Ploans."Outstanding Insurance") * -1);
                                            GenJournalLine.Description := UnclearedEffects.Description;
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Insurance Paid";
                                            GenJournalLine.Validate("Loan No.", Ploans."No.");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);
                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                            OutInsurance := Abs(GenJournalLine.Amount);
                                        end;
                                    end;
                                end else begin
                                    Response := '99|Failed.Loan Account Not found';
                                    exit(Response)
                                end;

                                PLoans.Reset;
                                PLoans.SetRange("No.", UnclearedEffects."Account No.(Credit)");
                                if PLoans.Find('-') then begin

                                    PLoans.CalcFields("Outstanding Bill", "Outstanding Principal",
                                    "Outstanding Interest", "Outstanding Balance");

                                    LRepayment := 0;
                                    LRepayment := (PLoans.Repayment - (OutInterest + OutBill + OutInsurance));
                                    if LRepayment > PLoans."Outstanding Principal" then
                                        LRepayment := PLoans."Outstanding Principal" else
                                        LRepayment := LRepayment;
                                    if Ploans."Outstanding Principal" > 0 then begin

                                        if RunBal > 0 then begin

                                            GenJournalLine.LockTable;
                                            LineNo := LineNo + 10000;
                                            TellPostMngt.InitializeAccEntry(GenJournalLine, LineNo,
                                            JTemplate, JBatch, UnclearedEffects."Trace ID", '',
                                            UnclearedEffects."Transaction Date", Dim1, Dim2);
                                            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                                            GenJournalLine."External Document No." := UnclearedEffects."Reference No";
                                            GenJournalLine.Validate(GenJournalLine."Account No.", Ploans."Loan Account");
                                            if Ploans."Outstanding Principal" > RunBal then
                                                GenJournalLine.Validate(Amount, RunBal * -1) else
                                                GenJournalLine.Validate(Amount, Ploans."Outstanding Principal" * -1);
                                            GenJournalLine.Description := UnclearedEffects.Description;
                                            GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::Repayment;
                                            GenJournalLine.Validate("Loan No.", Ploans."No.");
                                            if GenJournalLine.Amount <> 0 then
                                                GenJournalLine.Insert(true);

                                            RunBal := RunBal - Abs(GenJournalLine.Amount);
                                            OutInterest := Abs(GenJournalLine.Amount);
                                        end;
                                    end else begin
                                        Response := '99|Closed Account. Loan has no oustanding Balance';
                                        exit(Response)
                                    end;

                                end else begin
                                    Response := '99|Failed.Loan Account Not found';
                                    exit(Response)
                                end;
                            end;
                    end;

                    JnlPostMngt.CompletePosting(JTemplate, JBatch);
                    Commit();
                    UnclearedEffects.Posted := true;
                    UnclearedEffects.Modify(true);
                    UnclearedEffects."Customer Names" := Account.Name;
                    UnclearedEffects."Posting Date" := Today;
                    UnclearedEffects."Posted By" := UserId;
                    ReturnedVal := 0;
                    ReturnedVal := TellerMngt.CalcAvailableBal(Account."No.");
                    Response := '00|Success|' + DelChr(format(ReturnedVal), '=', ',');

                    if UnclearedEffects."Transaction Type" = UnclearedEffects."Transaction Type"::"Balance Enquiry" then begin
                        Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                        'You have done a balance enquiry on your account.' + 'Date: ' +
                        Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                    end else begin
                        Docs.CreateSmsNotif(NotifSource::"Cash Withdrawal Confirm", Account."Mobile No.",
                        'You have done a ' + Format(UnclearedEffects."Transaction Type") + ' on your account.' + 'Date: ' +
                        Format(Today) + 'Time: ' + Format(Time) + ' . ' + Comp.Name,
                        UnclearedEffects."Account No", UnclearedEffects."Trace ID", false);
                    end;
                end else begin
                    Response := '99|Failed.Account Blocked or Not found'
                end;
            end else begin
                Response := '99|Fail|No Transacting Bank found'
            end;
        end else begin
            Response := '99|Fail|Transaction ID Not found'
        end;
    end;
}



