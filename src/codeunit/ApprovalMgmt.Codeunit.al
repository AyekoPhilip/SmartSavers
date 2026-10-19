codeunit 50049 "Approval Mgmt."
{
    Permissions = TableData "Approval Entries" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label '%1 %2 requires further approval.\\Approval request entries have been created.';
        Text002: Label '%1 %2 approval request cancelled.';
        UserSetup: Record "User Setup";
        ApprvlMessageID: Enum ApprovalMessageID;
        ApproverId: Code[100];
        Text003: Label '%1 %2 has been automatically approved and released.';
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
        Text004: Label 'Approval Setup not found.';
        Text005: Label 'User ID %1 does not exist in the User Setup table.';
        Text007: Label '%1 for %2  does not exist in the User Setup table.';
        Text013: Label 'Document %1 must be approved and released before you can perform this action.';
        Text010: Label 'Approver not found.';
        AddApproversTemp: Record "Additional Approver" temporary;
        Text027: Label 'When Approval Type is blank, additional approvers must be added to the template.';
        Text100: Label 'S-QUOTE';
        Text101: Label 'Sales Quote Approval';
        Text102: Label 'S-ORDER';
        Text103: Label 'Sales Order Approval';
        Text104: Label 'S-INVOICE';
        Text105: Label 'Sales Invoice Approval';
        Text106: Label 'S-CREDIT MEMO';
        Text107: Label 'Sales Credit Memo Approval';
        Text108: Label 'S-RETURN ORDER';
        Text109: Label 'Sales Return Order Approval';
        Text110: Label 'S-BLANKET ORDER';
        Text111: Label 'Sales Blanket Order Approval';
        Text112: Label 'P-QUOTE';
        Text113: Label 'Purchase Quote Approval';
        Text114: Label 'P-ORDER';
        Text115: Label 'Purchase Order Approval';
        Text116: Label 'P-INVOICE';
        Text117: Label 'Purchase Invoice Approval';
        Text118: Label 'P-CREDIT MEMO';
        Text119: Label 'Purchase Credit Memo Approval';
        Text120: Label 'P-RETURN ORDER';
        Text121: Label 'Purchase Return Order Approval';
        Text122: Label 'P-BLANKET ORDER';
        Text123: Label 'Purchase Blanket Order Approval';
        Text124: Label 'S-O-CREDITLIMIT';
        Text125: Label 'Sales Order Credit Limit Apporval';
        Text126: Label 'S-I-CREDITLIMIT';
        Text127: Label 'Sales Invoice Credit Limit Apporval';
        Text128: Label '%1 %2 has been automatically approved. Status changed to Pending Prepayment.';
        Text129: Label 'No Approval Templates are enabled for document type %1.';
        IsOpenStatusSet: Boolean;
        Text130: Label 'The approval request cannot be canceled because the order has already been released. To  modify this order, you must reopen it.';
        Text131: Label '%1 %2 Approval Request Opened.';
        Text132: Label '%1 %2 Approval Request Deffered.';
        Text1382: Label '%1 Blocked.';
        RecVHeader: Record "Recovery Header";
        CrmApplication: Record "CRM Application";
        DocType: Enum CustomApprovalEntriesDocType;
        GeneralSetUp: Record "General Set-Up";
        DocPostMgt: Codeunit "Doc-PostMgt";
        RegistryMngt: Codeunit "Registry Mngt.";
        TemplateRec: Record "Approval Template";
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        PostMngt: Codeunit "Register Management";
        AppManagement: Codeunit "Approvals Mgt Notification";
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        SendNotif: Codeunit "SMS Notification";
        VarVariant: Variant;
        Mngt: Codeunit "Periodic Activities Mgt.";
        SendMail: Boolean;
        MailCreated: Boolean;
        MessageType: Enum ApprovalMessageID;

    procedure CheckBlockedDocsOnJnls(DocNo: Code[20]; TableID: Integer): Boolean
    var
        Approval: Record "Posted Approval Entries";
    begin
        Approval.Reset;
        Approval.SetRange("Document No.", DocNo);
        Approval.SetRange("Table ID", TableID);
        Approval.SetRange(Status, Approval.Status::Approved);
        if not Approval.FindFirst then begin
            exit(false)
        end else begin
            exit(true)
        end
    end;

    procedure MarkCrmApplicStatus(CrmNo: Code[50]; ApprovalStatus: Enum ApprovalStatus)
    begin
        CrmApplication.Reset();
        CrmApplication.SetRange("No.", CrmNo);
        if CrmApplication.FindFirst() then begin
            CrmApplication."Approval Status" := ApprovalStatus;
            CrmApplication.Modify(true);
        end;
    end;

    procedure fnCopyApprovedData(DocNo: Code[20]; TableID: Integer)
    var
        PostedApproval: Record "Posted Approval Entries";
        AppEntry: Record "Approval Entries";
        PostedApprovalEntry: Record "Approval Entries";
    begin
        AppEntry.Reset();
        AppEntry.SetRange("Table ID", TableID);
        AppEntry.SetRange("Document No.", DocNo);
        if AppEntry.FindSet() then begin
            repeat
                PostedApproval.TransferFields(AppEntry);
                PostedApproval.Insert(true)
            until AppEntry.Next() = 0;
        end;

        PostedApprovalEntry.Reset();
        PostedApprovalEntry.SetRange("Table ID", PostedApproval."Table ID");
        PostedApprovalEntry.SetRange("Document No.", PostedApproval."Document No.");
        PostedApprovalEntry.DeleteAll();
    end;

    procedure MakeApprovalEntry(TableID: Integer; DocType: Enum CustomApprovalEntriesDocType; DocNo: Code[20]; SalespersonPurchaser: Code[50]; ApprovalSetup: Record "Approval Setup"; ApproverId: Code[50]; ApprovalCode: Code[20]; UserSetup: Record "User Setup"; ApprovalAmount: Decimal; ApprovalAmountLCY: Decimal; CurrencyCode: Code[10]; AppTemplate: Record "Approval Template"; ExeedAmountLCY: Decimal)
    var
        ApprovalEntry: Record "Approval Entries";
        NewSequenceNo: Integer;
    begin
        if NewSequenceNo = 0 then NewSequenceNo := 1;
        NewSequenceNo := NewSequenceNo + 1;
        ApprovalEntry."Entry No." := InitNextEntryNo();
        ApprovalEntry."Table ID" := TableID;
        ApprovalEntry."Document Type" := DocType;
        ApprovalEntry."Document No." := DocNo;
        ApprovalEntry."Salespers./Purch. Code" := SalespersonPurchaser;
        ApprovalEntry."Sequence No." := InitNextEntryNo();
        ApprovalEntry."Approval Code" := ApprovalCode;
        ApprovalEntry."Sender ID" := UserId;
        ApprovalEntry.Amount := ApprovalAmount;
        ApprovalEntry."Amount (LCY)" := ApprovalAmountLCY;
        ApprovalEntry."Currency Code" := CurrencyCode;
        ApprovalEntry."Approver ID" := ApproverId;
        if ApproverId = UserId then
            ApprovalEntry.Status := ApprovalEntry.Status::Approved
        else
            ApprovalEntry.Status := ApprovalEntry.Status::Created;
        ApprovalEntry."Date-Time Sent for Approval" := CreateDateTime(Today, Time);
        ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
        ApprovalEntry."Last Modified By User ID" := UserId;
        ApprovalEntry."Due Date" := CalcDate(ApprovalSetup."Due Date Formula", Today);
        ApprovalEntry."Approval Type" := AppTemplate."Approval Type";
        ApprovalEntry."Limit Type" := AppTemplate."Limit Type";
        ApprovalEntry."Available Credit Limit (LCY)" := ExeedAmountLCY;
        ApprovalEntry.Insert(true);

    end;

    procedure ApproveApprovalRequest(ApprovalEntry: Record "Approval Entries"): Boolean
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ApprovalSetup: Record "Approval Setup";
        NextApprovalEntry: Record "Approval Entries";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        MembOpening: Record "Member Application";
        MembAcOpening: Record "Member Application";
        Acc: Record "Account Application";
        PFact: Record "Product Factory";
        Loans: Record Loans;
        PostLoan: Record Loans;
        LoanApplication: Record "Loan Application";
        LoanApplic: Record "Loan Application";
        LoanApplicationCharges: Record "Loan Application Charge";
        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
        LoansTopup: Record "Loans Top up";
        DisbursementHeader: Record "Loan Disbursement Header";
        CollateralRgt: Record "Collateral Register";
        InterestHeader: Record "Interest Header";
        CheckoffHeader: Record "Checkoff Header";
        RecoveryHeader: Record "Recovery Header";
        SecurityCollection: Record "Security Collection";
        TellerTransaction: Record "Teller Transaction";
        TreasuryTrans: Record "Treasury Cashier Transaction";
        AccTransfer: Record "Account Transfer Header";
        BnkCheque: Record "Bankers Cheque Application";
        StandingOrder: Record "Standing Order Header";
        EFTHeader: Record "EFT Transfer Header";
        Mchanges: Record "Member Changes";
        FileAlloc: Record "File Allocation";
        Notices: Record "Member withdrawal Notice";
        MClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        MRegistration: Record "Dsc Mobile Application";
        ProcedureAcc: Record "Account (Procedure)";
        DocSubstitution: Record "Guarantors Substitution";
        DocSubstitute: Record "Guarantors Substitution";
        Accbanking: Record "Account Banking";
        RecordChanges: Record "Mc Acc. Changes";
        TempBanking: Record "Account (Procedure)";
        Registry: Codeunit "Registry Mngt.";
        PeriodicMngt: Codeunit "Periodic Activities Mgt.";
        BankingRec: Record "Account Banking";
        CredAccount: Record "Account Credit";
        Temp: Record "User Setup";
        PayHeader: Record "Payments Header";
        InterBank: Record "Interbank Transfer";
        ImprestHeader: Record "Imprest Header";
        ObjtEmp: Record "HR Employees";
        PartialDisb: Record "Partial Disbursement Schedule";
        RegisterMngt: Codeunit "Register Management";
        PostApplic: Record "Loan Application";
        NotifMgt: Codeunit "SMS Notification";
        Varvariant: Variant;
        PrPayrollRequest: Record "Payroll Requests";
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        MsgOnNonGuaranteeAccount: Label 'Member no permitted to guarantee loan.Check comments. Are you you want to proceed?';
    begin
        if ApprovalEntry."Table ID" <> 0 then begin

            ApprovalEntry.Status := ApprovalEntry.Status::Approved;
            ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
            ApprovalEntry."Last Modified By User ID" := UserId;
            ApprovalEntry.Modify;
            NextApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.");
            NextApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
            NextApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type");
            NextApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
            NextApprovalEntry.SetFilter(Status, '%1|%2', NextApprovalEntry.Status::Created, NextApprovalEntry.Status::Open);
            if NextApprovalEntry.Find('-') then begin
                if NextApprovalEntry.Status = NextApprovalEntry.Status::Open then
                    exit(false)
                else begin

                    NextApprovalEntry.Status := NextApprovalEntry.Status::Open;
                    NextApprovalEntry."Date-Time Sent for Approval" := CreateDateTime(Today, Time);
                    NextApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    NextApprovalEntry."Last Modified By User ID" := UserId;
                    NextApprovalEntry.Modify;
                    if ApprovalSetup.Get then
                        if ApprovalSetup.Approvals then begin
                            if ApprovalEntry."Table ID" = DATABASE::"Sales Header" then begin
                            end;
                        end;
                    exit(false);
                end;
            end else begin

                if PayHeader.Get(ApprovalEntry."Document No.") then begin
                    PayHeader.Validate("Approval Status", PayHeader."Approval Status"::Approved);
                    PayHeader.Modify(true);
                    fnCopyApprovedData(PayHeader."No.", Database::"Payments Header");

                end;
                if InterBank.Get(ApprovalEntry."Document No.") then begin
                    InterBank.Validate("Approval Status", InterBank."Approval Status"::Approved);
                    InterBank.Modify(true);
                    fnCopyApprovedData(InterBank."No.", Database::"Interbank Transfer");

                end;
                if ImprestHeader.Get(ApprovalEntry."Document No.") then begin
                    ImprestHeader.Validate("Approval Status", ImprestHeader."Approval Status"::Approved);
                    ImprestHeader.Modify(true);
                    fnCopyApprovedData(ImprestHeader."No.", Database::"Imprest Header");
                end;
                if PrPayrollRequest.Get(ApprovalEntry."Document No.") then begin
                    PrPayrollRequest.Validate(Status, PrPayrollRequest.Status::Rejected);
                    PrPayrollRequest.Validate("Approval Status", PrPayrollRequest."Approval Status"::Rejected);
                    PrPayrollRequest.Modify(true)
                end;

                if MembOpening.Get(ApprovalEntry."Document No.") then begin
                    MembOpening.Validate("Approval Status", MembOpening."Approval Status"::Approved);
                    MembOpening.Modify;

                    CrmApplication.Reset();
                    CrmApplication.SetRange("No.", MembOpening."CRM Application No.");
                    if CrmApplication.FindFirst() then begin
                        CrmApplication."Approval Status" := CrmApplication."Approval Status"::Approved;
                        CrmApplication.Modify(true);
                    end;

                    MembAcOpening.Reset;
                    MembAcOpening.SetRange("No.", MembOpening."No.");
                    if MembAcOpening.FindFirst then begin
                        GeneralSetUp.Get;
                        GeneralSetUp.TestField("Post Membership As");
                        case GeneralSetUp."Post Membership As" of
                            GeneralSetUp."Post Membership As"::"Create Automatically":
                                begin
                                    if MembAcOpening."Application Type" <> MembAcOpening."Application Type"::Readmission then
                                        RegistryMngt.CustomerRegistration(MembAcOpening, 0)
                                end;
                        end;
                    end;
                    fnCopyApprovedData(MembOpening."No.", Database::"Member Application");

                end;
                if PFact.Get(ApprovalEntry."Document No.") then begin
                    PFact.Validate(Status, PFact.Status::Active);
                    PFact.Modify;
                    fnCopyApprovedData(PFact."Product ID", Database::"Product Factory");
                end;
                if Acc.Get(ApprovalEntry."Document No.") then begin
                    Acc.Validate("Approval Status", Acc."Approval Status"::Approved);
                    Acc.Modify;
                    fnCopyApprovedData(Acc."No.", Database::"Account Application");

                end;
                if DisbursementHeader.Get(ApprovalEntry."Document No.") then begin
                    DisbursementHeader.Validate("Approval Status", DisbursementHeader."Approval Status"::Approved);
                    DisbursementHeader.Modify;
                    fnCopyApprovedData(DisbursementHeader."No.", Database::"Loan Disbursement Header");
                end;

                if LoanApplication.Get(ApprovalEntry."Document No.") then begin
                    LoanApplication.Validate("Approval Status", LoanApplication."Approval Status"::Approved);
                    LoanApplication.Modify;
                    fnCopyApprovedData(LoanApplication."No.", Database::"Loan Application");

                    LoanApplic.Reset();
                    LoanApplic.SetRange("No.", LoanApplication."No.");
                    if LoanApplic.FindFirst() then begin
                        GeneralSetUp.Get;
                        GeneralSetUp.TestField("Post Loan As");
                        case GeneralSetUp."Post Loan As" of
                            GeneralSetUp."Post Loan As"::"Create Automatically":
                                DocPostMgt.LoanRegistration(LoanApplic, 0);
                        end;
                    end;

                    LoanApplicationCharges.Reset;
                    LoanApplicationCharges.SetRange("Application No.", LoanApplication."No.");
                    if LoanApplicationCharges.FindSet then
                        LoanApplicationCharges.ModifyAll("Approval Status",
                      LoanApplicationCharges."Approval Status"::Approved);

                    LoansTopup.Reset;
                    LoansTopup.SetRange("No.", LoanApplication."No.");
                    if LoansTopup.FindSet then
                        LoansTopup.ModifyAll("Approval Status", LoansTopup."Approval Status"::Approved);

                    LoanGuarantorsandSecurity.Reset;
                    LoanGuarantorsandSecurity.SetRange("No.", LoanApplication."No.");
                    if LoanGuarantorsandSecurity.FindSet then
                        LoanGuarantorsandSecurity.ModifyAll("Approval Status",
                      LoanGuarantorsandSecurity."Approval Status"::Approved);

                    PostApplic.Reset();
                    PostApplic.SetRange("No.", LoanApplication."No.");
                    PostApplic.SetRange("Approval Status", PostApplic."Approval Status"::Approved);
                    if PostApplic.FindFirst() then begin
                        Varvariant := PostApplic;
                        NotifMgt.SendEmailNotification(Varvariant, 0, PostApplic."No.");
                    end
                end;

                if Loans.Get(ApprovalEntry."Document No.") then begin
                    Loans.Validate("Approval Status", Loans."Approval Status"::Approved);
                    Loans.Modify;
                    fnCopyApprovedData(Loans."No.", Database::Loans);
                end;


                if CollateralRgt.Get(ApprovalEntry."Document No.") then begin
                    CollateralRgt.Validate("Approval Status", CollateralRgt."Approval Status"::Approved);
                    CollateralRgt.Validate("Inward/Outward", CollateralRgt."Inward/Outward"::"In-Store");
                    CollateralRgt.Modify;
                    fnCopyApprovedData(CollateralRgt."No.", Database::"Collateral Register");
                end;

                if InterestHeader.Get(ApprovalEntry."Document No.") then begin
                    InterestHeader.Validate("Approval Status", InterestHeader."Approval Status"::Approved);
                    InterestHeader.Modify;
                    fnCopyApprovedData(InterestHeader."No.", Database::"Interest Header");
                end;
                if CheckoffHeader.Get(ApprovalEntry."Document No.") then begin
                    CheckoffHeader.Validate("Approval Status", CheckoffHeader."Approval Status"::Approved);
                    CheckoffHeader.Modify;
                    fnCopyApprovedData(CheckoffHeader."No.", Database::"Checkoff Header");
                end;

                if RecoveryHeader.Get(ApprovalEntry."Document No.") then begin
                    RecoveryHeader.Validate("Approval Status", RecoveryHeader."Approval Status"::Approved);
                    RecoveryHeader.Modify;
                    fnCopyApprovedData(RecoveryHeader."No.", Database::"Recovery Header");
                    if RecVHeader.get(RecoveryHeader."No.") then begin
                        if RecVHeader."Post As" = RecVHeader."Post As"::"Post Automatically" then begin
                            /// Mngt.PerformPost(RecVHeader, 1)
                        end
                    end
                end;

                if SecurityCollection.Get(ApprovalEntry."Document No.") then begin
                    SecurityCollection.Validate("Approval Status", SecurityCollection."Approval Status"::Approved);
                    if SecurityCollection."Operation Type" = SecurityCollection."Operation Type"::Collection then begin
                        SecurityCollection.Validate("Inward/Outward", SecurityCollection."Inward/Outward"::Returned);
                    end;
                    SecurityCollection.Modify;

                    CollateralRgt.Reset();
                    CollateralRgt.SetRange("No.", SecurityCollection."Collateral Register No.");
                    if CollateralRgt.FindFirst() then begin
                        if CollateralRgt."Document Type" = CollateralRgt."Document Type"::Collateral then begin
                            CollateralRgt."Inward/Outward" := CollateralRgt."Inward/Outward"::Returned;
                        end;
                        CollateralRgt.Modify(true)
                    end;
                    fnCopyApprovedData(SecurityCollection."No.", Database::"Security Collection");
                end;

                if TellerTransaction.Get(ApprovalEntry."Document No.") then begin
                    if TellerTransaction.Type = TellerTransaction.Type::Lien then begin
                        TellerTransaction."Cheque Status" := TellerTransaction."Cheque Status"::Honoured;
                        TellerTransaction."Date Cleared" := Today;
                        TellerTransaction."Cleared By" := UserId;
                        TellerTransaction.Modify;
                    end else begin
                        TellerTransaction.Validate("Approval Status", TellerTransaction."Approval Status"::Approved);
                        TellerTransaction.Modify
                    end;
                    fnCopyApprovedData(TellerTransaction."No.", Database::"Teller Transaction");
                end;

                if TreasuryTrans.get(ApprovalEntry."Document No.") then begin
                    TreasuryTrans.validate(Status, TreasuryTrans.status::Approved);
                    TreasuryTrans.Modify(true);
                    fnCopyApprovedData(TreasuryTrans.No, Database::"Treasury Cashier Transaction");
                end;
                if AccTransfer.Get(ApprovalEntry."Document No.") then begin
                    AccTransfer.Validate(Status, AccTransfer.Status::Approved);
                    AccTransfer.Modify(true);
                    fnCopyApprovedData(AccTransfer."No.", Database::"Account Transfer Header");
                    // BnkMngt.PostTransfers(AccTransfer);
                end;
                if BnkCheque.get(ApprovalEntry."Document No.") then begin
                    BnkCheque.Validate("Approval Status", BnkCheque."Approval Status"::Approved);
                    BnkCheque.Modify(true);
                    fnCopyApprovedData(BnkCheque."No.", Database::"Bankers Cheque Application");

                end;
                if StandingOrder.get(ApprovalEntry."Document No.") then begin
                    StandingOrder.Validate("Approval Status", StandingOrder."Approval Status"::Approved);
                    StandingOrder.Modify(true);
                    fnCopyApprovedData(StandingOrder."No.", Database::"Standing Order Header");
                end;
                if EFTHeader.Get(ApprovalEntry."Document No.") then begin
                    EFTHeader.Validate("Approval Status", EFTHeader."Approval Status"::Approved);
                    EFTHeader.Modify(true);
                    fnCopyApprovedData(EFTHeader."No.", Database::"EFT Transfer Header");
                    //  BnkMngt.ElectronicFundsProcessing(EFTHeader, 1);
                end;

                if DocSubstitution.Get(ApprovalEntry."Document No.") then begin
                    DocSubstitution.Validate("Approval Status", DocSubstitution."Approval Status"::Approved);
                    DocSubstitution.Modify(true);
                    case DocSubstitution."Post As" of
                        DocSubstitution."Post As"::"Post Automatically":
                            begin
                                PostMngt.PostSubstitutionLine(DocSubstitution, 0);
                            end;
                    end;
                    fnCopyApprovedData(DocSubstitution."No.", Database::"Guarantors Substitution");
                end;

                if Mchanges.Get(ApprovalEntry."Document No.") then begin
                    Mchanges.validate("Approval Status", Mchanges."Approval Status"::Approved);
                    Mchanges.Modify(true);
                    fnCopyApprovedData(Mchanges."No.", Database::"Member Changes");
                end;

                if MClosure.Get(ApprovalEntry."Document No.") then begin
                    MClosure.Validate("Approval Status", MClosure."Approval Status"::Approved);
                    MClosure.Modify(true);
                    fnCopyApprovedData(MClosure."No.", Database::"Membership closure");

                end;
                if Notices.Get(ApprovalEntry."Document No.") then begin
                    Notices.Validate("Approval Status", Notices."Approval Status"::Approved);
                    Notices.Modify(true);

                    if CustomRecord.Get(Notices."Member No.") then begin
                        case Notices."Document Type" of
                            Notices."Document Type"::"Membership Closure":
                                begin
                                    CustomRecord.Status := CustomRecord.Status::"Withdrawal Application";
                                    CustomRecord.modify(true)
                                end;
                        end;
                    end;
                    Accredit.Reset();
                    Accredit.SetRange("Member No.", Notices."Member No.");
                    Accredit.SetRange("Account Category", Accredit."Account Category"::"Shares Deposit");
                    if Accredit.FindFirst() then begin
                        Accredit.Status := Accredit.Status::"Withdrawal Application";
                        Accredit.Modify(true)
                    end;
                    fnCopyApprovedData(Notices."No.", Database::"Member withdrawal Notice");
                end;

                if ObjtEmp.Get(ApprovalEntry."Document No.") then begin
                    ObjtEmp.Validate("Approval Status", ObjtEmp."Approval Status"::Approved);
                    ObjtEmp.Modify(true);
                    fnCopyApprovedData(ObjtEmp."No.", Database::"HR Employees");
                end;

                if MRegistration.Get(ApprovalEntry."Document No.") then begin
                    MRegistration.Validate("Approval Status", MRegistration."Approval Status"::Approved);
                    MRegistration.Modify(true);

                    ProcedureAcc.Reset();
                    ProcedureAcc.SetRange("No.", MRegistration."Application No");
                    if ProcedureAcc.FindFirst() then begin

                        case MRegistration."Application Type" of
                            MRegistration."Application Type"::Change:
                                begin
                                    ProcedureAcc.Validate("Mobile No.", MRegistration."Mobile Phone No.");
                                end;
                            MRegistration."Application Type"::Initial:
                                begin
                                    ProcedureAcc."Mobile Transaction Status" := ProcedureAcc."Mobile Transaction Status"::Registered;
                                    if ProcedureAcc."Mobile No." <> MRegistration."Mobile Phone No." then
                                        ProcedureAcc.Validate("Mobile No.", MRegistration."Mobile Phone No.");
                                    ProcedureAcc.Status := ProcedureAcc.Status::Active;
                                end;
                            MRegistration."Application Type"::Deactivate:
                                begin
                                    ProcedureAcc."Mobile Transaction Status" := ProcedureAcc."Mobile Transaction Status"::Deactived;
                                end;
                        end;
                        ProcedureAcc.Modify(true);
                        Accbanking.Reset();
                        Accbanking.SetRange("No.", MRegistration."Application No");
                        if Accbanking.FindFirst() then begin
                            Accbanking."Mobile No." := MRegistration."Mobile Phone No.";
                            Accbanking.Modify(true);

                            if CustomRecord.Get(Accbanking."Member No.") then begin
                                CustomRecord.Validate("Mobile Phone No", MRegistration."Mobile Phone No.");
                                CustomRecord.Modify(true);
                            end;
                        end;
                    end;
                    fnCopyApprovedData(MRegistration."No.", Database::"Dsc Mobile Application");
                end;
            end;
            exit(true);
        end


    end;

    procedure RejectApprovalApplication(DocumentNo: Code[100])
    var
        ApprovalSetup: Record "Approval Setup";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        NextApprovalEntry: Record "Approval Entries";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        MembOpening: Record "Member Application";
        MembAcOpening: Record "Member Application";
        Acc: Record "Account Application";
        PFact: Record "Product Factory";
        Loans: Record Loans;
        LoanApplication: Record "Loan Application";
        LoanApplic: Record "Loan Application";
        LoanApplicationCharges: Record "Loan Application Charge";
        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
        LoansTopup: Record "Loans Top up";
        DisbursementHeader: Record "Loan Disbursement Header";
        CollateralRgt: Record "Collateral Register";
        InterestHeader: Record "Interest Header";
        CheckoffHeader: Record "Checkoff Header";
        RecoveryHeader: Record "Recovery Header";
        SecurityCollection: Record "Security Collection";
        TellerTransaction: Record "Teller Transaction";
        TreasuryTrans: Record "Treasury Cashier Transaction";
        AccTransfer: Record "Account Transfer Header";
        BnkCheque: Record "Bankers Cheque Application";
        StandingOrder: Record "Standing Order Header";
        EFTHeader: Record "EFT Transfer Header";
        Mchanges: Record "Member Changes";
        FileAlloc: Record "File Allocation";
        Notices: Record "Member withdrawal Notice";
        MClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        MRegistration: Record "Dsc Mobile Application";
        ProcedureAcc: Record "Account (Procedure)";
        DocSubstitution: Record "Guarantors Substitution";
        Accbanking: Record "Account Banking";
        RecordChanges: Record "Mc Acc. Changes";
        Temp: Record "User Setup";
        PartialDisb: Record "Partial Disbursement Schedule";
        ObjtEmp: Record "HR Employees";
        PrPayrollRequest: record "Payroll Requests";
    begin

        if MembOpening.Get(DocumentNo) then begin
            MembOpening.Validate("Approval Status", MembOpening."Approval Status"::Rejected);
            MembOpening.Modify;
            MarkCrmApplicStatus(MembOpening."No.", MembOpening."Approval Status");

        end;

        PartialDisb.Reset();
        PartialDisb.SetRange("Entry No", ApprovalEntry."Document No.");
        if PartialDisb.FindFirst() then begin
            PartialDisb.Validate("Approval Status", PartialDisb."Approval Status"::Rejected);
            PartialDisb.Modify(true);

        end;

        if Acc.Get(DocumentNo) then begin
            Acc.Validate("Approval Status", Acc."Approval Status"::Rejected);
            Acc.Modify;

        end;
        if DisbursementHeader.Get(DocumentNo) then begin
            DisbursementHeader.Validate("Approval Status", DisbursementHeader."Approval Status"::Rejected);
            DisbursementHeader.Modify;

        end;
        if LoanApplication.Get(DocumentNo) then begin
            LoanApplication.Validate("Approval Status", LoanApplication."Approval Status"::Rejected);
            LoanApplication.Modify;
            MarkCrmApplicStatus(LoanApplication."CRM Application No.", LoanApplication."Approval Status");

        end;
        if Loans.Get(DocumentNo) then begin
            Loans.Validate("Approval Status", Loans."Approval Status"::Rejected);
            Loans.Modify;

        end;
        if PrPayrollRequest.Get(ApprovalEntry."Document No.") then begin
            PrPayrollRequest.Validate(Status, PrPayrollRequest.Status::Rejected);
            PrPayrollRequest.Validate("Approval Status", PrPayrollRequest."Approval Status"::Rejected);
            PrPayrollRequest.Modify(true)
        end;
        if CollateralRgt.Get(DocumentNo) then begin
            CollateralRgt.Validate("Approval Status", CollateralRgt."Approval Status"::Rejected);
            CollateralRgt.Modify;

        end;

        if InterestHeader.Get(DocumentNo) then begin
            InterestHeader.Validate("Approval Status", InterestHeader."Approval Status"::Rejected);
            InterestHeader.Modify;

        end;
        if CheckoffHeader.Get(DocumentNo) then begin
            CheckoffHeader.Validate("Approval Status", CheckoffHeader."Approval Status"::Rejected);
            CheckoffHeader.Modify;

        end;

        if RecoveryHeader.Get(DocumentNo) then begin
            RecoveryHeader.Validate("Approval Status", RecoveryHeader."Approval Status"::Rejected);
            RecoveryHeader.Modify;

        end;
        if SecurityCollection.Get(DocumentNo) then begin
            SecurityCollection.Validate("Approval Status", SecurityCollection."Approval Status"::Rejected);
            SecurityCollection.Modify;

        end;
        if TellerTransaction.Get(DocumentNo) then begin
            TellerTransaction.Validate("Approval Status", TellerTransaction."Approval Status"::Rejected);
            TellerTransaction.Modify;

        end;

        if TreasuryTrans.get(DocumentNo) then begin
            TreasuryTrans.validate(Status, TreasuryTrans.status::Rejected);
            TreasuryTrans.Modify(true);

        end;
        if AccTransfer.Get(DocumentNo) then begin
            AccTransfer.Validate(Status, AccTransfer.Status::Rejected);
            AccTransfer.Modify(true);

        end;
        if BnkCheque.get(DocumentNo) then begin
            BnkCheque.Validate("Approval Status", BnkCheque."Approval Status"::Rejected);
            BnkCheque.Modify(true);

        end;
        if StandingOrder.get(DocumentNo) then begin
            StandingOrder.Validate("Approval Status", StandingOrder."Approval Status"::Rejected);
            StandingOrder.Modify(true);
        end;
        if EFTHeader.Get(DocumentNo) then begin
            EFTHeader.Validate("Approval Status", EFTHeader."Approval Status"::Rejected);
            EFTHeader.Modify(true);

        end;
        if Temp.Get(DocumentNo) then begin
            Temp.Validate("Approval Status", Temp."Approval Status"::Rejected);
            Temp.Modify(true);

        end;

        if DocSubstitution.Get(DocumentNo) then begin
            DocSubstitution.Validate("Approval Status", DocSubstitution."Approval Status"::Rejected);
            DocSubstitution.Modify(true);
        end;

        if Mchanges.Get(DocumentNo) then begin
            Mchanges.validate("Approval Status", Mchanges."Approval Status"::Rejected);
            Mchanges.Modify(true);

        end;

        if RecordChanges.Get(DocumentNo) then begin
            RecordChanges.validate("Approval Status", RecordChanges."Approval Status"::Rejected);
            RecordChanges.Modify(true);

        end;

        if MClosure.Get(DocumentNo) then begin
            MClosure.Validate("Approval Status", MClosure."Approval Status"::Rejected);
            MClosure.Modify(true);


        end;
        if Notices.Get(DocumentNo) then begin
            Notices.Validate("Approval Status", Notices."Approval Status"::Rejected);
            Notices.Modify(true);

        end;

        if MRegistration.Get(DocumentNo) then begin
            MRegistration.Validate("Approval Status", MRegistration."Approval Status"::Rejected);
            MRegistration.Modify(true);
        end;

        if ObjtEmp.Get(DocumentNo) then begin
            ObjtEmp.Validate("Approval Status", ObjtEmp."Approval Status"::Rejected);
            ObjtEmp.Modify(true)
        end
    end;

    procedure RejectApprovalRequest(ApprovalEntry: Record "Approval Entries")
    var
        ApprovalSetup: Record "Approval Setup";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        NextApprovalEntry: Record "Approval Entries";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        MembOpening: Record "Member Application";
        MembAcOpening: Record "Member Application";
        Acc: Record "Account Application";
        PFact: Record "Product Factory";
        Loans: Record Loans;
        Temp: Record "User Setup";
        LoanApplication: Record "Loan Application";
        LoanApplic: Record "Loan Application";
        LoanApplicationCharges: Record "Loan Application Charge";
        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
        LoansTopup: Record "Loans Top up";
        DisbursementHeader: Record "Loan Disbursement Header";
        CollateralRgt: Record "Collateral Register";
        InterestHeader: Record "Interest Header";
        CheckoffHeader: Record "Checkoff Header";
        RecoveryHeader: Record "Recovery Header";
        SecurityCollection: Record "Security Collection";
        TellerTransaction: Record "Teller Transaction";
        TreasuryTrans: Record "Treasury Cashier Transaction";
        AccTransfer: Record "Account Transfer Header";
        BnkCheque: Record "Bankers Cheque Application";
        StandingOrder: Record "Standing Order Header";
        EFTHeader: Record "EFT Transfer Header";
        Mchanges: Record "Member Changes";
        FileAlloc: Record "File Allocation";
        Notices: Record "Member withdrawal Notice";
        MClosure: Record "Membership closure";
        CustomRecord: Record Member;
        Accredit: Record "Account Credit";
        MRegistration: Record "Dsc Mobile Application";
        ProcedureAcc: Record "Account (Procedure)";
        DocSubstitution: Record "Guarantors Substitution";
        Accbanking: Record "Account Banking";
        RecordChanges: Record "Mc Acc. Changes";
        PartialDisb: Record "Partial Disbursement Schedule";
        PayHeader: Record "Payments Header";
        InterBank: Record "Interbank Transfer";
        ImprestHeader: Record "Imprest Header";
        ObjtEmp: Record "HR Employees";
    begin
        if ApprovalEntry."Table ID" <> 0 then begin

            ApprovalSetup.Get;
            ApprovalEntry.Status := ApprovalEntry.Status::Open;
            ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
            ApprovalEntry."Last Modified By User ID" := UserId;
            ApprovalEntry.Modify;
            if ApprovalSetup.Rejections then
                SendRejectionMail(ApprovalEntry, AppManagement);
            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
            ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type");
            ApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2&<>%3', ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Open);
            if ApprovalEntry.Find('+') then
                SendMail := false;
            if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
               (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                SendMail := true;

            ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
            ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
            ApprovalEntry."Last Modified By User ID" := UserId;
            ApprovalEntry.Modify;
            if ApprovalSetup.Rejections and SendMail then
                SendRejectionMail(ApprovalEntry, AppManagement);
            if ApprovalSetup.Rejections then
                AppManagement.SendMail;
            if ApprovalEntry."Table ID" = DATABASE::"Sales Header" then begin
                SalesHeader.SetCurrentKey("Document Type", "No.");
                SalesHeader.SetRange("Document Type", ApprovalEntry."Document Type");
                SalesHeader.SetRange("No.", ApprovalEntry."Document No.");
                if SalesHeader.Find('-') then
                    ReleaseSalesDoc.Reopen(SalesHeader);
            end else begin
                if PayHeader.Get(ApprovalEntry."Document No.") then begin
                    PayHeader.Validate("Approval Status", PayHeader."Approval Status"::Rejected);
                    PayHeader.Modify(true);
                    fnCopyApprovedData(PayHeader."No.", Database::"Payments Header");

                end;
                if InterBank.Get(ApprovalEntry."Document No.") then begin
                    InterBank.Validate("Approval Status", InterBank."Approval Status"::Rejected);
                    InterBank.Modify(true);
                    fnCopyApprovedData(InterBank."No.", Database::"Interbank Transfer");

                end;
                if ImprestHeader.Get(ApprovalEntry."Document No.") then begin
                    ImprestHeader.Validate("Approval Status", ImprestHeader."Approval Status"::Rejected);
                    ImprestHeader.Modify(true);
                    fnCopyApprovedData(ImprestHeader."No.", Database::"Imprest Header");
                end;

                if MembOpening.Get(ApprovalEntry."Document No.") then begin
                    MembOpening.Validate("Approval Status", MembOpening."Approval Status"::Rejected);
                    MembOpening.Modify;

                    CrmApplication.Reset();
                    CrmApplication.SetRange("No.", MembOpening."CRM Application No.");
                    if CrmApplication.FindFirst() then begin
                        CrmApplication."Approval Status" := CrmApplication."Approval Status"::Rejected;
                        CrmApplication.Modify(true);
                    end;

                    fnCopyApprovedData(MembOpening."No.", Database::"Member Application");

                end;
                if PFact.Get(ApprovalEntry."Document No.") then begin
                    PFact.Validate(Status, PFact.Status::Blocked);
                    PFact.Modify;
                    fnCopyApprovedData(PFact."Product ID", Database::"Product Factory");
                end;
                if Acc.Get(ApprovalEntry."Document No.") then begin
                    Acc.Validate("Approval Status", Acc."Approval Status"::Rejected);
                    Acc.Modify;
                    fnCopyApprovedData(Acc."No.", Database::"Account Application");

                end;
                if DisbursementHeader.Get(ApprovalEntry."Document No.") then begin
                    DisbursementHeader.Validate("Approval Status", DisbursementHeader."Approval Status"::Rejected);
                    DisbursementHeader.Modify;
                    fnCopyApprovedData(DisbursementHeader."No.", Database::"Loan Disbursement Header");
                end;
                if LoanApplication.Get(ApprovalEntry."Document No.") then begin
                    LoanApplication.Validate("Approval Status", LoanApplication."Approval Status"::Rejected);
                    LoanApplication.Modify;
                    fnCopyApprovedData(LoanApplication."No.", Database::"Loan Application");

                    LoanApplicationCharges.Reset;
                    LoanApplicationCharges.SetRange("Application No.", LoanApplication."No.");
                    if LoanApplicationCharges.FindSet then
                        LoanApplicationCharges.ModifyAll("Approval Status",
                      LoanApplicationCharges."Approval Status"::Rejected);

                    LoansTopup.Reset;
                    LoansTopup.SetRange("No.", LoanApplication."No.");
                    if LoansTopup.FindSet then
                        LoansTopup.ModifyAll("Approval Status", LoansTopup."Approval Status"::Rejected);

                    LoanGuarantorsandSecurity.Reset;
                    LoanGuarantorsandSecurity.SetRange("No.", LoanApplication."No.");
                    if LoanGuarantorsandSecurity.FindSet then
                        LoanGuarantorsandSecurity.ModifyAll("Approval Status",
                      LoanGuarantorsandSecurity."Approval Status"::Rejected);

                end;

                if Loans.Get(ApprovalEntry."Document No.") then begin
                    Loans.Validate("Approval Status", Loans."Approval Status"::Rejected);
                    Loans.Modify;
                    fnCopyApprovedData(Loans."No.", Database::Loans);
                end;
                if CollateralRgt.Get(ApprovalEntry."Document No.") then begin
                    CollateralRgt.Validate("Approval Status", CollateralRgt."Approval Status"::Rejected);
                    CollateralRgt.Modify;
                    fnCopyApprovedData(CollateralRgt."No.", Database::"Collateral Register");
                end;

                if InterestHeader.Get(ApprovalEntry."Document No.") then begin
                    InterestHeader.Validate("Approval Status", InterestHeader."Approval Status"::Rejected);
                    InterestHeader.Modify;
                    fnCopyApprovedData(InterestHeader."No.", Database::"Interest Header");
                end;
                if CheckoffHeader.Get(ApprovalEntry."Document No.") then begin
                    CheckoffHeader.Validate("Approval Status", CheckoffHeader."Approval Status"::Rejected);
                    CheckoffHeader.Modify;
                    fnCopyApprovedData(CheckoffHeader."No.", Database::"Checkoff Header");
                end;

                if RecoveryHeader.Get(ApprovalEntry."Document No.") then begin
                    RecoveryHeader.Validate("Approval Status", RecoveryHeader."Approval Status"::Rejected);
                    RecoveryHeader.Modify;
                    fnCopyApprovedData(RecoveryHeader."No.", Database::"Recovery Header");
                end;
                if SecurityCollection.Get(ApprovalEntry."Document No.") then begin
                    SecurityCollection.Validate("Approval Status", SecurityCollection."Approval Status"::Rejected);
                    SecurityCollection.Modify;
                    fnCopyApprovedData(SecurityCollection."No.", Database::"Security Collection");
                end;

                if TellerTransaction.Get(ApprovalEntry."Document No.") then begin
                    if TellerTransaction.Type = TellerTransaction.Type::Lien then begin
                        TellerTransaction."Cheque Status" := TellerTransaction."Cheque Status"::Stopped;
                        TellerTransaction."Date Cleared" := Today;
                        TellerTransaction."Cleared By" := UserId;
                        TellerTransaction.Modify;
                    end else begin
                        TellerTransaction.Validate("Approval Status", TellerTransaction."Approval Status"::Rejected);
                        TellerTransaction.Modify
                    end;
                    fnCopyApprovedData(TellerTransaction."No.", Database::"Teller Transaction");
                end;

                if TreasuryTrans.get(ApprovalEntry."Document No.") then begin
                    TreasuryTrans.validate(Status, TreasuryTrans.status::Approved);
                    TreasuryTrans.Modify(true);
                    fnCopyApprovedData(TreasuryTrans.No, Database::"Treasury Cashier Transaction");
                end;
                if AccTransfer.Get(ApprovalEntry."Document No.") then begin
                    AccTransfer.Validate(Status, AccTransfer.Status::Rejected);
                    AccTransfer.Modify(true);
                    fnCopyApprovedData(AccTransfer."No.", Database::"Account Transfer Header");
                end;
                if BnkCheque.get(ApprovalEntry."Document No.") then begin
                    BnkCheque.Validate("Approval Status", BnkCheque."Approval Status"::Rejected);
                    BnkCheque.Modify(true);
                    fnCopyApprovedData(BnkCheque."No.", Database::"Bankers Cheque Application");

                end;
                if StandingOrder.get(ApprovalEntry."Document No.") then begin
                    StandingOrder.Validate("Approval Status", StandingOrder."Approval Status"::Rejected);
                    StandingOrder.Modify(true);
                    fnCopyApprovedData(StandingOrder."No.", Database::"Standing Order Header");
                end;

                if EFTHeader.Get(ApprovalEntry."Document No.") then begin
                    EFTHeader.Validate("Approval Status", EFTHeader."Approval Status"::Rejected);
                    EFTHeader.Modify(true);
                    fnCopyApprovedData(EFTHeader."No.", Database::"EFT Transfer Header");
                    //  BnkMngt.ElectronicFundsProcessing(EFTHeader, 1);
                end;

                if DocSubstitution.Get(ApprovalEntry."Document No.") then begin
                    DocSubstitution.Validate("Approval Status", DocSubstitution."Approval Status"::Rejected);
                    DocSubstitution.Modify(true);
                    fnCopyApprovedData(DocSubstitution."No.", Database::"Guarantors Substitution");
                end;

                if Mchanges.Get(ApprovalEntry."Document No.") then begin
                    Mchanges.validate("Approval Status", Mchanges."Approval Status"::Rejected);
                    Mchanges.Modify(true);
                    fnCopyApprovedData(Mchanges."No.", Database::"Member Changes");
                end;

                if MClosure.Get(ApprovalEntry."Document No.") then begin
                    MClosure.Validate("Approval Status", MClosure."Approval Status"::Rejected);
                    MClosure.Modify(true);
                    fnCopyApprovedData(MClosure."No.", Database::"Membership closure");

                end;
                if Notices.Get(ApprovalEntry."Document No.") then begin
                    Notices.Validate("Approval Status", Notices."Approval Status"::Rejected);
                    Notices.Modify(true);
                    fnCopyApprovedData(Notices."No.", Database::"Member withdrawal Notice");
                end;

                if MRegistration.Get(ApprovalEntry."Document No.") then begin
                    MRegistration.Validate("Approval Status", MRegistration."Approval Status"::Rejected);
                    MRegistration.Modify(true);
                    fnCopyApprovedData(MRegistration."No.", Database::"Dsc Mobile Application");
                end;

                if ObjtEmp.Get(ApprovalEntry."Document No.") then begin
                    ObjtEmp.Validate("Approval Status", ObjtEmp."Approval Status"::Rejected);
                    ObjtEmp.Modify(true);
                    fnCopyApprovedData(ObjtEmp."No.", Database::"HR Employees");
                end

            end;
        end;

    end;

    procedure DefferApprovalRequest(ApprovalEntry: Record "Approval Entries"): Boolean
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ApprovalSetup: Record "Approval Setup";
        NextApprovalEntry: Record "Approval Entries";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
        MembOpening: Record "Member Application";
        Acc: Record "Account Application";
        PFact: Record "Product Factory";
        Loans: Record Loans;
        LoanApplication: Record "Loan Application";
        LoanApplicationCharges: Record "Loan Application Charge";
        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
        LoansTopup: Record "Loans Top up";
        DisbursementHeader: Record "Loan Disbursement Header";
        CollateralRgt: Record "Collateral Register";
        InterestHeader: Record "Interest Header";
        CheckoffHeader: Record "Checkoff Header";
        RecoveryHeader: Record "Recovery Header";
        SecurityCollection: Record "Security Collection";
        TreasuryTrans: Record "Treasury Cashier Transaction";
        AccTransfer: Record "Account Transfer Header";
        Mchanges: Record "Member Changes";
        ReccordChanges: Record "Mc Acc. Changes";
    begin
        if ApprovalEntry."Table ID" <> 0 then begin
            ApprovalEntry.Status := ApprovalEntry.Status::Approved;
            ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
            ApprovalEntry."Last Modified By User ID" := UserId;
            ApprovalEntry.Modify;
            NextApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.");
            NextApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
            NextApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type");
            NextApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
            NextApprovalEntry.SetFilter(Status, '%1|%2', NextApprovalEntry.Status::Created, NextApprovalEntry.Status::Open);
            if NextApprovalEntry.Find('-') then begin
                if NextApprovalEntry.Status = NextApprovalEntry.Status::Open then
                    exit(false)
                else begin
                    NextApprovalEntry.Status := NextApprovalEntry.Status::Open;
                    NextApprovalEntry."Date-Time Sent for Approval" := CreateDateTime(Today, Time);
                    NextApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    NextApprovalEntry."Last Modified By User ID" := UserId;
                    NextApprovalEntry.Modify;
                    if ApprovalSetup.Get then
                        if ApprovalSetup.Approvals then begin
                            if ApprovalEntry."Table ID" = DATABASE::"Sales Header" then begin
                                // IF SalesHeader.GET(NextApprovalEntry."Document Type",NextApprovalEntry."Document No.") THEN
                                // ApprovalMgtNotification.SendSalesApprovalsMail(SalesHeader,NextApprovalEntry);
                                // END ELSE BEGIN
                                // IF PurchaseHeader.GET(NextApprovalEntry."Document Type",NextApprovalEntry."Document No.") THEN
                                // ApprovalMgtNotification.SendPurchaseApprovalsMail(PurchaseHeader,NextApprovalEntry);
                            end;
                        end;
                    exit(false);
                end;
            end else begin
                if ApprovalEntry."Table ID" = DATABASE::"Sales Header" then begin
                    if SalesHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then
                        ReleaseSalesDoc.Run(SalesHeader);
                end else begin
                    if PurchaseHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then
                        ReleasePurchaseDoc.Run(PurchaseHeader);
                end;

                if MembOpening.Get(ApprovalEntry."Document No.") then begin
                    MembOpening.Validate("Approval Status", MembOpening."Approval Status"::Deffered);
                    MembOpening.Modify;
                end;
                if PFact.Get(ApprovalEntry."Document No.") then begin
                    PFact.Validate(Status, PFact.Status::"Pending Approval");
                    PFact.Modify
                end;
                if Acc.Get(ApprovalEntry."Document No.") then begin
                    Acc.Validate("Approval Status", Acc."Approval Status"::Deffered);
                    Acc.Modify;
                end;
                if DisbursementHeader.Get(ApprovalEntry."Document No.") then begin
                    DisbursementHeader.Validate("Approval Status", DisbursementHeader."Approval Status"::Approved);
                    DisbursementHeader.Modify
                end;
                if LoanApplication.Get(ApprovalEntry."Document No.") then begin
                    LoanApplication.Validate("Approval Status", LoanApplication."Approval Status"::Deffered);
                    LoanApplication.Modify;

                    LoanApplicationCharges.Reset;
                    LoanApplicationCharges.SetRange("Application No.", LoanApplication."No.");
                    if LoanApplicationCharges.FindSet then
                        LoanApplicationCharges.ModifyAll("Approval Status",
                      LoanApplicationCharges."Approval Status"::Deffered);

                    LoansTopup.Reset;
                    LoansTopup.SetRange("No.", LoanApplication."No.");
                    if LoansTopup.FindSet then
                        LoansTopup.ModifyAll("Approval Status", LoansTopup."Approval Status"::Deffered);

                    LoanGuarantorsandSecurity.Reset;
                    LoanGuarantorsandSecurity.SetRange("No.", LoanApplication."No.");
                    if LoanGuarantorsandSecurity.FindSet then
                        LoanGuarantorsandSecurity.ModifyAll("Approval Status",
                      LoanGuarantorsandSecurity."Approval Status"::Deffered);

                end;
                if Loans.Get(ApprovalEntry."Document No.") then begin
                    Loans.Validate("Approval Status", Loans."Approval Status"::Deffered);
                    Loans.Modify;
                end;
                if CollateralRgt.Get(ApprovalEntry."Document No.") then begin
                    CollateralRgt.Validate("Approval Status", CollateralRgt."Approval Status"::Deffered);
                    CollateralRgt.Validate("Inward/Outward", CollateralRgt."Inward/Outward"::"In-Store");
                    CollateralRgt.Modify
                end;
                if InterestHeader.Get(ApprovalEntry."Document No.") then begin
                    InterestHeader.Validate("Approval Status", InterestHeader."Approval Status"::Deffered);
                    InterestHeader.Modify
                end;
                if CheckoffHeader.Get(ApprovalEntry."Document No.") then begin
                    CheckoffHeader.Validate("Approval Status", CheckoffHeader."Approval Status"::Deffered);
                    CheckoffHeader.Modify
                end;
                if RecoveryHeader.Get(ApprovalEntry."Document No.") then begin
                    RecoveryHeader.Validate("Approval Status", RecoveryHeader."Approval Status"::Deffered);
                    RecoveryHeader.Modify;
                end;

                if SecurityCollection.Get(ApprovalEntry."Document No.") then begin
                    SecurityCollection.Validate("Approval Status", SecurityCollection."Approval Status"::Deffered);
                    SecurityCollection.Modify
                end;

            end;
            exit(true);
        end;
    end;

    procedure DelegateApprovalRequest(ApprovalEntry: Record "Approval Entries")
    var
        UserSetup: Record "User Setup";
        ApprovalSetup: Record "Approval Setup";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        UserSetup.SetRange("User ID", ApprovalEntry."Approver ID");
        if not UserSetup.Find('-') then
            Error(Text005, ApprovalEntry."Approver ID");
        if not ApprovalSetup.Get then
            Error(Text004);

        if UserSetup.Substitute <> '' then begin
            UserSetup.SetRange("User ID", UserSetup.Substitute);
            if UserSetup.Find('-') then begin
                ApprovalEntry."Last Modified By User ID" := UserId;
                ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                ApprovalEntry."Approver ID" := UserSetup."User ID";
                ApprovalEntry.Modify;

            end;
        end else
            Error(Text007, UserSetup.FieldCaption(Substitute), UserSetup."User ID");
    end;

    procedure DelegateApprovalRequests(VAR ApprovalEntry: Record "Approval Entries")
    var
        ApprovalEntryToUpdate: Record "Approval Entries";
        ApprovalsDelegatedMsg: label 'The selected approval requests have been delegated.';
    begin
        if ApprovalEntry.FindSet(TRUE) then begin
            repeat
                ApprovalEntryToUpdate := ApprovalEntry;
                DelegateSelectedApprovalRequest(ApprovalEntryToUpdate, TRUE);
            until ApprovalEntry.Next() = 0;
            Message(ApprovalsDelegatedMsg);
        end
    end;

    procedure DelegateSelectedApprovalRequest(VAR ApprovalEntry: Record "Approval Entries"; CheckCurrentUser: Boolean)
    var
        DelegateOnlyOpenRequestsErr: label 'You can only delegate open approval requests.';
        NoPermissionToDelegateErr: label 'You do not have permission to delegate one or more of the selected approval requests.';
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open then
            Error(DelegateOnlyOpenRequestsErr);
        if CheckCurrentUser and (not ApprovalEntry.CanCurrentUserEdit) then
            Error(NoPermissionToDelegateErr);
    end;

    local procedure SubstituteUserIdForApprovalEntry(ApprovalEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        ApproverUserIdNotInSetupErr: label 'You must set up an approver for user ID %1 in the Approval User Setup window.';
        Substitute: code[100];
        ApprovalAdminUserSetup: Record "User Setup";
        SubstituteNotFoundErr: label '';
    begin
        if not UserSetup.GET(ApprovalEntry."Approver ID") then
            Error(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");
        Substitute := '';
        if Substitute <> '' then begin
            ApprovalEntry."Approver ID" := Substitute;
            ApprovalEntry.Modify(true);
            exit;
        end;

        if UserSetup.Substitute = '' then
            if UserSetup."Approver ID" = '' then begin
                ApprovalAdminUserSetup.SetRange("Approval Administrator", TRUE);
                if ApprovalAdminUserSetup.FindFirst() then
                    UserSetup.Get(ApprovalAdminUserSetup."User ID")
                else
                    Error(SubstituteNotFoundErr, UserSetup."User ID");
            end else
                UserSetup.Get(UserSetup."Approver ID")
        else
            UserSetup.Get(UserSetup.Substitute);
        ApprovalEntry."Approver ID" := UserSetup."User ID";
        ApprovalEntry.Modify(true);

    end;

    procedure PrePostApprovalCheck(SalesHeader: Record "Sales Header"; PurchaseHeader: Record "Purchase Header"): Boolean
    begin
        if SalesHeader."No." <> '' then begin
            if SalesHeader.Status = SalesHeader.Status::"Pending Approval" then begin
                Error(Text013, SalesHeader."No.");
            end else begin
                if Confirm('Format', true) = false then
                    exit(true)
                else begin
                    if (not (SalesHeader.Status = SalesHeader.Status::Released) and
                      not (SalesHeader.Status = SalesHeader.Status::"Pending Prepayment"))
                    then
                        Error(Text013, SalesHeader."No.")
                    else
                        exit(true);
                end;
            end;
        end else begin
            if PurchaseHeader.Status = PurchaseHeader.Status::"Pending Approval" then begin
                Error(Text013, PurchaseHeader."No.");
            end else begin
                if Confirm('Format', true) = false then
                    exit(true)
                else begin
                    if (not (PurchaseHeader.Status = PurchaseHeader.Status::Released) and
                      not (PurchaseHeader.Status = PurchaseHeader.Status::"Pending Prepayment"))
                    then
                        Error(Text013, PurchaseHeader."No.")
                    else
                        exit(true);
                end;
            end;
        end;
    end;

    procedure MoveApprvalEntryToPosted(var ApprovalEntry: Record "Approval Entries"; ToTableId: Integer; ToNo: Code[20])
    var
        PostedApprvlEntry: Record "Posted Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
    begin
        if ApprovalEntry.Find('-') then
            repeat
                PostedApprvlEntry.Init;
                PostedApprvlEntry.TransferFields(ApprovalEntry);
                PostedApprvlEntry."Table ID" := ToTableId;
                PostedApprvlEntry."Document No." := ToNo;
                PostedApprvlEntry.Insert;
            until ApprovalEntry.Next = 0;
        ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalCommentLine.SetRange("Document Type", ApprovalEntry."Document Type");
        ApprovalCommentLine.SetRange("Document No.", ApprovalEntry."Document No.");
        if ApprovalCommentLine.Find('-') then
            repeat
                PostedApprovalCommentLine.Init;
                PostedApprovalCommentLine.TransferFields(ApprovalCommentLine);
                PostedApprovalCommentLine."Entry No." := 0;
                PostedApprovalCommentLine."Table ID" := ToTableId;
                PostedApprovalCommentLine."Document No." := ToNo;
                PostedApprovalCommentLine.Insert(true);
            until ApprovalCommentLine.Next = 0;
    end;

    procedure OpenApprovalEntriesPage(RecId: Code[20]; TableId: Integer)
    var
        ApprovalEntry: Record "Approval Entries";
    begin
        ApprovalEntry.SetRange("Table ID", TableId);
        ApprovalEntry.SetRange("Document No.", RecId);
        ApprovalEntry.SetRange("Related to Change", false);
        PAGE.RunModal(PAGE::"Approval Requests", ApprovalEntry);
    end;

    procedure DeleteApprovalEntry(TableId: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Imprest,ImprestSurrender,"Status Change"; DocumentNo: Code[20])
    var
        ApprovalEntry: Record "Approval Entries";
    begin
        ApprovalEntry.SetRange("Table ID", TableId);
        ApprovalEntry.SetRange("Document Type", DocumentType);
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        DeleteApprovalCommentLine(TableId, DocumentType, DocumentNo);
        if ApprovalEntry.Find('-') then
            ApprovalEntry.DeleteAll;
    end;


    procedure DeleteApprovalCommentLine(TableId: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Imprest,ImprestSurrender; DocumentNo: Code[20])
    var
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        ApprovalCommentLine.SetRange("Table ID", TableId);
        ApprovalCommentLine.SetRange("Document Type", DocumentType);
        ApprovalCommentLine.SetRange("Document No.", DocumentNo);
        if ApprovalCommentLine.Find('-') then
            ApprovalCommentLine.DeleteAll;
    end;


    procedure DeletePostedApprovalEntry(TableId: Integer; DocumentNo: Code[20])
    var
        PostedApprovalEntry: Record "Posted Approval Entry";
    begin
        PostedApprovalEntry.SetRange("Table ID", TableId);
        PostedApprovalEntry.SetRange("Document No.", DocumentNo);
        DeletePostedApprvlCommentLine(TableId, DocumentNo);
        if PostedApprovalEntry.Find('-') then
            PostedApprovalEntry.DeleteAll;
    end;


    procedure DeletePostedApprvlCommentLine(TableId: Integer; DocumentNo: Code[20])
    var
        PostedApprovalCommentLine: Record "Posted Approval Comment Line";
    begin
        PostedApprovalCommentLine.SetRange("Entry No.", TableId);
        PostedApprovalCommentLine.SetRange("Document No.", DocumentNo);
        if PostedApprovalCommentLine.Find('-') then
            PostedApprovalCommentLine.DeleteAll;
    end;


    procedure InsertAddApprovers(AppTemplate: Record "Approval Template")
    var
        AddApprovers: Record "Additional Approver";
    begin
        Clear(AddApproversTemp);
        AddApprovers.SetCurrentKey("Sequence No.");
        AddApprovers.SetRange("Approval Code", AppTemplate."Approval Code");
        AddApprovers.SetRange("Approval Type", AppTemplate."Approval Type");
        AddApprovers.SetRange("Document Type", AppTemplate."Document Type");
        AddApprovers.SetRange("Limit Type", AppTemplate."Limit Type");
        if AddApprovers.Find('-') then
            repeat
                AddApproversTemp := AddApprovers;
                AddApproversTemp.Insert;
            until AddApprovers.Next = 0;
    end;


    procedure CheckCreditLimit(SalesHeader: Record "Sales Header"): Decimal
    begin
        //EXIT(SalesInfoPaneMgt.CalcAvailableCredit(SalesHeader."Bill-to Customer No."));
    end;


    procedure CheckAddApprovers(AppTemplate: Record "Approval Template")
    begin
        AppTemplate.CalcFields("Additional Approvers");
        if AppTemplate."Additional Approvers" then
            InsertAddApprovers(AppTemplate);
    end;

    procedure SetupDefualtApprovals()
    var
        ApprovalCode: Record "Approval Code";
        ApprovalTemplate: Record "Approval Template";
    //"Object": Record "Object";
    begin
        /* if not ApprovalCode.FindFirst then begin
            Object.SetRange(Type, Object.Type::Table);
            Object.SetRange(ID, DATABASE::"Sales Header");
            if Object.FindFirst then;
            InsertDefaultApprovalCode(ApprovalCode, Text100, Text101, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text102, Text103, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text104, Text105, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text106, Text107, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text108, Text109, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text110, Text111, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text124, Text125, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text126, Text127, Object.ID, Object.Name);
            Object.SetRange(ID, DATABASE::"Purchase Header");
            if Object.FindFirst then;
            InsertDefaultApprovalCode(ApprovalCode, Text112, Text113, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text114, Text115, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text116, Text117, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text118, Text119, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text120, Text121, Object.ID, Object.Name);
            InsertDefaultApprovalCode(ApprovalCode, Text122, Text123, Object.ID, Object.Name);
        end;
        if not ApprovalTemplate.FindFirst and ApprovalCode.FindFirst then
            repeat
                InsertDefaultApprovalTemplate(ApprovalTemplate, ApprovalCode);
            until ApprovalCode.Next = 0; */
    end;

    procedure InsertDefaultApprovalCode(var ApprovalCodeRec: Record "Approval Code"; ApprovalCode: Code[20]; ApprovalName: Text[100]; TableId: Integer; Tablename: Text[50])
    begin
        ApprovalCodeRec.Init;
        ApprovalCodeRec.Code := ApprovalCode;
        ApprovalCodeRec.Description := ApprovalName;
        ApprovalCodeRec."Linked To Table Name" := Tablename;
        ApprovalCodeRec."Linked To Table No." := TableId;
        ApprovalCodeRec.Insert;
    end;

    procedure findDelegatedApprovalEntry(AppDoc: Code[50])
    var
        ApprovalEntry: Record "Approval Entries";
        TempApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        Usersetup: Record "User Setup";
    begin

        TempApprovalEntry.SetRange("Document No.", AppDoc);
        TempApprovalEntry.SetRange(Status, TempApprovalEntry.Status::Open);
        if TempApprovalEntry.FindSet() then begin
            if ApprovalSetup.Get then
                if Usersetup.Get(UserId) then
                    Usersetup.TestField(Substitute);
            if (ApprovalEntry."Sender ID" = Usersetup."User ID") or
               (ApprovalSetup."Approval Administrator" = Usersetup."User ID") or
               (ApprovalEntry."Approver ID" = Usersetup."User ID")
            then
                repeat
                    DelegateApprovalRequest(TempApprovalEntry)
                until TempApprovalEntry.Next() = 0;
        end
    end;

    procedure InsertDefaultApprovalTemplate(var ApprovalTemplate: Record "Approval Template"; ApprovalCode: Record "Approval Code")
    begin
        case true of
            ApprovalCode.Code = Text100:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::None;
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text102:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"Approval Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text104:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Member Application";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text106:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::Product;
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text108:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Member Changes";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text110:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Specific Approver";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Account Opening";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text112:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Direct Approver";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::None;
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"Request Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text114:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";

                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"Approval Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text116:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Member Application";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text118:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::Product;
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text120:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Sales Pers./Purchaser";
                    // ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Member Changes";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text122:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Specific Approver";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Account Opening";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"No Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text124:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Specific Approver";

                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"Credit Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
            ApprovalCode.Code = Text126:
                begin
                    ApprovalTemplate.Init;
                    ApprovalTemplate."Approval Code" := ApprovalCode.Code;
                    ApprovalTemplate."Approval Type" := ApprovalTemplate."Approval Type"::"Specific Approver";
                    //ApprovalTemplate."Document Type" := ApprovalTemplate."Document Type"::"Member Application";
                    ApprovalTemplate."Limit Type" := ApprovalTemplate."Limit Type"::"Credit Limits";
                    ApprovalTemplate."Table ID" := ApprovalCode."Linked To Table No.";
                    ApprovalTemplate.Insert;
                end;
        end;
    end;


    procedure TestSetup()
    var
        ApprovalSetup: Record "Approval Setup";
    begin
        if not ApprovalSetup.Get then
            Error(Text004);
    end;

    procedure SendRejectionMail(ApprovalEntry: Record "Approval Entries"; AppManagement: Codeunit "Approvals Mgt Notification")
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case ApprovalEntry."Table ID" of
            36:
                begin
                    if SalesHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then
                        Error('Table Not Found');
                    //AppManagement.SendSalesRejectionsMail(SalesHeader,ApprovalEntry);
                end;
            38:
                begin
                    if PurchaseHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then
                        Error('Table Not Found');
                    //AppManagement.SendPurchaseRejectionsMail(PurchaseHeader,ApprovalEntry);
                end;
        end;
    end;

    procedure SendAccOpeningRequest(var MembOpenings: Record "Member Application"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if MembOpenings."Approval Status" <> MembOpenings."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        DocType := DocType::"Member Application";
        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Member Application");
        TemplateRec.SetRange("Document Type", TemplateRec."Document Type"::"Member Application");
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            MembOpenings.TestField("Responsibility Center");
            TemplateRec.SetRange(TemplateRec."Responsibility Center", MembOpenings."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat

                if not FindApproverAccOpening(MembOpenings, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            FinishApprovalEntryAccOpening(MembOpenings, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, MembOpenings."No.");
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, MembOpenings."No.");
                MessageType::RequiresApproval:
                    Message(Text001, DocType, MembOpenings."No.");
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure FindApproverAccOpening(var MembOpening: Record "Member Application"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;
        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;
        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::"Member Application";
        case AppTemplate."Approval Type" of
            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);
                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";

                                MakeApprovalEntry(
                                  DATABASE::"Member Application",
                                  DocType, Format(MembOpening."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Member Application", DocType, MembOpening."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Member Application", DocType, MembOpening."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                              ApprovalAmount, ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Member Application", DocType, MembOpening."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;

    procedure FinishApprovalEntryAccOpening(var MembOpening: Record "Member Application"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin
        DocReleased := false;
        IsOpenStatusSet := false;

        ApprovalEntry.Init();
        DocType := DocType::"Member Application";

        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", MembOpening."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        ApprovalEntry.SetRange("Table ID", Database::"Member Application");
        if ApprovalEntry.Find('-') then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else begin
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //if ApprovalSetup.Approvals then
                        //ApprovalsMgtNotification.SendApprovalMailNotification(ApprovalEntry);
                    end
                end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            MembOpening."Approval Status" := MembOpening."Approval Status"::"Pending Approval";
            MembOpening.Modify(true);
            MarkCrmApplicStatus(MembOpening."CRM Application No.", MembOpening."Approval Status");
            MessageID := MessageID::RequiresApproval;
        end;
        OnAfterSendMemberApplicationForApproval(MembOpening, MessageID);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSendMemberApplicationForApproval(MemberOpening: Record "Member Application"; MessageID: Enum ApprovalMessageID)
    begin

    end;

    procedure CancelAccOpeninApprovalRequest(var MembOpening: Record "Member Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (MembOpening."Approval Status" = MembOpening."Approval Status"::"Pending Approval")
        then begin
            DocType := DocType::"Member Application";
            if not ApprovalSetup.Get then
                Error(Text004);

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Member Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(MembOpening."No."));
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;

            if ManualCancel or (not ManualCancel and not (MembOpening."Approval Status" = MembOpening."Approval Status"::Approved)) then
                MembOpening."Approval Status" := MembOpening."Approval Status"::Open;
            MembOpening.Modify(true);
            MarkCrmApplicStatus(MembOpening."CRM Application No.", MembOpening."Approval Status");
            if ShowMessage then
                Message(Text002, DocType, Format(MembOpening."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnDefferAccountOpeningApprovalRequest(var RecRef: Record "Member Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Open)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::"Member Application";

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"Member Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Deffered;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text132, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OpenAccOpeninApprovalRequest(var MembOpening: Record "Member Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (MembOpening."Approval Status" = MembOpening."Approval Status"::Approved)
        then begin
            DocType := DocType::"Member Application";
            if not ApprovalSetup.Get then
                Error(Text004);

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Member Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(MembOpening."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin
                    AppManagement.SendMail;
                    MailCreated := false;
                end;
            end;

            if ManualCancel or (not ManualCancel and not (MembOpening."Approval Status" = MembOpening."Approval Status"::Posted)) then
                MembOpening."Approval Status" := MembOpening."Approval Status"::Open;
            MembOpening.Modify(true);
            MarkCrmApplicStatus(MembOpening."CRM Application No.", MembOpening."Approval Status");
            if ShowMessage then
                Message(Text131, DocType, Format(MembOpening."No."));
        end
        else
            Message(Text130);
    end;


    procedure SendProductFactRequest(var VarVariant: Record "Product Factory"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
        DocumentType: Option "None",Journal,"Member Application",Product,"Account Opening";
    begin
        TestSetup;

        if VarVariant.Status <> VarVariant.Status::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        Case VarVariant."Product Class" of
            VarVariant."Product Class"::Account:
                DocType := DocType::AccountType;
            VarVariant."Product Class"::Loan:
                DocType := DocType::Product;
        end;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Product Factory");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if TemplateRec.Find('-') then begin
            repeat
                if not FindApproverProductFact(VarVariant, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            FinishApprovalEntryProductFact(VarVariant, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(VarVariant."Product ID"));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(VarVariant."Product ID"));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(VarVariant."Product ID"));
            end;
        end else
            Error(StrSubstNo(Text129, DocumentType));
    end;


    procedure FindApproverProductFact(var VarVariant: Record "Product Factory"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        Case VarVariant."Product Class" of
            VarVariant."Product Class"::Account:
                DocType := DocType::AccountType;
            VarVariant."Product Class"::Loan:
                DocType := DocType::Product;
        end;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Product Factory",
                                  DocType, Format(VarVariant."Product ID"), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Product Factory", DocType, Format(VarVariant."Product ID"), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Product Factory", DocType, Format(VarVariant."Product ID"), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Product Factory", DocType, Format(VarVariant."Product ID"), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure FinishApprovalEntryProductFact(var VarVariant: Record "Product Factory"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        Case VarVariant."Product Class" of
            VarVariant."Product Class"::Account:
                DocType := DocType::AccountType;
            VarVariant."Product Class"::Loan:
                DocType := DocType::Product;
        end;

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Product Factory");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", VarVariant."Product ID");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat

                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;

                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            VarVariant.Status := VarVariant.Status::"Pending Approval";
            VarVariant.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure CancelProductFactApprovalRequest(var VarVariant: Record "Product Factory"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        Case VarVariant."Product Class" of
            VarVariant."Product Class"::Account:
                DocType := DocType::AccountType;
            VarVariant."Product Class"::Loan:
                DocType := DocType::Product;
        end;

        if (VarVariant.Status = VarVariant.Status::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Product Factory");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", VarVariant."Product ID");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (VarVariant.Status = VarVariant.Status::Active)) then
                VarVariant.Status := VarVariant.Status::Open;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(VarVariant."Product ID"));
        end
        else
            Message(Text130);
    end;

    procedure OpenProductFactApprovalRequest(var VarVariant: Record "Product Factory"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (VarVariant.Status <> VarVariant.Status::Open)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            Case VarVariant."Product Class" of
                VarVariant."Product Class"::Account:
                    DocType := DocType::AccountType;
                VarVariant."Product Class"::Loan:
                    DocType := DocType::Product;
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Product Factory");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(VarVariant."Product ID"));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin
                    AppManagement.SendMail;
                    MailCreated := false;
                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant.Status = VarVariant.Status::"Pending Approval")) then
                VarVariant.Status := VarVariant.Status::Open;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(VarVariant."Product ID"));
        end
        else
            Message(Text130);
    end;

    procedure BlockProductFactApprovalRequest(var VarVariant: Record "Product Factory"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if VarVariant.Status <> VarVariant.Status::Blocked
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);

            Case VarVariant."Product Class" of
                VarVariant."Product Class"::Account:
                    DocType := DocType::AccountType;
                VarVariant."Product Class"::Loan:
                    DocType := DocType::Product;
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Product Factory");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(VarVariant."Product ID"));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin
                    AppManagement.SendMail;
                    MailCreated := false;
                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant.Status = VarVariant.Status::Blocked)) then
                VarVariant.Status := VarVariant.Status::Blocked;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text1382, VarVariant.Description);
        end
        else
            Message(Text130);
    end;


    procedure SendUsersetupRequest(var VarVariant: Record "User Setup"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
        DocumentType: Option "None",Journal,"Member Application",Product,"Account Opening";
    begin
        TestSetup;

        if VarVariant."Approval Status" <> VarVariant."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        DocType := DocType::Usersetup;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"User Setup");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if TemplateRec.Find('-') then begin
            repeat
                if not FindApproverUsersetup(VarVariant, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            FinishApprovalEntryUsersetup(VarVariant, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(VarVariant."User ID"));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(VarVariant."User ID"));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(VarVariant."User ID"));
            end;
        end else
            Error(StrSubstNo(Text129, DocumentType));
    end;


    procedure FindApproverUsersetup(var VarVariant: Record "User Setup"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        DocType := DocType::Usersetup;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"User Setup",
                                  DocType, Format(VarVariant."User ID"), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"User Setup", DocType, Format(VarVariant."User ID"), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"User Setup", DocType, Format(VarVariant."User ID"), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"User Setup", DocType, Format(VarVariant."User ID"), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure FinishApprovalEntryUsersetup(var VarVariant: Record "User Setup"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin


        DocType := DocType::Usersetup;

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"User Setup");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", VarVariant."User ID");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat

                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;

                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            VarVariant."Approval Status" := VarVariant."Approval Status"::"Pending Approval";
            VarVariant.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure CancelUsersetupApprovalRequest(var VarVariant: Record "User Setup"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;

        DocType := DocType::Usersetup;


        if (VarVariant."Approval Status" = VarVariant."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"User Setup");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", VarVariant."User ID");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::Approved)) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Open;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(VarVariant."User ID"));
        end
        else
            Message(Text130);
    end;

    procedure OpenUsersetupApprovalRequest(var VarVariant: Record "User Setup"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (VarVariant."Approval Status" <> VarVariant."Approval Status"::Open)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Usersetup;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"User Setup");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(VarVariant."User ID"));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin
                    AppManagement.SendMail;
                    MailCreated := false;
                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::"Pending Approval")) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Open;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(VarVariant."User ID"));
        end
        else
            Message(Text130);
    end;

    procedure BlockUsersetupApprovalRequest(var VarVariant: Record "User Setup"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if VarVariant."Approval Status" <> VarVariant."Approval Status"::Block
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);


            DocType := DocType::Usersetup;


            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"User Setup");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(VarVariant."User ID"));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin
                    AppManagement.SendMail;
                    MailCreated := false;
                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::Block)) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Block;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text1382, VarVariant."User ID");
        end
        else
            Message(Text130);
    end;





    procedure SendAccountAppRequest(var VarVariant: Record "Account Application"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if VarVariant."Approval Status" <> VarVariant."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        case VarVariant."Application Type" of
            VarVariant."Application Type"::"Account Application":
                DocType := DocType::"Account Opening";
            VarVariant."Application Type"::"Account Changes":
                DocType := DocType::"Account Change";

        end;


        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Account Application");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            VarVariant.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", VarVariant."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not FindApproverAccountApp(VarVariant, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            FinishApprovalEntryAccountApp(VarVariant, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(VarVariant."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(VarVariant."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(VarVariant."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure FindApproverAccountApp(var VarVariant: Record "Account Application"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        case VarVariant."Application Type" of
            VarVariant."Application Type"::"Account Application":
                DocType := DocType::"Account Opening";
            VarVariant."Application Type"::"Account Changes":
                DocType := DocType::"Account Change";
        end;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Account Application",
                                  DocType, Format(VarVariant."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Account Application", DocType, Format(VarVariant."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Account Application", DocType, Format(VarVariant."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Account Application", DocType, Format(VarVariant."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure FinishApprovalEntryAccountApp(var VarVariant: Record "Account Application"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        case VarVariant."Application Type" of
            VarVariant."Application Type"::"Account Application":
                DocType := DocType::"Account Opening";
            VarVariant."Application Type"::"Account Changes":
                DocType := DocType::"Account Change";
        end;


        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Account Application");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", VarVariant."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat

                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;

                end else
                    if not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            VarVariant."Approval Status" := VarVariant."Approval Status"::"Pending Approval";
            VarVariant.Modify(true);
            MarkCrmApplicStatus(VarVariant."CRM Application No.", VarVariant."Approval Status");
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure CancelAccountAppApprovalRequest(var VarVariant: Record "Account Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (VarVariant."Approval Status" = VarVariant."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            case VarVariant."Application Type" of
                VarVariant."Application Type"::"Account Application":
                    DocType := DocType::"Account Opening";
                VarVariant."Application Type"::"Account Changes":
                    DocType := DocType::"Account Change";
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Account Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", VarVariant."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::Approved)) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Open;
            VarVariant.Modify(true);
            MarkCrmApplicStatus(VarVariant."CRM Application No.", VarVariant."Approval Status");
            if ShowMessage then
                Message(Text002, DocType, Format(VarVariant."No."));
        end
        else
            Message(Text130);
    end;


    procedure OpenAccountAppApprovalRequest(var VarVariant: Record "Account Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (VarVariant."Approval Status" = VarVariant."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);

            case VarVariant."Application Type" of
                VarVariant."Application Type"::"Account Application":
                    DocType := DocType::"Account Opening";
                VarVariant."Application Type"::"Account Changes":
                    DocType := DocType::"Account Change";
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Account Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(VarVariant."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Open;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::"Pending Approval")) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Open;
            VarVariant.Modify(true);
            MarkCrmApplicStatus(VarVariant."CRM Application No.", VarVariant."Approval Status");
            if ShowMessage then
                Message(Text131, DocType, Format(VarVariant."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnSendChangesAppRequest(var RecRef: Record "Member Changes"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        case RecRef."Document Type" of

            RecRef."Document Type"::"Member Change":
                DocType := DocType::"Member Changes";
            RecRef."Document Type"::"Account Activation":
                DocType := DocType::Activation;
            RecRef."Document Type"::"Kin Signatories":
                DocType := DocType::Signatory;
            RecRef."Document Type"::"Card Link":
                DocType := DocType::CardLink;
        end;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Member Changes");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverChanges(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryChanges(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverChanges(var RecRef: Record "Member Changes"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        case RecRef."Document Type" of

            RecRef."Document Type"::"Member Change":
                DocType := DocType::"Member Changes";
            RecRef."Document Type"::"Account Activation":
                DocType := DocType::Activation;
            RecRef."Document Type"::"Kin Signatories":
                DocType := DocType::Signatory;
            RecRef."Document Type"::"Card Link":
                DocType := DocType::CardLink;
        end;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Member Changes",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Member Changes", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Member Changes", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Member Changes", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryChanges(var RecRef: Record "Member Changes"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        case RecRef."Document Type" of

            RecRef."Document Type"::"Member Change":
                DocType := DocType::"Member Changes";
            RecRef."Document Type"::"Account Activation":
                DocType := DocType::Activation;
            RecRef."Document Type"::"Kin Signatories":
                DocType := DocType::Signatory;
            RecRef."Document Type"::"Card Link":
                DocType := DocType::CardLink;
        end;

        DocReleased := false;
        IsOpenStatusSet := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", Database::"Member Changes");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;

                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelChangesApprovalRequest(var RecRef: Record "Member Changes"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            case RecRef."Document Type" of

                RecRef."Document Type"::"Member Change":
                    DocType := DocType::"Member Changes";
                RecRef."Document Type"::"Account Activation":
                    DocType := DocType::Activation;
                RecRef."Document Type"::"Kin Signatories":
                    DocType := DocType::Signatory;
                RecRef."Document Type"::"Card Link":
                    DocType := DocType::CardLink;
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Member Changes");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenChangesApprovalRequest(var RecRef: Record "Member Changes"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            case RecRef."Document Type" of

                RecRef."Document Type"::"Member Change":
                    DocType := DocType::"Member Changes";
                RecRef."Document Type"::"Account Activation":
                    DocType := DocType::Activation;
                RecRef."Document Type"::"Kin Signatories":
                    DocType := DocType::Signatory;
                RecRef."Document Type"::"Card Link":
                    DocType := DocType::CardLink;
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Member Changes");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendRecordChangesAppRequest(var RecRef: Record "Mc Acc. Changes"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        DocType := DocType::AdviseChanges;

        RecRef.TestField("Responsibility Center");

        TemplateRec.SetRange(Enabled, true);
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Mc Acc. Changes");
        TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverRecordChanges(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryRecordChanges(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverRecordChanges(var RecRef: Record "Mc Acc. Changes"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        DocType := DocType::AdviseChanges;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Mc Acc. Changes",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Mc Acc. Changes", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Mc Acc. Changes", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Mc Acc. Changes", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryRecordChanges(var RecRef: Record "Mc Acc. Changes"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocType := DocType::AdviseChanges;
        DocReleased := false;
        IsOpenStatusSet := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Mc Acc. Changes");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;

                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelRecordChangesApprovalRequest(var RecRef: Record "Mc Acc. Changes"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::AdviseChanges;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Mc Acc. Changes");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenRecordChangesApprovalRequest(var RecRef: Record "Mc Acc. Changes"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::AdviseChanges;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Mc Acc. Changes");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnSendLoanApplicationApprovalRequest(var RecRef: Record "Loan Application"; PostInt: Integer): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        case RecRef."Approval Status" of
            RecRef."Approval Status"::Approved,
            RecRef."Approval Status"::"Pending Approval",
            RecRef."Approval Status"::Posted,
            RecRef."Approval Status"::Rejected:
                begin
                    exit(false);
                end;
        end;

        if not ApprovalSetup.Get() then
            Error(Text004);

        DocType := DocType::"Loan Application";
        RecRef.TestField("Responsibility Centre");

        TemplateRec.Reset();
        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange(Enabled, true);
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange("Table ID", Database::"Loan Application");
        if ApprovalSetup."Responsibility Center Required" then begin
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Centre");
        end;
        if ApprovalSetup."Set As Product" then begin
            TemplateRec.SetRange("Product Type", RecRef."Product Type");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverLoanApplication(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;
            OnFinishApprovalEntryLoanApplication(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    begin
                        Message(Text128, DocType, Format(RecRef."No."));
                    end;
                MessageType::AutomaticRelease:
                    begin
                        if PostInt = 1 then
                            Message(Text003, DocType, Format(RecRef."No."));
                    end;
                MessageType::RequiresApproval:
                    begin
                        Message(Text001, DocType, Format(RecRef."No."));
                    end;
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverLoanApplication(var RecRef: Record "Loan Application"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        Text001: Label 'Maximum Amount Cannot be ZERO for Approver %1';
    begin
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := RecRef."Approved Amount";
        ApprovalAmountLCY := RecRef."Approved Amount";
        AboveCreditLimitAmountLCY := RecRef."Approved Amount";
        DocType := DocType::"Loan Application";

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;

                        AppTemplate."Limit Type"::"Approval Limits":
                            begin
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                if not UserSetup."Unlimited Loan Amt Appr" and
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") or
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 then
                                    repeat
                                        UserSetup.SetRange("User ID", UserSetup."Approver ID");
                                        if not UserSetup.Find('-') then
                                            Error(Text005, UserId);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until UserSetup."Unlimited Loan Amt Appr" or
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") and
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) or
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;

                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end else begin

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SetCurrentKey("Sequence No.");
                            if AddApproversTemp.Find('-') then
                                repeat
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(Database::"Loan Application", DocType, RecRef."No.", '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                until AddApproversTemp.Next = 0
                            else
                                Error(Text027);

                        end;
                    end;
                end;
            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
            AppTemplate."Approval Type"::"Sales Pers./Purchaser":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Office/Group";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."Office/Group";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;

                        AppTemplate."Limit Type"::"Approval Limits":
                            begin
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                if not UserSetup."Unlimited Loan Amt Appr" and
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") or
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 then
                                    repeat
                                        UserSetup.SetRange("User ID", UserSetup."Approver ID");
                                        if not UserSetup.Find('-') then
                                            Error(Text005, UserId);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until UserSetup."Unlimited Loan Amt Appr" or
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") and
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) or
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;

                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::"Loan Application", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryLoanApplication(var RecRef: Record "Loan Application"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Application");
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Loan Application");
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;

                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef.Validate("Approval Status", RecRef."Approval Status"::"Pending Approval");
            RecRef.Modify(true);
            MarkCrmApplicStatus(RecRef."CRM Application No.", RecRef."Approval Status");
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelLoanApplicationApprovalRequest(var RecRef: Record "Loan Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::"Loan Application";
            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenLoanApplicationApprovalRequest(var RecRef: Record "Loan Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved) or (RecRef."Approval Status" = RecRef."Approval Status"::Deffered)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::"Loan Application";

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef."Loan Status" := RecRef."Loan Status"::Application;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnDefferLoanApplicationApprovalRequest(var RecRef: Record "Loan Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Open)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::"Loan Application";

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Application");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Deffered;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text132, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnSendLoansApprovalResquest(var RecRef: Record Loans): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Loans;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::Loans);
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Centre");
            TemplateRec.SetRange(TemplateRec."Responsibility Center", RecRef."Responsibility Centre");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverLoans(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryLoans(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverLoans(var RecRef: Record Loans; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        Text001: Label 'Maximum Amount Cannot be ZERO for Approver %1';
    begin
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := RecRef."Approved Amount";
        ApprovalAmountLCY := RecRef."Approved Amount";
        AboveCreditLimitAmountLCY := RecRef."Approved Amount";
        DocType := DocType::Loans;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end; /// End No Limits

                        AppTemplate."Limit Type"::"Approval Limits":
                            begin
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                if not UserSetup."Unlimited Loan Amt Appr" and
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") or
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 then
                                    repeat
                                        UserSetup.SetRange("User ID", UserSetup."Approver ID");
                                        if not UserSetup.Find('-') then
                                            Error(Text005, UserId);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until UserSetup."Unlimited Loan Amt Appr" or
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") and
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) or
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;   // End Approval Limit

                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;  //End Tiered Approval
                    end; // End Limit Type
                end;//  End Approver

            AppTemplate."Approval Type"::"Specific Approver":
                begin

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end else begin

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SetCurrentKey("Sequence No.");
                            if AddApproversTemp.Find('-') then
                                repeat
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::Loans, DocType, Format(RecRef."No."), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                until AddApproversTemp.Next = 0
                            else
                                Error(Text027);

                        end;
                    end; // End Limit Type
                end;//  End Blank
            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::Loans, DocType, RecRef."No.", '', ApprovalSetup, ApproverId,
                            AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        //End Group Approval
        end; /// End Approval Type
        exit(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSendLoanApplicationForApproval(LoanApplication: Record Loans; MessageID: Enum ApprovalMessageID)
    begin

    end;

    procedure OnFinishApprovalEntryLoans(var RecRef: Record Loans; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::Loans);
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::Loans);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
        OnSendLoanApplicationForApproval(RecRef, MessageID);
    end;


    procedure OnCancelLoansApprovalRequest(var RecRef: Record Loans; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Loans;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::Loans);
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenLoansApprovalRequest(var RecRef: Record Loans; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Loans;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::Loans);
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendBatchApprovalResquest(var RecRef: Record "Loan Disbursement Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Batch;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Loan Disbursement Header");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverBatch(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryBatch(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverBatch(var RecRef: Record "Loan Disbursement Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Batch;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Loan Disbursement Header",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Loan Disbursement Header", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Loan Disbursement Header", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Loan Disbursement Header", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryBatch(var RecRef: Record "Loan Disbursement Header"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Disbursement Header");
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::Batch);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelBatchApprovalRequest(var RecRef: Record "Loan Disbursement Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Batch;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Disbursement Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenBatchApprovalRequest(var RecRef: Record "Loan Disbursement Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Batch;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Loan Disbursement Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendCollateralRegtApprovalRequest(var RecRef: Record "Collateral Register"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        case RecRef."Document Type" of
            RecRef."Document Type"::Collateral:
                DocType := DocType::Collateral;
            RecRef."Document Type"::Document:
                DocType := DocType::Custody;
        end;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Collateral Register");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverCollateralRegt(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryCollateralRegt(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverCollateralRegt(var RecRef: Record "Collateral Register"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        case RecRef."Document Type" of
            RecRef."Document Type"::Collateral:
                DocType := DocType::Collateral;
            RecRef."Document Type"::Document:
                DocType := DocType::Custody;
        end;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Collateral Register",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Collateral Register", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Collateral Register", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Collateral Register", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryCollateralRegt(var RecRef: Record "Collateral Register"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;

        case RecRef."Document Type" of
            RecRef."Document Type"::Collateral:
                DocType := DocType::Collateral;
            RecRef."Document Type"::Document:
                DocType := DocType::Custody;
        end;

        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Collateral Register");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;

                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelCollateralRegtApprovalRequest(var RecRef: Record "Collateral Register"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            case RecRef."Document Type" of
                RecRef."Document Type"::Collateral:
                    DocType := DocType::Collateral;
                RecRef."Document Type"::Document:
                    DocType := DocType::Custody;
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Collateral Register");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenCollateralRegtApprovalRequest(var RecRef: Record "Collateral Register"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);

            case RecRef."Document Type" of
                RecRef."Document Type"::Collateral:
                    DocType := DocType::Collateral;
                RecRef."Document Type"::Document:
                    DocType := DocType::Custody;
            end;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Collateral Register");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnSendBillingApprovalResquest(var RecRef: Record "Interest Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Billing;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Interest Header");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverBilling(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryBilling(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverBilling(var RecRef: Record "Interest Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Billing;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Interest Header",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Interest Header", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Interest Header", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Interest Header", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryBilling(var RecRef: Record "Interest Header"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        DocType := DocType::Billing;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Interest Header");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelBillingApprovalRequest(var RecRef: Record "Interest Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Billing;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Interest Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenBillingApprovalRequest(var RecRef: Record "Interest Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Billing;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Interest Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendCheckoffApprovalRequest(var RecRef: Record "Checkoff Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Checkoff;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Checkoff Header");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Centre");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Centre");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverCheckoff(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryCheckoff(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverCheckoff(var RecRef: Record "Checkoff Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Checkoff;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Checkoff Header",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Checkoff Header", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Checkoff Header", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Checkoff Header", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryCheckoff(var RecRef: Record "Checkoff Header"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        DocType := DocType::Checkoff;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Checkoff Header");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelCheckoffApprovalRequest(var RecRef: Record "Checkoff Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Checkoff;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Checkoff Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenCheckoffApprovalRequest(var RecRef: Record "Checkoff Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Checkoff;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Checkoff Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendRecoveryHeaderApprovalRequest(var RecRef: Record "Recovery Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Recovery;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange(Enabled, true);
        TemplateRec.SetRange("Table ID", Database::"Recovery Header");
        TemplateRec.SetRange("Document Type", TemplateRec."Document Type"::Recovery);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Centre");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Centre");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverRecoveryHeader(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryRecoveryHeader(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverRecoveryHeader(var RecRef: Record "Recovery Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Recovery;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                DATABASE::"Recovery Header",
                                DocType, Format(RecRef."No."), '',
                                ApprovalSetup, ApproverId,
                                AppTemplate."Approval Code",
                                UserSetup,
                                ApprovalAmount,
                                ApprovalAmountLCY,
                                '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                        DATABASE::"Recovery Header", DocType, Format(RecRef."No."), '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                        ApprovalAmount, ApprovalAmountLCY,
                                        '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                            DATABASE::"Recovery Header", DocType, Format(RecRef."No."), '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                            DATABASE::"Recovery Header", DocType, Format(RecRef."No."), '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryRecoveryHeader(var RecRef: Record "Recovery Header"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        DocType := DocType::Recovery;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Recovery Header");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelRecoveryHeaderApprovalRequest(var RecRef: Record "Recovery Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Recovery;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Recovery Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenRecoveryHeaderApprovalRequest(var RecRef: Record "Recovery Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Recovery;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Recovery Header");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendCollateralCollectionApprovalRequest(var RecRef: Record "Security Collection"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Collection;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Security Collection");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverCollateralCollection(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryCollateralCollection(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverCollateralCollection(var RecRef: Record "Security Collection"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Collection;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                DATABASE::"Security Collection",
                                DocType, Format(RecRef."No."), '',
                                ApprovalSetup, ApproverId,
                                AppTemplate."Approval Code",
                                UserSetup,
                                ApprovalAmount,
                                ApprovalAmountLCY,
                                '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                        DATABASE::"Security Collection", DocType, Format(RecRef."No."), '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                        ApprovalAmount, ApprovalAmountLCY,
                                        '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                            DATABASE::"Security Collection", DocType, Format(RecRef."No."), '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                            DATABASE::"Security Collection", DocType, Format(RecRef."No."), '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryCollateralCollection(var RecRef: Record "Security Collection"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        DocType := DocType::Collection;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Security Collection");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    if not IsOpenStatusSet then begin
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelCollateralCollectionApprovalRequest(var RecRef: Record "Security Collection"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Collection;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Security Collection");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenCollateralCollectionApprovalRequest(var RecRef: Record "Security Collection"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Collection;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Security Collection");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendTellerTransactionApprovalRequest(var RecRef: Record "Teller Transaction"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::Teller;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Teller Transaction");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Centre");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Centre");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverTellerTransaction(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;
            OnFinishApprovalEntryTellerTransaction(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure OnFindApproverTellerTransaction(var RecRef: Record "Teller Transaction"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        Text001: Label 'Maximum Amount Cannot be ZERO for Approver %1';
    begin
        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := RecRef.Amount;
        ApprovalAmountLCY := RecRef.Amount;
        AboveCreditLimitAmountLCY := RecRef.Amount;
        DocType := DocType::Teller;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;

                        AppTemplate."Limit Type"::"Approval Limits":
                            begin
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                if not UserSetup."Unlimited Loan Amt Appr" and
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") or
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 then
                                    repeat
                                        UserSetup.SetRange("User ID", UserSetup."Approver ID");
                                        if not UserSetup.Find('-') then
                                            Error(Text005, UserId);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until UserSetup."Unlimited Loan Amt Appr" or
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") and
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) or
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;

                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::Tiered:
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.FindSet then
                                    repeat
                                        if (AddApproversTemp."Maximum Amount" = 0) or (AddApproversTemp."Maximum Amount" = 0) then
                                            Error(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        if (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") and
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") then
                                            MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end else begin

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SetCurrentKey("Sequence No.");
                            if AddApproversTemp.Find('-') then
                                repeat
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, Format(RecRef."No."), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                until AddApproversTemp.Next = 0
                            else
                                Error(Text027);

                        end;
                    end;
                end;
            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Teller Transaction", DocType, RecRef."No.", '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure OnFinishApprovalEntryTellerTransaction(var RecRef: Record "Teller Transaction"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Teller Transaction");
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::Teller);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Findset() then
            repeat

                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;

                end else
                    if not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure OnCancelTellerTransactionApprovalRequest(var RecRef: Record "Teller Transaction"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Teller;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Teller Transaction");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnOpenTellerTransactionApprovalRequest(var RecRef: Record "Teller Transaction"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Teller;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Teller Transaction");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure InitNextEntryNo(): Integer
    var
        RecRef: Record "Approval Entries";
        NextEntryNo: Integer;
    begin
        RecRef.LOCKTABLE;
        IF RecRef.FINDLAST THEN BEGIN
            NextEntryNo := RecRef."Entry No." + 1;
        END ELSE BEGIN
            NextEntryNo := 1;
        END;
        EXIT(NextEntryNo)
    end;

    procedure OnSendTreasuryTransactionApprovalRequest(VAR RecRef: Record "Treasury Cashier Transaction"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin

        TestSetup;
        if RecRef.Status <> RecRef.Status::Open then
            EXIT(FALSE);

        IF NOT ApprovalSetup.GET THEN
            ERROR(Text004);
        DocType := DocType::Treasury;

        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.SETRANGE("Table ID", DATABASE::"Treasury Cashier Transaction");
        TemplateRec.SETRANGE("Document Type", DocType);
        TemplateRec.SETRANGE(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" THEN BEGIN
            RecRef.TESTFIELD("Responsibility Center");
            TemplateRec.SETRANGE("Responsibility Center", RecRef."Responsibility Center");
        END;
        IF TemplateRec.FIND('-') THEN BEGIN
            REPEAT
                IF NOT OnFindApproverTreasuryTransaction(RecRef, ApprovalSetup, TemplateRec) THEN
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            OnFinishApprovalEntryTreasuryTransaction(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef.No));
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef.No));
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef.No));
            END;
        END ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure OnFindApproverTreasuryTransaction(VAR RecRef: Record "Treasury Cashier Transaction"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        ApprovalAmount := RecRef.Amount;
        ApprovalAmountLCY := RecRef.Amount;
        AboveCreditLimitAmountLCY := RecRef.Amount;
        DocType := DocType::Treasury;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                IF NOT UserSetup."Unlimited Loan Amt Appr" AND
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") OR
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited Loan Amt Appr" OR
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") AND
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) OR
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END ELSE BEGIN

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SETCURRENTKEY("Sequence No.");
                            IF AddApproversTemp.FIND('-') THEN
                                REPEAT
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, FORMAT(RecRef.No), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                UNTIL AddApproversTemp.NEXT = 0
                            ELSE
                                ERROR(Text027);

                        END;
                    END;
                END;
            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Treasury Cashier Transaction", DocType, RecRef.No, '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryTreasuryTransaction(VAR RecRef: Record "Treasury Cashier Transaction"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin
        DocReleased := FALSE;
        ApprovalEntry.INIT;
        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Treasury Cashier Transaction");
        ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::Treasury);
        ApprovalEntry.SETRANGE("Document No.", RecRef.No);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() THEN
            REPEAT
                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;
                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        //IF ApprovalSetup.Approvals THEN
                        //ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;
        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;

        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            RecRef.Status := RecRef.Status::Pending;
            RecRef.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END;
    end;

    procedure OnCancelTreasuryTransactionApprovalRequest(VAR RecRef: Record "Treasury Cashier Transaction"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin

        TestSetup;
        IF (RecRef.Status = RecRef.Status::Pending)
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::Treasury;
            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Treasury Cashier Transaction");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef.No);
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;

                IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef.Status = RecRef.Status::Approved)) THEN
                    RecRef.Status := RecRef.Status::Open;
                RecRef.MODIFY(TRUE);
            END;
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef.No));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnOpenTreasuryTransactionApprovalRequest(VAR RecRef: Record "Treasury Cashier Transaction"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef.Status = RecRef.Status::Approved)
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::Treasury;
            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Treasury Cashier Transaction");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef.No);
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

                IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef.Status = RecRef.Status::Approved)) THEN
                    RecRef.Status := RecRef.Status::Open;
                RecRef.MODIFY(TRUE);
            END;
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef.No));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendAccountTransferApprovalRequest(VAR RecRef: Record "Account Transfer Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin

        TestSetup;
        if RecRef.Status <> RecRef.Status::Open then
            EXIT(FALSE);

        IF NOT ApprovalSetup.GET THEN
            ERROR(Text004);
        DocType := DocType::"Account Transfer";
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.SETRANGE("Table ID", DATABASE::"Account Transfer Header");
        TemplateRec.SETRANGE("Document Type", DocType);
        TemplateRec.SETRANGE(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" THEN BEGIN
            RecRef.TESTFIELD("Responsibility Center");
            TemplateRec.SETRANGE("Responsibility Center", RecRef."Responsibility Center");
        END;
        IF TemplateRec.FIND('-') THEN BEGIN
            REPEAT
                IF NOT OnFindApproverAccountTransfer(RecRef, ApprovalSetup, TemplateRec) THEN
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            OnFinishApprovalEntryAccountTransfer(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            END;
        END ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure OnFindApproverAccountTransfer(VAR RecRef: Record "Account Transfer Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;
        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::"Account Transfer";

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                IF NOT UserSetup."Unlimited Loan Amt Appr" AND
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") OR
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited Loan Amt Appr" OR
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") AND
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) OR
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END ELSE BEGIN

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SETCURRENTKEY("Sequence No.");
                            IF AddApproversTemp.FIND('-') THEN
                                REPEAT
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, FORMAT(RecRef."No."), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                UNTIL AddApproversTemp.NEXT = 0
                            ELSE
                                ERROR(Text027);

                        END;
                    END;
                END;
            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Account Transfer Header", DocType, RecRef."No.", '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryAccountTransfer(VAR RecRef: Record "Account Transfer Header"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin
        DocReleased := FALSE;
        ApprovalEntry.INIT;
        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Account Transfer Header");
        ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::"Account Transfer");
        ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() THEN
            REPEAT
                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;
                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        //IF ApprovalSetup.Approvals THEN
                        //ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;
        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;

        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            RecRef.Status := RecRef.Status::"Pending Approval";
            RecRef.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END;
    end;

    procedure OnCancelAccountTransferApprovalRequest(VAR RecRef: Record "Account Transfer Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin

        TestSetup;
        IF (RecRef.Status = RecRef.Status::"Pending Approval")
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::"Account Transfer";
            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Account Transfer Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;


                IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef.Status = RecRef.Status::Approved)) THEN
                    RecRef.Status := RecRef.Status::Open;
                RecRef.MODIFY(TRUE);
            END;
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnOpenAccountTransferApprovalRequest(VAR RecRef: Record "Account Transfer Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef.Status = RecRef.Status::Approved)
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::"Account Transfer";
            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Account Transfer Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                UNTIL ApprovalEntry.NEXT = 0;
            END;

            RecRef.Status := RecRef.Status::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendBankersChequeApprovalRequest(VAR RecRef: Record "Bankers Cheque Application"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;

    begin

        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open THEN
            EXIT(FALSE);

        IF NOT ApprovalSetup.GET THEN
            ERROR(Text004);
        DocType := DocType::BCheque;

        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.SETRANGE("Table ID", DATABASE::"Bankers Cheque Application");
        TemplateRec.SETRANGE("Document Type", DocType);
        TemplateRec.SETRANGE(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" THEN BEGIN
            RecRef.TESTFIELD("Responsibility Centre");
            TemplateRec.SETRANGE("Responsibility Center", RecRef."Responsibility Centre");
        END;
        IF TemplateRec.FIND('-') THEN BEGIN
            REPEAT
                IF NOT OnFindApproverBankerCheque(RecRef, ApprovalSetup, TemplateRec) THEN
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            OnFinishApprovalEntryBankersCheque(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            END;
        END ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure OnFindApproverBankerCheque(VAR RecRef: Record "Bankers Cheque Application"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        ApprovalAmount := RecRef."Leaf Limit Amount";
        ApprovalAmountLCY := RecRef."Leaf Limit Amount";
        AboveCreditLimitAmountLCY := RecRef."Leaf Limit Amount";
        DocType := DocType::BCheque;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                IF NOT UserSetup."Unlimited Loan Amt Appr" AND
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") OR
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited Loan Amt Appr" OR
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") AND
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) OR
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END ELSE BEGIN

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SETCURRENTKEY("Sequence No.");
                            IF AddApproversTemp.FIND('-') THEN
                                REPEAT
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, FORMAT(RecRef."No."), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                UNTIL AddApproversTemp.NEXT = 0
                            ELSE
                                ERROR(Text027);

                        END;
                    END;
                END;
            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);

    end;

    procedure OnFinishApprovalEntryBankersCheque(VAR RecRef: Record "Bankers Cheque Application"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin
        DocReleased := FALSE;
        ApprovalEntry.INIT;

        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Bankers Cheque Application");
        ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::BCheque);
        ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() THEN
            REPEAT

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;

        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END;
    end;

    procedure OnCancelBankersChequeApprovalRequest(VAR RecRef: Record "Bankers Cheque Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var

        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);
            DocType := DocType::BCheque;
            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Bankers Cheque Application");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnOpenBankersChequeApprovalRequest(VAR RecRef: Record "Bankers Cheque Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        THEN BEGIN

            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);
            DocType := DocType::BCheque;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Bankers Cheque Application");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text131, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendStandingOrderApprovalRequest(VAR RecRef: Record "Standing Order Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open THEN
            EXIT(FALSE);

        IF NOT ApprovalSetup.GET THEN
            ERROR(Text004);

        DocType := DocType::STO;
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.SETRANGE("Table ID", DATABASE::"Standing Order Header");
        TemplateRec.SETRANGE("Document Type", DocType);
        TemplateRec.SETRANGE(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" THEN BEGIN
            RecRef.TESTFIELD("Responsibility Centre");
            TemplateRec.SETRANGE("Responsibility Center", RecRef."Responsibility Centre");
        END;
        IF TemplateRec.FIND('-') THEN BEGIN
            REPEAT
                IF NOT OnFindApproverStandingOrder(RecRef, ApprovalSetup, TemplateRec) THEN
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            OnFinishApprovalEntryStandingOrder(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            END;
        END ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure OnFindApproverStandingOrder(VAR RecRef: Record "Standing Order Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin
        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        ApprovalAmount := RecRef.Amount;
        ApprovalAmountLCY := RecRef.Amount;
        AboveCreditLimitAmountLCY := RecRef.Amount;
        DocType := DocType::STO;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                IF NOT UserSetup."Unlimited Loan Amt Appr" AND
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") OR
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited Loan Amt Appr" OR
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") AND
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) OR
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Bankers Cheque Application", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END ELSE BEGIN

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SETCURRENTKEY("Sequence No.");
                            IF AddApproversTemp.FIND('-') THEN
                                REPEAT
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, FORMAT(RecRef."No."), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                UNTIL AddApproversTemp.NEXT = 0
                            ELSE
                                ERROR(Text027);

                        END;
                    END;
                END;
            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Standing Order Header", DocType, RecRef."No.", '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryStandingOrder(VAR RecRef: Record "Standing Order Header"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin
        DocReleased := FALSE;
        ApprovalEntry.INIT;
        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Standing Order Header");
        ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::STO);
        ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() THEN
            REPEAT

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;

        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END;

    end;

    procedure OnCancelStandingOrderApprovalRequest(VAR RecRef: Record "Standing Order Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::STO;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Standing Order Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnOpenStandingOrderApprovalRequest(VAR RecRef: Record "Standing Order Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        THEN BEGIN

            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);
            DocType := DocType::STO;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Standing Order Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text131, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnStopStandingOrderApprovalRequest(VAR RecRef: Record "Standing Order Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);
            DocType := DocType::STO;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Standing Order Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Stopped;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text131, DocType, FORMAT(RecRef."No."));
        END ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendEFTApprovalRequest(VAR RecRef: Record "EFT Transfer Header"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open THEN
            EXIT(FALSE);

        if not ApprovalSetup.GET then
            ERROR(Text004);
        DocType := DocType::EFT;

        RecRef.TESTFIELD("Responsibility Centre");
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.SETRANGE(Enabled, true);
        TemplateRec.SETRANGE("Document Type", DocType);
        TemplateRec.SETRANGE("Table ID", Database::"EFT Transfer Header");
        TemplateRec.SETRANGE("Responsibility Center", RecRef."Responsibility Centre");
        IF TemplateRec.FindFirst() then begin
            repeat
                if not OnFindApproverEFT(RecRef, ApprovalSetup, TemplateRec) then
                    error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryEFT(RecRef, ApprovalSetup, MessageType);

            CASE MessageType OF
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            END;
        END ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure OnFindApproverEFT(VAR RecRef: Record "EFT Transfer Header"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin
        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        RecRef.CalcFields("Record Total");

        ApprovalAmount := RecRef."Record Total";
        ApprovalAmountLCY := RecRef."Record Total";
        AboveCreditLimitAmountLCY := RecRef."Record Total";
        DocType := DocType::EFT;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                IF NOT UserSetup."Unlimited Loan Amt Appr" AND
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") OR
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited Loan Amt Appr" OR
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") AND
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) OR
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;

                            END ELSE BEGIN

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SETCURRENTKEY("Sequence No.");
                            IF AddApproversTemp.FIND('-') THEN
                                REPEAT
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, FORMAT(RecRef."No."), '',
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                UNTIL AddApproversTemp.NEXT = 0
                            ELSE
                                ERROR(Text027);
                        END;
                    END;
                END;
            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"EFT Transfer Header", DocType, RecRef."No.", '',
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryEFT(VAR RecRef: Record "EFT Transfer Header"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin
        DocReleased := FALSE;
        ApprovalEntry.INIT;

        ApprovalEntry.SETRANGE("Table ID", DATABASE::"EFT Transfer Header");
        ApprovalEntry.SETRANGE("Document Type", ApprovalEntry."Document Type"::EFT);
        ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() THEN
            REPEAT

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;

        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END;
    end;

    procedure OnCancelEFTApprovalRequest(VAR RecRef: Record "EFT Transfer Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::EFT;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"EFT Transfer Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", RecRef."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN

                END;
            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnOpenEFTApprovalRequest(VAR RecRef: Record "EFT Transfer Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;

    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        THEN BEGIN

            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);
            DocType := DocType::EFT;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"EFT Transfer Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text131, DocType, FORMAT(RecRef."No."));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure InsertRejectionComment(AppEntry: Record "Approval Entries"; Comments: Text[100]; TableID: Integer)
    var
        CommentLine: Record "Apprvals. Comment Line";
        LineNo: Integer;
    begin
        if CommentLine.FindLast() then
            LineNo := CommentLine."Entry No." + 1
        else
            LineNo := 1;
        CommentLine.Init();
        CommentLine."Entry No." := LineNo;
        CommentLine."Table ID" := TableID;
        CommentLine."Document Type" := AppEntry."Document Type";
        CommentLine."Document No." := AppEntry."Document No.";
        CommentLine."Date and Time" := CreateDateTime(Today, Time);
        CommentLine."Record ID to Approve" := AppEntry."Record ID to Approve";
        CommentLine."Workflow Step Instance ID" := AppEntry."Workflow Step Instance ID";
        CommentLine."User ID" := UserId;
        CommentLine.Insert();
    end;

    procedure OnSendAccnoticeRequest(VAR RecRef: Record "Member withdrawal notice"): Boolean
    begin

        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        IF not ApprovalSetup.get then
            Error(Text004);

        DocType := DocType::notice;
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.Setrange("Table ID", DATABASE::"Member withdrawal notice");
        TemplateRec.Setrange("Document Type", DocType);
        TemplateRec.Setrange(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TESTFIELD("Responsibility Center");
            TemplateRec.Setrange(TemplateRec."Responsibility Center", RecRef."Responsibility Center");
        end;
        IF TemplateRec.FIND('-') then begin
            repeat
                IF not FindApproverAccNotice(RecRef, ApprovalSetup, TemplateRec) then
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            FinishApprovalEntryAccNotice(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                Messagetype::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                Messagetype::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                Messagetype::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            end;
        end ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure FindApproverAccnotice(VAR RecRef: Record "Member withdrawal notice"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;
        ApproverId := '';
        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Notice;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.Setrange("User ID", USERID);
                    IF not UserSetup.FIND('-') then
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Member withdrawal notice",
                                  DocType, FORMAT(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Member withdrawal notice", DocType, FORMAT(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Member withdrawal notice", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Member withdrawal notice", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;
        end;
        exit(true);
    end;

    procedure FinishApprovalEntryAccnotice(VAR RecRef: Record "Member withdrawal notice"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin

        DocReleased := false;
        IsOpenStatusSet := false;
        ApprovalEntry.INIT;
        DocType := DocType::Notice;
        ApprovalEntry.Setrange("Table ID", DATABASE::"Member withdrawal notice");
        ApprovalEntry.Setrange("Document Type", DocType);
        ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
        ApprovalEntry.Setrange(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() then
            repeat

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                end ELSE
                    IF not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := true;
                    end;
            UNTIL ApprovalEntry.NEXT = 0;
        IF not IsOpenStatusSet then begin
            ApprovalEntry.Setrange(Status);
            ApprovalEntry.FindLast();
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;
        IF DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end ELSE begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelAccNoticeApprovalRequest(VAR RecRef: Record "Member withdrawal notice"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            DocType := DocType::Notice;

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Member withdrawal notice");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.Modify(true);
                UNTIL ApprovalEntry.NEXT = 0;
            end;

            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OpenAccNoticeApprovalRequest(VAR RecRef: Record "Member withdrawal notice"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin
            DocType := DocType::Notice;

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Member withdrawal Notice");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                UNTIL ApprovalEntry.NEXT = 0;
            end;

            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef.Validate("Approval Status", RecRef."Approval Status"::Open);
            RecRef.Modify(true);

            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendAcclosureRequest(VAR RecRef: Record "Membership closure"): Boolean
    begin

        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            EXIT(FALSE);

        IF not ApprovalSetup.get then
            ERROR(Text004);

        DocType := DocType::"Account Closure";
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.Setrange("Table ID", DATABASE::"Membership closure");
        TemplateRec.Setrange("Document Type", DocType);
        TemplateRec.Setrange(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.Setrange(TemplateRec."Responsibility Center", RecRef."Responsibility Center");
        end;
        IF TemplateRec.FIND('-') then begin
            repeat
                IF not FindApproverAcclosure(RecRef, ApprovalSetup, TemplateRec) then
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            FinishApprovalEntryAcclosure(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                Messagetype::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                Messagetype::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                Messagetype::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            end;
        end ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure FindApproverAcclosure(VAR RecRef: Record "Membership closure"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.Reset();
        AddApproversTemp.DeleteAll();

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;
        ApproverId := '';
        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::"Account Closure";

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.Setrange("User ID", USERID);
                    IF not UserSetup.FIND('-') then
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Membership closure",
                                  DocType, FORMAT(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Membership closure", DocType, FORMAT(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Membership closure", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Membership closure", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;
        end;
        exit(true);
    end;

    procedure FinishApprovalEntryAcclosure(VAR RecRef: Record "Membership closure"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin

        DocReleased := FALSE;
        ApprovalEntry.INIT;
        DocType := DocType::"Account Closure";
        ApprovalEntry.Setrange("Table ID", DATABASE::"Membership closure");
        ApprovalEntry.Setrange("Document Type", DocType);
        ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
        ApprovalEntry.Setrange(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() then
            repeat

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                end ELSE
                    IF not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                    end;
            UNTIL ApprovalEntry.NEXT = 0;
        IF not IsOpenStatusSet then begin
            ApprovalEntry.Setrange(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;
        IF DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end ELSE begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelAcclosureApprovalRequest(VAR RecRef: Record "Membership closure"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            DocType := DocType::"Account Closure";

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Membership closure");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            IF ApprovalEntry.find('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.Modify(true);
                UNTIL ApprovalEntry.NEXT = 0;
            end;

            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OpenAcclosureApprovalRequest(VAR RecRef: Record "Membership closure"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin
            DocType := DocType::"Account Closure";


            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Membership closure");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                UNTIL ApprovalEntry.NEXT = 0;
            end;
            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendMobileRegtRequest(VAR RecRef: Record "Dsc Mobile Application"): Boolean
    begin

        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            EXIT(FALSE);

        IF not ApprovalSetup.get then
            ERROR(Text004);

        DocType := DocType::Mobile;
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.Setrange("Table ID", DATABASE::"Dsc Mobile Application");
        TemplateRec.Setrange("Document Type", DocType);
        TemplateRec.Setrange(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.Setrange(TemplateRec."Responsibility Center", RecRef."Responsibility Center");
        end;
        IF TemplateRec.FIND('-') then begin
            repeat
                IF not FindApproverMobileRegt(RecRef, ApprovalSetup, TemplateRec) then
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            FinishApprovalEntryMobileRegt(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                Messagetype::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                Messagetype::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                Messagetype::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            end;
        end ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure FindApproverMobileRegt(VAR RecRef: Record "Dsc Mobile Application"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.Reset();
        AddApproversTemp.DeleteAll();

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;
        ApproverId := '';
        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Mobile;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.Setrange("User ID", USERID);
                    IF not UserSetup.FIND('-') then
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Dsc Mobile Application",
                                  DocType, FORMAT(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Dsc Mobile Application", DocType, FORMAT(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Dsc Mobile Application", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Dsc Mobile Application", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;
        end;
        exit(true);
    end;

    procedure FinishApprovalEntryMobileRegt(VAR RecRef: Record "Dsc Mobile Application"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin

        DocReleased := FALSE;
        ApprovalEntry.INIT;
        DocType := DocType::Mobile;
        ApprovalEntry.Setrange("Table ID", DATABASE::"Dsc Mobile Application");
        ApprovalEntry.Setrange("Document Type", DocType);
        ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
        ApprovalEntry.Setrange(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() then
            repeat

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                end ELSE
                    IF not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                    end;
            UNTIL ApprovalEntry.NEXT = 0;
        IF not IsOpenStatusSet then begin
            ApprovalEntry.Setrange(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;
        IF DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end ELSE begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelMobileRegtApprovalRequest(VAR RecRef: Record "Dsc Mobile Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            DocType := DocType::Mobile;

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Dsc Mobile Application");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.Modify(true);
                UNTIL ApprovalEntry.NEXT = 0;
            end;

            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OpenMobileRegtApprovalRequest(VAR RecRef: Record "Dsc Mobile Application"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin
            DocType := DocType::Mobile;

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Dsc Mobile Application");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                UNTIL ApprovalEntry.NEXT = 0;
            end;
            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendDocSubstitutionRegtRequest(VAR RecRef: Record "Guarantors Substitution"): Boolean
    begin

        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            EXIT(FALSE);

        IF not ApprovalSetup.get then
            ERROR(Text004);

        DocType := DocType::Substitution;
        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.Setrange("Table ID", DATABASE::"Guarantors Substitution");
        TemplateRec.Setrange("Document Type", DocType);
        TemplateRec.Setrange(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Centre");
            TemplateRec.Setrange(TemplateRec."Responsibility Center", RecRef."Responsibility Centre");
        end;
        IF TemplateRec.FIND('-') then begin
            repeat
                IF not FindApproverMobileRegt(RecRef, ApprovalSetup, TemplateRec) then
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            FinishApprovalEntryMobileRegt(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                Messagetype::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."No."));
                Messagetype::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."No."));
                Messagetype::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."No."));
            end;
        end ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure FindApproverMobileRegt(VAR RecRef: Record "Guarantors Substitution"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin

        AddApproversTemp.Reset();
        AddApproversTemp.DeleteAll();

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;
        ApproverId := '';
        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::Substitution;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.Setrange("User ID", USERID);
                    IF not UserSetup.FIND('-') then
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Guarantors Substitution",
                                  DocType, FORMAT(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Guarantors Substitution", DocType, FORMAT(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Guarantors Substitution", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Guarantors Substitution", DocType, FORMAT(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                end;
        end;
        exit(true);
    end;

    procedure FinishApprovalEntryMobileRegt(VAR RecRef: Record "Guarantors Substitution"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin

        DocReleased := FALSE;
        ApprovalEntry.INIT;
        DocType := DocType::Substitution;
        ApprovalEntry.Setrange("Table ID", DATABASE::"Guarantors Substitution");
        ApprovalEntry.Setrange("Document Type", DocType);
        ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
        ApprovalEntry.Setrange(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() then
            repeat

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                end ELSE
                    IF not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                    end;
            UNTIL ApprovalEntry.NEXT = 0;
        IF not IsOpenStatusSet then begin
            ApprovalEntry.Setrange(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;
        IF DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end ELSE begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelDocSubstitutionRegtApprovalRequest(VAR RecRef: Record "Guarantors Substitution"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            DocType := DocType::Substitution;

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Guarantors Substitution");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.Modify(true);
                UNTIL ApprovalEntry.NEXT = 0;
            end;

            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OpenDocSubstitutionRegtApprovalRequest(VAR RecRef: Record "Guarantors Substitution"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin

        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin
            DocType := DocType::Substitution;

            IF not ApprovalSetup.get then
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Guarantors Substitution");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", FORMAT(RecRef."No."));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') then begin
                repeat
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                UNTIL ApprovalEntry.NEXT = 0;
            end;
            IF ManualCancel OR (not ManualCancel AND not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage then
                MESSAGE(Text002, DocType, FORMAT(RecRef."No."));
        end
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendPartialDisbApprovalRequest(VAR RecRef: Record "Partial Disbursement Schedule"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        IF RecRef."Approval Status" <> RecRef."Approval Status"::Open THEN
            EXIT(FALSE);

        IF NOT ApprovalSetup.GET THEN
            ERROR(Text004);
        DocType := DocType::Partial;

        TemplateRec.SETCURRENTKEY("Table ID", "Document Type", Enabled);
        TemplateRec.Setrange("Table ID", DATABASE::"Partial Disbursement Schedule");
        TemplateRec.Setrange("Document Type", DocType);
        TemplateRec.Setrange(Enabled, TRUE);
        IF ApprovalSetup."Responsibility Center Required" THEN BEGIN
            RecRef.TESTFIELD("Responsibility Centre");
            TemplateRec.Setrange("Responsibility Center", RecRef."Responsibility Centre");
        END;
        IF TemplateRec.FIND('-') THEN BEGIN
            REPEAT
                IF NOT OnFindApproverPartialDisb(RecRef, ApprovalSetup, TemplateRec) THEN
                    ERROR(Text010);
            UNTIL TemplateRec.NEXT = 0;
            OnFinishApprovalEntryPartialDisb(RecRef, ApprovalSetup, MessageType);
            CASE MessageType OF
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, FORMAT(RecRef."Entry No"));
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, FORMAT(RecRef."Entry No"));
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, FORMAT(RecRef."Entry No"));
            END;
        END ELSE
            ERROR(STRSUBSTNO(Text129, DocType));
    end;

    procedure OnFindApproverPartialDisb(VAR RecRef: Record "Partial Disbursement Schedule"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        InsertEntries: Boolean;
    begin
        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        ApprovalAmount := RecRef.Amount;
        ApprovalAmountLCY := RecRef.Amount;
        AboveCreditLimitAmountLCY := RecRef.Amount;
        DocType := DocType::Partial;

        CASE AppTemplate."Approval Type" OF

            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.Setrange("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                IF NOT UserSetup."Unlimited Loan Amt Appr" AND
                                       ((ApprovalAmountLCY > UserSetup."Loan Amt Approval Limit") OR
                                       (UserSetup."Loan Amt Approval Limit" = 0))
                                 THEN
                                    REPEAT
                                        UserSetup.Setrange("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited Loan Amt Appr" OR
                                     ((ApprovalAmountLCY <= UserSetup."Loan Amt Approval Limit") AND
                                     (UserSetup."Loan Amt Approval Limit" <> 0)) OR
                                     (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                        ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                        ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::Tiered:
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                ApprovalAmountLCY, '', AppTemplate, 0);
                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FINDSET THEN
                                    REPEAT
                                        IF (AddApproversTemp."Maximum Amount" = 0) OR (AddApproversTemp."Maximum Amount" = 0) THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");
                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND
                                           (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                            ApprovalAmountLCY, '', AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END ELSE BEGIN

                            CheckAddApprovers(AppTemplate);
                            AddApproversTemp.SETCURRENTKEY("Sequence No.");
                            IF AddApproversTemp.FIND('-') THEN
                                REPEAT
                                    ApproverId := AddApproversTemp."Approver ID";
                                    MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                                    ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                                    ApprovalAmountLCY, '', AppTemplate, 0);
                                UNTIL AddApproversTemp.NEXT = 0
                            ELSE
                                ERROR(Text027);

                        END;
                    END;
                END;
            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(DATABASE::"Partial Disbursement Schedule", DocType, Format(RecRef."Entry No"), RecRef."Loan No.",
                            ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                            ApprovalAmountLCY, '', AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryPartialDisb(VAR RecRef: Record "Partial Disbursement Schedule"; ApprovalSetup: Record "Approval Setup"; VAR MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
        ApprovalsMgtNotification: Codeunit "Approvals Mgt Notification";
    begin
        DocReleased := FALSE;
        ApprovalEntry.INIT;
        DocType := DocType::Partial;

        ApprovalEntry.Setrange("Table ID", DATABASE::"Partial Disbursement Schedule");
        ApprovalEntry.Setrange("Document Type", DocType);
        ApprovalEntry.Setrange("Document No.", Format(RecRef."Entry No"));
        ApprovalEntry.Setrange(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.Findset() THEN
            REPEAT

                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;

                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.Setrange(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;

        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END;
    end;

    procedure OnCancelPartialDisbApprovalRequest(VAR RecRef: Record "Partial Disbursement Schedule"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        THEN BEGIN
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            DocType := DocType::Partial;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Partial Disbursement Schedule");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", Format(RecRef."Entry No"));
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN

                END;
            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, Format(RecRef."Entry No"));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnOpenPartialDisbApprovalRequest(VAR RecRef: Record "Partial Disbursement Schedule"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        AppManagement: Codeunit "Approvals Mgt Notification";
        SendMail: Boolean;
        MailCreated: Boolean;

    begin
        TestSetup;
        IF (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        THEN BEGIN

            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);
            DocType := DocType::Partial;

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.Setrange("Table ID", DATABASE::"Partial Disbursement Schedule");
            ApprovalEntry.Setrange("Document Type", DocType);
            ApprovalEntry.Setrange("Document No.", Format(RecRef."Entry No"));
            ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;

                UNTIL ApprovalEntry.NEXT = 0;

            END;
            IF ManualCancel OR (NOT ManualCancel AND NOT (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) THEN
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text131, DocType, Format(RecRef."Entry No"));
        END
        ELSE
            MESSAGE(Text130);
    end;

    procedure OnSendPVApprovalRequest(var PaymentHeader: Record "Payments Header")
    begin
        TestSetup;
        if PaymentHeader."Approval Status" <> PaymentHeader."Approval Status"::Open then
            exit;
        if not ApprovalSetup.Get() then
            Error(Text004);

        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Normal then
            DocType := DocType::"Payment Voucher"
        else
            DocType := DocType::"Petty Cash";

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", Database::"Payments Header");
        TemplateRec.SetRange("Document Type", DocType);
        if ApprovalSetup."Responsibility Center Required" then begin
            PaymentHeader.TestField(PaymentHeader."Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", PaymentHeader."Responsibility Center");
        end;
        TemplateRec.SetRange(Enabled, true);
        if TemplateRec.Find('-') then begin
            Repeat
                if not OnFindApproverPV(PaymentHeader, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            Until TemplateRec.Next() = 0;
            OnFinishApprovalEntryPV(PaymentHeader, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, PaymentHeader."No.");
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, PaymentHeader."No.");
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, PaymentHeader."No.");
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverPV(PaymentHeader: Record "Payments Header"; ApprovalSetup: Record "Approval setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin
        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        PaymentHeader.CalcFields("Total Amount", PaymentHeader."Total Payment Amount LCY");
        ApprovalAmount := PaymentHeader."Total Amount";
        ApprovalAmountLCY := PaymentHeader."Total Payment Amount LCY";
        AboveCreditLimitAmountLCY := 0;

        if PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Normal then
            DocType := DocType::"Payment Voucher"
        else
            DocType := DocType::"Petty Cash";

        case AppTemplate."Approval Type" of
            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                  ApprovalAmount, ApprovalAmountLCY,
                                  PaymentHeader.Currency, AppTemplate, 0);
                                IF NOT UserSetup."Unlimited PV Amount Approval" AND
                                   ((ApprovalAmountLCY > UserSetup."PV Amount Approval Limit") OR
                                   (UserSetup."PV Amount Approval Limit" = 0))
                                THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited PV Amount Approval" OR
                                          ((ApprovalAmountLCY <= UserSetup."PV Amount Approval Limit") AND
                                          (UserSetup."PV Amount Approval Limit" <> 0)) OR
                                          (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                  ApprovalAmount, ApprovalAmountLCY,
                                  PaymentHeader.Currency, AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT

                                        IF AddApproversTemp."Maximum Amount" = 0 THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");

                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(
                                              DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                              ApprovalAmount, ApprovalAmountLCY,
                                              PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                              ApprovalAmount, ApprovalAmountLCY,
                              PaymentHeader.Currency, AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;

            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Payments Header", DocType, PaymentHeader."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                              ApprovalAmount, ApprovalAmountLCY,
                              PaymentHeader.Currency, AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryPV(PaymentHeader: Record "Payments Header"; ApprovalSetup: Record "Approval setup"; VAR MessageID: Enum ApprovalMessageID)
    Var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        IsOpenStatusSet := false;
        ApprovalEntry.Init();

        if PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Normal then
            DocType := DocType::"Payment Voucher"
        else
            DocType := DocType::"Petty Cash";

        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Payments Header");
        ApprovalEntry.SETRANGE("Document Type", DocType);
        ApprovalEntry.SETRANGE("Document No.", PaymentHeader."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.FINDSET() THEN
            REPEAT
                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;
                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;
        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            PaymentHeader."Approval Status" := PaymentHeader."Approval Status"::"Pending Approval";
            PaymentHeader.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END
    end;

    procedure OnCancelPVApprovalRequest(VAR PaymentHeader: Record "Payments Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin
        TestSetup;

        IF (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::"Pending Approval")
        THEN BEGIN
            IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Normal THEN
                DocType := DocType::"Payment Voucher"
            ELSE
                DocType := DocType::"Petty Cash";
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Payments Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", PaymentHeader."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                    IF ApprovalSetup.Cancellations AND ShowMessage AND SendMail THEN BEGIN
                        // AppManagement.SendPVCancellationsMail(PaymentHeader,ApprovalEntry);
                        MailCreated := TRUE;
                        SendMail := FALSE;
                    END;
                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;
            END;

            IF ManualCancel OR (NOT ManualCancel AND NOT (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::Approved)) THEN
                PaymentHeader."Approval Status" := PaymentHeader."Approval Status"::Open;
            PaymentHeader.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, PaymentHeader."No.");
        end
        else
            Message(Text130);
    end;

    procedure OnOpenPVApprovalRequest(VAR PaymentHeader: Record "Payments Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin
        TestSetup;

        IF (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::Approved)
        THEN BEGIN
            IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Normal THEN
                DocType := DocType::"Payment Voucher"
            ELSE
                DocType := DocType::"Petty Cash";
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Payments Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", PaymentHeader."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                    IF ApprovalSetup.Cancellations AND ShowMessage AND SendMail THEN BEGIN
                        // AppManagement.SendPVCancellationsMail(PaymentHeader,ApprovalEntry);
                        MailCreated := TRUE;
                        SendMail := FALSE;
                    END;
                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;
            END;

            IF ManualCancel OR (NOT ManualCancel AND NOT (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::"Pending Approval")) THEN
                PaymentHeader."Approval Status" := PaymentHeader."Approval Status"::Open;
            PaymentHeader.MODIFY(TRUE);
            if ShowMessage then
                Message(Text002, DocType, PaymentHeader."No.");
        end
        else
            Message(Text130);
    end;

    procedure OnSendImprestApprovalRequest(var PaymentHeader: Record "Imprest Header")
    begin
        TestSetup;

        if PaymentHeader."Approval Status" <> PaymentHeader."Approval Status"::Open then
            exit;

        if not ApprovalSetup.Get() then
            Error(Text004);

        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Imprest THEN
            DocType := DocType::Imprest
        ELSE
            DocType := DocType::Surrender;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Imprest Header");
        TemplateRec.SetRange("Document Type", DocType);
        if ApprovalSetup."Responsibility Center Required" then begin
            PaymentHeader.TestField(PaymentHeader."Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", PaymentHeader."Responsibility Center");
        end;
        TemplateRec.SetRange(Enabled, true);
        if TemplateRec.Find('-') then begin
            Repeat
                if not OnFindApproverImprest(PaymentHeader, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            Until TemplateRec.Next() = 0;
            OnFinishApprovalEntryImprest(PaymentHeader, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, PaymentHeader."No.");
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, PaymentHeader."No.");
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, PaymentHeader."No.");
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverImprest(PaymentHeader: Record "Imprest Header"; ApprovalSetup: Record "Approval setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin
        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        PaymentHeader.CalcFields("Total Amount", PaymentHeader."Total Payment Amount LCY");
        ApprovalAmount := PaymentHeader."Total Amount";
        ApprovalAmountLCY := PaymentHeader."Total Payment Amount LCY";
        AboveCreditLimitAmountLCY := 0;

        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Imprest THEN
            DocType := DocType::Imprest
        ELSE
            DocType := DocType::Surrender;

        case AppTemplate."Approval Type" of
            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                  PaymentHeader.Currency, AppTemplate, 0);
                                IF NOT UserSetup."Unlimited PV Amount Approval" AND
                                   ((ApprovalAmountLCY > UserSetup."PV Amount Approval Limit") OR
                                   (UserSetup."PV Amount Approval Limit" = 0))
                                THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited PV Amount Approval" OR
                                          ((ApprovalAmountLCY <= UserSetup."PV Amount Approval Limit") AND
                                          (UserSetup."PV Amount Approval Limit" <> 0)) OR
                                          (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                  PaymentHeader.Currency, AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT

                                        IF AddApproversTemp."Maximum Amount" = 0 THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");

                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(
                                              DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                              PaymentHeader.Currency, AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              PaymentHeader.Currency, AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;

            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Imprest Header", DocType, PaymentHeader."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              PaymentHeader.Currency, AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        EXIT(TRUE);
    end;

    procedure OnFinishApprovalEntryImprest(PaymentHeader: Record "Imprest Header"; ApprovalSetup: Record "Approval setup"; VAR MessageID: Enum ApprovalMessageID)
    Var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        IsOpenStatusSet := false;
        ApprovalEntry.Init();

        IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Imprest THEN
            DocType := DocType::Imprest
        ELSE
            DocType := DocType::Surrender;

        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Imprest Header");
        ApprovalEntry.SETRANGE("Document Type", DocType);
        ApprovalEntry.SETRANGE("Document No.", PaymentHeader."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.FINDSET() THEN
            REPEAT
                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;
                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;
        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            PaymentHeader."Approval Status" := PaymentHeader."Approval Status"::"Pending Approval";
            PaymentHeader.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END
    end;

    procedure OnCancelImprestApprovalRequest(VAR PaymentHeader: Record "Imprest Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin
        TestSetup;

        IF (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::"Pending Approval")
        THEN BEGIN
            IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Imprest THEN
                DocType := DocType::Imprest
            ELSE
                DocType := DocType::Surrender;
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Imprest Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", PaymentHeader."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                    IF ApprovalSetup.Cancellations AND ShowMessage AND SendMail THEN BEGIN
                        // AppManagement.SendPVCancellationsMail(PaymentHeader,ApprovalEntry);
                        MailCreated := TRUE;
                        SendMail := FALSE;
                    END;
                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;
            END;

            IF ManualCancel OR (NOT ManualCancel AND NOT (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::Approved)) THEN
                PaymentHeader."Approval Status" := PaymentHeader."Approval Status"::"Pending Approval";
            PaymentHeader.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, PaymentHeader."No.");
        end
        else
            MESSAGE(Text130);
    end;

    procedure OnOpenImprestApprovalRequest(VAR PaymentHeader: Record "Imprest Header"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin
        TestSetup;

        IF (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::Approved)
        THEN BEGIN
            IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Imprest THEN
                DocType := DocType::Imprest
            ELSE
                DocType := DocType::Surrender;
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Imprest Header");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", PaymentHeader."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                    IF ApprovalSetup.Cancellations AND ShowMessage AND SendMail THEN BEGIN
                        // AppManagement.SendPVCancellationsMail(PaymentHeader,ApprovalEntry);
                        MailCreated := TRUE;
                        SendMail := FALSE;
                    END;
                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;
            END;

            IF ManualCancel OR (NOT ManualCancel AND NOT (PaymentHeader."Approval Status" = PaymentHeader."Approval Status"::"Pending Approval")) THEN
                PaymentHeader."Approval Status" := PaymentHeader."Approval Status"::Open;
            PaymentHeader.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, PaymentHeader."No.");
        end
        else
            MESSAGE(Text130);
    end;

    procedure OnSendInterBankApprovalRequest(var InterbankHeader: Record "Interbank Transfer")
    begin
        TestSetup;

        if InterbankHeader."Approval Status" <> InterbankHeader."Approval Status"::Open then
            exit;

        if not ApprovalSetup.Get() then
            Error(Text004);
        DocType := DocType::Interbank;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", Database::"Interbank Transfer");
        TemplateRec.SetRange("Document Type", DocType);
        if ApprovalSetup."Responsibility Center Required" then begin
            InterbankHeader.TestField(InterbankHeader."Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", InterbankHeader."Responsibility Center");
        end;
        TemplateRec.SetRange(Enabled, true);
        if TemplateRec.Find('-') then begin
            Repeat
                if not OnFindApproverInterBank(InterbankHeader, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            Until TemplateRec.Next() = 0;
            OnFinishApprovalEntryInterBank(InterbankHeader, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    MESSAGE(Text128, DocType, InterbankHeader."No.");
                MessageType::AutomaticRelease:
                    MESSAGE(Text003, DocType, InterbankHeader."No.");
                MessageType::RequiresApproval:
                    MESSAGE(Text001, DocType, InterbankHeader."No.");
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverInterBank(InterbankHeader: Record "Interbank Transfer"; ApprovalSetup: Record "Approval setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin
        AddApproversTemp.RESET;
        AddApproversTemp.DELETEALL;

        InterbankHeader.CalcFields("Total Amount");
        ApprovalAmount := InterbankHeader."Amount Recieved";
        ApprovalAmountLCY := InterbankHeader."Amount Recieved LCY";
        AboveCreditLimitAmountLCY := 0;

        DocType := DocType::Interbank;

        case AppTemplate."Approval Type" of
            AppTemplate."Approval Type"::"Direct Approver":
                BEGIN
                    UserSetup.SETRANGE("User ID", USERID);
                    IF NOT UserSetup.FIND('-') THEN
                        ERROR(Text005, USERID);

                    CASE AppTemplate."Limit Type" OF
                        AppTemplate."Limit Type"::"Approval Limits":
                            BEGIN
                                ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                  InterbankHeader."Currency Code", AppTemplate, 0);
                                IF NOT UserSetup."Unlimited PV Amount Approval" AND
                                   ((ApprovalAmountLCY > UserSetup."PV Amount Approval Limit") OR
                                   (UserSetup."PV Amount Approval Limit" = 0))
                                THEN
                                    REPEAT
                                        UserSetup.SETRANGE("User ID", UserSetup."Approver ID");
                                        IF NOT UserSetup.FIND('-') THEN
                                            ERROR(Text005, USERID);
                                        ApproverId := UserSetup."User ID";
                                        MakeApprovalEntry(
                                          Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          InterbankHeader."Currency Code", AppTemplate, 0);
                                    UNTIL UserSetup."Unlimited PV Amount Approval" OR
                                          ((ApprovalAmountLCY <= UserSetup."PV Amount Approval Limit") AND
                                          (UserSetup."PV Amount Approval Limit" <> 0)) OR
                                          (UserSetup."User ID" = UserSetup."Approver ID");

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          InterbankHeader."Currency Code", AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::"No Limits":
                            BEGIN
                                ApproverId := UserSetup."Approver ID";
                                IF ApproverId = '' THEN
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                                  ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                  InterbankHeader."Currency Code", AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                          InterbankHeader."Currency Code", AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;

                        AppTemplate."Limit Type"::Tiered:
                            BEGIN

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SETCURRENTKEY("Sequence No.");
                                IF AddApproversTemp.FIND('-') THEN
                                    REPEAT

                                        IF AddApproversTemp."Maximum Amount" = 0 THEN
                                            ERROR(Text001, AddApproversTemp."Approver ID");

                                        ApproverId := AddApproversTemp."Approver ID";
                                        IF (ApprovalAmountLCY >= AddApproversTemp."Minimum Amount") AND (ApprovalAmountLCY <= AddApproversTemp."Maximum Amount") THEN
                                            MakeApprovalEntry(
                                              Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                                              InterbankHeader."Currency Code", AppTemplate, 0);
                                    UNTIL AddApproversTemp.NEXT = 0;
                            END;
                    END;
                END;

            AppTemplate."Approval Type"::"Specific Approver":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              InterbankHeader."Currency Code", AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;

            AppTemplate."Approval Type"::"Workflow User Group":
                BEGIN
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SETCURRENTKEY("Sequence No.");
                    IF AddApproversTemp.FIND('-') THEN
                        REPEAT
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Interbank Transfer", DocType, InterbankHeader."No.", '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount, ApprovalAmountLCY,
                              InterbankHeader."Currency Code", AppTemplate, 0);
                        UNTIL AddApproversTemp.NEXT = 0
                    ELSE
                        ERROR(Text027);
                END;
        END;
        exit(true);
    end;

    procedure OnFinishApprovalEntryInterBank(InterbankHeader: Record "Interbank Transfer"; ApprovalSetup: Record "Approval setup"; VAR MessageID: Enum ApprovalMessageID)
    Var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        IsOpenStatusSet := false;
        ApprovalEntry.Init();
        DocType := DocType::Interbank;

        ApprovalEntry.SETRANGE("Table ID", Database::"Interbank Transfer");
        ApprovalEntry.SETRANGE("Document Type", DocType);
        ApprovalEntry.SETRANGE("Document No.", InterbankHeader."No.");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Created);
        IF ApprovalEntry.FINDSET() THEN
            REPEAT
                IF ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" THEN BEGIN
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.MODIFY;
                END ELSE
                    IF NOT IsOpenStatusSet THEN BEGIN
                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.MODIFY;
                        IsOpenStatusSet := TRUE;
                    END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF NOT IsOpenStatusSet THEN BEGIN
            ApprovalEntry.SETRANGE(Status);
            ApprovalEntry.FINDLAST;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        END;
        IF DocReleased THEN BEGIN
            MessageID := MessageID::AutomaticRelease;
        END ELSE BEGIN
            InterbankHeader."Approval Status" := InterbankHeader."Approval Status"::"Pending Approval";
            InterbankHeader.MODIFY(TRUE);
            MessageID := MessageID::RequiresApproval;
        END
    end;

    procedure OnCancelInterBankApprovalRequest(VAR InterbankHeader: Record "Interbank Transfer"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin
        TestSetup;

        IF (InterbankHeader."Approval Status" = InterbankHeader."Approval Status"::"Pending Approval")
        THEN BEGIN

            DocType := DocType::Interbank;
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", Database::"Interbank Transfer");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", InterbankHeader."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                    IF ApprovalSetup.Cancellations AND ShowMessage AND SendMail THEN BEGIN
                        // AppManagement.SendPVCancellationsMail(InterbankHeader,ApprovalEntry);
                        MailCreated := TRUE;
                        SendMail := FALSE;
                    END;
                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;
            END;

            IF ManualCancel OR (NOT ManualCancel AND NOT (InterbankHeader."Approval Status" = InterbankHeader."Approval Status"::Approved)) THEN
                InterbankHeader."Approval Status" := InterbankHeader."Approval Status"::"Pending Approval";
            InterbankHeader.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, InterbankHeader."No.");
        end
        else
            MESSAGE(Text130);
    end;

    procedure OnOpenInterBankApprovalRequest(VAR InterbankHeader: Record "Interbank Transfer"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    begin
        TestSetup;

        IF (InterbankHeader."Approval Status" = InterbankHeader."Approval Status"::Approved)
        THEN BEGIN

            DocType := DocType::Interbank;
            IF NOT ApprovalSetup.GET THEN
                ERROR(Text004);

            ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SETRANGE("Table ID", Database::"Interbank Transfer");
            ApprovalEntry.SETRANGE("Document Type", DocType);
            ApprovalEntry.SETRANGE("Document No.", InterbankHeader."No.");
            ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := FALSE;
            IF ApprovalEntry.FIND('-') THEN BEGIN
                REPEAT
                    IF (ApprovalEntry.Status = ApprovalEntry.Status::Open) OR
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) THEN
                        SendMail := TRUE;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                    ApprovalEntry."Last Modified By User ID" := USERID;
                    ApprovalEntry.MODIFY;
                    IF ApprovalSetup.Cancellations AND ShowMessage AND SendMail THEN BEGIN
                        // AppManagement.SendPVCancellationsMail(InterbankHeader,ApprovalEntry);
                        MailCreated := TRUE;
                        SendMail := FALSE;
                    END;
                UNTIL ApprovalEntry.NEXT = 0;
                IF MailCreated THEN BEGIN
                    AppManagement.SendMail;
                    MailCreated := FALSE;
                END;
            END;

            IF ManualCancel OR (NOT ManualCancel AND NOT (InterbankHeader."Approval Status" = InterbankHeader."Approval Status"::"Pending Approval")) THEN
                InterbankHeader."Approval Status" := InterbankHeader."Approval Status"::Open;
            InterbankHeader.MODIFY(TRUE);
            IF ShowMessage THEN
                MESSAGE(Text002, DocType, InterbankHeader."No.");
        end
        else
            MESSAGE(Text130);
    end;

    procedure SendAccountBankingAppRequest(var VarVariant: Record "Account Banking"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if VarVariant."Approval Status" <> VarVariant."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);
        DocType := DocType::PostAccount;

        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", DATABASE::"Account Banking");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            VarVariant.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", VarVariant."Responsibility Center");
        end;
        if TemplateRec.Find('-') then begin
            repeat
                if not FindApproverAccountBanking(VarVariant, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            FinishApprovalEntryAccountBanking(VarVariant, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(VarVariant."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(VarVariant."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(VarVariant."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;


    procedure FindApproverAccountBanking(var VarVariant: Record "Account Banking"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;
        DocType := DocType::PostAccount;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  DATABASE::"Account Banking",
                                  DocType, Format(VarVariant."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          DATABASE::"Account Banking", DocType, Format(VarVariant."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Account Banking", DocType, Format(VarVariant."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              DATABASE::"Account Banking", DocType, Format(VarVariant."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;


    procedure FinishApprovalEntryAccountBanking(var VarVariant: Record "Account Banking"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", DATABASE::"Account Banking");
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::PostAccount);
        ApprovalEntry.SetRange("Document No.", VarVariant."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.FindSet() then
            repeat

                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;

                end else
                    if not IsOpenStatusSet then begin

                        ApprovalEntry.Status := ApprovalEntry.Status::Open;
                        ApprovalEntry.Modify;
                        IsOpenStatusSet := true;
                        //  IF ApprovalSetup.Approvals THEN
                        //   ApprovalsMgtNotification.SendJVApprovalsMail(MembClosure,ApprovalEntry);
                    end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            VarVariant."Approval Status" := VarVariant."Approval Status"::"Pending Approval";
            VarVariant.Modify(true);

            MessageID := MessageID::RequiresApproval;
        end;
    end;


    procedure CancelAccountBankingAppApprovalRequest(var VarVariant: Record "Account Banking"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (VarVariant."Approval Status" = VarVariant."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::PostAccount;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Account Banking");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", VarVariant."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat

                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::Approved)) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Open;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(VarVariant."No."));
        end
        else
            Message(Text130);
    end;


    procedure OpenAccountBankingAppApprovalRequest(var VarVariant: Record "Account Banking"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (VarVariant."Approval Status" = VarVariant."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::PostAccount;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", DATABASE::"Account Banking");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(VarVariant."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Open;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;
                if MailCreated then begin

                end;
            end;
            if ManualCancel or (not ManualCancel and not (VarVariant."Approval Status" = VarVariant."Approval Status"::"Pending Approval")) then
                VarVariant."Approval Status" := VarVariant."Approval Status"::Open;
            VarVariant.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(VarVariant."No."));
        end
        else
            Message(Text130);
    end;


    procedure OnSendHrEmployeeAppRequest(var RecRef: Record "HR Employees"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        DocType := DocType::Employee;
        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", Database::"HR Employees");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Centre");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Centre");
        end;

        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverHrEmployee(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryHrEmployee(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverHrEmployee(var RecRef: Record "HR Employees"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        DocType := DocType::Employee;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  Database::"HR Employees",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          Database::"HR Employees", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"HR Employees", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"HR Employees", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;

    procedure OnFinishApprovalEntryHrEmployee(var RecRef: Record "HR Employees"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocType := DocType::Employee;

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", Database::"HR Employees");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Find('-') then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    DocReleased := false;
                if not IsOpenStatusSet then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Open;
                    ApprovalEntry.Modify;
                    IsOpenStatusSet := true;
                end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelHrEmployeeApprovalRequest(var RecRef: Record "HR Employees"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Employee;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"HR Employees");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnOpenHrEmployeeApprovalRequest(var RecRef: Record "HR Employees"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Employee;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"HR Employees");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnSendPayrollRequest(var RecRef: Record "Payroll Requests"): Boolean
    var
        TemplateRec: Record "Approval Template";
        ApprovalSetup: Record "Approval Setup";
        MessageType: Enum ApprovalMessageID;
    begin
        TestSetup;
        if RecRef."Approval Status" <> RecRef."Approval Status"::Open then
            exit(false);

        if not ApprovalSetup.Get then
            Error(Text004);

        DocType := DocType::Employee;
        TemplateRec.SetCurrentKey("Table ID", "Document Type", Enabled);
        TemplateRec.SetRange("Table ID", Database::"Payroll Requests");
        TemplateRec.SetRange("Document Type", DocType);
        TemplateRec.SetRange(Enabled, true);
        if ApprovalSetup."Responsibility Center Required" then begin
            RecRef.TestField("Responsibility Center");
            TemplateRec.SetRange("Responsibility Center", RecRef."Responsibility Center");
        end;

        if TemplateRec.Find('-') then begin
            repeat
                if not OnFindApproverPayrollRequest(RecRef, ApprovalSetup, TemplateRec) then
                    Error(Text010);
            until TemplateRec.Next = 0;

            OnFinishApprovalEntryPayrollRequest(RecRef, ApprovalSetup, MessageType);
            case MessageType of
                MessageType::AutomaticPrePayment:
                    Message(Text128, DocType, Format(RecRef."No."));
                MessageType::AutomaticRelease:
                    Message(Text003, DocType, Format(RecRef."No."));
                MessageType::RequiresApproval:
                    Message(Text001, DocType, Format(RecRef."No."));
            end;
        end else
            Error(StrSubstNo(Text129, DocType));
    end;

    procedure OnFindApproverPayrollRequest(var RecRef: Record "Payroll Requests"; ApprovalSetup: Record "Approval Setup"; AppTemplate: Record "Approval Template"): Boolean
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[100];
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
    begin

        AddApproversTemp.Reset;
        AddApproversTemp.DeleteAll;

        ApprovalAmount := 0;
        ApprovalAmountLCY := 0;

        AboveCreditLimitAmountLCY := 0;

        DocType := DocType::Employee;

        case AppTemplate."Approval Type" of

            AppTemplate."Approval Type"::"Direct Approver":
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if not UserSetup.Find('-') then
                        Error(Text005, UserId);

                    case AppTemplate."Limit Type" of
                        AppTemplate."Limit Type"::"No Limits":
                            begin
                                ApproverId := UserSetup."Approver ID";
                                if ApproverId = '' then
                                    ApproverId := UserSetup."User ID";
                                MakeApprovalEntry(
                                  Database::"Payroll Requests",
                                  DocType, Format(RecRef."No."), '',
                                  ApprovalSetup, ApproverId,
                                  AppTemplate."Approval Code",
                                  UserSetup,
                                  ApprovalAmount,
                                  ApprovalAmountLCY,
                                  '', AppTemplate, 0);

                                CheckAddApprovers(AppTemplate);
                                AddApproversTemp.SetCurrentKey("Sequence No.");
                                if AddApproversTemp.Find('-') then
                                    repeat
                                        ApproverId := AddApproversTemp."Approver ID";
                                        MakeApprovalEntry(
                                          Database::"Payroll Requests", DocType, Format(RecRef."No."), '',
                                          ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup,
                                          ApprovalAmount, ApprovalAmountLCY,
                                          '', AppTemplate, 0);
                                    until AddApproversTemp.Next = 0;
                            end;
                    end;
                end;

            AppTemplate."Approval Type"::"Specific Approver":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Payroll Requests", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;

            AppTemplate."Approval Type"::"Workflow User Group":
                begin
                    CheckAddApprovers(AppTemplate);
                    AddApproversTemp.SetCurrentKey("Sequence No.");
                    if AddApproversTemp.Find('-') then
                        repeat
                            ApproverId := AddApproversTemp."Approver ID";
                            MakeApprovalEntry(
                              Database::"Payroll Requests", DocType, Format(RecRef."No."), '',
                              ApprovalSetup, ApproverId, AppTemplate."Approval Code", UserSetup, ApprovalAmount,
                              ApprovalAmountLCY, '', AppTemplate, 0);
                        until AddApproversTemp.Next = 0
                    else
                        Error(Text027);
                end;
        end;
        exit(true);
    end;

    procedure OnFinishApprovalEntryPayrollRequest(var RecRef: Record "Payroll Requests"; ApprovalSetup: Record "Approval Setup"; var MessageID: Enum ApprovalMessageID)
    var
        DocReleased: Boolean;
        ApprovalEntry: Record "Approval Entries";
    begin

        DocType := DocType::Employee;

        DocReleased := false;
        ApprovalEntry.Init;

        ApprovalEntry.SetRange("Table ID", Database::"Payroll Requests");
        ApprovalEntry.SetRange("Document Type", DocType);
        ApprovalEntry.SetRange("Document No.", RecRef."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.Find('-') then
            repeat
                if ApprovalEntry."Sender ID" = ApprovalEntry."Approver ID" then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry.Modify;
                end else
                    DocReleased := false;
                if not IsOpenStatusSet then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Open;
                    ApprovalEntry.Modify;
                    IsOpenStatusSet := true;
                end;
            until ApprovalEntry.Next = 0;

        if not IsOpenStatusSet then begin
            ApprovalEntry.SetRange(Status);
            ApprovalEntry.FindLast;
            DocReleased := ApproveApprovalRequest(ApprovalEntry);
        end;

        if DocReleased then begin
            MessageID := MessageID::AutomaticRelease;
        end else begin
            RecRef."Approval Status" := RecRef."Approval Status"::"Pending Approval";
            RecRef.Modify(true);
            MessageID := MessageID::RequiresApproval;
        end;
    end;

    procedure OnCancelPayrollApprovalRequest(var RecRef: Record "Payroll Requests"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")
        then begin
            if not ApprovalSetup.Get then
                Error(Text004);

            DocType := DocType::Employee;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"Payroll Requests");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", RecRef."No.");
            ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;

                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::Approved)) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text002, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;

    procedure OnOpenPayrollApprovalRequest(var RecRef: Record "Payroll Requests"; ShowMessage: Boolean; ManualCancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entries";
        ApprovalSetup: Record "Approval Setup";
        SendMail: Boolean;
        MailCreated: Boolean;
    begin
        TestSetup;
        if (RecRef."Approval Status" = RecRef."Approval Status"::Approved)
        then begin

            if not ApprovalSetup.Get then
                Error(Text004);
            DocType := DocType::Employee;

            ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"Payroll Requests");
            ApprovalEntry.SetRange("Document Type", DocType);
            ApprovalEntry.SetRange("Document No.", Format(RecRef."No."));
            ApprovalEntry.SetFilter(Status, '%1', ApprovalEntry.Status::Approved);
            SendMail := false;
            if ApprovalEntry.Find('-') then begin
                repeat
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Open) or
                       (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                        SendMail := true;
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today, Time);
                    ApprovalEntry."Last Modified By User ID" := UserId;
                    ApprovalEntry.Modify;
                until ApprovalEntry.Next = 0;

            end;
            if ManualCancel or (not ManualCancel and not (RecRef."Approval Status" = RecRef."Approval Status"::"Pending Approval")) then
                RecRef."Approval Status" := RecRef."Approval Status"::Open;
            RecRef.Modify(true);
            if ShowMessage then
                Message(Text131, DocType, Format(RecRef."No."));
        end
        else
            Message(Text130);
    end;



}




