codeunit 50074 "Loan Graduation/Downgrade Mngt"
{
    TableNo = Member;

    trigger OnRun()
    begin
        InitPost(Rec."No.");
    end;

    var

        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        AccCred: Record "Account Credit";
        VarVariant: Variant;
        AccBnk: Record "Account Banking";
        QCdirection: Enum QCQualificationDirection;
        JournlPosted: Codeunit "Jnl Mngt. Post Successful";
        Gensetup: Record "General Set-Up";
        RegMngt: Codeunit "Register Management";
        PFact: Record "Product Factory";
        CustRecord: Record Member;
        QcQualifyAmt: Record "QC. Grad. Qualification";
        QcQualifyMngt: Record "QC. Grad. Qualification";
        RegistryMngt: Codeunit "Registry Mngt.";
        LoanRecvMngt: Record "Loan Recovery Mngt.";
        DFilter: Text[50];
        DisbFilter: Text[50];
        LastPayDate: Date;
        EndPostDate: Date;
        StartPostDate: Date;
        Loan: Record Loans;
        QualAmt: Decimal;

    procedure InitPost(CustNo: Code[100])
    var
        CustMember: Record Member;
    begin

        DFilter := '';
        DisbFilter := '';
        LastPayDate := 0D;
        QualAmt := 0;

        LastPayDate := CalcDate('-3M', Today);
        DisbFilter := Format(LastPayDate) + '..' + Format(Today);

        PFact.Reset();
        PFact.SetRange(Status, PFact.Status::Active);
        PFact.SetRange("Loan Span", PFact."Loan Span"::"Mobile Loan");
        if PFact.FindFirst() then begin

            CustRecord.Reset();
            CustRecord.SetRange("No.", CustNo);
            CustRecord.SetFilter(Status, '<>%1 & <>%2', CustRecord.Status::Deceased, CustRecord.Status::Withdrawn);
            if CustRecord.FindFirst() then begin

                QualAmt := RegMngt.GetLoanMaxCreditLimitScoreQC(CustRecord, PFact."Product ID", 90, 1);

                LoanRecvMngt.Reset();
                LoanRecvMngt.SetFilter("Date Posted", DisbFilter);
                LoanRecvMngt.SetRange("Member No.", CustRecord."No.");
                LoanRecvMngt.SetRange("Product Type", PFact."Product ID");
                if LoanRecvMngt.FindLast() then begin

                    Loan.SetCurrentKey("Approved Amount");
                    Loan.Reset();
                    Loan.Ascending(false);
                    Loan.SetRange("Account No.", CustRecord."No.");
                    Loan.SetRange("Product Type", PFact."Product ID");
                    Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
                    if Loan.Find('-') then begin
                        Loan.CalcFields("Outstanding Balance");

                        QcQualifyMngt.LockTable();
                        InitializeQcGradQualAmount(CustRecord, QcQualifyMngt);

                        AccCred.Reset();
                        AccCred.SetRange("Member No.", CustRecord."No.");
                        AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
                        if AccCred.FindFirst() then
                            QcQualifyMngt."Account No." := AccCred."No.";
                        QcQualifyMngt.Validate("Qualifying Amount", fnGetGraduatedAmt(Loan."No.", CustMember."No.",
                            PFact."Product ID", QCdirection::Downgrade));
                        QcQualifyMngt."Product Type" := PFact."Product ID";
                        QcQualifyMngt."Loan No." := Loan."No.";
                        QcQualifyMngt."Qualifying Direction" := QcQualifyMngt."Qualifying Direction"::Downgrade;
                        QcQualifyMngt.Insert(true);

                    end;

                end else begin

                    if RegMngt.GetLoanMaxCreditLimitScoreQC(CustRecord, PFact."Product ID", 90, 1) > 0 then begin

                        Loan.Reset();
                        Loan.Ascending(true);
                        Loan.SetRange("Account No.", CustRecord."No.");
                        Loan.SetRange("Product Type", PFact."Product ID");
                        Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
                        if Loan.FindLast() then begin

                            Loan.CalcFields("Outstanding Balance");

                            if CheckLoanQualifiedRepayment(Loan."No.", Loan."Account No.", Loan."Product Type") then begin

                                QcQualifyMngt.LockTable();
                                InitializeQcGradQualAmount(CustRecord, QcQualifyMngt);

                                AccCred.Reset();
                                AccCred.SetRange("Member No.", CustRecord."No.");
                                AccCred.SetRange("Account Category", AccCred."Account Category"::"Shares Deposit");
                                if AccCred.FindFirst() then
                                    QcQualifyMngt."Account No." := AccCred."No.";
                                QcQualifyMngt.Validate("Qualifying Amount", fnGetGraduatedAmt(Loan."No.", CustRecord."No.",
                                            Loan."Product Type", QCdirection::Graduate));
                                QcQualifyMngt."Product Type" := Loan."Product Type";
                                QcQualifyMngt."Loan No." := Loan."No.";
                                QcQualifyMngt."Qualifying Direction" := QcQualifyMngt."Qualifying Direction"::Graduate;
                                QcQualifyMngt.Insert(true);
                            end
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure CheckLoanQualifiedRepayment(LoanNo: Code[100]; MemberNo: Code[100]; LoanType: Code[20]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        Amt: Decimal;
        CredLedger: Record "Cust. Ledger Entry";
    begin

        Loans.Reset();
        Loans.SetRange("No.", LoanNo);
        if Loans.FindLast() then begin
            Loans.CalcFields("Last Pay Date", "Outstanding Balance");
            if Loans."Outstanding Balance" = 0 then begin
                if Loans."Last Pay Date" <> 0D then begin
                    if Loans."Last Pay Date" <= CalcDate('3D', Loans."Expected Date of Completion") then begin

                        exit(true)
                    end else begin
                        exit(false)
                    end;
                end else begin
                    exit(false)
                end;
            end;
        end else begin
            exit(false)
        end;
    end;

    procedure CheckQualifiedRepayment(MemberNo: Code[100]; LoanType: Code[20]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        Amt: Decimal;
        CredLedger: Record "Cust. Ledger Entry";
    begin

        Loans.Reset();
        Loans.SetRange("Account No.", MemberNo);
        Loans.SetRange("Product Type", PFact."Product ID");
        Loans.SetRange("Approval Status", Loans."Approval Status"::Posted);
        if Loans.FindLast() then begin
            Loans.CalcFields("Last Pay Date", "Outstanding Balance");
            if Loans."Outstanding Balance" > 0 then begin
                exit(false)
            end else begin
                if Loans."Last Pay Date" <> 0D then begin
                    if Loans."Last Pay Date" <= Loans."Expected Date of Completion" then begin
                        exit(true)
                    end else begin
                        exit(false)
                    end;
                end else begin
                    exit(false)
                end;
            end;

        end else begin
            exit(true)
        end;
    end;

    procedure CheckDefaultedRepayment(MemberNo: Code[100]; LoanType: Code[20]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record "Loans Categorization";
        PFact: Record "Product Factory";
        Amt: Decimal;
        CredLedger: Record "Cust. Ledger Entry";
    begin

        Loans.Reset();
        Loans.SetRange("Account No.", MemberNo);
        Loans.SetRange("Product Type", PFact."Product ID");
        Loans.SetRange("Performance Indicator", Loans."Performance Indicator"::"Defaulted Account");
        if Loans.FindLast() then begin
            exit(true)
        end else begin
            exit(false)
        end;

    end;

    procedure GetMinMonthlyContrib(MemberNo: Code[50]; LoanType: Code[20]; SavingsDays: Integer): Boolean
    var
        AmtMax: Decimal;
        SavAcc: Record "Account Credit";
        RSchedule: Record "Contribution Schedule";
        InitialInstal: Integer;
        RunDate: Date;
        RepayPeriod: Integer;
        InstalNo: Integer;
        ScheduleTxt: Record "Contribution Schedule";
        ContribTxt: Record "Member Monthly Contribution";
        SharesContrib: Decimal;
        Pfact: Record "Product Factory";
    begin

        AmtMax := 0;
        SharesContrib := 0;

        SavAcc.Reset();
        SavAcc.SetRange("Member No.", MemberNo);
        SavAcc.SetRange("Account Category", SavAcc."Account Category"::"Shares Deposit");
        if SavAcc.FindFirst() then begin
            if Pfact.Get(SavAcc."Product Type") then
                RSchedule.Reset();
            RSchedule.SetRange("Account No.", SavAcc."No.");
            RSchedule.SetRange("Entry Type", RSchedule."Entry Type"::Graduation);
            RSchedule.DeleteAll();

            SharesContrib := RegMngt.getAccountShareBand(SavAcc."Member No.");

            if SavingsDays = 14 then begin

                InitialInstal := 14;
                RepayPeriod := 14;
                RunDate := CalcDate('-14D', Today);
            end else begin
                InitialInstal := SavingsDays;
                RepayPeriod := SavingsDays;
                RunDate := CalcDate('-90D', Today);
            end;
            InstalNo := 0;
            repeat
                InstalNo := InstalNo + 1;
                RSchedule.Init();
                RSchedule."Account No." := SavAcc."No.";
                RSchedule."Posting Date" := RunDate;
                RSchedule."Installment No." := InstalNo;
                RSchedule."Member No." := SavAcc."Member No.";
                RSchedule.Amount := 0;
                RSchedule.Insert(true);
                RunDate := CalcDate('1D', RunDate);
            until InstalNo = SavingsDays;

            FetchCreditMemberDailySavings(SavAcc."No.");

            ScheduleTxt.Reset();
            ScheduleTxt.SetRange("Account No.", SavAcc."No.");
            IF ScheduleTxt.Find('-') then begin
                repeat
                    if ScheduleTxt.Amount < SharesContrib then
                        exit(true)
                until ScheduleTxt.Next() = 0;
            end;
            exit(false)
        end;
    end;

    local procedure FetchCreditMemberDailySavings(AcNo: Code[20])
    var
        CShedule: record "Contribution Schedule";
        SavLedgers: Record "Detailed Cust. Ledg. Entry";
        CustLedger: Record "Cust. Ledger Entry";

    begin
        CShedule.Reset();
        CShedule.SetRange("Account No.", AcNo);
        if CShedule.FindSet() then begin
            repeat
                SavLedgers.Reset();
                SavLedgers.SetRange("Customer No.", CShedule."Account No.");
                SavLedgers.SetRange("Posting Date", CShedule."Posting Date");
                if SavLedgers.FindSet() then begin
                    if CustLedger.Get(SavLedgers."Cust. Ledger Entry No.") then begin
                        if not CustLedger.Reversed then begin
                            SavLedgers.CalcSums(Amount);
                            CShedule.Amount := SavLedgers.Amount * -1;
                            CShedule.Modify(true)
                        end
                    end;
                end;

            until CShedule.Next() = 0;
        end;

    end;
    procedure InitializeQcGradQualAmount(VarVariant: Record Member; var QCDetails: Record "QC. Grad. Qualification")
    begin
        QCDetails.Init;
        QCDetails.CopyFromCustDetail(VarVariant);
    end;
    procedure fnGetGraduatedAmt(LoanNo: Code[100]; MemberNo: Code[100]; LoanType: Code[20]; Direction: Enum QCQualificationDirection): Decimal
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        Amt: Decimal;
        CredLedger: Record "Cust. Ledger Entry";
    begin
        if PFact.Get(LoanType) then begin

            PFact.TestField("Minimum Loan Amount");
            PFact.TestField("Graduation % (Mobile)");
            PFact.TestField("Downgrade % (Mobile)");

            case PFact."Loan Span" of
                PFact."Loan Span"::"Mobile Loan":
                    begin

                        Loans.Reset();
                        Loans.SetRange("No.", LoanNo);
                        if Loans.FindFirst() then begin
                            Loans.CalcFields("Outstanding Balance");
                            if Loans."Outstanding Balance" = 0 then begin

                                CredLedger.Reset();
                                CredLedger.SetRange(Reversed, false);
                                CredLedger.Setrange("Loan No.", Loans."No.");
                                CredLedger.SetRange("Transaction Type", CredLedger."Transaction Type"::Loan);
                                if CredLedger.FindFirst() then begin

                                    case Direction of
                                        Direction::Graduate:
                                            begin
                                                Amt := Round((Loans."Approved Amount" + (Loans."Approved Amount" * (PFact."Graduation % (Mobile)" / 100))), 1, '=');
                                                if Amt >= PFact."Maximum Loan Amount" then
                                                    Amt := PFact."Maximum Loan Amount";
                                            end;

                                        Direction::Downgrade:
                                            begin
                                                Amt := Round((Loans."Approved Amount" - (Loans."Approved Amount" * (PFact."Downgrade % (Mobile)" / 100))), 1, '=');
                                            end;
                                    end;
                                end else begin
                                    Amt := PFact."Minimum Loan Amount";
                                end;
                            end;
                        end else begin
                            Amt := PFact."Minimum Loan Amount";
                        end;
                        exit(Amt)
                    end;
            end;
        end;
    end;

}
