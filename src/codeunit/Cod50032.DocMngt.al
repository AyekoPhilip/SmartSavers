codeunit 50032 "Doc. Mngt"
{

    trigger OnRun()
    begin
    end;


    procedure DocPrintRepayschedule(var Variant: Variant; PostInt: Integer)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        LoanApplication: Record "Loan Application";
        LoansR: Record "Loan Application";
        AppraisalParameter: Record "Loan Appraisal Parameter";
        Prdfact: Record "Product Factory";
        LoanFacility: Record Loans;
        LoanP: Record Loans;
        SimHeader: Record "Dividend Simulation Header";
        LoanCalc: Record "Loan Calculator";
        LnCalc: Record "Loan Calculator";
        GenJournal: Record "Gen. Journal Line";
        Temp: Record "Banking User Template";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    case PostInt of
                        1:
                            begin
                                LoansR.Reset;
                                LoansR.SetRange("No.", LoanApplication."No.");
                                if LoansR.Find('-') then
                                    Report.Run(Report::"Repayment Schedule Application", true, true, LoansR);
                            end;
                        2:
                            begin
                                AppraisalParameter.Reset;
                                AppraisalParameter.SetRange("No.", LoanApplication."No.");
                                if AppraisalParameter.Find('-') then begin
                                    if Prdfact.Get(AppraisalParameter."Product Type") then begin
                                        case Prdfact."Product Dimension" of
                                            Prdfact."Product Dimension"::Account:
                                                begin
                                                    Report.Run(Report::"Loan Appraisal Parameter-IESA", true, true, AppraisalParameter);

                                                end;
                                            Prdfact."Product Dimension"::Credit,
                                            Prdfact."Product Dimension"::"Micro Credit":
                                                begin
                                                    Report.Run(Report::"Loan Appraisal Parameters", true, true, AppraisalParameter);

                                                end;
                                        end;
                                    end;
                                end;

                            end
                    end;
                    Variant := LoanApplication
                end;
            DATABASE::"Loan Calculator":
                begin

                    RecRef.SetTable(LnCalc);
                    case PostInt of
                        1:
                            begin
                                LoanCalc.Reset;
                                LoanCalc.SetRange("No.", LnCalc."No.");
                                if LoanCalc.Find('-') then
                                    Report.Run(Report::"Repayment Schedule -Ln. Calc", true, true, LoanCalc);
                            end;
                        2:
                            begin
                                AppraisalParameter.Reset;
                                AppraisalParameter.SetRange("No.", LnCalc."No.");
                                if AppraisalParameter.Find('-') then
                                    Report.Run(Report::"Loan Appraisal Parameters", true, true, AppraisalParameter);
                            end
                    end;
                    Variant := LnCalc
                end;

            Database::Loans:
                begin
                    RecRef.SetTable(LoanFacility);
                    LoanP.Reset();
                    LoanP.SetRange("No.", LoanFacility."No.");
                    if LoanP.FindFirst() then begin
                        Report.Run(Report::"Repayment Schedule-Loans", true, true, LoanP);
                    end;

                    Variant := LoanFacility;
                end;
            Database::"Dividend Simulation Header":
                begin
                    RecRef.SetTable(SimHeader);

                    Temp.Get(UserId);
                    Temp.TestField("Periodic Journal Template");
                    Temp.TestField("Periodic Journal Batch");

                    GenJournal.Reset();
                    GenJournal.SetRange("Document No.", SimHeader."No.");
                    GenJournal.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                    GenJournal.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                    if GenJournal.FindFirst() then begin
                        Page.Run(Page::"Journal Test Batch", GenJournal);
                    end;

                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;

    procedure DocPrintLoanRepayschedule(PostInt: Integer; DocumentNo: Code[100])
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        LoanApplication: Record "Loan Application";
        LoansR: Record "Loan Application";
        AppraisalParameter: Record "Loan Appraisal Parameter";
        LoanFacility: Record Loans;
        LoanP: Record Loans;
    begin
        case PostInt of
            0:
                begin
                    LoanP.Reset();
                    LoanP.SetRange("No.", DocumentNo);
                    if LoanP.FindFirst() then begin
                        Report.Run(Report::"Repayment Schedule-Loans", true, true, LoanP);
                    end;
                end;
            1:
                begin
                    LoansR.Reset;
                    LoansR.SetRange("No.", DocumentNo);
                    if LoansR.Find('-') then
                        Report.Run(Report::"Repayment Schedule Application", true, true, LoansR);
                end;
            2:
                begin
                    AppraisalParameter.Reset;
                    AppraisalParameter.SetRange("No.", DocumentNo);
                    if AppraisalParameter.Find('-') then
                        Report.Run(Report::"Loan Appraisal Parameters", true, true, AppraisalParameter);
                end
        end;

    end;

    procedure DocPrintstatement(var Variant: Variant; PostInt: Integer)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        CustMember: Record Member;
        CustMembr: Record Member;
        TellerTransaction: Record "Teller Transaction";
        TellerTrans: Record "Teller Transaction";
        PLoan: Record Loans;
        Temp: Record "Banking User Template";
        LoanTemp: Record Loans;
        GenJournal: Record "Gen. Journal Line";
        RecoverHeader: Record "Recovery Header";
        RecHeaderTemp: Record "Recovery Header";
        RecHeader: Record "Checkoff Header";
        RecTemp: Record "Checkoff Header";
        RecAccountTransfer: Record "Account Transfer Header";
        AccountTransfer: Record "Account Transfer Header";
        EftHeader: Record "EFT Transfer Header";
        PartLoan: Record "Partial Disbursement Schedule";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::Member:
                begin
                    RecRef.SetTable(CustMember);
                    case PostInt of
                        0:
                            begin
                                CustMembr.Reset;
                                CustMembr.SetRange(CustMembr."No.", CustMember."No.");
                                if CustMembr.FindFirst then
                                    REPORT.Run(REPORT::"Statement of Account", true, false, CustMembr);
                            end;
                        1:
                            begin
                                CustMembr.Reset;
                                CustMembr.SetRange(CustMembr."No.", CustMember."No.");
                                if CustMembr.FindFirst then
                                    REPORT.Run(REPORT::"Statement of Account-Loan", true, false, CustMembr);
                            end;
                        2:
                            begin
                                CustMembr.Reset;
                                CustMembr.SetRange(CustMembr."No.", CustMember."No.");
                                if CustMembr.FindFirst then
                                    REPORT.Run(REPORT::"Statement-Loans", true, false, CustMembr);
                            end;
                        3:
                            begin
                                if CustMembr.Get(CustMember."No.") then
                                    PAGE.Run(PAGE::"Member Statistics", CustMembr, CustMembr."No.")
                            end
                    end;
                    Variant := CustMember
                end;

            DATABASE::"Teller Transaction":
                begin
                    RecRef.SetTable(TellerTransaction);

                    TellerTrans.Reset;
                    TellerTrans.SetRange("No.", TellerTransaction."No.");
                    if TellerTrans.Find('-') then begin
                        case TellerTrans.Type of
                            TellerTrans.Type::"Cash Withdrawal":
                                begin
                                    Report.Run(Report::"Teller Withdrawal Slip", false, true, TellerTrans);
                                end;
                            TellerTrans.Type::"Cash Deposit":
                                begin
                                    Report.Run(Report::"Teller Deposit Slip", false, true, TellerTrans);
                                end;
                            TellerTrans.Type::"Cheque Deposit":
                                begin
                                    Report.Run(Report::"Teller CHeq. Deposit Slip", false, true, TellerTrans);
                                end;
                            TellerTrans.Type::"Account Zerolize",
                        TellerTrans.Type::"Bankers Cheque":
                                begin
                                    Report.Run(Report::"Teller CHeq. Deposit Slip", false, true, TellerTrans);
                                end;
                            TellerTrans.Type::"Credit Receipt":
                                begin
                                    Report.Run(Report::"CashierCredit Deposit Slip", false, true, TellerTrans);
                                end;
                            TellerTrans.Type::"Credit Cheque":
                                begin
                                    Report.Run(Report::"Teller CHeq. Deposit Slip", false, true, TellerTrans);
                                end;
                        end;
                    end;
                    Variant := TellerTransaction
                end;

            Database::"Partial Disbursement Schedule":
                begin
                    RecRef.SetTable(PartLoan);

                    Temp.Get(UserId);
                    Temp.TestField("Loans Template");
                    Temp.TestField("Loans Batch");

                    GenJournal.Reset();
                    GenJournal.SetRange("Document No.", PartLoan."Entry No");
                    GenJournal.SetRange("Journal Template Name", Temp."Loans Template");
                    GenJournal.SetRange("Journal Batch Name", Temp."Loans Batch");
                    if GenJournal.FindFirst() then begin
                        Page.Run(Page::"Journal Test Batch", GenJournal);
                    end;
                    Variant := PartLoan;
                end;
            Database::Loans:
                begin
                    RecRef.SetTable(PLoan);
                    case PostInt of
                        0:
                            begin
                                Temp.Get(UserId);
                                Temp.TestField("Loans Template");
                                Temp.TestField("Loans Batch");

                                LoanTemp.Reset();
                                LoanTemp.SetRange("No.", PLoan."No.");
                                if LoanTemp.Find('-') then begin

                                    GenJournal.Reset();
                                    GenJournal.SetRange("Document No.", LoanTemp."No.");
                                    GenJournal.SetRange("Journal Template Name", Temp."Loans Template");
                                    GenJournal.SetRange("Journal Batch Name", Temp."Loans Batch");
                                    if GenJournal.FindFirst() then begin
                                        Page.Run(Page::"Journal Test Batch", GenJournal);
                                    end;
                                end;
                            end;
                        1:
                            begin
                                Temp.Get(UserId);
                                LoanTemp.Reset();
                                LoanTemp.SetRange("No.", PLoan."No.");
                                if LoanTemp.Find('-') then begin
                                    GenJournal.Reset();
                                    GenJournal.SetRange("Document No.", LoanTemp."No.");
                                    GenJournal.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                                    GenJournal.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                                    if GenJournal.FindFirst() then begin
                                        Page.Run(Page::"Journal Test Batch", GenJournal, GenJournal."Journal Template Name");
                                    end;
                                end;
                            end;

                    end;

                    Variant := PLoan
                end;
            Database::"Recovery Header":
                begin
                    RecRef.SetTable(RecoverHeader);
                    Temp.Get(UserId);
                    Temp.TestField("Periodic Journal Template");
                    Temp.TestField("Periodic Journal Batch");

                    case PostInt of
                        0:
                            begin
                                RecHeaderTemp.Reset();
                                RecHeaderTemp.SetRange("No.", RecoverHeader."No.");
                                if RecHeaderTemp.Find('-') then begin
                                    GenJournal.Reset();
                                    GenJournal.SetRange("Document No.", RecHeaderTemp."No.");
                                    GenJournal.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                                    GenJournal.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                                    if GenJournal.FindSet() then begin
                                        Page.Run(Page::"Journal Test Batch", GenJournal, GenJournal."Journal Template Name");
                                    end;
                                end;
                            end;
                        1:
                            begin

                                RecHeaderTemp.Reset();
                                RecHeaderTemp.SetRange("No.", RecoverHeader."No.");
                                if RecHeaderTemp.Find('-') then begin
                                    GenJournal.Reset();
                                    GenJournal.SetRange("Document No.", RecHeaderTemp."No.");
                                    GenJournal.SetRange("Journal Batch Name", Temp."Periodic Journal Batch");
                                    GenJournal.SetRange("Journal Template Name", Temp."Periodic Journal Template");
                                    if GenJournal.FindSet() then begin
                                        Report.Run(Report::"Journal Batch Test", true, false, GenJournal);
                                    end;
                                end;
                            end;
                    end;

                    Variant := RecoverHeader
                end;
            Database::"EFT Transfer Header":
                begin
                    RecRef.SetTable(EftHeader);
                    Temp.Get(UserId);
                    Temp.TestField(Temp."Cashier Journal Template");
                    Temp.TestField(Temp."Cashier Journal Batch");

                    case PostInt of
                        0:
                            begin
                                EftHeader.Reset();
                                EftHeader.SetRange("No.", EftHeader."No.");
                                if EftHeader.FindFirst() then begin
                                    GenJournal.Reset();
                                    GenJournal.SetRange("Journal Template Name", Temp."Cashier Journal Template");
                                    GenJournal.SetRange("Journal Batch Name", Temp."Cashier Journal Batch");
                                    GenJournal.SetRange("Document No.", EftHeader."No.");
                                    if GenJournal.FindFirst() then begin
                                        Page.Run(Page::"Journal Test Batch", GenJournal, GenJournal."Journal Template Name");
                                    end;
                                end;
                            end;
                    end;
                end;
            Database::"Account Transfer Header":
                begin
                    RecRef.SetTable(AccountTransfer);
                    Temp.GET(UserId);
                    Temp.TestField("Transfer Journal Template");
                    Temp.TestField("Transfer Journal Batch");
                    case PostInt of
                        0:
                            begin
                                RecAccountTransfer.Reset();
                                RecAccountTransfer.SetRange("No.", AccountTransfer."No.");
                                if RecAccountTransfer.FindFirst() then begin
                                    GenJournal.Reset();
                                    GenJournal.SetRange("Journal Template Name", Temp."Transfer Journal Template");
                                    GenJournal.SetRange("Journal Batch Name", Temp."Transfer Journal Batch");
                                    if GenJournal.FindFirst() then begin
                                        Page.Run(Page::"Journal Test Batch", GenJournal, GenJournal."Journal Template Name");
                                    end;
                                end;

                            end;
                    end;

                end;

            Database::"Checkoff Header":
                begin

                    RecRef.SetTable(RecHeader);
                    Temp.Get(UserId);
                    Temp.TestField("Check Off Template");
                    Temp.TestField("Check Off Batch");

                    RecTemp.Reset();
                    RecTemp.SetRange("No.", RecHeader."No.");
                    if RecTemp.Find('-') then begin
                        GenJournal.Reset();
                        GenJournal.SetRange("Journal Template Name", Temp."Check Off Template");
                        GenJournal.SetRange("Journal Batch Name", Temp."Check Off Batch");
                        GenJournal.SetRange("Document No.", RecTemp."No.");
                        if GenJournal.FindFirst() then begin
                            Page.Run(Page::"Journal Test Batch", GenJournal, GenJournal."Journal Template Name");
                        end;
                    end;
                    Variant := RecoverHeader
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;

    procedure GetConditionalCardPageID(var RecRef: Integer; DocumentNo: Code[20])
    var
        LoanApplication: Record "Loan Application";
        MemberApplication: Record "Member Application";
        AccountApplication: Record "Account Application";
        MemberChange: Record "Member Changes";
        Facility: Record Loans;
        CollateralRegister: Record "Collateral Register";
        DisbursementHeader: Record "Loan Disbursement Header";
        InterestHeader: Record "Interest Header";
        ReceiptsHeader: Record "Checkoff Header";
        RecoveryHeader: Record "Recovery Header";
        SecurityCollection: Record "Security Collection";
        TraesuryTrans: Record "Treasury Cashier Transaction";
        TellerTrans: Record "Teller Transaction";
        AccTransfer: Record "Account Transfer Header";
        PFact: Record "Product Factory";
        BnkCheque: Record "Bankers Cheque Application";
        StandingOrder: Record "Standing Order Header";
        EFTHeader: Record "EFT Transfer Header";
        MRegmt: Record "Dsc Mobile Application";
        RecordSubstitution: Record "Guarantors Substitution";
        Acclosure: Record "Membership closure";
        MNotice: Record "Member withdrawal Notice";
        RecordChange: Record "Mc Acc. Changes";
        Temp: Record "User Setup";
        PartialDisb: Record "Partial Disbursement Schedule";
        Accbanking: Record "Account Banking";
        PayHeader: Record "Payments Header";
        InterBank: Record "Interbank Transfer";
        ImprestHeader: Record "Imprest Header";
        ObjtEmp: Record "HR Employees";
        PrPayrollRequest: Record "Payroll Requests";
    begin

        //get the App/Doc. Page
        case RecRef of
            Database::"Payments Header":
                begin
                    if not PayHeader.Get(DocumentNo) then exit;
                    if PayHeader."Payment Type" = PayHeader."Payment Type"::Normal then
                        Page.Run(Page::"Payment Voucher", PayHeader) else
                        Page.Run(Page::"Payment Voucher", PayHeader);
                end;
            Database::"Interbank Transfer":
                begin
                    if not InterBank.Get(DocumentNo) then exit;
                    Page.Run(Page::"Interbank Transfer Card", InterBank);
                end;
            Database::"Imprest Header":
                begin
                    if not ImprestHeader.Get(DocumentNo) then
                        if ImprestHeader."Payment Type" = ImprestHeader."Payment Type"::Imprest then
                            Page.Run(Page::"Imprest Header") else
                            Page.Run(Page::"Imprest Surrender Header", ImprestHeader);

                end;
                Database::"Payroll Requests":
                begin
                    if not PrPayrollRequest.Get(DocumentNo) then exit;
                    Page.Run(Page::"Payroll Request Card", PrPayrollRequest);
                end;
            Database::"Account Banking":
                begin
                    if not Accbanking.Get(DocumentNo) then exit;
                    Page.Run(Page::"Savings Account Card", Accbanking);
                end;
            DATABASE::"Loan Application":
                begin
                    if not LoanApplication.Get(DocumentNo) then exit;
                    case LoanApplication."Application Type" of
                        LoanApplication."Application Type"::Normal:
                            PAGE.Run(PAGE::"Loan Application Card", LoanApplication);
                        LoanApplication."Application Type"::"Loan Restructure":
                            PAGE.Run(PAGE::"Loan Restructure", LoanApplication);
                    end;
                end;
            Database::"Member withdrawal Notice":
                begin
                    if not MNotice.Get(DocumentNo) then exit;
                    Page.Run(Page::"Member withdrawal Notice", MNotice);
                end;

            Database::"Partial Disbursement Schedule":
                begin

                    PartialDisb.Reset();
                    PartialDisb.SetRange("Entry No", DocumentNo);
                    if PartialDisb.FindFirst() then begin
                        Page.Run(Page::"Partial Disbursement Schedule", PartialDisb);
                    end;
                end;

            Database::"User Setup":
                begin
                    if not Temp.Get(DocumentNo) then exit;
                    Page.Run(Page::"User Setup Card", Temp);
                end;

            Database::"Membership closure":
                begin
                    if not Acclosure.Get(DocumentNo) then exit;
                    Page.Run(Page::"Membership Closure", Acclosure);
                end;
            Database::"Guarantors Substitution":
                begin
                    if not RecordSubstitution.Get(DocumentNo) then exit;
                    case RecordSubstitution."Substitution Type" of
                        RecordSubstitution."Substitution Type"::"Guarantor Substitution":
                            Page.Run(Page::"Guarantor Substitution", RecordSubstitution);
                        RecordSubstitution."Substitution Type"::"Kin Substitution":
                            Page.Run(Page::"Guarantor Substitution", RecordSubstitution);
                        RecordSubstitution."Substitution Type"::"Signatory Substitution":
                            Page.Run(Page::"Guarantor Substitution", RecordSubstitution);
                    end;
                end;
            DATABASE::"Member Application":
                begin
                    if not MemberApplication.Get(DocumentNo) then exit;
                    case MemberApplication."Customer Type" of
                        MemberApplication."Customer Type"::Individual:
                            begin
                                Case MemberApplication."Application Type" of
                                    MemberApplication."Application Type"::"New Member":
                                        PAGE.Run(PAGE::"Individual Application", MemberApplication);
                                    MemberApplication."Application Type"::Readmission:
                                        PAGE.Run(PAGE::"Individual Application", MemberApplication);
                                end;
                            end else begin
                            PAGE.Run(PAGE::"Application Group", MemberApplication);
                        end;
                    end
                end;
            DATABASE::"Account Application":
                begin
                    if not AccountApplication.Get(DocumentNo) then exit;

                    Case AccountApplication."Application Type" of
                        AccountApplication."Application Type"::"Account Application":
                            PAGE.Run(PAGE::"Account Application Card", AccountApplication);
                        AccountApplication."Application Type"::"Account Changes":
                            PAGE.Run(PAGE::"Account Change-Card", AccountApplication);
                    end
                end;
            Database::"Product Factory":
                begin
                    If not PFact.Get(DocumentNo) then exit;
                    case PFact."Product Class" of
                        pfact."Product Class"::Account:
                            Page.Run(Page::"Product Factory-Account", PFact);
                        PFact."Product Class"::Loan:
                            Page.Run(Page::"Product Factory-Loan", PFact);
                    end
                end;
            DATABASE::"Member Changes":
                begin
                    if not MemberChange.Get(DocumentNo) then exit;
                    case
                        MemberChange."Document Type" of
                        MemberChange."Document Type"::"Member Change":
                            PAGE.Run(PAGE::"Member Change Card", MemberChange);
                        MemberChange."Document Type"::"Account Activation":
                            PAGE.Run(PAGE::"Account Activation", MemberChange);
                        MemberChange."Document Type"::"Card Link":
                            PAGE.Run(PAGE::"Automated Card Authorisation", MemberChange);
                        MemberChange."Document Type"::"Kin Signatories":
                            PAGE.Run(PAGE::"Member Change Card", MemberChange);
                    end;
                end;
            Database::"Mc Acc. Changes":
                begin

                    if not RecordChange.Get(DocumentNo) then
                        exit;
                    case RecordChange."Account Dimension" of
                        RecordChange."Account Dimension"::Credit:
                            begin
                                Page.Run(Page::"Mc. Ac. Changes Page", RecordChange);
                            end;
                        RecordChange."Account Dimension"::Banking:
                            begin
                                Page.Run(Page::"Ac Changes Card", RecordChange);
                            end;

                    end
                end;
            DATABASE::Loans:
                begin
                    if not Facility.Get(DocumentNo) then exit;
                    PAGE.Run(PAGE::"Loans Card", Facility);
                end;
            DATABASE::"Collateral Register":
                begin
                    if not CollateralRegister.Get(DocumentNo) then exit;
                    case CollateralRegister."Document Type" of
                        CollateralRegister."Document Type"::Collateral:
                            PAGE.Run(PAGE::"Collateral Register Card", CollateralRegister);
                        CollateralRegister."Document Type"::Document:
                            PAGE.Run(PAGE::"Safe Custody Card", CollateralRegister);
                    end;
                end;
            DATABASE::"Loan Disbursement Header":
                begin
                    if not DisbursementHeader.Get(DocumentNo) then exit;
                    PAGE.Run(PAGE::Batch, DisbursementHeader);
                end;
            DATABASE::"Interest Header":
                begin
                    if not InterestHeader.Get(DocumentNo) then exit;
                    PAGE.Run(PAGE::"Interest Header Card", InterestHeader);
                end;
            DATABASE::"Checkoff Header":
                begin
                    if not ReceiptsHeader.Get(DocumentNo) then exit;
                    PAGE.Run(PAGE::"Remittance Header", ReceiptsHeader);
                end;
            DATABASE::"Recovery Header":
                begin
                    if not RecoveryHeader.Get(DocumentNo) then exit;
                    PAGE.Run(PAGE::"Recovery Header", RecoveryHeader);
                end;
            DATABASE::"Security Collection":
                begin
                    if not SecurityCollection.Get(DocumentNo) then exit;
                    PAGE.Run(PAGE::"Collateral Collection Card", SecurityCollection)
                end;
            Database::"Teller Transaction":
                begin
                    if not TellerTrans.Get(DocumentNo) then exit;
                    Page.Run(Page::"Teller Transaction", TellerTrans);

                end;
            Database::"Treasury Cashier Transaction":
                begin
                    if not TraesuryTrans.Get(DocumentNo) then exit;
                    Page.Run(Page::"Treasury Cashier Transaction", TraesuryTrans);
                end;
            Database::"Account Transfer Header":
                begin
                    if not AccTransfer.Get(DocumentNo) then exit;
                    Page.Run(Page::"Account Transfer", AccTransfer);
                end;
            Database::"Bankers Cheque Application":
                begin
                    if not BnkCheque.Get(DocumentNo) then exit;
                    Page.Run(Page::"Bankers Cheque Application", BnkCheque);
                end;
            Database::"Standing Order Header":
                begin
                    if not StandingOrder.Get(DocumentNo) then exit;
                    Page.Run(Page::"Standing Order", StandingOrder);
                end;
            Database::"EFT Transfer Header":
                begin
                    if not EFTHeader.Get(DocumentNo) then exit;
                    case EFTHeader."Application Source" of
                        EFTHeader."Application Source"::Credit:
                            Page.Run(Page::"EFT Transfer Header", EFTHeader);
                        EFTHeader."Application Source"::Teller,
                            EFTHeader."Application Source"::Benefits,
                        EFTHeader."Application Source"::Finance:
                            Page.Run(Page::"EFT Receipt Header", EFTHeader);
                    end;
                end;
            Database::"Dsc Mobile Application":
                begin
                    if not MRegmt.Get(DocumentNo) then exit;
                    Page.Run(Page::"Mobile Registration Page", MRegmt);
                end;
            Database::"HR Employees":
                begin
                    if not ObjtEmp.Get(DocumentNo) then exit;
                    Page.Run(Page::"Hr Employee Card", ObjtEmp);
                end;
            else begin
                exit
            end;
        end;
    end;

    procedure getmemberStatsAcc(MemberNo: Code[100]; PostInteger: Integer)
    var
        CustMembr: Record Member;
        PLoan: Record Loans;
    begin
        case PostInteger of
            0:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') then
                        REPORT.RUN(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;

            1:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') THEN
                        REPORT.RUN(Report::"Standard Statement-All Account", TRUE, FALSE, CustMembr);

                end;
            2:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') THEN
                        REPORT.RUN(Report::"Standard Statement-All Account", TRUE, FALSE, CustMembr);
                end;
            3:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') then
                        REPORT.RUN(Report::"Member Loan Guaranteed", true, false, CustMembr);
                end;
            4:
                begin
                    PLoan.Reset();
                    PLoan.SetRange("Account No.", MemberNo);
                    if PLoan.Find('-') then
                        Report.Run(Report::"Member Loan Guarantors", true, false, PLoan);

                end;
            5:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') then
                        Page.Run(Page::"Member Contribution", CustMembr, CustMembr."No.");


                end;
            6:
                begin

                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') then
                        Page.Run(Page::"Savings Account List", CustMembr, CustMembr."No.");
                end;
            7:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') then
                        Page.Run(Page::"Account Credit List", CustMembr, CustMembr."No.");

                end;
            8:
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", MemberNo);
                    IF CustMembr.FIND('-') then
                        Page.Run(Page::"Member Statistics", CustMembr, CustMembr."No.");
                end;
        end
    end;

    procedure PermissionMngt(UserAcNo: Code[100]; FunctTxt: Enum "Change Status"; ExtFuncTxt: Enum "Change Status")
    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
    begin

        StatusChange.Reset();
        StatusChange.SetRange("User ID", UserAcNo);
        StatusChange.SetRange(Function, FunctTxt);
        StatusChange.SetRange("Function Extended", ExtFuncTxt);
        if not StatusChange.FindFirst() then begin
            Error(MsgOnPermissionTxt);
        end;

    end;

    procedure PermissionOnRecRestrict(AccNo: Code[100])
    begin
        StatusChange.Reset();
        StatusChange.SetRange("User ID", AccNo);
        StatusChange.SetRange(Function, StatusChange.Function::Administrator);
        if not StatusChange.FindFirst() then
            Error(ErrorOnPermissionTxt);
    end;

    procedure RecordRestrictMngt(UserAcNo: Code[100]; TableID: Integer; ExtFuncTxt: Enum "Change Status"): Boolean
    var
        RecRestriction: Record "Record Restrictions Mngt.";
        UserSettings: Page "User Settings";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

    begin

        RecRestriction.Reset();
        RecRestriction.SetRange("Table ID", TableID);
        RecRestriction.SetRange("Account No.", UserAcNo);
        RecRestriction.SetRange("Document Type", RecRestriction."Document Type"::TableID);
        if RecRestriction.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure RecordRestrictDataMngt(UserAcNo: Code[100]; TableID: Integer; ExtFuncTxt: Enum "Change Status"): Boolean
    var
        RecRestriction: Record "Record Restrictions Mngt.";
        UserSettings: Page "User Settings";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

    begin

        RecRestriction.Reset();
        RecRestriction.SetRange("Table ID", TableID);
        RecRestriction.SetRange("Account No.", UserAcNo);
        RecRestriction.SetRange("Data Management", RecRestriction."Data Management"::Import);
        RecRestriction.SetRange("Document Type", RecRestriction."Document Type"::TableID);
        if RecRestriction.FindFirst() then begin
            exit(true)
        end;
        exit(false)

    end;

    procedure PostReversalMngt(UserAcNo: Code[100]): Boolean
    var
        Temp: Record "User Setup";
    begin
        Temp.Reset();
        Temp.SetRange("User ID", UserAcNo);
        Temp.SetRange("Post Reversals", true);
        if Temp.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure PostJournalMngt(UserAcNo: Code[100]): Boolean
    var
        Temp: Record "User Setup";
    begin
        Temp.Reset();
        Temp.SetRange("User ID", UserAcNo);
        Temp.SetRange("Post Journals", true);
        if Temp.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure PostBankReconMngt(UserAcNo: Code[100]): Boolean
    var
        Temp: Record "User Setup";
    begin
        Temp.Reset();
        Temp.SetRange("User ID", UserAcNo);
        Temp.SetRange("Post Bank Reconcilliation", true);
        if Temp.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure PermissionBankingMngt(UserAcNo: Code[100]; FunctTxt: Boolean): Boolean
    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
    begin
        if not fnOverride() then begin
            StatusChange.Reset();
            StatusChange.SetRange("User ID", UserAcNo);
            StatusChange.SetRange("Edit Data Sheet", FunctTxt);
            if StatusChange.FindFirst() then begin
                exit(true)
            end;
            exit(false)
        end;
    end;

    procedure PostJournalsMngt(UserAcNo: Code[100]) PostJournal: Boolean
    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Record "User Setup";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
    begin

        UserSettings.Reset();
        UserSettings.SetRange("User ID", UserAcNo);
        UserSettings.SetRange("Post Journals", true);
        if UserSettings.FindFirst() then begin
            PostJournal := true
        end;
    end;

    procedure fnGetCurrentBatchName(AccNo: Code[100]; CurrentJnlBatchName: Code[100]; JournalTemplateName: Code[100]): Boolean
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("User ID", AccNo);
        GenJnlBatch.SetRange(Name, CurrentJnlBatchName);
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        if GenJnlBatch.FindFirst() then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure fnCheckCurrentRespBatchName(AccNo: Code[100]; CurrentJnlBatchName: Code[100]; JournalTemplateName: Code[100])
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange(Name, CurrentJnlBatchName);
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        if GenJnlBatch.FindFirst() then begin
            GenJnlBatch.TestField("User ID");
            GenJnlBatch.TestField("Responsibility Centre");
        end;
    end;

    local procedure fnOverride(): Boolean
    begin
        gensetup.Get();
        if gensetup."Override Setup Control" then begin
            exit(true)
        end;
        exit(false)
    end;

    procedure PassDocumentNo(strUserCode: Code[100]; var RespCentre: Code[20]; var Dim1: Code[20]; var Dim2: Code[20]; var PostUserCode: Code[100]; var DateCreated: Date; var TimeCreated: Time)
    var
        ExemptionsApprvl: Record "User Setup";
        HrLeaveMgt: Record "Hr Leave Mgt.";
        ObjtEmpCode: Record "Hr Employees";

    begin
        ExemptionsApprvl.Get(strUserCode);
        ExemptionsApprvl.TestField("Responsibility Centre");
        ExemptionsApprvl.TestField("Global Dimension 1 Code");
        ExemptionsApprvl.TestField("Global Dimension 2 Code");
        ExemptionsApprvl.TestField("Employee No.");
        RespCentre := ExemptionsApprvl."Responsibility Centre";
        Dim1 := ExemptionsApprvl."Global Dimension 1 Code";
        Dim2 := ExemptionsApprvl."Global Dimension 2 Code";
        PostUserCode := UserId;
        DateCreated := Today;
        TimeCreated := Time;
    end;

    var
        gensetup: Record "General Set-Up";
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        ErrorOnPermissionTxt: Label 'You don not permission to Access this Page. Kindly contact your system administration for assistance';


}




