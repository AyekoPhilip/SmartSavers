codeunit 50041 "Credit Mgmt."
{

    trigger OnRun()
    begin
    end;

    var
        ProdFact: Record "Product Factory";
        DocsMngt: Codeunit "Doc-PostMgt";
        BankMngt: Codeunit "Banking Procedure Mngt.";
        Member: Record Member;
        SmsNotification: Codeunit "SMS Notification";
        LoansRec: Record Loans;
        ActItems: Enum ActionPanesItems;
        GenPostMngt: Codeunit "Gen.Jnl.+Preview";
        RegMgt: Codeunit "Register Management";
        AcCatType: Enum ProductAccountCategory;
        AdviceType: Enum AdviseType;
        CredNotif: Codeunit "SMS Notification";
        DocMngt: Codeunit "Doc. Mngt";
        CreditMngt: Codeunit "Credit Mgmt.";
        DocPostMgt: Codeunit "Doc-PostMgt";
        GeneralSetUp: Record "General Set-Up";
        ApprovalMgnt: Codeunit "Approval Mgmt.";
        Mgt: Codeunit "Periodic Activities Mgt.";
        Notifsource: Enum NotifSourceType;
        MonthCont: Record "Member Monthly Contribution";

    procedure CheckCustomerExistingProduct(MemberNo: Code[50]; ProductType: Code[10]; TopUpAmt: Decimal; LoanNo: Code[50])
    var
        LoanApp: Record Loans;
        StringErrorText0001: Label 'Member has an existing loan of same product.Kindly topup before you can continue.';
        StringErrorText0002: Label 'Account No. or Product of the Loan application must have a value. It cannot be blank';
        StringErrText0003: Label 'Member already has an existing %1-%2 application';
        ProductFact: Record "Product Factory";
    begin
        if (MemberNo <> '') and (ProductType <> '') then begin

            LoanApp.Reset;
            LoanApp.SetRange("Account No.", MemberNo);
            LoanApp.SetRange("Approval Status", LoanApp."Approval Status"::Open);
            LoanApp.SetFilter("Disbursement Destination", '<>%1', LoanApp."Disbursement Destination"::"Bank Account");
            if LoanApp.FindFirst then begin
                if LoanApp."No." <> LoanNo then
                    Message(StringErrText0003, ProductType, LoanApp."No.");
            end;

            LoanApp.Reset;
            LoanApp.SetRange("Account No.", MemberNo);
            LoanApp.SetFilter("Outstanding Balance", '>0');
            LoanApp.SetRange("Product Type", ProductType);
            if LoanApp.Find('-') then begin
                LoanApp.CalcFields("Outstanding Balance");
                if ProdFact.Get(ProductType) then begin
                    if ProdFact."Allow Multiple Running Loans" then begin
                        ProdFact.TestField("Max. No.(Same Loans)");
                        if LoanApp.Count > ProdFact."Max. No.(Same Loans)" then
                            Error('Member exceed max. same loan application of %1', ProdFact."Max. No.(Same Loans)");
                    end else begin
                        if TopUpAmt = 0 then
                            Message(StringErrorText0001);
                    end;
                end;
            end;
            RegMgt.GetLoanCharges(ProductType, LoanNo, 0, 0);
        end else begin
            Error(StringErrorText0002)
        end
    end;


    procedure CreateLoanAccount(MemberNo: Code[100]; ProdType: Code[20]) LoanAcc: Code[100]
    var
        ProdFac: Record "Product Factory";
        Accounts: Record "Credit Account";
        Member: Record Member;
    begin

        GeneralSetUp.Get();

        if ProdFac.Get(ProdType) then begin
            if Member.Get(MemberNo) then begin
                RegMgt.CreateCredicAcc(ProdFac."Product ID", Member."No.")
            end;
            case GeneralSetUp."Loan Account Options" of
                GeneralSetUp."Loan Account Options"::Single:
                    LoanAcc := MemberNo;
                GeneralSetUp."Loan Account Options"::Multiple:
                    LoanAcc := ProdFac."Account No. Suffix" + MemberNo + ProdFac."Account No. Prefix";
                else
                    Error('Invalid Option Selected (Loan Account Options)');
            end;
            if Accounts.Get(LoanAcc) then
                exit(LoanAcc);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanEntry(var LoanEntry: Record Loans; Applic: Record "Loan Application")
    begin
    end;


    procedure OnValidateLoanStatusTxt(LoanStatus: Enum ApprovalStatus; MemberNo: Code[20]; AmToDisburse: Decimal; Repaymt: Decimal; LoanNo: Code[20]; DisAccountNo: Code[20]; RequestAmt: Decimal; RejectionReason: Text[150]; ProdType: Text[150])
    var
        CustMember: Record Member;
        Text0001: Label 'Your %1 application of KES %2 has been received and is being processed';
        Text0002: Label 'Dear';
        Text0003: Label '.Kindly pay Loan monthly installment of kshs.';
        Text0004: Label '.each.';
        Text0005: Label ',Your Loan has been of KES';
        Text0006: Label ' has been rejected.';
        Text0007: Label '. Thank you for choosing us.';
        LnSecurity: Record "Loan Guarantors and Security";
        AccountCred: Record "Account Credit";
        CSCApp: Codeunit "CSC Appraisal Parameters";
        Varvariants: Variant;
        CustRec: Record Member;
        Notif: Codeunit "SMS Notification";
        LoansApp: Record "Loan Application";
        CustRecord: Record Member;
    begin
        case LoanStatus of
            LoanStatus::Approved:
                begin

                end;
            LoanStatus::"Pending Approval":
                begin

                    if CustMember.Get(MemberNo) then begin
                        CredNotif.CreateSmsNotif(Notifsource::"Loan Posted", CustMember."Mobile Phone No", Text0002 + ' ' +
                         CustMember.Name + ', Your ' + ProdType + ' application of KES ' + Format(AmToDisburse) + ' has been received and is being processed', LoanNo, DisAccountNo, false);
                    end;

                    GeneralSetUp.Get();
                    if GeneralSetUp."Nofity Guarantors" then begin
                        LnSecurity.Reset;
                        LnSecurity.SetRange("No.", LoanNo);
                        LnSecurity.SetRange("Notification Sent", false);
                        if LnSecurity.FindSet() then begin
                            repeat
                                case LnSecurity."Security Type" of
                                    Lnsecurity."Security Type"::Guarantor,
                                    Lnsecurity."Security Type"::Lien:
                                        begin
                                            if AccountCred.Get(LnSecurity."Account No.") then begin
                                                if CustRecord.Get(AccountCred."Member No.") then begin
                                                    if LoansApp.Get(LoanNo) then begin
                                                        CSCApp.SendSmsNotification(LnSecurity."Account No.", LoansApp."Account Name",
                                                       LoansApp."Product Description", LoansApp."Approved Amount", LoansApp."No.");
                                                        if CustRec.Get(AccountCred."Member No.") then begin
                                                            Varvariants := LnSecurity;
                                                        end;
                                                        LnSecurity."Notification Sent" := true;
                                                        LnSecurity.Modify(true);
                                                    end;
                                                end;

                                            end;
                                        end;
                                end;
                            until LnSecurity.Next() = 0;
                        end;
                    end;
                end;
            LoanStatus::Rejected:
                begin
                    if CustMember.Get(MemberNo) then begin
                        CredNotif.CreateSmsNotif(Notifsource::"Loan Rejected", CustMember."Mobile Phone No", Text0002 + ' ' +
                         CustMember.Name + Text0005 + Format(RequestAmt) + Text0006 + '(' + RejectionReason + ')' +
                         Text0007 + CompanyName + '.', LoanNo, DisAccountNo, false);
                    end;
                end;
        end
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanOnBeforeLoanEntryInsert(var LoanEntry: Record Loans; var VarVariant: Record "Loan Application"; LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanOnBeforeLoanCategoryEntryInsert(var LoanEntry: Record "Loans Categorization"; var VarVariant: Record Loans; LoanApplication: Record Loans)
    begin
    end;


    procedure fnComputeCharges(ApprovedAmt: Decimal; ProdType: Code[20]; LoanNo: Code[20]; CurrValue: Decimal; DepositPurchase: Decimal): Decimal
    var
        ComputedCharges: Decimal;
        LoanAppCharges: Record "Loan Application Charge";
    begin
        LoanAppCharges.Reset;
        LoanAppCharges.SetRange("Application No.", LoanNo);
        if LoanAppCharges.Find('-') then begin
            repeat
                if LoanAppCharges."Use Percentage" then begin
                    LoanAppCharges.TestField(Percentage);
                    ComputedCharges := Round((ComputedCharges + (ApprovedAmt * LoanAppCharges.Percentage)), 1, '=');
                end else begin
                    ComputedCharges := ComputedCharges + LoanAppCharges."Charge Amount"
                end;
            until LoanAppCharges.Next = 0;
        end;
        exit(ComputedCharges)
    end;


    procedure fnCalculateAvailableShares(AcNo: Code[20]; DepositShares: Decimal) AvailableShares: Decimal
    var
        LSecurity: Record "Guarantor & Security Posted";
        TotAmtGuaranteed: Decimal;
        Loans: Record Loans;
        TotalGuarant: Decimal;
    begin
        LSecurity.Reset;
        LSecurity.SetRange("Account No.", AcNo);
        LSecurity.SetFilter("Outstanding Balance", '>0');
        if LSecurity.Find('-') then begin
            LSecurity.CalcFields("Outstanding Balance");
            LSecurity.CalcSums("Amount Guaranteed");
            TotAmtGuaranteed := LSecurity."Amount Guaranteed";
            Loans.Reset;
            Loans.SetRange("Account No.", LSecurity."Account No.");
            Loans.SetFilter("Outstanding Principal", '>0');
            if Loans.Find('-') then begin
                repeat
                    Loans.CalcFields("Outstanding Principal");
                    TotalGuarant := Round((TotalGuarant + (Loans."Outstanding Principal" / Loans."Approved Amount")), 1, '=');
                until Loans.Next = 0;
            end;
            AvailableShares := (DepositShares * GeneralSetUp."Guarantors Multiplier") - (TotalGuarant * TotalGuarant);
            if AvailableShares < 0 then
                AvailableShares := 0;
        end;
        exit(AvailableShares)
    end;

    local procedure InitLoanEntry(RecRef: Record "Loan Application"; var LoanRecordEntry: Record Loans)
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry.CopyFromLoanApplicationLine(RecRef);
        LoanRecordEntry."No." := '';
        OnAfterInitLoanEntry(LoanRecordEntry, RecRef);
    end;

    local procedure InitQCLoanEntry(RecRef: Record Loans; var LoanRecordEntry: Record "Loans (Procedure)"; LoanNo: Code[100])
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry."No." := LoanNo;
        LoanRecordEntry."Entry No." := RegMgt.generateNextEntryNo();
        LoanRecordEntry.CopyFromLoanApplicationLine(RecRef);

    end;

    procedure ApplicationDocPane(var Variant: Variant; ActionItem: Enum ActionPanesItems)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Action Item %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        LoansApp: Record "Loan Application";
        Members: Record Member;
        PLoan: Record Loans;
        LoanApplic: Record "Loan Application";
        DisbursementHeader: Record "Loan Disbursement Header";
        Batch: Record "Loan Disbursement Header";
        InterestHeader: Record "Interest Header";
        TextInt000: Label 'Interest Posting...\';
        TextInt001: Label 'Do you want to create and post interest lines?';
        IntHeader: Record "Interest Header";
        CollateralRegister: Record "Collateral Register";
        CheckHeader: Record "Checkoff Header";
        Receiptines: Record "Checkoff Receipt Lines";
        TextHeader000: Label 'Post\';
        TextHeader001: Label 'Do you want to create and post this application?';
        RecoveryHeader: Record "Recovery Header";
        GuarantSecurity: Record "Guarantor & Security Posted";
        SecurityCollection: Record "Security Collection";
        LnSecurity: Record "Loan Guarantors and Security";
        AccountCred: Record "Account Credit";
        CSCApp: Codeunit "CSC Appraisal Parameters";
        Varvariants: Variant;
        CustRec: Record Member;
        Notif: Codeunit "SMS Notification";
        RepaySchedMngt: Codeunit "Generate RapaymentSchedule";
        LoanCalc: Record "Loan Calculator";
        LnCalc: Record "Loan Calculator";
        ConfigPackgt: Record "Config. Package";
        LonPostMngt: Codeunit "Loan Post Mngt. (Yes/No)";
        Varvariant: Variant;
        Applic: Record "Loan Application";
        PostCheckMgt: Codeunit "Post. Checkoff Mngt.";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(LoansApp);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin
                                LoansApp.TestField("Account No.");
                                LoansApp.TestField("Product Type");
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                LoanApplic.SetRange("No.", LoansApp."No.");
                                if LoanApplic.Find('-') then
                                    GenerateRepaymentSchedule(false, LoanApplic."No.", 1);
                            end;
                        ActionItem::"Loan BuyOff":
                            begin
                                LoansApp.TestField("Account No.");
                            end;
                        ActionItem::"Loan History":
                            begin
                                PLoan.SetRange("Account No.", LoansApp."Account No.");
                                if PLoan.Find('-') then
                                    PAGE.Run(PAGE::"Loan Application Posted", PLoan, PLoan."Account No.");
                            end;
                        ActionItem::"Salary Details":
                            begin
                                CreditMngt.fnFetchSalaryDetails(LoansApp."Account No.", LoansApp."No.");
                            end;
                        ActionItem::Statement:
                            begin
                                Members.Reset;
                                Members.SetRange("No.", LoansApp."Account No.");
                                if Members.Find('-') then
                                    REPORT.Run(50357, true, false, Members);
                            end;
                        ActionItem::"Loan Appraisal":
                            begin
                                Applic.Reset();
                                Applic.SetRange("No.", LoansApp."No.");
                                if Applic.Find('-') then begin
                                    Codeunit.Run(Codeunit::"CSC Appraisal Parameters", LoansApp);
                                end;
                            end;
                        ActionItem::"Post Application":
                            begin

                                LoansApp.CheckMinRequirementApprovals();
                                LoansApp.TestField("Approval Status", LoansApp."Approval Status"::Approved);

                                GeneralSetUp.Get();
                                GeneralSetUp.TestField("Post Loan As");

                                if Confirm(OnConfirmDialogTxt, true) = false then
                                    exit;
                                case GeneralSetUp."Post Loan As" of
                                    GeneralSetUp."Post Loan As"::"Create as User":
                                        begin
                                            DocPostMgt.LoanRegistration(LoansApp, 1)
                                        end;
                                end
                            end;
                        ActionItem::Commitments:
                            begin

                            end;
                        ActionItem::File:
                            begin

                            end;
                        ActionItem::"Send Approval Request":
                            begin
                                LoansApp.TestField("Loan Status", LoansApp."Loan Status"::Appraisal);
                                LoansApp.CheckMinRequirementApprovals;
                                LoansApp.CheckMinReqOnExternalComms();
                                ApprovalMgnt.OnSendLoanApplicationApprovalRequest(LoansApp, 1);
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                                ApprovalMgnt.OnCancelLoanApplicationApprovalRequest(LoansApp, true, true)
                            end;
                        ActionItem::"Open Request":
                            begin
                                ApprovalMgnt.OnOpenLoanApplicationApprovalRequest(LoansApp, true, true)
                            end;
                    end;
                    Variant := LoansApp;
                end;
            DATABASE::Loans:
                begin
                    RecRef.SetTable(PLoan);
                    case ActionItem of
                        ActionItem::"Post Application":
                            begin
                                if Confirm(OnConfirmDialogTxt, true) = false then
                                    exit;

                                LoansRec.Reset();
                                LoansRec.SetRange("No.", PLoan."No.");
                                if LoansRec.FindFirst() then begin
                                    LoansRec.TestField("Approval Status", LoansRec."Approval Status"::Approved);

                                    case LoansRec."Application Type" of
                                        LoansRec."Application Type"::"Loan Restructure":
                                            begin
                                                if LoansRec."Check Line" then begin
                                                    Codeunit.Run(Codeunit::"Loan Post Mngt. (Yes/No)", LoansRec);
                                                    Commit();
                                                    ValuePost(LoansRec."No.", 0);
                                                end;
                                            end;
                                        LoansRec."Application Type"::Normal:
                                            begin
                                                case LoansRec."Mode of Disbursement" of
                                                    LoansRec."Mode of Disbursement"::"Full Disbursement":
                                                        begin
                                                            GenPostMngt.CodePost(LoansRec."No.", true, Today, LoansRec."No.");
                                                        end else begin
                                                        GenPostMngt.CodePostPartialDisb(LoansRec."No.", true, Today, LoansRec."No.", 1);
                                                    end
                                                end;
                                                Commit();
                                                ValuePost(LoansRec."No.", 0);

                                            end;

                                    end;
                                end

                            end;
                    end;
                    Variant := PLoan;
                end;
            DATABASE::"Loan Disbursement Header":
                begin
                    RecRef.SetTable(DisbursementHeader);
                    case ActionItem of
                        ActionItem::"Loan BuyOff":
                            begin
                                Batch.Reset;
                                Batch.SetRange("No.", DisbursementHeader."No.");
                                if Batch.Find('-') then begin
                                    Report.Run(Report::"Disbursement Schedule", true, true, Batch);
                                end
                            end;
                        ActionItem::"Post Application":
                            begin
                                DisbursementHeader.CheckRequiredItems;
                                DisbursementHeader.TestField("Payment Type");
                                DisbursementHeader.TestField("Approval Status",
                             DisbursementHeader."Approval Status"::Approved);
                                if Confirm(OnConfirmDialogTxt, true) = false then
                                    exit;
                                case DisbursementHeader."Payment Type" of
                                    DisbursementHeader."Payment Type"::Loans:
                                        begin
                                            Batch.Reset;
                                            Batch.SetRange("No.", DisbursementHeader."No.");
                                            if Batch.Find('-') then begin
                                                CODEUNIT.Run(CODEUNIT::"Credit. Jnl.-Post Batch", Batch)
                                            end
                                        end
                                end
                            end;
                        ActionItem::"Send Approval Request":
                            begin
                                DisbursementHeader.CheckRequiredItems;
                                ApprovalMgnt.OnSendBatchApprovalResquest(DisbursementHeader);
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                                ApprovalMgnt.OnCancelBatchApprovalRequest(DisbursementHeader, true, true)
                            end;
                        ActionItem::"Open Request":
                            begin
                                ApprovalMgnt.OnOpenBatchApprovalRequest(DisbursementHeader, true, true)
                            end;
                    end;
                    Variant := DisbursementHeader
                end;
            Database::"Loan Calculator":
                begin
                    RecRef.SetTable(LoanCalc);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin
                                LoanCalc.TestField("Account No.");
                                LoanCalc.TestField("Product Type");
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                LnCalc.SetRange("No.", LoanCalc."No.");
                                if LnCalc.Find('-') then
                                    GenLoanCalcRepaymentSchedule(false, LnCalc."No.", 1);
                            end;
                        ActionItem::"Loan BuyOff":
                            begin
                                LoanCalc.TestField("Account No.");
                            end;
                        ActionItem::"Loan History":
                            begin
                                PLoan.SetRange("Account No.", LoanCalc."Account No.");
                                if PLoan.Find('-') then
                                    PAGE.Run(PAGE::"Loan Application Posted", PLoan, PLoan."Account No.");
                            end;
                        ActionItem::"Salary Details":
                            begin
                                CreditMngt.fnFetchSalaryDetails(LoanCalc."Account No.", LoanCalc."No.");
                            end;
                        ActionItem::Statement:
                            begin
                                Members.Reset;
                                Members.SetRange("No.", LoanCalc."Account No.");
                                if Members.Find('-') then
                                    Report.Run(50357, true, false, Members);
                            end;
                        ActionItem::"Loan Appraisal":
                            begin
                                Codeunit.Run(Codeunit::"Cred. Mngt Loan Appraisal", LoanCalc)
                            end;
                    end;
                    Variant := LoanCalc;
                end;
            DATABASE::"Interest Header":
                begin
                    RecRef.SetTable(InterestHeader);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin
                                if not
                              Confirm(
                                TextInt000 +
                                TextInt001)
                           then
                                    exit;
                                InterestHeader.TestField("Application Type");
                                Codeunit.Run(Codeunit::"Gen.Jnl.-Post Periodic", InterestHeader)
                            end;
                        ActionItem::"Loan BuyOff":
                            begin
                                IntHeader.Reset;
                                IntHeader.SetRange("No.", InterestHeader."No.");
                                if IntHeader.Find('-') then begin
                                    case IntHeader."Application Type" of
                                        IntHeader."Application Type"::Insurance,
                                            IntHeader."Application Type"::"Loan Interest",
                                            IntHeader."Application Type"::"Ledger fee",
                                            IntHeader."Application Type"::Penalty,
                                            IntHeader."Application Type"::"Interest+Insurance",
                                            IntHeader."Application Type"::"Interest or Ledger Fee",
                                            IntHeader."Application Type"::"Interest+Insurance+LedgerFee":
                                            begin
                                                Report.Run(Report::"Post Loan Interest/Penalty", true, false, IntHeader)
                                            end;
                                        InterestHeader."Application Type"::"Benevolent Recovery":
                                            begin
                                                Report.Run(Report::"Calculate Benovelent Recovery", true, false, IntHeader);

                                            end;

                                    end;

                                end;
                            end;
                        ActionItem::"Salary Details":
                            begin
                                ApprovalMgnt.OnSendBillingApprovalResquest(InterestHeader)
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                ApprovalMgnt.OnCancelBillingApprovalRequest(InterestHeader, true, true)
                            end;
                        ActionItem::Statement:
                            begin
                                ApprovalMgnt.OnOpenBillingApprovalRequest(InterestHeader, true, true)
                            end;
                    end;
                    Variant := InterestHeader
                end;
            DATABASE::"Collateral Register":
                begin
                    RecRef.SetTable(CollateralRegister);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin
                                CollateralRegister.CheckRequiredItems;
                                ApprovalMgnt.OnSendCollateralRegtApprovalRequest(CollateralRegister)
                            end;
                        ActionItem::"Loan BuyOff":
                            begin
                                ApprovalMgnt.OnCancelCollateralRegtApprovalRequest(CollateralRegister,
                                   true, true)
                            end;
                        ActionItem::"Salary Details":
                            begin
                                ApprovalMgnt.OnOpenCollateralRegtApprovalRequest(CollateralRegister,
                                   true, true)
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                ApprovalMgnt.OpenApprovalEntriesPage(CollateralRegister."No.", Database::"Collateral Register")
                            end;
                    end;
                    Variant := CollateralRegister;
                end;
            DATABASE::"Checkoff Header":
                begin
                    RecRef.SetTable(CheckHeader);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin
                                Receiptines.Reset;
                                Receiptines.SetRange("No.", CheckHeader."No.");
                                Receiptines.DeleteAll;
                                Commit;
                                Xmlport.Run(Xmlport::"Import Checkoff Receipts")
                            end;
                        ActionItem::File:
                            begin
                                Receiptines.Reset;
                                Receiptines.SetRange("No.", CheckHeader."No.");
                                Receiptines.DeleteAll;
                                Commit;
                                Xmlport.Run(Xmlport::"Import CheckOff- Product")
                            end;
                        ActionItem::"Loan BuyOff":
                            begin
                                PostCheckMgt.PerfomValidate(CheckHeader);
                            end;
                        ActionItem::"Salary Details":
                            begin
                                CheckHeader.RequiredItems;
                                ApprovalMgnt.OnSendCheckoffApprovalRequest(CheckHeader)
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                ApprovalMgnt.OnCancelCheckoffApprovalRequest(CheckHeader, true, true)
                            end;
                        ActionItem::Statement:
                            begin
                                ApprovalMgnt.OnOpenCheckoffApprovalRequest(CheckHeader, true, true)
                            end;
                        ActionItem::"Loan Appraisal":
                            begin
                                if Confirm(TextHeader000 + TextHeader001, true) = false then exit;
                                Mgt.PostCode(CheckHeader, 1);
                            end;
                        ActionItem::Commitments:
                            begin

                                Receiptines.Reset;
                                Receiptines.SetRange("No.", CheckHeader."No.");
                                Receiptines.DeleteAll;
                                Commit;

                                ConfigPackgt.Reset();
                                ConfigPackgt.SetRange(Code, 'CHECKOFF');
                                if ConfigPackgt.FindFirst() then begin
                                    Page.Run(Page::"Config.Package", ConfigPackgt, ConfigPackgt.Code);
                                end else begin
                                    Error('No Configuration Package related to this process found');
                                end;
                            end;
                    end;
                    Variant := CheckHeader
                end;
            DATABASE::"Recovery Header":
                begin
                    RecRef.SetTable(RecoveryHeader);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin

                                if ApprovalMgnt.CheckBlockedDocsOnJnls(RecoveryHeader."No.", Database::"Checkoff Header") then begin
                                    if Confirm(TextHeader000 + TextHeader001, false) = true then
                                        Mgt.PostRecvMgt(RecoveryHeader, 0)
                                end;
                            end;

                        ActionItem::"Loan BuyOff":
                            begin
                                case RecoveryHeader."Recovery Type" of
                                    RecoveryHeader."Recovery Type"::"All Loans":
                                        begin
                                            GuarantSecurity.Reset;
                                            GuarantSecurity.SetRange("Member No. (Loanee)", RecoveryHeader."Account No.");
                                            if GuarantSecurity.Find('-') then
                                                PAGE.Run(PAGE::"Guarantors & Security", GuarantSecurity,
                                               GuarantSecurity."Loan No.")
                                        end;
                                    RecoveryHeader."Recovery Type"::"Specific Loan":
                                        begin
                                            GuarantSecurity.Reset;
                                            GuarantSecurity.SetRange("Loan No.", RecoveryHeader."Loan No.");
                                            if GuarantSecurity.Find('-') then
                                                PAGE.Run(PAGE::"Guarantors & Security", GuarantSecurity,
                                                GuarantSecurity."Loan No.")
                                        end
                                end
                            end;
                        ActionItem::"Salary Details":
                            begin
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                ApprovalMgnt.OnSendRecoveryHeaderApprovalRequest(RecoveryHeader)
                            end;
                        ActionItem::Statement:
                            begin
                                ApprovalMgnt.OnCancelRecoveryHeaderApprovalRequest(RecoveryHeader, true, true)
                            end;
                        ActionItem::"Loan Appraisal":
                            begin
                                ApprovalMgnt.OnOpenRecoveryHeaderApprovalRequest(RecoveryHeader, true, true)
                            end;
                        ActionItem::"Loan History":
                            begin
                                PAGE.Run(PAGE::"Loan List", RecoveryHeader, RecoveryHeader."Account No.");
                            end;
                    end;
                    Variant := RecoveryHeader
                end;

            DATABASE::"Security Collection":
                begin
                    RecRef.SetTable(SecurityCollection);
                    case ActionItem of
                        ActionItem::Agreement:
                            begin
                                SecurityCollection.TestField("Collateral Register No.");
                                ApprovalMgnt.OnSendCollateralCollectionApprovalRequest(SecurityCollection);
                            end;
                        ActionItem::"Loan BuyOff":
                            begin
                                if ApprovalMgnt.OnCancelCollateralCollectionApprovalRequest(SecurityCollection, true, true) then;
                            end;
                        ActionItem::"Salary Details":
                            begin
                                if ApprovalMgnt.OnOpenCollateralCollectionApprovalRequest(SecurityCollection, true, true) then;
                            end;
                        ActionItem::RepaymentSchedule:
                            begin
                                ApprovalMgnt.OpenApprovalEntriesPage(SecurityCollection."No.", 52140660)
                            end;
                        ActionItem::"Loan Appraisal":
                            begin
                            end;
                    end;
                    Variant := SecurityCollection;
                end;
            else
                Error(UnsupportedRecordTypeErr, ActionItem);
        end
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanOnAfterLoanEntryInsert(var LoanEntry: Record Loans; var RecRef: Record "Loan Application"; LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLoanOnAfterLoanCategoryEntryInsert(var LoanEntry: Record "Loans Categorization"; var RecRef: Record Loans; LoanApplication: Record Loans)
    begin
    end;

    procedure GetQualificationSchedule(Post: Boolean; LoanNo: Code[20]; PostInt: Integer; MinuteNo: Code[100]; AppAmount: Decimal)
    var
        RSchedule: Record "Loan Repayment Schedule";
        LoansR: Record "Loan Application";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        InitialInstal: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        Varvariant: Variant;
        Principal: Decimal;
        GrInterest: Decimal;
        GrPrinciple: Decimal;
        RepayCode: Code[10];
        LoanApp: Record "Loan Application";
        AccInt: Decimal;
        StartMonth: Date;
        EndMonthDate: Date;
        CheckoffDate: Date;
        MidCheckDate: Date;
        IntDays: Integer;
        LSchedule: Record "Loan Repayment Schedule";
        SharesDeposit: Decimal;
        SharesBanding: Decimal;
        InsuranceFee: Decimal;
        FactProd: Record "Product Factory";
        SettlementFee: Decimal;
        TopUpFacility: Record "Loans Top up";
        TotalTopup: Decimal;
        TopUpFee: Decimal;

    begin

        GeneralSetUp.Get();
        GeneralSetUp.TestField("Checkoff Cutoff Days");
        case Post of
            false:
                begin
                    RSchedule.Reset;
                    RSchedule.SetRange("No.", MinuteNo);
                    RSchedule.DeleteAll;

                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin
                        FactProd.Get(LoansR."Product Type");

                        LoansR.CalcFields("Total TopUp");

                        LoansR.TestField("Disbursement Date");
                        LoansR.TestField("Repayment Start Date");
                        IntDays := 0;

                        StartMonth := CalcDate('-CM', LoansR."Disbursement Date");
                        EndMonthDate := CalcDate('CM', LoansR."Disbursement Date");
                        MidCheckDate := CalcDate(GeneralSetUp."Checkoff Cutoff Days", StartMonth);

                        if LoansR."Disbursement Date" >= MidCheckDate then
                            IntDays := StartMonth - EndMonthDate else
                            IntDays := 0;

                        LoanAmount := AppAmount;
                        InterestRate := LoansR."Interest Rate";
                        RepayPeriod := LoansR.Installments;
                        InitialInstal := LoansR.Installments;
                        LBalance := AppAmount;
                        RunDate := LoansR."Repayment Start Date";
                        SharesBanding := LoansR."Shares Banding";
                        SharesDeposit := LoansR."Shares Deposit";
                        InstalNo := 0;
                        InsuranceFee := 0;
                        TopUpFee := 0;

                        case LoansR."Repayment Frequency" of
                            LoansR."Repayment Frequency"::Daily:
                                RunDate := CalcDate('-1D', RunDate);
                            LoansR."Repayment Frequency"::Weekly:
                                RunDate := CalcDate('-1W', RunDate);
                            LoansR."Repayment Frequency"::Monthly:
                                RunDate := CalcDate('-1M', RunDate);
                            LoansR."Repayment Frequency"::Quarterly:
                                RunDate := CalcDate('-1Q', RunDate);
                            LoansR."Repayment Frequency"::Yearly:
                                RunDate := CalcDate('-1Y', RunDate);
                        end;
                        repeat

                            InstalNo := InstalNo + 1;
                            case LoansR."Repayment Frequency" of
                                LoansR."Repayment Frequency"::Daily:
                                    RunDate := CalcDate('1D', RunDate);
                                LoansR."Repayment Frequency"::Weekly:
                                    RunDate := CalcDate('1W', RunDate);
                                LoansR."Repayment Frequency"::Monthly:
                                    RunDate := CalcDate('1M', RunDate);
                                LoansR."Repayment Frequency"::Quarterly:
                                    RunDate := CalcDate('1Q', RunDate);
                                LoansR."Repayment Frequency"::Yearly:
                                    RunDate := CalcDate('1Y', RunDate);
                            end;

                            SharesDeposit := (SharesDeposit + SharesBanding);
                            LoansR.TestField(Installments);

                            case LoansR."Interest Calculation Method" of
                                LoansR."Interest Calculation Method"::Amortised:
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 1, '>');
                                        LInterest := Round(LBalance * InterestRate / 12 / 100, 0.01, '=');
                                        InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 1000)) / 2));
                                        LPrincipal := (TotalMRepay - LInterest);
                                        AccInt := RegMgt.getaccruedLoanInterest(LoansR."No.", LoansR."Disbursement Date");
                                    end;
                                LoansR."Interest Calculation Method"::"Straight Line":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');

                                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');
                                        InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 100)) / 2));
                                    end;
                                LoansR."Interest Calculation Method"::"Reducing Balance":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := LoanAmount / RepayPeriod;
                                        LInterest := (InterestRate / 12 / 100) * LBalance;
                                        InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 100)) / 2));
                                    end;
                                LoansR."Interest Calculation Method"::"Reducing Flat":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                                        InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 100)) / 2));
                                        LInterest := Round((LoansR."Approved Amount" * 0.6) * (LoansR.Installments + 1) / (LoansR.Installments * 100), 1, '=');
                                    end;
                                LoansR."Interest Calculation Method"::"Zero Interest":
                                    begin
                                        LPrincipal := LoanAmount / RepayPeriod;
                                    end
                            end;

                            if GrInterest > 0 then
                                LInterest := 0;
                            GrPrinciple := GrPrinciple - 1;
                            GrInterest := GrInterest - 1;
                            Evaluate(RepayCode, Format(InstalNo));

                            if InstalNo = LoansR.Installments then
                                Principal := LBalance else
                                Principal := LPrincipal;

                            RegMgt.ScheduledRepayDetail(MinuteNo, RepayCode,
                            RunDate, InstalNo, LoansR."Interest Rate", Principal,
                            LInterest, 0, (LInterest + Principal + InsuranceFee),
                            LBalance, SharesBanding, SharesDeposit, InsuranceFee, TopUpFee, 0);
                            LBalance := Round(LBalance - LPrincipal);
                        until InstalNo = LoansR.Installments;
                    end;
                    case PostInt of
                        1:
                            begin
                                if LoanApp.Get(LoansR."No.") then begin
                                    case LoanApp."Charge Interest on Posting" of
                                        LoanApp."Charge Interest on Posting"::"Full Interest":
                                            LoanApp."Interest Repayment" := CalcInterestDueOnPost(1, LoanApp."No.")
                                    end;
                                    LoanApp.Modify
                                end;
                                Commit;
                                Varvariant := LoansR;
                                DocMngt.DocPrintRepayschedule(Varvariant, 1);
                            end;
                    end
                end;
            true:
                begin
                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin
                        Varvariant := LoansR;
                        DocMngt.DocPrintRepayschedule(Varvariant, 1);
                    end
                end;
        end
    end;

    procedure GenLoanCalcRepaymentSchedule(Post: Boolean; LoanNo: Code[20]; PostInt: Integer)
    var
        RSchedule: Record "Loan Repayment Schedule";
        LoansR: Record "Loan Calculator";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        InitialInstal: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        Varvariant: Variant;
        Principal: Decimal;
        GrInterest: Decimal;
        GrPrinciple: Decimal;
        RepayCode: Code[10];
        LoanApp: Record "Loan Calculator";
        AccInt: Decimal;
        StartMonth: Date;
        EndMonthDate: Date;
        CheckoffDate: Date;
        MidCheckDate: Date;
        IntDays: Integer;
        LSchedule: Record "Loan Repayment Schedule";
        SharesDeposit: Decimal;
        SharesBanding: Decimal;
        InsuranceFee: Decimal;
        FactProd: Record "Product Factory";
        SettlementFee: Decimal;
        TopUpFacility: Record "Loans Top up";
        TotalTopup: Decimal;
        TopUpFee: Decimal;
        CustRec: Record Member;

    begin

        GeneralSetUp.Get();
        GeneralSetUp.TestField("Checkoff Cutoff Days");
        GeneralSetUp.TestField("Max. Member Age");
        case Post of
            false:
                begin
                    RSchedule.Reset;
                    RSchedule.SetRange("No.", LoanNo);
                    RSchedule.DeleteAll;

                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin

                        FactProd.Get(LoansR."Product Type");
                        LoansR.CalcFields("Total TopUp");
                        LoansR.TestField("Disbursement Date");
                        LoansR.TestField("Repayment Start Date");
                        IntDays := 0;

                        StartMonth := CalcDate('-CM', LoansR."Disbursement Date");
                        EndMonthDate := CalcDate('CM', LoansR."Disbursement Date");
                        MidCheckDate := CalcDate(GeneralSetUp."Checkoff Cutoff Days", StartMonth);

                        if LoansR."Disbursement Date" >= MidCheckDate then
                            IntDays := StartMonth - EndMonthDate else
                            IntDays := 0;

                        LoanAmount := LoansR."Approved Amount";
                        InterestRate := LoansR."Interest Rate";
                        RepayPeriod := LoansR.Installments;
                        InitialInstal := LoansR.Installments;
                        LBalance := LoansR."Approved Amount";
                        RunDate := LoansR."Repayment Start Date";
                        SharesBanding := LoansR."Shares Banding";
                        SharesDeposit := LoansR."Shares Deposit";
                        InstalNo := 0;
                        InsuranceFee := 0;
                        TopUpFee := 0;

                        if CustRec.Get(LoansR."Account No.") then
                            CustRec.TestField("Date of Birth");
                        if CalcDate(GeneralSetUp."Max. Member Age", CustRec."Date of Birth") <= Today then
                            InsuranceFee := 0 else
                            InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 1000)) / 2));

                        case LoansR."Repayment Frequency" of
                            LoansR."Repayment Frequency"::Daily:
                                RunDate := CalcDate('-1D', RunDate);
                            LoansR."Repayment Frequency"::Weekly:
                                RunDate := CalcDate('-1W', RunDate);
                            LoansR."Repayment Frequency"::Monthly:
                                RunDate := CalcDate('-1M', RunDate);
                            LoansR."Repayment Frequency"::Quarterly:
                                RunDate := CalcDate('-1Q', RunDate);
                            LoansR."Repayment Frequency"::Yearly:
                                RunDate := CalcDate('-1Y', RunDate);
                        end;
                        repeat

                            InstalNo := InstalNo + 1;
                            case LoansR."Repayment Frequency" of
                                LoansR."Repayment Frequency"::Daily:
                                    RunDate := CalcDate('1D', RunDate);
                                LoansR."Repayment Frequency"::Weekly:
                                    RunDate := CalcDate('1W', RunDate);
                                LoansR."Repayment Frequency"::Monthly:
                                    RunDate := CalcDate('1M', RunDate);
                                LoansR."Repayment Frequency"::Quarterly:
                                    RunDate := CalcDate('1Q', RunDate);
                                LoansR."Repayment Frequency"::Yearly:
                                    RunDate := CalcDate('1Y', RunDate);
                            end;

                            SharesDeposit := (SharesDeposit + SharesBanding);
                            LoansR.TestField(Installments);

                            case LoansR."Interest Calculation Method" of
                                LoansR."Interest Calculation Method"::Amortised:
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount));
                                        LInterest := Round((LBalance * InterestRate / 12 / 100), 1, '=');
                                        LPrincipal := (TotalMRepay - LInterest);
                                        AccInt := RegMgt.getaccruedLoanInterest(LoansR."No.", LoansR."Disbursement Date");
                                    end;
                                LoansR."Interest Calculation Method"::"Straight Line":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');
                                        TopUpFee := SettlementFee;
                                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');

                                    end;
                                LoansR."Interest Calculation Method"::"Reducing Balance":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := LoanAmount / RepayPeriod;
                                        LInterest := (InterestRate / 12 / 100) * LBalance;
                                    end;

                                LoansR."Interest Calculation Method"::"Reducing Flat":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                                        InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 100)) / 2));
                                        LInterest := Round((LoansR."Approved Amount" * 0.6) * (LoansR.Installments + 1) / (LoansR.Installments * 100), 1, '=');
                                    end;
                                LoansR."Interest Calculation Method"::"Zero Interest":
                                    begin
                                        LPrincipal := LoanAmount / RepayPeriod;

                                    end
                            end;

                            if GrInterest > 0 then
                                LInterest := 0;
                            GrPrinciple := GrPrinciple - 1;
                            GrInterest := GrInterest - 1;
                            Evaluate(RepayCode, Format(InstalNo));
                            if InstalNo = LoansR.Installments then
                                Principal := LBalance else
                                Principal := LPrincipal;

                            RegMgt.ScheduledRepayDetail(LoansR."No.", RepayCode,
                            RunDate, InstalNo, LoansR."Interest Rate", Principal,
                            LInterest, 0, (LInterest + Principal + InsuranceFee),
                            LBalance, SharesBanding, SharesDeposit, InsuranceFee, TopUpFee, 1);
                            LBalance := Round(LBalance - LPrincipal);
                        until InstalNo = LoansR.Installments;
                    end;
                    case PostInt of
                        1:
                            begin
                                Commit;
                                Varvariant := LoansR;
                                DocMngt.DocPrintRepayschedule(Varvariant, 1);
                            end;
                    end
                end;
            true:
                begin
                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin
                        Varvariant := LoansR;
                        DocMngt.DocPrintRepayschedule(Varvariant, 1);
                    end
                end;
        end
    end;

    procedure GenerateRepaymentSchedule(Post: Boolean; LoanNo: Code[20]; PostInt: Integer)
    var
        RSchedule: Record "Loan Repayment Schedule";
        LoansR: Record "Loan Application";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        InitialInstal: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        Varvariant: Variant;
        Principal: Decimal;
        GrInterest: Decimal;
        GrPrinciple: Decimal;
        RepayCode: Code[10];
        LoanApp: Record "Loan Application";
        AccInt: Decimal;
        StartMonth: Date;
        EndMonthDate: Date;
        CheckoffDate: Date;
        MidCheckDate: Date;
        IntDays: Integer;
        LSchedule: Record "Loan Repayment Schedule";
        SharesDeposit: Decimal;
        SharesBanding: Decimal;
        InsuranceFee: Decimal;
        FactProd: Record "Product Factory";
        SettlementFee: Decimal;
        TopUpFacility: Record "Loans Top up";
        TotalTopup: Decimal;
        TopUpFee: Decimal;
        CustRec: Record Member;

    begin

        GeneralSetUp.Get();
        GeneralSetUp.TestField("Checkoff Cutoff Days");
        GeneralSetUp.TestField("Max. Member Age");
        case Post of
            false:
                begin
                    RSchedule.Reset;
                    RSchedule.SetRange("No.", LoanNo);
                    RSchedule.DeleteAll;

                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin

                        FactProd.Get(LoansR."Product Type");

                        LoansR.CalcFields("Total TopUp");
                        LoansR.TestField("Disbursement Date");
                        LoansR.TestField("Repayment Start Date");
                        IntDays := 0;

                        StartMonth := CalcDate('-CM', LoansR."Disbursement Date");
                        EndMonthDate := CalcDate('CM', LoansR."Disbursement Date");
                        MidCheckDate := CalcDate(GeneralSetUp."Checkoff Cutoff Days", StartMonth);

                        if LoansR."Disbursement Date" >= MidCheckDate then
                            IntDays := StartMonth - EndMonthDate else
                            IntDays := 0;
                        LoanAmount := LoansR."Approved Amount";
                        InterestRate := LoansR."Interest Rate";
                        RepayPeriod := LoansR.Installments;
                        InitialInstal := LoansR.Installments;
                        LBalance := LoansR."Approved Amount";
                        RunDate := LoansR."Repayment Start Date";
                        SharesBanding := LoansR."Shares Banding";
                        SharesDeposit := LoansR."Shares Deposit";
                        InstalNo := 0;
                        InsuranceFee := 0;
                        TopUpFee := 0;

                        if CustRec.Get(LoansR."Account No.") then
                            CustRec.TestField("Date of Birth");
                        if CalcDate(GeneralSetUp."Max. Member Age", CustRec."Date of Birth") <= Today then
                            InsuranceFee := 0 else
                            InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 1000)) / 2));

                        case LoansR."Repayment Frequency" of
                            LoansR."Repayment Frequency"::Daily:
                                RunDate := CalcDate('-1D', RunDate);
                            LoansR."Repayment Frequency"::Weekly:
                                RunDate := CalcDate('-1W', RunDate);
                            LoansR."Repayment Frequency"::Monthly:
                                RunDate := CalcDate('-1M', RunDate);
                            LoansR."Repayment Frequency"::Quarterly:
                                RunDate := CalcDate('-1Q', RunDate);
                            LoansR."Repayment Frequency"::Yearly:
                                RunDate := CalcDate('-1Y', RunDate);
                        end;
                        repeat

                            InstalNo := InstalNo + 1;
                            case LoansR."Repayment Frequency" of
                                LoansR."Repayment Frequency"::Daily:
                                    RunDate := CalcDate('1D', RunDate);
                                LoansR."Repayment Frequency"::Weekly:
                                    RunDate := CalcDate('1W', RunDate);
                                LoansR."Repayment Frequency"::Monthly:
                                    RunDate := CalcDate('1M', RunDate);
                                LoansR."Repayment Frequency"::Quarterly:
                                    RunDate := CalcDate('1Q', RunDate);
                                LoansR."Repayment Frequency"::Yearly:
                                    RunDate := CalcDate('1Y', RunDate);
                            end;

                            SharesDeposit := (SharesDeposit + SharesBanding);

                            LoansR.TestField(Installments);

                            case LoansR."Interest Calculation Method" of
                                LoansR."Interest Calculation Method"::Amortised:
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount));
                                        LInterest := Round((LBalance * InterestRate / 12 / 100), 1, '=');
                                        LPrincipal := (TotalMRepay - LInterest);
                                        AccInt := RegMgt.getaccruedLoanInterest(LoansR."No.", LoansR."Disbursement Date");
                                    end;
                                LoansR."Interest Calculation Method"::"Straight Line":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');
                                        TopUpFee := SettlementFee;
                                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');

                                    end;
                                LoansR."Interest Calculation Method"::"Reducing Balance":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := LoanAmount / RepayPeriod;
                                        LInterest := (InterestRate / 12 / 100) * LBalance;
                                    end;

                                LoansR."Interest Calculation Method"::"Reducing Flat":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                                        InsuranceFee := Round(((LoanAmount * (FactProd."Insurance Fee" / 100)) / 2));
                                        LInterest := Round((LoansR."Approved Amount" * 0.6) * (LoansR.Installments + 1) / (LoansR.Installments * 100), 1, '=');
                                    end;
                                LoansR."Interest Calculation Method"::"Zero Interest":
                                    begin
                                        LPrincipal := LoanAmount / RepayPeriod;

                                    end
                            end;

                            if GrInterest > 0 then
                                LInterest := 0;
                            GrPrinciple := GrPrinciple - 1;
                            GrInterest := GrInterest - 1;
                            Evaluate(RepayCode, Format(InstalNo));

                            if InstalNo = LoansR.Installments then
                                Principal := LBalance else
                                Principal := LPrincipal;

                            RegMgt.ScheduledRepayDetail(LoansR."No.", RepayCode,
                            RunDate, InstalNo, LoansR."Interest Rate", Principal,
                            LInterest, 0, (LInterest + Principal + InsuranceFee),
                            LBalance, SharesBanding, SharesDeposit, InsuranceFee, TopUpFee, 0);
                            LBalance := Round(LBalance - LPrincipal);
                        until InstalNo = LoansR.Installments;
                    end;
                    case PostInt of
                        1:
                            begin
                                if LoanApp.Get(LoansR."No.") then begin
                                    case LoanApp."Charge Interest on Posting" of
                                        LoanApp."Charge Interest on Posting"::"Full Interest":
                                            LoanApp."Interest Repayment" := CalcInterestDueOnPost(1, LoanApp."No.")
                                    end;
                                    LoanApp.Modify
                                end;
                                Commit;
                                Varvariant := LoansR;
                                DocMngt.DocPrintRepayschedule(Varvariant, 1);
                            end;
                    end
                end;
            true:
                begin
                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin
                        Varvariant := LoansR;
                        DocMngt.DocPrintRepayschedule(Varvariant, 1);
                    end
                end;
        end
    end;

    local procedure InitLoanCategoryEntry(RecRef: Record Loans; var LoanRecordEntry: Record "Loans Categorization"; LoanNo: Code[20])
    begin
        LoanRecordEntry.Init;
        LoanRecordEntry.CopyFromLoanApplicationLine(RecRef);
        LoanRecordEntry."No." := LoanNo;
        OnAfterInitLoanCategoryEntry(LoanRecordEntry, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanCategoryEntry(var LoanEntry: Record "Loans Categorization"; Applic: Record Loans)
    begin
    end;


    procedure PostLoanAcc(LoanApplication: Record "Loan Application"): Code[50]
    var
        RecRef: Record "Loan Application";
        LoanRecEntry: Record Loans;
        LoanNo: Code[20];
    begin
        RecRef.Get(LoanApplication."No.");
        if RecRef."Application Type" <> RecRef."Application Type"::Mobile then begin
            RecRef.CheckMinRequirement;
        end;

        LoanRecEntry.LockTable;
        InitLoanEntry(RecRef, LoanRecEntry);
        LoanRecEntry."Application No." := RecRef."No.";
        LoanRecEntry."Application Date" := RecRef."Application Date";
        LoanRecEntry."Disbursement Date" := RecRef."Disbursement Date";
        LoanRecEntry."Repayment Start Date" := RecRef."Repayment Start Date";
        LoanRecEntry."Expected Date of Completion" := RecRef."Expected Date of Completion";
        LoanRecEntry."Post Application As" := RecRef."Post Application As";
        LoanRecEntry.Validate("Account No.", RecRef."Account No.");
        LoanRecEntry."Application No." := RecRef."No.";
        LoanRecEntry."Account Dimension" := RecRef."Account Dimension";
        LoanRecEntry."Product Type" := RecRef."Product Type";
        LoanRecEntry."Interest Rate" := RecRef."Interest Rate";
        LoanRecEntry.Installments := RecRef.Installments;
        LoanRecEntry."Requested Amount" := RecRef."Requested Amount";
        LoanRecEntry."Approved Amount" := RecRef."Approved Amount";
        LoanRecEntry.Repayment := RecRef.Repayment;
        LoanRecEntry."Interest Repayment" := RecRef."Interest Repayment";
        LoanRecEntry."Principle Repayment" := RecRef."Principle Repayment";
        LoanRecEntry."Batch No." := RecRef."Batch No.";
        LoanRecEntry."Loan Account" := RecRef."Loan Account";
        LoanRecEntry."Disbursement Account No." := RecRef."Disbursement Account No.";
        LoanRecEntry."Charge Interest on Posting" := RecRef."Charge Interest on Posting";
        LoanRecEntry.Repayment := RecRef.Repayment;
        LoanRecEntry."Mode of Disbursement" := RecRef."Mode of Disbursement";
        LoanRecEntry."Recovery Mode" := RecRef."Recovery Mode";
        LoanRecEntry."Repayment Mode" := RecRef."Repayment Mode";
        LoanRecEntry."Captured By" := RecRef."Captured By";
        LoanRecEntry."Recovery No." := RecRef."Recovery Header No.";
        LoanRecEntry."Interest Calculation Method" := RecRef."Interest Calculation Method";
        LoanRecEntry.Insert(true);

        LoanNo := LoanRecEntry."No.";
        if LoanNo <> '' then begin
            CreateLoancategory(LoanRecEntry);
            fncreateRepayschedule(false, LoanRecEntry."No.", 0);
            Commit();

            MonthCont.LockTable();
            RegMgt.CreateMonthlyDeduct(LoanRecEntry."Account No.",
            LoanRecEntry."No.", AcCatType::" ", LoanRecEntry.Repayment,
            'Loan Repayment', AdviceType::"New Loan");
        end;
        exit(LoanNo);
    end;

    procedure CreateQCLoans(LoanApplication: Record Loans; TransType: Enum "LoanTransactionType")
    var
        RecRef: Record Loans;
        LoanRecEntry: Record "Loans (Procedure)";
        TellMngt: Codeunit "Teller-Post (Yes/No)";
        AccBanking: Record "Account Banking";
        LoanNo: Code[20];
    begin
        RecRef.Get(LoanApplication."No.");
        LoanRecEntry.LockTable;
        InitQCLoanEntry(RecRef, LoanRecEntry, RecRef."No.");
        LoanRecEntry."Application No." := RecRef."No.";
        LoanRecEntry."Post Application As" := RecRef."Post Application As";
        LoanRecEntry.Validate("Account No.", RecRef."Account No.");
        LoanRecEntry."Application Date" := RecRef."Application Date";
        LoanRecEntry."Application No." := RecRef."No.";
        LoanRecEntry.Validate("Product Type", RecRef."Product Type");
        LoanRecEntry.Validate("Requested Amount", RecRef."Requested Amount");
        LoanRecEntry.Validate("Approved Amount", RecRef."Approved Amount");
        LoanRecEntry."Batch No." := RecRef."Batch No.";
        LoanRecEntry."Loan Account" := RecRef."Loan Account";
        LoanRecEntry."Disbursement Account No." := RecRef."Disbursement Account No.";
        LoanRecEntry."Charge Interest on Posting" := RecRef."Charge Interest on Posting";
        LoanRecEntry.Installments := RecRef.Installments;
        LoanRecEntry.Repayment := RecRef.Repayment;
        if AccBanking.Get(RecRef."Disbursement Account No.") then
            LoanRecEntry."Available Balance" := TellMngt.CalcAvailableBal(AccBanking."No.");
        LoanRecEntry."Transaction Type" := TransType;
        LoanRecEntry.Insert(true);
        LoanNo := LoanRecEntry."No.";
    end;

    procedure fnFetchSalaryDetails(AccountNo: Code[20]; LoanNo: Code[20])
    var
        AppraisalDetailsSetup: Record "Appraisal Salary Set-up";
        AppraisalSalDetails: Record "Appraisal Salary Details";
        AppraisalSalaryDetails: Record "Appraisal Salary Details";
        LoanApplication: Record "Loan Application";
    begin

        AppraisalSalDetails.Reset;
        AppraisalSalDetails.SetRange("Loan Application No.", LoanNo);
        AppraisalSalDetails.SetRange("Client Code", AccountNo);
        if AppraisalSalDetails.Find('-') then begin
            PAGE.Run(PAGE::"Appraisal Salary Details", AppraisalSalDetails,
                  AppraisalSalDetails."Loan Application No.");
            exit
        end
        else begin
            AppraisalDetailsSetup.Reset;
            if AppraisalDetailsSetup.Find('-') then begin
                repeat
                    AppraisalSalaryDetails.Reset;
                    AppraisalSalaryDetails.SetRange("Client Code", AccountNo);
                    AppraisalSalaryDetails.SetRange(Type, AppraisalDetailsSetup.Type);
                    AppraisalSalaryDetails.SetRange(Code, AppraisalDetailsSetup.Code);
                    if AppraisalSalaryDetails.Find('-') then begin
                        AppraisalSalDetails.Init;
                        AppraisalSalDetails."Loan Application No." := LoanNo;
                        AppraisalSalDetails."Client Code" := AccountNo;
                        AppraisalSalDetails."No." := LoanNo;
                        AppraisalSalDetails.Amount := AppraisalSalaryDetails.Amount;
                        AppraisalSalDetails.Code := AppraisalDetailsSetup.Code;
                        AppraisalSalDetails.Description := AppraisalDetailsSetup.Description;
                        AppraisalSalDetails.Type := AppraisalDetailsSetup.Type;
                        AppraisalSalDetails."Auto Computed" := AppraisalDetailsSetup."Auto Computed";
                        AppraisalSalDetails.Insert(true);
                    end else begin
                        AppraisalSalDetails.Init;
                        AppraisalSalDetails."Loan Application No." := LoanNo;
                        AppraisalSalDetails."Client Code" := AccountNo;
                        AppraisalSalDetails."No." := LoanNo;
                        AppraisalSalDetails.Code := AppraisalDetailsSetup.Code;
                        AppraisalSalDetails.Description := AppraisalDetailsSetup.Description;
                        AppraisalSalDetails.Type := AppraisalDetailsSetup.Type;
                        AppraisalSalDetails."Auto Computed" := AppraisalDetailsSetup."Auto Computed";
                        AppraisalSalDetails.Insert(true);
                    end;
                until AppraisalDetailsSetup.Next = 0;
            end;
            Commit;
            AppraisalSalDetails.Reset;
            AppraisalSalDetails.SetRange("Loan Application No.", LoanNo);
            AppraisalSalDetails.SetRange("Client Code", AccountNo);
            if AppraisalSalDetails.Find('-') then begin
                PAGE.Run(PAGE::"Appraisal Salary Details", AppraisalSalDetails,
                      AppraisalSalDetails."Loan Application No.");
            end;
        end
    end;

    procedure CreditTopUp(AccountNo: Code[20]; LoanNo: Code[20]; ProdCode: Code[20])
    var
        LoansTopup: array[2] of Record "Loans Top up";
    begin
        LoansTopup[1].Reset;
        LoansTopup[1].SetRange("No.", LoanNo);
        LoansTopup[1].SetRange("Account No.", AccountNo);
        if LoansTopup[1].FindFirst then begin
            PAGE.Run(PAGE::"Loan Top Up", LoansTopup[1], LoansTopup[1]."No.");
            exit
        end else begin
            LoansTopup[2].Init;
            LoansTopup[2]."No." := LoanNo;
            LoansTopup[2]."Account No." := AccountNo;
            LoansTopup[2].Insert(true);
            LoansTopup[2].Reset;
            LoansTopup[2].SetRange("No.", LoanNo);
            LoansTopup[2].SetRange("Account No.", AccountNo);
            if LoansTopup[2].FindFirst then
                PAGE.Run(PAGE::"Loan Top Up", LoansTopup[2], LoansTopup[2]."No.");
        end
    end;

    procedure CalcInterestDueOnPost(PostInt: Integer; LoanNo: Code[20]): Decimal
    var
        LoanRepaySchedule: Record "Loan Repayment Schedule";
        Amt: Decimal;
        LoanApplic: Record "Loan Application";
    begin
        case PostInt of
            1:
                begin
                    LoanRepaySchedule.Reset;
                    LoanRepaySchedule.SetRange("No.", LoanNo);
                    if LoanRepaySchedule.FindSet then begin
                        LoanRepaySchedule.CalcSums("Monthly Interest");
                        Amt := LoanRepaySchedule."Monthly Interest";
                    end;
                end;
            2:
                begin
                    LoanApplic.Reset();
                    LoanApplic.SetRange("No.", LoanNo);
                    if LoanApplic.FindFirst() then begin
                        Amt := RegMgt.getaccruedLoanInterest(LoanApplic."No.", Today)
                    end;
                end;
        end;
        exit(Amt)
    end;

    procedure fncreateRepayschedule(Post: Boolean; LoanNo: Code[20]; PostInt: Integer)
    var
        RSchedule: Record "Repayment Schedule";
        LoansR: Record Loans;
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        InitialInstal: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        Varvariant: Variant;
        Principal: Decimal;
        GrInterest: Decimal;
        GrPrinciple: Decimal;
        RepayCode: Code[10];
        LoanApp: Record Loans;
        CustRec: Record Member;
        FactProd: Record "Product Factory";
        InsuranceFee: Decimal;
        PartialSchedule: Record "Partial Disbursement Schedule";
    begin
        case Post of
            false:
                begin
                    GeneralSetUp.Get();
                    GeneralSetUp.TestField("Max. Member Age");

                    RSchedule.Reset;
                    RSchedule.SetRange("No.", LoanNo);
                    RSchedule.DeleteAll;

                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin

                        LoansR.TestField("Disbursement Date");
                        LoansR.TestField("Repayment Start Date");
                        InterestRate := LoansR."Interest Rate";
                        RepayPeriod := LoansR.Installments;
                        InitialInstal := LoansR.Installments;
                        LBalance := LoansR."Approved Amount";
                        LoanAmount := LoansR."Approved Amount";

                        if FactProd.Get(LoansR."Product Type") then
                            InsuranceFee := 0;

                        Case LoansR."Interest Calculation Method" of
                            LoansR."Interest Calculation Method"::"Zero Interest":
                                begin
                                    InsuranceFee := 0
                                end;
                        end;

                        RunDate := LoansR."Repayment Start Date";
                        InstalNo := 0;

                        case LoansR."Repayment Frequency" of
                            LoansR."Repayment Frequency"::Daily:
                                RunDate := CalcDate('-1D', RunDate);
                            LoansR."Repayment Frequency"::Weekly:
                                RunDate := CalcDate('-1W', RunDate);
                            LoansR."Repayment Frequency"::Monthly:
                                RunDate := CalcDate('-1M', RunDate);
                            LoansR."Repayment Frequency"::Quarterly:
                                RunDate := CalcDate('-1Q', RunDate);
                            LoansR."Repayment Frequency"::Yearly:
                                RunDate := CalcDate('-1Y', RunDate);
                        end;
                        repeat

                            InstalNo := InstalNo + 1;
                            case LoansR."Repayment Frequency" of
                                LoansR."Repayment Frequency"::Daily:
                                    RunDate := CalcDate('1D', RunDate);
                                LoansR."Repayment Frequency"::Weekly:
                                    RunDate := CalcDate('1W', RunDate);
                                LoansR."Repayment Frequency"::Monthly:
                                    RunDate := CalcDate('1M', RunDate);
                                LoansR."Repayment Frequency"::Quarterly:
                                    RunDate := CalcDate('1Q', RunDate);
                                LoansR."Repayment Frequency"::Yearly:
                                    RunDate := CalcDate('1Y', RunDate);
                            end;

                            LoansR.TestField(Installments);

                            case LoansR."Interest Calculation Method" of
                                LoansR."Interest Calculation Method"::Amortised:
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        TotalMRepay := Round((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 1, '>');
                                        LInterest := Round(LBalance * InterestRate / 12 / 100, 0.01, '=');
                                        LPrincipal := (TotalMRepay - LInterest);
                                    end;
                                LoansR."Interest Calculation Method"::"Straight Line":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1, '=');
                                        LInterest := Round((InterestRate / 12 / 100) * LoanAmount, 1, '=');
                                    end;
                                LoansR."Interest Calculation Method"::"Reducing Balance":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := LoanAmount / RepayPeriod;
                                        LInterest := (InterestRate / 12 / 100) * LBalance;
                                    end;
                                LoansR."Interest Calculation Method"::"Reducing Flat":
                                    begin
                                        LoansR.TestField("Interest Rate");
                                        LPrincipal := Round(LoanAmount / RepayPeriod, 1.0, '>');
                                        LInterest := Round((LoansR."Approved Amount" * 0.6) * (LoansR.Installments + 1) / (LoansR.Installments * 100), 1, '=');
                                    end;
                                LoansR."Interest Calculation Method"::"Zero Interest":
                                    begin
                                        LPrincipal := LoanAmount / RepayPeriod;
                                    end
                            end;

                            if GrInterest > 0 then
                                LInterest := 0;
                            GrPrinciple := GrPrinciple - 1;
                            GrInterest := GrInterest - 1;
                            Evaluate(RepayCode, Format(InstalNo));

                            if InstalNo = LoansR.Installments then
                                Principal := LBalance else
                                Principal := LPrincipal;
                            RegMgt.ScheduledLoanRepayDetail(LoansR."No.", RepayCode, RunDate, InstalNo,
                            LoansR."Interest Rate", Principal, LInterest, InsuranceFee, (LInterest + Principal + InsuranceFee), LBalance);
                            LBalance := Round(LBalance - LPrincipal);
                        until InstalNo = LoansR.Installments;
                    end;
                    case PostInt of
                        1:
                            begin
                                Varvariant := LoansR;
                                DocMngt.DocPrintRepayschedule(Varvariant, 1);
                            end;
                        2:
                            begin
                                Commit();
                                DocMngt.DocPrintLoanRepayschedule(0, LoansR."No.");
                            end;
                    end
                end;
            true:
                begin
                    LoansR.Reset;
                    LoansR.SetRange("No.", LoanNo);
                    if LoansR.Find('-') then begin
                        Varvariant := LoansR;
                        DocMngt.DocPrintRepayschedule(Varvariant, 1);
                    end
                end;
        end
    end;


    procedure CreateLoancategory(LoanApplication: Record Loans)
    var
        RecRef: Record Loans;
        LoanRecEntry: Record "Loans Categorization";
    begin
        RecRef.Reset();
        RecRef.SetRange("No.", LoanApplication."No.");
        if RecRef.FindFirst() then begin

            LoanRecEntry.LockTable;
            InitLoanCategoryEntry(RecRef, LoanRecEntry, RecRef."No.");
            LoanRecEntry."Application No." := RecRef."Application No.";
            LoanRecEntry.Validate("Account No.", RecRef."Account No.");
            LoanRecEntry."Application Date" := RecRef."Application Date";
            LoanRecEntry."Disbursement Date" := RecRef."Disbursement Date";
            LoanRecEntry."Product Type" := RecRef."Product Type";
            LoanRecEntry."Requested Amount" := RecRef."Requested Amount";
            LoanRecEntry."Approved Amount" := RecRef."Approved Amount";
            LoanRecEntry."Batch No." := RecRef."Batch No.";
            LoanRecEntry.Repayment := RecRef.Repayment;
            LoanRecEntry."Loan Account" := RecRef."Loan Account";
            LoanRecEntry."Disbursement Account No." := RecRef."Disbursement Account No.";
            LoanRecEntry.Insert(true);
        end;
    end;


    procedure ConfirmPost(CheckHeader: Record "Checkoff Header"): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Member No.,&ID/Passport No.,Payroll No.,&Repayment A/c';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 4 then
            DefaultOption := 4;
        if DefaultOption <= 0 then
            DefaultOption := 1;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to validate lines');
        PassInt := Selection;
        if Selection = 0 then
            exit;
        exit(PassInt);
    end;


    procedure NoOfGuarantor(AcNo: Code[20]): Integer
    var
        GuarantorSecurity: Record "Guarantor & Security Posted";
        NoOfGuarant: Integer;
    begin
        GuarantorSecurity.Reset;
        GuarantorSecurity.SetRange("Account No.", AcNo);
        if GuarantorSecurity.FindSet then begin
            NoOfGuarant := GuarantorSecurity.Count;
            exit(NoOfGuarant);
        end
    end;

    procedure PostLoanEntries(LoanNo: Code[50]; LineNo: Integer; RunBal: Decimal; JTemplate: Code[10]; JBatch: Code[10]; Dim1: Code[10]; Dim2: Code[10]; DocNo: Code[20]; AccNo: Code[100]; LineAmt: Decimal)
    var
        LoanApps: Record Loans;
        InitGenPost: Codeunit "Initialize Gen. Jnl.-Post";
        GenJournaline: Record "Gen. Journal Line";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        PostType: Enum "LoanTransactionType";
        LoanRep: Decimal;
        Journaline: Record "Gen. Journal Line";
        AccCredit: Record "Account Credit";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        PostAmt: Decimal;
    begin
        LoanApps.Reset();
        LoanApps.SetRange(LoanApps."No.", LoanNo);
        LoanApps.SetFilter("Outstanding Balance", '>0');
        IF LoanApps.Find('-') then begin

            LoanApps.CalcFields(LoanApps."Outstanding Interest",
            LoanApps."Outstanding Balance", "Outstanding Principal");
            if LoanApps."Outstanding Interest" > 0 then begin

                PostAmt := 0;
                if LineAmt > LoanApps."Outstanding Interest" then
                    PostAmt := LoanApps."Outstanding Interest" else
                    PostAmt := LineAmt;

                GenJournaline.LockTable();
                LineNo := LineNo + 10000;
                InitializeEntry(GenJournaline, LineNo,
                JTemplate, JBatch, DocNo, '', Today, Dim1, Dim2);
                GenJournaline.Description := CopyStr(DocNo + '-' + format(PostType::"Interest Paid") +
                '-' + LoanApps."No.", 1, 50);
                GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                GenJournaline.Validate("Account No.", AccNo);
                if RunBal > PostAmt then
                    GenJournaline.Validate(Amount, PostAmt) else
                    GenJournaline.Validate(Amount, RunBal);
                if GenJournaline.Amount <> 0 then
                    GenJournaline.Insert(true);


                GenJournaline.LockTable();
                LineNo := LineNo + 10000;
                InitGenPost.InitializeCreditEntry(GenJournaline, LineNo,
                JTemplate, JBatch, DocNo, LoanApps."Currency Code",
                LoanApps."Disbursement Date", Dim1, Dim2, LoanApps."No.",
                PostType::"Interest Paid");
                GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                GenJournaline.Validate("Account No.", LoanApps."Loan Account");
                if RunBal > PostAmt then
                    GenJournaline.Validate(Amount, PostAmt * -1) else
                    GenJournaline.Validate(Amount, RunBal * -1);
                Genjournaline.Validate("Loan No.", Loanapps."No.");
                GenJournaline."Transaction Type" := GenJournaline."Transaction Type"::"Interest Paid";
                GenJournaline.Description := CopyStr(DocNo + '-' + Format(GenJournaline."Transaction Type") + '-' + LoanApps."No.", 1, 50);
                if GenJournaline.Amount <> 0 then
                    GenJournaline.Insert(true);
                RunBal := RunBal - Abs(GenJournaline.Amount);
            end;

            if RunBal > 0 then begin

                if LoanApps."Outstanding Principal" > 0 then begin
                    PostAmt := 0;
                    if LineAmt > LoanApps."Outstanding Principal" then
                        PostAmt := LoanApps."Outstanding Principal" else
                        PostAmt := LineAmt;

                    GenJournaline.LockTable();
                    LineNo := LineNo + 10000;
                    InitializeEntry(GenJournaline, LineNo,
                    JTemplate, JBatch, DocNo, '', Today, Dim1, Dim2);
                    GenJournaline.Description := CopyStr(DocNo + '-' + format(PostType::Repayment) +
                    '-' + LoanApps."No.", 1, 50);
                    GenJournaline."Account Type" := GenJournaline."Account Type"::Vendor;
                    GenJournaline.Validate("Account No.", AccNo);
                    if RunBal > PostAmt then
                        GenJournaline.Validate(Amount, PostAmt) else
                        GenJournaline.Validate(Amount, RunBal);
                    if GenJournaline.Amount <> 0 then
                        GenJournaline.Insert(true);


                    GenJournaline.LockTable();
                    LineNo := LineNo + 10000;

                    InitGenPost.InitializeCreditEntry(GenJournaline, LineNo,
                    JTemplate, JBatch, DocNo, LoanApps."Currency Code",
                    LoanApps."Disbursement Date", Dim1, Dim2, LoanApps."No.",
                    PostType::"Interest Paid");
                    GenJournaline."Account Type" := GenJournaline."Account Type"::Customer;
                    GenJournaline.Validate("Account No.", LoanApps."Loan Account");
                    if RunBal > PostAmt then
                        GenJournaline.Validate(Amount, PostAmt * -1) else
                        GenJournaline.Validate(Amount, RunBal * -1);
                    Genjournaline.Validate("Loan No.", LoanApps."No.");
                    GenJournaline."Transaction Type" := GenJournaline."Transaction Type"::Repayment;
                    GenJournaline.Description := CopyStr(DocNo + '-' + Format(GenJournaline."Transaction Type") + '-' + LoanApps."No.", 1, 50);
                    GenJournaline.Validate("Shortcut Dimension 1 Code", Dim1);
                    GenJournaline.Validate("Shortcut Dimension 2 Code", Dim2);
                    if GenJournaline.Amount <> 0 then
                        GenJournaline.Insert(true);
                    RunBal := RunBal - Abs(GenJournaline.Amount);
                end;
            end
        end
    end;

    procedure CreateLoanSharesBanding(AcNo: Code[100]; LoanNo: Code[50]) ApprvlAmt: Decimal
    var
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        TempAmt: Decimal;
        ShareBanding: Record "Shares Banding";
        BandingShare: Decimal;
    begin

        PostedLoan.Reset();
        PostedLoan.SetCurrentKey("Approved Amount");
        PostedLoan.Ascending(false);
        PostedLoan.SetFilter("Outstanding Balance", '>0');
        PostedLoan.SetRange("Account No.", AcNo);
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
        end;
        ApprvlAmt := TempAmt;


        PostedLoan.Reset();
        PostedLoan.SetRange("No.", LoanNo);
        if PostedLoan.Find('-') then begin

            ShareBanding.Reset();
            if ShareBanding.Find('-') then begin
                repeat
                    if (PostedLoan."Approved Amount" >= ShareBanding.Minimum) and (PostedLoan."Approved Amount" <= ShareBanding.Maximum) then begin
                        BandingShare := ShareBanding."Shares Amount";
                    end;
                until ShareBanding.Next() = 0
            end;
        end;
        if BandingShare >= ApprvlAmt then
            ApprvlAmt := BandingShare else
            ApprvlAmt := ApprvlAmt;
        exit(ApprvlAmt)
    end;

    procedure getSaccoLoanDeduction(AcNo: Code[100]) ApprvlAmt: Decimal
    var
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        TempAmt: Decimal;
        ShareBanding: Record "Shares Banding";
        BandingShare: Decimal;
    begin
        PostedLoan.Reset();
        PostedLoan.SetRange("Account No.", AcNo);
        PostedLoan.SetFilter("Outstanding Balance", '>0');
        if PostedLoan.Find('-') then begin
            PostedLoan.TestField(Repayment);
            PostedLoan.CalcFields("Outstanding Balance");
            PostedLoan.CalcSums(Repayment);
            ApprvlAmt := PostedLoan.Repayment;
        end;
        exit(ApprvlAmt);
    end;

    procedure getBridgeReleaseAmt(AcNo: Code[100]) ApprvlAmt: Decimal
    var
        PostedLoan: Record "Loan Application";
        PostedAmt: Decimal;
        TempAmt: Decimal;
        ShareBanding: Record "Shares Banding";
        BandingShare: Decimal;
    begin
        PostedLoan.Reset();
        PostedLoan.SetRange("No.", AcNo);
        if PostedLoan.Find('-') then begin
            PostedLoan.CalcFields("Total TopUp");
            ApprvlAmt := PostedLoan."Total TopUp";
        end;
        exit(ApprvlAmt);
    end;

    procedure UpdateChangesOnGuarantorLine(RecordNo: Code[50]; GuarantorNo: Code[100])
    var
        Lguarantx: Record "Guarantor & Security Posted";
        Lguarant: Record "Guarantor & Security Posted";
        RegMgnt: Codeunit "Register Management";
        RecRef: Record "Guarantors Substitution";
    begin

        Lguarantx.Reset();
        Lguarantx.SetRange("Loan No.", RecordNo);
        Lguarantx.SetRange("Account No.", GuarantorNo);
        if Lguarantx.Find('-') then begin
            Lguarantx.Substituted := TRUE;
            Lguarantx.Modify(true);
        end;
    end;

    procedure UpdateChangesOnEftLine(RecordNo: Code[50]; ExtCommitNo: Code[100])
    var
        RegMgnt: Codeunit "Register Management";
        RecRef: Record "EFT Transfer Lines";
        ExternalCommitment: Record "Other Commitements Clearance";
    begin
        ExternalCommitment.Reset();
        ExternalCommitment.SetRange("Application No.", ExtCommitNo);
        ExternalCommitment.SetRange("Approval Status", ExternalCommitment."Approval Status"::Posted);
        if ExternalCommitment.FindSet() then begin
            repeat
                RecRef.Reset();
                RecRef.SetRange(No, RecordNo);
                RecRef.SetRange("External Committment No.", ExternalCommitment."Entry No.");
                if RecRef.FindFirst() then begin
                    RecRef."External Account Name" := ExternalCommitment."External Account Name";
                    RecRef.Modify(true)
                end;
            until ExternalCommitment.Next() = 0;
        end;
    end;

    procedure InitializeEntry(var RecRef: Record "Gen. Journal Line"; LineNo: Integer; JTemplate: Code[20]; JBatche: Code[20]; DocNo: Code[20]; CurrencyCode: Code[20]; TransactionDate: Date; Dimension1: Code[20]; Dimension2: Code[20])
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

    procedure CreateLoanApplication(MemberNo: Code[100]; ProductID: Code[10]; AmtToPost: Decimal; InstPeriod: Integer) Responce: Code[100]
    var
        PLoan: Record "Loan Application";
        Product: Record "Product Factory";
        LoanNo: Code[50];
        ApplicLoan: Record "Loan Application";
    begin

        PLoan.Init();
        PLoan."No." := '';
        PLoan."Application Source" := PLoan."Application Source"::Mobile;
        PLoan."Application Type" := PLoan."Application Type"::Mobile;
        PLoan."Appraisal Parameter Type" := PLoan."Appraisal Parameter Type"::Salary;
        PLoan."Disbursement Destination" := PLoan."Disbursement Destination"::"Banking Account";
        PLoan."Mode of Disbursement" := PLoan."Mode of Disbursement"::"Full Disbursement";
        PLoan."Application Date" := Today;
        PLoan.Remarks := 'Mobile Loan-' + PLoan."No.";
        PLoan."Captured By" := UserId;
        PLoan.Validate("Account No.", MemberNo);
        Product.Get(ProductID);
        PLoan.Validate("Product Type", ProductID);
        PLoan.Validate(Installments, InstPeriod);
        PLoan.Validate("Requested Amount", AmtToPost);
        PLoan.Validate("Disbursement Date", Today);
        PLoan."Approval Status" := PLoan."Approval Status"::Approved;
        PLoan."Loan Status" := PLoan."Loan Status"::Approved;
        PLoan.Insert(true);
        LoanNo := PLoan."No.";

        ApplicLoan.Reset();
        ApplicLoan.SetRange("No.", LoanNo);
        if ApplicLoan.FindFirst() then begin
            GenerateRepaymentSchedule(false, ApplicLoan."No.", 0);
            Responce := PostLoanAcc(ApplicLoan);
        end else begin
            Responce := '0| Failed';
        end;

    end;

    procedure fnCreateLoanApplication(MemberNo: Code[100]; ProductID: Code[10]; AmtToPost: Decimal; InstPeriod: Integer) Responce: Code[100]
    var
        PLoan: Record Loans;
        ProdFact: Record "Product Factory";
        LoanNo: Code[50];
        ApplicLoan: Record Loans;
        AccBanking: Record "Account Banking";
    begin

        PLoan.Init();
        PLoan."No." := '';
        PLoan."Application Source" := PLoan."Application Source"::Mobile;
        PLoan."Application Type" := PLoan."Application Type"::Mobile;
        PLoan."Application Date" := Today;

        PLoan.Remarks := 'Mobile Loan-' + PLoan."No.";
        PLoan."Captured By" := 'ADMIN';
        PLoan.Validate("Account No.", MemberNo);
        if ProdFact.Get(ProductID) then
            PLoan.Validate("Product Type", ProductID);
        PLoan.Validate(Installments, InstPeriod);
        PLoan.Validate("Requested Amount", AmtToPost);
        PLoan.Validate("Disbursement Date", Today);
        PLoan."Approval Status" := PLoan."Approval Status"::Approved;
        PLoan."Loan Status" := PLoan."Loan Status"::Approved;
        PLoan."Exclude From Related Balance" := ProdFact."Exclude Sacco Deduction";
        PLoan."Ignore Related Balance" := ProdFact."Ignore Related Balance";
        PLoan."Disbursement Destination" := PLoan."Disbursement Destination"::"Banking Account";

        AccBanking.Reset();
        AccBanking.SetRange("Member No.", MemberNo);
        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
        if AccBanking.FindFirst() then
            PLoan."Disbursement Account No." := AccBanking."No.";
        PLoan.Insert(true);
        LoanNo := PLoan."No.";

        ApplicLoan.Reset();
        ApplicLoan.SetRange("No.", LoanNo);
        if ApplicLoan.FindFirst() then begin
            if ApplicLoan."Disbursement Account No." = '' then begin
                AccBanking.Reset();
                AccBanking.SetRange("Member No.", ApplicLoan."Account No.");
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then
                    ApplicLoan."Disbursement Account No." := AccBanking."No.";
                ApplicLoan.Modify(true)
            end;
            fncreateRepayschedule(false, ApplicLoan."No.", 0);
            Responce := LoanNo;
        end else begin
            Responce := '0| Failed';
        end;
        exit(Responce)
    end;

    procedure ValuePost(RecNo: Code[100]; ModeOfDisbursement: Integer): Boolean
    var
        CreditLedger: Record "Cust. Ledger Entry";
        LoansT: Record Loans;
        OtherCommit: Record "Other Commitements Clearance";
        AccBanking: Record "Account Banking";
        LoanApplication: Record "Loan Application";
        LoanCategory: Record "Loans Categorization";
        MonthlyContrib: Record "Member Monthly Contribution";
        LoanApplic: Record "Loan Application";
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

                if LoansT."TopUp Loan" = '' then begin
                    LoansT.Validate("Disbursement Date", CreditLedger."Posting Date");
                    LoansT."Interest Posting Date" := CreditLedger."Posting Date";
                    LoansT."Loan Status" := LoansT."Loan Status"::Issued;
                    LoansT."Approval Status" := LoansT."Approval Status"::Posted;
                    if LoanApplication.Get(LoansT."Application No.") then
                        LoansT."Captured By" := LoanApplication."Captured By";
                    LoansT.Modify(true);

                    fncreateRepayschedule(false, LoansT."No.", 0);

                    if LoanCategory.Get(LoansT."No.") then begin
                        LoanCategory.Validate("Disbursement Date", CreditLedger."Posting Date");
                        LoanCategory.Modify(true);
                    end;
                end else begin
                    fncreateRepayschedule(false, LoansT."No.", 0);

                    LoanApplic.Reset();
                    LoanApplic.SetRange("TopUp Loan", LoansT."No.");
                    if LoanApplic.FindFirst() then begin
                        LoanApplic."Approval Status" := LoanApplic."Approval Status"::Posted;
                        LoanApplic."Loan Status" := LoanApplic."Loan Status"::Issued;
                        LoanApplic."Date Posted" := Today;
                        LoanApplic."Time Posted" := Time;
                        LoanApplic."Posted By" := UserId;
                        LoanApplic.Modify(true);
                    end;
                end;

                if LoansT."Application Type" = LoansT."Application Type"::Normal then begin
                    if AccBanking.Get(LoansT."Disbursement Account No.") then begin
                        AccBanking.CalcFields("Balance (LCY)");
                        case LoansT."Payment Mode" of
                            LoansT."Payment Mode"::EFT:
                                begin
                                    if LoansT."Mode of Disbursement" = LoansT."Mode of Disbursement"::"Full Disbursement" then
                                        BankMngt.PostLien(AccBanking, AccBanking."Balance (LCY)",
                                                   LoansT."Product Description", 1, LoansT."No.");
                                end;
                        end;
                    end;
                end;

                OtherCommit.Reset();
                OtherCommit.SetRange("Application No.", LoansT."Application No.");
                if OtherCommit.FindSet() then begin
                    OtherCommit.ModifyAll("Time Posted", Time);
                    OtherCommit.ModifyAll("Date Posted", Today);
                    OtherCommit.ModifyAll("Disbursement Date", Today);
                    OtherCommit.ModifyAll("Approval Status", OtherCommit."Approval Status"::Posted);
                end;

                if Member.Get(LoansT."Account No.") then begin
                    Member."Loan Status" := Member."Loan Status"::Active;
                    Member.Modify(true);
                    SmsNotification.CreateSmsNotif(NotifSource::"Loan Posted", Member."Mobile Phone No",
              'Dear member, Your Loan Application of KES ' + Format(LoansT."Approved Amount") + ' repayable in ' +
              format(LoansT.Installments) + ' at ' + Format(LoansT."Interest Rate") + ' P.A has been issued. Thank You', Member."No.",
                 Member."No.", false);
                end;
            end;
        end;
        exit(false)
    end;


}




