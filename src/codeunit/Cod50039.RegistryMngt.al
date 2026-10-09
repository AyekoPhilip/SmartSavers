codeunit 50039 "Registry Mngt."
{


    trigger OnRun()
    begin
    end;

    var
        ErrorOnInvalidTxt: Label 'Member already Created %1';
        ErrOnNotApprovedDocTxt: Label 'Application %1 is not fully approved';
        ErrorOnNotApprovedDocMgt: Label 'This document has not been approved';
        ProdFact: Record "Product Factory";
        Cust: Record Member;
        CompanyInfo: Record "Company Information";
        FileAlloc: Record "File Allocation";
        CustBankAcc: Record "Cust. Bank Account";
        ImageMedia: Record "Image Data";
        NextofKINApplication: Record "Next of KIN Application";
        NextofKIN: Record "Next of KIN";
        SignatoryApplication: Record "Signatory Application";
        AccountSignatories: Record "Account Signatories";
        DefaultSavAccReg: Record "Default Accounts Application";
        Banking: Record "Account Banking";
        NotifSource: Enum NotifSourceType;
        DelgMember: Record "Delegate Members";
        CredAc: Record "Account Credit";
        TempBanking: Record "Account (Procedure)";
        TempCredAcc: Record "Account (Member)";
        RepaymentAc: Record "Repayment Account";
        Gensetup: Record "General Set-Up";
        NotificationTemplates: Record "Notification Template";
        SmsNotification: Codeunit "SMS Notification";
        MembNoSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";

        ProctedAcc: Record "Proctected Account";
        RestrictRecord: Record "Record Restrictions Mngt.";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        UnsupportedRecordTypeErrTxt: Label 'This record has not been approved.Kindly send approval request before you can continue.';
        UnsupportedRecordTypeErrMsg: Label 'Application No. %1 successfully posted and account No. %2 created.';
        ErrorOnRestrictReportTxt: Label 'This is a proctected Account. You are not allowed to this view/generate this statement';
        RegisterManagement: Codeunit "Register Management";
        CustAccType: Enum CustAccountType;
        MonthlyContrib: Record "Monthly Contribution Applic.";
        VarVariant: Variant;

    procedure CustomerRegistration(MemberApplication: Record "Member Application"; PostInt: Integer)
    var
        Post: Boolean;
        CustomerNo: Code[20];
        CustRec: Record Member;
        OnCompleteMsgTxt: Label 'Member Account No. %1 Successfull created.';
        DocAttach: Record "Document Attachment";
        Contribution: Record "Member Monthly Contribution";
        ProdCat: Enum ProductAccountCategory;
        AccDim: Enum AccountDimension;
        KinApp: Record "Account Kins-Applications";
        KinAccount: Record "Account Kins";
        SegMngt: Record "Segment/County/Dividend/Signat";
        CrmApplic: Record "CRM Application";
        RiskMatrix: Record "Risk Assessment Matrix";
        ApplicTemp: Record "Member Application";

    begin
        CompanyInfo.Get();
        MembNoSeries.Get();

        case MemberApplication."Approval Status" of

            MemberApplication."Approval Status"::Approved:
                begin
                    Gensetup.Get();
                    MemberApplication.CheckMinimumRegistrationEntry;
                    if not MemberApplication."Group Account" then begin
                        MemberApplication.TestField("Member Category");
                        MemberApplication.TestField("ID No.");
                    end;
                    if MemberApplication."ID No." <> '' then begin
                        Cust.Reset;
                        Cust.SetRange("ID No.", MemberApplication."ID No.");
                        if Cust.Find('-') then begin
                            Error(ErrorOnInvalidTxt, Cust."No.");
                        end;
                    end;
                    if MemberApplication."Passport No." <> '' then begin
                        Cust.Reset;
                        Cust.SetRange("Passport No.", MemberApplication."Passport No.");
                        if Cust.Find('-') then begin
                            Error(ErrorOnInvalidTxt, Cust."No.");
                        end;
                    end;
                    Post := MemberApplication.CheckBlockedCustOnJnls(
                      MemberApplication, MemberApplication."No.");

                    if MemberApplication.CheckBlockedCustOnJnls(
                      MemberApplication, MemberApplication."No.") then begin

                        CustomerNo := PostCustAcc(MemberApplication, Post);

                        if CustomerNo <> '' then begin

                            SegMngt.Reset();
                            SegMngt.SetRange(Code, MemberApplication."No.");
                            if SegMngt.FindSet() then begin
                                repeat
                                    DelgMember.Init();
                                    DelgMember.Code := CustomerNo;
                                    DelgMember."Delegate Name" := SegMngt.Description;
                                    DelgMember.Insert(true);
                                until SegMngt.Next() = 0;
                            end;

                            CustBankAcc.Reset();
                            CustBankAcc.SetRange("Customer No.", MemberApplication."No.");
                            if CustBankAcc.FindSet() then begin
                                CustBankAcc.ModifyAll("Member No.", CustomerNo);
                            end;

                            RiskMatrix.Reset();
                            RiskMatrix.SetRange("Account No.", MemberApplication."No.");
                            if RiskMatrix.FindSet() then begin
                                RiskMatrix.ModifyAll("Member No.", CustomerNo);
                            end;

                            ImageMedia.LockTable;
                            fnImageDataInitialize(MemberApplication, ImageMedia);
                            ImageMedia."Member No." := CustomerNo;
                            ImageMedia."ID No." := MemberApplication."ID No.";
                            ImageMedia.Insert(true);
                            case MemberApplication."Group Account" of
                                false:
                                    begin
                                        NextofKIN.LockTable;
                                        NextofKINApplication.Reset;
                                        NextofKINApplication.SetRange("Account No", MemberApplication."No.");
                                        NextofKINApplication.SetRange(Type, NextofKINApplication.Type::"Next of Kin");
                                        if NextofKINApplication.Find('-') then begin
                                            repeat
                                                InitializeKinDetails(NextofKINApplication, NextofKIN);
                                                NextofKIN."Account No" := CustomerNo;
                                                NextofKIN."Application No." := MemberApplication."No.";
                                                NextofKIN.Insert(true);
                                            until NextofKINApplication.Next = 0;
                                        end
                                    end;
                                true:
                                    begin
                                        AccountSignatories.LockTable;
                                        SignatoryApplication.Reset;
                                        SignatoryApplication.SetRange("Account No.", MemberApplication."No.");
                                        if SignatoryApplication.Find('-') then begin
                                            repeat
                                                InitializeSignatoriesDetails(SignatoryApplication, AccountSignatories);
                                                AccountSignatories."Account No." := CustomerNo;
                                                AccountSignatories.Insert(true);
                                            until SignatoryApplication.Next = 0;
                                        end;

                                        KinAccount.LockTable();
                                        KinApp.Reset();
                                        KinApp.SetRange("Account No.", MemberApplication."No.");
                                        if KinApp.Find('-') then begin
                                            repeat
                                                InitializeKinAccDetail(KinApp, KinAccount);
                                                KinAccount."Account No." := CustomerNo;
                                                KinAccount.Insert(true)
                                            until KinApp.Next() = 0;
                                        end;
                                    end;
                            end;
                            DefaultSavAccReg.Reset;
                            DefaultSavAccReg.SetRange(DefaultSavAccReg."No.", MemberApplication."No.");
                            if DefaultSavAccReg.Find('-') then begin
                                repeat
                                    if ProdFact.Get(DefaultSavAccReg."Product Type") then begin
                                        ProdFact.TestField("Account Dimension");
                                        ProdFact.TestField("Posting Group");
                                        ProdFact.TestField(Status, ProdFact.Status::Active);
                                        ProdFact.TestField("Product Class", ProdFact."Product Class"::Account);
                                        case ProdFact."Account Dimension" of
                                            ProdFact."Account Dimension"::Banking:
                                                begin

                                                    Banking.LockTable;
                                                    fnInitializeAccountBanking(MemberApplication, Banking);

                                                    case ProdFact."No. Serialization" of
                                                        ProdFact."No. Serialization"::Automated:
                                                            begin
                                                                Banking.Init();
                                                                Banking."No." := '';
                                                            end;
                                                        ProdFact."No. Serialization"::Manual:
                                                            begin
                                                                Cust.Reset();
                                                                Cust.SetRange("No.", CustomerNo);
                                                                if Cust.FindFirst() then
                                                                    InitBankingAcEntry(Cust, Banking,
                                                                ProdFact."Account No. Suffix",
                                                                ProdFact."Account No. Prefix",
                                                                Cust."Global Dimension 2 Code",
                                                                Cust."No.", ProdFact."Product ID");
                                                            end;
                                                    end;

                                                    Banking."Member No." := CustomerNo;
                                                    Banking."Product Type" := DefaultSavAccReg."Product Type";
                                                    Banking."Product Name" := DefaultSavAccReg."Product Name";
                                                    Banking."Monthly Contribution" := DefaultSavAccReg."Monthly Contribution";
                                                    Banking."Account Category" := DefaultSavAccReg."Account Category";
                                                    Banking."Loan Disbursement Account" := DefaultSavAccReg."Loan Disbursement A/c";
                                                    Banking."Customer Posting Group" := ProdFact."Posting Group";
                                                    Banking."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                    Banking."Account Dimension" := ProdFact."Account Dimension";
                                                    Banking."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                    Banking.Insert(true);

                                                    RegisterManagement.fnCreateVendorPostAc(Banking."No.",
                                                    Banking.Name, Banking."Mobile No.", Banking."Global Dimension 1 Code",
                                                    Banking."Global Dimension 2 Code", Banking."Customer Posting Group",
                                                    Banking."E-Mail", Banking.Status, Banking."Product Type",
                                                    Banking."ID/Passport No.", Banking."Member No.", Banking."Account Category");

                                                    MonthlyContrib.LockTable();
                                                    MonthlyContrib.Reset();
                                                    MonthlyContrib.SetRange("Account No.", MemberApplication."No.");
                                                    MonthlyContrib.SetRange(Type, Banking."Account Category");
                                                    if MonthlyContrib.FindSet() then begin
                                                        InitializeMonthlyContribDetails(MonthlyContrib, Contribution);
                                                        Contribution."Account No." := Banking."Member No.";
                                                        Contribution."Application No." := Banking."No.";
                                                        Contribution.Insert(true);
                                                    end;
                                                    case
                                                        ProdFact."Account Category" of
                                                        ProdFact."Account Category"::"Money Market":
                                                            begin
                                                                AccountSignatories.LockTable;
                                                                SignatoryApplication.Reset;
                                                                SignatoryApplication.SetRange("Account No.", MemberApplication."No.");
                                                                if SignatoryApplication.Find('-') then begin
                                                                    repeat
                                                                        InitializeSignatoriesDetails(SignatoryApplication, AccountSignatories);
                                                                        AccountSignatories."Account No." := Banking."No.";
                                                                        AccountSignatories."Member No." := Banking."Member No.";
                                                                        AccountSignatories.Insert(true);
                                                                    until SignatoryApplication.Next = 0;
                                                                end;
                                                            end;
                                                        ProdFact."Account Category"::Junior:
                                                            begin

                                                                KinAccount.LockTable();
                                                                KinApp.Reset();
                                                                KinApp.SetRange("Account No.", MemberApplication."No.");
                                                                if KinApp.Find('-') then begin
                                                                    repeat
                                                                        InitializeKinAccDetail(KinApp, KinAccount);
                                                                        KinAccount."Account No." := Banking."No.";
                                                                        KinAccount."Member No." := Banking."Member No.";
                                                                        KinAccount.Insert(true)
                                                                    until KinApp.Next() = 0;
                                                                end;
                                                            end;
                                                    end;

                                                    TempBanking.LockTable();
                                                    fnInitializeTempAccountBanking(MemberApplication, TempBanking);
                                                    TempBanking."No." := Banking."No.";
                                                    TempBanking."Member No." := CustomerNo;
                                                    TempBanking."Product Type" := DefaultSavAccReg."Product Type";
                                                    TempBanking."Product Name" := DefaultSavAccReg."Product Name";
                                                    TempBanking."Monthly Contribution" := DefaultSavAccReg."Monthly Contribution";
                                                    TempBanking."Account Category" := DefaultSavAccReg."Account Category";
                                                    TempBanking."Loan Disbursement Account" := DefaultSavAccReg."Loan Disbursement A/c";
                                                    TempBanking."Customer Posting Group" := ProdFact."Posting Group";
                                                    TempBanking."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                    TempBanking."Account Dimension" := ProdFact."Account Dimension";
                                                    TempBanking."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                    TempBanking.Insert(true);
                                                end;

                                            ProdFact."Account Dimension"::Credit,
                                            ProdFact."Account Dimension"::"Micro Credit":
                                                begin
                                                    CredAc.LockTable;
                                                    fnInitializeAccountCredit(MemberApplication, CredAc);

                                                    case ProdFact."No. Serialization" of
                                                        ProdFact."No. Serialization"::Automated:
                                                            begin
                                                                CredAc.Init();
                                                                CredAc."No." := '';
                                                            end;
                                                        ProdFact."No. Serialization"::Manual:
                                                            begin
                                                                Cust.Reset();
                                                                Cust.SetRange("No.", CustomerNo);
                                                                if Cust.FindFirst() then
                                                                    InitCreditAcEntry(Cust, CredAc, ProdFact."Account No. Suffix",
                                                         ProdFact."Account No. Prefix", Cust."Global Dimension 2 Code", Cust."No.");
                                                            end;
                                                    end;
                                                    CredAc."Member No." := CustomerNo;
                                                    CredAc."Product Type" := DefaultSavAccReg."Product Type";
                                                    CredAc."Product Name" := DefaultSavAccReg."Product Name";
                                                    CredAc."Monthly Contribution" := DefaultSavAccReg."Monthly Contribution";
                                                    CredAc."Account Category" := DefaultSavAccReg."Account Category";
                                                    CredAc."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                    CredAc."Customer Posting Group" := ProdFact."Posting Group";
                                                    CredAc."Withdrawal Option" := ProdFact."Withdrawal Option";

                                                    case Cust."Customer Type" of
                                                        Cust."Customer Type"::" ",
                                                        Cust."Customer Type"::"Non-Member",
                                                        Cust."Customer Type"::Individual:
                                                            begin
                                                                CredAc."Account Dimension" := ProdFact."Account Dimension";
                                                            end;
                                                        Cust."Customer Type"::Corporate,
                                                        Cust."Customer Type"::Joint,
                                                        Cust."Customer Type"::Groups:
                                                            begin
                                                                CredAc."Account Dimension" := ProdFact."Account Dimension";
                                                            end
                                                    end;

                                                    CredAc.Insert(true);

                                                    RegisterManagement.fnCreateCustMemberPostAc(CredAc."No.",
                                                    CredAc.Name, CredAc."Mobile No.",
                                                    CredAc."Global Dimension 1 Code",
                                                    CredAc."Global Dimension 2 Code",
                                                    CredAc."Customer Posting Group",
                                                    MemberApplication."E-Mail",
                                                    CredAc.Status, CredAc."Product Type",
                                                    CredAc."ID/Passport No.",
                                                    CredAc."Member No.",
                                                    CustAccType::"Credit Account",
                                                    CredAc."Account Dimension",
                                                    CredAc."Account Category");

                                                    MonthlyContrib.LockTable();
                                                    MonthlyContrib.Reset();
                                                    MonthlyContrib.SetRange("Account No.", MemberApplication."No.");
                                                    MonthlyContrib.SetRange(Type, CredAc."Account Category");
                                                    if MonthlyContrib.FindSet() then begin
                                                        InitializeMonthlyContribDetails(MonthlyContrib, Contribution);
                                                        Contribution."Account No." := CredAc."Member No.";
                                                        Contribution."Application No." := CredAc."No.";
                                                        Contribution.Insert(true);
                                                    end;

                                                    TempCredAcc.LockTable();
                                                    fnInitializeTempAccountCredit(MemberApplication, TempCredAcc);
                                                    TempCredAcc."No." := CredAc."No.";
                                                    TempCredAcc."Member No." := CustomerNo;
                                                    TempCredAcc."Product Type" := DefaultSavAccReg."Product Type";
                                                    TempCredAcc."Product Name" := DefaultSavAccReg."Product Name";
                                                    TempCredAcc."Monthly Contribution" := DefaultSavAccReg."Monthly Contribution";
                                                    TempCredAcc."Account Category" := DefaultSavAccReg."Account Category";
                                                    TempCredAcc."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                    TempCredAcc."Customer Posting Group" := ProdFact."Posting Group";
                                                    TempCredAcc."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                    TempCredAcc."Account Dimension" := ProdFact."Account Dimension";
                                                    TempCredAcc.Insert(true);

                                                end;

                                            ProdFact."Account Dimension"::Repayment:
                                                begin
                                                    RepaymentAc.LockTable;
                                                    fnInitializeRepaymentAcc(MemberApplication, RepaymentAc);

                                                    case ProdFact."No. Serialization" of
                                                        ProdFact."No. Serialization"::Automated:
                                                            begin
                                                                RepaymentAc.Init();
                                                                RepaymentAc."No." := '';
                                                            end;
                                                        ProdFact."No. Serialization"::Manual:
                                                            begin
                                                                Cust.Reset();
                                                                Cust.SetRange("No.", CustomerNo);
                                                                if Cust.FindFirst() then
                                                                    InitRepayAcEntry(Cust, RepaymentAc, ProdFact."Account No. Suffix",
                                                        ProdFact."Account No. Prefix", Cust."Global Dimension 2 Code", Cust."No.");
                                                            end;
                                                    end;

                                                    RepaymentAc."Member No." := CustomerNo;
                                                    RepaymentAc."Product Type" := DefaultSavAccReg."Product Type";
                                                    RepaymentAc."Product Name" := DefaultSavAccReg."Product Name";
                                                    RepaymentAc."Account Category" := DefaultSavAccReg."Account Category";
                                                    RepaymentAc."Customer Posting Group" := ProdFact."Posting Group";
                                                    RepaymentAc."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                    RepaymentAc."Account Dimension" := ProdFact."Account Dimension";
                                                    RepaymentAc.Insert(true);

                                                    RegisterManagement.fnCreateVendorPostAc(RepaymentAc."No.",
                                                    RepaymentAc.Name, MemberApplication."Mobile Phone No",
                                                    RepaymentAc."Global Dimension 1 Code",
                                                    RepaymentAc."Global Dimension 2 Code",
                                                    RepaymentAc."Customer Posting Group",
                                                    MemberApplication."E-Mail",
                                                    RepaymentAc.Status,
                                                    RepaymentAc."Product Type",
                                                    MemberApplication."ID No.",
                                                    RepaymentAc."Member No.", RepaymentAc."Account Category");

                                                end;
                                        end;
                                    end;
                                until DefaultSavAccReg.Next = 0;
                            end;
                        end;

                        if CustRec.Get(CustomerNo) then begin
                            DocAttach.Reset;
                            DocAttach.SetRange("Table ID", 52140533);
                            DocAttach.SetRange("No.", MemberApplication."No.");
                            if DocAttach.FindSet then begin
                                DocAttach.ModifyAll("New Table ID", 52140542);
                                DocAttach.ModifyAll("Record No.", CustRec."No.");
                            end;

                            FileAlloc.Reset();
                            FileAlloc.SetRange("ID No.", CustRec."ID No.");
                            if FileAlloc.FindFirst() then begin
                                CustRec."File No." := FileAlloc."No.";
                                CustRec.Modify(true);
                            end;

                            SmsNotification.CreateSmsNotif(NotifSource::"New Member", MemberApplication."Mobile Phone No",
                            'Dear ' + MemberApplication.Name + 'Your member No. is ' + CustomerNo + '' + CompanyInfo."E-Mail", MemberApplication."No.",
                               CustRec."No.", false);

                            MemberApplication."Posted By" := UserId;
                            MemberApplication."Date Posted" := CurrentDateTime;
                            MemberApplication."Approval Status" := MemberApplication."Approval Status"::Posted;
                            MemberApplication.Modify;
                            onAfterCreateMember(MemberApplication, CustomerNo);
                            CrmApplic.Reset();
                            CrmApplic.SetRange("No.", MemberApplication."CRM Application No.");
                            if CrmApplic.FindFirst() then begin
                                CrmApplic.Created := true;
                                CrmApplic."Approval Status" := CrmApplic."Approval Status"::Posted;
                                CrmApplic.Modify(true);
                            end;

                            RegisterManagement.ValidateDefaultDim(CustomerNo);
                            Gensetup.Get();

                            ApplicTemp.Reset();
                            ApplicTemp.SetRange("No.", MemberApplication."No.");
                            ApplicTemp.SetRange("Approval Status", ApplicTemp."Approval Status"::Posted);
                            if ApplicTemp.FindFirst() then begin
                                VarVariant := ApplicTemp;
                                if MemberApplication."E-Mail" <> '' then begin
                                    if CustomerNo <> '' then
                                        SmsNotification.SendEmailNotification(VarVariant, 0, CustomerNo);
                                end
                            end;
                            case PostInt of
                                1:
                                    begin
                                        Message(OnCompleteMsgTxt, CustomerNo);
                                    end;
                            end;
                        end;
                    end;
                end else begin
                Error(ErrOnNotApprovedDocTxt, MemberApplication."No.")
            end
        end
    end;

    [IntegrationEvent(false, false)]
    local procedure onAfterCreateMember(MemberApplication: Record "Member Application"; MemberNo: code[20])
    begin

    end;

    local procedure PostCustAcc(VarVariant: Record "Member Application"; Balancing: Boolean) CustNo: Code[20]
    var
        SavAcc: Record "Member Application";
        CustRecordEntry: Record Member;
    begin

        SavAcc.Get(VarVariant."No.");
        if Balancing then begin

            if VarVariant."Currency Code" = '' then
                SavAcc.TestField("Currency Code", '')
            else
                if SavAcc."Currency Code" <> '' then
                    VarVariant.TestField("Currency Code", SavAcc."Currency Code");

            CustRecordEntry.LockTable;
            InitCustEntry(VarVariant, CustRecordEntry);

            CustRecordEntry."Date of Birth" := SavAcc."Date of Birth";
            CustRecordEntry."Birth Certificate No." := SavAcc."Birth Certificate No.";
            CustRecordEntry."ID No." := SavAcc."ID No.";
            CustRecordEntry."PIN No." := SavAcc."PIN No.";
            CustRecordEntry."Application No." := SavAcc."No.";
            CustRecordEntry."Other Name" := SavAcc."Other Name";
            CustRecordEntry."Principal Member No." := SavAcc."Principal Member";
            CustRecordEntry."Company Registration No." := SavAcc."Company Registration No.";
            CustRecordEntry."Date of Business Reg." := SavAcc."Date of Business Reg.";
            CustRecordEntry."Group Account No." := SavAcc."Group Account No.";
            CustRecordEntry."Global Dimension 1 Code" := SavAcc."Global Dimension 1 Code";
            CustRecordEntry."Global Dimension 2 Code" := SavAcc."Global Dimension 2 Code";
            OnPostCustOnBeforeCustEntryInsert(CustRecordEntry, VarVariant, SavAcc);
            CustRecordEntry.Insert(true);
            OnPostCustOnAfterCustEntryInsert(CustRecordEntry, VarVariant, SavAcc);
            CustNo := CustRecordEntry."No.";
            exit(CustNo);
        end;
    end;

    local procedure InitCustEntry(VarVariant: Record "Member Application"; var CustRecordEntry: Record Member)
    begin
        CustRecordEntry.Init;
        CustRecordEntry.CopyFromApplicationLine(VarVariant);
        CustRecordEntry."No." := '';
        OnAfterInitCustEntry(CustRecordEntry, VarVariant);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCustEntry(var CustEntry: Record Member; Applic: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCustOnAfterCustEntryInsert(var CustEntry: Record Member; var VarVariant: Record "Member Application"; Account: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCustOnBeforeCustEntryInsert(var CustEntry: Record Member; var VarVariant: Record "Member Application"; Account: Record "Member Application")
    begin
    end;

    procedure fnImageDataInitialize(VarVariant: Record "Member Application"; var ImageData: Record "Image Data")
    begin
        ImageData.Init;
        ImageData.CopyFromApplication(VarVariant);
    end;

    local procedure ImageDataInitialize(VarVariant: Record "Member Changes"; var ImageData: Record "Image Data")
    begin
        ImageData.Init;
        ImageData.CopyFromChanges(VarVariant);
    end;

    local procedure InitializeKinDetails(VarVariant: Record "Next of KIN Application"; var KinDetails: Record "Next of KIN")
    begin
        KinDetails.Init;
        KinDetails.CopyFromApplicationKinDetails(VarVariant);
        OnAfterInitnextOfkinEntry(KinDetails, VarVariant);
    end;

    procedure InitializeAppraisalDetails(VarVariant: Record "Loan Application"; var AppraisalDetails: Record "Loan Appraisal Parameter")
    begin
        AppraisalDetails.Init;
        AppraisalDetails."Entry No." := RegisterManagement.InitNextEntryNo;
        AppraisalDetails.CopyFromLoanApplication(VarVariant);
    end;

    procedure InitializeMonthlyContribDetails(VarVariant: Record "Monthly Contribution Applic."; var ContribDetails: Record "Member Monthly Contribution")
    begin
        ContribDetails.Init();
        ContribDetails.CopyFromMembContributionApplicDetails(VarVariant);
        OnAfterInitContribDetailsEntry(ContribDetails, VarVariant);
    end;

    procedure InitializeAccountContribDetails(VarVariant: Record "Account Application"; var ContribDetails: Record "Member Monthly Contribution")
    begin
        ContribDetails.Init();
        ContribDetails.CopyFromAccountApplicDetails(VarVariant);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitnextOfkinEntry(var NextOfKin: Record "Next of KIN"; Applic: Record "Next of KIN Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitContribDetailsEntry(var NextOfKin: Record "Member Monthly Contribution"; Applic: Record "Monthly Contribution Applic.")
    begin
    end;

    procedure InitializeSignatoriesDetails(VarVariant: Record "Signatory Application"; var Signatories: Record "Account Signatories")
    begin
        Signatories.Init;
        Signatories.CopyFromApplicationsignatoriesDetails(VarVariant);
        OnAfterInitsignatoriesEntry(Signatories, VarVariant)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitsignatoriesEntry(var NextOfKin: Record "Account Signatories"; Applic: Record "Signatory Application")
    begin
    end;

    procedure InitializeKinAccDetail(RecRef: Record "Account Kins-Applications"; var KinDetail: Record "Account Kins")
    var
    begin
        KinDetail.Init();
        KinDetail.CopyFromAccountKinDetail(RecRef);
    end;



    procedure fnInitializeAccountBanking(VarVariant: Record "Member Application"; var Acc: Record "Account Banking")
    begin
        Acc.Init;
        Acc.CopyFromMemberApplicationEntries(VarVariant);
        OnAfterInitAccountBankingEntry(Acc, VarVariant)
    end;

    procedure fnInitializeAccountRec(VarVariant: Record Member; var Acc: Record "Account Banking")
    begin
        Acc.Init;
        Acc.CopyFromCustomerMemberEntries(VarVariant);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCustChangesEntry(var CustEntry: Record "Member Changes"; Applic: Record Member)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitAccountBankingEntry(var Acc: Record "Account Banking"; Applic: Record "Member Application")
    begin
    end;


    procedure fnInitializeAccountCredit(VarVariant: Record "Member Application"; var Acc: Record "Account Credit")
    begin
        Acc.Init;
        Acc.CopyFromMemberApplicationEntries(VarVariant);
        OnAfterInitAccountCreditEntry(Acc, VarVariant)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitAccountCreditEntry(var Acc: Record "Account Credit"; Applic: Record "Member Application")
    begin
    end;


    procedure fnInitializeRepaymentAcc(VarVariant: Record "Member Application"; var Acc: Record "Repayment Account")
    begin
        Acc.Init;
        Acc.CopyFromMemberApplicationEntries(VarVariant);
        OnAfterInitRepaymentAccEntry(Acc, VarVariant)
    end;

    local procedure InitCustChangesEntry(VarVariant: Record Member; var CustRecordEntries: Record "Member Changes")
    begin

        CustRecordEntries.Init;
        CustRecordEntries."No." := '';
        CustRecordEntries.CopyFromCustomerMember(VarVariant);
        CustRecordEntries."Last Date Modified" := Today;
        OnAfterInitCustChangesEntry(CustRecordEntries, VarVariant);
    end;

    procedure InitAccChangesEntry(VarVariant: Record "Account Banking"; var CustRecordEntries: Record "Account Application")
    begin
        CustRecordEntries.Init;
        CustRecordEntries."No." := '';
        CustRecordEntries."Account No." := VarVariant."No.";
        CustRecordEntries."Application Type" := CustRecordEntries."Application Type"::"Account Changes";
        CustRecordEntries.CopyFromAccountBanking(VarVariant);
        CustRecordEntries.Name := VarVariant.Name;
        CustRecordEntries."Last Date Modified" := Today;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitRepaymentAccEntry(var Acc: Record "Repayment Account"; Applic: Record "Member Application")
    begin


    end;

    procedure ActionsOnApplicationDocumentPane(var Variant: Variant; ActionItem: Option " ","Post Application","Kin Details","Default Product","Application Document",File,"Send Approval Request","Cancel Approval Request","Open Request",Approval)
    var
        RecRef: RecordRef;
        MemberAppl: Record "Member Application";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberAppl);
                    case ActionItem of

                        ActionItem::File:
                            begin
                            end;
                        ActionItem::"Default Product":
                            begin

                            end;
                        ActionItem::"Kin Details":
                            begin
                            end;
                        ActionItem::"Application Document":
                            begin
                            end;
                        ActionItem::"Post Application":
                            begin
                                CustomerRegistration(MemberAppl, 1);
                            end;
                        ActionItem::"Send Approval Request":
                            begin
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                            end;
                        ActionItem::"Open Request":
                            begin
                            end;
                        ActionItem::Approval:
                            begin
                            end;
                    end;
                    Variant := MemberAppl;
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    procedure fnPostAccountApplication(var Variant: Variant; Source: Enum AccountDimension)
    var
        RecRef: RecordRef;
        BankingRecordEntry: Record "Account Banking";
        CredAcRecordEntry: Record "Account Credit";
        AccountApp: Record "Account Application";
        RepayAcRecordEntry: Record "Repayment Account";
        ErrorOnInvalidEntryNo: Label 'Error On Null Value returned. Account No. must be in application No.%1';
        BnkAccNo: Code[100];
        CredAccNo: Code[100];
        CustAccType: Enum CustAccountType;
        KinAcc: Record "Account Kins";
        KinAppAccount: Record "Account Kins-Applications";
        AppSignatory: Record "Signatory Application";
        AccountSignatory: Record Signatories;
        AssocAccount: Record "Associated Account";
        BnkMngt: Codeunit "Banking Procedure Mngt.";
        AccSignatory: Record "Account Signatories";
        ImgData: Record "Image Data";
        Notif: Codeunit "SMS Notification";
        SmsSource: Enum NotifSourceType;
        CompInfo: Record "Company Information";
        Application: Record "Account Application";
        NonMemberAc: Record Member;
        BnkEntryRec: Record "Account Banking";
        Contribution: Record "Member Monthly Contribution";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Account Application":
                begin

                    MembNoSeries.Get();

                    RecRef.SetTable(Application);
                    AccountApp.Reset();
                    AccountApp.SetRange("No.", Application."No.");
                    if AccountApp.FindFirst() then begin

                        case AccountApp."Approval Status" of
                            AccountApp."Approval Status"::Approved:
                                begin
                                    AccountApp.TestField("Account Source");
                                    case Source of
                                        Source::Banking:
                                            begin
                                                Cust.Reset;
                                                Cust.SetRange("No.", AccountApp."Member No.");
                                                if Cust.Find('-') then begin

                                                    if ProdFact.Get(AccountApp."Product Type") then begin
                                                        ProdFact.fnCheckMinRequirements;
                                                        BankingRecordEntry.LockTable;
                                                        case ProdFact."No. Serialization" of
                                                            ProdFact."No. Serialization"::Automated:
                                                                begin
                                                                    BankingRecordEntry.Init();
                                                                    BankingRecordEntry."No." := '';
                                                                end;
                                                            ProdFact."No. Serialization"::Manual:
                                                                begin
                                                                    InitBankingAcEntry(Cust,
                                                                BankingRecordEntry,
                                                                ProdFact."Account No. Suffix",
                                                                ProdFact."Account No. Prefix",
                                                                Cust."Global Dimension 2 Code",
                                                                Cust."No.", ProdFact."Product ID");
                                                                end;
                                                        end;

                                                        if BankingRecordEntry."Account Category" = BankingRecordEntry."Account Category"::"Money Market" then begin
                                                            BankingRecordEntry."Old Member No." := '';
                                                        end;

                                                        BankingRecordEntry."Loan Disbursement Account" := ProdFact."Loan Disbursement Account";
                                                        if ProdFact."Account Category" = ProdFact."Account Category"::Junior then begin
                                                            BankingRecordEntry.Name := AccountApp.Name;
                                                            BankingRecordEntry."Parent Account No." := AccountApp."Parent Account No.";
                                                            BankingRecordEntry."Birth Certificate No." := AccountApp."Birth Certificate No.";
                                                            BankingRecordEntry."Date of Birth" := AccountApp."Date of Birth";

                                                            KinAcc.LockTable();
                                                            KinAppAccount.Reset();
                                                            KinAppAccount.SetRange("Account No.", AccountApp."No.");
                                                            if KinAppAccount.FindSet() then begin
                                                                repeat
                                                                    InitializeKinAccDetail(KinAppAccount, KinAcc);
                                                                    KinAcc."Account No." := BnkAccNo;
                                                                    kinacc."Member No." := BankingRecordEntry."Member No.";
                                                                    KinAcc.Insert(true)
                                                                until KinAppAccount.Next() = 0;
                                                            end;
                                                            AccountSignatories.LockTable;
                                                            SignatoryApplication.Reset;
                                                            SignatoryApplication.SetRange("Account No.", AccountApp."No.");
                                                            if SignatoryApplication.Find('-') then begin
                                                                repeat

                                                                    InitializeSignatoriesDetails(SignatoryApplication, AccountSignatories);
                                                                    AccountSignatories."Account No." := BankingRecordEntry."No.";
                                                                    AccountSignatories."Member No." := AccountApp."Member No.";
                                                                    AccountSignatories.Names := AccountApp.Name;
                                                                    AccountSignatories.Insert(true);
                                                                until SignatoryApplication.Next = 0;
                                                            end;
                                                        end;

                                                        BankingRecordEntry."Member No." := Cust."No.";
                                                        BankingRecordEntry."Account Category" := AccountApp."Account Type";
                                                        BankingRecordEntry."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                        BankingRecordEntry."Account Dimension" := ProdFact."Account Dimension";
                                                        BankingRecordEntry.Validate("Product Type", ProdFact."Product ID");
                                                        BankingRecordEntry."Customer Posting Group" := ProdFact."Posting Group";

                                                        case ProdFact."Account Category" of
                                                            ProdFact."Account Category"::"Certificates of Deposit":
                                                                begin
                                                                    AccountApp.fnCheckDetails();
                                                                    BankingRecordEntry."Fixed Deposit Status" := BankingRecordEntry."Fixed Deposit Status"::Active;
                                                                    BankingRecordEntry."Fixed Deposit Type" := AccountApp."Fixed Deposit Type";
                                                                    BankingRecordEntry."FD Maturity Date" := AccountApp."FD Maturity Date";
                                                                    BankingRecordEntry."FD Duration" := AccountApp."FD Duration";
                                                                    BankingRecordEntry."Neg. Interest Rate" := AccountApp."Negotiated Interest Rate";
                                                                    BankingRecordEntry."FD Maturity Instructions" := AccountApp."FD Maturity Instructions";
                                                                    BankingRecordEntry."Fixed Deposit Amount" := AccountApp."Fixed Deposit Amount";
                                                                    BankingRecordEntry."Savings Account No." := AccountApp."Savings Account No.";
                                                                end;
                                                        end;
                                                        BankingRecordEntry."Application No." := AccountApp."No.";
                                                        BankingRecordEntry."Global Dimension 1 Code" := ProdFact."Shortcut Dimension 1 Code";
                                                        BankingRecordEntry.Insert(true);

                                                        if BankingRecordEntry."Account Category" = BankingRecordEntry."Account Category"::"Money Market" then begin

                                                            BnkEntryRec.Reset();
                                                            BnkEntryRec.SetRange("No.", BankingRecordEntry."No.");
                                                            if BnkEntryRec.FindFirst() then begin
                                                                BnkEntryRec."Old Account No." := BankingRecordEntry."Old Member No.";
                                                                Cust."Old Member No." := BankingRecordEntry."Old Member No.";
                                                                Cust.Modify(true);
                                                                BnkEntryRec.Modify(true)
                                                            end
                                                        end;

                                                        BnkAccNo := BankingRecordEntry."No.";
                                                        if BnkAccNo = '' then
                                                            Error(ErrorOnInvalidEntryNo, AccountApp."No.");
                                                        if BnkAccNo <> '' then begin
                                                            Case AccountApp."Account Type" of
                                                                AccountApp."Account Type"::Junior:
                                                                    begin
                                                                        CustBankAcc.Reset();
                                                                        CustBankAcc.SetRange("Customer No.", BankingRecordEntry."Application No.");
                                                                        if CustBankAcc.FindSet() then begin
                                                                            CustBankAcc.ModifyAll("Member No.", BnkAccNo);
                                                                        end;
                                                                        InitializeAccountContribDetails(AccountApp, Contribution);
                                                                        Contribution."Account No." := BankingRecordEntry."Member No.";
                                                                        Contribution."Application No." := BnkAccNo;
                                                                        Contribution.Insert(true);
                                                                    end;
                                                            End;

                                                            RegisterManagement.fnCreateVendorPostAc(BnkAccNo,
                                                            BankingRecordEntry.Name, BankingRecordEntry."Mobile No.",
                                                            BankingRecordEntry."Global Dimension 1 Code", BankingRecordEntry."Global Dimension 2 Code",
                                                            BankingRecordEntry."Customer Posting Group", BankingRecordEntry."E-Mail", BankingRecordEntry.Status,
                                                            BankingRecordEntry."Product Type", BankingRecordEntry."ID/Passport No.", BankingRecordEntry."Member No.", BankingRecordEntry."Account Category");
                                                        end;

                                                        TempBanking.LockTable();
                                                        TempBanking.Reset();
                                                        TempBanking.SetRange("No.", Banking."No.");
                                                        if not TempBanking.FindFirst() then begin
                                                            InitializeTempAccountBanking(Cust, TempBanking);
                                                            TempBanking."No." := Banking."No.";
                                                            TempBanking."Member No." := BankingRecordEntry."Member No.";
                                                            TempBanking."Product Type" := ProdFact."Product ID";
                                                            TempBanking."Product Name" := ProdFact.Description;
                                                            TempBanking."Account Category" := ProdFact."Account Category";
                                                            TempBanking."Loan Disbursement Account" := ProdFact."Loan Disbursement Account";
                                                            TempBanking."Customer Posting Group" := ProdFact."Posting Group";
                                                            TempBanking."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                            TempBanking."Account Dimension" := ProdFact."Account Dimension";
                                                            TempBanking."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                            TempBanking.Insert(true);
                                                        end;

                                                        case ProdFact."Account Category" of
                                                            ProdFact."Account Category"::"Money Market":
                                                                begin
                                                                    AccountSignatories.LockTable;
                                                                    SignatoryApplication.Reset;
                                                                    SignatoryApplication.SetRange("Account No.", AccountApp."No.");
                                                                    if SignatoryApplication.Find('-') then begin
                                                                        repeat
                                                                            InitializeSignatoriesDetails(SignatoryApplication, AccountSignatories);
                                                                            AccountSignatories."Account No." := BnkAccNo;
                                                                            AccountSignatories."Member No." := BankingRecordEntry."Member No.";
                                                                            AccountSignatories.Insert(true);
                                                                        until SignatoryApplication.Next = 0;
                                                                    end;

                                                                end;
                                                        end;
                                                        case ProdFact."Account Category" of
                                                            ProdFact."Account Category"::"Certificates of Deposit":
                                                                begin
                                                                    if BnkAccNo <> '' then begin
                                                                        BnkMngt.PerformPostOnCertDepositAc(BnkAccNo);
                                                                    end
                                                                end;
                                                        end;
                                                        AccountApp."Posted By" := UserId;
                                                        AccountApp."Date Posted" := CurrentDateTime;
                                                        AccountApp.Validate("Approval Status", AccountApp."Approval Status"::Posted);
                                                        AccountApp.Modify;

                                                        if Cust."Mobile Phone No" <> '' then begin
                                                            Notif.CreateSmsNotif(SmsSource::Mobile, Cust."Mobile Phone No",
                                                            'Dear member your ' + ProdFact.Description + ' account has been successfully created.Thank you.' + CompInfo.Name,
                                                            Cust."No.", Cust."ID No.", false);
                                                        end;
                                                        Message(UnsupportedRecordTypeErrMsg, AccountApp."No.", BankingRecordEntry."No.");
                                                    end;
                                                end else begin

                                                    if ProdFact.Get(AccountApp."Product Type") then begin
                                                        ProdFact.fnCheckMinRequirements;

                                                        case ProdFact."No. Serialization" of
                                                            ProdFact."No. Serialization"::Automated:
                                                                begin
                                                                    BankingRecordEntry.Init();
                                                                    BankingRecordEntry."No." := '';
                                                                end;
                                                            ProdFact."No. Serialization"::Manual:
                                                                begin
                                                                    InitBankingAcEntry(Cust,
                                                                BankingRecordEntry,
                                                                ProdFact."Account No. Prefix",
                                                                ProdFact."Account No. Suffix",
                                                                Cust."Global Dimension 2 Code",
                                                                Cust."No.", ProdFact."Product ID");
                                                                end;
                                                        end;

                                                        BankingRecordEntry."Loan Disbursement Account" := ProdFact."Loan Disbursement Account";
                                                        BankingRecordEntry.Name := AccountApp.Name;
                                                        BankingRecordEntry."Date of Birth" := AccountApp."Date of Birth";
                                                        BankingRecordEntry.Validate("ID/Passport No.", AccountApp."ID No.");
                                                        BankingRecordEntry."Phone No." := AccountApp."Mobile Phone";
                                                        BankingRecordEntry."Mobile No." := AccountApp."Mobile Phone";
                                                        BankingRecordEntry."Member No." := AccountApp."ID No.";
                                                        BankingRecordEntry."Signing Mandates" := AccountApp."Signing Mandates";
                                                        BankingRecordEntry."Created By" := UserId;
                                                        BankingRecordEntry."Account Category" := AccountApp."Account Type";
                                                        BankingRecordEntry."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                        BankingRecordEntry."Account Dimension" := ProdFact."Account Dimension";
                                                        BankingRecordEntry.Validate("Product Type", ProdFact."Product ID");
                                                        BankingRecordEntry."Customer Posting Group" := ProdFact."Posting Group";
                                                        BankingRecordEntry."Application No." := AccountApp."No.";
                                                        BankingRecordEntry."Global Dimension 1 Code" := AccountApp."Global Dimension 1 Code";
                                                        BankingRecordEntry."Global Dimension 2 Code" := AccountApp."Global Dimension 2 Code";
                                                        BankingRecordEntry.Insert(true);
                                                        BnkAccNo := BankingRecordEntry."No.";

                                                        NonMemberAc.Init();
                                                        NonMemberAc."No." := AccountApp."ID No.";
                                                        NonMemberAc.Name := AccountApp.Name;
                                                        NonMemberAc.Status := NonMemberAc.Status::New;
                                                        NonMemberAc."Registration Date" := Today;
                                                        NonMemberAc."Identification Type" := NonMemberAc."Identification Type"::Passport;
                                                        NonMemberAc."ID No." := AccountApp."ID No.";
                                                        NonMemberAc."Date of Birth" := AccountApp."Date of Birth";
                                                        NonMemberAc."Mobile Phone No" := AccountApp."Mobile Phone";
                                                        NonMemberAc."Phone No." := AccountApp."Mobile Phone";

                                                        NonMemberAc."Current Address" := AccountApp."Current Address";
                                                        NonMemberAc."Post Code" := AccountApp."Post Code";
                                                        NonMemberAc.City := AccountApp.City;
                                                        NonMemberAc."Country/Region" := AccountApp."Country/Region";
                                                        NonMemberAc.Nationality := AccountApp.Nationality;
                                                        NonMemberAc."E-Mail" := AccountApp."E-Mail";
                                                        NonMemberAc."E-mail (Personal)" := AccountApp."E-Mail";
                                                        NonMemberAc."Customer Type" := NonMemberAc."Customer Type"::"Non-Member";
                                                        NonMemberAc.Insert();

                                                        SignatoryApplication.Reset;
                                                        SignatoryApplication.SetRange("Account No.", AccountApp."No.");
                                                        if not SignatoryApplication.Find('-') then begin
                                                            Error('no signatories attached to this application');
                                                        end;

                                                        AccountSignatories.LockTable;
                                                        SignatoryApplication.Reset;
                                                        SignatoryApplication.SetRange("Account No.", AccountApp."No.");
                                                        if SignatoryApplication.Find('-') then begin
                                                            repeat
                                                                InitializeSignatoriesDetails(SignatoryApplication, AccountSignatories);
                                                                AccountSignatories."Account No." := BnkAccNo;
                                                                AccountSignatories."Member No." := AccountApp."ID No.";
                                                                AccountSignatories.Names := SignatoryApplication.Names;
                                                                AccountSignatories.Insert(true);
                                                            until SignatoryApplication.Next = 0;
                                                        end;

                                                        if BnkAccNo = '' then
                                                            Error(ErrorOnInvalidEntryNo, AccountApp."No.");
                                                        if BnkAccNo <> '' then begin
                                                            RegisterManagement.fnCreateVendorPostAc(BnkAccNo,
                                                            BankingRecordEntry.Name,
                                                            BankingRecordEntry."Mobile No.",
                                                            BankingRecordEntry."Global Dimension 1 Code",
                                                            BankingRecordEntry."Global Dimension 2 Code",
                                                            BankingRecordEntry."Customer Posting Group",
                                                            BankingRecordEntry."E-Mail", BankingRecordEntry.Status,
                                                            BankingRecordEntry."Product Type",
                                                            BankingRecordEntry."ID/Passport No.",
                                                            BankingRecordEntry."Member No.", BankingRecordEntry."Account Category");
                                                        end;
                                                        AccountApp."Posted By" := UserId;
                                                        AccountApp."Date Posted" := CurrentDateTime;
                                                        AccountApp.Validate("Approval Status", AccountApp."Approval Status"::Posted);
                                                        AccountApp.Modify;
                                                        if AccountApp."Mobile Phone" <> '' then begin
                                                            Notif.CreateSmsNotif(SmsSource::Mobile, AccountApp."Mobile Phone",
                                                            'Dear member your ' + ProdFact.Description + ' account has been successfully created.Thank you.' + CompInfo.Name,
                                                            AccountApp."ID No.", AccountApp."ID No.", false);
                                                        end;
                                                        Message(UnsupportedRecordTypeErrMsg, AccountApp."No.", BankingRecordEntry."No.");
                                                    end
                                                end;
                                            end;
                                        Source::Credit:
                                            begin
                                                Cust.Reset;
                                                Cust.SetRange("No.", AccountApp."Member No.");
                                                if Cust.Find('-') then begin
                                                    if ProdFact.Get(AccountApp."Product Type") then begin
                                                        ProdFact.fnCheckMinRequirements;
                                                        CredAcRecordEntry.LockTable;
                                                        case ProdFact."No. Serialization" of
                                                            ProdFact."No. Serialization"::Automated:
                                                                begin
                                                                    CredAcRecordEntry.Init();
                                                                    CredAcRecordEntry."No." := '';
                                                                end;
                                                            ProdFact."No. Serialization"::Manual:
                                                                begin
                                                                    InitCreditAcEntry(Cust, CredAcRecordEntry, ProdFact."Account No. Prefix",
                                                         ProdFact."Account No. Suffix", Cust."Global Dimension 2 Code", Cust."No.");

                                                                end;
                                                        end;


                                                        CredAcRecordEntry.Validate("Product Type", ProdFact."Product ID");
                                                        CredAcRecordEntry."Account Category" := ProdFact."Account Category";
                                                        CredAcRecordEntry."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                        CredAcRecordEntry."Group Account" := Cust."Group Account";
                                                        CredAcRecordEntry."Member No." := Cust."No.";
                                                        CredAcRecordEntry."Account Dimension" := ProdFact."Account Dimension";
                                                        CredAcRecordEntry."Group Account No." := Cust."Group Account No.";
                                                        CredAcRecordEntry."Customer Posting Group" := ProdFact."Posting Group";
                                                        CredAcRecordEntry."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                        CredAcRecordEntry.Insert(true);
                                                        CredAccNo := CredAcRecordEntry."No.";

                                                        if CredAccNo = '' then
                                                            Error(ErrorOnInvalidEntryNo, AccountApp."No.");
                                                        if CredAccNo <> '' then begin

                                                            RegisterManagement.fnCreateCustMemberPostAc(CredAccNo,
                                                            CredAcRecordEntry.Name,
                                                            CredAcRecordEntry."Mobile No.",
                                                            CredAcRecordEntry."Global Dimension 1 Code",
                                                            CredAcRecordEntry."Global Dimension 2 Code",
                                                            CredAcRecordEntry."Customer Posting Group", '',
                                                            CredAcRecordEntry.Status,
                                                            CredAcRecordEntry."Product Type",
                                                            CredAcRecordEntry."ID/Passport No.",
                                                            CredAcRecordEntry."Member No.",
                                                            CustAccType::"Credit Account",
                                                            ProdFact."Account Dimension",
                                                            ProdFact."Account Category");
                                                        end;

                                                        TempCredAcc.LockTable();
                                                        InitializeCustTempAccountCredit(Cust, TempCredAcc);
                                                        TempCredAcc."No." := CredAcRecordEntry."No.";
                                                        TempCredAcc."Member No." := CredAcRecordEntry."Member No.";
                                                        TempCredAcc."Product Type" := ProdFact."Product ID";
                                                        TempCredAcc."Product Name" := ProdFact.Description;
                                                        TempCredAcc."Account Category" := ProdFact."Account Category";
                                                        TempCredAcc."Can Guarantee Loan" := ProdFact."Can Guarantee Loan";
                                                        TempCredAcc."Customer Posting Group" := ProdFact."Posting Group";
                                                        TempCredAcc."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                        TempCredAcc."Account Dimension" := ProdFact."Account Dimension";
                                                        TempCredAcc.Insert(true);

                                                        AccountApp."Posted By" := UserId;
                                                        AccountApp."Date Posted" := CurrentDateTime;
                                                        AccountApp.Validate("Approval Status", AccountApp."Approval Status"::Posted);
                                                        AccountApp.Modify;
                                                        if Cust."Mobile Phone No" <> '' then begin
                                                            Notif.CreateSmsNotif(SmsSource::Mobile, Cust."Mobile Phone No",
                                                            'Dear member your ' + ProdFact.Description + ' account has been successfully created.Thank you.' + CompInfo.Name,
                                                            Cust."No.", Cust."ID No.", false);
                                                        end;
                                                        Message(UnsupportedRecordTypeErrMsg, AccountApp."No.", CredAcRecordEntry."No.");
                                                    end;
                                                end
                                            end;
                                        Source::Repayment:
                                            begin
                                                Cust.Reset;
                                                Cust.SetRange("No.", AccountApp."Member No.");
                                                if Cust.Find('-') then begin
                                                    if ProdFact.Get(AccountApp."Product Type") then begin
                                                        ProdFact.fnCheckMinRequirements;
                                                        RepayAcRecordEntry.LockTable;

                                                        case ProdFact."No. Serialization" of
                                                            ProdFact."No. Serialization"::Automated:
                                                                begin
                                                                    RepayAcRecordEntry.Init();
                                                                    RepayAcRecordEntry."No." := '';
                                                                end;
                                                            ProdFact."No. Serialization"::Manual:
                                                                begin
                                                                    InitRepayAcEntry(Cust, RepayAcRecordEntry, ProdFact."Account No. Prefix",
                                                        ProdFact."Account No. Suffix", Cust."Global Dimension 2 Code", Cust."No.");

                                                                end;
                                                        end;
                                                        RepayAcRecordEntry.Validate("Product Type", ProdFact."Product ID");
                                                        RepayAcRecordEntry."Account Category" := ProdFact."Account Category";
                                                        RepayAcRecordEntry."Withdrawal Option" := ProdFact."Withdrawal Option";
                                                        RepayAcRecordEntry."Group Account" := Cust."Group Account";
                                                        RepayAcRecordEntry."Group Account No" := Cust."Group Account No.";
                                                        RepayAcRecordEntry."Customer Posting Group" := ProdFact."Posting Group";
                                                        RepayAcRecordEntry.Insert(true);
                                                        AccountApp."Created By" := UserId;
                                                        AccountApp."Date Posted" := CurrentDateTime;
                                                        AccountApp.Validate("Approval Status", AccountApp."Approval Status"::Posted);
                                                        AccountApp.Modify;

                                                        if Cust."Mobile Phone No" <> '' then begin
                                                            Notif.CreateSmsNotif(SmsSource::Mobile, Cust."Mobile Phone No",
                                                            'Dear member your ' + ProdFact.Description + ' account has been successfully created.Thank you.' + CompInfo.Name,
                                                            Cust."No.", Cust."ID No.", false);
                                                        end;
                                                        Message(UnsupportedRecordTypeErrMsg, AccountApp."No.", RepayAcRecordEntry."No.");
                                                    end;
                                                end;
                                            end;
                                    end;
                                end else begin
                                Error(UnsupportedRecordTypeErrTxt);
                            end;
                        end;

                        Variant := AccountApp;
                    end;
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;

    procedure InitRepayAcEntry(VarVariant: Record Member; var RepayAcRecordEntry: Record "Repayment Account"; AccSuffix: Code[10]; AccPrefix: Code[10]; Dim1: Code[10]; CustNo: Code[20])
    begin
        RepayAcRecordEntry.Init;
        RepayAcRecordEntry."No." := AccPrefix + DelChr(CustNo, '=', 'U|-') + AccSuffix;
        RepayAcRecordEntry.CopyFromCustomerMemberEntries(VarVariant);
    end;

    procedure InitBankingAcEntry(VarVariant: Record Member; var BankingAcRecordEntry: Record "Account Banking"; AccSuffix: Code[10]; AccPrefix: Code[10]; Dim1: Code[10]; CustNo: Code[20]; Prodcode: Code[20])
    var
        ProdFct: Record "Product Factory";
        SavAcc: Record "Account Banking";
#pragma warning disable AL0432
        NoSeriesMgt: Codeunit "No. Series";
#pragma warning restore AL0432
        AccNo: Code[100];
        ExistNo: Integer;
    begin
        ProdFct.Get(Prodcode);
        AccNo := AccPrefix + CustNo;
        BankingAcRecordEntry.Init;
        case ProdFct."No. Serialization" of
            ProdFct."No. Serialization"::Manual:
                begin
                    case ProdFct."Allow Multiple Accounts" of
                        true:
                            begin
                                SavAcc.SetCurrentKey("Last No. Series");

                                SavAcc.Reset();
                                SavAcc.SetRange("Member No.", CustNo);
                                SavAcc.SetRange("Product Type", Prodcode);
                                if SavAcc.FindLast() then begin
                                    if SavAcc."Last No. Series" <> '' then begin
                                        BankingAcRecordEntry."No." := AccPrefix + CustNo + '-' + IncStr(SavAcc."Last No. Series");
                                        BankingAcRecordEntry."Last No. Series" := IncStr(SavAcc."Last No. Series");
                                    end else begin
                                        BankingAcRecordEntry."No." := AccPrefix + CustNo + '-' + '01';
                                        BankingAcRecordEntry."Last No. Series" := '01';
                                    end;
                                end else begin
                                    BankingAcRecordEntry."No." := AccPrefix + DelChr(CustNo, '=', 'U') + AccSuffix
                                end;
                            end;
                        false:
                            begin
                                BankingAcRecordEntry."No." := AccPrefix + DelChr(CustNo, '=', 'U') + AccSuffix;
                            end;
                    end;

                end;
        end;
        BankingAcRecordEntry.CopyFromCustomerMemberEntries(VarVariant)
    end;

    procedure InitCreditAcEntry(VarVariant: Record Member; var CredAcRecordEntry: Record "Account Credit"; AccSuffix: Code[10]; AccPrefix: Code[10]; Dim1: Code[10]; CustNo: Code[20])
    begin
        CredAcRecordEntry.Init;
        CredAcRecordEntry."No." := AccPrefix + DelChr(CustNo, '=', 'U|-') + AccSuffix;
        CredAcRecordEntry.CopyFromCustomerMemberEntries(VarVariant)
    end;

    procedure InitCreditAcRec(VarVariant: Record Member; var CredAcRecordEntry: Record "Account Credit")
    begin
        CredAcRecordEntry.CopyFromCustomerMemberEntries(VarVariant)
    end;


    procedure CreateFDaccount(FDepositStatus: Integer; FDepositType: Code[20]; MaturityDate: Date; NegotiatedIntRate: Decimal; FDMaturityInst: Integer; FDepositCertNo: Code[20]; FDepositAmount: Decimal; SavingsAccountNo: Code[20])
    var
        BankingRecordEntry: Record "Account Banking";
    begin
        BankingRecordEntry."Fixed Deposit Status" := FDepositStatus;
        BankingRecordEntry."Fixed Deposit Type" := FDepositType;
        BankingRecordEntry."FD Maturity Date" := MaturityDate;
        BankingRecordEntry."Neg. Interest Rate" := NegotiatedIntRate;
        BankingRecordEntry."FD Maturity Instructions" := FDMaturityInst;
        BankingRecordEntry."Fixed Deposit Cert. No." := FDepositCertNo;
        BankingRecordEntry."Fixed Deposit Amount" := FDepositAmount;
        BankingRecordEntry."Savings Account No." := SavingsAccountNo;
    end;

    procedure fnCreateDefaultAccount(DocNo: Code[20]; DisbursementAcc: Boolean; MinContribution: Decimal; ProductID: Code[20]; AccountSource: Enum AccountDimension; AccountCategory: Enum ProductAccountCategory)
    var
        AutoOpenSavingAccs: Record "Default Accounts Application";
    begin
        AutoOpenSavingAccs.Init;
        AutoOpenSavingAccs."No." := DocNo;
        AutoOpenSavingAccs."Loan Disbursement A/c" := DisbursementAcc;
        AutoOpenSavingAccs."Monthly Contribution" := MinContribution;
        AutoOpenSavingAccs.Validate("Product Type", ProductID);
        AutoOpenSavingAccs."Account Source" := AccountSource;
        AutoOpenSavingAccs."Account Category" := AccountCategory;
        AutoOpenSavingAccs.Insert(true);
    end;

    procedure fnCreateRiskAssesmentMatrix(DocNo: Code[20])
    var
        AutoOpenSavingAccs: Record "Risk Assessment Matrix";
        RiskTemplate: Record "Risk Assessment Template";
    begin
        RiskTemplate.Reset();
        if RiskTemplate.Find('-') then begin
            repeat
                AutoOpenSavingAccs.Init;
                AutoOpenSavingAccs."Account No." := DocNo;
                AutoOpenSavingAccs.Code := RiskTemplate.Code;
                AutoOpenSavingAccs.Description := RiskTemplate.Description;
                AutoOpenSavingAccs.Insert(true);
            until RiskTemplate.Next() = 0;
        end;
    end;

    procedure fnCreateDefaultContribution(DocNo: Code[50]; Type: Enum ProductAccountCategory; Amt: Decimal)
    var

        Contribution: Record "Monthly Contribution Applic.";
    begin
        Contribution.Init();
        Contribution."Account No." := DocNo;
        Contribution.Type := Type;
        Contribution.Amount := Amt;
        Contribution.Insert(true)
    end;

    procedure fnAccountEntries(Cust: Record "Account Banking"; PostInt: Integer)
    var
        RecRef: Record "Account Application";
        MemberChanges: Record "Member Changes";
        Text0001: Label 'Process Complete.Go to account changes to complete the process.';
    begin
        InitAccChangesEntry(Cust, RecRef);
        RecRef.Validate(Response, PostInt);
        RecRef.Insert(true);
        case PostInt of
            3:
                begin
                    RegisterManagement.GetBankAcDetails(RecRef."No.", Cust."No.");
                end;
        end;
        Message(Text0001)
    end;

    procedure fnCustomerEntries(Cust: Record Member; PostInt: Integer)
    var
        RecRef: Record "Member Changes";
        MemberChanges: Record "Member Changes";
        Text0001: Label 'Process Complete.Go to account changes to complete the process.';
    begin
        if PostInt = 0 then exit;

        RecRef.LockTable;

        InitCustChangesEntry(Cust, RecRef);
        RecRef."Member No." := Cust."No.";
        RecRef."Posting Type" := PostInt;
        RecRef."ID No." := Cust."ID No.";
        RecRef."Date of Birth" := Cust."Date of Birth";
        RecRef."Passport No." := Cust."Passport No.";
        RecRef.Validate(Response, PostInt);
        RecRef.Insert(true);
        RegisterManagement.getCustomerBankDetailsCodeNoCode(RecRef."No.", Cust."No.");

        case PostInt of
            1:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::"Membership Details";

                end;

            2:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::Images;
                    ImageMedia.Reset;
                    ImageMedia.SetRange("Member No.", Cust."No.");
                    if ImageMedia.Find('-') then begin
                        RecRef.Picture := ImageMedia.Picture;
                        RecRef.Signature := ImageMedia.Signature;
                        RecRef."Picture ID" := ImageMedia."Picture ID";
                        RecRef."Signature ID" := ImageMedia."Signature ID";
                    end;
                end;
            3:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::"Kin Details";
                    RegisterManagement.GetkinDetails(RecRef."No.", Cust."No.");
                end;
            4:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::"Account Signatories";
                    RegisterManagement.getMemberAccountSignatory(RecRef."No.", Cust."No.");
                end;

            5:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::"Block Account";
                end;
            6:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::Contribution;
                    RegisterManagement.getMemberMonthlyContribution(RecRef."No.", Cust."No.");
                end;
            7:
                begin
                    RecRef."Changes Type" := RecRef."Changes Type"::Readmission;
                    RegisterManagement.GetkinDetails(RecRef."No.", Cust."No.");
                    RegisterManagement.getMemberAccountSignatory(RecRef."No.", Cust."No.");
                    RegisterManagement.getMemberMonthlyContribution(RecRef."No.", Cust."No.");

                    ImageMedia.Reset;
                    ImageMedia.SetRange("Member No.", Cust."No.");
                    if ImageMedia.Find('-') then begin
                        RecRef.Picture := ImageMedia.Picture;
                        RecRef.Signature := ImageMedia.Signature;
                    end;
                end;
        end;

        Message(Text0001)
    end;

    local procedure InitCustChangeEntriesTxt(VarVariant: Record Member; var CustRecordEntries: Record "Member Changes"; CustType: Enum CreditCustomerType)
    begin
        case CustType of
            CustType::Individual:
                CustRecordEntries.CopyIndividualEntriesFromCustMember(VarVariant)
            else
                CustRecordEntries.CopyGroupEntriesFromCustMember(VarVariant)
        end;
        CustRecordEntries."Last Date Modified" := Today;
        OnBeforePostCustChangesEntry(CustRecordEntries, VarVariant);
    end;

    procedure PostMediaChanges(CustRecordEntries: Record "Member Changes")
    var
        ImageData: Record "Image Data";
        AppImageData: Record "Image Data";
        AppMngt: Codeunit "Approval Mgmt.";
        AppChange: Record "Member Changes";
        PicInstream: InStream;
    begin
        CustRecordEntries.TestField("ID No.");
        CustRecordEntries.TestField("Member No.");

        CustRecordEntries.TestField("Approval Status", CustRecordEntries."Approval Status"::Approved);
        if AppMngt.CheckBlockedDocsOnJnls(CustRecordEntries."No.", 50413) then begin

            ImageData.Reset();
            ImageData.SetRange("ID No.", CustRecordEntries."ID No.");
            ImageData.SetRange("Member No.", CustRecordEntries."Member No.");
            if ImageData.Find('-') then begin
                ImageData.Picture := CustRecordEntries.Picture;
                ImageData.Signature := CustRecordEntries.Signature;
                ImageData."Signature ID" := CustRecordEntries."Signature ID";
                ImageData."Picture ID" := CustRecordEntries."Picture ID";
                ImageData.Modify(true);

            end else begin

                AppImageData.LockTable();
                AppImageData.Init();
                AppImageData."ID No." := CustRecordEntries."ID No.";
                AppImageData."Member No." := CustRecordEntries."Member No.";
                AppImageData.Picture := CustRecordEntries.Picture;
                AppImageData."Picture ID" := CustRecordEntries."Picture ID";
                AppImageData."Signature ID" := CustRecordEntries."Signature ID";
                AppImageData.Signature := CustRecordEntries.Signature;
                AppImageData.Insert(true)
            end;
            AppChange.Reset();
            AppChange.SetRange("No.", CustRecordEntries."No.");
            if AppChange.FindFirst() then begin
                AppChange."Approval Status" := AppChange."Approval Status"::Posted;
                AppChange."Date Posted" := CurrentDateTime;
                AppChange."Posted By" := UserId;
                AppChange.Modify(true);
                Message('Process Complete. Changes made to record');
            end;
        end;
    end;

    procedure PostMemberContribution(CustRecordEntries: Record "Member Changes")
    var
        Contribution: Record "Member Monthly Contribution";
        ChangeContrib: Record "Contribution-Changes";
        Contribt: Record "Member Monthly Contribution";
        PostRecord: Record "Member Changes";
        AppMngt: Codeunit "Approval Mgmt.";
    begin

        if AppMngt.CheckBlockedDocsOnJnls(CustRecordEntries."No.", Database::"Member Changes") then begin

            ChangeContrib.Reset();
            ChangeContrib.SetRange("Entry No.", CustRecordEntries."No.");
            ChangeContrib.SetRange("Account No.", CustRecordEntries."Member No.");
            if ChangeContrib.Find('-') then begin
                repeat
                    Contribution.Reset();
                    Contribution.SetRange(Type, ChangeContrib.Type);
                    Contribution.SetRange("Account No.", ChangeContrib."Account No.");
                    Contribution.SetRange("Application No.", ChangeContrib."Application No.");
                    if Contribution.Find('-') then begin
                        Contribution.Amount := ChangeContrib.Amount;
                        Contribution.Remarks := ChangeContrib.Remarks;
                        Contribution."Advise Type" := ChangeContrib."Advise Type";
                        Contribution.Modify(true);
                    end else begin
                        Contribt.Init();
                        Contribt."Account No." := ChangeContrib."Account No.";
                        Contribt."Application No." := ChangeContrib."Application No.";
                        Contribt.Type := ChangeContrib.Type;
                        Contribt.Amount := ChangeContrib.Amount;
                        Contribt.Remarks := ChangeContrib.Remarks;
                        Contribt."Advise Type" := ChangeContrib."Advise Type";
                        Contribt.Insert(true)
                    end;
                until ChangeContrib.Next() = 0
            end;
        end else begin
            Error('This document has not been approved');
        end;
        if PostRecord.Get(CustRecordEntries."No.") then begin
            PostRecord."Posted By" := UserId;
            PostRecord."Date Posted" := CurrentDateTime;
            PostRecord."Approval Status" := PostRecord."Approval Status"::Posted;
            PostRecord.Modify(true);
            Message('Process Complete. Changes made to record');
        end;
    end;

    procedure PostKinDetailsChanges(CustRecordEntries: Record "Member Changes")
    var
        KinDetail: Record "Next of KIN";
        KinApplication: Record "Next of KIN Application";
        PostRecord: Record "Member Changes";
        AppMngt: Codeunit "Approval Mgmt.";
    begin

        if AppMngt.CheckBlockedDocsOnJnls(CustRecordEntries."No.", Database::"Member Changes") then begin

            KinDetail.Reset();
            KinDetail.SetRange("Account No", CustRecordEntries."Member No.");
            KinDetail.DeleteAll();

            KinApplication.Reset();
            KinApplication.SetRange("Account No", CustRecordEntries."Member No.");
            KinApplication.SetRange("Application No.", CustRecordEntries."No.");
            if KinApplication.FindSet() then begin
                repeat

                    KinDetail.Init();
                    KinDetail."Account No" := KinApplication."Account No";
                    KinDetail.Name := KinApplication.Name;
                    KinDetail.Beneficiary := KinApplication.Beneficiary;
                    KinDetail."ID No." := KinApplication."ID No.";
                    KinDetail.Type := KinApplication.Type;
                    KinDetail.Address := KinApplication.Address;
                    KinDetail."Date of Birth" := KinApplication."Date of Birth";
                    KinDetail.Email := KinApplication.Email;
                    KinDetail."Entry No." := KinApplication."Entry No.";
                    KinDetail.Allocation := KinApplication.Allocation;
                    KinDetail."Application No." := CustRecordEntries."No.";
                    KinDetail.Relationship := KinApplication.Relationship;
                    KinDetail.Guardian := KinApplication.Guardian;
                    KinDetail."Kin Type" := KinApplication."Kin Type";
                    KinDetail.Telephone := KinApplication.Telephone;
                    KinDetail.Insert(true)

                until KinApplication.Next() = 0;
            end;
        end else begin
            Error(ErrorOnNotApprovedDocMgt);
        end;
    end;

    procedure PostAccSignatoryChanges(CustRecordEntries: Record "Member Changes")
    var
        ApplicSignatory: Record "Account Signatories";
        Signatory: Record "Signatory Application";
        PostRecord: Record "Member Changes";
        AppMngt: Codeunit "Approval Mgmt.";
    begin

        if AppMngt.CheckBlockedDocsOnJnls(CustRecordEntries."No.", Database::"Member Changes") then begin

            ApplicSignatory.Reset();
            ApplicSignatory.SetRange("Member No.", CustRecordEntries."Member No.");
            ApplicSignatory.DeleteAll();

            ApplicSignatory.LockTable();
            Signatory.Reset();
            Signatory.SetRange("Account No.", CustRecordEntries."No.");
            if Signatory.FindSet() then begin
                repeat
                    ApplicSignatory.Init();
                    ApplicSignatory."Account No." := Signatory."Member No.";
                    ApplicSignatory."Member No." := Signatory."Member No.";
                    ApplicSignatory.Address := Signatory.Address;
                    ApplicSignatory.Names := Signatory.Names;
                    ApplicSignatory."Staff/Payroll" := Signatory."Staff/Payroll";
                    ApplicSignatory."Must be Present" := Signatory."Must be Present";
                    ApplicSignatory."Must Sign" := Signatory."Must Sign";
                    ApplicSignatory.Type := Signatory.Type;
                    ApplicSignatory."Date Of Birth" := Signatory."Date Of Birth";
                    ApplicSignatory."Expiry Date" := Signatory."Expiry Date";
                    ApplicSignatory.City := Signatory.City;
                    ApplicSignatory."ID No." := Signatory."ID No.";
                    ApplicSignatory."Passport No." := Signatory."Passport No.";
                    ApplicSignatory.Gender := Signatory.Gender;
                    ApplicSignatory.Nationality := Signatory.Nationality;
                    ApplicSignatory.City := Signatory.City;
                    ApplicSignatory."Post Code" := Signatory."Post Code";
                    ApplicSignatory.Signature := Signatory.Signature;
                    ApplicSignatory.Picture := Signatory.Picture;
                    ApplicSignatory."Pin No." := Signatory."Pin No.";
                    ApplicSignatory.Signatory := Signatory.Signatory;
                    ApplicSignatory.Insert(true);
                until Signatory.Next() = 0
            end;
        end else begin
            Error('This document has not been approved.');
        end;
        if PostRecord.Get(CustRecordEntries."No.") then begin
            PostRecord."Posted By" := UserId;
            PostRecord."Date Posted" := CurrentDateTime;
            PostRecord."Approval Status" := PostRecord."Approval Status"::Posted;
            PostRecord.Modify(true);
            Message('Process Complete. Changes made to record');
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCustChangesEntry(var CustEntry: Record "Member Changes"; Applic: Record Member)
    begin
    end;

    procedure PerformPostOnCustomerChangesTxt(RecVar: Record "Member Changes")
    var
        Cust: Record Member;
        PostChangesTxt: Label 'Changes successfully posted.';
        MChange: Record "Member Changes";
    begin
        RecVar.LockTable;
        RecVar.TestField("Member No.");
        RecVar.TestField("Changes Type");
        RecVar.TestField("Approval Status", RecVar."Approval Status"::Approved);
        if Cust.Get(RecVar."Member No.") then begin
            InitCustChangeEntriesTxt(Cust, RecVar, Cust."Customer Type");
            RecVar."Date Posted" := CurrentDateTime;
            RecVar."Approval Status" := RecVar."Approval Status"::Posted;
            RecVar."Posted By" := UserId;
            RecVar.Modify;
            Message(PostChangesTxt)
        end;
    end;


    procedure InitTopupEntry(VarVariant: Record Loans; RecordEntry: Code[20]; CustNo: Code[20]; ProductType: Code[10]; OutPrinciple: Decimal; OutBill: Decimal; OutInterest: Decimal; TotalOutAmount: Decimal)
    begin
        VarVariant.Reset;
        VarVariant.SetRange("No.", RecordEntry);
        if VarVariant.Find('-') then begin
            VarVariant.CalcFields("Outstanding Principal", "Outstanding Bill",
           "Outstanding Interest", "Outstanding Balance");

            ProductType := VarVariant."Product Type";
            OutPrinciple := VarVariant."Outstanding Principal";
            OutBill := VarVariant."Outstanding Bill";
            OutInterest := VarVariant."Outstanding Interest";
            TotalOutAmount := VarVariant."Outstanding Balance";
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitTopupEntry(var TopupEntry: Record "Loans Top up"; Applic: Record Loans)
    begin
    end;


    procedure ApplicationRegistration(var Variant: Variant; PostInt: Integer)
    var
        RecRef: RecordRef;
        MemberAppl: Record "Member Application";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        CRMApplication: Record "CRM Application";
        ErrorOnExistingApplicationTxt: Label 'Apllication already attached to application No. %1-%2';
        AccountApplication: Record "Account Application";
    begin
        RecRef.GetTable(Variant);
        Gensetup.Get();
        case RecRef.Number of
            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberAppl);

                    Gensetup.TestField("Application Source (Member)");
                    case Gensetup."Application Source (Member)" of
                        Gensetup."Application Source (Member)"::CRM:
                            begin
                                if not fnCheckExistingApplication(MemberAppl."CRM Application No.") then begin
                                    CRMApplication.Reset;
                                    CRMApplication.SetRange(Created, false);
                                    CRMApplication.SetRange("No.", MemberAppl."CRM Application No.");
                                    if CRMApplication.FindFirst then begin
                                        CRMApplication.fnValidateMinRequiredItems;
                                        MemberAppl.Validate(Name, CRMApplication.Name);
                                        MemberAppl.Validate("Identification Type", CRMApplication."Identification Type");
                                        case CRMApplication."Identification Type" of
                                            CRMApplication."Identification Type"::"National ID":
                                                begin
                                                    MemberAppl.Validate("ID No.", CRMApplication."ID No.");
                                                end else begin
                                                MemberAppl.Validate("Passport No.", CRMApplication."ID No.");
                                            end;
                                        end;
                                    end;
                                end else begin
                                    Error(ErrorOnExistingApplicationTxt, MemberAppl."No.", MemberAppl.Name)
                                end
                            end;
                    end;
                    Variant := MemberAppl;
                end;
            DATABASE::"Account Application":
                begin

                    Gensetup.TestField("Application Source (Account)");
                    case Gensetup."Application Source (Account)" of
                        Gensetup."Application Source (Account)"::CRM:
                            begin
                                if not fnCheckExistingApplication(AccountApplication."CRM Application No.") then begin

                                    CRMApplication.Reset;
                                    CRMApplication.SetRange(Created, false);
                                    CRMApplication.SetRange("No.", AccountApplication."CRM Application No.");
                                    if CRMApplication.FindFirst then begin
                                        CRMApplication.TestField("Member No.");
                                        CRMApplication.TestField("Product Type");
                                        AccountApplication.Validate("Member No.", CRMApplication."Member No.");
                                        AccountApplication.Validate("Product Type", CRMApplication."Product Type");
                                        AccountApplication.Modify
                                    end;
                                end else begin
                                    Error(ErrorOnExistingApplicationTxt, AccountApplication."No.", AccountApplication.Name)
                                end
                            end;
                    end;
                    Variant := AccountApplication
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    procedure fnCheckExistingApplication(CodeNo: Code[50]): Boolean
    var
        MemberApplication: Record "Member Application";
    begin
        MemberApplication.Reset;
        MemberApplication.SetRange("CRM Application No.", CodeNo);
        if MemberApplication.Find('-') then
            exit(true) else
            exit(false)
    end;

    procedure InitTempBankingAcEntry(Varvariant: Record Member; var BankingAcRecordEntry: Record "Account (Procedure)"; AccSuffix: Code[10]; AccPrefix: Code[10]; Dim1: Code[10]; CustNo: Code[10])
    var
    begin
        BankingAcRecordEntry.INIT;
        BankingAcRecordEntry."No." := AccPrefix + CustNo + AccSuffix + Dim1;
        BankingAcRecordEntry.CopyFromCustomerMemberEntries(VarVariant)
    end;

    procedure InitTempCreditAcEntry(VarVariant: Record Member; var CredAcRecordEntry: Record "Account (Member)"; AccSuffix: Code[10]; AccPrefix: Code[10]; Dim1: Code[10]; CustNo: Code[10])
    begin
        CredAcRecordEntry.INIT;
        CredAcRecordEntry."No." := AccPrefix + CustNo + AccSuffix + Dim1;
        CredAcRecordEntry.CopyFromCustomerMemberEntries(VarVariant)
    end;

    procedure fnInitializeTempAccountBanking(VarVariant: Record "Member Application"; var acc: Record "Account (Procedure)")
    begin
        Acc.Init();
        Acc.CopyFromMemberApplicationEntries(VarVariant);
    end;

    procedure InitializeTempAccountBanking(VarVariant: Record Member; var acc: Record "Account (Procedure)")
    begin
        Acc.Init();
        Acc.CopyFromCustomerMemberEntries(VarVariant);
    end;

    procedure fnInitializeTempAccountCredit(VarVariant: Record "Member Application"; var acc: Record "Account (Member)")
    begin
        Acc.Init();
        Acc.CopyFromMemberApplicationEntries(VarVariant);
    end;

    procedure InitializeRepaymentAcc(VarVariant: Record Member; var Acc: Record "Repayment Account")
    begin
        Acc.Init;
        Acc.CopyFromMemberCustEntries(VarVariant);
    end;



    procedure InitializeCustTempAccountCredit(VarVariant: Record Member; var acc: Record "Account (Member)")
    begin
        Acc.Init();
        Acc.CopyFromCustomerMemberEntries(VarVariant);
    end;

    procedure fnAccountActivateDeactivate(RecRef: Record "Member Changes")
    var
        AccMember: Record Member;
        AccBanking: Record "Account Banking";
        AccCredit: Record "Account Credit";
        RegisterMngts: Codeunit "Register Management";
        Change: Record "Member Changes";
    begin
        RecRef.TestField("Approval Status", RecRef."Approval Status"::Approved);
        case RecRef."Changes Type" of

            RecRef."Changes Type"::"Account Activation":
                begin
                    if RecRef."Operation Type" = RecRef."Operation Type"::"All Accounts" then begin
                        AccMember.Reset();
                        AccMember.SetRange("No.", RecRef."Member No.");
                        if AccMember.FindFirst() then begin
                            AccMember.Status := AccMember.Status::Active;
                            AccMember.Modify(true);
                            RegisterMngts.PostAccountActDeact(2, 0, AccMember."No.", RecRef."No.");
                            if Change.Get(RecRef."No.") then begin
                                Change."Approval Status" := Change."Approval Status"::Posted;
                                Change."Posted By" := UserId;
                                Change."Date Posted" := CurrentDateTime;
                                Change.Modify(true);
                                SmsNotification.CreateSmsNotif(NotifSource::"Account Status", AccMember."Mobile Phone No", 'Dear ' +
                                AccBanking.Name + ' your Account has been successfully reactivated.', AccMember."ID No.", AccMember."No.", false);
                            end;
                        end;
                    end else begin
                        AccBanking.Reset();
                        AccBanking.SetRange("No.", RecRef."Account No.");
                        if AccBanking.FindFirst() then begin
                            RegisterMngts.PostAccountActDeact(0, 0, AccBanking."No.", RecRef."No.");
                            if Change.Get(RecRef."No.") then begin
                                Change."Approval Status" := Change."Approval Status"::Posted;
                                Change."Posted By" := UserId;
                                Change."Date Posted" := CurrentDateTime;
                                Change.Modify(true);
                                Change.Modify(true);
                                SmsNotification.CreateSmsNotif(NotifSource::"Account Status", AccBanking."Mobile No.", 'Dear ' +
                                AccBanking.Name + ' your Fosa Account has been successfully reactivated.', AccBanking."Member No.", AccBanking."No.", false);
                            end;
                        end;
                        if RecRef."Product Type" = RecRef."Product Type"::"Shares Deposit" then begin
                            AccCredit.Reset();
                            AccCredit.SetRange("No.", RecRef."Account No.");
                            if AccCredit.FindFirst() then begin
                                RegisterMngts.PostAccountActDeact(1, 0, AccCredit."No.", RecRef."No.")
                            end;
                        end;
                    end;
                end;
            RecRef."Changes Type"::"Deceased Account":
                begin
                    RegisterMngts.PostAccountActDeact(3, 0, RecRef."Member No.", RecRef."No.");
                    if Change.Get(RecRef."No.") then begin
                        Change."Approval Status" := Change."Approval Status"::Posted;
                        Change."Posted By" := UserId;
                        Change."Date Posted" := CurrentDateTime;
                        Change.Modify(true);
                    end;
                end;
            RecRef."Changes Type"::"Account Deactivation":
                begin

                    case RecRef."Operation Type" of
                        RecRef."Operation Type"::"All Accounts":
                            begin
                                if RecRef."Account Type" = RecRef."Account Type"::Banking then begin
                                    RegisterMngts.DeactivateAcc(0, 0, RecRef."Member No.");
                                end;
                                if RecRef."Account Type" = RecRef."Account Type"::Credit then begin
                                    RegisterMngts.DeactivateAcc(0, 2, RecRef."Member No.");
                                end;
                            end;
                        RecRef."Operation Type"::"Single Account":
                            begin
                                if RecRef."Account Type" = RecRef."Account Type"::Banking then begin
                                    RegisterMngts.DeactivateAcc(0, 1, RecRef."Member No.");
                                end;
                                if RecRef."Account Type" = RecRef."Account Type"::Credit then begin
                                    RegisterMngts.DeactivateAcc(0, 3, RecRef."Member No.");

                                end;
                            end;

                    end;

                    if Change.Get(RecRef."No.") then begin
                        Change."Approval Status" := Change."Approval Status"::Posted;
                        Change."Posted By" := UserId;
                        Change."Date Posted" := CurrentDateTime;
                        Change.Modify(true);
                    end;

                end;
            RecRef."Changes Type"::"Block Account":
                begin

                    case RecRef."Operation Type" of
                        RecRef."Operation Type"::"All Accounts":
                            begin
                                if RecRef."Account Type" = RecRef."Account Type"::Banking then begin
                                    RegisterMngts.DeactivateAcc(1, 0, RecRef."Member No.");
                                end;
                                if RecRef."Account Type" = RecRef."Account Type"::Credit then begin
                                    RegisterMngts.DeactivateAcc(1, 2, RecRef."Member No.");
                                end;
                            end;
                        RecRef."Operation Type"::"Single Account":
                            begin
                                if RecRef."Account Type" = RecRef."Account Type"::Banking then begin
                                    RegisterMngts.DeactivateAcc(1, 1, RecRef."Member No.");
                                end;
                                if RecRef."Account Type" = RecRef."Account Type"::Credit then begin
                                    RegisterMngts.DeactivateAcc(1, 3, RecRef."Member No.");

                                end;
                            end;

                    end;

                    if Change.Get(RecRef."No.") then begin
                        Change."Approval Status" := Change."Approval Status"::Posted;
                        Change."Posted By" := UserId;
                        Change."Date Posted" := CurrentDateTime;
                        Change.Modify(true);
                    end;

                end;
        end;
    end;

    procedure PerformPostOnPostChanges(RecRef: Record "Member Changes")
    var
        RegistrationProcess: Codeunit "Registry Mngt.";
    begin
        case RecRef."Changes Type" of
            RecRef."Changes Type"::" ",
                            RecRef."Changes Type"::Images,
                            RecRef."Changes Type"::"Kin Details",
                            RecRef."Changes Type"::"Membership Details",
                            RecRef."Changes Type"::"Account Signatories":
                Error('The Option selected is not allowed');
        end;
        fnAccountActivateDeactivate(RecRef);
    end;

    procedure PostCardLink(VarVariant: Record "Member Changes")
    var
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        Temp: Record "Banking User Template";

    begin
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        if VarVariant."Approval Status" = VarVariant."Approval Status"::Approved then begin
            BnkMgt.CardLinkAccount(VarVariant, Temp."Periodic Journal Template",
            Temp."Periodic Journal Batch", Temp."Shortcut Dimension 1 Code",
            Temp."Shortcut Dimension 2 Code", 0);
        end else begin
            Error('Application not approved');
        end;
    end;

    procedure PostSafeCustody(VarVariant: Record "Collateral Register")
    var
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        Temp: Record "Banking User Template";
        TellerTrans: Record "Teller Transaction";
        AccountFosa: Record "Account Banking";

    begin
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        VarVariant.TestField("Transaction Type");
        VarVariant.TestField("Account No.");
        VarVariant.TestField("Savings Account No.");

        VarVariant.TestField("Terms & Conditions", true);
        if VarVariant."Approval Status" = VarVariant."Approval Status"::Approved then begin
            BnkMgt.PerformPostOnSafeCustody(VarVariant, Temp."Periodic Journal Template",
            Temp."Periodic Journal Batch", Temp."Shortcut Dimension 1 Code",
            Temp."Shortcut Dimension 2 Code", 0);
        end else begin
            Error('This Application is yet not approved');
        end;
    end;

    procedure PostSafeCustodyAutomated(VarVariant: Record "Collateral Register")
    var
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        Temp: Record "Banking User Template";

    begin
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        VarVariant.TestField("Transaction Type");
        VarVariant.TestField("Account No.");
        VarVariant.TestField("Savings Account No.");
        VarVariant.TestField("Terms & Conditions", true);
        if VarVariant."Approval Status" = VarVariant."Approval Status"::Posted then begin
            BnkMgt.PerformPostOnSafeCustodyRenew(VarVariant, Temp."Periodic Journal Template",
            Temp."Periodic Journal Batch", Temp."Shortcut Dimension 1 Code",
            Temp."Shortcut Dimension 2 Code", 0);
        end else begin
            Error('This Application is yet not approved');
        end;
    end;

    procedure PostSafeCustodyCollection(VarVariant: Record "Security Collection")
    var
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        Temp: Record "Banking User Template";
        SafeDoc: Record "Collateral Register";

    begin
        Temp.Get(UserId);
        Temp.TestField("Periodic Journal Template");
        Temp.TestField("Periodic Journal Batch");
        Temp.TestField("Shortcut Dimension 1 Code");
        Temp.TestField("Shortcut Dimension 2 Code");
        VarVariant.TestField("Account No.");
        VarVariant.TestField("Savings Account No.");
        if VarVariant."Operation Type" = VarVariant."Operation Type"::Retrieval then
            VarVariant.TestField("Transaction Type");
        if VarVariant."Approval Status" = VarVariant."Approval Status"::Approved then begin
            SafeDoc.Reset();
            SafeDoc.SetRange("No.", VarVariant."Collateral Register No.");
            if SafeDoc.FindFirst() then begin

                if VarVariant."Operation Type" = VarVariant."Operation Type"::Retrieval then begin
                    BnkMgt.PerformPostOnCustodyCollection(VarVariant, Temp."Periodic Journal Template",
                    Temp."Periodic Journal Batch", Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code", 0);
                end else begin
                    BnkMgt.MarkCustodyCollectionAsReturned(VarVariant, Temp."Periodic Journal Template",
                    Temp."Periodic Journal Batch", Temp."Shortcut Dimension 1 Code",
                    Temp."Shortcut Dimension 2 Code", 0);
                end;
            end;
        end else begin
            Error('This Application is yet not approved');
        end;
    end;

    procedure RestrictedAccountMngt(AccountNo: Code[100]; UserTemp: Code[100])
    begin
        ProctedAcc.Reset();
        ProctedAcc.SetRange("Account No.", AccountNo);
        ProctedAcc.SetRange("Restrict Viewship (Statement)", true);
        if ProctedAcc.FindFirst() then begin

            RestrictRecord.Reset();
            RestrictRecord.SetRange("Account No.", UserTemp);
            RestrictRecord.SetRange("Restrict Viewship (Statement)", true);
            if RestrictRecord.FindFirst() then
                Error(ErrorOnRestrictReportTxt);
        end;

    end;

    procedure getfileNo(AccountNo: Code[100]): Code[100]
    var
        CustRecord: Record Member;
    begin
        CustRecord.Reset();
        CustRecord.SetRange("No.", AccountNo);
        if CustRecord.FindFirst() then begin
            exit(CustRecord."File No.")
        end else begin
            exit('')
        end;
    end;

    procedure generateCustomerStopOrder(ObjEmpCode: Code[20]; PostInt: Boolean)
    var
        CustRecord: Record Member;
        Account: Record "Account Banking";
        CredAccount: Record "Account Credit";
        Loans: Record "Loans Categorization";
        ProdFact: Record "Product Factory";
        Contribution: Record "Member Monthly Contribution";
    begin

        CustRecord.Reset();
        CustRecord.SetRange("No.", ObjEmpCode);
        CustRecord.SetFilter(Status, '%1 | %2 | %3', CustRecord.Status::Active, CustRecord.Status::Dormant, CustRecord.Status::New);
        if CustRecord.Find('-') then begin

            ProdFact.Reset();
            ProdFact.SetRange(Status, ProdFact.Status::Active);
            ProdFact.SetRange("Product Class", ProdFact."Product Class"::Account);
            ProdFact.SetRange("Account Dimension", ProdFact."Account Dimension"::Credit);
            ProdFact.SetFilter("Account Category", '%1 | %2', ProdFact."Account Category"::"Shares Deposit", ProdFact."Account Category"::"Shares Capital");
            if ProdFact.FindSet() then begin
                repeat
                    CredAccount.Reset();
                    CredAccount.SetRange("Member No.", CustRecord."No.");
                    CredAccount.SetRange("Account Category", ProdFact."Account Category");
                    if CredAccount.FindFirst() then begin

                        Contribution.Reset();
                        Contribution.SetRange("Application No.", CredAccount."No.");
                        if not Contribution.FindFirst() then begin

                            Contribution.Init();
                            Contribution.Validate("Account No.", CustRecord."No.");
                            Contribution.Type := CredAccount."Account Category";
                            Contribution.Validate("Application No.", CredAccount."No.");
                            Contribution.Validate(Amount, ProdFact."Minimum Contribution");
                            Contribution."Advise Type" := Contribution."Advise Type"::"Change (Increase/Decrease)";
                            Contribution.Remarks := Format(CredAccount."Account Category");
                            Contribution.Insert(true)
                        end;
                    end;
                until ProdFact.Next() = 0;
            end;

            ProdFact.Reset();
            ProdFact.SetRange(Status, ProdFact.Status::Active);
            ProdFact.SetRange("Product Class", ProdFact."Product Class"::Account);
            ProdFact.SetRange("Account Dimension", ProdFact."Account Dimension"::Banking);
            ProdFact.SetFilter("Account Category", '%1', ProdFact."Account Category"::"Specialty Savings");
            if ProdFact.FindSet() then begin

                Account.Reset();
                Account.SetRange("Member No.", CustRecord."No.");
                Account.SetRange("Account Category", ProdFact."Account Category");
                if Account.FindFirst() then begin

                    Contribution.Reset();
                    Contribution.SetRange("Application No.", Account."No.");
                    if not Contribution.FindFirst() then begin

                        Contribution.Init();
                        Contribution.Validate("Account No.", Account."Member No.");
                        Contribution.Type := Account."Account Category";
                        Contribution.Validate("Application No.", Account."No.");
                        Contribution.Validate(Amount, ProdFact."Minimum Contribution");
                        Contribution."Advise Type" := Contribution."Advise Type"::"Change (Increase/Decrease)";
                        Contribution.Remarks := Format(Account."Account Category");
                        Contribution.Insert(true)
                    end;
                end;
            end;

            Loans.Reset();
            Loans.SetRange("Account No.", CustRecord."No.");
            if Loans.FindFirst() then begin
                repeat
                    Loans.CalcFields("Outstanding Balance");
                    if Loans."Outstanding Balance" > 0 then begin
                        Contribution.Reset();
                        Contribution.SetRange("Application No.", Loans."No.");
                        if not Contribution.FindFirst() then begin

                            Contribution.Init();
                            Contribution.Validate("Account No.", CustRecord."No.");
                            Contribution.Type := Contribution.Type::" ";
                            Contribution.Validate("Application No.", Loans."No.");
                            Contribution.Validate(Amount, Loans.Repayment);
                            Contribution."Advise Type" := Contribution."Advise Type"::Variations;
                            Contribution.Remarks := Loans."Product Description";
                            Contribution.Insert(true)
                        end;
                    end;
                Until Loans.Next() = 0;
            end;
        end;
    end;

    procedure InitializeQcQualAmount(VarVariant: Record Member; var QCDetails: Record "QC Qualifying Amount")
    begin
        QCDetails.Init;
        QCDetails.CopyFromCustDetail(VarVariant);
    end;

}




