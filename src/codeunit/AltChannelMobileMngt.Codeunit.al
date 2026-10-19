codeunit 50055 "Alt. Channel (Mobile Mngt.)"
{
    trigger OnRun()
    begin
        SendFullStatement('130012', 20220101D, 20221231D);
    end;

    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        AltPostYesNo: Codeunit "Alt. Purch.-Post. (Yes/No)";
        PFactory: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        Post: Codeunit "Mngt. Post Alt. Channels";
        TransCharges: Record "Transaction Charge";
        TransTypes: Record "Transaction Types";
        TellerTransType: Enum TellerTypes;
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        RegmntAcc: Record "Account (Procedure)";

    procedure GetMemberInfo(AcNo: Code[100]) MemberInfo: Text[2048]
    begin

        Member.Reset();
        Member.SetRange("ID No.", AcNo);
        Member.SetFilter(Status, '%1|%2|%3', Member.Status::New, Member.Status::Active, Member.Status::Dormant);
        IF Member.Find('-') then begin

            if Member."ID No." <> '' then begin
                MemberInfo := '<No.>' + Member."No." + '</No.>'
                        + '<Name>' + Member.Name + '</Name>'
                        + '<PhoneNo>' + Member."Mobile Phone No" + '</PhoneNo>'
                        + '<IDType>' + format(Member."Identification Type") + '</IDType>'
                        + '<DOB>' + Format(Member."Date of Birth") + '</DOB>'
                        + '<Gender>' + Format(Member.Gender) + '</Gender>'
                        + '<Mail>' + Member."E-Mail" + '</Mail>'
                        + '<PIN>' + Member."PIN No." + '</PIN>'
                        + '<Status>' + format(Member.Status) + '</Status>';
                exit(MemberInfo)
            end else begin
                MemberInfo := 'Null ID';
                exit(MemberInfo)
            end;

        end else begin
            MemberInfo := 'Account Not Found';
            exit(MemberInfo)
        end;
    end;

    procedure GetMemberBosaAccounts(AcNo: Code[100]) AccInfo: Text[6096]
    begin
        AccCredit.Reset();
        AccCredit.SetRange("ID/Passport No.", AcNo);
        AccCredit.SetRange(Status, AccCredit.Status::Active);
        AccCredit.SetFilter("Account Category", '<>%1', AccCredit."Account Category"::"Registration Fee");
        if AccCredit.FindSet() then begin
            repeat
                if AccCredit."ID/Passport No." <> '' then begin
                    AccCredit.CalcFields("Balance (LCY)");
                    AccInfo := AccInfo + '<AC>' +
                    '<No.>' + AccCredit."No." + '</No.>' +
                    '<Product>' + AccCredit."Product Type" + '</Product>' +
                    '<Bal>' + DelChr(Format(AccCredit."Balance (LCY)"), '=', ',') + '</Bal>' + '</AC>';
                end;
            until AccCredit.Next = 0
        end else begin
            AccInfo := 'Account Not Found';
        end;
    end;

    procedure GetAllAccounts(MemberNo: Code[100]) AccInfo: Text[6096]
    var
        MemAllAccount: Record "Member Accounts (All)";
        AllAccount: Record "Member Accounts (All)";
    begin

        if AltPostYesNo.OnAfterCheckDeferralPostAccount(true, MemberNo) then begin

            if MemberNo <> '' then begin

                MemAllAccount.Reset();
                MemAllAccount.SetRange("Member No.", MemberNo);
                if MemAllAccount.FindSet() then
                    MemAllAccount.DeleteAll();

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", MemberNo);
                AccBanking.SetRange(Status, AccBanking.Status::Active);
                AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::"Certificates of Deposit");
                if AccBanking.FindFirst() then begin
                    repeat
                        AccBanking.CalcFields("Balance (LCY)");
                        MemAllAccount.Init();
                        MemAllAccount."No." := AccBanking."No.";
                        MemAllAccount.Name := AccBanking.Name;
                        MemAllAccount."ID/Passport No." := AccBanking."ID/Passport No.";
                        MemAllAccount."Product Type" := AccBanking."Product Type";
                        MemAllAccount."Product Name" := AccBanking."Product Name";
                        MemAllAccount."Employer Code" := AccBanking."Employer Code";
                        MemAllAccount."Account Category" := AccBanking."Account Category";
                        MemAllAccount."Member No." := AccBanking."Member No.";
                        case AccBanking."Account Category" of
                            AccBanking."Account Category"::Savings,
                            AccBanking."Account Category"::Junior:
                                begin
                                    MemAllAccount."Balance (LCY)" := TellerMngt.CalcAvailableBal(AccBanking."No.");
                                end else begin
                                MemAllAccount."Balance (LCY)" := AccBanking."Balance (LCY)";
                            end;
                        end;
                        MemAllAccount.Insert(true);
                    until AccBanking.Next() = 0;
                end;

                AccCredit.Reset();
                AccCredit.SetRange("Member No.", MemberNo);
                AccCredit.SetRange(Status, AccCredit.Status::Active);
                AccCredit.SetFilter("Account Category", '<>%1', AccCredit."Account Category"::"Registration Fee");
                if AccCredit.FindSet() then begin
                    repeat
                        AccCredit.CalcFields("Balance (LCY)");
                        MemAllAccount.Init();
                        MemAllAccount."No." := AccCredit."No.";
                        MemAllAccount.Name := AccCredit.Name;
                        MemAllAccount."ID/Passport No." := AccCredit."ID/Passport No.";
                        MemAllAccount."Product Type" := AccCredit."Product Type";
                        MemAllAccount."Product Name" := AccCredit."Product Name";
                        MemAllAccount."Employer Code" := AccCredit."Employer Code";
                        MemAllAccount."Account Category" := AccCredit."Account Category";
                        MemAllAccount."Member No." := AccCredit."Member No.";
                        MemAllAccount."Balance (LCY)" := AccCredit."Balance (LCY)";
                        MemAllAccount.Insert(true);
                    until AccCredit.Next() = 0;
                end;

                AllAccount.Reset();
                AllAccount.SetRange("Member No.", MemberNo);
                if AllAccount.FindSet() then begin
                    repeat
                        AccInfo := AccInfo + '<AC>' +
                            '<No.>' + AllAccount."No." + '</No.>' +
                            '<Product>' + AllAccount."Product Name" + '</Product>' +
                            '<Bal>' + DelChr(Format(AllAccount."Balance (LCY)"), '=', ',') + '</Bal>' + '</AC>';
                    until AllAccount.Next() = 0;
                end;
            end else begin
                AccInfo := 'Member Account Not Found';
            end;
        end else begin
            AccInfo := '99|Account not Registered for Mobile Transaction';
            exit(AccInfo);
        end;
    end;

    procedure GetMemberFosaAccounts(AcNo: Code[100]) AccInfo: Text[6096]
    var
        CustRecord: Record Member;
    begin

        CustRecord.Reset();
        CustRecord.SetRange("ID No.", AcNo);
        if CustRecord.FindFirst() then begin
            if CustRecord."ID No." <> '' then begin
                AccBanking.Reset();
                AccBanking.SetRange("Member No.", CustRecord."No.");
                AccBanking.SetFilter(Status, '<>%1 & <>%2', AccBanking.Status::Deceased, AccBanking.Status::Withdrawn);
                AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::"Certificates of Deposit");
                if AccBanking.FindSet() then begin
                    repeat
                        AccBanking.CalcFields("Balance (LCY)");
                        AccInfo := AccInfo + '<AC>' +
                        '<No.>' + AccBanking."No." + '</No.>' +
                        '<Name>' + AccBanking.Name + '</Name>' +
                        '<Product>' + AccBanking."Product Name" + '</Product>' +
                        '<Bal>' + DelChr(Format(AccBanking."Balance (LCY)"), '=', ',') + '</Bal>' + '</AC>';

                    until AccBanking.Next() = 0
                end else begin
                    AccInfo := 'Account Not Found';
                end;
            end;
        end else begin
            AccInfo := 'Account Not Found';
        end;
    end;

    procedure GetFosaAvailableBalance(AcNo: Code[100]) AvailBalance: Text[1024]
    var
        BalanceLCY: Decimal;
    begin
        if AcNo <> '' then begin
            AccBanking.Reset();
            AccBanking.SetRange("No.", AcNo);
            if AccBanking.Find('-') then begin
                AccBanking.CalcFields("Balance (LCY)", Balance);
                BalanceLCY := TellerMngt.CalcAvailableBal(AccBanking."No.");
                if BalanceLCY < 0 then
                    BalanceLCY := 0;
                AvailBalance := DelChr(Format(BalanceLCY), '=', ',');
            end;
        end else begin
            AvailBalance := 'Account ID must have a value'
        end;
    end;

    procedure MinistatementLoans(LoanAcNo: Code[50]) statement: Text[2024]
    var
        Loans: Record Loans;
        Minicount: Integer;
        CreditLedger: Record "Loan Ledger Entry";
    begin
        Loans.Reset();
        Loans.SetRange("No.", LoanAcNo);
        if Loans.FindFirst() then begin
            if AltPostYesNo.OnAfterCheckDeferralPostAccount(true, Loans."Account No.") then begin
                Minicount := 1;
                CreditLedger.SetCurrentKey("Entry No.");
                CreditLedger.Ascending(false);
                CreditLedger.SetRange(Reversed, false);
                CreditLedger.SetRange("Loan No.", Loans."No.");
                if CreditLedger.FindSet() then begin
                    repeat
                        statement := statement + FORMAT(CreditLedger."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '::' + COPYSTR(CreditLedger.Description, 1, 25) + '::' +
                        DelChr(Format(CreditLedger.Amount), '=', ',') + '#';
                        Minicount := Minicount + 1;
                        if Minicount > 20 then exit
                    until CreditLedger.Next() = 0;
                end;
            end else begin
                statement := '99|Account not Registered for Mobile Transaction';
                exit(statement)
            end;
        end;
    end;

    procedure FosaAccMinistatement(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]) Statement: Text[6048]
    var
        SaccoAccount: Record "Account Banking";
        Minicount: Integer;
        Venderdetails: Record "Banking A/c Ledger Entry";
        Charges: Decimal;
        Response: Text;
    begin

        SaccoAccount.Reset();
        SaccoAccount.SetRange("No.", AccNo);
        SaccoAccount.SetRange(Status, SaccoAccount.Status::Active);
        SaccoAccount.SetFilter(Blocked, '<>%1 & <>%2', SaccoAccount.Blocked::All, SaccoAccount.Blocked::Payment);
        SaccoAccount.SetFilter(Status, '<>%1 & <>%2', SaccoAccount.Status::Deceased, SaccoAccount.Status::Withdrawn);
        if SaccoAccount.FindFirst() then begin

            RegmntAcc.Reset();
            RegmntAcc.SetRange("Member No.", SaccoAccount."Member No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
            if not RegmntAcc.FindFirst() then begin
                Statement := '99|Account not Registered for Mobile Transaction';
                exit(Statement)
            end;

            if AccNo = '' then begin
                Statement := '99|Failed Null String';
                exit(Statement)
            end;

            if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(AccNo) then begin
                RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, ChargeAmt, 'Mobile', TransType::" ",
                Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

                Trans.Reset();
                Trans.SetRange("Trace ID", ReferenceNo);
                if Trans.Find('-') then begin
                    if ChargeAmt > 0 then begin

                        Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");

                        if CopyStr(Response, 1, 2) = '00' then begin
                            SaccoAccount.Reset();
                            SaccoAccount.SetRange("No.", AccNo);
                            if SaccoAccount.Find('-') then begin

                                Minicount := 1;
                                Venderdetails.SetCurrentKey(Venderdetails."Entry No.");
                                Venderdetails.Ascending(false);
                                Venderdetails.SetRange(Venderdetails."Customer No.", SaccoAccount."No.");
                                Venderdetails.SetRange(Venderdetails.Reversed, false);
                                IF Venderdetails.FindSet() then begin
                                    Statement := '';
                                    repeat
                                        Statement := Statement + Format(Venderdetails."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '::' + COPYSTR(Venderdetails.Description, 1, 25) + '::' + Venderdetails."Document No." + '::' +
                                         DelChr(Format(Venderdetails.Amount), '=', ',') + '#';
                                        Minicount := Minicount + 1;
                                        if Minicount > 20 then exit
                                until Venderdetails.Next() = 0;
                                end;
                            end;
                        end;
                    end else begin

                        SaccoAccount.Reset();
                        SaccoAccount.SetRange("No.", AccNo);
                        if SaccoAccount.Find('-') then begin

                            Minicount := 1;
                            Venderdetails.SetCurrentKey(Venderdetails."Entry No.");
                            Venderdetails.Ascending(false);
                            Venderdetails.SetRange(Venderdetails."Customer No.", SaccoAccount."No.");
                            Venderdetails.SetRange(Venderdetails.Reversed, false);
                            IF Venderdetails.FindSet() then begin
                                Statement := '';
                                repeat
                                    Statement := Statement + Format(Venderdetails."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '::' + COPYSTR(Venderdetails.Description, 1, 25) + '::' + Venderdetails."Document No." + '::' +
                                     DelChr(Format(Venderdetails.Amount), '=', ',') + '#';
                                    Minicount := Minicount + 1;
                                    if Minicount > 20 then exit
                            until Venderdetails.Next() = 0;
                            end;
                        end;
                    end;
                end else begin
                    Statement := '99|Failed'
                end
            end else begin
                Statement := '99|Failed No enough fund for this transaction'
            end;
        end else begin
            Statement := '99|Account not found';
            exit(Statement)
        end;
    end;

    procedure BosaAccMinistatement(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]) Statement: Text[6048]
    var
        SaccoAccount: Record "Account Banking";
        Minicount: Integer;
        Venderdetails: Record "Banking A/c Ledger Entry";
        Charges: Decimal;
        Response: Text;
        BosaAccount: Record "Account Credit";
        CredLedgedetails: Record "Credits A/c Ledger Entry";
        DepAcc: Code[100];

    begin

        BosaAccount.Reset();
        BosaAccount.SetRange("No.", AccNo);
        if BosaAccount.FindFirst() then begin
            DepAcc := BosaAccount."No.";

            RegmntAcc.Reset();
            RegmntAcc.SetRange("Member No.", BosaAccount."Member No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
            if not RegmntAcc.FindFirst() then begin
                Statement := '99|Account not Registered for Mobile Transaction';
                exit(Statement)
            end;

            if AccNo = '' then begin
                Statement := '99|Failed Null String';
                exit(Statement)
            end;

            SaccoAccount.Reset();
            SaccoAccount.SetRange("Member No.", BosaAccount."Member No.");
            SaccoAccount.SetRange("Account Category", SaccoAccount."Account Category"::Savings);
            if SaccoAccount.FindFirst() then
                if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(SaccoAccount."No.") then begin
                    RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, SaccoAccount."No.", Narration, ChargeAmt, 'Mobile', TransType::" ",
                    Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

                    Trans.Reset();
                    Trans.SetRange("Trace ID", ReferenceNo);
                    if Trans.Find('-') then begin
                        if ChargeAmt > 0 then begin

                            Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");

                            if CopyStr(Response, 1, 2) = '00' then begin

                                BosaAccount.Reset();
                                BosaAccount.SetRange("No.", DepAcc);
                                if BosaAccount.FindFirst() then begin
                                    Minicount := 1;
                                    CredLedgedetails.SetCurrentKey(CredLedgedetails."Entry No.");
                                    CredLedgedetails.Ascending(FALSE);
                                    CredLedgedetails.SetRange(CredLedgedetails."Customer No.", BosaAccount."No.");
                                    CredLedgedetails.SetRange(CredLedgedetails.Reversed, FALSE);
                                    IF CredLedgedetails.FindSet() then begin
                                        Statement := '';
                                        repeat
                                            Statement := Statement + Format(CredLedgedetails."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '::' + CopyStr(CredLedgedetails.Description, 1, 25) + '::' + CredLedgedetails."Document No." + '::' +
                                            Format(CredLedgedetails.Amount) + '#';
                                            Minicount := Minicount + 1;
                                            IF Minicount >= 10 then exit
                                        until CredLedgedetails.NEXT = 0;
                                    end;
                                end;
                            end;

                        end else begin

                            BosaAccount.Reset();
                            BosaAccount.SetRange("No.", DepAcc);
                            if BosaAccount.FindFirst() then begin

                                Minicount := 1;
                                CredLedgedetails.SETCURRENTKEY(CredLedgedetails."Entry No.");
                                CredLedgedetails.ASCENDING(FALSE);
                                CredLedgedetails.SETRANGE(CredLedgedetails."Customer No.", BosaAccount."No.");
                                CredLedgedetails.SETRANGE(CredLedgedetails.Reversed, FALSE);
                                IF CredLedgedetails.FINDSET then begin
                                    Statement := '';
                                    REPEAT
                                        Statement := Statement + FORMAT(CredLedgedetails."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '::' + COPYSTR(CredLedgedetails.Description, 1, 25) + '::' + CredLedgedetails."Document No." + '::' +
                                        FORMAT(CredLedgedetails.Amount) + '#';
                                        Minicount := Minicount + 1;
                                        IF Minicount >= 10 then exit
                                    until CredLedgedetails.NEXT = 0;
                                end;
                            end;
                        end;
                    end else begin
                        Statement := '99|Failed'
                    end
                end else begin
                    Statement := '99|Failed No enough fund for this transaction'
                end;
        end else begin
            Statement := '99|Account not found';
            exit(Statement)
        end;

    end;

    procedure BosaAccMinistatement(AcNo: Code[100]) Statement: Text[1024]
    var
        SaccoAccount: Record "Account Credit";
        Minicount: Integer;
        Venderdetails: Record "Credits A/c Ledger Entry";
    begin

        SaccoAccount.RESET;
        SaccoAccount.SETRANGE("No.", AcNo);
        IF SaccoAccount.FIND('-') THEN BEGIN
            Minicount := 1;

            Venderdetails.SETCURRENTKEY(Venderdetails."Entry No.");
            Venderdetails.ASCENDING(FALSE);
            Venderdetails.SETRANGE(Venderdetails."Customer No.", SaccoAccount."No.");
            Venderdetails.SETRANGE(Venderdetails.Reversed, FALSE);
            IF Venderdetails.FINDSET THEN BEGIN
                Statement := '';
                REPEAT
                    Statement := Statement + FORMAT(Venderdetails."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '::' + COPYSTR(Venderdetails.Description, 1, 25) + '::' +
                    FORMAT(Venderdetails.Amount) + '#';
                    Minicount := Minicount + 1;
                    IF Minicount >= 10 THEN EXIT
                UNTIL Venderdetails.NEXT = 0;
            END;
        END;
    end;

    procedure fnGetLoanBalance(AcNo: Code[100]) LoanInfo: Text[1024]
    begin
        if AcNo <> '' then begin

            Member.RESET;
            Member.SETRANGE("ID No.", AcNo);
            IF Member.FINDFIRST() then begin
                CreditAcc.Reset();
                CreditAcc.SetRange("Account No.", Member."No.");
                if CreditAcc.FindSet() then begin
                    repeat
                        CreditAcc.CalcFields("Outstanding Balance");
                        if CreditAcc."Outstanding Balance" > 0 then begin
                            LoanInfo := LoanInfo +
                            '<No.>' + CreditAcc."No." + '<No./>' +
                            '<Product>' + CreditAcc."Product Description" + '<Product/>' +
                            '<Inst>' + Format(CreditAcc.Installments) + '<Inst/>' +
                            '<Bal>' + Format(CreditAcc."Outstanding Balance") + '<Bal/>';
                        end;

                    until CreditAcc.Next = 0;
                end;
            end;
        end else begin
            LoanInfo := '99|Invalid entry'
        end;

    end;

    procedure ActiveMemberLoans(IDNo: Code[50]) ActiveLoans: Text[2048]
    var
        LoansT: Record Loans;
        CustMember: Record Member;
        EndDate: Date;
        StartDate: Date;
        IntDays: Integer;
        PeriodicMgt: Codeunit "Periodic Activities Mgt.";
        RunBal: array[2] of Decimal;
    begin

        CustMember.Reset();
        CustMember.SetRange("ID No.", IDNo);
        if CustMember.FindFirst() then begin

            LoansT.Reset();
            LoansT.SetRange("Account No.", CustMember."No.");
            LoansT.SetFilter("Outstanding Balance", '>0');
            if LoansT.FindSet() then begin
                repeat

                    LoansT.CalcFields("Outstanding Balance");
                    RunBal[1] := 0;

                    EndDate := Today;
                    StartDate := CalcDate('-CM', Today);
                    IntDays := (EndDate - StartDate) + 1;
                    if LoansT."Product Type" = 'MSACCOLN' then
                        RunBal[1] := 0 else
                        RunBal[1] := PeriodicMgt.fnIntEntriesonSpecificLoan(LoansT, Today, LoansT."No.", 1, IntDays, StartDate);

                    ActiveLoans := ActiveLoans +
                    '<No.>' + LoansT."No." + '</No.>' +
                    '<Period>' + Format(LoansT.Installments) + '</Period>' +
                    '<Int>' + Format(LoansT."Interest Rate") + '</Int>' +
                    '<Repayment>' + Format(LoansT.Repayment) + '</Repayment>' +
                    '<Type>' + LoansT."Product Description" + '</Type>' +
                    '<Bal>' + DelChr(format(Round(LoansT."Outstanding Balance" + RunBal[1], 1, '>')), '=', ',') + '</Bal>';

                until LoansT.Next() = 0;
            end;
        end;
    end;

    local procedure InitializeEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
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

    procedure AllBosaAcccountBalEnqChargeableTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; SelectedAcc: Code[100]; Narration: Text[150]) ReturnVal: Text[2048]
    var
        SaccoAccount: Record "Account Banking";
        Minicount: Integer;
        Venderdetails: Record "Banking A/c Ledger Entry";
        Charges: Decimal;
        AvailBal: Decimal;
        Response: Text;
        AccBosa: Record "Account Credit";
    begin

        RegmntAcc.Reset();
        RegmntAcc.SetRange("Member No.", SelectedAcc);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            ReturnVal := '99|Account not Registered for Mobile Transaction';
            exit(ReturnVal)
        end;

        if SelectedAcc = '' then begin
            ReturnVal := '99|Failed Null String';
            exit(ReturnVal)
        end;

        AvailBal := 0;

        AccBanking.Reset();
        AccBanking.SetRange("Member No.", SelectedAcc);
        AccBanking.SetRange(Status, AccBanking.Status::Active);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
        if AccBanking.Find('-') then begin

            if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(AccBanking."No.") then begin
                RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccBanking."No.", Narration, ChargeAmt, 'Mobile', TransType::" ",
                Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

            end else begin
                ReturnVal := '99|Failed No enough fund for this transaction';
                exit(ReturnVal)

            end;
            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                if ChargeAmt > 0 then begin
                    Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");
                    if CopyStr(Response, 1, 2) = '00' then begin

                        AccBosa.Reset();
                        AccBosa.SetRange("Member No.", SelectedAcc);
                        AccBosa.SetRange(Status, AccBosa.Status::Active);
                        AccBosa.SetFilter("Account Category", '<>%1', AccBosa."Account Category"::"Registration Fee");
                        if AccBosa.Find('-') then begin
                            repeat
                                AccBosa.CalcFields("Balance (LCY)");
                                AvailBal := AccBosa."Balance (LCY)";
                                ReturnVal := ReturnVal + '<AC>' +
                                '<No.>' + AccBosa."No." + '</No.>' +
                                '<Product>' + AccBosa."Product Name" + '</Product>' +
                                '<Bal>' + DelChr(Format(AvailBal), '=', ',') + '</Bal>' + '</AC>';
                            until AccBosa.Next = 0
                        end else begin
                            ReturnVal := 'Account Not Found';
                        end
                    end
                end else begin

                    AccBanking.Reset();
                    AccBanking.SetRange("Member No.", SelectedAcc);
                    AccBanking.SetRange(Status, AccBanking.Status::Active);
                    AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::"Certificates of Deposit");
                    if AccBanking.FindSet() then begin
                        repeat
                            AccBanking.CalcFields("Balance (LCY)");
                            if AccBanking."Account Category" = AccBanking."Account Category"::Savings then
                                AvailBal := TellerMngt.CalcAvailableBal(SelectedAcc) else
                                AvailBal := AccBanking."Balance (LCY)";
                            ReturnVal := ReturnVal + '<AC>' +
                            '<No.>' + AccBanking."No." + '</No.>' +
                            '<Product>' + AccBanking."Product Name" + '</Product>' +
                            '<Bal>' + DelChr(Format(AvailBal), '=', ',') + '</Bal>' + '</AC>';
                        until AccBanking.Next = 0
                    end else begin
                        ReturnVal := 'Account Not Found';
                    end
                end;
            end else begin
                ReturnVal := '99|Failed'
            end
        end else begin
            ReturnVal := '99|Account not Found'
        end;

    end;

    procedure AllFosaAcccountBalEnqChargeableTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; SelectedAcc: Code[100]; Narration: Text[150]) ReturnVal: Text[2048]
    var
        SaccoAccount: Record "Account Banking";
        Minicount: Integer;
        Venderdetails: Record "Banking A/c Ledger Entry";
        Charges: Decimal;
        AvailBal: Decimal;
        Response: Text;
        FosaAc: Code[100];
        MemAllAccount: Record "Member Accounts (All)";
        AllAccount: Record "Member Accounts (All)";
    begin
        FosaAc := '';

        RegmntAcc.Reset();
        RegmntAcc.SetRange("Member No.", SelectedAcc);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            FosaAc := RegmntAcc."No.";
            ReturnVal := '99|Account not Registered for Mobile Transaction';
            exit(ReturnVal)
        end;

        if SelectedAcc = '' then begin
            ReturnVal := '99|Failed Null String';
            exit(ReturnVal)
        end;

        MemAllAccount.Reset();
        MemAllAccount.SetRange("Member No.", SelectedAcc);
        if MemAllAccount.FindSet() then
            MemAllAccount.DeleteAll();

        AccBanking.Reset();
        AccBanking.SetRange("Member No.", SelectedAcc);
        AccBanking.SetRange(Status, AccBanking.Status::Active);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
        if AccBanking.FindFirst() then begin

            AccBanking.CalcFields("Balance (LCY)");

            MemAllAccount.Init();
            MemAllAccount."No." := AccBanking."No.";
            MemAllAccount.Name := AccBanking.Name;
            MemAllAccount."ID/Passport No." := AccBanking."ID/Passport No.";
            MemAllAccount."Product Type" := AccBanking."Product Type";
            MemAllAccount."Product Name" := AccBanking."Product Name";
            MemAllAccount."Employer Code" := AccBanking."Employer Code";
            MemAllAccount."Account Category" := AccBanking."Account Category";
            MemAllAccount."Member No." := AccBanking."Member No.";
            case AccBanking."Account Category" of
                AccBanking."Account Category"::Savings,
                AccBanking."Account Category"::Junior:
                    begin
                        MemAllAccount."Balance (LCY)" := TellerMngt.CalcAvailableBal(AccBanking."No.");

                    end else begin
                    MemAllAccount."Balance (LCY)" := AccBanking."Balance (LCY)";
                end;
            end;
            MemAllAccount.Insert(true)
        end;

        AccCredit.Reset();
        AccCredit.SetRange("Member No.", SelectedAcc);
        AccCredit.SetRange(Status, AccCredit.Status::Active);
        AccCredit.SetFilter("Account Category", '<>%1', AccCredit."Account Category"::"Registration Fee");
        if AccCredit.FindSet() then begin
            repeat
                AccCredit.CalcFields("Balance (LCY)");
                MemAllAccount.Init();
                MemAllAccount."No." := AccCredit."No.";
                MemAllAccount.Name := AccCredit.Name;
                MemAllAccount."ID/Passport No." := AccCredit."ID/Passport No.";
                MemAllAccount."Product Type" := AccCredit."Product Type";
                MemAllAccount."Product Name" := AccCredit."Product Name";
                MemAllAccount."Employer Code" := AccCredit."Employer Code";
                MemAllAccount."Account Category" := AccCredit."Account Category";
                MemAllAccount."Member No." := AccCredit."Member No.";
                MemAllAccount."Balance (LCY)" := AccCredit."Balance (LCY)";
                MemAllAccount.Insert(true);
            until AccCredit.Next() = 0;
        end;
        AvailBal := 0;

        AccBanking.Reset();
        AccBanking.SetRange("Member No.", SelectedAcc);
        AccBanking.SetRange(Status, AccBanking.Status::Active);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
        if AccBanking.Find('-') then begin
            if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(AccBanking."No.") then begin
                RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccBanking."No.", Narration, ChargeAmt, 'Mobile', TransType::" ",
                Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);
            end else begin
                ReturnVal := '99|Failed No enough fund for this transaction';
                exit(ReturnVal)
            end;

            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                if ChargeAmt > 0 then begin
                    Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");
                    if CopyStr(Response, 1, 2) = '00' then begin

                        AllAccount.Reset();
                        AllAccount.SetRange("Member No.", SelectedAcc);
                        if AllAccount.FindSet() then begin
                            repeat
                                ReturnVal := ReturnVal + '<AC>' +
                                    '<No.>' + AllAccount."No." + '</No.>' +
                                    '<Product>' + AllAccount."Product Name" + '</Product>' +
                                    '<Bal>' + DelChr(Format(AllAccount."Balance (LCY)"), '=', ',') + '</Bal>' + '</AC>';
                            until AllAccount.Next() = 0;
                        end;
                    end
                end else begin
                    AllAccount.Reset();
                    AllAccount.SetRange("Member No.", SelectedAcc);
                    if AllAccount.FindSet() then begin
                        repeat
                            ReturnVal := ReturnVal + '<AC>' +
                                '<No.>' + AllAccount."No." + '</No.>' +
                                '<Product>' + AllAccount."Product Name" + '</Product>' +
                                '<Bal>' + DelChr(Format(AllAccount."Balance (LCY)"), '=', ',') + '</Bal>' + '</AC>';
                        until AllAccount.Next() = 0;
                    end;
                end;
            end else begin
                ReturnVal := '99|Failed'
            end
        end else begin
            ReturnVal := '99|No Fosa Account found';

        end;

    end;

    procedure AccountBalanceEnquiryChargeableTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; SelectedAcc: Code[100]; Narration: Text[150]) ReturnVal: Text
    var
        SaccoAccount: Record "Account Banking";
        Minicount: Integer;
        Venderdetails: Record "Banking A/c Ledger Entry";
        Charges: Decimal;
        AvailBal: Decimal;
        Response: Text;
        ActualBal: Decimal;
    begin

        SaccoAccount.Reset();
        SaccoAccount.SetRange("No.", SelectedAcc);
        SaccoAccount.SetFilter(Blocked, '<>%1 & <>%2', SaccoAccount.Blocked::All, SaccoAccount.Blocked::Payment);
        SaccoAccount.SetFilter(Status, '<>%1 & <>%2', SaccoAccount.Status::Deceased, SaccoAccount.Status::Withdrawn);
        if SaccoAccount.FindFirst() then begin

            RegmntAcc.Reset();
            RegmntAcc.SetRange("Member No.", SaccoAccount."Member No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
            if not RegmntAcc.FindFirst() then begin
                ReturnVal := '99|Account not Registered for Mobile Transaction';
                exit(ReturnVal)
            end;

            if SelectedAcc = '' then begin
                ReturnVal := '99|Failed Null String';
                exit(ReturnVal)
            end;

            AvailBal := 0;
            ActualBal := 0;

            if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(SelectedAcc) then begin
                RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, SelectedAcc, Narration, ChargeAmt, 'Mobile', TransType::" ",
                Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

                Trans.Reset();
                Trans.SetRange("Trace ID", ReferenceNo);
                if Trans.Find('-') then begin
                    if ChargeAmt > 0 then begin
                        Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");
                        if CopyStr(Response, 1, 2) = '00' then begin
                            AvailBal := TellerMngt.CalcAvailableBal(SelectedAcc);

                            SaccoAccount.Reset();
                            SaccoAccount.SetRange("No.", SelectedAcc);
                            if SaccoAccount.FindFirst() then begin
                                SaccoAccount.CalcFields("Balance (LCY)");
                                ActualBal := SaccoAccount."Balance (LCY)";
                            end else begin
                                ActualBal := 0;
                            end;
                            ReturnVal := '00|' + DelChr(Format(AvailBal), '=', ',') + '|' + DelChr(Format(ActualBal), '=', ',');
                        end
                    end else begin
                        AvailBal := TellerMngt.CalcAvailableBal(SelectedAcc);

                        SaccoAccount.Reset();
                        SaccoAccount.SetRange("No.", SelectedAcc);
                        if SaccoAccount.FindFirst() then begin
                            SaccoAccount.CalcFields("Balance (LCY)");
                            ActualBal := SaccoAccount."Balance (LCY)";
                        end else begin
                            ActualBal := 0;
                        end;
                        ReturnVal := '00|' + DelChr(Format(AvailBal), '=', ',') + '|' + DelChr(Format(ActualBal), '=', ',');
                    end;
                end else begin
                    ReturnVal := '99|Failed'
                end
            end else begin
                ReturnVal := '99|Failed No enough fund for this transaction'
            end;
        end else begin

            ReturnVal := '99|Account not found';
            exit(ReturnVal)
        end;

    end;

    procedure BosaAccountBalanceEnquiryChargeableTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; SelectedAcc: Code[100]; Narration: Text[150]) ReturnVal: Text
    var
        SaccoAccount: Record "Account Credit";
        Minicount: Integer;
        Venderdetails: Record "Banking A/c Ledger Entry";
        Charges: Decimal;
        AvailBal: Decimal;
        Response: Text;
        MembrAc: Code[100];
        FosaSaccoAccount: Record "Account Banking";
        AccNo: Code[100];

    begin

        if SelectedAcc = '' then begin
            ReturnVal := '99|Failed Null String';
            exit(ReturnVal)
        end;

        AvailBal := 0;

        SaccoAccount.Reset();
        SaccoAccount.SetRange("No.", SelectedAcc);
        if SaccoAccount.FindFirst() then begin
            SaccoAccount.CalcFields("Balance (LCY)");
            AvailBal := SaccoAccount."Balance (LCY)";
            MembrAc := SaccoAccount."Member No.";
        end else begin
            ReturnVal := '99|Account Not Found';
            exit(ReturnVal)
        end;

        RegmntAcc.Reset();
        RegmntAcc.SetRange("Member No.", MembrAc);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            ReturnVal := '99|Account not Registered for Mobile Transaction';
            exit(ReturnVal)
        end;

        FosaSaccoAccount.Reset();
        FosaSaccoAccount.SetRange("Member No.", MembrAc);
        if FosaSaccoAccount.FindFirst() then begin
            AccNo := FosaSaccoAccount."No.";
        end;

        if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(AccNo) then begin
            RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, ChargeAmt, 'Mobile', TransType::" ",
            Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                if ChargeAmt > 0 then begin
                    Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");
                    if CopyStr(Response, 1, 2) = '00' then begin
                        ReturnVal := '00|' + DelChr(Format(AvailBal), '=', ',');
                    end
                end else begin
                    ReturnVal := '00|' + DelChr(Format(AvailBal), '=', ',');
                end;
            end else begin
                ReturnVal := '99|Failed'
            end
        end else begin
            ReturnVal := '99|Failed No enough fund for this transaction'
        end;

    end;

    procedure CreateMembAccTxt(VillageResidence: Code[50]; TeaNoPayrollNo: Code[50]; CustName: Text; CustID: Code[50]; GenderCust: Enum CustGender; PinNo: Code[50]; MembAccCat: Code[10]; MobileNo: Code[50]; PhoneNo: Code[50]; DatOfBirth: Date; MaritalStat: Enum MaritalStatus; CustType: Enum CreditCustomerType; RegDate: Date; MembContrib: Decimal; FAcctype: Code[50]; TeaBuyingCentre: Code[50]; ApplicCode: Code[10]) AccountInfo: Text
    var
        MembApp: Record "Member Application";
    begin
        RegMngt.CreateMembAccTxt(VillageResidence, TeaNoPayrollNo, CustName,
        CustID, GenderCust, PinNo, MembAccCat, MobileNo, PhoneNo, DatOfBirth, MaritalStat,
        CustType, RegDate, MembContrib, FAcctype, TeaBuyingCentre, ApplicCode, 1);

        MembApp.Reset();
        MembApp.SetRange("No.", ApplicCode);
        if MembApp.Find('-') then begin
            AccountInfo := '1 |' + MembApp."No.";
        end else begin
            AccountInfo := '0 |' + 'Failed Application'
        end
    end;

    procedure PostUtilitiesTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
    begin

        RegmntAcc.Reset();
        RegmntAcc.SetRange("No.", AccNo);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            Response := '99|Account not Registered for Mobile Transaction';
            exit(Response)
        end;

        if (AmtPost = 0) or (AccNo = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(AccNo) then begin
            RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost, 'Mobile', TransType::" ",
            Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                Response := Post.PerformPostOnBillUtility(Trans."Trace ID");
            end else begin
                Response := '99|Failed'
            end
        end else begin
            Response := '99|Failed No enough fund for this transaction'
        end;
    end;

    procedure CallBackPostMngtTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]; PhoneNo: Code[20]; ChargeCode: Code[20]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        AltChannel: Record "Alt. Channel Entry";
        Gensetup: Record "General Set-Up";

    begin
        Gensetup.Get();

        if (AmtPost = 0) or (AccNo = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;
        if ReceiptNo = '' then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        if Trans.Get(ReferenceNo) then begin

            RegMngt.InitializeAltChannelEntryTxt(ReferenceNo, Today, AccNo,
            Narration, AmtPost, 'Mobile', TransType::" ", Today, 2, '', ReceiptNo, ChargeCode, ChargeAmt);

            AltChannel.Reset();
            AltChannel.SetRange("Trace ID", ReferenceNo);
            if AltChannel.Find('-') then begin
                Response := Post.PerformPostCashWithdrawalcallbackTxt(AltChannel."Trace ID", Gensetup."Journal Preview");
            end else begin
                Response := '99|Failed'
            end
        end else begin
            Response := '99|No matching Transaction no found'
        end;
    end;

    procedure PostAccWithdrawalTxt(ReferenceNo: Code[100]; ReceiptNo: Code[100]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]; PhoneNo: Code[100]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        SaccoAc: Record "Account Banking";
        CustRecord: Record Member;
    begin

        if AccNo = '' then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        RegmntAcc.Reset();
        RegmntAcc.SetRange("No.", AccNo);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            Response := '99|Account not Registered for Mobile Transaction';
            exit(Response)
        end;

        CustRecord.Reset();
        CustRecord.SetRange("No.", RegmntAcc."Member No.");
        CustRecord.SetRange(Status, CustRecord.Status::Active);
        if CustRecord.FindFirst() then begin

            SaccoAc.Reset();
            SaccoAc.SetRange("No.", AccNo);
            SaccoAc.SetRange(Status, SaccoAc.Status::Active);
            if SaccoAc.FindFirst() then begin

                if (AmtPost + 100) <= TellerMngt.CalcAvailableBal(AccNo) then begin
                    RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost, 'Mobile', TransType::" ",
                    Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

                    if ReceiptNo = '430000' then begin

                        Trans.Reset();
                        Trans.SetRange("Trace ID", ReferenceNo);
                        if Trans.Find('-') then begin
                            Response := '00|Success|' + Trans."Trace ID";
                        end else begin
                            Response := '99|Failed'
                        end
                    end else begin

                        Trans.Reset();
                        Trans.SetRange("Trace ID", ReferenceNo);
                        if Trans.Find('-') then begin

                            if AmtPost > 0 then
                                Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID");
                        end else begin
                            Response := '99|Failed'
                        end
                    end
                end else begin
                    Response := '99|Failed No enough fund for this transaction'
                end
            end else begin
                Response := '99|Account is not active or has been Blocked from transacting'
            end
        end else begin
            Response := '99|Member status is not active'
        end;
    end;

    procedure PostCashDepositTxt(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]; PhoneNo: Code[100]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
    begin

        if (AmtPost = 0) or (AccNo = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost, 'Mobile', TransType::" ",
        Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);
        Trans.Reset();
        Trans.SetRange("Trace ID", ReferenceNo);
        if Trans.Find('-') then begin
            Response := Post.PostAccountDeposits(Trans."Trace ID");
        end else begin
            Response := '99|Failed'
        end
    end;

    procedure PostCashDepositSaccoLink(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]; PhoneNo: Code[100]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        FosaAcc: Record "Account Banking";
        SourceTxt: Option ATM,Mobile,"Bank Deposit";
    begin

        RegmntAcc.Reset();
        RegmntAcc.SetRange("No.", AccNo);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Card Status", RegmntAcc."Card Status"::Approved);
        if not RegmntAcc.FindFirst() then begin
            Response := '99|Account Card not Registered/Linked for Transaction';
            exit(Response)
        end;

        FosaAcc.Reset();
        FosaAcc.SetRange("No.", AccNo);
        FosaAcc.SetRange(status, FosaAcc.Status::Active);
        FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
        FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
        FosaAcc.SetFilter("ATM No.", '<>%1', '');
        if not FosaAcc.FindFirst() then begin
            Response := '99|Account not found or not attached to sacco Link';
            exit(Response)
        end;

        if (AmtPost = 0) or (AccNo = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        SourceTxt := SourceTxt::ATM;
        RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost, 'ATM', TransType::Deposit,
            Today, SourceTxt, '', PhoneNo, ReceiptNo, ChargeAmt);

        Trans.Reset();
        Trans.SetRange("Trace ID", ReferenceNo);
        if Trans.Find('-') then begin
            Response := Post.PostAccountDepositSaccoLink(Trans."Trace ID");
        end else begin
            Response := '99|Failed'
        end
    end;

    procedure PostAltChannelReversal(DocumentNo: Code[50]) Response: Text[150]
    var

        GLRegister: Record "G/L Register";
        ReversalEntry: Record "Reversal Entry";
        Text003: Label '00|Success The entries were successfully reversed.';
        Text004: Label '99|Failed The entries reversal failed.';
        Text005: Label '99|Failed No related entries found.';
        Text006: Label '99|Failed Null value posted.';
        BnkLedgerEntry: Record "Bank Account Ledger Entry";
        Trans: Record "ATM Transaction";

    begin
        if DocumentNo <> '' then begin
            GLRegister.Reset();
            GLRegister.SetRange("Document No.", DocumentNo);
            if GLRegister.Find('-') then begin
                GLRegister.TestField(GLRegister."No.");
                ReversalEntry.SetHideDialog(true);
                ReversalEntry.SetHideWarningDialogs();
                ReversalEntry.ReverseRegister(GLRegister."No.");

                Commit();

                Trans.Reset();
                Trans.SetRange("Document No.", DocumentNo);
                if Trans.FindFirst() then begin
                    Trans.Posted := true;
                    Trans.Reversed := true;
                    BnkLedgerEntry.Reset();
                    BnkLedgerEntry.SetRange("Document No.", Trans."Document No.");
                    if BnkLedgerEntry.FindFirst() then
                        Trans."Reversal Trace ID" := Format(BnkLedgerEntry."Reversed Entry No.");
                    Trans."Reversed Posted" := true;
                    Trans.Modify(true);
                    Response := Text003;
                    exit(Response)
                end else begin
                    Response := Text004;
                end;

            end else begin
                Response := Text005;
                exit(Response)
            end;
        end else begin
            Response := Text006;
            exit(Response)
        end;
    end;

    procedure PostAccWithdrawalSaccoLink(ReferenceNo: Code[100]; ReceiptNo: Code[100]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[250]; PhoneNo: Code[100]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        SourceTxt: Option ATM,Mobile,"Bank Deposit";
        FosaAcc: Record "Account Banking";
        gensetup: Record "General Set-Up";
        ReturnedVal: Decimal;

    begin
        gensetup.Get();
        ReturnedVal := 0;

        RegmntAcc.Reset();
        RegmntAcc.SetRange("No.", AccNo);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Card Status", RegmntAcc."Card Status"::Approved);
        if not RegmntAcc.FindFirst() then begin
            Response := '99|Account Card not Registered/Linked for Transaction';
            exit(Response)
        end;

        FosaAcc.Reset();
        FosaAcc.SetRange("No.", AccNo);
        FosaAcc.SetRange(status, FosaAcc.Status::Active);
        FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
        FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
        FosaAcc.SetFilter("ATM No.", '<>%1', '');
        if not FosaAcc.FindFirst() then begin
            Response := '99|Account not found or not attached to sacco Link';
            exit(Response)
        end;

        if (AmtPost = 0) or (AccNo = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        SourceTxt := SourceTxt::ATM;
        if (AmtPost + 200) <= TellerMngt.CalcAvailableBal(AccNo) then begin
            RegMngt.InitUnclearedEffectsTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost, 'ATM', TransType::Withdrawal,
            Today, SourceTxt, '', PhoneNo, ReceiptNo, ChargeAmt);

            RegMngt.InitLinkEffectsTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost, 'ATM', TransType::Withdrawal,
            Today, SourceTxt, '', PhoneNo, ReceiptNo, ChargeAmt);


            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                case gensetup."Post As" of
                    gensetup."Post As"::"Job Queue":
                        begin
                            if FosaAcc.Get(Trans."Account No") then begin
                                ReturnedVal := TellerMngt.CalcAvailableBal(FosaAcc."No.");
                                Response := '00|Success|' + Format(ReturnedVal, 0, '<Precision,2:2><Standard Format,2>');
                            end;
                        end;
                    gensetup."Post As"::"Web Service":
                        begin
                            Response := Post.PerformPostWithdrawalSaccoLinkTxt(Trans."Trace ID");
                        end;
                end;

            end else begin
                Response := '99|Failed'
            end
        end else begin
            Response := '99|Failed No enough fund for this transaction'
        end;
    end;

    procedure CardMemberBlockMngt(accNo: Code[100]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        SourceTxt: Option ATM,Mobile,"Bank Deposit";
        FosaAcc: Record "Account Banking";
    begin

        if accNo <> '' then begin

            FosaAcc.Reset();
            FosaAcc.SetRange("No.", accNo);
            FosaAcc.SetRange(status, FosaAcc.Status::Active);
            FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
            FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
            if FosaAcc.FindFirst() then begin

                RegmntAcc.Reset();
                RegmntAcc.SetRange("No.", FosaAcc."No.");
                RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                if RegmntAcc.FindFirst() then begin
                    RegmntAcc.Validate("Card Status", RegmntAcc."Card Status"::Posted);
                    RegmntAcc.Modify(true);
                    Response := '00|Card successfully blocked from transacting';
                    exit(Response)
                end else begin
                    Response := '99|Failed No Related account found'
                end;
            end else begin
                Response := '99|Failed Card No not attached to any account'
            end;
        end else begin
            Response := '99|Null Value'
        end;
    end;

    procedure CardBlockMngt(CardNo: Code[100]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        SourceTxt: Option ATM,Mobile,"Bank Deposit";
        FosaAcc: Record "Account Banking";
    begin

        FosaAcc.Reset();
        FosaAcc.SetRange(FosaAcc."ATM No.", CardNo);
        FosaAcc.SetRange(status, FosaAcc.Status::Active);
        FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
        FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
        if FosaAcc.FindFirst() then begin

            RegmntAcc.Reset();
            RegmntAcc.SetRange("No.", FosaAcc."No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            if RegmntAcc.FindFirst() then begin
                RegmntAcc.Validate("Card Status", RegmntAcc."Card Status"::Posted);
                RegmntAcc.Modify(true);
                Response := '00|Card successfully blocked from transacting';
                exit(Response)
            end else begin
                Response := '99|Failed No Related account found'
            end;
        end else begin
            Response := '99|Failed Card No not attached to any account'
        end;
    end;

    procedure CardUnBlockMngt(CardNo: Code[20]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        SourceTxt: Option ATM,Mobile,"Bank Deposit";
        FosaAcc: Record "Account Banking";
    begin

        FosaAcc.Reset();
        FosaAcc.SetRange(FosaAcc."ATM No.", CardNo);
        FosaAcc.SetRange(status, FosaAcc.Status::Active);
        FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
        FosaAcc.SetRange("Account Category", FosaAcc."Account Category"::Savings);
        if FosaAcc.FindFirst() then begin

            RegmntAcc.Reset();
            RegmntAcc.SetRange("No.", FosaAcc."No.");
            RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
            if RegmntAcc.FindFirst() then begin
                RegmntAcc.Validate("Card Status", RegmntAcc."Card Status"::Approved);
                RegmntAcc.Modify(true);
                Response := '00|Card successfully unblocked for transacting';
                exit(Response)
            end else begin
                Response := '99|Failed No Related account found'
            end;
        end else begin
            Response := '99|Failed Card No not attached to any account'
        end;
    end;

    procedure PostBnkIntConfiguration(ReferenceNo: Code[20]; ReceiptNo: Code[20]; AmtPost: Decimal; ChargeAmt: Decimal; AccNo: Code[100]; Narration: Text[150]; PhoneNo: Code[20]) Response: Text[6048]
    var
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        FosaAcc: Record "Account Banking";
        BosaAcc: Record "Account Credit";
        SearchCode: Code[10];
        Loans: Record Loans;
    begin

        SearchCode := '';
        if (AmtPost = 0) or (AccNo = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        SearchCode := CopyStr(AccNo, 1, 2);
        case SearchCode of
            'FS':
                begin
                    FosaAcc.Reset();
                    FosaAcc.Setrange("No.", AccNo);
                    FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
                    FosaAcc.SetFilter(Status, '<>%1 & <>%2', FosaAcc.Status::Deceased, FosaAcc.Status::Withdrawn);
                    if not FosaAcc.FindFirst() then begin
                        Response := '99|Account Not found';
                        exit(Response)
                    end;
                end;
            'JR':
                begin
                    FosaAcc.Reset();
                    FosaAcc.Setrange("No.", AccNo);
                    FosaAcc.SetRange(Blocked, FosaAcc.Blocked::" ");
                    FosaAcc.SetFilter(Status, '<>%1 & <>%2', FosaAcc.Status::Deceased, FosaAcc.Status::Withdrawn);
                    if not FosaAcc.FindFirst() then begin
                        Response := '99|Account Not found';
                        exit(Response)
                    end;
                end;
            'DP':
                begin
                    BosaAcc.Reset();
                    BosaAcc.Setrange("No.", AccNo);
                    BosaAcc.SetRange(Blocked, BosaAcc.Blocked::" ");
                    BosaAcc.SetFilter(Status, '<>%1 & <>%2', BosaAcc.Status::Deceased, BosaAcc.Status::Withdrawn);
                    if not BosaAcc.FindFirst() then begin
                        Response := '99|Account Not found';
                        exit(Response)
                    end;
                end;
            'SC':
                begin
                    BosaAcc.Reset();
                    BosaAcc.Setrange("No.", AccNo);
                    BosaAcc.SetRange(Blocked, BosaAcc.Blocked::" ");
                    BosaAcc.SetFilter(Status, '<>%1 & <>%2', BosaAcc.Status::Deceased, BosaAcc.Status::Withdrawn);
                    if not BosaAcc.FindFirst() then begin
                        Response := '99|Account Not found';
                        exit(Response)
                    end;
                end;
        end;

        RegMngt.InitBnkIntConfigurationTxt(ReferenceNo, 0D, AccNo, Narration, AmtPost,
        'BankConfig', TransType::" ", Today, 2, '', ReferenceNo, ReceiptNo, ChargeAmt);

        Trans.Reset();
        Trans.SetRange("Trace ID", ReferenceNo);
        if Trans.Find('-') then begin
            Response := Post.PostBnkIntConfiguration(Trans."Trace ID");
        end else begin
            Response := '99|Failed'
        end
    end;

    procedure ValidateMobileCallBackTxt(ReceiptNo: Code[20]; ReferenceNo: Code[20]; Description: Text[150]; PhoneNo: Code[20]; AmtPost: Decimal) Response: Text
    var
        Trans: Record "ATM Transaction";
    begin
        Trans.RESET;
        Trans.SETRANGE("Reference No", ReferenceNo);
        Trans.SETRANGE(Trans.Amount, AmtPost);
        IF Trans.FIND('-') then begin
            Trans."Trace ID" := ReceiptNo;
            Trans."Phone No." := PhoneNo;
            Trans."Transaction Description" := Description;
            Trans.MODIFY;
            Response := Post.PerformPostCashWithdrawalTxt(Trans."Trace ID")
        end else begin
            Response := '0 | Failed'
        end;
    end;

    procedure PostLoanRepayKCBTxt(LoanNo: Code[50]; AmtPost: Decimal; Phone: Code[20]; ReferenceNo: Code[20]; Descript: Text[150]) RepayText: Text
    var
        Loan: Record Loans;
        BankingSetup: record "Banking User Template";
        GenJourline: Record "Gen. Journal Line";
        JnPostMngt: Codeunit "Journal Post Mngt.";
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        LineNo: Integer;
        Loans: Record Loans;
        MTrans: Record "Mobile Loan Transaction";
        TransType: Enum MobileTransactionTypes;
        AppSource: Enum DocApplicationSource;
    begin

        if (AmtPost > 0) and (LoanNo <> '') then begin

            Loans.Reset();
            Loans.SetRange("No.", LoanNo);
            if Loans.FindFirst() then begin
                Loans.CalcFields("Outstanding Balance");
                if Loans."Outstanding Balance" > 0 then begin

                    RegmntAcc.Reset();
                    RegmntAcc.SetRange("No.", Loans."Disbursement Account No.");
                    RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                    RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
                    if not RegmntAcc.FindFirst() then begin
                        RepayText := '99|Account not Registered for Mobile Transaction';
                        exit(RepayText)
                    end;
                    RegMngt.InitMobileTransactionsTxt(ReferenceNo, Descript,
                    Loans."Account No.", AmtPost, TransType::"Loan Repayment", false, Loans."No.", ReferenceNo,
                    AppSource::"External Bank");

                    MTrans.Reset();
                    MTrans.SetRange("Document No.", ReferenceNo);
                    if MTrans.FindFirst() then begin
                        RepayText := Post.PostLoanRepaymentTxt(MTrans."Document No.")
                    end else begin
                        RepayText := '99|Failed'
                    end;
                end else begin
                    RepayText := '25|No Loan for repayment available'
                end;
            end else begin
                RepayText := '25|No Loan for repayment available'
            end;
        end else begin
            RepayText := '99|Failed negative amount value or missing Loan No.'
        end;
    end;

    procedure PostLoanRepaymenTxt(LoanNo: Code[50]; AmtPost: Decimal; Phone: Code[20]; ReferenceNo: Code[20]; Descript: Text[150]) RepayText: Text
    var
        Loan: Record Loans;
        BankingSetup: record "Banking User Template";
        GenJourline: Record "Gen. Journal Line";
        JnPostMngt: Codeunit "Journal Post Mngt.";
        RunBal: Decimal;
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        LineNo: Integer;
        Loans: Record Loans;
        MTrans: Record "Mobile Loan Transaction";
        TransType: Enum MobileTransactionTypes;
        AppSource: Enum DocApplicationSource;
    begin

        if (AmtPost > 0) and (LoanNo <> '') then begin

            Loans.Reset();
            Loans.SetRange("No.", LoanNo);
            if Loans.FindFirst() then begin
                Loans.CalcFields("Outstanding Balance");
                if Loans."Outstanding Balance" > 0 then begin

                    RegmntAcc.Reset();
                    RegmntAcc.SetRange("No.", Loans."Disbursement Account No.");
                    RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                    RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
                    if not RegmntAcc.FindFirst() then begin
                        RepayText := '99|Account not Registered for Mobile Transaction';
                        exit(RepayText)
                    end;
                    RegMngt.InitMobileTransactionsTxt(ReferenceNo, Descript,
                    Loans."Account No.", AmtPost, TransType::"Loan Repayment", false, Loans."No.", ReferenceNo, AppSource::Mobile);

                    MTrans.Reset();
                    MTrans.SetRange("Document No.", ReferenceNo);
                    if MTrans.FindFirst() then begin
                        RepayText := Post.PostLoanRepaymentTxt(MTrans."Document No.")
                    end else begin
                        RepayText := '99|Failed'
                    end;
                end else begin
                    RepayText := '25|No Loan for repayment available'
                end;
            end else begin
                RepayText := '25|No Loan for repayment available'
            end;
        end else begin
            RepayText := '99|Failed negative amount value or missing Loan No.'
        end;
    end;

    procedure MobileLoanApplication(PhoneNo: Code[20]; AccountNo: Code[100]; Amount: Decimal; LoanType: Code[70]; ReferenceNo: Code[70]; PeriodTxt: Integer; Descript: Text[150]) Response: Text[250]
    var
        DscMobLoan: Record "DSC Mobile Loan";
        Err002: Label 'Reference No. already has been appended to Loan No. %1';
        ExistLoan: Record Loans;
    begin

        if AltPostYesNo.OnAfterCheckDeferralPostAccount(true, AccountNo) then begin

            OnBeforeCheckDeferralPostAccount(true, AccountNo, LoanType);
            DscMobLoan.Reset();
            DscMobLoan.SetRange("Document No.", ReferenceNo);
            if DscMobLoan.FindFirst() then begin
                if DscMobLoan."Document No." <> '' then
                    Response := '99|' + Err002;
                exit(Response);
            end;
            Response := RegMngt.MobLoanApplicationTxt(AccountNo, Amount, Descript, LoanType, ReferenceNo, 90, PhoneNo, PeriodTxt)
        end else begin
            exit('99| Mmeber not registered for Mobile banking')
        end;
    end;

    procedure MobileRegistrationMngt(IDNo: Code[20]) AccountInfo: Text[150]
    var
        AccBanking: Record "Account (Procedure)";
    begin
        if IDNo <> '' then begin
            AccBanking.Reset();
            AccBanking.SetRange("ID/Passport No.", IDNo);
            AccBanking.SetFilter(Status, '%1 | %2 | %3', AccBanking.Status::Active, AccBanking.Status::New, AccBanking.Status::Dormant);
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            AccBanking.SetRange("Mobile Transaction Status", AccBanking."Mobile Transaction Status"::Registered);
            if AccBanking.FindFirst() then begin
                AccountInfo := '00|Account registered for mobile transaction'
            end else begin
                AccountInfo := '20|Account not registered for mobile transaction'
            end;
        end else begin
            AccountInfo := '21|ID No. Must have a Value. It cannot be null';
        end;
    end;

    procedure InterBankingRegistrationMngt(IDNo: Code[20]) AccountInfo: Text[150]
    var
        AccBanking: Record "Account (Procedure)";
    begin
        if IDNo <> '' then begin
            AccBanking.Reset();
            AccBanking.SetRange("ID/Passport No.", IDNo);
            AccBanking.SetRange(Status, AccBanking.Status::Active);
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            AccBanking.SetRange("Internet Banking", AccBanking."Internet Banking"::Registered);
            if AccBanking.FindFirst() then begin
                AccountInfo := '00|Account registered for Internet Banking'
            end else begin
                AccountInfo := '20|Account not registered for Internet Banking'
            end;
        end else begin
            AccountInfo := '21|ID No. Must have a Value. It cannot be null';
        end;
    end;

    procedure getTransactionalCharges(TellerType: Enum TellerTypes) ChargeAmt: Decimal
    var

    begin
        TransTypes.Reset();
        TransTypes.SetRange(Type, TellerType);
        if TransTypes.FindFirst() then begin
            TransCharges.Reset();
            TransCharges.SetRange("Transaction Type", TransTypes.Code);
            if TransCharges.FindFirst() then begin
                ChargeAmt := TransCharges."Charge Amount"
            end;
            exit(ChargeAmt)
        end;
    end;

    procedure SendSMSNotification() TextMsg: Text[2048]
    var
        SmsMessage: Record "SMS Notification";
        MiniCount: Integer;
    begin
        SmsMessage.Reset();
        SmsMessage.SetRange("Sent To Server", SmsMessage."Sent To Server"::No);
        if SmsMessage.FindFirst() then begin
            TextMsg := TextMsg + SmsMessage."Telephone No" + '|' + SmsMessage."SMS Message" + '|' + format(SmsMessage."Entry No");
        end;
    end;

    procedure PostSendSMSNotification(EntryNo: integer; Sent: Boolean) TextMsg: Text[2048]
    var
        SmsMessage: Record "SMS Notification";
        MiniCount: Integer;
    begin
        SmsMessage.Reset();
        SmsMessage.SetRange("Entry No", EntryNo);
        if SmsMessage.Find('-') then begin
            if Sent then begin
                SmsMessage."Sent To Server" := SmsMessage."Sent To Server"::Yes;
            end else begin
                SmsMessage."Sent To Server" := SmsMessage."Sent To Server"::Failed;
            end;
            SmsMessage.Posted := true;
            SmsMessage."Date Sent to Server" := Today;
            SmsMessage.Modify(true);
        end;
    end;

    procedure getMemberMaxQualifyAmt(MemberNo: Code[100]; LoanType: Code[20]) MaxAmt: Text[150]
    var
        CustMember: Record Member;
    begin
        if MemberNo <> '' then begin
            CustMember.Reset();
            CustMember.SetRange("No.", MemberNo);
            CustMember.SetRange(Status, CustMember.Status::Active);
            if CustMember.FindFirst() then begin

                if LoanType = 'MSACCOLN' then
                    MaxAmt := '00|' + DelChr(Format(RegMngt.GetLoanMaxCreditLimitScoreQC(CustMember, LoanType, 30, 0)), '=', ',|.') else
                    MaxAmt := '00|' + DelChr(Format(RegMngt.GetDivLoanMaxCreditLimitScore(CustMember, LoanType, 30, 0)), '=', ',|.');

            end else begin
                MaxAmt := '00|Account not found'
            end;
        end else begin
            MaxAmt := '00|Null String'
        end;
    end;

    procedure SendFullStatement(MemberNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        Member: Record Member;
        CompanyInformation: Record "Company Information";
        Base64Conv: Codeunit "Base64 Convert";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        AttachInstr: InStream;
        AttachOutstr: OutStream;
        Base64Txt, FileName, Subject, EmailBody : Text;
        NewBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt">Dear %1 </p><p style="font-family:Verdana,Arial;font-size:10pt">Please find attached your Full Statement of Account from <strong>%2</strong> to <strong>%3</strong>.</p><p style="font-family:Verdana,Arial;font-size:10pt">To acess certified statement, please contact the Sacco.</p><p style="font-family:Verdana,Arial;font-size:10pt">Kind Regards,<br><p style="font-family:Verdana,Arial;font-size:10pt">%4</p>';
        Recipient: List of [Text];
        StatementOfAccount: Report "Standard Statement-All Account";
    begin
        CompanyInformation.Get();

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        if Member.FindFirst() then begin
            StatementOfAccount.SetTableView(Member);
            StatementOfAccount.GetDefaults(FromDate, ToDate);

            Subject := StrSubstNo('Full Statement from %1 to %2', Format(FromDate), Format(ToDate));
            Clear(Recipient);
            Recipient.Add(Member."E-Mail");
            FileName := 'FullStatement' + Format(FromDate) + '_' + Format(ToDate) + '.pdf';
            EmailBody := StrSubstNo(NewBody, Member.Name, Format(FromDate), Format(ToDate), CompanyInformation.Name);
            EmailMessage.Create(Recipient, Subject, EmailBody, true);

            TempBlob.CreateOutStream(AttachOutstr);
            if StatementOfAccount.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                TempBlob.CreateInStream(AttachInstr);
                Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                EmailMessage.AddAttachment(FileName, 'application/pdf', Base64Txt);
            end;
            if Email.Send(EmailMessage) then
                exit(true)
            else
                exit(false);
        end;
    end;

    procedure PostAccountTransfersLoan(AccToDebit: Code[100]; LoanNo: code[100]; AmtToPost: Decimal; ReferenceNo: Code[50]; PhoneNo: Code[20]; DescriptionTxt: Text[100]; ChargeAmt: Decimal) Response: Text
    var
        PLoan: Record Loans;

    begin
        RegmntAcc.Reset();
        RegmntAcc.SetRange("No.", AccToDebit);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            Response := '99|Account not Registered for Mobile Transaction';
            exit(Response)
        end;

        if (AmtToPost = 0) or (LoanNo = '') or (AccToDebit = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        PLoan.Reset();
        PLoan.SetRange("No.", LoanNo);
        if PLoan.FindFirst() then begin
            PLoan.CalcFields("Outstanding Balance");
            if PLoan."Outstanding Balance" = 0 then begin
                Response := '99|Failed.Loan Account has no outstanding baance';
                exit(Response)
            end;

        end;

        if AmtToPost <= TellerMngt.CalcAvailableBal(AccToDebit) then begin
            RegMngt.InitAccountTransferTxt(ReferenceNo, Today, AccToDebit, DescriptionTxt, AmtToPost, 'Mobile', TransType::" ",
            Today, 2, '', ReferenceNo, ReferenceNo, ChargeAmt, LoanNo);
            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                Response := Post.PerformPostOnAccountTransfers(Trans."Trace ID", 2, false);
            end else begin
                Response := '99|Failed'
            end
        end else begin
            Response := '99|Failed No enough fund for this transaction'
        end;
    end;

    procedure PostAccountTransfers(AccToDebit: Code[100]; AccToCredit: code[100]; AmtToPost: Decimal; ReferenceNo: Code[50]; PhoneNo: Code[20]; DescriptionTxt: Text[100]; ChargeAmt: Decimal) Response: Text
    var
        AccountType: Record "Product Factory";
        AccBanking: Record "Account Banking";
        TotalCharge: Decimal;
        JuniorTransType: Code[20];
        TellerMgt: Codeunit "Teller-Post (Yes/No)";
        ErrorOnExistNoCharge: Label 'No Charge type found associated with this account.';
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        Text0008: Label '99|No enough funds for this transaction';
    begin
        TotalCharge := 0;
        JuniorTransType := '';

        RegmntAcc.Reset();
        RegmntAcc.SetRange("No.", AccToDebit);
        RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
        RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
        if not RegmntAcc.FindFirst() then begin
            Response := '99|Account not Registered for Mobile Transaction';
            exit(Response)
        end;

        if (AmtToPost = 0) or (AccToCredit = '') or (AccToDebit = '') then begin
            Response := '99|Failed Null String';
            exit(Response)
        end;

        if AccBanking.Get(AccToDebit) then begin
            if AccountType.Get(AccBanking."Product Type") then
                if AccountType."Charge Subsiquent withdrawal" then begin
                    JuniorTransType := TellerMgt.getSubsiquenTransType(AccountType."Product ID");

                    if JuniorTransType = '' then Error(ErrorOnExistNoCharge);
                    TotalCharge := BnkMngt.CalculateTransactCharges(AmtToPost, JuniorTransType, 1, true);
                    if AccBanking."Next Withdrawal Date" <> 0D then begin

                        if Today <= AccBanking."Next Withdrawal Date" then begin
                            if AmtToPost > TellerMgt.CalcAvailableBal(AccBanking."No.") then
                                exit(Text0008);
                        end;
                    end
                end;
        end;

        if AmtToPost <= TellerMngt.CalcAvailableBal(AccToDebit) then begin
            RegMngt.InitAccountTransferTxt(ReferenceNo, Today, AccToDebit,
            DescriptionTxt, AmtToPost, 'Mobile', TransType::" ",
            Today, 2, '', ReferenceNo, ReferenceNo, ChargeAmt, AccToCredit);
            Trans.Reset();
            Trans.SetRange("Trace ID", ReferenceNo);
            if Trans.Find('-') then begin
                Response := Post.PerformPostOnAccountTransfers(Trans."Trace ID", 1, false);
            end else begin
                Response := '99|Failed'
            end
        end else begin
            Response := '99|Failed No enough fund for this transaction'
        end;
    end;

    procedure SendFullStatementFreq(MemberNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        Member: Record Member;
        CompanyInformation: Record "Company Information";
        Base64Conv: Codeunit "Base64 Convert";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        AttachInstr: InStream;
        AttachOutstr: OutStream;
        Base64Txt, FileName, Subject, EmailBody : Text;
        NewBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt"><b>Dear %1 </br></p><p style="font-family:Verdana,Arial;font-size:10pt">Thank you for choosing %2 as your financial solutions provider of choice. Please find attached your %3 detailed statement for the period <strong>%4</strong> to <strong>%5</strong>.</p><p style="font-family:Verdana,Arial;font-size:10pt"><br>For any reservations, kindly contact us through our official email, Ubora@kebs.org or call us on +254 700 156 971</br></p><p style="font-family:Verdana,Arial;font-size:10pt">Kind Regards,<br><p style="font-family:Verdana,Arial;font-size:10pt">%6</br></p><p style="font-family:Verdana,Arial;font-size:10pt">This is a system generated email please do not reply. For any clarifications, contact us through the email, ubora@kebs.org or call us on 254700156971</br></p>';
        Recipient: List of [Text];
        StatementOfAccount: Report "Standard Statement-Alt Channel";
    begin

        CompanyInformation.Get();

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetFilter("Notification Option", '%1 | %2', Member."Notification Option"::"All Notification",
        Member."Notification Option"::Statement);
        if Member.FindFirst() then begin
            if Member."E-Mail" <> '' then begin
                StatementOfAccount.SetTableView(Member);
                StatementOfAccount.GetDefaults(FromDate, ToDate);
                Subject := StrSubstNo('Full Statement from %1 to %2', Format(FromDate), Format(ToDate));
                Clear(Recipient);

                Recipient.Add(Member."E-Mail");
                FileName := 'FullStatement' + Format(FromDate) + '_' + Format(ToDate) + '.pdf';
                EmailBody := StrSubstNo(NewBody, Member.Name, CompanyInformation.Name, CompanyInformation.Name, Format(FromDate), Format(ToDate), CompanyInformation.Name);
                EmailMessage.Create(Recipient, Subject, EmailBody, true);
                TempBlob.CreateOutStream(AttachOutstr);

                if StatementOfAccount.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                    TempBlob.CreateInStream(AttachInstr);
                    Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                    EmailMessage.AddAttachment(FileName, 'Application/pdf', Base64Txt);
                end;
                if Email.Send(EmailMessage) then
                    exit(true)
                else
                    exit(false);
            end;
        end;
    end;


    procedure SendDividendSlip(MemberNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        Member: Record Member;
        CompanyInformation: Record "Company Information";
        Base64Conv: Codeunit "Base64 Convert";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        AttachInstr: InStream;
        AttachOutstr: OutStream;
        Base64Txt, FileName, Subject, EmailBody : Text;
        NewBody: Label '<p style="font-family:Verdana,Arial;font-size:10pt"><b>Dear %1 </br></p><p style="font-family:Verdana,Arial;font-size:10pt">Thank you for choosing %2 as your financial solutions provider of choice. Please find attached your %3 dividend slip for the period <strong>%4</strong> to <strong>%5</strong>.</p><p style="font-family:Verdana,Arial;font-size:10pt"><br>For any reservations, kindly contact us through our official email, Ubora@kebs.org or call us on +254 700 156 971</br></p><p style="font-family:Verdana,Arial;font-size:10pt">Kind Regards,<br><p style="font-family:Verdana,Arial;font-size:10pt">%6</br></p><p style="font-family:Verdana,Arial;font-size:10pt">This is a system generated email please do not reply. For any clarifications, contact us through the email, ubora@kebs.org or call us on 254700156971</br></p>';
        Recipient: List of [Text];
        AccountCredits: Record "Account Credit";
        acmgt: Record "Account Banking";
        Divprogression: Record "Dividend Progression";
        DivProgressionslip: Report "Dividend Slip Portal";
        DivproMgt: Codeunit "Div. Process Mgt.";
        DividendSetUp: Record "Dividend SetUp";
        InterestOptions: Enum "Rcv12 Dividend Interest Option";
        DivProcMgt: Codeunit "Dividend Process";

    begin

        CompanyInformation.Get();

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        if Member.FindFirst() then begin
            if Member."E-Mail" <> '' then begin

                Dividendsetup.Get();
                Dividendsetup.TestField("Start Date");
                Dividendsetup.TestField("End Date");
                InterestOptions := InterestOptions::"Monthly Accrual";
                DivProcMgt.fngetIndividualCustDiv(Member."No.", 0, Dividendsetup."Start Date",
                Dividendsetup."End Date", InterestOptions);

                Divprogression.SetFilter("Member No", Member."No.");
                Divprogression.SetRange("Header No.", 'ALTC/' + Format(Dividendsetup."Start Date"));
                DivProgressionslip.SetTableView(Divprogression);
                Subject := StrSubstNo('Dividend Slip for %1 to %2', Format(Dividendsetup."Start Date"), Format(Dividendsetup."End Date"));
                Clear(Recipient);

                Recipient.Add(Member."E-Mail");
                FileName := 'DividendSlip' + Format(Dividendsetup."Start Date") + '_' + Format(Dividendsetup."End Date") + '.pdf';
                EmailBody := StrSubstNo(NewBody, Member.Name, CompanyInformation.Name, CompanyInformation.Name, Format(DividendSetUp."Start Date"), Format(DividendSetUp."End Date"), CompanyInformation.Name);
                EmailMessage.Create(Recipient, Subject, EmailBody, true);
                TempBlob.CreateOutStream(AttachOutstr);

                if DivProgressionslip.SaveAs('', ReportFormat::Pdf, AttachOutstr) then begin
                    TempBlob.CreateInStream(AttachInstr);
                    Base64Txt := Base64Conv.ToBase64(AttachInstr, true);
                    EmailMessage.AddAttachment(FileName, 'DivSlip/pdf', Base64Txt);
                end;

                if Email.Send(EmailMessage) then
                    exit(true)
                else
                    exit(false);
            end;
        end;
    end;

    procedure GetAccountCardNo(CardNo: Code[100]) Response: Text
    var

    begin
        if CardNo <> '' then begin

            AccBanking.Reset();
            AccBanking.SetRange("ATM No.", CardNo);
            AccBanking.SetRange(Status, AccBanking.Status::Active);
            AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
            if AccBanking.FindFirst() then begin

                RegmntAcc.Reset();
                RegmntAcc.SetRange("No.", AccBanking."No.");
                RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                RegmntAcc.SetRange("Card Status", RegmntAcc."Card Status"::Approved);
                if RegmntAcc.FindFirst() then begin
                    Response := '00|' + AccBanking."No." + '|' + AccBanking."Member No.";
                    exit(Response)

                end else begin
                    Response := '99|Account not Registered for ATM Transaction';
                    exit(Response)

                end;
            end
            else begin
                Response := '99|No Card No attached to this account';
                exit(Response)
            end;
        end else begin
            Response := '99|Null String';
            exit(Response)

        end;
    end;

    procedure GetMemberNo(LoanNo: Code[50]) ResponseTxt: Text
    Var
        Loan: Record Loans;
    begin

        Loan.Reset();
        Loan.SetRange("No.", LoanNo);
        if Loan.FindFirst() then begin
            //Loan."Account No.":=ResponseTxt;  
            ResponseTxt := Loan."Account No." + '|' + Loan."ID No.";
        end;
        exit(ResponseTxt)
    end;



    procedure ConfirmMemberNo(ReferenceNo: Code[30]; MemNo: Code[30]) ResponseMsg: Text

    var
        FosaAcc: Record Member;

    begin
        FosaAcc.Reset();
        FosaAcc.SetRange("No.", MemNo);
        if FosaAcc.FindFirst() then begin
            ResponseMsg := '00|' + FosaAcc.Name;
        end else begin
            ResponseMsg := '99|No Member'
        end;
    end;

    Procedure ConfirmMemberMemberAccounts(SourceNo: Code[30]; MemNo: Code[30]) ResponseMsg: Text

    var
        ProdF: Record "Product Factory";
        Account: Record "Account Banking";
        BosAAcc: Record "Account Credit";
        JuniorAcc: Code[20];
    begin
        ProdF.Reset();
        ProdF.SetRange("Search Code", SourceNo);
        if ProdF.FindFirst() then begin
            case SourceNo of
                'FS':
                    begin
                        Account.Reset();
                        Account.SetRange("Member No.", MemNo);
                        Account.SetRange("Account Category", ProdF."Account Category");
                        if Account.FindFirst() then begin
                            ResponseMsg := '00|' + Account.Name;
                        end else begin
                            ResponseMsg := '99|No Member Account found'
                        end;
                    end;
                'JR':
                    begin

                        JuniorAcc := '';
                        JuniorAcc := ProdF."Account No. Prefix" + MemNo;
                        Account.Reset();
                        Account.SetRange("No.", JuniorAcc);
                        Account.SetRange("Account Category", ProdF."Account Category");
                        if Account.FindFirst() then begin
                            ResponseMsg := '00|' + Account.Name;
                        end else begin
                            ResponseMsg := '99|No Member Account found'
                        end;
                    end;
                'DP',
                'SC':
                    begin
                        BosAAcc.Reset();
                        BosAAcc.SetRange("Member No.", MemNo);
                        BosAAcc.SetRange("Account Category", ProdF."Account Category");
                        if BosAAcc.FindFirst() then begin
                            ResponseMsg := '00|' + BosAAcc.Name;
                        end else begin
                            ResponseMsg := '99|No Member Account found'
                        end;
                    end;
            end;
        end else begin
            ResponseMsg := 'Keyword not found'
        end;
    end;

    procedure ValidateAllAccount(AccountNo: Code[100]): Boolean
    var
        AccBanking: Record "Account Banking";
        AcBosa: Record "Account Credit";
    begin

        if AccountNo = '' then exit(false);

        AcBosa.Reset();
        AcBosa.SetRange("No.", AccountNo);
        AcBosa.SetFilter(Status, '<>%1 & <>%2', AcBosa.Status::Withdrawn, AcBosa.status::Deceased);
        if AcBosa.FindFirst() then begin
            exit(true)
        end else begin

            AccBanking.Reset();
            AccBanking.SetRange("No.", AccountNo);
            AccBanking.SetFilter(Status, '<>%1 & <>%2', AccBanking.Status::Withdrawn, AccBanking.status::Deceased);
            AccBanking.SetFilter("Account Category", '<>%1', AccBanking."Account Category"::"Certificates of Deposit");
            if AccBanking.FindFirst() then begin
                exit(true)
            end else begin
                exit(false)
            end;
        end;
    end;

    procedure TerminateUnresponsiveTransact(TraceID: Code[100]): Text[250]
    var

        GLRegister: Record "G/L Register";
        Text003: Label '00|Success The entries were successfully reversed.';
        Text004: Label '99|Failed The entries reversal failed.';
        Text005: Label '99|Failed No related entries found.';
        Text006: Label '99|Failed Null value posted.';
        Text007: Label '99|Failed Related Entries already posted.';
        BnkLedgerEntry: Record "Bank Account Ledger Entry";
        ReversalEntry: Record "ATM Transaction";
        TempReversalEntry: Record "ATM Transaction";
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        AltChannel: Record "Alt. Channel Entry";
    begin
        if TraceID <> '' then begin

            AltChannel.Reset();
            AltChannel.SetRange("Trace ID", TraceID);
            if AltChannel.Find('-') then begin
                exit(Text007)

            end else begin

                ReversalEntry.Reset();
                ReversalEntry.SetRange(Posted, false);
                ReversalEntry.SetRange("Trace ID", TraceID);
                ReversalEntry.SetRange("Transaction Charge Code", '430000');
                if ReversalEntry.FindFirst() then begin
                    ReversalEntry.Reversed := true;
                    ReversalEntry."Reversal Trace ID" := ReversalEntry."Trace ID";
                    ReversalEntry."Reversed Posted" := true;
                    ReversalEntry.Posted := true;
                    ReversalEntry."Posted By" := UserId;
                    ReversalEntry."Posting Date" := Today;
                    ReversalEntry.Modify(true)

                end else begin
                    exit(Text005)
                end;

                TempReversalEntry.Reset();
                TempReversalEntry.SetRange(Reversed, true);
                TempReversalEntry.SetRange("Trace ID", TraceID);
                TempReversalEntry.SetRange("Reversal Trace ID", TraceID);
                TempReversalEntry.SetRange("Transaction Charge Code", '430000');
                if TempReversalEntry.FindFirst() then begin
                    exit(Text003)
                end else begin
                    exit(Text004)
                end;
            end;
        end else begin
            exit(Text006)
        end;
    end;

    procedure GetOnlineMemberDetails(MemberNo: Code[100]) MemberInfo: Text[2048]
    begin
        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.Find('-') then begin
            MemberInfo := '<Name>' + Member.Name + '</Name>' + '<PhoneNo>' +
            Member."Mobile Phone No" + '</PhoneNo>';
            exit(MemberInfo)
        end else begin
            MemberInfo := 'Account Not Found';
            exit(MemberInfo)
        end;
    end;

    procedure GetActiveLoanProduct() LoanProducts: Text[2048]
    begin

        PFactory.Reset();
        PFactory.SetRange(Status, PFactory.Status::Active);
        PFactory.SetRange("Allow Online Application", true);
        PFactory.SetRange("Product Class", PFactory."Product Class"::Loan);
        PFactory.SetFilter("Loan Span", '<>%1 & <>%2', PFactory."Loan Span"::"Mobile Loan",
        PFactory."Loan Span"::Dividends);
        if PFactory.FindSet() then begin
            repeat
                LoanProducts := LoanProducts + '<ID>' + PFactory."Product ID" +
                '<Name>' + PFactory.Description +
                '<Period>' + format(PFactory."Ordinary Default Intallments");
            Until PFactory.Next() = 0;
            exit(LoanProducts)
        end else begin
            exit('No Loan Product found within specified Parameters')
        end;
    end;

    procedure WebLoanApplication(ApplicNo: code[100]; MemberNo: Code[100]; ProductType: Code[20]; AmountApplied: Decimal; Narration: Text[100]) Response: Text[150]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        Post: Codeunit "Mngt. Post Alt. Channels";
        TransCharges: Record "Transaction Charge";
        TransTypes: Record "Transaction Types";
        TellerTransType: Enum TellerTypes;
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        RegmntAcc: Record "Account (Procedure)";
        LnPortal: Record "Loan Application-Portal";
        PostedPortal: Record "Loan Application-Portal";

    begin

        if (MemberNo = '') or (ProductType = '') or (AmountApplied = 0) then begin
            Response := '99| Null Response';
            exit(Response)
        end;

        PostedPortal.Reset();
        PostedPortal.SetRange("Application No.", ApplicNo);
        if PostedPortal.FindFirst() then begin
            exit('99|Application No. Already exists')
        end;

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Capital");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");

                if AccountTypes.Get(AccCredit."Product Type") then begin
                    if AccCredit."Balance (LCY)" < AccountTypes."Minimum Balance" then begin
                        Response := '99|Member has not attained Minimum share capital of KES 50,000';
                        exit(Response)
                    end else begin

                        AccCredit.Reset();
                        AccCredit.SetRange("Member No.", Member."No.");
                        AccCredit.SetRange(Status, AccCredit.Status::Active);
                        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                        if AccCredit.FindFirst() then begin
                            AccCredit.CalcFields("Balance (LCY)");
                            if AccCredit."Balance (LCY)" > 0 then begin

                                LnPortal.Init();
                                LnPortal."No." := '';
                                LnPortal.Validate("Application No.", ApplicNo);
                                LnPortal.Validate("Account No.", MemberNo);
                                LnPortal.Validate("Product Type", ProductType);
                                LnPortal.Validate("Requested Amount", AmountApplied);
                                LnPortal.Source := LnPortal.Source::Credit;
                                LnPortal.Remarks := Narration;
                                LnPortal."Application Source" := LnPortal."Application Source"::Web;
                                LnPortal."Application Type" := LnPortal."Application Type"::Normal;
                                LnPortal.Insert(true);

                                PostedPortal.Reset();
                                PostedPortal.SetRange("Application No.", ApplicNo);
                                if PostedPortal.FindFirst() then begin
                                    Response := '00|' + PostedPortal."No.";
                                    exit(Response)
                                end else begin
                                    Response := '99|Null Application Code.';
                                end;

                            end else begin
                                Response := '99|Member does not have shares';
                                exit(Response)
                            end;
                        end else begin
                            Response := '99|Deposit Account not Found';
                            exit(Response)
                        end;

                    end;

                end else begin
                    Response := '99|Shares capital account not found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Share capital account not found';
                exit(Response)
            end;

        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

    procedure getguarantorInfo(ApplicNo: Code[100]; MemberNo: Code[100]) Response: Text[150]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        AccountTypes: Record "Product Factory";
        LnPortal: Record "Loan Application-Portal";
        Agreement: Record "Loan Agreement-Portal";
        LnSecurity: Record "Loan Agreement-Portal";
    begin

        if (ApplicNo = '') or (MemberNo = '') then begin
            Response := '99|Null Inputs';
            exit(Response)
        end;

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");
                if AccCredit."Balance (LCY)" > 0 then begin

                    LnPortal.Reset();
                    LnPortal.SetRange("No.", ApplicNo);
                    if LnPortal.FindFirst() then begin

                        Agreement.Init();
                        Agreement."No." := LnPortal."No.";
                        Agreement."Security Type" := Agreement."Security Type"::Guarantor;
                        Agreement.Validate("Loan No.", LnPortal."Application No.");
                        Agreement.Validate("Account No.", AccCredit."No.");
                        Agreement.Insert(true);

                        LnSecurity.Reset();
                        LnSecurity.SetRange("No.", LnPortal."No.");
                        if LnSecurity.FindFirst() then begin
                            Response := '00|Success|' + LnSecurity."No.";
                            exit(Response)
                        end else begin
                            Response := '99|Loan No. not found';
                            exit(Response)
                        end;
                    end else begin
                        Response := '99|Application No. not found';
                        exit(Response)
                    end;
                end else begin
                    Response := '99|Member has no shares';
                    exit(Response)
                end;
            end else begin
                Response := '99|Member does not have shares';
                exit(Response)
            end;

        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

    procedure OnlineLoanApplication(ApplicNo: code[100]; MemberNo: Code[100]; ProductType: Code[20]; AmountApplied: Decimal; AccountNo: Code[100]) Response: Text[150]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        Post: Codeunit "Mngt. Post Alt. Channels";
        TransCharges: Record "Transaction Charge";
        TransTypes: Record "Transaction Types";
        TellerTransType: Enum TellerTypes;
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        RegmntAcc: Record "Account (Procedure)";
        LnPortal: Record "Online Loan Temp.";

    begin

        if fnPassDocumentID(ApplicNo, MemberNo, ProductType, AmountApplied, AccountNo) then begin
            exit('99|Null String')
        end;

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            AccountTypes.Reset();
            AccountTypes.SetRange(Status, AccountTypes.Status::Active);
            AccountTypes.SetRange("Product ID", AccCredit."Product Type");
            if not AccountTypes.FindFirst() then begin
                exit('99|Product ID not found')
            end;

            LnPortal.Reset();
            LnPortal.SetRange("Member  No.", Member."No.");
            LnPortal.SetRange("Product Type", AccountTypes."Product ID");
            LnPortal.SetFilter("Approval Status", '%1 | %2', LnPortal."Approval Status"::Open,
            LnPortal."Approval Status"::"Pending Approval");
            if LnPortal.FindFirst() then begin
                Response := '99|Existing Appication still on queue' + LnPortal."API Code";
            end;

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", Member."No.");
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Capital");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");
                AccountTypes.Reset();
                AccountTypes.SetRange("Product ID", AccCredit."Product Type");
                if AccountTypes.FindFirst() then begin
                    if AccCredit."Balance (LCY)" < AccountTypes."Minimum Balance" then
                        Response := '99|Member has not attained Minimum share capital of KES 50,000';
                    exit(Response)
                end;
            end;

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", AccountNo);
            AccCredit.SetRange(Status, AccCredit.Status::Active);
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");
                if AccCredit."Balance (LCY)" > 0 then begin

                    LnPortal.Init();
                    LnPortal.Validate("API Code", ApplicNo);
                    LnPortal.Validate("Member  No.", MemberNo);
                    LnPortal.Validate("Product Type", ProductType);
                    LnPortal.Validate("Requested Amount", AmountApplied);
                    LnPortal.Validate("Account No. (Guarantor)", AccountNo);
                    LnPortal.Insert(true);

                end else begin
                    Response := '99|Member does not have shares';
                    exit(Response)
                end;
            end else begin
                Response := '99|Account not Found';
                exit(Response)
            end;

            LnPortal.Reset();
            LnPortal.SetRange("API Code", ApplicNo);
            if LnPortal.FindFirst() then begin
                Response := '00|Success|' + LnPortal."API Code";
                exit(Response)
            end else begin
                Response := '99|Appication not Found';
                exit(Response)
            end;
        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

    procedure getappliedLoanDetail(ApiCode: Code[100]; MemberNo: Code[100]) Response: Text[250]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        CreditAcc: Record Loans;
        PFactory: Record "Product Factory";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        RegMngt: Codeunit "Register Management";
        AccountTypes: Record "Product Factory";
        Post: Codeunit "Mngt. Post Alt. Channels";
        TransCharges: Record "Transaction Charge";
        TransTypes: Record "Transaction Types";
        TellerTransType: Enum TellerTypes;
        TransType: Enum MobileTransactionTypes;
        Trans: Record "ATM Transaction";
        RegmntAcc: Record "Account (Procedure)";
        LnPortal: Record "Loan Application-Portal";
    begin

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin

            LnPortal.Reset();
            LnPortal.SetRange("Account No.", Member."No.");
            LnPortal.SetRange("No.", ApiCode);
            if LnPortal.FindFirst() then begin

                Response := '<No.>' + Format(LnPortal."No.") + '</No.>' + '<Api Code>' +
                LnPortal."Application No." + '</Api Code>' + '<Product Type>' +
                LnPortal."Product Type" + '</Product Type>' + '<Applied Amount>' +
                Format(LnPortal."Requested Amount") +
                '</Applied Amount>' + '<Loan Status>' +
                Format(LnPortal."Approval Status") + '</Loan Status>';

            end else begin
                exit('99|No Application found');
            end;
        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;

    procedure updateCancelExistApplication(apicode: Code[100]; MemberNo: Code[100]; ProductType: Code[20]; AmountApplied: Decimal; PostingType: Option " ",Update,Cancel) Response: Text[250]
    var
        Member: Record Member;
        AccBanking: Record "Account Banking";
        LnPortal: Record "Loan Application-Portal";
    begin

        Member.Reset();
        Member.SetRange("No.", MemberNo);
        Member.SetRange(Status, Member.Status::Active);
        if Member.FindFirst() then begin
            case PostingType of
                PostingType::Update:
                    begin

                        LnPortal.Reset();
                        LnPortal.SetRange("No.", apicode);
                        LnPortal.SetRange("Account No.", Member."No.");
                        LnPortal.SetRange("Approval Status", LnPortal."Approval Status"::Open);
                        if LnPortal.FindFirst() then begin

                            if LnPortal."Product Type" <> ProductType then
                                LnPortal.Validate("Product Type", ProductType);
                            if LnPortal."Requested Amount" <> AmountApplied then
                                LnPortal.Validate("Requested Amount", AmountApplied);
                            LnPortal.Modify(true);

                            exit('00|Success');
                        end else begin
                            exit('99|No Application found');
                        end;
                    end;
                PostingType::Cancel:
                    begin

                        LnPortal.Reset();
                        LnPortal.SetRange("No.", apicode);
                        LnPortal.SetRange("Account No.", MemberNo);
                        if LnPortal.FindFirst() then begin
                            LnPortal.Validate("Approval Status", LnPortal."Approval Status"::Rejected);
                            LnPortal.Modify(true)
                        end;
                    end;
                PostingType::" ":
                    begin
                        Response := 'Case condition not implemented.'
                    end
            end;
        end else begin
            Response := '99|Member not Found';
            exit(Response)
        end;
    end;



    procedure fnPassDocumentID(ApplicNo: code[100]; MemberNo: Code[100]; ProductType: Code[20]; AmountApplied: Decimal; AccountNo: Code[100]): Boolean
    begin
        if (ApplicNo = '') or (MemberNo = '') or (ProductType = '') or (AccountNo = '') then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure CreateNextOfKinAccTxt(AccNo: Code[50]; CustName: Text; RelationShip: Code[50]; Beneficiary: Boolean; Allocations: Decimal; KinID: Code[10]; MobileNo: Code[50]; DatOfBirth: Date; ApplicCode: Code[100]; EmailAddress: Code[50]; KinAddress: Code[50]; Gender: Enum CustGender) AccountInfo: Text
    Var
        Applic: Record "Next of KIN Application";
        ExistsApplic: Record "Next of KIN Application";
    begin


        ExistsApplic.Reset();
        ExistsApplic.SetRange("Account No", AccNo);
        ExistsApplic.SetRange(Name, CustName);
        if ExistsApplic.FindFirst() then begin
            AccountInfo := '99|Application already exist|' + ExistsApplic."Account No";
            exit(AccountInfo)
        end;

        RegMngt.CreateNextOfKinAccTxt(AccNo, CustName, RelationShip, Beneficiary,
        Allocations, KinID, MobileNo, DatOfBirth,
        ApplicCode, EmailAddress, KinAddress, Gender);

        Applic.Reset();
        Applic.SetRange("Application No.", ApplicCode);
        if Applic.FindFirst() then begin
            AccountInfo := '00|Success|' + Applic."Account No";
        end else begin
            AccountInfo := '99|' + 'Application failed';
        end;
    end;

    procedure fnMemberSelfOnboard(ApplcCode: Code[100]; IDNo: Code[20]; AccName: Text[150]; DateOfBirth: Date; Gender: Enum CustGender; MaritalStatus: Enum MaritalStatus; MobilePhone: Code[20]; EmailAddress: Code[150]; PayrollNo: Code[20]; EmpCode: Code[50]; PinNo: Code[20]; Residence: Code[50]; SalesPerson: Code[100]) Response: Text[150]
    var
        CustRecord: Record Member;
        Application: Record "Member Application";
        Gensetup: Record "General Set-Up";
        DateofBirthError: Label 'This date cannot be greater than today.';
        MinimumAgeError: Label 'Date of birth must not be less than %1';
        CustType: Enum CreditCustomerType;
    begin
        Gensetup.Get();

        if (AccName = '') or (DateOfBirth = 0D) or (IDNo = '') then begin
            exit('99|Null Value');
        end;

        if DateOfBirth > Today then begin
            Response := '99|' + DateofBirthError;
            exit(Response);

        end;

        if CalcDate(Gensetup."Min. Member Age", DateOfBirth) > Today then begin
            Response := '99|' + DateofBirthError;
            exit(Response);
        end;

        if PinNo <> '' then begin

            CustRecord.Reset();
            CustRecord.SetRange("PIN No.", PinNo);
            if CustRecord.FindFirst() then begin
                exit('99|PIN No. Already Registered');
            end
        end;

        if PayrollNo <> '' then begin

            CustRecord.Reset();
            CustRecord.SetRange("Employer Code", EmpCode);
            CustRecord.SetRange("Payroll/Staff No.", PayrollNo);
            if CustRecord.FindFirst() then begin
                exit('99|Payroll No. Already Registered');
            end
        end;

        if MobilePhone <> '' then begin
            CustRecord.Reset();
            CustRecord.SetRange("Mobile Phone No", MobilePhone);
            if CustRecord.FindFirst() then begin
                exit('99|Phone No. Already Registered');
            end
        end;

        if IDNo <> '' then begin

            Application.Reset;
            Application.SetRange("ID No.", IDNo);
            Application.SetFilter("Approval Status", '<>%1 & <>%2', Application."Approval Status"::Posted, Application."Approval Status"::Rejected);
            if Application.FindSet() then begin
                Response := '99|There is a pending application |' + Application."No.";
                exit(Response);
            end;

            CustRecord.Reset();
            CustRecord.SetRange("ID No.", IDNo);
            if CustRecord.FindFirst() then begin
                exit('99|ID No. Already Registered');
            end else begin

                RegMngt.CreateMembAccTxt(SalesPerson, PayrollNo, AccName, IDNo,
                Gender, PinNo, 'MEMBER', MobilePhone, MobilePhone, DateOfBirth, MaritalStatus,
                CustType::Individual, Today, 0, Residence, EmailAddress, ApplcCode, 0);

                Application.Reset();
                Application.SetRange("Application Code", ApplcCode);
                if Application.FindFirst() then begin
                    Response := '00|Success|' + Application."No.";
                    exit(Response)
                end else begin
                    exit('99|No Entry found');
                end;
            end;
        end else begin
            exit('99|ID No. cannot be null');
        end;
    end;

    procedure fnGetLoanPortalDetails(MemberNo: Code[100]) Response: Text[2048]
    Var
        LoanApplic: Record "Loan Application";
        LnPortal: Record "Online Loan Temp.";
        CustRecord: Record Member;
    begin
        if MemberNo <> '' then begin

            CustRecord.Reset();
            CustRecord.SetRange("No.", MemberNo);
            CustRecord.SetRange(Status, CustRecord.Status::Active);
            if CustRecord.FindFirst() then begin

                LnPortal.Reset();
                LnPortal.SetRange("Member  No.", MemberNo);
                if LnPortal.FindFirst() then begin
                    Response := '<No.>' + Format(LnPortal."API Code") + '</No.>' + '<Product Type>' +
                    LnPortal."Product Type" + '</Product Type>' + '<Applied Amount>' + Format(LnPortal."Requested Amount") +
                    '</Applied Amount>' + 'Loan Status' + Format(LnPortal."Approval Status") + '</Loan Status>';
                end else begin
                    exit('99|No Application found');
                end;

            end else begin
                exit('99|Account No. not found');
            end;
        end else begin
            exit('99|ID No. cannot be null');
        end;
    end;



    procedure fnGetAccOnlineLoanStatus(MemberNo: Code[100]) Response: Text[2048]
    Var
        LoanApplic: Record "Loan Application";
        LnPortal: Record "Loan Application-Portal";
        CustRecord: Record Member;
    begin
        if MemberNo <> '' then begin

            CustRecord.Reset();
            CustRecord.SetRange("No.", MemberNo);
            CustRecord.SetRange(Status, CustRecord.Status::Active);
            if CustRecord.FindFirst() then begin

                LnPortal.Reset();
                LnPortal.SetRange("Account No.", MemberNo);
                if LnPortal.FindFirst() then begin

                    Response := '<No>' + LnPortal."No." + '</No>' + '<ProductType>' +
                        LnPortal."Product Description" + '</ProductType>' +
                        '<AppliedAmount>' + DelChr(Format(LnPortal."Approved Amount"), '=', '.|,') + '</AppliedAmount>' +
                        '<LoanStatus>' + Format(LnPortal."Approval Status") + '</LoanStatus>';

                end else begin
                    exit('99|Application still channeled for verification|' + LnPortal."No.");
                end;
            end else begin
                exit('99|Account No. not found');
            end;
        end else begin
            exit('99|ID No. cannot be null');
        end;
    end;

    procedure guarantorWorkFlowOnApproveReject(LoanNo: Code[100]; MemberNo: Code[100]; Status: Boolean) Response: Text[2048]
    var
        Aggreement: Record "Loan Agreement-Portal";
        AccountCredt: Record "Account Credit";
    begin

        if (LoanNo = ' ') or (MemberNo = '') then begin
            Response := '99|Null String';
            exit(Response);
        end;
        case Status of
            true:
                begin

                    AccountCredt.Reset();
                    AccountCredt.SetRange("Member No.", MemberNo);
                    AccountCredt.SetRange("Account Category", AccountCredt."Account Category"::"Shares Deposit");
                    if AccountCredt.FindFirst() then begin

                        Aggreement.Reset();
                        Aggreement.SetRange("No.", LoanNo);
                        Aggreement.SetRange("Account No.", AccountCredt."No.");
                        if Aggreement.FindFirst() then begin
                            Aggreement."Approval Status" := Aggreement."Approval Status"::Approved;
                            Aggreement.Modify(true);
                            Response := '00|Success|' + format(Aggreement."Approval Status");
                            exit(Response);
                        end else begin
                            Response := '99|Loan Account not found';
                            exit(Response)
                        end;
                    end else begin
                        Response := '99|Account not found';
                        exit(Response)
                    end;
                end;
            false:
                begin

                    AccountCredt.Reset();
                    AccountCredt.SetRange("Member No.", MemberNo);
                    AccountCredt.SetRange("Account Category", AccountCredt."Account Category"::"Shares Deposit");
                    if AccountCredt.FindFirst() then begin

                        Aggreement.Reset();
                        Aggreement.SetRange("No.", LoanNo);
                        Aggreement.SetRange("Account No.", AccountCredt."No.");
                        if Aggreement.FindFirst() then begin
                            Aggreement."Approval Status" := Aggreement."Approval Status"::Rejected;
                            Aggreement.Modify(true);
                            Response := '00|Success|' + format(Aggreement."Approval Status");
                            exit(Response);
                        end else begin
                            Response := '99|Loan Account not found';
                            exit(Response)
                        end;
                    end else begin
                        Response := '99|Account not found';
                        exit(Response)
                    end;
                end;
        end;

    end;

    procedure getLoanguarantorList(LoanNo: Code[100]) Response: Text[2048]
    var
        Loans: Record Loans;
        Aggreement: Record "Loan Agreement-Portal";

    begin

        Aggreement.Reset();
        Aggreement.SetRange("No.", LoanNo);
        if Aggreement.FindSet() then begin
            repeat
                Response := Response + '<Guarantor>' + '<AccountNo>' + Aggreement."Account No." +
                '</AccountNo>' + '<Name>' + Aggreement.Name + '</Name>' + '<Status>' +
                Format(Aggreement."Approval Status") + '</Status>' + '</Guarantor>';
            until Aggreement.Next() = 0;
        end;
    end;

    procedure getMemberLoanguaranteed(MemberNo: Code[100]) ResponseMessage: Text[2048]
    var
        Loans: Record "Loan Application-Portal";
        Aggreement: Record "Loan Agreement-Portal";
        TempResponse: BigText;
        LoanNo: Code[100];
        AmountGuaranteed: Decimal;
        Minicount: integer;
        CustRec: Record "Account Credit";
    begin

        CustRec.Reset();
        CustRec.SetRange("Member No.", MemberNo);
        CustRec.SetRange("Account Category", CustRec."Account Category"::"Shares Deposit");
        if CustRec.FindFirst() then begin

            Aggreement.Reset();
            Aggreement.SetRange("Account No.", CustRec."No.");
            if Aggreement.FindSet() then begin
                repeat
                    if Loans.Get(Aggreement."No.") then begin
                        ResponseMessage := ResponseMessage + Aggreement."No." + '|' + Loans."Account No." +
                        '|' + Loans."Account Name" + '|' + Loans."Product Description" + '|' +
                        Format(Loans."Approved Amount") + '|' + Format(Aggreement."Approval Status") + '#';
                    end;
                    Minicount := Minicount + 1;
                    if Minicount > 20 then exit
                Until Aggreement.Next() = 0;
                exit(ResponseMessage)
            end else begin
                exit('99|Guarantor not found')
            end;
        end else begin
            exit('99|Account not found')
        end;
    end;

    procedure GenerateLoanSchedule(LoanNo: Code[20]): Text
    begin

    end;

    procedure fngetMemberLoanguaranteed(MemberNo: Code[100]): Text
    var
        ResponseCode: Code[100];
        ResponseMessage: BigText;
        Loans: Record "Loan Application-Portal";
        Aggreement: Record "Loan Agreement-Portal";
        TempResponse: BigText;
        LoanNo: Code[100];
        AmountGuaranteed: Decimal;
        AmountApp: Decimal;
    begin

        Clear(ResponseMessage);
        Clear(TempResponse);
        Clear(ResponseCode);

        ResponseCode := '00';

        Aggreement.Reset();
        Aggreement.SetRange("Member No. (Loanee)", MemberNo);
        if Aggreement.FindSet() then begin
            repeat
                if Loans.Get(Aggreement."No.") then begin
                    TempResponse.AddText('<No>' + Loans."No." + '</No>' + '<AppliedAmount>' + DelChr(Format(Loans."Approved Amount"), '=', ',|.') + '</Amountapplied>');
                    TempResponse.AddText('</LoanNo>');
                end;
            Until Aggreement.Next() = 0;
        end else begin
            exit('99|Account not found')
        end;

        if StrLen(format(TempResponse)) > 1 then
            ResponseMessage.AddText(CopyStr(Format(TempResponse), 1, StrLen(Format(TempResponse)) - 1));
        exit(format(ResponseMessage));
    end;

    procedure PostEftTransfer(MemberNo: Code[100]; AmountPost: Decimal; SourceOfFunds: Enum SourceOfFunds; Remarks: Text[150]; Bnkcode: Code[50]; BnkBranch: Text[150]; ExtAccNo: Code[150]; ExtAccName: Text[150]; ContBen: Text[150]; PhycAdress: Text[150]; SwiftCode: Code[50]) Response: Text[250]
    var
        EftHeader: Record "EFT Transfer Header";
        EftHeader2: Record "EFT Transfer Header";
        EftHeader3: Record "EFT Transfer Header";
        EftLine: Record "EFT Transfer Lines";
        EftLine2: Record "EFT Transfer Lines";
        TransType: Record "Transaction Types";
        EftHeaderNo: Code[50];
        SaccoAc: Record "Account Banking";
        CustRecord: Record Member;
        TempRec: Record "Banking User Template";
        Till: Record "Bank Account";
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        gensetup: Record "General Set-Up";
    begin

        gensetup.Get();

        TempRec.Get(UserId);
        TempRec.TestField("Default Bank Account (EFT)");
        Till.SetRange("No.", TempRec."Default Bank Account (EFT)");
        if Till.FindFirst() then begin
            Till.CalcFields("Balance (LCY)");

            EftHeaderNo := '';

            EftHeader3.Reset();
            EftHeader3.SetRange("Member No.", MemberNo);
            EftHeader3.SetRange("Application Source", EftHeader3."Application Source"::Web);
            EftHeader3.SetFilter("Approval Status", '%1| %2 | %3', EftHeader3."Approval Status"::Open, EftHeader3."Approval Status"::Approved, EftHeader3."Approval Status"::"Pending Approval");
            if EftHeader3.FindFirst() then begin
                Response := '99|Member has existing application not yet posted';
                exit(Response)
            end;

            CustRecord.Reset();
            CustRecord.SetRange("No.", MemberNo);
            CustRecord.SetRange(Status, CustRecord.Status::Active);
            if CustRecord.FindFirst() then begin

                RegmntAcc.Reset();
                RegmntAcc.SetRange("Member No.", MemberNo);
                RegmntAcc.SetRange("Account Category", RegmntAcc."Account Category"::Savings);
                RegmntAcc.SetRange("Mobile Transaction Status", RegmntAcc."Mobile Transaction Status"::Registered);
                if not RegmntAcc.FindFirst() then begin
                    Response := '99|Account not Registered for Mobile Transaction';
                    exit(Response)
                end;

                SaccoAc.Reset();
                SaccoAc.SetRange("No.", RegmntAcc."No.");
                SaccoAc.SetRange(Status, SaccoAc.Status::Active);
                if SaccoAc.FindFirst() then begin
                    if (AmountPost + 100) <= TellerMngt.CalcAvailableBal(SaccoAc."No.") then begin

                        EftHeader.init();
                        EftHeader."No." := '';
                        EftHeader."Application Source" := EftHeader."Application Source"::Web;
                        EftHeader."Document Type" := EftHeader."Document Type"::"Electronic Fund Transfer";
                        EftHeader."Account Type" := EftHeader."Account Type"::"Bank Account";
                        EftHeader.Validate("Account No.", Till."No.");
                        EftHeader."Approval Status" := EftHeader."Approval Status"::Approved;
                        EftHeader.Remarks := Remarks;
                        EftHeader."Member No." := MemberNo;
                        EftHeader."Source of funds" := SourceOfFunds;

                        TransType.Reset();
                        TransType.SetRange(Type, TransType.Type::EFT);
                        if TransType.FindFirst() then
                            EftHeader."Transaction Type" := TransType.Code;
                        EftHeader.Insert(true);
                        EftHeaderNo := EftHeader."No.";

                        EftLine.Init();
                        EftLine."Document No." := EftHeaderNo;
                        EftLine.Validate("Account Type", EftLine."Account Type"::Savings);
                        EftLine.Validate("Account No.", SaccoAc."No.");
                        EftLine.Validate(Amount, AmountPost);
                        EftLine.Validate("Bank Code", Bnkcode);
                        EftLine.Validate("Branch Code", BnkBranch);
                        EftLine."External Account No." := ExtAccNo;
                        EftLine."External Account Name" := ExtAccName;
                        EftLine.Contact := ContBen;
                        EftLine."Physical Address" := PhycAdress;
                        EftLine."IBAN No." := SwiftCode;
                        EftLine.Insert(true);

                        EftHeader2.SetRange("No.", EftLine."Document No.");
                        if EftHeader2.FindFirst() then begin

                            case gensetup."Post As (EFT)" of
                                gensetup."Post As (EFT)"::"Web Service":
                                    begin
                                        BnkMgt.ElectronicFundsProcessing(EftHeader2, 1, false);
                                    end;
                            end;
                            Response := '00|Sucess|' + EftHeader2."No.";
                            exit(Response)
                        end else begin
                            Response := '99|Failed';
                            exit(Response)
                        end;
                    end else begin
                        Response := '99|No enough funds for this transaction';
                        exit(Response)
                    end;
                end else begin
                    Response := '99|Banking Account not Found';
                    exit(Response)
                end;
            end else begin
                Response := '99|Member Account not Found';
                exit(Response)
            end;
        end else begin
            Response := '99| Bank Account not Found';
            exit(Response)
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDeferralPostAccount(isChannel: Boolean; IsHandled: Code[100]; PtyLoad: Code[10])
    begin
    end;

}


