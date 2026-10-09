codeunit 50031 "Doc-PostMgt"
{

    trigger OnRun()
    begin
    end;

    var
        ErrOnNotApprovedDocTxt: Label 'Application %1 is not fully approved';
        ApprovalsMngt: Codeunit "Approval Mgmt.";
        CredMngt: Codeunit "Credit Mgmt.";
        ErrorOnNoRepaymentSchd: Label 'No repayment schedule generated for this loan';
        ErrorOnBlankApplicNosTxt: Label 'Loan No must have a value in application No. It cannot be blank.';
        LoanChargePosted: Record "Loan Charge Posted";
        GuarantorSecurityPosted: Record "Guarantor & Security Posted";
        LoansTopupPosted: Record "Loans Top up Posted";
        LoanApplicationCharges: Record "Loan Application Charge";
        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
        LoansTopup: Record "Loans Top up";
        OnCompleteMsgTxt: Label 'Application No. %1 Successfull created and Posted.';
        ErrorOnDuplicationEntryNoTxt: Label 'This Application has been already created and registed.';
        Loans: Record Loans;
        CreateNotif: Codeunit "SMS Notification";
        NotifSource: Enum NotifSourceType;
        CompInfo: Record "Company Information";


    procedure LoanRegistration(LoanApplication: Record "Loan Application"; PostInt: Integer)
    var
        LoanNo: Code[20];
        AppCharges: Record "Loan Application Charge";
        GuarantorSecurity: Record "Loan Guarantors and Security";
        LnTopup: Record "Loans Top up";
        LoanDisbLine: Record "Loan Disbursement Lines";
    begin

        if LoanApplication."Approval Status" = LoanApplication."Approval Status"::Approved then begin
            LoanApplication.CheckMinRequirement();

            if LoanApplication.fnCheckOnExistingApplicationEntry then
                Error(ErrorOnDuplicationEntryNoTxt);

            LoanNo := '';

            case LoanApplication."Application Type" of
                LoanApplication."Application Type"::Defaulter:
                    begin
                        LoanNo := '';

                        LoanNo := CredMngt.PostLoanAcc(LoanApplication);
                        if LoanNo <> '' then begin
                            Loans.Reset;
                            Loans.SetRange("Application No.", LoanApplication."No.");
                            if Loans.Find('-') then begin

                                LoanApplication."Posted By" := UserId;
                                LoanApplication."Time Posted" := Time;
                                LoanApplication."Date Posted" := Today;
                                LoanApplication."Loan Status" := LoanApplication."Loan Status"::Issued;
                                LoanApplication."Approval Status" := LoanApplication."Approval Status"::Posted;
                                LoanApplication.Modify(true);

                                case LoanApplication."Application Type" of
                                    LoanApplication."Application Type"::Defaulter:
                                        begin
                                            LoanDisbLine.Reset();
                                            LoanDisbLine.SetRange("Application No.", LoanApplication."No.");
                                            if LoanDisbLine.FindFirst() then begin
                                                LoanDisbLine."Loan Entry No." := LoanNo;
                                                LoanDisbLine."Buff. Applic No." := LoanApplication."No.";
                                                LoanDisbLine."Buff.Loan Entry No." := LoanNo;
                                                LoanDisbLine.Modify(true)
                                            end;
                                        end;
                                end;
                            end;
                        end;

                    end else begin
                    if ApprovalsMngt.CheckBlockedDocsOnJnls(LoanApplication."No.", Database::"Loan Application") then begin
                        LoanNo := CredMngt.PostLoanAcc(LoanApplication);
                        if LoanNo <> '' then begin

                            LoanChargePosted.LockTable;
                            LoanApplicationCharges.Reset;
                            LoanApplicationCharges.SetRange("Application No.", LoanApplication."No.");
                            if LoanApplicationCharges.FindSet then begin
                                repeat
                                    InitLoanChargesEntry(LoanApplicationCharges, LoanChargePosted, LoanNo);
                                    LoanChargePosted."Charge Code" := LoanApplicationCharges."Charge Code";
                                    LoanChargePosted."Product Code" := LoanApplication."Product Type";
                                    LoanChargePosted."Staggered Charge Code" := LoanApplicationCharges."Staggered Charge Code";
                                    LoanChargePosted."Application No." := LoanApplicationCharges."Application No.";
                                    LoanChargePosted.Insert(true);
                                until LoanApplicationCharges.Next = 0;
                            end;

                            GuarantorSecurityPosted.LockTable;
                            LoanGuarantorsandSecurity.Reset;
                            LoanGuarantorsandSecurity.SetRange("No.", LoanApplication."No.");
                            if LoanGuarantorsandSecurity.FindSet then begin
                                repeat
                                    fnInitLoanSecEntry(LoanGuarantorsandSecurity, GuarantorSecurityPosted, LoanNo);
                                    GuarantorSecurityPosted."No." := LoanApplication."No.";
                                    GuarantorSecurityPosted.Name := LoanGuarantorsandSecurity.Name;
                                    GuarantorSecurityPosted."Product Type" := LoanGuarantorsandSecurity."Product Type";
                                    GuarantorSecurityPosted."Account No." := LoanGuarantorsandSecurity."Account No.";
                                    GuarantorSecurityPosted."Deposit Shares" := LoanGuarantorsandSecurity."Deposit Shares";
                                    GuarantorSecurityPosted.Insert(true);
                                until LoanGuarantorsandSecurity.Next = 0;
                            end;
                            LoanApplication.CalcFields("Total TopUp");
                            if LoanApplication."Total TopUp" > 0 then begin
                                LoansTopupPosted.LockTable;

                                LoansTopup.Reset;
                                LoansTopup.SetRange("No.", LoanApplication."No.");
                                LoansTopup.SetRange("Account No.", LoanApplication."Account No.");
                                if LoansTopup.FindSet then begin
                                    repeat
                                        InitLoanTopupEntry(LoansTopup, LoansTopupPosted, LoanNo);
                                        LoansTopupPosted."Loan Top Up" := LoansTopup."Loan Top Up";
                                        LoansTopupPosted."Account No." := LoansTopup."Account No.";
                                        LoansTopupPosted."No." := LoanApplication."No.";
                                        LoansTopupPosted.Insert(true);
                                    until LoansTopup.Next = 0;
                                end;
                            end;

                            AppCharges.Reset;
                            AppCharges.SetRange("Application No.", LoanApplication."No.");
                            if AppCharges.FindSet then
                                AppCharges.ModifyAll("Approval Status",
                              AppCharges."Approval Status"::Posted);

                            LnTopup.Reset;
                            LnTopup.SetRange("No.", LoanApplication."No.");
                            if LnTopup.FindSet then
                                LnTopup.ModifyAll("Approval Status", LnTopup."Approval Status"::Posted);

                            GuarantorSecurity.Reset;
                            GuarantorSecurity.SetRange("No.", LoanApplication."No.");
                            if GuarantorSecurity.FindSet then
                                GuarantorSecurity.ModifyAll("Approval Status",
                              GuarantorSecurity."Approval Status"::Posted);

                            Loans.Reset;
                            Loans.SetRange("Application No.", LoanApplication."No.");
                            if Loans.Find('-') then begin
                                LoanApplication."Posted By" := UserId;
                                LoanApplication."Time Posted" := Time;
                                LoanApplication."Date Posted" := Today;
                                LoanApplication."Loan Status" := LoanApplication."Loan Status"::Issued;
                                LoanApplication."Approval Status" := LoanApplication."Approval Status"::Posted;
                                LoanApplication.Modify
                            end;

                            case PostInt of
                                1:
                                    begin
                                        Message(OnCompleteMsgTxt, LoanNo)
                                    end;
                            end
                        end else begin
                            Error(ErrorOnBlankApplicNosTxt, LoanApplication."No.")
                        end
                    end else begin
                        Error(ErrOnNotApprovedDocTxt, LoanApplication."No.")
                    end
                end
            end
        end else begin
            Error('Application status %1 is still Pending Approval-%2', LoanApplication."Approval Status", LoanApplication."No.")
        end;
    end;

    local procedure fnInitLoanSecEntry(RecRef: Record "Loan Guarantors and Security"; var LoanSecRecordEntry: Record "Guarantor & Security Posted"; LoanNo: Code[20])
    begin
        LoanSecRecordEntry.Init;
        LoanSecRecordEntry.CopyFromLoanGuarantLine(RecRef);
        LoanSecRecordEntry."Loan No." := LoanNo;
        OnAfterInitLoanSecEntry(LoanSecRecordEntry, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanSecEntry(var LoanSecEntry: Record "Guarantor & Security Posted"; Applic: Record "Loan Guarantors and Security")
    begin
    end;

    procedure InitLoanChargesEntry(RecRef: Record "Loan Application Charge"; var LoanChargeRecordEntry: Record "Loan Charge Posted"; LoanNo: Code[10])
    begin
        LoanChargeRecordEntry.Init;
        LoanChargeRecordEntry.CopyFromPostedChargesLine(RecRef);
        LoanChargeRecordEntry."Loan No." := LoanNo;
        OnAfterInitLoanChargesEntry(LoanChargeRecordEntry, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanChargesEntry(var LoanChargeEntry: Record "Loan Charge Posted"; Applic: Record "Loan Application Charge")
    begin

    end;

    local procedure InitLoanTopupEntry(RecRef: Record "Loans Top up"; var LoanTopupRecordEntry: Record "Loans Top up Posted"; LoanNo: Code[10])
    begin
        LoanTopupRecordEntry.Init;
        LoanTopupRecordEntry.CopyFromLoansTopup(RecRef);
        LoanTopupRecordEntry."Loan No." := LoanNo;
        OnAfterInitLoanTopupEntry(LoanTopupRecordEntry, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanTopupEntry(var LoanChargeEntry: Record "Loans Top up Posted"; Applic: Record "Loans Top up")
    begin
    end;

    procedure InitNextEntryNo(): Integer
    var
        RecRef: Record "Loan Recovery Mngt.";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure CreateRecovLine(AccNo: Code[100]; MemberNo: Code[100]; SharesDeposits: Decimal; ApprovedAmount: Decimal; OutInterest: Decimal; OutPrincipal: Decimal; ProducType: Code[20]; SharesDeductable: Decimal; AppType: Integer; LoanNo: Code[50]; HeaderNo: Code[50])
    var
        LnRecoveryMngt: Record "Loan Recovery Mngt.";
    begin
        LnRecoveryMngt.Init();
        LnRecoveryMngt."Entry No." := InitNextEntryNo();
        LnRecoveryMngt."Account No." := AccNo;
        LnRecoveryMngt.Validate("Member No.", MemberNo);
        LnRecoveryMngt."Shares Deposit" := SharesDeposits;
        LnRecoveryMngt."Approved Amount" := ApprovedAmount;
        LnRecoveryMngt."Posted By" := UserId;
        LnRecoveryMngt."Date Posted" := Today;
        LnRecoveryMngt."Time Posted" := Time;
        LnRecoveryMngt."Outstanding Interest" := OutInterest;
        LnRecoveryMngt."Outstanding Principal" := OutPrincipal;
        LnRecoveryMngt."Loan No." := LoanNo;
        LnRecoveryMngt."Product Type" := ProducType;
        LnRecoveryMngt."Shares Deducted" := SharesDeductable;
        LnRecoveryMngt."Haeder No." := HeaderNo;
        case AppType of
            1:
                LnRecoveryMngt."Recovery Type" := LnRecoveryMngt."Recovery Type"::Banking;
            2:
                LnRecoveryMngt."Recovery Type" := LnRecoveryMngt."Recovery Type"::Shares;
            3:
                LnRecoveryMngt."Recovery Type" := LnRecoveryMngt."Recovery Type"::Guarantors;
        end;
        LnRecoveryMngt.Insert(true)
    end;

    procedure GenerateDormantAcMngt(Source: Integer; AccNo: Code[100])
    Var
        AccBanking: Record "Account Banking";
        CredAcc: Record "Account Credit";
        ProdFact: Record "Product Factory";
        VarVariant: Variant;
        CustMember: Record Member;

    begin
        if Source = 1 then begin

            AccBanking.Reset();
            AccBanking.SetRange("No.", AccNo);
            if AccBanking.FindFirst() then begin
                AccBanking.CalcFields("Last Transaction Date");
                if ProdFact.Get(AccBanking."Product Type") then begin
                    ProdFact.TestField("Dormancy Period");
                    case
                        AccBanking.Status of
                        AccBanking.Status::New,
                        AccBanking.Status::Active:
                            begin
                                if AccBanking."Last Transaction Date" <> 0D then begin
                                    if CalcDate(ProdFact."Dormancy Period", AccBanking."Last Transaction Date") <= Today then begin
                                        AccBanking.Status := AccBanking.Status::Dormant;
                                        AccBanking.Blocked := AccBanking.Blocked::Payment;
                                        AccBanking."Last Date Modified-Dormancy" := Today;
                                        AccBanking.Modify(true);
                                        if AccBanking."Mobile No." <> '' then begin
                                            CreateNotif.CreateSmsNotif(NotifSource::"ATM Collection",
                                           AccBanking."Mobile No.", 'Dear ' + AccBanking.Name + ' your Fosa account is Dormant. Kindly contact us via info@unsacco.org or +2540207622700 for reactivation.' + ' ' + CompInfo."Phone No.", AccBanking."No.",
                                       AccBanking."Member No.", false);
                                            VarVariant := AccBanking;
                                            //CreateNotif.SendEmailNotification(VarVariant, 0, AccBanking."No.");
                                        end;
                                    end;
                                end;
                            end;
                    end;
                end;
            end;
        end else begin

            CredAcc.Reset();
            CredAcc.SetRange("No.", AccNo);
            if CredAcc.FindFirst() then begin
                CredAcc.CalcFields("Last Transaction Date");
                if ProdFact.Get(CredAcc."Product Type") then begin
                    ProdFact.TestField("Dormancy Period");

                    case CredAcc.Status of
                        CredAcc.Status::New,
                          CredAcc.Status::Active:
                            begin
                                if CredAcc."Last Transaction Date" <> 0D then begin
                                    if CalcDate(ProdFact."Dormancy Period", CredAcc."Last Transaction Date") < Today then begin
                                        CredAcc.Status := CredAcc.Status::Dormant;

                                        CredAcc."Last Date Modified-Dormancy" := Today;
                                        CredAcc.Modify(true);
                                        if CustMember.Get(CredAcc."Member No.") then begin
                                            CustMember.Status := CustMember.Status::Dormant;
                                            CustMember.Modify(true);
                                        end;
                                        if CredAcc."Mobile No." <> '' then begin
                                            CreateNotif.CreateSmsNotif(NotifSource::"ATM Collection",
                                           CredAcc."Mobile No.", 'Dear ' + CredAcc.Name + '. your Deposits Account is Dormant. Kindly contact us via info@unsacco.org or +2540207622700 for reactivation.' + ' ' + CompInfo."Phone No.", CredAcc."No.",
                                           CredAcc."Member No.", false);

                                            VarVariant := CredAcc;
                                            CreateNotif.SendEmailNotification(VarVariant, 0, CredAcc."No.");
                                        end
                                    end;
                                end;
                            end;
                        CredAcc.Status::Dormant:
                            begin
                                if CredAcc."Last Transaction Date" <> 0D then begin
                                    if CalcDate(ProdFact."Dormancy Period", CredAcc."Last Transaction Date") > Today then begin
                                        CredAcc.Status := CredAcc.Status::Active;
                                        CredAcc.Blocked := CredAcc.Blocked::" ";
                                        CredAcc.Modify(true);

                                        if CustMember.Get(CredAcc."Member No.") then begin
                                            CustMember.Status := CustMember.Status::Active;
                                            CustMember.Modify(true);
                                        end;
                                    end;
                                end;
                            end;
                    end;
                end
            end;
        end;
    end;

    procedure TimeNotAllowed(LoginTime: Time): Boolean
    var
        UserSetup: Record "User Setup";
        User: Record User;
        OverHours: Boolean;
        AllowLoginFrom: Time;
        AllowLoginTo: Time;
    begin
        IF (Format(AllowLoginFrom) = '') and (Format(AllowLoginTo) = '') then begin
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    UserSetup.TestField("Allow Posting From [Time]");
                    UserSetup.TestField("Allow Posting To [Time]");

                    AllowLoginFrom := UserSetup."Allow Posting From [Time]";
                    AllowLoginTo := UserSetup."Allow Posting To [Time]";
                end;
        end;
        exit((LoginTime < AllowLoginFrom) or (LoginTime > AllowLoginTo));
    end;

    procedure CalculateLoanInt(LoanNo: Code[100]): Decimal
    var
        AccruedInt: Decimal;
        RecRef: Record Loans;
        RSchedule: Record "Repayment Schedule";
    begin
        AccruedInt := 0;
        if RecRef.Get(LoanNo) then begin
            case RecRef."Charge Interest on Posting" of
                RecRef."Charge Interest on Posting"::" ":
                    begin
                        exit(0)
                    end;
                RecRef."Charge Interest on Posting"::"Pro-rate":
                    begin
                        case RecRef."Interest Calculation Method" of
                            RecRef."Interest Calculation Method"::"Straight Line":
                                AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>') else
                                                                                                                               AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                        end;
                    end;
                RecRef."Charge Interest on Posting"::"Full Interest":
                    begin
                        RSchedule.SetRange("No.", RecRef."No.");
                        if RSchedule.FindSet() then begin
                            RSchedule.CalcSums("Monthly Interest");
                            AccruedInt := RSchedule."Monthly Interest";
                        end else begin
                            Error(ErrorOnNoRepaymentSchd);
                        end;
                    end;
                RecRef."Charge Interest on Posting"::"Interest Due":
                    begin
                        case RecRef."Interest Calculation Method" of
                            RecRef."Interest Calculation Method"::"Straight Line":
                                AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>') else
                                                                                                                               AccruedInt := Round(RecRef."Approved Amount" * (RecRef."Interest Rate" / 1200), 0.01, '>');
                        end;
                    end;
            end;
            exit(AccruedInt)
        end;
    end;

    local procedure findChargeTxt(RecRefNo: Code[100]): Boolean
    begin
        LoanChargePosted.Reset;
        LoanChargePosted.SetRange("Loan No.", RecRefNo);
        LoanChargePosted.SetRange("Charge Type", LoanChargePosted."Charge Type"::General);
        if LoanChargePosted.Find('-') then begin
            exit(true)
        end;
        exit(false)

    end;

    procedure CreateLoanCharge(RecRef: Record Loans)
    var
        LnAppCharges: Record "Loan Product Charges";
        PostedCharges: Record "Loan Charge Posted";
        TopupPosted: Record "Loans Top up Posted";
    begin
        if not findChargeTxt(RecRef."No.") then begin
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
    end;

    procedure fnInsertLoanCharge(RecNo: Code[100]; ProductType: Code[20]; ApplicType: Enum LoanApplictionType)
    var
        LnAppCharges: Record "Loan Product Charges";
        ApplicationCharge: Record "Loan Application Charge";
    begin

        case ApplicType of
            ApplicType::Normal:
                begin
                    ApplicationCharge.Reset();
                    ApplicationCharge.SetRange("Application No.", RecNo);
                    ApplicationCharge.SetFilter("Charge Type", '<>%1 & <>%2 &<>%3', ApplicationCharge."Charge Type"::"Top up",
                    ApplicationCharge."Charge Type"::Boosting, ApplicationCharge."Charge Type"::Restructure);
                    ApplicationCharge.DeleteAll();

                    LnAppCharges.Reset();
                    LnAppCharges.SetRange("Product Code", ProductType);
                    LnAppCharges.SetFilter("Charge Type", '<>%1 & <>%2 &<>%3', LnAppCharges."Charge Type"::"Top up",
                    LnAppCharges."Charge Type"::Boosting, LnAppCharges."Charge Type"::Restructure);
                    if LnAppCharges.FindSet() then begin
                        repeat

                            ApplicationCharge.Init();
                            ApplicationCharge."Application No." := RecNo;
                            ApplicationCharge."Product Code" := LnAppCharges."Product Code";
                            ApplicationCharge."Charge Code" := LnAppCharges."Charge Code";
                            ApplicationCharge."Charge Amount" := LnAppCharges."Charge Amount";
                            ApplicationCharge.Percentage := LnAppCharges.Percentage;
                            ApplicationCharge."Use Percentage" := LnAppCharges."Use Percentage";
                            ApplicationCharge."Charge Description" := LnAppCharges."Charge Description";
                            ApplicationCharge."Charge Method" := LnAppCharges."Charge Method";
                            ApplicationCharge."Charge Type" := LnAppCharges."Charge Type";
                            ApplicationCharge."Charging Option" := LnAppCharges."Charging Option";
                            ApplicationCharge."Effect Excise Duty" := LnAppCharges."Effect Excise Duty";
                            ApplicationCharge."Staggered Charge Code" := LnAppCharges."Staggered Charge Code";
                            ApplicationCharge."Account Type" := LnAppCharges."Account Type";
                            ApplicationCharge."Account No." := LnAppCharges."Charges Account";
                            ApplicationCharge."Post Charge" := true;
                            ApplicationCharge.Maximum := LnAppCharges.Maximum;
                            ApplicationCharge.Minimum := LnAppCharges.Maximum;
                            ApplicationCharge.Insert(true)
                        until LnAppCharges.Next() = 0;
                    end;

                end;
            ApplicType::"Loan Restructure":
                begin
                    ApplicationCharge.Reset();
                    ApplicationCharge.SetRange("Application No.", RecNo);
                    ApplicationCharge.DeleteAll();

                    LnAppCharges.Reset();
                    LnAppCharges.SetRange("Product Code", ProductType);
                    LnAppCharges.SetFilter("Charge Type", '<>%1', LnAppCharges."Charge Type"::Boosting);
                    if LnAppCharges.FindSet() then begin
                        repeat

                            ApplicationCharge.Init();
                            ApplicationCharge."Application No." := RecNo;
                            ApplicationCharge."Product Code" := LnAppCharges."Product Code";
                            ApplicationCharge."Charge Code" := LnAppCharges."Charge Code";
                            ApplicationCharge."Charge Amount" := LnAppCharges."Charge Amount";
                            ApplicationCharge.Percentage := LnAppCharges.Percentage;
                            ApplicationCharge."Use Percentage" := LnAppCharges."Use Percentage";
                            ApplicationCharge."Charge Description" := LnAppCharges."Charge Description";
                            ApplicationCharge."Charge Method" := LnAppCharges."Charge Method";
                            ApplicationCharge."Charge Type" := LnAppCharges."Charge Type";
                            ApplicationCharge."Charging Option" := LnAppCharges."Charging Option";
                            ApplicationCharge."Effect Excise Duty" := LnAppCharges."Effect Excise Duty";
                            ApplicationCharge."Staggered Charge Code" := LnAppCharges."Staggered Charge Code";
                            ApplicationCharge."Account Type" := LnAppCharges."Account Type";
                            ApplicationCharge."Account No." := LnAppCharges."Charges Account";
                            ApplicationCharge."Post Charge" := true;
                            ApplicationCharge.Maximum := LnAppCharges.Maximum;
                            ApplicationCharge.Minimum := LnAppCharges.Maximum;
                            ApplicationCharge.Insert(true)

                        until LnAppCharges.Next() = 0;
                    end;
                end;
        end;

    end;

    procedure fnCreateTopUpCharge(RecNo: Code[100]; ProductType: Code[20]; ValuePost: Integer; ChargeType: Enum ChargeType)
    var
        LnAppCharges: Record "Loan Product Charges";
        ApplicationCharge: Record "Loan Application Charge";
    begin

        ApplicationCharge.Reset();
        ApplicationCharge.SetRange("Application No.", RecNo);
        ApplicationCharge.SetRange("Charge Type", ChargeType);
        ApplicationCharge.DeleteAll();

        LnAppCharges.Reset();
        LnAppCharges.SetRange("Product Code", ProductType);
        LnAppCharges.SetRange("Charge Type", ChargeType);
        if LnAppCharges.FindSet() then begin
            repeat

                ApplicationCharge.Init();
                ApplicationCharge."Application No." := RecNo;
                ApplicationCharge."Product Code" := LnAppCharges."Product Code";
                ApplicationCharge."Charge Code" := LnAppCharges."Charge Code";
                ApplicationCharge."Charge Amount" := LnAppCharges."Charge Amount";
                ApplicationCharge.Percentage := LnAppCharges.Percentage;
                ApplicationCharge."Use Percentage" := LnAppCharges."Use Percentage";
                ApplicationCharge."Charge Description" := LnAppCharges."Charge Description";
                ApplicationCharge."Charge Method" := LnAppCharges."Charge Method";
                ApplicationCharge."Charge Type" := LnAppCharges."Charge Type";
                ApplicationCharge."Charging Option" := LnAppCharges."Charging Option";
                ApplicationCharge."Effect Excise Duty" := LnAppCharges."Effect Excise Duty";
                ApplicationCharge."Staggered Charge Code" := LnAppCharges."Staggered Charge Code";
                ApplicationCharge."Account Type" := LnAppCharges."Account Type";
                ApplicationCharge."Account No." := LnAppCharges."Charges Account";
                ApplicationCharge."Post Charge" := true;
                ApplicationCharge.Maximum := LnAppCharges.Maximum;
                ApplicationCharge.Minimum := LnAppCharges.Maximum;
                ApplicationCharge.Insert(true)
            until LnAppCharges.Next() = 0;
        end;
    end;

    procedure CreateScheduledLoanPaymentJnline(LoanNo: Code[100]; PostInt: Enum "LoanTransactionType"; ValuePost: Integer): Decimal
    var
        IntDays: Integer;
        LoanCat: Record "Loans Categorization";
        EndDate: Date;
        PLoans: Record "Loans Categorization";
        StartDate: Date;
        DateFilter: Text[100];
        Lshedule: Record "Repayment Schedule";
        Rshedule: Record "Repayment Schedule";
        ScheduledPayment: Decimal;

    begin

        Rshedule.Reset();
        Rshedule.SetRange("No.", LoanNo);
        if Rshedule.FindSet() then begin
            if ValuePost = 0 then begin
                Rshedule.CalcSums("Monthly Insurance", "Monthly Interest", "Monthly Repayment");
            end;

            case PostInt of
                Enum::"LoanTransactionType"::"Interest Due":
                    begin
                        ScheduledPayment := Rshedule."Monthly Interest";
                        exit(ScheduledPayment)
                    end;
                Enum::"LoanTransactionType"::"Insurance Due":
                    begin
                        ScheduledPayment := Rshedule."Monthly Insurance";
                        exit(ScheduledPayment)

                    end;
                Enum::"LoanTransactionType"::"Ledger Fee Due":
                    begin
                        ScheduledPayment := Rshedule."Monthly Interest";
                        exit(ScheduledPayment)

                    end;
                Enum::"LoanTransactionType"::"Penalty Due":
                    begin
                        ScheduledPayment := Rshedule."Monthly Interest";
                        exit(ScheduledPayment)

                    end;
                Enum::"LoanTransactionType"::Repayment:
                    begin
                        ScheduledPayment := Rshedule."Monthly Repayment";
                        exit(ScheduledPayment)
                    end;
            end;
        end;

    end;

    procedure fnCustgetMinShare(AccountNo: Code[100]; AccountCategory: Enum ProductAccountCategory): Decimal
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        ProdFact: Record "Product Factory";
        DiffAmount: Decimal;
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active.Status- %1 | Balance %2';
    begin
        DiffAmount := 0;

        CredAc.Reset;
        CredAc.SetRange("No.", AccountNo);
        CredAc.SetRange("Account Category", AccountCategory);
        if CredAc.FindFirst() then begin
            CredAc.CalcFields("Balance (LCY)");
            if ProdFact.Get(CredAc."Product Type") then begin
                ProdFact.TestField("Minimum Balance");
                if CredAc."Balance (LCY)" > 0 then begin
                    DiffAmount := (ProdFact."Minimum Balance" - CredAc."Balance (LCY)");
                    exit(DiffAmount)
                end else begin
                    exit(0)
                end;
            end;
        end
    end;

    procedure CustHasNotAttainedMinShares(CustNo: Code[100]): Boolean
    var
        RegMngt: Codeunit "Register Management";
        CredtMngt: Record "Account Credit";
        ProdFact: Record "Product Factory";
    begin

        CredtMngt.Reset();
        CredtMngt.SetRange("No.", CustNo);
        if CredtMngt.FindFirst() then begin
            if ProdFact.Get(CredtMngt."Product Type") then
                if RegMngt.GetOperationAccBalanceTxt(CredtMngt."Account Category", CredtMngt."Member No.", 2) < ProdFact."Minimum Balance" then begin
                    exit(true)
                end;
        end;
    end;

    procedure CheckLienAccLoan(AccNo: code[100]): Boolean
    var
        AccBanking: Record "Account Banking";
        PFact: Record "Product Factory";
        PLoan: Record Loans;
    begin
        if Accbanking.Get(AccNo) then begin
            PFact.Reset();
            PFact.SetRange("Product Type", Accbanking."Product Type");
            if PFact.FindFirst() then begin
                Loans.Reset();
                Loans.SetRange("Account No.", AccBanking."Member No.");
                Loans.SetRange("Product Type", PFact."Product ID");
                Loans.SetFilter("Outstanding Balance", '>0');
                if Loans.FindFirst() then begin
                    exit(true)
                end;
            end;
        end;
        exit(false)
    end;

    procedure CheckIfCustisNotSubstuted(MemberNo: Code[100]): Boolean
    var
        AccCredit: Record "Account Credit";
        LoanGuarant: Record "Guarantor & Security Posted";
    begin

        AccCredit.Reset();
        AccCredit.SetRange("Member No.", MemberNo);
        AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
        if AccCredit.FindFirst() then begin

            LoanGuarant.Reset();
            LoanGuarant.SetRange(Substituted, false);
            LoanGuarant.SetRange("Account No.", AccCredit."No.");
            LoanGuarant.SetFilter("Outstanding Balance", '>0');
            if LoanGuarant.Find('-') then begin
                exit(true)
            end;
            exit(false)
        end;
    end;

    /* procedure fnIntPeriodClosure(StartDate: Date; dtNewPeriod: Date; PayrollCode: Code[50])
    var
        PrNewIntPeriods: Record "Loan Interest Periods";
        PrIntPeriods: Record "Loan Interest Periods";
        intMonth: Integer;
        intYear: Integer;
        intNewMonth: Integer;
        intNewYear: Integer;
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        CreateTrans: Boolean;
    begin

        PrIntPeriods.SetRange("Date Opened", StartDate);
        PrIntPeriods.SetRange(Closed, false);
        if PrIntPeriods.Find('-') then begin
            PrIntPeriods.Closed := true;
            PrIntPeriods."Date Closed" := Today;
            PrIntPeriods."Posted By" := UserId;
            PrIntPeriods."Payroll Code" := PayrollCode;
            PrIntPeriods.Modify(true);
        end;
    end; */

    procedure fnIntPeriodClosure(StartDate: Date; dtNewPeriod: Date; PayrollCode: Code[50]; ApplicType: Enum CreditBillingType)
    var
        PrNewIntPeriods: Record "Loan Interest Periods";
        PrIntPeriods: Record "Loan Interest Periods";
        intMonth: Integer;
        intYear: Integer;
        intNewMonth: Integer;
        intNewYear: Integer;
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        CreateTrans: Boolean;
    begin

        case ApplicType of
            ApplicType::"Ledger fee",
                   ApplicType::Insurance,
                       ApplicType::"Interest+LedgerFee",
                       ApplicType::"Interest+Insurance",
                       ApplicType::"Interest+Penalty",
                       ApplicType::"Interest or Ledger Fee",
               ApplicType::"Loan Interest":
                begin
                    PrIntPeriods.Reset();
                    PrIntPeriods.SetRange("Date Closed", StartDate);
                    PrIntPeriods.SetRange("Date Opened", dtNewPeriod);
                    PrIntPeriods.SetRange(Closed, false);
                    if PrIntPeriods.Find('-') then begin
                        PrIntPeriods.Closed := true;
                        PrIntPeriods."Payroll Code" := PayrollCode;
                        PrIntPeriods.Modify(true);
                    end;

                    PrNewIntPeriods.Init();
                    PrNewIntPeriods."Date Closed" := CalcDate('1M', dtNewPeriod);
                    PrNewIntPeriods."Period Month" := Date2DMY(PrNewIntPeriods."Date Closed", 2);
                    PrNewIntPeriods."Period Year" := Date2DMY(PrNewIntPeriods."Date Closed", 3);
                    PrNewIntPeriods."Period Name" := Format(PrNewIntPeriods."Date Closed", 0, '<Month Text>') + ' - ' + Format(Date2DMY(PrNewIntPeriods."Date Closed", 3));
                    PrNewIntPeriods."Date Opened" := dtNewPeriod;
                    PrNewIntPeriods.Closed := false;
                    PrNewIntPeriods.Insert(true);
                end;
        end;
    end;

    procedure fnCreateNewPeriod()
    var
        PrIntPeriods: Record "Loan Interest Periods";
        PrNewIntPeriods: Record "Loan Interest Periods";
        FirstDate: Date;
    begin
        FirstDate := CalcDate('-CM-1D', Today);

        PrIntPeriods.Reset();
        PrIntPeriods.SetFilter(Closed, '%1 & %2', false, true);
        if not PrIntPeriods.FindSet() then begin

            PrNewIntPeriods.Init();
            PrNewIntPeriods."Created By" := UserId;
            PrNewIntPeriods."Posted By" := UserId;
            PrNewIntPeriods."Date Opened" := FirstDate;
            PrNewIntPeriods."Period Month" := Date2DMY(FirstDate, 2);
            PrNewIntPeriods."Period Year" := Date2DMY(FirstDate, 2);
            PrNewIntPeriods."Period Name" := Format(FirstDate, 0, '<Month Text>');
            PrNewIntPeriods."Date Closed" := CalcDate('-CM', FirstDate);
            PrNewIntPeriods.Insert(true)
        end else
            exit

    end;

}




