codeunit 90000 "Rcv07 Credit Score Engine Mgt."
{

    trigger OnRun()
    begin
    end;

    procedure GetQualifyingAmt(CustRec: Code[100]; LoanType: Code[20]; SavingsDays: Integer; Preview: Boolean) Response: Decimal
    var
        HrDate: Codeunit "Date Conversion";
        ContMembership: Record "DSC Continous Membership";
        DscAppScoring: Record "Rcv01 Appraisal Score Mgt.";
        DscAppScore: Record "Rcv01 Appraisal Score Mgt.";
        CustomerAge: Integer;
        MaxContAge: Integer;
        MemberNo: Code[50];
        CustMember: Record Member;
        Loan: Record "Loans Categorization";
        LoanT: Record Loans;
        DepositExp: Decimal;
        AccCredit: Record "Account Credit";
        SharesDeposit: Decimal;
        ProdFact: Record "Product Factory";
        MonthContrib: Record "Member Monthly Contribution";
        Contribt: Decimal;
        DateFilter: Text[100];
        StartDate: Date;
        Enddate: Date;
        AccBanking: Record "Account Banking";
        FirstDateMonth: Date;
        BankAccLedgerEntry: Record "Banking A/c Ledger Entry";
        MembershipDuration: Integer;
        QualifyAmtBanding: Record "QC Qualifying Tiers";
        QualifyingAmt: Decimal;
        ShareBand: Decimal;
        DepositMultiplier: Decimal;
        MaxAvailable: Decimal;
        ExistDivLoan: Decimal;
        DivMngt: Codeunit "Dividend Process";
        DiviProgession: Record "Dividend Progression";
        GrossDivAmt: Decimal;
        ScoreAmt: Decimal;
        QcQualifyAmt: Record "QC Qualifying Amount";
        QcQualifyMngt: Record "QC Qualifying Amount";
        MemberCust: Record Member;
        TotalScore: Decimal;
        HasExistingLoan: Boolean;
        FactProd: Record "Product Factory";
        SharesDepositMultiplier: Decimal;
        AgesInDays: Integer;
        LoanRecvMngt: Record "Loan Recovery Mngt.";
        PostedLoan: Record Loans;
        DisbFilter: Text[50];
        LastPayDate: Date;
        GradScaleMgt: Record "Rcv04 Graduation Scale";
        BosaAccNo: Code[100];
        CustInt: Decimal;
        GradQualify: Record "QC Qualifying Amount";
        MaxQualAvailable: Decimal;
        DivMgt: codeunit "Dividend Process";
        RegistrationDate: Date;
        AppraisalScoringMgt: Report "Mobile Loan Score";
        ScoreMgt: Record "Rcv01 Appraisal Score Mgt.";
        ScoringMgt: Record "Rcv01 Appraisal Score Mgt.";
        noncustomer: Record Member;
        accmgt: Record "Account Banking";
    begin

        CustomerAge := 0;
        MaxContAge := 0;
        CustInt := 0;
        DepositExp := 0;
        GrossDivAmt := 0;
        MembershipDuration := 0;
        SharesDeposit := 0;
        DisbFilter := '';
        Contribt := 0;
        FirstDateMonth := 0D;
        DepositMultiplier := 0;
        ShareBand := 0;
        DepositMultiplier := 0;
        MaxAvailable := 0;
        ExistDivLoan := 0;
        ScoreAmt := 0;
        TotalScore := 0;
        HasExistingLoan := false;
        SharesDepositMultiplier := 0;
        AgesInDays := 0;
        MaxQualAvailable := 0;
        RegistrationDate := 0D;
        BosaAccNo := '';

        FirstDateMonth := CalcDate('-CM-1D', Today);
        LastPayDate := CalcDate('-3M', Today);
        DisbFilter := Format(LastPayDate) + '..' + Format(Today);

        CustMember.Reset();
        CustMember.SetRange("No.", CustRec);
        CustMember.SetRange(Status, CustMember.Status::Active);
        if CustMember.FindFirst() then begin

            clearExistingQcQualMgt(CustMember."No.", LoanType);
            clearExistingScoreQualMgt(CustMember."No.");
            clearExistingLoanAppMgt(CustMember."No.", LoanType);

            case CustMember.Rejoined of
                true:
                    begin
                        RegistrationDate := CustMember."Rejoining Date";
                        CustomerAge := Round(((Today - CustMember."Rejoining Date") / 30.42), 1, '=');
                    end;
                false:
                    begin
                        RegistrationDate := CustMember."Registration Date";
                        CustomerAge := Round(((Today - CustMember."Registration Date") / 30.42), 1, '=');
                        AgesInDays := (Today - CustMember."Registration Date");
                    end
            end;

            if RegistrationDate <> 0D then begin

                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustMember."No.");
                AccCredit.SetRange(Status, AccCredit.Status::Active);
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                if AccCredit.findfirst() then begin
                    AccCredit.CalcFields("Balance (LCY)", Balance);
                    if AccCredit."Balance (LCY)" <= 0 then begin
                        UpdatefailedRequest(CustMember."No.", LoanType, Enum::MobileLoanStatus::Failed,
                            Text0001 + Format(AccCredit."Balance (LCY)"),
                            Enum::"Rcv13 Docs Application Source"::Navision);

                        ScoreMgt.LockTable();
                        InitializeScoringMgt(CustMember, ScoreMgt);
                        ScoreMgt."Registration Date" := RegistrationDate;
                        ScoreMgt."Error Log" := Text0001;
                        ScoreMgt.Rejoined := CustMember.Rejoined;
                        ScoreMgt."Product Type" := LoanType;
                        ScoreMgt.Insert(true);
                        exit(0);
                    end
                end else begin

                    UpdatefailedRequest(CustMember."No.", LoanType, Enum::MobileLoanStatus::Failed,
                        Text0002, Enum::"Rcv13 Docs Application Source"::Navision);
                    ScoreMgt.LockTable();
                    InitializeScoringMgt(CustMember, ScoreMgt);
                    ScoreMgt."Registration Date" := RegistrationDate;
                    ScoreMgt."Product Type" := LoanType;
                    ScoreMgt."Error Log" := Text0002;
                    ScoreMgt.Insert(true);
                    exit(0);
                end;

                if CustMember.Rejoined then begin

                    if CalcDate('90D', RegistrationDate) > Today then begin
                        UpdatefailedRequest(CustMember."No.",
                           ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                           Text0003 + Format(RegistrationDate),
                           Enum::"Rcv13 Docs Application Source"::Navision);
                        ScoreMgt.LockTable();
                        InitializeScoringMgt(CustMember, ScoreMgt);
                        ScoreMgt."Registration Date" := RegistrationDate;
                        ScoreMgt."Product Type" := LoanType;
                        ScoreMgt.Rejoined := CustMember.Rejoined;
                        ScoreMgt."Error Log" := Text0003 + ' ' + Format(RegistrationDate);
                        ScoreMgt.Insert(true);
                        exit(0)
                    end;

                end else begin

                    if CalcDate('1D', RegistrationDate) > Today then begin
                        UpdatefailedRequest(CustMember."No.",
                           ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                           Text0004 + Format(RegistrationDate),
                           Enum::"Rcv13 Docs Application Source"::Navision);
                        ScoreMgt.LockTable();
                        InitializeScoringMgt(CustMember, ScoreMgt);
                        ScoreMgt."Registration Date" := RegistrationDate;
                        ScoreMgt."Product Type" := LoanType;
                        ScoreMgt.Rejoined := CustMember.Rejoined;
                        ScoreMgt."Error Log" := Text0004 + ' ' + Format(RegistrationDate);
                        ScoreMgt.Insert(true);
                        exit(0)
                    end;
                end;

                if (CustMember."Mobile Status" = CustMember."Mobile Status"::Defaulter) then begin
                    UpdatefailedRequest(CustMember."No.", ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                    Text0005 + Format(CustMember."Mobile Status"), Enum::"Rcv13 Docs Application Source"::Navision);

                    ScoreMgt.LockTable();
                    InitializeScoringMgt(CustMember, ScoreMgt);
                    ScoreMgt."Registration Date" := RegistrationDate;
                    ScoreMgt."Product Type" := LoanType;
                    ScoreMgt.Rejoined := CustMember.Rejoined;
                    ScoreMgt."Error Log" := Text0005 + ' ' + Format(CustMember."Mobile Status");
                    ScoreMgt.Insert(true);
                    exit(0);
                end;

                if (CustMember."Loan Status" = CustMember."Loan Status"::Defaulter) then begin
                    UpdatefailedRequest(CustMember."No.", ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                    Text0005 + Format(CustMember."Loan Status"), Enum::"Rcv13 Docs Application Source"::Navision);

                    ScoreMgt.LockTable();
                    InitializeScoringMgt(CustMember, ScoreMgt);
                    ScoreMgt."Registration Date" := RegistrationDate;
                    ScoreMgt."Product Type" := LoanType;
                    ScoreMgt.Rejoined := CustMember.Rejoined;
                    ScoreMgt."Error Log" := Text0005 + ' ' + Format(CustMember."Loan Status");
                    ScoreMgt.Insert(true);
                    exit(0);
                end;

                accmgt.Reset();
                accmgt.SetRange("Member No.", CustMember."No.");
                accmgt.SetRange(Status, accmgt.Status::Active);
                accmgt.SetRange("Account Category", accmgt."Account Category"::Savings);
                if not accmgt.FindFirst() then begin

                    UpdatefailedRequest(CustMember."No.", ProdFact."Product ID", Enum::MobileLoanStatus::Failed, Text0018, Enum::"Rcv13 Docs Application Source"::Navision);

                    ScoreMgt.LockTable();
                    InitializeScoringMgt(CustMember, ScoreMgt);
                    ScoreMgt."Registration Date" := RegistrationDate;
                    ScoreMgt."Product Type" := LoanType;
                    ScoreMgt.Rejoined := CustMember.Rejoined;
                    ScoreMgt."Error Log" := Text0018;
                    ScoreMgt.Insert(true);
                    exit(0);
                end;

                /* if getcheckcontribution(CustMember."No.", LoanType, 90) then begin
                    UpdatefailedRequest(CustMember."No.", LoanType, Enum::MobileLoanStatus::Failed, Text0006, Enum::"Docs Application Source"::Navision);
                    ScoreMgt.LockTable();
                    InitializeScoringMgt(CustMember, ScoreMgt);
                    ScoreMgt."Registration Date" := RegistrationDate;
                    ScoreMgt."Product Type" := LoanType;
                    ScoreMgt."Error Log" := Text0006;
                    ScoreMgt.Rejoined := CustMember.Rejoined;
                    ScoreMgt.Insert(true);
                    exit(0);
                end; */

                ProdFact.Reset();
                ProdFact.SetRange("Product ID", LoanType);
                ProdFact.SetRange(Status, ProdFact.Status::Active);
                if ProdFact.FindFirst() then begin
                    if (ProdFact."Maximum Loan Amount" = 0) or (ProdFact."Minimum Loan Amount" = 0) then begin
                        UpdatefailedRequest(CustMember."No.", LoanType, Enum::MobileLoanStatus::Failed, Text0008, Enum::"Rcv13 Docs Application Source"::Navision);

                        ScoreMgt.LockTable();
                        InitializeScoringMgt(CustMember, ScoreMgt);
                        ScoreMgt."Registration Date" := RegistrationDate;
                        ScoreMgt."Product Type" := LoanType;
                        ScoreMgt."Error Log" := Text0008;
                        ScoreMgt.Rejoined := CustMember.Rejoined;
                        ScoreMgt.Insert(true);
                        exit(0);
                    end;

                    if ProdFact."Deposit Multiplier" = 0 then begin
                        UpdatefailedRequest(CustMember."No.", LoanType, Enum::MobileLoanStatus::Failed, Text0009, Enum::"Rcv13 Docs Application Source"::Navision);

                        ScoreMgt.LockTable();
                        InitializeScoringMgt(CustMember, ScoreMgt);
                        ScoreMgt."Registration Date" := RegistrationDate;
                        ScoreMgt."Product Type" := LoanType;
                        ScoreMgt."Error Log" := Text0009;
                        ScoreMgt.Rejoined := CustMember.Rejoined;
                        ScoreMgt.Insert(true);
                        exit(0);
                    end;

                    InitializeScore(custMember."No.", LoanType);

                    case ProdFact."Loan Span" of
                        ProdFact."Loan Span"::"Mobile Loan":
                            begin

                                Loan.Reset();
                                Loan.SetRange("Account No.", CustMember."No.");
                                Loan.SetFilter("Outstanding Balance", '>0');
                                Loan.SetRange("Product Type", ProdFact."Product ID");
                                if Loan.FindFirst() then begin

                                    Loan.CalcFields("Outstanding Balance");
                                    UpdatefailedRequest(CustMember."No.",
                                    ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                    Text0010 + ' - ' + Loan."No.",
                                    Enum::"Rcv13 Docs Application Source"::Navision);
                                    ScoreMgt.LockTable();
                                    InitializeScoringMgt(CustMember, ScoreMgt);
                                    ScoreMgt."Registration Date" := RegistrationDate;
                                    ScoreMgt."Product Type" := LoanType;
                                    ScoreMgt."Error Log" := Text0010 + ' - ' + Loan."No.";
                                    ScoreMgt."Has Exiting Loan" := true;
                                    ScoreMgt.Rejoined := CustMember.Rejoined;
                                    ScoreMgt.Insert(true);
                                    exit(0);
                                end;

                                AccCredit.Reset();
                                AccCredit.SetRange("Member No.", CustMember."No.");
                                AccCredit.SetRange(Status, AccCredit.Status::Active);
                                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Capital");
                                if AccCredit.FindFirst() then begin
                                    AccCredit.CalcFields("Balance (LCY)", Balance);

                                    FactProd.Reset();
                                    FactProd.SetRange("Product ID", AccCredit."Product Type");
                                    if FactProd.FindFirst() then
                                        FactProd.TestField("Minimum Balance");
                                    if AccCredit."Balance (LCY)" <= 0 then begin
                                        UpdatefailedRequest(CustMember."No.",
                                        ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                        Text0011 + Format(FactProd."Minimum Balance"),
                                        Enum::"Rcv13 Docs Application Source"::Navision);
                                        ScoreMgt.LockTable();
                                        InitializeScoringMgt(CustMember, ScoreMgt);
                                        ScoreMgt."Registration Date" := RegistrationDate;
                                        ScoreMgt."Product Type" := LoanType;
                                        ScoreMgt."Error Log" := Text0011;
                                        ScoreMgt.Rejoined := CustMember.Rejoined;
                                        ScoreMgt.Insert(true);
                                        exit(0)
                                    end;
                                end else begin
                                    UpdatefailedRequest(CustMember."No.", ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                    Text0012, Enum::"Rcv13 Docs Application Source"::Navision);
                                    ScoreMgt.LockTable();
                                    InitializeScoringMgt(CustMember, ScoreMgt);
                                    ScoreMgt."Registration Date" := RegistrationDate;
                                    ScoreMgt."Product Type" := LoanType;
                                    ScoreMgt."Error Log" := Text0012;
                                    ScoreMgt.Rejoined := CustMember.Rejoined;
                                    ScoreMgt.Insert(true);
                                    exit(0)
                                end;

                                AccCredit.Reset();
                                AccCredit.SetRange("Member No.", CustMember."No.");
                                AccCredit.SetRange(Status, AccCredit.Status::Active);
                                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                                if AccCredit.FindFirst() then begin
                                    AccCredit.CalcFields("Balance (LCY)", Balance);

                                    FactProd.Reset();
                                    FactProd.SetRange("Product ID", ProdFact."Product ID");
                                    if FactProd.FindFirst() then
                                        FactProd.TestField("Minimum Deposit Balance");

                                    if AccCredit."Balance (LCY)" <= 0 then begin
                                        UpdatefailedRequest(CustMember."No.",
                                        ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                        Text0011 + Format(FactProd."Minimum Balance"),
                                        Enum::"Rcv13 Docs Application Source"::Navision);
                                        ScoreMgt.LockTable();
                                        InitializeScoringMgt(CustMember, ScoreMgt);
                                        ScoreMgt."Registration Date" := RegistrationDate;
                                        ScoreMgt."Product Type" := LoanType;
                                        ScoreMgt."Error Log" := Text0011;
                                        ScoreMgt.Rejoined := CustMember.Rejoined;
                                        ScoreMgt.Insert(true);
                                        exit(0)
                                    end else begin
                                        FactProd.TestField("Minimum Deposit Balance");
                                        if AccCredit."Balance (LCY)" < FactProd."Minimum Deposit Balance" then begin
                                            UpdatefailedRequest(CustMember."No.",
                                        ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                        Text0011 + Format(FactProd."Minimum Balance"),
                                        Enum::"Rcv13 Docs Application Source"::Navision);
                                            ScoreMgt.LockTable();
                                            InitializeScoringMgt(CustMember, ScoreMgt);
                                            ScoreMgt."Registration Date" := RegistrationDate;
                                            ScoreMgt."Product Type" := LoanType;
                                            ScoreMgt."Error Log" := Text0011;
                                            ScoreMgt.Rejoined := CustMember.Rejoined;
                                            ScoreMgt.Insert(true);
                                            exit(0)
                                        end;
                                    end;
                                end else begin
                                    UpdatefailedRequest(CustMember."No.", ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                    Text0012, Enum::"Rcv13 Docs Application Source"::Navision);
                                    ScoreMgt.LockTable();
                                    InitializeScoringMgt(CustMember, ScoreMgt);
                                    ScoreMgt."Registration Date" := RegistrationDate;
                                    ScoreMgt."Product Type" := LoanType;
                                    ScoreMgt."Error Log" := Text0012;
                                    ScoreMgt.Rejoined := CustMember.Rejoined;
                                    ScoreMgt.Insert(true);
                                    exit(0)
                                end;

                                InitializeScore(CustMember."No.", ProdFact."Product ID",
                                CustMember.Name, CustMember.Status, RegistrationDate, CustMember.Rejoined);
                                GetcustLastPostedLoan(CustMember."No.", ProdFact."Product ID");


                                MembershipDuration := CustomerAge;
                                DscAppScoring.Init();
                                DscAppScoring."Account No." := CustMember."No.";
                                DscAppScoring."Account Name" := CustMember.Name;
                                DscAppScoring.Status := CustMember.Status;
                                DscAppScoring."Registration Date" := RegistrationDate;
                                DscAppScoring.Rejoined := CustMember.Rejoined;
                                DscAppScoring."Product Type" := ProdFact."Product ID";

                                ContMembership.Reset();
                                if ContMembership.FindSet() then begin
                                    repeat
                                        if (MembershipDuration >= ContMembership."Min. Age") and (MembershipDuration <= ContMembership."Max. Age") then begin
                                            MaxContAge := ContMembership.Score;
                                        end;
                                    until ContMembership.Next() = 0;
                                end;

                                DscAppScoring."Membership Age" := MaxContAge;
                                DscAppScoring."Credit History" := checkcustCreditHistory(CustMember."No.");
                                DscAppScoring."Deposit Exposure" := calculateDepositExposure(CustMember."No.");
                                DscAppScoring."Monthly Contribution" := custmonthlyContribution(CustMember."No.");

                                DscAppScoring."Shares Banding" := RegMgt.getAccountShareBand(CustMember."No.");
                                DscAppScoring."Monthly Deposit" := getcustDepositremittance(CustMember."No.");
                                DscAppScoring."Previously Defaulted Facility" := checkIfcustIsdefaulter(CustMember."No.");
                                DscAppScoring."Allow Min. Banding" := CustMember."Allow Min. Banding";
                                if checkIfcustIsdefaulter(CustMember."No.") then begin
                                    DscAppScoring."Loan Paid on Time" := 1
                                end else begin

                                    if checkifCustPaidLastIsTrue(CustMember."No.", ProdFact."Product ID") then begin
                                        DscAppScoring."Loan Paid on Time" := 3
                                    end else begin
                                        if checkifCustHasPenaltyCharged(CustMember."No.", ProdFact."Product ID") then begin
                                            if checkIfcustIsdefaulter(CustMember."No.") then
                                                DscAppScoring."Loan Paid on Time" := 1
                                            else
                                                DscAppScoring."Loan Paid on Time" := 2
                                        end else begin
                                            DscAppScoring."Loan Paid on Time" := 2
                                        end
                                    end;

                                end;
                                if custSharesDeposit(CustMember."No.") >= 1000000 then
                                    DscAppScoring."Total Deposits" := 2 else
                                    DscAppScoring."Total Deposits" := 1;

                                if checkIfcustHasExistingLoan(CustMember."No.", ProdFact."Product ID") then
                                    DscAppScoring."Has Exiting Loan" := true else
                                    DscAppScoring."Has Exiting Loan" := false;

                                TotalScore := (DscAppScoring."Total Deposits" +
                                               DscAppScoring."Banking Remittance" +
                                               DscAppScoring."Monthly Deposit" +
                                               DscAppScoring."Deposit Exposure" +
                                               DscAppScoring."Loan Paid on Time" +
                                               DscAppScoring."Credit History" + DscAppScoring."Membership Age");

                                if TotalScore > 15 then begin

                                    UpdatefailedRequest(CustMember."No.",
                                   ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                   Text0013 + Format(TotalScore),
                                   Enum::"Rcv13 Docs Application Source"::Navision);
                                    ScoreMgt.LockTable();
                                    InitializeScoringMgt(CustMember, ScoreMgt);
                                    ScoreMgt."Registration Date" := RegistrationDate;
                                    ScoreMgt."Product Type" := LoanType;
                                    ScoreMgt."Error Log" := Text0013 + ' ' + Format(TotalScore);
                                    ScoreMgt.Rejoined := CustMember.Rejoined;
                                    ScoreMgt.Insert(true);
                                    exit(0)
                                end else begin
                                    if TotalScore < 0 then TotalScore := 0;
                                end;
                                DscAppScoring."Total Score" := TotalScore;

                                QualifyAmtBanding.Reset();
                                if QualifyAmtBanding.FindSet() then begin
                                    repeat
                                        if (TotalScore >= QualifyAmtBanding."Min. Amount") and (TotalScore <= QualifyAmtBanding."Max. Amount") then begin
                                            ScoreAmt := QualifyAmtBanding.Score;
                                        end;
                                    until QualifyAmtBanding.Next() = 0
                                end;

                                if ScoreAmt < 0 then begin

                                    UpdatefailedRequest(CustMember."No.",
                                       ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
                                       Text0013 + Format(TotalScore),
                                       Enum::"Rcv13 Docs Application Source"::Navision);
                                    ScoreMgt.LockTable();
                                    InitializeScoringMgt(CustMember, ScoreMgt);
                                    ScoreMgt."Registration Date" := RegistrationDate;
                                    ScoreMgt."Product Type" := LoanType;
                                    ScoreMgt."Error Log" := 'Score amount less than zero ' + ' ' + Format(ScoreAmt);
                                    ScoreMgt.Rejoined := CustMember.Rejoined;
                                    ScoreMgt.Insert(true);
                                    exit(0)
                                end;

                                DscAppScoring."Max Available" := MaxQualifyingAvailable(CustMember."No.", ProdFact."Product ID");
                                DscAppScoring."Shares Multiplier" := getcustsharesMultiplier(CustMember."No.", ProdFact."Product ID");
                                DscAppScoring."Last Approved Loans" := GetPostedfacility(CustMember."No.", ProdFact."Product ID");

                                if CustHasLastloanPaidOnTime(CustMember."No.", ProdFact."Product ID") then begin

                                    GradScaleMgt.Reset();
                                    GradScaleMgt.SetRange("Product Type", ProdFact."Product ID");
                                    if GradScaleMgt.FindSet() then begin
                                        repeat
                                            if (GetPostedfacility(CustMember."No.", ProdFact."Product ID") >= GradScaleMgt."Lower Limit") and (GetPostedfacility(CustMember."No.", ProdFact."Product ID") <= GradScaleMgt."Upper Limit") then begin
                                                ScoreAmt := GradScaleMgt."Max. Amount";

                                            end;
                                        until GradScaleMgt.Next() = 0
                                    end;

                                end else begin
                                    ScoreAmt := ScoreAmt
                                end;

                                if ScoreAmt >= MaxQualifyingAvailable(CustMember."No.", ProdFact."Product ID") then
                                    ScoreAmt := MaxQualifyingAvailable(CustMember."No.", ProdFact."Product ID");


                                if ScoreAmt <= 0 then
                                    ScoreAmt := 0;

                                if ScoreAmt > ProdFact."Rcv Max. Graduated Amount" then
                                    ScoreAmt := ProdFact."Rcv Max. Graduated Amount";

                                if (DscAppScoring."Has Exiting Loan") or (DscAppScoring."Membership Age" = 0) then
                                    DscAppScoring."Qualify Amount" := 0 else
                                    DscAppScoring."Qualify Amount" := ScoreAmt;
                                DscAppScoring."Score Amount" := ScoreAmt;

                                DscAppScoring."Error Log" := Text0014;
                                if DscAppScoring.Insert(true) then begin
                                    Response := Round(DscAppScoring."Qualify Amount", 1, '<');

                                    QcQualifyAmt.Reset();
                                    QcQualifyAmt.SetRange("No.", CustMember."No.");
                                    QcQualifyAmt.SetRange("Product Type", ProdFact."Product ID");
                                    if QcQualifyAmt.FindFirst() then begin
                                        QcQualifyAmt.Validate("Qualifying Amount", DscAppScoring."Qualify Amount");
                                        QcQualifyAmt.Modify(true)

                                    end else begin

                                        QcQualifyMngt.LockTable();
                                        RegistryMngt.InitializeQcQualAmount(CustMember, QcQualifyMngt);
                                        QcQualifyMngt."Account No." := BosaAccNo;
                                        QcQualifyMngt.Validate("Qualifying Amount", DscAppScoring."Qualify Amount");
                                        QcQualifyMngt."Product Type" := ProdFact."Product ID";
                                        QcQualifyMngt.Insert(true);

                                    end;

                                    exit(Response)
                                end else begin
                                    UpdatefailedRequest(CustMember."No.",
                                    ProdFact."Product ID", Enum::MobileLoanStatus::Failed, Text0015,
                                    Enum::"Rcv13 Docs Application Source"::Navision);
                                    ScoreMgt.LockTable();
                                    InitializeScoringMgt(CustMember, ScoreMgt);
                                    ScoreMgt."Registration Date" := RegistrationDate;
                                    ScoreMgt."Product Type" := LoanType;
                                    ScoreMgt."Error Log" := Text0015;
                                    ScoreMgt.Rejoined := CustMember.Rejoined;
                                    ScoreMgt.Insert(true);
                                    exit(0);
                                end;
                            end;
                        ProdFact."Loan Span"::Dividends:
                            begin
                                Response := RegMgt.GetDivLoanMaxCreditLimitScore(CustMember, ProdFact."Product ID", 0, 0);
                                exit(Response);
                            end;
                        ProdFact."Loan Span"::" ":
                            Error('Case condition %1 not implemented.', ProdFact."Loan Span"::" ");
                        ProdFact."Loan Span"::"Short Term":
                            Error('Case condition %1 not implemented.', ProdFact."Loan Span"::"Short Term");
                        ProdFact."Loan Span"::"Long Term":
                            Error('Case condition %1 not implemented.', ProdFact."Loan Span"::"Long Term");
                    end;

                end else begin
                    UpdatefailedRequest(CustMember."No.",
                        LoanType, Enum::MobileLoanStatus::Failed, Text0016,
                        Enum::"Rcv13 Docs Application Source"::Navision);
                    ScoreMgt.LockTable();
                    InitializeScoringMgt(CustMember, ScoreMgt);
                    ScoreMgt."Registration Date" := RegistrationDate;
                    ScoreMgt."Product Type" := LoanType;
                    ScoreMgt."Error Log" := Text0016;
                    ScoreMgt.Rejoined := CustMember.Rejoined;
                    ScoreMgt.Insert(true);
                    exit(0);
                end;

            end else begin
                UpdatefailedRequest(CustMember."No.",
                    ProdFact."Product ID", Enum::MobileLoanStatus::Failed, Text0017, Enum::"Rcv13 Docs Application Source"::Navision);
                ScoreMgt.LockTable();
                InitializeScoringMgt(CustMember, ScoreMgt);
                ScoreMgt."Registration Date" := RegistrationDate;
                ScoreMgt."Product Type" := LoanType;
                ScoreMgt."Error Log" := Text0017;
                ScoreMgt.Rejoined := CustMember.Rejoined;
                ScoreMgt.Insert(true);
                exit(0);
            end;
        end else begin

            UpdatefailedRequest(CustMember."No.",
            ProdFact."Product ID", Enum::MobileLoanStatus::Failed,
            'Member account status is ' + Format(CustMember.Status) + ' and not eligible for loan application.', Enum::"Rcv13 Docs Application Source"::Navision);

            noncustomer.SetRange("No.", CustRec);
            if noncustomer.FindFirst() then begin

                ScoringMgt.SetRange("Account No.", noncustomer."No.");
                ScoringMgt.DeleteAll();

                ScoreMgt.LockTable();
                InitializeScoringMgt(noncustomer, ScoreMgt);
                ScoreMgt."Registration Date" := RegistrationDate;
                ScoreMgt."Product Type" := LoanType;
                ScoreMgt.Rejoined := noncustomer.Rejoined;
                ScoreMgt."Error Log" := 'Member account status is ' + Format(noncustomer.Status) + ' and not eligible for loan application.';
                ScoreMgt.Insert(true);

            end;

            exit(0)
        end;
    end;

    local procedure checkifCustPaidLastIsTrue(accountno: Code[100]; Loantype: Code[20]): Boolean
    var
        LedgerEntry: Record "Cust. Ledger Entry";
        Loan: Record Loans;
    begin

        Loan.SetCurrentKey("No.");
        Loan.Ascending(true);
        Loan.SetRange("Account No.", accountno);
        Loan.SetRange("Product Type", Loantype);
        Loan.SetFilter("Outstanding Balance", '0');
        if Loan.FindLast() then begin

            LedgerEntry.SetCurrentKey("Entry No.");
            LedgerEntry.Ascending(true);
            LedgerEntry.SetRange(Reversed, false);
            LedgerEntry.SetRange("Loan No.", Loan."No.");
            LedgerEntry.SetRange("Transaction Type", LedgerEntry."Transaction Type"::Repayment);
            if LedgerEntry.FindLast() then begin
                if LedgerEntry."Posting Date" < Loan."Expected Date of Completion" then
                    exit(true)
            end;
        end else begin
            exit(true)
        end;
    end;


    local procedure GetcustLastPostedLoan(accountno: Code[100]; Loantype: Code[20])
    var
        LedgerEntry: Record "Cust. Ledger Entry";
        Loan: Record Loans;
        dfilter: Text[100];
        LastPayDate: Date;
        FirstDateMonth: Date;
        LoanMgt: Record "Rcv05 Loan (Score Mgt)";
        LoanScoreMgt: Record "Rcv05 Loan (Score Mgt)";
        Prodtype: Record "Product Factory";
    begin

        LoanScoreMgt.SetRange("Member No.", accountno);
        LoanScoreMgt.DeleteAll();

        LastPayDate := CalcDate('-1M', Today);
        FirstDateMonth := CalcDate('-97D', LastPayDate);
        dfilter := Format(FirstDateMonth) + '..' + Format(LastPayDate);

        Prodtype.Get(Loantype);

        case Prodtype."Loan Span" of

            Prodtype."Loan Span"::"Mobile Loan":
                begin

                    LedgerEntry.SetRange(Reversed, false);
                    LedgerEntry.SetRange("Member No.", accountno);
                    LedgerEntry.SetRange("Transaction Type", LedgerEntry."Transaction Type"::Loan);
                    LedgerEntry.SetFilter("Posting Date", dfilter);
                    if LedgerEntry.FindSet() then begin
                        repeat
                            LedgerEntry.CalcFields(Amount);
                            Loan.Reset();
                            Loan.SetRange("Product Type", Prodtype."Product ID");
                            Loan.SetRange("Account No.", accountno);
                            Loan.SetRange("No.", LedgerEntry."Loan No.");
                            if Loan.FindFirst() then begin
                                Loan.CalcFields("Outstanding Balance", "Last Pay Date");
                                if Loan."Outstanding Balance" = 0 then begin

                                    LoanMgt.Init();
                                    LoanMgt."Entry No." := LedgerEntry."Entry No.";
                                    LoanMgt."Loan No." := LedgerEntry."Loan No.";
                                    LoanMgt."Posting Date" := Loan."Last Pay Date";
                                    LoanMgt.Amount := Abs(LedgerEntry.Amount);
                                    LoanMgt."Member No." := LedgerEntry."Member No.";
                                    LoanMgt."Product Type" := Loan."Product Type";
                                    LoanMgt."Expected Completion Date" := Loan."Expected Date of Completion";
                                    if Loan."Last Pay Date" <= Loan."Expected Date of Completion" then
                                        LoanMgt."Loan Paid on Time" := true
                                    else
                                        LoanMgt."Loan Paid on Time" := false;
                                    LoanMgt.Insert(true);
                                end
                            end
                        until LedgerEntry.Next() = 0
                    end;
                end
        end;
    end;

    local procedure CustHasLastloanPaidOnTime(accountno: Code[100]; Producttype: Code[10]): Boolean
    var
        LoanScoreMgt: Record "Rcv05 Loan (Score Mgt)";
        Loantype: Record "Product Factory";
        ttt: page "Product Factory-Loan";
    begin
        Loantype.Get(Producttype);
        Loantype.TestField("No. of Times Salary");
        LoanScoreMgt.SetRange("Loan Paid on Time", true);
        LoanScoreMgt.SetRange("Member No.", accountno);
        if LoanScoreMgt.Count >= Loantype."No. of Times Salary" then
            exit(true) else
            exit(false)
    end;

    local procedure checkifCustHasPenaltyCharged(accountno: Code[100]; Loantype: Code[20]): Boolean
    var
        LedgerEntry: Record "Cust. Ledger Entry";
        Loan: Record Loans;
    begin

        Loan.SetCurrentKey("No.");
        Loan.Ascending(true);
        Loan.SetRange("Account No.", accountno);
        Loan.SetRange("Product Type", Loantype);
        Loan.SetFilter("Outstanding Balance", '0');
        if Loan.FindLast() then begin

            LedgerEntry.SetCurrentKey("Entry No.");
            LedgerEntry.Ascending(true);
            LedgerEntry.SetRange(Reversed, false);
            LedgerEntry.SetRange("Loan No.", Loan."No.");
            LedgerEntry.SetRange("Transaction Type", LedgerEntry."Transaction Type"::"Penalty Due");
            if LedgerEntry.FindLast() then begin
                if LedgerEntry."Posting Date" < Loan."Expected Date of Completion" then
                    exit(true)
            end;
        end else begin
            exit(false)
        end;
    end;

    procedure checkifLoanHasPenaltyCharged(accountno: Code[100]; Loantype: Code[20]): Boolean
    var
        LedgerEntry: Record "Cust. Ledger Entry";
        Loan: Record Loans;
    begin

        Loan.SetCurrentKey("No.");
        Loan.Ascending(true);
        Loan.SetRange("No.", accountno);
        Loan.SetRange("Product Type", Loantype);
        if Loan.FindFirst() then begin

            LedgerEntry.SetCurrentKey("Entry No.");
            LedgerEntry.Ascending(true);
            LedgerEntry.SetRange(Reversed, false);
            LedgerEntry.SetRange("Loan No.", Loan."No.");
            LedgerEntry.SetRange("Transaction Type", LedgerEntry."Transaction Type"::"Penalty Due");
            if LedgerEntry.FindFirst() then begin
                exit(true)
            end else begin
                exit(false)
            end;
        end else begin
            exit(false)
        end;
    end;

    local procedure getcustsharesMultiplier(CustRec: Code[100]; ProductFact: Code[20]): Decimal
    var
        CustMember: Record Member;
        AccCredit: Record "Account Credit";
        AccountType: Record "Product Factory";
    begin
        if CustMember.Get(CustRec) then begin

            AccCredit.Reset();
            AccCredit.SetRange("Member No.", CustMember."No.");
            AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
            if AccCredit.FindFirst() then begin
                AccCredit.CalcFields("Balance (LCY)");

                AccountType.Reset();
                AccountType.SetRange(Status, AccountType.Status::Active);
                AccountType.SetRange("Product ID", ProductFact);
                if AccountType.FindFirst() then begin
                    AccountType.TestField("Deposit Multiplier");

                    if CheckIfCustHasNoExistLoan(CustMember."No.") then begin
                        if fnCustHasLoanWithinDeposit(CustMember."No.", '') then begin
                            exit(CheckIfCustHasLoanWithinDeposit(CustMember."No.", AccountType."Product ID"));
                        end else begin
                            exit(Round((AccCredit."Balance (LCY)" * (AccountType."Deposit Multiplier" / 100))));
                        end;
                    end else begin
                        exit(CheckIfCustHasLoanWithinDeposit(CustMember."No.", AccountType."Product ID"));
                    end
                end;
            end
        end
    end;

    local procedure getcustBankingRemittance(CustRec: Code[100]): Integer
    var
        AccBanking: Record "Account Banking";
        BankAccLedgerEntry: Record "Vendor Ledger Entry";
        FirstDateMonth: Date;
        StartDate: Date;
        Enddate: Date;
        DateFilter: Text[100];
    begin

        FirstDateMonth := CalcDate('-CM+1D', Today);

        AccBanking.Reset();
        AccBanking.SetRange("Member No.", CustRec);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
        if AccBanking.FindFirst() then begin

            StartDate := CalcDate('-1M', FirstDateMonth);
            Enddate := CalcDate('CM', StartDate);

            DateFilter := Format(StartDate) + '..' + Format(Enddate);
            BankAccLedgerEntry.SetCurrentKey("External Document No.");
            BankAccLedgerEntry.Reset();
            BankAccLedgerEntry.SetRange("External Document No.", 'SALPROC');
            BankAccLedgerEntry.SetRange("Vendor No.", AccBanking."No.");
            BankAccLedgerEntry.SetFilter("Posting Date", DateFilter);
            if BankAccLedgerEntry.FindSet() then begin
                repeat
                    exit(3);
                until BankAccLedgerEntry.Next() = 0
            end else begin
                exit(0);
            end;
        end else begin
            exit(0);
        end;
    end;

    local procedure checkIfcustHasExistingLoan(CustRec: Code[100]; ProdType: Code[20]): Boolean
    var
        Loan: Record Loans;
        CustMember: Record Member;
    begin

        Loan.Reset();
        Loan.SetRange("Account No.", CustRec);
        Loan.SetFilter("Outstanding Balance", '>0');
        Loan.SetRange("Product Type", ProdType);
        if Loan.FindFirst() then begin
            Loan.CalcFields("Outstanding Balance");
            exit(true);
        end else begin
            exit(false);
        end;
    end;


    local procedure Getlastclearedfacility(CustRec: Code[100]; ProdType: Code[20]): Decimal
    var
        Loan: Record Loans;
        CustMember: Record Member;
        TellMgt: Codeunit "Teller-Post (Yes/No)";
    begin

        Loan.SetCurrentKey("No.");
        Loan.Reset();
        Loan.SetRange("Account No.", CustRec);
        Loan.SetFilter("Outstanding Balance", '0');
        Loan.SetRange("Product Type", ProdType);
        if Loan.FindLast() then begin
            if TellMgt.TestNoEntriesExist(Loan."Account Name", Loan."No.", 0) then
                exit(Loan."Approved Amount") else
                exit(0);
        end else begin
            exit(0);
        end;
    end;

    procedure CheckIfCustHasLoanWithinDeposit(MemberNo: Code[100]; LoanType: code[10]): Decimal
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        Amt: array[4] of Decimal;
    begin

        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        Amt[4] := 0;

        if CustRecord.Get(MemberNo) then begin
            Amt[1] := GetCustAccruedIntLoanBalance(0, CustRecord."No.", 0);
            Amt[2] := GetOperationAccBalanceTxt(ProdtCategory::"Shares Deposit", CustRecord."No.", 2, CustRecord."Currency Code");
            Amt[3] := (Amt[2] - Amt[1]);

            if PFact.Get(LoanType) then
                PFact.TestField("Maximum Loan Amount");

            if Amt[3] <= 0 then begin
                Amt[4] := PFact."Maximum Loan Amount"
            end else begin

                if (checkifCustHasSelfGuaranteed(CustRecord."No.")) or (checkIfMemberhasguaranteedSelf(CustRecord."No.")) then
                    Amt[4] := Amt[3] * (PFact."Maximum Loan Amount" / 100) else
                    Amt[4] := PFact."Maximum Loan Amount"
            end;

            if Amt[4] >= PFact."Maximum Loan Amount" then
                Amt[4] := PFact."Maximum Loan Amount";
            exit(Amt[4]);

        end
    end;

    procedure GetCustAccruedIntLoanBalance(ProdtCategory: Integer; AccNo: Code[50]; ProdtSource: Integer) StringBalTxt: Decimal
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        Loans: Record Loans;
        LoanBal: Decimal;
        AccruedInt: Decimal;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active.';
    begin

        StartDate := CalcDate('-CM', Today);
        EndDate := Today;
        IntDays := (EndDate - StartDate) + 1;
        Loans.Reset();
        Loans.SetRange("Account No.", AccNo);
        if Loans.FindSet() then begin
            repeat
                Loans.CalcFields("Outstanding Balance");
                if Loans."Outstanding Balance" > 0 then begin
                    AccruedInt := AccruedInt + PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, Today);
                    LoanBal := LoanBal + Loans."Outstanding Balance";
                end;
            until Loans.Next() = 0
        end;
        StringBalTxt := (AccruedInt + LoanBal);
        exit(StringBalTxt)
    end;

    procedure checkIfMemberhasguaranteedSelf(MemberNo: Code[100]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        guaranteedPosted: Record "Guarantor & Security Posted";
        accredit: Record "Account Credit";
    begin

        Loans.Reset();
        Loans.SetRange("Account No.", MemberNo);
        Loans.SetFilter("Outstanding Balance", '>0');
        if Loans.FindSet() then begin
            repeat
                accredit.Reset();
                accredit.SetRange("Member No.", MemberNo);
                accredit.SetRange("Account Category", accredit."Account Category"::"Shares Deposit");
                if accredit.FindFirst() then begin
                    guaranteedPosted.Reset();
                    guaranteedPosted.SetRange("Account No.", accredit."No.");
                    guaranteedPosted.SetRange("Loan No.", Loans."No.");
                    guaranteedPosted.SetFilter("Outstanding Balance", '>0');
                    if guaranteedPosted.FindFirst() then begin
                        exit(true)
                    end else begin
                        exit(false)
                    end;
                end;

            until Loans.Next() = 0;
        end;
        exit(false);
    end;

    procedure CheckifCustHasSelfGuaranteed(MemberNo: Code[100]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
    begin
        Loans.Reset();
        Loans.SetRange("Account No.", MemberNo);
        Loans.SetFilter("Outstanding Balance", '>0');
        if Loans.FindSet() then begin
            repeat
                if PFact.Get(Loans."Product Type") then begin
                    case PFact."Deposits Appraisal Parameter" of
                        PFact."Deposits Appraisal Parameter"::Deposits:
                            exit(true) else
                                           exit(false)
                    end;
                end
            Until Loans.Next() = 0;
        end
    end;


    local procedure getcustDepositremittance(CustRec: Code[100]): Integer
    var
        CustMember: Record Member;
    begin
        CustMember.Reset();
        CustMember.SetRange("No.", CustRec);
        if CustMember.FindFirst() then begin

            if CustMember."Allow Min. Banding" then begin
                exit(2)
            end else begin
                if custmonthlyContribution(CustMember."No.") > RegMgt.getAccountShareBand(CustMember."No.") then begin
                    exit(2);
                end else begin
                    if custmonthlyContribution(CustMember."No.") = RegMgt.getAccountShareBand(CustMember."No.") then
                        exit(1) else
                        exit(1);
                end
            end;
        end;
        exit(0);
    end;

    local procedure MaxQualifyingAvailable(CustRec: Code[100]; ProductFact: Code[20]): Decimal
    var
        CustMember: Record Member;
        AccCredit: Record "Account Credit";
        AccountType: Record "Product Factory";
    begin
        AccCredit.Reset();
        AccCredit.SetRange("Member No.", CustRec);
        AccCredit.SetFilter("Balance (LCY)", '>0');
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindFirst() then begin
            AccCredit.CalcFields("Balance (LCY)");

            AccountType.Reset();
            AccountType.SetRange(Status, AccountType.Status::Active);
            AccountType.SetRange("Product ID", ProductFact);
            if AccountType.FindFirst() then begin
                AccountType.TestField("Deposit Multiplier");
                exit(Round((AccCredit."Balance (LCY)" * (AccountType."Deposit Multiplier" / 100))));
            end;
        end;
    end;

    local procedure custSharesDeposit(CustRec: Code[100]): Decimal
    var
        CustMember: Record Member;
        AccCredit: Record "Account Credit";
    begin
        AccCredit.Reset();
        AccCredit.SetRange("Member No.", CustRec);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindFirst() then begin
            AccCredit.CalcFields("Balance (LCY)");
            exit(AccCredit."Balance (LCY)");
        end
    end;

    local procedure custmonthlyContribution(CustRec: Code[100]): Decimal
    var
        CustMember: Record Member;
        AccCredit: Record "Account Credit";
    begin
        AccCredit.Reset();
        AccCredit.SetRange("Member No.", CustRec);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindFirst() then begin
            AccCredit.CalcFields("Balance (LCY)");
            exit(RegMgt.GetMaxMonthlyRemittance(AccCredit."No.", '', 90));
        end
    end;

    local procedure checkcustCreditHistory(CustRec: Code[100]): Integer
    var
        CustMember: Record Member;
        Loan: Record "Loans Categorization";
        DscAppScoring: Record "Rcv01 Appraisal Score Mgt.";
    begin
        Loan.Reset();
        Loan.SetRange("Account No.", CustMember."No.");
        Loan.SetFilter("Outstanding Balance", '> 0');
        Loan.SetFilter("Performance Indicator", '%1|%2|%3|%4', Loan."Performance Indicator"::Doubtfull,
                    Loan."Performance Indicator"::Loss, Loan."Performance Indicator"::Substandard,
                    Loan."Performance Indicator"::Watch);
        if Loan.FindFirst() then begin
            Loan.CalcFields("Outstanding Balance");
            exit(1);
        end else begin
            exit(2);
        end;
    end;

    local procedure calculateDepositExposure(CustMember_No: Code[100]): Integer
    var
        DepositExp: Decimal;
        AccCredit: Record "Account Credit";
        SharesDeposit: Decimal;
    begin
        AccCredit.Reset();
        AccCredit.SetRange("Member No.", CustMember_No);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindFirst() then begin
            AccCredit.CalcFields("Balance (LCY)");
            SharesDeposit := AccCredit."Balance (LCY)";
            if AccCredit."Balance (LCY)" > getcusttotalOutloanMgt(AccCredit."Member No.") then begin
                exit(3);
            end else begin
                if getcusttotalOutloanMgt(AccCredit."Member No.") <= (AccCredit."Balance (LCY)" * 3) then begin
                    exit(2);
                end else begin
                    exit(1);
                end;
            end;
        end;
    end;

    procedure getcustshareBanding(CustMember_No: Code[100]): Decimal
    var
        PostedLoan: Record Loans;
        ShareBanding: Record "Shares Banding";
        PostedAmt: Decimal;
        TempAmt: Decimal;
        accmgt: Record "Account Credit";
        ProdFac: Record "Product Factory";
        MonthlyContrib: Record "Member Monthly Contribution";
    begin

        accmgt.Reset();
        accmgt.SetRange("Member No.", CustMember_No);
        accmgt.SetRange("Account Category", accmgt."Account Category"::"Shares Deposit");
        if not accmgt.FindFirst() then begin
            exit(0);
        end;

        PostedLoan.Reset();
        PostedLoan.SetCurrentKey("Approved Amount");
        PostedLoan.Ascending(false);
        PostedLoan.SetFilter("Outstanding Balance", '>0');
        PostedLoan.SetRange("Account No.", CustMember_No);
        PostedLoan.SetFilter("Deposits Appraisal Parameter", '<>%1', PostedLoan."Deposits Appraisal Parameter"::Collateral);
        if PostedLoan.Find('-') then begin
            PostedAmt := PostedLoan."Approved Amount";
            ShareBanding.Reset();
            if ShareBanding.Find('-') then begin
                repeat
                    if (PostedAmt >= ShareBanding.Minimum) and (PostedAmt <= ShareBanding.Maximum) then begin
                        TempAmt := ShareBanding."Shares Amount";
                    end;
                until ShareBanding.Next() = 0
            end;
        end else begin

            MonthlyContrib.Reset();
            MonthlyContrib.SetRange("Account No.", custMember_No);
            MonthlyContrib.SetRange(Type, MonthlyContrib.Type::"Shares Deposit");
            if MonthlyContrib.FindFirst() then begin
                if MonthlyContrib.Amount = 0 then begin
                    if ProdFac.Get(accmgt."Product Type") then
                        ProdFac.TestField("Minimum Contribution");
                    TempAmt := ProdFac."Minimum Contribution";
                end else begin
                    TempAmt := MonthlyContrib.Amount;
                end;
            end else begin

                if ProdFac.Get(accmgt."Product Type") then
                    ProdFac.TestField("Minimum Contribution");
                TempAmt := ProdFac."Minimum Contribution";
            end;
        end;
        exit(TempAmt);
    end;

    local procedure getcusttotalOutloanMgt(CustMember_No: Code[100]): Decimal

    var
        Loan: Record Loans;
        DepositExp: Decimal;
    begin
        Loan.Reset();
        Loan.SetRange("Account No.", CustMember_No);
        Loan.SetFilter("Outstanding Balance", '>0');
        if Loan.FindSet() then begin
            repeat
                Loan.CalcFields("Outstanding Balance");
                DepositExp := (DepositExp + Loan."Outstanding Balance");
            until Loan.Next() = 0
        end;
        exit(DepositExp);
    end;

    local procedure Updatefailedrequest(MemberNo: Code[20];
     ProductID: Code[20];
     MStatus: Enum MobileLoanStatus;
                  RMarks: Text[150];
                  AppSource: Enum "Rcv13 Docs Application Source")
    LoanApp: Record "DSC Mobile Loan";
    begin
        LoanApp.Init();
        LoanApp."Entry No." := RegMgt.InitNextIntDSCEntryNo();
        LoanApp."Account No." := MemberNo;
        LoanApp.Date := Today;
        LoanApp."Captured By" := UserId;
        LoanApp."Date/Time Captured" := CurrentDateTime;
        LoanApp."Product Type" := ProductID;
        LoanApp.Remarks := RMarks;
        LoanApp.Description := RMarks;
        LoanApp.Status := MStatus;
       LoanApp."Rcv Application Source" := LoanApp."Rcv Application Source"::Mobile;
        LoanApp.Insert(true);
    end;


    procedure GetMaxContribLimit(MemberNo: Code[50]; LoanType: Code[20]; SavingsDays: Integer): Boolean
    var
        AmtMax: Decimal;
        SavAcc: Record "Account Credit";
        RSchedule: Record "Rcv03 Contribution Schedule Mg";
        Schedule: Record "Rcv02 Contribution Schedule-De";
        InitialInstal: Integer;
        RunDate: Date;
        RepayPeriod: Integer;
        InstalNo: Integer;
        InstalNos: Integer;
        ScheduleTxt: Record "Rcv02 Contribution Schedule-De";
        ContribTxt: Record "Member Monthly Contribution";
        SharesContrib: Decimal;
        LastDepositDate: Date;
        LastTransDate: Date;
        accountType: Record "Product Factory";
        detailedLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        Dfilter: Text[100];
    begin

        SavingsDays := 3;

        AmtMax := 0;
        SharesContrib := 0;

        LastDepositDate := 0D;
        LastTransDate := 0D;
        LastTransDate := CalcDate('-1M-1D', Today);
        LastDepositDate := CalcDate('-90D', LastTransDate);

        SavAcc.Reset();
        SavAcc.SetRange("Member No.", MemberNo);
        SavAcc.SetRange("Account Category", SavAcc."Account Category"::"Shares Deposit");
        if SavAcc.FindFirst() then begin
            if accountType.Get(SavAcc."Product Type") then
                accountType.TestField("Minimum Contribution");

            RSchedule.Reset();
            RSchedule.SetRange("Account No.", SavAcc."No.");
            RSchedule.DeleteAll();

            Schedule.Reset();
            Schedule.SetRange("Account No.", SavAcc."No.");
            Schedule.DeleteAll();

            RepayPeriod := 3;
            RunDate := CalcDate('-CM', LastDepositDate);
            repeat

                InstalNos := InstalNos + 1;
                Schedule.Init();
                Schedule."Account No." := SavAcc."No.";
                Schedule."Posting Date" := RunDate;
                Schedule."Installment No." := InstalNos;
                Schedule."Entry No." := InstalNos;
                Schedule."End Date" := CalcDate('40D', RunDate);
                Schedule."Member No." := SavAcc."Member No.";
                Schedule.Amount := 0;
                Schedule.Insert(true);
                RunDate := CalcDate('40D', RunDate);

            until InstalNos = SavingsDays;

            Dfilter := format(RunDate) + '..' + Format(LastTransDate);

            detailedLedgerEntry.Reset();
            detailedLedgerEntry.SetRange("Customer No.", SavAcc."No.");
            detailedLedgerEntry.SetFilter("Posting Date", Dfilter);
            detailedLedgerEntry.SetFilter("Amount (LCY)", '< 0');
            if detailedLedgerEntry.FindSet() then begin
                repeat
                    InstalNo := InstalNo + 1;

                    RSchedule.Init();
                    RSchedule."Account No." := detailedLedgerEntry."Customer No.";
                    RSchedule."Posting Date" := detailedLedgerEntry."Posting Date";
                    RSchedule."Installment No." := InstalNo;
                    RSchedule."Entry No." := detailedLedgerEntry."Entry No.";
                    RSchedule."Member No." := SavAcc."Member No.";
                    RSchedule.Amount := detailedLedgerEntry."Amount (LCY)" * -1;
                    RSchedule.Insert(true);
                Until detailedLedgerEntry.Next() = 0
            end;

            FetchMemberDailySavings(SavAcc."No.");
            ScheduleTxt.Reset();
            ScheduleTxt.SetRange("Account No.", SavAcc."No.");
            ScheduleTxt.SetFilter("Member No.", SavAcc."Member No.");
            if ScheduleTxt.FindSet() then begin
                repeat
                    if ScheduleTxt.Amount < accountType."Minimum Contribution" then
                        exit(true)
                until ScheduleTxt.Next() = 0;
            end else begin
                exit(true)
            end;
        end;
    end;

    local procedure FetchMemberDailySavings(AcNo: Code[20])
    var
        CShedule: record "Contribution Schedule-Deposit";
        SavLedgers: Record "Detailed Cust. Ledg. Entry";
        dfilter: Text[100];
        Postamount: Decimal;

    begin
        CShedule.Reset();
        CShedule.SetRange("Account No.", AcNo);
        if CShedule.FindSet() then begin
            repeat
                Postamount := 0;
                dfilter := '';
                dfilter := Format(CShedule."Posting Date") + '..' + Format(CShedule."End Date");

                SavLedgers.Reset();
                SavLedgers.SetRange("Customer No.", CShedule."Account No.");
                SavLedgers.SetFilter("Amount (LCY)", '< 0');
                SavLedgers.SetFilter("Posting Date", dfilter);
                if SavLedgers.FindSet() then begin
                    SavLedgers.CalcSums("Amount (LCY)");
                    Postamount := Abs(SavLedgers."Amount (LCY)");
                    CShedule.Amount := Postamount;
                    CShedule.Modify(true);
                end;
            until CShedule.Next() = 0;
        end;
    end;

    procedure getcheckcontribution(MemberNo: Code[50]; LoanType: Code[20]; SavingsDays: Integer): Boolean
    var
        AmtMax: Decimal;
        SavAcc: Record "Account Credit";
        RSchedule: Record "Rcv03 Contribution Schedule Mg";
        Schedule: Record "Rcv02 Contribution Schedule-De";
        InitialInstal: Integer;
        RunDate: Date;
        RepayPeriod: Integer;
        InstalNo: Integer;
        InstalNos: Integer;
        ScheduleTxt: Record "Rcv02 Contribution Schedule-De";
        ContribTxt: Record "Member Monthly Contribution";
        SharesContrib: Decimal;
        LastDepositDate: Date;
        LastTransDate: Date;
        accountType: Record "Product Factory";
        CustLedgerEntryRecord: Record "Detailed Cust. Ledg. Entry";
        Dfilter: Text[100];
        shareBandingMin: Decimal;
        i: Integer;
        custrecord: Record Member;
        maxcontrib: Decimal;
        mincontrib: Decimal;
        mincount: Integer;
        entrynotfound: Boolean;
    begin

        SavingsDays := 3;

        AmtMax := 0;
        SharesContrib := 0;
        maxcontrib := 0;
        mincontrib := 0;
        mincount := 0;
        entrynotfound := false;

        Schedule.SetRange("Member No.", MemberNo);
        Schedule.DeleteAll();

        if custrecord.Get(MemberNo) then
            shareBandingMin := getcustshareBanding(MemberNo);

        LastDepositDate := 0D;
        LastTransDate := 0D;
        LastTransDate := CalcDate('-1M-1D', Today);
        LastDepositDate := CalcDate('-90D', LastTransDate);
        dfilter := format(LastDepositDate) + '..' + Format(CalcDate('CM', LastTransDate));

        SavAcc.Reset();
        SavAcc.SetRange("Member No.", MemberNo);
        SavAcc.SetRange("Account Category", SavAcc."Account Category"::"Shares Deposit");
        if SavAcc.FindFirst() then begin
            if accountType.Get(SavAcc."Product Type") then
                accountType.TestField("Minimum Contribution");

            RSchedule.SetRange("Account No.", SavAcc."No.");
            RSchedule.DeleteAll();

            CustLedgerEntryRecord.Reset();
            CustLedgerEntryRecord.SetFilter("Amount (LCY)", '< 0');
            CustLedgerEntryRecord.SetFilter("Posting Date", dfilter);
            CustLedgerEntryRecord.SetRange("Customer No.", SavAcc."No.");
            CustLedgerEntryRecord.SetFilter("Document No.", '<>%1', 'OPENBALDEP');
            if CustLedgerEntryRecord.FindSet() then begin
                repeat

                    InstalNos := InstalNos + 1;
                    i := i + 1;

                    RSchedule.Init();
                    RSchedule."Installment No." := i;
                    RSchedule."Member No." := SavAcc."Member No.";
                    RSchedule."Account No." := SavAcc."No.";
                    RSchedule."Entry No." := CustLedgerEntryRecord."Entry No.";
                    RSchedule."Posting Date" := CustLedgerEntryRecord."Posting Date";
                    RSchedule.Amount := CustLedgerEntryRecord."Amount (LCY)" * -1;
                    RSchedule.Insert(true);

                until CustLedgerEntryRecord.Next() = 0;
            end;

            consolidatecontrib(SavAcc."Member No.");

            ScheduleTxt.Reset();
            ScheduleTxt.SetRange("Account No.", SavAcc."No.");
            ScheduleTxt.SetFilter("Member No.", SavAcc."Member No.");
            if ScheduleTxt.FindSet() then begin
                ScheduleTxt.CalcSums(Amount);
                mincontrib := ScheduleTxt.Amount;
                mincount := ScheduleTxt.Count;
            end else begin
                entrynotfound := true
            end;
            if entrynotfound then begin
                exit(true)
            end else begin

                if (mincontrib >= (accountType."Minimum Contribution" * 2)) and (mincount >= 2) then
                    exit(false) else
                    exit(true)
            end;
        end
    end;

    local procedure GetPostedfacility(MemberNo: Code[50]; LoanType: Code[20]): Decimal
    var
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        counter: Integer;
        Productype: Record "Product Factory";

    begin
        if checkIfcustIsdefaulter(MemberNo) then begin
            exit(0);
        end else begin

            if productype.Get(LoanType) then
                productype.TestField("Maximum Loan Amount");

            counter := 0;
            PostedLoan.Reset();
            PostedLoan.SetCurrentKey("Disbursement Date");
            PostedLoan.Ascending(false);
            PostedLoan.SetRange("Account No.", MemberNo);
            PostedLoan.SetRange("Product Type", LoanType);
            PostedLoan.SetRange("Approval Status", PostedLoan."Approval Status"::Posted);
            if PostedLoan.FindSet() then begin
                repeat
                    counter := counter + 1;
                    PostedAmt := PostedAmt + PostedLoan."Approved Amount";
                    if counter = 3 then
                        exit(PostedAmt)
                until PostedLoan.Next() = 0;
            end else begin
                exit(0);
            end;
        end
    end;

    local procedure checkIfCustHasPaidBeforeEndDate(MemberNo: Code[50]; LoanType: Code[20]): Decimal
    var
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        counter: Integer;
        Productype: Record "Product Factory";

    begin
        if checkIfcustIsdefaulter(MemberNo) then begin
            exit(0);
        end else begin

            Productype.Reset();
            if productype.Get(LoanType) then
                productype.TestField("Maximum Loan Amount");

            counter := 0;
            PostedLoan.Reset();
            PostedLoan.SetCurrentKey("Disbursement Date");
            PostedLoan.Ascending(false);
            PostedLoan.SetRange("Account No.", MemberNo);
            PostedLoan.SetRange("Product Type", LoanType);
            PostedLoan.SetRange("Approval Status", PostedLoan."Approval Status"::Posted);
            if PostedLoan.FindSet() then begin
                repeat
                    counter := counter + 1;
                    PostedAmt := PostedAmt + PostedLoan."Approved Amount";
                    if counter = 3 then
                        exit(PostedAmt)
                until PostedLoan.Next() = 0;
            end else begin
                exit(0);
            end;
        end
    end;


    local procedure GetLastPayDate(MemberNo: Code[50]; LoanType: Code[20]): Date
    var
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        counter: Integer;
        Productype: Record "Product Factory";
    begin
        if productype.Get(LoanType) then
            productype.TestField("Maximum Loan Amount");
        PostedLoan.SetCurrentKey("Disbursement Date");

        PostedLoan.Ascending(false);
        PostedLoan.SetRange("Account No.", MemberNo);
        PostedLoan.SetRange("Product Type", LoanType);
        PostedLoan.SetRange("Approval Status", PostedLoan."Approval Status"::Posted);
        if PostedLoan.FindSet() then begin
            repeat
                PostedLoan.CalcFields("Last Pay Date");
                counter := counter + 1;
                if counter = 3 then
                    exit(PostedLoan."Last Pay Date");
            until PostedLoan.Next() = 0;
        end else begin
            exit(0D);
        end;

    end;

    procedure checkIfcustIsdefaulter(CustRec: Code[100]): Boolean
    var
        mobtranstype: Record "Transaction Types-Mobile";
        dfilter: Text;
        startdate: Date;
        enddate: Date;
    begin

        startdate := CalcDate('-1Y', Today);
        enddate := Today;
        dfilter := Format(startdate) + '..' + Format(enddate);
        mobtranstype.Reset();
        mobtranstype.SetRange("Account No.", CustRec);
        mobtranstype.SetFilter("Application Date", dfilter);
        mobtranstype.SetRange("Transaction Type", mobtranstype."Transaction Type"::"Recovery from Deposits");
        if mobtranstype.FindFirst() then begin
            exit(true);
        end else begin
            exit(false);
        end;
    end;



    procedure consolidatecontrib(MemberNo: Code[50]): Boolean
    var
        i: Integer;
        AmtMax: Decimal;
        SavAcc: Record "Account Credit";
        RSchedule: Record "Rcv03 Contribution Schedule Mg";
        Schedule: Record "Rcv02 Contribution Schedule-De";
        LastDepositDate: Date;
        LastTransDate: Date;
        accountType: Record "Product Factory";
        FromDate: Date;
        ToDate: Date;
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text[100];
    begin

        LastDepositDate := 0D;
        LastTransDate := 0D;
        LastTransDate := CalcDate('-1M-1D', Today);
        LastDepositDate := CalcDate('-90D', LastTransDate);
        StartDate := CalcDate('-CM', LastDepositDate);
        EndDate := CalcDate('CM', LastTransDate);

        SavAcc.Reset();
        SavAcc.SetRange("Member No.", MemberNo);
        SavAcc.SetRange("Account Category", SavAcc."Account Category"::"Shares Deposit");
        if SavAcc.FindFirst() then begin

            if accountType.Get(SavAcc."Product Type") then
                accountType.TestField("Minimum Contribution");

            FromDate := StartDate;
            ToDate := CalcDate('1M-1D', StartDate);
            if (ToDate <= EndDate) then begin
                DateFilter := Format(FromDate) + '..' + Format(ToDate);


                RSchedule.SetRange("Account No.", SavAcc."No.");
                RSchedule.SetFilter("Posting Date", DateFilter);
                if RSchedule.FindSet() then begin
                    RSchedule.CalcSums(Amount);


                    Schedule.Init();
                    Schedule."Account No." := SavAcc."No.";
                    Schedule."Posting Date" := RSchedule."Posting Date";
                    Schedule."Installment No." := 1;
                    Schedule."Entry No." := RSchedule."Entry No.";
                    Schedule."End Date" := ToDate;
                    Schedule."Start Date" := FromDate;
                    Schedule."Member No." := RSchedule."Member No.";
                    Schedule.Balance := RSchedule.Amount;
                    Schedule.Amount := RSchedule.Amount;
                    if Schedule.Amount > 0 then
                        Schedule.Insert(true);
                end
            end;

            FromDate := CalcDate('1M', StartDate);
            ToDate := CalcDate('2M-1D', StartDate);
            if (ToDate <= EndDate) then begin
                DateFilter := Format(FromDate) + '..' + Format(ToDate);


                RSchedule.SetRange("Account No.", SavAcc."No.");
                RSchedule.SetFilter("Posting Date", DateFilter);
                if RSchedule.FindSet() then begin
                    RSchedule.CalcSums(Amount);

                    Schedule.Init();
                    Schedule."Account No." := SavAcc."No.";
                    Schedule."Posting Date" := RSchedule."Posting Date";
                    Schedule."Installment No." := 2;
                    Schedule."Entry No." := RSchedule."Entry No.";
                    Schedule."End Date" := ToDate;
                    Schedule."Start Date" := FromDate;
                    Schedule."Member No." := RSchedule."Member No.";
                    Schedule.Balance := RSchedule.Amount;
                    Schedule.Amount := RSchedule.Amount;
                    if Schedule.Amount > 0 then
                        Schedule.Insert(true);
                end
            end;

            FromDate := CalcDate('2M', StartDate);
            ToDate := CalcDate('3M-1D', StartDate);
            if (ToDate <= EndDate) then begin

                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RSchedule.SetRange("Account No.", SavAcc."No.");
                RSchedule.SetFilter("Posting Date", DateFilter);
                if RSchedule.FindSet() then begin
                    RSchedule.CalcSums(Amount);

                    Schedule.Init();
                    Schedule."Account No." := SavAcc."No.";
                    Schedule."Posting Date" := RSchedule."Posting Date";
                    Schedule."Installment No." := 3;
                    Schedule."Entry No." := RSchedule."Entry No.";
                    Schedule."End Date" := ToDate;
                    Schedule."Start Date" := FromDate;
                    Schedule."Member No." := RSchedule."Member No.";
                    Schedule.Balance := RSchedule.Amount;
                    Schedule.Amount := RSchedule.Amount;
                    if Schedule.Amount > 0 then
                        Schedule.Insert(true);
                end
            end;

            FromDate := CalcDate('3M', StartDate);
            ToDate := CalcDate('4M-1D', StartDate);
            if (ToDate <= EndDate) then begin

                DateFilter := Format(FromDate) + '..' + Format(ToDate);
                RSchedule.SetRange("Account No.", SavAcc."No.");
                RSchedule.SetFilter("Posting Date", DateFilter);
                if RSchedule.FindSet() then begin
                    RSchedule.CalcSums(Amount);

                    Schedule.Init();
                    Schedule."Account No." := SavAcc."No.";
                    Schedule."Posting Date" := RSchedule."Posting Date";
                    Schedule."Installment No." := 3;
                    Schedule."Entry No." := RSchedule."Entry No.";
                    Schedule."End Date" := ToDate;
                    Schedule."Start Date" := FromDate;
                    Schedule."Member No." := RSchedule."Member No.";
                    Schedule.Balance := RSchedule.Amount;
                    Schedule.Amount := RSchedule.Amount;
                    if Schedule.Amount > 0 then
                        Schedule.Insert(true);
                end
            end;
        end;
    end;


    local procedure InitializeScore(AccountNo: Code[100]; Product_ID: Code[20]; Member_Name: Text[100]; CustMember_Status: Enum MemberStatus; Registration_Date: Date;
                                                                                                                               CustMember_Rejoined: Boolean)
    var
        DscAppScoring: Record "Rcv01 Appraisal Score Mgt.";
        AppScoringMgt: Record "Rcv01 Appraisal Score Mgt.";
    begin

        AppScoringMgt.Reset();
        AppScoringMgt.SetRange("Account No.", AccountNo);
        AppScoringMgt.SetRange("Product Type", Product_ID);
        AppScoringMgt.DeleteAll();
    end;

    local procedure clearExistingLoanAppMgt(MemberNo: Code[20]; ProductID: Code[20])
    var
        LoanApp: Record "DSC Mobile Loan";
    begin

        LoanApp.Reset();
        LoanApp.SetRange("Account No.", MemberNo);
        LoanApp.SetRange("Product Type", ProductID);
        LoanApp.SetRange("Rcv Application Source", LoanApp."Rcv Application Source"::Appraisal);
        LoanApp.DeleteAll();
    end;

    local procedure clearExistingQcQualMgt(MemberNo: Code[20]; ProductID: Code[20])
    var
        QcQualifyAmt: Record "QC Qualifying Amount";
    begin
        QcQualifyAmt.Reset();
        QcQualifyAmt.SetRange("Account No.", MemberNo);
        QcQualifyAmt.SetRange("Product Type", ProductID);
        QcQualifyAmt.DeleteAll();
    end;

    local procedure clearExistingScoreQualMgt(MemberNo: Code[20])
    var
        QcQualifyAmt: Record "Rcv01 Appraisal Score Mgt.";
    begin
        QcQualifyAmt.Reset();
        QcQualifyAmt.SetRange("Account No.", MemberNo);
        if QcQualifyAmt.FindSet() then
            QcQualifyAmt.DeleteAll();
    end;

    procedure fncheckIfCustHasgraduated(AccNo: code[100]; LoanType: Code[10]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        Amt: Decimal;
        CredLedger: Record "Cust. Ledger Entry";
        QcQualifyMngt: Record "QC. Grad. Qualification";
        credscoretmgt: Codeunit "Rcv07 Credit Score Engine Mgt.";
        dfilter: Text;
        startdate: Date;
        enddate: Date;
    begin

        startdate := CalcDate('-3M', Today);
        enddate := Today;
        dfilter := Format(startdate) + '..' + Format(enddate);
        if credscoretmgt.checkIfcustIsdefaulter(AccNo) then begin
            exit(false)
        end else begin

            QcQualifyMngt.SetRange("No.", AccNo);
            QcQualifyMngt.SetRange("Product Type", LoanType);
            QcQualifyMngt.SetFilter("Date Posted", dfilter);
            QcQualifyMngt.SetRange("Qualifying Direction", QcQualifyMngt."Qualifying Direction"::Graduate);
            if QcQualifyMngt.FindFirst() then begin
                exit(true)
            end else begin
                exit(false)
            end
        end
    end;

    procedure InitializeScore(AccountNo: Code[100]; ProdFactory: Code[10])
    var
        DscAppScoring: Record "Rcv01 Appraisal Score Mgt.";
    begin
        DscAppScoring.Reset();
        DscAppScoring.SetRange("Account No.", AccountNo);
        if DscAppScoring.Find('-') then
            DscAppScoring.Delete();
    end;

    procedure fnCustHasLoanWithinDeposit(MemberNo: Code[100]; LoanType: code[10]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        Amt: array[4] of Decimal;

    begin

        Amt[1] := 0;
        Amt[2] := 0;
        Amt[3] := 0;
        Amt[4] := 0;

        if CustRecord.Get(MemberNo) then begin
            Amt[1] := getCustAccruedIntLoanBalance(0, CustRecord."No.", 0);
            Amt[2] := GetOperationAccBalanceTxt(ProdtCategory::"Shares Deposit", CustRecord."No.", 2, CustRecord."Currency Code");
            Amt[3] := (Amt[2] - Amt[1]);

            if Amt[1] <= Amt[2] then
                exit(true) else
                exit(false)
        end
    end;




    procedure GetOperationAccBalanceTxt(ProdtCategory: Enum ProductAccountCategory; AccNo: Code[50];
    ProdtSource: Integer; CurrencyCode: Code[20]) StringBalTxt: Decimal
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active.Status- %1 | Balance %2';
    begin
        case ProdtSource of
            1:
                begin
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", AccNo);
                    AccountB.SetRange("Currency Code", CurrencyCode);
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.FindFirst() then begin
                        AccountB.CalcFields("Balance (LCY)", Balance);
                        if AccountB."Currency Code" = '' then
                            StringBalTxt := AccountB."Balance (LCY)" else
                            StringBalTxt := AccountB.Balance
                    end;
                end;
            2:
                begin

                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetFilter("Balance (LCY)", '>0');
                    CredAc.SetRange("Currency Code", CurrencyCode);
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.FindFirst() then begin
                        CredAc.CalcFields("Balance (LCY)", Balance);
                        if CredAc."Currency Code" = '' then
                            StringBalTxt := CredAc."Balance (LCY)" else
                            StringBalTxt := CredAc.Balance
                    end else begin
                        Error(ErrorOnNonFoundAccounDetails, CredAc.Status, CredAc."Balance (LCY)")
                    end

                end;
        end;
        exit(StringBalTxt)
    end;

    procedure CheckIfCustHasNoExistLoan(MemberNo: Code[100]): Boolean
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
    begin

        if CustRecord.Get(MemberNo) then begin
            if GetCustAccruedIntLoanBalance(0, CustRecord."No.", 0) = 0 then begin
                exit(true)
            end else begin
                exit(false)
            end
        end;
    end;

    local procedure InitializeScoringMgt(VarVariant: Record Member; var QCDetails: Record "Rcv01 Appraisal Score Mgt.")
    begin
        QCDetails.Init;
        QCDetails.CopyfromCustDetailMgt(VarVariant);
    end;

    var
        LoanApp: Record "DSC Mobile Loan";
        RegMgt: Codeunit "Register Management";
        RegistryMngt: Codeunit "Registry Mngt.";
        ProdtCategory: Enum ProductAccountCategory;
        Text0001: Label 'Member has Shares Deposit Less than Min. Balance of  ';
        Text0002: Label 'Member has no Deposit Account';
        Text0003: Label 'Member Registration Date is less Min. Period of 90 Days ';
        Text0004: Label 'Member Registration Date is less Min. Period of 180 Days ';
        Text0005: Label 'Member has a Mobile status marked as ';
        Text0006: Label 'Member has not constantly contributed above Min. limit for the last 90 days ';
        Text0007: Label 'Member has not constantly been contributing above required Min. Limit';
        Text0008: Label 'Product Type has no Min/Max Loan Amount defined';
        Text0009: Label 'Product Type has no Deposit Multiplier defined';
        Text0010: Label 'Member has an Same existing active loan';
        Text0011: Label 'Member has Shares Deposit Less than Min. Balance of  ';
        Text0012: Label 'Member has no Shares Capital Account';
        Text0013: Label 'Member has scored more than Max. required Score of 15. Total Score is ';
        Text0014: Label 'Appraised successfully';
        Text0015: Label 'Error occurred while saving scoring details';
        Text0016: Label 'Product Type not found';
        Text0017: Label 'Member Registration Date is null. Cannot proceed';
        Text0018: Label 'Member Fosa Account is not active and therefore cannot transact.';
        Text00019: Label 'Member not ligible for Mobile Loan. the account status is %1';

}
