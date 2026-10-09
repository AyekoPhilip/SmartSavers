codeunit 50030 "Register Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        RegisterNo: Integer;
        FromEntryNo: Integer;
        ProdCategory: Enum ProductAccountCategory;
        ToEntryNo: Integer;
        DescriptionTxt: Text[250];
        ApprovalsMngt: Codeunit "Approval Mgmt.";
        RegistryMngt: Codeunit "Registry Mngt.";
        ApprovalEntry: Record "Approval Entry";
        PostAc: Variant;
        Trans: Record "ATM Transaction";
        MTransactions: Record "Mobile Loan Transaction";
        MobTrans: Record "Mobile Money Transaction";
        NotifSource: Enum NotifSourceType;
        DscScoringMngt: Codeunit "DSC Credit Analysis";

    procedure ResetValues()
    begin
        RegisterNo := 0;
        FromEntryNo := 0;
        ToEntryNo := 0;
    end;


    procedure SetRegisterNumber(var "No.": Integer)
    begin
        RegisterNo := "No.";
    end;


    procedure SetFromEntryNumber(var "No.": Integer)
    begin
        FromEntryNo := "No.";
    end;


    procedure SetToEntryNumber(var "No.": Integer)
    begin
        ToEntryNo := "No.";
    end;


    procedure GetRegisterNumber() RegisterNumber: Integer
    begin
        RegisterNumber := RegisterNo;
        exit(RegisterNumber);
    end;

    local procedure InitializeKinDetails(VarVariant: Record "Next of KIN"; var KinDetails: Record "Next of KIN Application"; AccNo: Code[20])
    begin
        KinDetails.Init;
        KinDetails."Application No." := AccNo;
        KinDetails.CopyFromApplicationKinDetails(VarVariant);
        OnAfterInitnextOfkinEntry(KinDetails, VarVariant);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitnextOfkinEntry(var NextOfKin: Record "Next of KIN Application"; Applic: Record "Next of KIN")
    begin
    end;

    local procedure InitializeAgreementDetails(VarVariant: Record "Guarantor & Security Posted"; var GuarantLine: Record "Loan Guarantors Sub"; DocNo: Code[100]; AccNo: Code[20]; LoanNo: Code[50])
    begin
        VarVariant.Init();

        VarVariant."No." := DocNo;
        VarVariant."Security Type" := VarVariant."Security Type"::Guarantor;
        VarVariant."Loan No." := LoanNo;
        VarVariant.Validate("Account No.", AccNo);
        VarVariant.CopyFromLoanGuarantLinesub(GuarantLine);
    end;

    procedure PassAgreement(LoanNo: Code[20]; CodeNo: Code[50]; AccountNo: Code[100]; ValuePost: Integer)
    var
        LoanAreement: Record "Guarantor & Security Posted";
        LoanSubLine: Record "Loan Guarantors Sub";
        LoanSub: Record "Loan Guarantors Sub";
        GuarantHeader: Record "Guarantors Substitution";
        PLoan: Record Loans;
        CredAccount: Record "Account Credit";
    begin
        LoanSub.Reset();
        LoanSub.SetRange("No.", CodeNo);
        LoanSub.SetRange(Posted, false);
        LoanSub.DeleteAll();

        case ValuePost of
            0:
                begin
                    LoanAreement.Reset();
                    LoanAreement.SetRange("Loan No.", LoanNo);
                    LoanAreement.SetRange("Account No.", AccountNo);
                    LoanAreement.SetRange(Substituted, false);
                    if LoanAreement.FindSet() then begin
                        repeat
                            LoanSubLine.Init();
                            LoanSubLine."No." := CodeNo;
                            LoanSubLine."Security Type" := LoanAreement."Security Type";
                            LoanSubLine."Non Subsituted" := true;
                            LoanSubLine."Loan No" := LoanAreement."Loan No.";
                            LoanSubLine.Name := LoanAreement.Name;
                            LoanSubLine."Savings Account No." := LoanAreement."Account No.";
                            LoanSubLine."Amount Guaranteed" := LoanAreement."Amount Guaranteed";
                            LoanSubLine."Loan Product Type" := LoanAreement."Product Type";
                            LoanSubLine."Member No" := LoanAreement."Member No.";
                            LoanSubLine."Application No." := LoanAreement."No.";
                            LoanSubLine.Shares := LoanAreement."Deposit Shares";
                            LoanSubLine.Ignored := true;
                            LoanSubLine."Available Shares" := LoanAreement."Available Shares";
                            LoanSubLine."Outstanding Balance" := LoanAreement."Outstanding Balance";
                            LoanSubLine."No Of Loans Guaranteed" := LoanAreement."No. of Loans Guaranteed";
                            LoanSubLine.Insert(true)
                        until LoanAreement.Next() = 0;
                    end;

                end;
            1:
                begin

                    PLoan.Reset();
                    PLoan.SetRange("No.", LoanNo);
                    if PLoan.FindFirst() then begin
                        PLoan.CalcFields("Outstanding Balance");

                        LoanSubLine.Init();
                        LoanSubLine."No." := CodeNo;
                        LoanSubLine."Loan No" := PLoan."No.";
                        LoanSubLine.Validate("Savings Account No.", AccountNo);
                        LoanSubLine."Non Subsituted" := false;
                        LoanSubLine."Amount Guaranteed" := 0;
                        LoanSubLine."Loan Product Type" := PLoan."Product Type";
                        LoanSubLine."Member No" := PLoan."Account No.";
                        LoanSubLine.Ignored := false;
                        LoanSubLine."Outstanding Balance" := PLoan."Outstanding Balance";
                        LoanSubLine.Insert(true)

                    end;
                end;
        end;
    end;


    procedure PostSubstitutionLine(RecRef: Record "Guarantors Substitution"; PostInt: Integer)
    var
        SubstitutionLine: Record "Loan Guarantors Sub";
        Agreemngt: record "Guarantor & Security Posted";
        RegMgnt: Codeunit "Register Management";
        Notif: Codeunit "SMS Notification";
        AccCredit: Record "Account Credit";
        PFact: Record "Product Factory";
        CrMngt: Codeunit "Credit Mgmt.";
        Ploan: Record Loans;
    begin

        RecRef.CheckMinRequiredInfo();

        if RecRef."Application Type" = RecRef."Application Type"::"Update Amount Guaranteed" then begin
            Agreemngt.SetRange("Loan No.",RecRef."Loan No.");
            Agreemngt.SetRange("Account No.", RecRef."Guarantors To Be Substituted");
            if Agreemngt.FindFirst() then begin
                Agreemngt.Validate("Amount Guaranteed", RecRef."Amount Guaranteed");
                Agreemngt.Modify(true)
            end;
            
        end else begin

            SubstitutionLine.LockTable();
            SubstitutionLine.SetRange("Non Subsituted", false);
            SubstitutionLine.SetFilter("No.", '<>%1', '');
            SubstitutionLine.SetFilter("Loan No", '<>%1', '');
            SubstitutionLine.SetRange(Substituted, false);
            SubstitutionLine.SetRange("No.", RecRef."No.");
            SubstitutionLine.SetRange("Loan No", RecRef."Loan No.");
            SubstitutionLine.SetFilter("Savings Account No.", '<>%1', '');
            if SubstitutionLine.FindSet() then begin
                repeat

                    Agreemngt.Init();
                    if Ploan.Get(SubstitutionLine."Loan No") then
                        Agreemngt."No." := Ploan."Application No.";
                    Agreemngt."Loan No." := SubstitutionLine."Loan No";
                    Agreemngt."Product Type" := Ploan."Product Type";
                    Agreemngt."ID No." := Ploan."ID No.";
                    Agreemngt."Security Type" := SubstitutionLine."Security Type";
                    Agreemngt.Validate("Account No.", SubstitutionLine."Savings Account No.");
                    Agreemngt."Amount Guaranteed" := SubstitutionLine."Amount Guaranteed";
                    Agreemngt.Insert(true);

                    if Ploan.Get(SubstitutionLine."Loan No") then
                        PFact.Get(Ploan."Product Type");
                    if AccCredit.Get(SubstitutionLine."Savings Account No.") then begin
                        if not SubstitutionLine."SMS Sent" then begin

                            case RecRef."Send Notification" of
                                RecRef."Send Notification"::SMS:
                                    begin
                                        Notif.CreateSmsNotif(NotifSource::"Loan Guarantors", AccCredit."Mobile No.",
                                        'Your have been substituted to guarantee ' +
                                        SubstitutionLine.Name + ' Loan Type:  ' + PFact.Description +
                                        '. If in dispute call ******',
                                        AccCredit."No.", AccCredit."Member No.", false);
                                    end;
                            end;
                            Commit();
                            SubstitutionLine.Posted := true;
                            SubstitutionLine."SMS Sent" := true;
                            SubstitutionLine.Modify(true);
                        end;

                    end;
                until SubstitutionLine.Next() = 0;
            end;

              case RecRef."Application Type" of
            RecRef."Application Type"::Substitution:
                CrMngt.UpdateChangesOnGuarantorLine(RecRef."Loan No.",
                RecRef."Guarantors To Be Substituted");
        end;
        end;

        RecRef.Posted := true;
        RecRef."Posted By" := UserId;
        RecRef."Approval Status" := RecRef."Approval Status"::Posted;
        RecRef.Modify(true);
        if PostInt = 1 then
            Message('Application successfully Posted');
    end;

    procedure GetFromEntryNo() EntryNo: Integer
    begin
        EntryNo := FromEntryNo;
        exit(EntryNo);
    end;

    procedure GetToEntryNo() EntryNo: Integer
    begin
        EntryNo := ToEntryNo;
        exit(EntryNo);
    end;

    procedure fnActionPaneItems(var Variant: Variant; ActionItem: Option "Send Approval Request","Cancel Approval Request","Open Request",Approval,Post,"Kin Details",Files,"Product Charges",Account,Block)
    var
        RecRef: RecordRef;
        PFact: Record "Product Factory";
        MemberApp: Record "Member Application";
        AccountApp: Record "Account Application";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        ProductCharges: Record "Loan Product Charges";
        KinDetails: Record "Next of KIN Application";
        DefaultAccApp: Record "Default Accounts Application";
        OnConfirmDialogMembTxt: Label 'Are you sure you want to create this member account?';
        MemberChanges: Record "Member Changes";
        SignatoryApp: Record "Signatory Application";
        SendNotif: Codeunit "SMS Notification";
        VarVariant: Variant;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            DATABASE::"Product Factory":
                begin
                    RecRef.SetTable(PFact);
                    case ActionItem of
                        ActionItem::"Send Approval Request":
                            begin
                                PFact.fnCheckMinApprovalRequirements;
                                ApprovalsMngt.SendProductFactRequest(PFact)
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                                if ApprovalsMngt.CancelProductFactApprovalRequest(PFact, true, true) then;
                            end;
                        ActionItem::"Open Request":
                            begin
                                if ApprovalsMngt.OpenProductFactApprovalRequest(PFact, true, true) then
                                    ;
                            end;
                        ActionItem::Block:
                            begin
                                if ApprovalsMngt.BlockProductFactApprovalRequest(PFact, true, true) then
                                    ;
                            end;
                        ActionItem::Approval:
                            begin
                                ApprovalEntry.Reset;
                                ApprovalEntry.SetRange("Document No.", PFact."Product ID");
                                if ApprovalEntry.Find('-') then
                                    PAGE.Run(PAGE::"Approval Requests", ApprovalEntry,
                                       ApprovalEntry."Document No.")
                            end;
                        ActionItem::"Product Charges":
                            begin
                                ProductCharges.Reset;
                                ProductCharges.SetRange("Product Code", PFact."Product ID");
                                if ProductCharges.Find('-') then
                                    PAGE.Run(PAGE::"Loan Product Charges", ProductCharges,
                                        ProductCharges."Product Code")
                            end;
                    end;
                    Variant := PFact;
                end;
            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberApp);
                    case ActionItem of
                        ActionItem::"Send Approval Request":
                            begin
                                MemberApp.CheckMinimumRegistrationEntry;
                                ApprovalsMngt.SendAccOpeningRequest(MemberApp)
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                                ApprovalsMngt.CancelAccOpeninApprovalRequest(
                                  MemberApp, true, true);
                            end;
                        ActionItem::"Open Request":
                            begin
                                ApprovalsMngt.OpenAccOpeninApprovalRequest(
                                  MemberApp, true, true)
                            end;
                        ActionItem::Approval:
                            begin
                                ApprovalEntry.Reset;
                                ApprovalEntry.SetRange("Document No.", MemberApp."No.");
                                if ApprovalEntry.Find('-') then
                                    PAGE.Run(PAGE::"Approval Requests", ApprovalEntry,
                                       ApprovalEntry."Document No.")
                            end;
                        ActionItem::"Kin Details":
                            begin
                                KinDetails.Reset;
                                KinDetails.SetRange("Account No", MemberApp."No.");
                                if KinDetails.Find('-') then
                                    PAGE.Run(PAGE::"Next of KIN Application",
                                     KinDetails, KinDetails."Account No")
                            end;
                        ActionItem::Account:
                            begin
                                DefaultAccApp.Reset;
                                DefaultAccApp.SetRange("No.", MemberApp."No.");
                                if DefaultAccApp.Find('-') then
                                    PAGE.Run(PAGE::"Savings Account Registration",
                                        DefaultAccApp, DefaultAccApp."No.")
                            end;
                        ActionItem::Post:
                            begin
                                if Confirm(OnConfirmDialogMembTxt, true) = false then
                                    exit;
                                RegistryMngt.CustomerRegistration(MemberApp, 1)
                            end
                    end;
                    Variant := MemberApp
                end;

            DATABASE::"Member Changes":
                begin
                    RecRef.SetTable(MemberChanges);
                    case ActionItem of
                        ActionItem::"Send Approval Request":
                            begin
                                MemberChanges.TestField("Changes Type");
                                MemberChanges.TestField("Member No.");
                                MemberChanges.TestField("Resons for Status Change");
                                if MemberChanges."Terms of Employment" = MemberChanges."Terms of Employment"::Contract then
                                    MemberChanges.TestField("Contract End Date");
                                MemberChanges.SendEmailNotif();
                                ApprovalsMngt.OnSendChangesAppRequest(MemberChanges)
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                                ApprovalsMngt.OnCancelChangesApprovalRequest(MemberChanges, true, true)

                            end;
                        ActionItem::"Open Request":
                            begin
                                ApprovalsMngt.OnOpenChangesApprovalRequest(MemberChanges, true, true)
                            end;
                        ActionItem::Approval:
                            begin
                                ApprovalEntry.Reset;
                                ApprovalEntry.SetRange("Document No.", MemberChanges."No.");
                                if ApprovalEntry.Find('-') then
                                    PAGE.Run(PAGE::"Approval Requests", ApprovalEntry, ApprovalEntry."Document No.")
                            end;
                        ActionItem::"Kin Details":
                            begin
                                KinDetails.Reset;
                                KinDetails.SetRange("Account No", MemberChanges."Member No.");
                                if KinDetails.Find('-') then begin
                                    PAGE.Run(PAGE::"Next of KIN Application", KinDetails, KinDetails."Account No")
                                end;

                            end;

                        ActionItem::Account:
                            begin
                                SignatoryApp.Reset;
                                SignatoryApp.SetRange("Account No.", MemberChanges."Member No.");
                                if SignatoryApp.Find('-') then
                                    PAGE.Run(PAGE::"Signatory Application", SignatoryApp, SignatoryApp."Account No.")
                            end;
                        ActionItem::Post:
                            begin
                                if Confirm(OnConfirmDialogTxt, true) = false then
                                    exit;
                                MemberChanges.TestField("Changes Type");
                                MemberChanges.TestField("Member No.");
                                case
                                    MemberChanges."Changes Type" of
                                    MemberChanges."Changes Type"::"Membership Details":
                                        RegistryMngt.PerformPostOnCustomerChangesTxt(MemberChanges);
                                    MemberChanges."Changes Type"::Images:
                                        RegistryMngt.PostMediaChanges(MemberChanges);
                                    MemberChanges."Changes Type"::Contribution:
                                        RegistryMngt.PostMemberContribution(MemberChanges);
                                    MemberChanges."Changes Type"::"Kin Details":
                                        RegistryMngt.PostKinDetailsChanges(MemberChanges);
                                    MemberChanges."Changes Type"::"Account Signatories":
                                        RegistryMngt.PostAccSignatoryChanges(MemberChanges);
                                end;

                            end
                    end;
                    Variant := MemberChanges
                end;
            DATABASE::"Account Application":
                begin
                    RecRef.SetTable(AccountApp);
                    case ActionItem of
                        ActionItem::"Send Approval Request":
                            begin
                                AccountApp.fnCheckDetails;
                                AccountApp.fnValidateMultipleAccountCreation;
                                ApprovalsMngt.SendAccountAppRequest(AccountApp)
                            end;
                        ActionItem::"Cancel Approval Request":
                            begin
                                ApprovalsMngt.CancelAccountAppApprovalRequest(AccountApp, true, true)
                            end;
                        ActionItem::"Open Request":
                            begin
                                ApprovalsMngt.OpenAccountAppApprovalRequest(AccountApp, true, true)

                            end;
                        ActionItem::Approval:
                            begin
                                ApprovalEntry.Reset;
                                ApprovalEntry.SetRange("Document No.", AccountApp."No.");
                                if ApprovalEntry.Find('-') then
                                    PAGE.Run(PAGE::"Approval Requests", ApprovalEntry,
                                       ApprovalEntry."Document No.")
                            end;
                        ActionItem::Post:
                            begin
                                if Confirm(OnConfirmDialogTxt, true) = false then
                                    exit;
                                PostAccount(AccountApp)
                            end
                    end;
                    Variant := AccountApp
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;

    local procedure InitializeLoanCharges(VarVariant: Record "Loan Product Charges"; var AppCharges: Record "Loan Application Charge"; AccNo: Code[20])
    begin
        AppCharges.Init;
        AppCharges."Application No." := AccNo;
        AppCharges.CopyFromLoanProductCharges(VarVariant);
        OnAfterInitLoanChargesEntry(AppCharges, VarVariant);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanChargesEntry(var AppCharges: Record "Loan Application Charge"; PCharges: Record "Loan Product Charges")
    begin
    end;


    procedure fnPostAccountchanges(var Variant: Variant; NameTxt: Text[100]; GlobalDim: Code[20]; StatusTxt: Integer; GroupAccountNo: Code[20]; GroupAccount: Boolean; IDPassportNo: Code[20]; MobileNo: Code[20]; EmployerCode: Code[20]; DateofBirth: Date; PhoneNo: Code[50])
    var
        RecRef: RecordRef;
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        AccountProc: Record "Account (Procedure)";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        RepayAc: Record "Repayment Account";
        MemberChanges: Record "Member Changes";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            DATABASE::"Member Changes":
                begin
                    RecRef.SetTable(MemberChanges);
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", MemberChanges."Member No.");
                    if AccountB.Find('-') then begin
                        repeat
                            AccountB.Name := NameTxt;
                            AccountB."Global Dimension 2 Code" := GlobalDim;
                            AccountB."Group Account No" := GroupAccountNo;
                            AccountB."Group Account" := GroupAccount;
                            AccountB."ID/Passport No." := IDPassportNo;
                            AccountB."Mobile No." := MobileNo;
                            AccountProc."Phone No." := PhoneNo;
                            AccountB."Date of Birth" := DateofBirth;
                            AccountB."Employer Code" := EmployerCode;
                            AccountB.Modify
                        until AccountB.Next = 0;
                    end;

                    AccountProc.Reset;
                    AccountProc.SetRange("Member No.", MemberChanges."Member No.");
                    if AccountProc.Find('-') then begin
                        repeat
                            AccountProc.Name := NameTxt;
                            AccountProc."Global Dimension 2 Code" := GlobalDim;
                            AccountProc."Group Account No" := GroupAccountNo;
                            AccountProc."Group Account" := GroupAccount;
                            AccountProc."ID/Passport No." := IDPassportNo;
                            AccountProc."Mobile No." := MobileNo;
                            AccountProc."Phone No." := PhoneNo;
                            AccountProc."Date of Birth" := DateofBirth;
                            AccountProc."Employer Code" := EmployerCode;
                            AccountProc.Modify
                        until AccountProc.Next = 0;
                    end;

                    CredAc.Reset;
                    CredAc.SetRange("Member No.", MemberChanges."Member No.");
                    if CredAc.Find('-') then begin
                        repeat
                            CredAc.Name := NameTxt;
                            CredAc."Global Dimension 2 Code" := GlobalDim;
                            CredAc."Group Account No." := GroupAccountNo;
                            CredAc."Group Account" := GroupAccount;
                            CredAc."ID/Passport No." := IDPassportNo;
                            CredAc."Mobile No." := MobileNo;
                            AccountProc."Phone No." := PhoneNo;
                            CredAc."Date of Birth" := DateofBirth;
                            CredAc."Employer Code" := EmployerCode;
                            CredAc.Modify
                        until CredAc.Next = 0;
                    end;

                    RepayAc.Reset;
                    RepayAc.SetRange("Member No.", MemberChanges."Member No.");
                    if RepayAc.Find('-') then begin
                        RepayAc.Name := NameTxt;
                        RepayAc."Global Dimension 2 Code" := GlobalDim;
                        RepayAc."Group Account No" := GroupAccountNo;
                        RepayAc."Group Account" := GroupAccount;
                        RepayAc."ID No." := IDPassportNo;
                        RepayAc."Phone No." := MobileNo;
                        RepayAc."Employer Code" := EmployerCode;
                        RepayAc.Modify
                    end;
                    Variant := MemberChanges;
                end;
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;

    procedure GetBankAcDetails(CodeNo: Code[20]; MemberNo: Code[20])
    var
        CustBankAc: Record "Cust. Bank Account";
        CustBankApp: Record "Cust. Bank Applic Change";
    begin

        CustBankApp.LockTable();
        CustBankAc.Reset();
        CustBankAc.SetRange("Member No.", MemberNo);
        if CustBankAc.FindSet() then begin
            repeat
                CustBankApp.Init();
                CustBankApp."Application No." := CodeNo;
                CustBankApp."Member No." := MemberNo;
                CustBankApp.Code := CustBankAc.Code;
                CustBankApp."Bank Account No." := CustBankAc."Bank Account No.";
                CustBankApp."Bank Branch No." := CustBankAc."Bank Branch No.";
                CustBankApp."Telex No." := CustBankAc."Telex No.";
                CustBankApp.Insert(true);
            until CustBankAc.Next() = 0
        end

        /*  NextOfKin.Reset;
         NextOfKin.SetRange(NextOfKin."Account No", MemberNo);
         if NextOfKin.Find('-') then begin
             repeat
                 InitializeKinDetails(NextOfKin, NextOfKinApp, NextOfKin."Account No");
                 NextOfKinApp."Account No" := CodeNo;
                 NextOfKinApp.Insert(true);
             until NextOfKin.Next = 0;
         end; */
    end;


    procedure GetkinDetails(CodeNo: Code[50]; MemberNo: Code[100])
    var
        NextOfKin: Record "Next of KIN";
        NextOfKinApp: Record "Next of KIN Application";
    begin
        NextOfKinApp.LockTable;
        NextOfKin.Reset;
        NextOfKin.SetRange(NextOfKin."Account No", MemberNo);
        if NextOfKin.Find('-') then begin
            repeat
                NextOfKinApp.Init();
                NextOfKinApp."Account No" := MemberNo;
                NextOfKinApp."Application No." := CodeNo;
                NextOfKinApp.Name := UpperCase(NextOfKin.Name);
                NextOfKinApp.Relationship := NextOfKin.Relationship;
                NextOfKinApp.Beneficiary := NextOfKin.Beneficiary;
                NextOfKinApp."Date of Birth" := NextOfKin."Date of Birth";
                NextOfKinApp.Address := NextOfKin.Address;
                NextOfKinApp.Telephone := NextOfKin.Telephone;
                NextOfKinApp.Fax := NextOfKin.Fax;
                NextOfKinApp.Email := NextOfKin.Email;
                NextOfKinApp.Allocation := NextOfKin.Allocation;
                NextOfKinApp.Type := NextOfKin.Type;
                NextOfKinApp."BBF Entitlement" := NextOfKin."BBF Entitlement";
                NextOfKinApp."BBF Entitlement Code" := NextOfKin."BBF Entitlement Code";
                NextOfKinApp."ID No." := NextOfKin."ID No.";
                NextOfKinApp.Insert(true);
            until NextOfKin.Next = 0;
        end;
    end;

    procedure getCustomerBankDetailsCodeNoCode(CodeNo: Code[20]; MemberNo: Code[20])
    var
        BankChangeRec: Record "Bank Account-Change";
        CustomerBankDetail: Record "Cust. Bank Account";
    begin

        CustomerBankDetail.SetFilter(Code, '<>%1', '');
        CustomerBankDetail.SetRange("Member No.", MemberNo);
        if CustomerBankDetail.Find('-') then begin
            repeat

                BankChangeRec.Init();
                BankChangeRec."Application No." := CodeNo;
                BankChangeRec."Member No." := MemberNo;
                BankChangeRec."Customer No." := MemberNo;
                BankChangeRec.Code := CustomerBankDetail.Code;
                BankChangeRec."Bank Account No." := CustomerBankDetail."Bank Account No.";
                BankChangeRec."Bank Branch No." := CustomerBankDetail."Bank Branch No.";
                BankChangeRec."Telex Answer Back" := CustomerBankDetail."Telex Answer Back";
                BankChangeRec.Insert(true)

            until CustomerBankDetail.Next() = 0;
        end
    end;

    procedure getMemberMonthlyContribution(CodeNo: Code[20]; MemberNo: Code[20])
    var
        Contrib: Record "Member Monthly Contribution";
        MonthlyContrib: Record "Contribution-Changes";
    begin

        MonthlyContrib.LockTable();
        Contrib.Reset();
        Contrib.SetRange("Account No.", MemberNo);
        if Contrib.Find('-') then begin
            repeat
                MonthlyContrib.Init();
                MonthlyContrib."Account No." := Contrib."Account No.";
                MonthlyContrib.Type := Contrib.Type;
                MonthlyContrib.Amount := Contrib.Amount;
                MonthlyContrib.Remarks := Contrib.Remarks;
                MonthlyContrib."Application No." := Contrib."Application No.";
                MonthlyContrib."Entry No." := CodeNo;
                MonthlyContrib.Insert(true)
            until Contrib.Next() = 0;
        end;
    end;

    procedure getMemberAccountSignatory(CodeNo: Code[20]; MemberNo: Code[20])
    var
        ApplicSignatory: Record "Signatory Application";
        Signatory: Record "Account Signatories";
    begin
        ApplicSignatory.LockTable();
        Signatory.Reset();
        Signatory.SetRange("Account No.", MemberNo);
        if Signatory.FindSet() then begin
            repeat
                ApplicSignatory.Init();
                ApplicSignatory."Account No." := CodeNo;
                ApplicSignatory."Member No." := Signatory."Account No.";
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
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitRepaymentSchEntry(var Rschedule: Record "Loan Repayment Schedule"; LoanApplic: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanRepayschEntry(var Rschedule: Record "Repayment Schedule"; LoanApplic: Record Loans)
    begin
    end;

    procedure CreateCredicAcc(ProductID: Code[10]; AccNo: Code[50]) CrAcNo: Code[20]
    var
        CreditAccounts: Record "Credit Account";
        ProductFactory: Record "Product Factory";
        Cust: Record Member;
        CustomerAccType: Enum CustAccountType;
        ProdCategory: Enum ProductAccountCategory;
        AccDimension: Enum AccountDimension;
        CustRec: Record Customer;
        RegistryMngt: Codeunit "Registry Mngt.";
    begin
        CreditAccounts.LockTable;
        Cust.Get(AccNo);
        Cust.TestField("Global Dimension 2 Code");
        ProductFactory.Get(ProductID);
        ProductFactory.fnCheckMinApprovalRequirements;
        InitializeCreditAcc(ProductFactory, CreditAccounts, Cust."No.",
        ProductFactory."Account No. Suffix", ProductFactory."Account No. Prefix",
        Cust."Global Dimension 2 Code");
        CreditAccounts."Member No." := Cust."No.";
        CreditAccounts.Name := Cust.Name;
        CreditAccounts."ID No." := Cust."ID No.";
        CreditAccounts."Employer Code" := Cust."Employer Code";
        CreditAccounts.Insert(true);
        CrAcNo := CreditAccounts."No.";

        CustRec.Reset();
        CustRec.SetRange("No.", CreditAccounts."No.");
        if not CustRec.FindFirst() then begin
            fnCreateCustMemberPostAc(CreditAccounts."No.",
            CreditAccounts.Name, '',
            CreditAccounts."Global Dimension 1 Code",
            CreditAccounts."Global Dimension 2 Code",
            CreditAccounts."Customer Posting Group", '',
            CreditAccounts.Status, CreditAccounts."Product Type",
            CreditAccounts."ID No.",
            CreditAccounts."Member No.",
            CustomerAccType::"Loan Account",
            AccDimension::Loan, ProdCategory::" ");
        end;
        ValidateDefaultDim(CreditAccounts."Member No.");
        exit(CrAcNo)
    end;

    procedure PostAccount(RecVar: Record "Account Application")
    var
        RecRef: Record "Account Application";
        ProdFct: Record "Product Factory";
    begin
        PostAc := RecVar;
        RecVar.TestField("Approval Status", RecVar."Approval Status"::Approved);
        if RecVar."Account Source" <> RecVar."Account Source"::" " then
            RegistryMngt.fnPostAccountApplication(PostAc, RecVar."Account Source") else
            Error('Account source must have a value. It cannot be blank');
    end;

    procedure GetOperationAcc(ProdtCategory: Enum ProductAccountCategory; AccNo: Code[50]; ProdtSource: Integer) StringTxt: Code[100]
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active. Status- %1 Balance %2';
    begin

        case ProdtSource of
            0:
                begin
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", AccNo);
                    AccountB.SetRange("Loan Disbursement Account", true);
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        StringTxt := AccountB."No.";
                    end
                end;
            1:
                begin
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", AccNo);
                    AccountB.SetRange(Status, AccountB.Status::Active);
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        StringTxt := AccountB."No."
                    end
                end;
            2:
                begin
                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.Find('-') then begin
                        CredAc.CalcFields("Balance (LCY)");
                        StringTxt := CredAc."No."
                    end;
                end;
        end;
        exit(StringTxt)
    end;

    procedure GetOperationAccNoBalanceTxt(ProdtCategory: Enum ProductAccountCategory; AccNo: Code[50]; ProdtSource: Integer) StringBalTxt: Decimal
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
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        StringBalTxt := AccountB."Balance (LCY)"
                    end;
                end;
            2:
                begin
                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetFilter("Balance (LCY)", '>0');
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.Find('-') then begin
                        CredAc.CalcFields("Balance (LCY)");
                        StringBalTxt := CredAc."Balance (LCY)"
                    end;
                end;
        end;
        exit(StringBalTxt)
    end;

    procedure GetOperationAccBalanceTxt(ProdtCategory: Enum ProductAccountCategory; AccNo: Code[50]; ProdtSource: Integer) StringBalTxt: Decimal
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        Amt: array[2] of Decimal;
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active.Status- %1 | Balance %2';
    begin
        case ProdtSource of
            1:
                begin
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", AccNo);
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        StringBalTxt := AccountB."Balance (LCY)"
                    end;
                end;
            2:
                begin
                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetFilter("Balance (LCY)", '>0');
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.Find('-') then begin
                        CredAc.CalcFields("Balance (LCY)");
                        StringBalTxt := CredAc."Balance (LCY)"
                    end
                end;
            3:
                begin
                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetFilter("Balance (LCY)", '>0');
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.Find('-') then begin
                        CredAc.CalcFields("Balance (LCY)");
                        StringBalTxt := CredAc."Balance (LCY)"
                    end;
                end;
            4:
                begin
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", AccNo);
                    AccountB.SetRange("Account Category", AccountB."Account Category"::"Specialty Savings");
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        Amt[1] := AccountB."Balance (LCY)"
                    end;

                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetFilter("Account Category", '<>%1', CredAc."Account Category"::"Registration Fee");
                    if CredAc.Find('-') then begin
                        repeat
                            CredAc.CalcFields("Balance (LCY)");
                            Amt[2] := Amt[2] + CredAc."Balance (LCY)";
                        until CredAc.Next() = 0;
                    end;
                    StringBalTxt := (Amt[1] + Amt[2])
                end;
        end;
        exit(StringBalTxt)
    end;

    procedure GetOperationAccTxt(ProdtCategory: Enum ProductAccountCategory; AccNo: Code[50]; ProdtSource: Integer): Boolean
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
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        exit(true)
                    end;
                end;
            2:
                begin
                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.Find('-') then begin
                        CredAc.CalcFields("Balance (LCY)");
                        exit(true)
                    end
                end;
        end;
        exit(false)
    end;

    procedure GetMemberAccBalance(ProdtCategory: Enum ProductAccountCategory; AccNo: Code[50]; ProdtSource: Integer) StringBalTxt: Decimal
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        Loans: Record Loans;
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active.Status- %1 | Balance %2';
    begin
        case ProdtSource of
            1:
                begin
                    AccountB.Reset;
                    AccountB.SetRange("Member No.", AccNo);
                    AccountB.SetRange("Account Category", ProdtCategory);
                    if AccountB.Find('-') then begin
                        AccountB.CalcFields("Balance (LCY)");
                        StringBalTxt := AccountB."Balance (LCY)";
                        exit(StringBalTxt);
                    end else begin
                        StringBalTxt := 0;
                        exit(StringBalTxt);
                    end;
                end;
            2:
                begin
                    CredAc.Reset;
                    CredAc.SetRange("Member No.", AccNo);
                    CredAc.SetRange("Account Category", ProdtCategory);
                    if CredAc.Find('-') then begin
                        CredAc.CalcFields("Balance (LCY)");
                        StringBalTxt := CredAc."Balance (LCY)";
                        exit(StringBalTxt);
                    end else begin
                        StringBalTxt := 0;
                        exit(StringBalTxt);
                    end
                end;
            3:
                begin
                    Loans.Reset();
                    Loans.SetRange("Account No.", AccNo);
                    if Loans.FindSet() then begin
                        repeat
                            Loans.CalcFields("Outstanding Balance");
                            StringBalTxt := (StringBalTxt + Loans."Outstanding Balance");
                        until Loans.Next() = 0;
                    end;
                    exit(StringBalTxt);
                end;
        end;
        exit(0);
    end;

    procedure getCustLoanBalance(ProdtCategory: Integer; AccNo: Code[50]; ProdtSource: Integer) StringBalTxt: Decimal
    var
        CredAc: Record "Account Credit";
        AccountB: Record "Account Banking";
        Loans: Record Loans;
        AccruedInt: Decimal;
        ErrorOnNonFoundAccounDetails: Label 'Account Not Found. Reason(s):- Either Member has zero balance or the account is not Active.';
    begin
        Loans.Reset();
        Loans.SetRange("Account No.", AccNo);
        Loans.SetFilter("Outstanding Balance", '>0');
        if Loans.FindSet() then begin
            repeat
                Loans.CalcFields("Outstanding Balance");
                StringBalTxt := StringBalTxt + Loans."Outstanding Balance";
            until Loans.Next() = 0
        end;
    end;

    procedure getCustAccruedIntLoanBalance(ProdtCategory: Integer; AccNo: Code[50]; ProdtSource: Integer) StringBalTxt: Decimal
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
        Loans.SetFilter("Outstanding Balance", '>0');
        if Loans.FindSet() then begin
            repeat
                Loans.CalcFields("Outstanding Balance");
                AccruedInt := AccruedInt + PeriodAct.fnIntEntriesonSpecificLoan(Loans, Today, Loans."No.", 1, IntDays, Today);
                LoanBal := LoanBal + Loans."Outstanding Balance";
            until Loans.Next() = 0
        end;
        if AccruedInt < 0 then
            AccruedInt := 0;

        StringBalTxt := (AccruedInt + LoanBal);
        exit(StringBalTxt)
    end;

    procedure getguarantorBalance(AcNo: Code[100]): Decimal
    var
        LnAgreement: Record "Guarantor & Security Posted";
    begin

        LnAgreement.Reset();
        LnAgreement.SetRange("Account No.", AcNo);
        LnAgreement.SetRange(Substituted, false);
        LnAgreement.SetFilter("Outstanding Balance", '>0');
        if LnAgreement.FindSet() then begin
            LnAgreement.CalcSums(LnAgreement."Amount Guaranteed");
            exit(LnAgreement."Amount Guaranteed");
        end;
        exit(0)
    end;

    procedure getNoOfLoansGuaranteed(CustNo: Code[100]) NoOfLoan: Integer
    var
        LnAgreement: Record "Guarantor & Security Posted";
    begin
        LnAgreement.Reset();
        LnAgreement.SetRange("Account No.", CustNo);
        LnAgreement.SetRange(Substituted, false);
        if LnAgreement.FindSet() then begin
            NoOfLoan := LnAgreement.Count;
        end
    end;

    procedure getNoOfLoansGuarantor(CustNo: Code[100]) NoOfLoan: Integer
    var
        LnAgreement: Record "Loan Guarantors and Security";
    begin
        LnAgreement.Reset();
        LnAgreement.SetRange("No.", CustNo);
        LnAgreement.SetRange(Substituted, false);
        if LnAgreement.FindSet() then begin
            NoOfLoan := LnAgreement.Count;
        end
    end;

    procedure ScheduledRepayDetail(CodeNo: Code[20]; RepayCode: Code[10]; RepayDate: Date; InstallmentNo: Integer; IntRate: Decimal; PrincRepayment: Decimal; IntRepayment: Decimal; InsRepayment: Decimal; MRepayment: Decimal; LoanBal: Decimal; SharesBanding: Decimal; SharesDeposit: Decimal; InsFee: Decimal; SettleFee: Decimal; IntPost: Integer)
    var
        LoanApplication: Record "Loan Application";
        RepaymentSched: Record "Loan Repayment Schedule";
        LoanApplicationCalc: Record "Loan Calculator";
    begin
        RepaymentSched.LockTable;
        case IntPost of
            0:
                InitializeRepaymentSch(LoanApplication, RepaymentSched, CodeNo);
            1:
                InitializeRepaymentSchCalc(LoanApplicationCalc, RepaymentSched, CodeNo);
        end;
        RepaymentSched."No." := CodeNo;
        RepaymentSched."Repayment Code" := RepayCode;
        RepaymentSched."Repayment Date" := RepayDate;
        RepaymentSched."Instalment No" := InstallmentNo;
        RepaymentSched."Interest Rate" := IntRate;
        RepaymentSched."Principal Repayment" := PrincRepayment;
        RepaymentSched."Monthly Interest" := IntRepayment;
        RepaymentSched."Monthly Insurance" := InsRepayment;
        RepaymentSched."Monthly Repayment" := MRepayment;
        RepaymentSched."Loan Balance" := LoanBal;
        RepaymentSched."Loan Application No" := CodeNo;
        RepaymentSched."Shares Banding" := SharesBanding;
        RepaymentSched."Shares Deposit" := SharesDeposit;
        RepaymentSched."Insurance Repayment" := InsFee;
        RepaymentSched."Settlement Fee" := SettleFee;
        RepaymentSched.Insert(true);
    end;

    procedure GetLoanCharges(ProductType: Code[10]; LoanNo: Code[20]; DepositPurchase: Decimal; Topup: Decimal)
    var
        PCharges: Record "Loan Product Charges";
        AppCharges: Record "Loan Application Charge";
        ApplicationCharge: Record "Loan Application Charge";
    begin
        ApplicationCharge.Reset;
        ApplicationCharge.SetRange("Application No.", LoanNo);
        ApplicationCharge.DeleteAll;

        AppCharges.LockTable;
        PCharges.Reset;
        PCharges.SetRange("Product Code", ProductType);
        if PCharges.Find('-') then begin
            repeat
                InitializeLoanCharges(PCharges, AppCharges, LoanNo);
                if PCharges."Charge Type" = PCharges."Charge Type"::General then
                    AppCharges."Post Charge" := true else
                    AppCharges."Post Charge" := false;
                AppCharges."Application No." := LoanNo;
                AppCharges.Insert(true);
            until PCharges.Next = 0;
        end;
    end;

    local procedure InitializeCreditAcc(VarVariant: Record "Product Factory"; var CredAcc: Record "Credit Account"; AccNo: Code[20]; AccSuffix: Code[10]; AccPrefix: Code[10]; Dim1: Code[10])
    var
        Gensetup: Record "General Set-Up";
    begin
        Gensetup.Get();

        CredAcc.Init;
        case Gensetup."Loan Account Options" of
            Gensetup."Loan Account Options"::Single:
                CredAcc."No." := AccNo;
            Gensetup."Loan Account Options"::Multiple:
                CredAcc."No." := AccSuffix + AccNo + AccPrefix;
            else
                Error('Invalid Option Selected (Loan Account Options)');
        end;
        CredAcc."Global Dimension 2 Code" := Dim1;
        CredAcc.CopyFromProductFactory(VarVariant);
        OnAfterInitCreditAccEntry(CredAcc, VarVariant)
    end;

    procedure InitializeMembAdvise(VarVariant: Record Member; var AdviceAnalysis: Record "Member Advice Analysis")
    begin
        AdviceAnalysis.CopyFromCustomerMember(VarVariant);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCreditAccEntry(var CreditAccounts: Record "Credit Account"; ProductFactory: Record "Product Factory")
    begin
    end;

    procedure PostAdviseAnalysis(AcNo: code[100]; Regfee: Decimal; ShareCap: Decimal; ShareDep: Decimal; SchFee: Decimal; TotalLoan: Decimal; IdentityType: Enum AdviseType; StartDate: Date; EndDate: Date; Totals: Decimal; EmpCode: code[10])
    var
        CustRec: Record Member;
        RecRef: Record "Member Advice Analysis";
    begin
        CustRec.Reset();
        CustRec.SetRange("No.", AcNo);
        if CustRec.FindFirst() then begin
            RecRef.Init();
            RecRef."No." := CustRec."No.";
            RecRef."Start Date" := StartDate;
            RecRef."End Date" := EndDate;
            InitializeMembAdvise(CustRec, RecRef);
            RecRef."Registration Fee" := Regfee;
            RecRef."Employer Code" := EmpCode;
            RecRef."Shares Capital" := ShareCap;
            RecRef."Shares Deposit" := ShareDep;
            RecRef."School Fee savings" := SchFee;
            RecRef."Total Loans" := TotalLoan;
            RecRef."Identity Type" := IdentityType;
            RecRef."Total Deduction" := Totals;
            RecRef.Insert(true)
        end;

    end;

    procedure ComputeLoanApplicationCharges(ProductType: Code[10]; LoanNo: Code[20]; DepositPurchase: Decimal; Topup: Decimal; ChrgeType: Enum ChargeType): Decimal
    var
        PCharges: Record "Loan Product Charges";
        AppCharges: Record "Loan Product Charges";
        CompCharges: Decimal;
        ChargeAmt: Decimal;
        TransType: Record "Transaction Charge";
        TieredChargeLine: Record "Tiered Charges Line";
    begin
        CompCharges := 0;
        ChargeAmt := 0;

        if Topup > 0 then begin

            AppCharges.Reset();
            AppCharges.SetRange("Product Code", ProductType);
            AppCharges.SetRange("Charge Type", ChrgeType);
            if AppCharges.FindFirst() then begin
                repeat
                    if AppCharges."Staggered Charge Code" = '' then begin
                        if AppCharges."Use Percentage" then begin
                            AppCharges.TestField(Percentage);
                            CompCharges := (CompCharges + ((AppCharges.Percentage / 100) * Topup));
                        end else begin
                            CompCharges := (CompCharges + AppCharges."Charge Amount");
                        end;
                    end else begin

                        TransType.Reset();
                        TransType.SetRange("Staggered Charge Code", AppCharges."Staggered Charge Code");
                        if TransType.FindFirst() then begin
                            TieredChargeLine.Reset();
                            TieredChargeLine.SetRange(Code, TransType."Staggered Charge Code");
                            if TieredChargeLine.FindSet() then begin
                                repeat
                                    if (Topup >= TieredChargeLine."Lower Limit") and (TopUp <= TieredChargeLine."Upper Limit") then begin
                                        if TieredChargeLine."Use Percentage" then begin
                                            TieredChargeLine.TestField(Percentage);
                                            CompCharges := (CompCharges + (Topup * (TieredChargeLine.Percentage / 100)));
                                        end else begin
                                            CompCharges := (CompCharges + TieredChargeLine."Charge Amount");
                                        end;
                                    end;
                                until TieredChargeLine.Next() = 0;
                            end;
                        end;
                    end;
                until AppCharges.Next() = 0;
                exit(CompCharges);
            end;
        end;
        exit(0)
    end;


    procedure ComputeLoanCharges(ProductType: Code[10]; LoanNo: Code[20]; DepositPurchase: Decimal; Topup: Decimal): Decimal
    var
        PCharges: Record "Loan Product Charges";
        AppCharges: Record "Loan Application Charge";
        CompCharges: Decimal;
    begin
        AppCharges.LockTable;

        if DepositPurchase > 0 then begin
            PCharges.Reset;
            PCharges.SetRange("Product Code", ProductType);
            PCharges.SetRange("Charge Type", PCharges."Charge Type"::Boosting);
            if PCharges.Find('-') then begin
                if PCharges."Use Percentage" then begin
                    PCharges.TestField(Percentage);
                    CompCharges := Round((DepositPurchase * (PCharges.Percentage / 100)), 1, '=');
                end else begin
                    CompCharges := PCharges."Charge Amount"
                end
            end;
        end;

        if Topup > 0 then begin
            PCharges.Reset;
            PCharges.SetRange("Product Code", ProductType);
            PCharges.SetRange("Charge Type", PCharges."Charge Type"::"Top up");
            if PCharges.Find('-') then begin
                if PCharges."Use Percentage" then begin
                    PCharges.TestField(Percentage);
                    CompCharges := Round((Topup * (PCharges.Percentage / 100)), 1, '=');
                end else begin
                    Topup := PCharges."Charge Amount"
                end
            end;
        end;
        exit(CompCharges)
    end;

    local procedure InitializeRepaymentSch(RecRef: Record "Loan Application"; var RepaymentSched: Record "Loan Repayment Schedule"; LoanNo: Code[20])
    begin
        RepaymentSched.Init;
        RepaymentSched."No." := LoanNo;
        RepaymentSched.CopyFromLoanApplication(RecRef);
        OnAfterInitRepaymentSchEntry(RepaymentSched, RecRef);
    end;

    local procedure InitializeRepaymentSchCalc(RecRef: Record "Loan Calculator"; var RepaymentSched: Record "Loan Repayment Schedule"; LoanNo: Code[20])
    begin
        RepaymentSched.Init;
        RepaymentSched."No." := LoanNo;
        RepaymentSched.CopyFromLoanCalc(RecRef);
    end;

    local procedure InitializeLoanRepayschedule(RecRef: Record Loans; var RepaymentSched: Record "Repayment Schedule"; LoanNo: Code[20])
    begin
        RepaymentSched.Init;
        RepaymentSched."No." := LoanNo;
        RepaymentSched.CopyFromLoanRecEntry(RecRef);
        OnAfterInitLoanRepayschEntry(RepaymentSched, RecRef);
    end;


    procedure InitNextEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Loan Appraisal Parameter";
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

    procedure InitNextEntryNoEftFile(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "EFT File";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        RecRef.Reset();
        RecRef.SetRange("EFT Options", RecRef."EFT Options"::"Mobile Money");
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Sequence No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextPFactEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Product Factory Temp.";
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

    procedure InitNextEntryNoMob(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Mobile Loan Transaction";
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

    procedure InitNextEntryDivProg(): Integer
    var

        RecRef: Record "Dividend Progression";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        RecRef.Reset();
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextEntryStandingOrder(): Integer
    var
        RecRef: Record "Standing Order Register";
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

    procedure InitNextUnclearedEffEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "ATM Transaction";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No" + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextLinkEffEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Link Transactions";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No" + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure generateNextEntryNo(): Integer
    var

        RecRef: Record "Loans (Procedure)";
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

    procedure InitNextAltChannelEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Alt. Channel Entry";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Entry No" + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextAltTransTypesEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Transaction Types-Mobile";
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


    procedure InitializeLoanCharge(RecRef: Record "Loan Charge Posted"; var ApplicCharges: Record "Loan Application Charge"; AccNo: Code[20])
    begin
        RecRef.Init;
        RecRef."Application No." := AccNo;
        RecRef.CopyFromPostedChargesLine(ApplicCharges);
        OnAfterInitLoanChargeEntry(ApplicCharges, RecRef)
    end;




    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanChargeEntry(var ApplicationCharge: Record "Loan Application Charge"; ChargePosted: Record "Loan Charge Posted")
    begin
    end;


    procedure InitializeLoanGuarant(RecRef: Record "Guarantor & Security Posted"; var LoanGuarant: Record "Loan Guarantors and Security"; AccNo: Code[20])
    begin
        RecRef.Init;
        RecRef."No." := AccNo;
        RecRef.CopyFromLoanGuarantLine(LoanGuarant);
        OnAfterInitLoanGuarantEntry(LoanGuarant, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoanGuarantEntry(var ApplicationCharge: Record "Loan Guarantors and Security"; GuarantPosted: Record "Guarantor & Security Posted")
    begin
    end;


    procedure InitializeLoansTopup(RecRef: Record "Loans Top up Posted"; var LoanTopup: Record "Loans Top up"; AccNo: Code[20])
    begin
        RecRef.Init;
        RecRef."No." := AccNo;
        RecRef.CopyFromLoansTopup(LoanTopup);
        OnAfterInitLoansTopupEntry(LoanTopup, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLoansTopupEntry(var LoanTopup: Record "Loans Top up"; LoanTopupPosted: Record "Loans Top up Posted")
    begin
    end;

    procedure getFullInterest(CodeNo: Code[20]): Decimal
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        TotInterest: Decimal;
        Text0001: Label 'KIndly generate schedule before you can continue.';
    begin
        RepaymentSchedule.SetRange("No.", CodeNo);
        if RepaymentSchedule.FindSet then begin
            RepaymentSchedule.CalcSums("Monthly Interest");
            TotInterest := RepaymentSchedule."Monthly Interest"
        end else begin
            Error(Text0001);
        end;
        exit(TotInterest)
    end;


    procedure ScheduledLoanRepayDetail(CodeNo: Code[20]; RepayCode: Code[10]; RepayDate: Date; InstallmentNo: Integer; IntRate: Decimal; PrincRepayment: Decimal; IntRepayment: Decimal; InsRepayment: Decimal; MRepayment: Decimal; LoanBal: Decimal)
    var
        LoanApplication: Record Loans;
        RepaymentSched: Record "Repayment Schedule";
    begin
        RepaymentSched.LockTable;
        InitializeLoanRepayschedule(LoanApplication, RepaymentSched, CodeNo);
        RepaymentSched."No." := CodeNo;
        RepaymentSched."Repayment Code" := RepayCode;
        RepaymentSched."Repayment Date" := RepayDate;
        RepaymentSched."Instalment No" := InstallmentNo;
        RepaymentSched."Principal Repayment" := PrincRepayment;
        RepaymentSched."Monthly Interest" := IntRepayment;
        RepaymentSched."Monthly Insurance" := InsRepayment;
        RepaymentSched."Monthly Repayment" := MRepayment;
        RepaymentSched."Loan Balance" := LoanBal;
        RepaymentSched."Loan Application No." := CodeNo;
        RepaymentSched.Insert(true);
    end;

    procedure CheckspecialCharacters(ParseText: Text)
    var
        SpecialCharacters: Label '!|@|#|$|%|&|*|(|)|_|-|+|=|?';
        Len: Integer;
        SpecialCharsErr: Label 'You can not enter the special characters!';
    begin
        Clear(Len);
        Len := StrLen(DelChr(ParseText, '=', DelChr(ParseText, '=', SpecialCharacters)));
        if Len > 0 then
            Error(SpecialCharsErr);
    end;


    procedure InitNextLineEntryNo(): Integer
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        RecRef: Record "Loan Disbursement Lines";
        NextEntryNo: Integer;
    begin
        RecRef.LockTable;
        if RecRef.FindLast then begin
            NextEntryNo := RecRef."Line No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure fnCreateVendorPostAc(AcNo: Code[100]; NameTxt: Text[150]; PhoneNo: Code[30]; Dim1: Code[20]; Dim2: Code[20]; PostGroup: Code[20]; EmailAddress: Text[80]; StatusTxt: Enum MemberStatus; ProductType: Code[20]; IDNo: Code[20]; MemberNo: Code[20]; CategoryAc: Enum ProductAccountCategory)
    var
        RecRef: Record Vendor;
    begin
        RecRef.Init();
        RecRef."No." := AcNo;
        RecRef.Name := NameTxt;
        RecRef."Phone No." := CopyStr(PhoneNo, 1, 30);
        RecRef."Global Dimension 1 Code" := Dim1;
        RecRef."Global Dimension 2 Code" := Dim2;
        RecRef."Vendor Posting Group" := PostGroup;
        RecRef.Status := StatusTxt;
        RecRef."Product Type" := ProductType;
        RecRef."ID No." := IDNo;
        RecRef."Member No." := MemberNo;
        RecRef."Account Type" := RecRef."Account Type"::Banking;
        RecRef."Account Category" := CategoryAc;
        RecRef.Insert(true)
    end;

    procedure fnCreateCustMemberPostAc(AcNo: Code[100]; NameTxt: Text[150]; PhoneNo: Code[30]; Dim1: Code[20]; Dim2: Code[20]; PostGroup: Code[20]; EmailAddress: Text[80]; StatusTxt: Enum MemberStatus; ProductType: Code[20]; IDNo: Code[20]; MemberNo: Code[20]; AccType: Enum CustAccountType; AccDim: Enum AccountDimension; ProdCategory: Enum ProductAccountCategory)
    var
        PFact: Record "Product Factory";
        RecRef: Record Customer;
    begin

        RecRef.Init();
        RecRef."No." := AcNo;
        RecRef.Name := NameTxt;
        RecRef."Phone No." := PhoneNo;
        RecRef."Global Dimension 1 Code" := Dim1;
        RecRef."Global Dimension 2 Code" := Dim2;
        RecRef."Customer Posting Group" := PostGroup;
        RecRef.Status := StatusTxt;
        RecRef."Product Type" := ProductType;
        RecRef."ID No." := IDNo;
        RecRef."Member No." := MemberNo;
        RecRef."Account Type" := AccType;
        RecRef."Account Category" := ProdCategory;
        RecRef."Account Dimension" := AccDim;
        RecRef.Insert(true)
    end;

    procedure PostAccountActDeact(Dimensionset: Integer; PostInt: Integer; AccNo: Code[100]; ApplicNo: Code[50])
    var
        BankingAcc: Record "Account Banking";
        CreditAcc: Record "Account Credit";
        LoanAc: Record "Credit Account";
        Notif: Codeunit "SMS Notification";
        Source: Enum NotifSourceType;
        CompInfo: Record "Company Information";
        MChange: Record "Member Changes";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TransType: Record "Transaction Types";
        TransCharge: Record "Transaction Charge";
        CustMember: Record Member;

    begin
        case Dimensionset of
            0:
                begin
                    case PostInt of
                        0:
                            begin
                                BankingAcc.Reset();
                                BankingAcc.SetRange("No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.Status := BankingAcc.Status::Active;
                                    BankingAcc.Blocked := BankingAcc.Blocked::" ";
                                    BankingAcc.Modify(true);
                                    if MChange.Get(ApplicNo) then begin
                                        case MChange."Changes Type" of
                                            MChange."Changes Type"::"Account Activation":
                                                begin
                                                    if MChange."Transaction Type" <> '' then begin

                                                        Temp.Get(UserId);
                                                        Temp.TestField("Shortcut Dimension 1 Code");
                                                        Temp.TestField("Shortcut Dimension 2 Code");
                                                        Temp.TestField("Periodic Journal Template");
                                                        Temp.TestField("Periodic Journal Batch");
                                                        JnlPostMngt.ClearJournalLines(Temp."Periodic Journal Template",
                                                        Temp."Periodic Journal Batch");

                                                        TellerMngt.fnPostAccTransferCharges(MChange."Transaction Type",
                                                        BankingAcc."No.", 0, Temp."Shortcut Dimension 1 Code",
                                                        Temp."Shortcut Dimension 2 Code", Temp."Periodic Journal Template",
                                                        Temp."Periodic Journal Batch", MChange."No.", Today);
                                                        JnlPostMngt.CompletePosting(Temp."Periodic Journal Template",
                                                        Temp."Periodic Journal Batch");
                                                    end;
                                                end;
                                        end
                                    end;

                                    if BankingAcc."Mobile No." <> '' then begin
                                        Notif.CreateSmsNotif(Source::Mobile, BankingAcc."Mobile No.",
                                        'Dear member your account has been Activated.Thank you.' + CompInfo.Name,
                                        BankingAcc."Member No.", BankingAcc."No.", false);
                                    end;

                                end;
                            end;
                        1:
                            begin
                                BankingAcc.Reset();
                                BankingAcc.SetRange("Member No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.ModifyAll(Status, BankingAcc.Status::Active);
                                    BankingAcc.ModifyAll(Blocked, BankingAcc.Blocked::" ");
                                end;
                            end;
                    end
                end;
            1:
                begin
                    case PostInt of
                        0:
                            begin
                                CreditAcc.Reset();
                                CreditAcc.SetRange("No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.Status := CreditAcc.Status::Active;
                                    CreditAcc.Blocked := CreditAcc.Blocked::" ";
                                    CreditAcc.Modify(true)
                                end;
                            end;
                        1:
                            begin
                                CreditAcc.Reset();
                                CreditAcc.SetRange("Member No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.ModifyAll(Status, CreditAcc.Status::Active);
                                    CreditAcc.ModifyAll(Blocked, CreditAcc.Blocked::" ");
                                end;
                            end;
                    end
                end;
            2:
                begin
                    BankingAcc.Reset();
                    BankingAcc.SetRange("Member No.", AccNo);
                    if BankingAcc.FindFirst() then begin
                        BankingAcc.ModifyAll(Status, BankingAcc.Status::Active);
                        BankingAcc.ModifyAll(Blocked, BankingAcc.Blocked::" ");
                    end;

                    CreditAcc.Reset();
                    CreditAcc.SetRange("Member No.", AccNo);
                    if CreditAcc.FindFirst() then begin
                        CreditAcc.ModifyAll(Status, CreditAcc.Status::Active);
                        CreditAcc.ModifyAll(Blocked, CreditAcc.Blocked::" ");
                    end;

                    LoanAc.Reset();
                    LoanAc.SetRange("Member No.", AccNo);
                    if LoanAc.FindFirst() then begin
                        LoanAc.ModifyAll(Status, LoanAc.Status::Active);
                        LoanAc.ModifyAll(Blocked, LoanAc.Blocked::" ");
                    end;

                end;
            3:
                begin
                    case PostInt of
                        0:
                            begin
                                CustMember.Reset();
                                CustMember.SetRange("No.", AccNo);
                                if CustMember.FindFirst() then begin
                                    CustMember.Status := CustMember.Status::Deceased;
                                    CustMember.Blocked := CustMember.Blocked::All;
                                    CustMember.Modify(true);
                                end;

                                BankingAcc.Reset();
                                BankingAcc.SetRange("Member No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.ModifyAll(Status, BankingAcc.Status::Deceased);
                                    BankingAcc.ModifyAll(Blocked, BankingAcc.Blocked::All);
                                end;

                                CreditAcc.Reset();
                                CreditAcc.SetRange("Member No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.ModifyAll(Status, CreditAcc.Status::Deceased);
                                    CreditAcc.ModifyAll(Blocked, CreditAcc.Blocked::All);
                                end;

                                LoanAc.Reset();
                                LoanAc.SetRange("Member No.", AccNo);
                                if LoanAc.FindFirst() then begin
                                    LoanAc.ModifyAll(Status, LoanAc.Status::Deceased);
                                    LoanAc.ModifyAll(Blocked, LoanAc.Blocked::All);
                                end;
                            end;
                    end
                end
        end;
    end;

    procedure DeactivateAcc(Dimensionset: Integer; OperationType: Integer; AccNo: Code[100])
    var
        BankingAcc: Record "Account Banking";
        CreditAcc: Record "Account Credit";
        LoanAc: Record "Credit Account";
        Notif: Codeunit "SMS Notification";
        Source: Enum NotifSourceType;
        CompInfo: Record "Company Information";
        MChange: Record "Member Changes";
        TellerMngt: Codeunit "Teller-Post (Yes/No)";
        Temp: Record "Banking User Template";
        JnlPostMngt: Codeunit "Journal Post Mngt.";
        TransType: Record "Transaction Types";
        TransCharge: Record "Transaction Charge";
        CustMember: Record Member;
    begin
        case Dimensionset of
            0:
                begin

                    case OperationType of
                        0:
                            begin

                                CustMember.Reset();
                                CustMember.SetRange("No.", AccNo);
                                if CustMember.FindFirst() then begin
                                    CustMember.Blocked := CustMember.Blocked::" ";
                                    CustMember.Modify(true);
                                end;

                                BankingAcc.Reset();
                                BankingAcc.SetRange("Member No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.ModifyAll(Blocked, BankingAcc.Blocked::" ");
                                end;

                            end;
                        1:
                            begin
                                BankingAcc.Reset();
                                BankingAcc.SetRange("No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.Blocked := BankingAcc.Blocked::" ";
                                    BankingAcc.Modify(true);
                                end;
                            end;
                        2:
                            begin
                                CustMember.Reset();
                                CustMember.SetRange("No.", AccNo);
                                if CustMember.FindFirst() then begin
                                    CustMember.Blocked := CustMember.Blocked::" ";
                                    CustMember.Modify(true);
                                end;

                                CreditAcc.Reset();
                                CreditAcc.SetRange("Member No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.ModifyAll(Blocked, CreditAcc.Blocked::" ");
                                end;
                            end;
                        3:
                            begin
                                CreditAcc.Reset();
                                CreditAcc.SetRange("No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.Blocked := CreditAcc.Blocked::" ";
                                    CreditAcc.Modify(true);
                                end;
                            end;
                    end;
                end;
            1:
                begin

                    case OperationType of
                        0:
                            begin
                                CustMember.Reset();
                                CustMember.SetRange("No.", AccNo);
                                if CustMember.FindFirst() then begin
                                    CustMember.Blocked := CustMember.Blocked::All;
                                    CustMember.Modify(true);
                                end;

                                BankingAcc.Reset();
                                BankingAcc.SetRange("Member No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.ModifyAll(Blocked, BankingAcc.Blocked::All);
                                end;
                            end;
                        1:
                            begin
                                BankingAcc.Reset();
                                BankingAcc.SetRange("No.", AccNo);
                                if BankingAcc.FindFirst() then begin
                                    BankingAcc.Blocked := BankingAcc.Blocked::All;
                                    BankingAcc.Modify(true);
                                end;
                            end;
                        2:
                            begin
                                CustMember.Reset();
                                CustMember.SetRange("No.", AccNo);
                                if CustMember.FindFirst() then begin
                                    CustMember.Blocked := CustMember.Blocked::All;
                                    CustMember.Modify(true);
                                end;

                                CreditAcc.Reset();
                                CreditAcc.SetRange("Member No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.ModifyAll(Blocked, CreditAcc.Blocked::All);
                                end;
                            end;
                        3:
                            begin
                                CreditAcc.Reset();
                                CreditAcc.SetRange("No.", AccNo);
                                if CreditAcc.FindFirst() then begin
                                    CreditAcc.Blocked := CreditAcc.Blocked::All;
                                    CreditAcc.Modify(true);
                                end;
                            end;
                    end;

                end;
        end;
    end;

    procedure InitMobileTransactionsTxt(Reference: Code[70]; Descript: Text[50]; VendorNo: Code[100]; Msaccocharge: Decimal; TransactionType: Enum MobileTransactionTypes; Posted: Boolean; LoanNo: Code[20]; DocNo: Code[20]; AppSource: Enum DocApplicationSource)
    begin
        MTransactions.Init();
        MTransactions."Entry No." := InitNextEntryNoMob;
        MTransactions."Document No." := Reference;
        MTransactions.Description := Descript;
        MTransactions."Transaction Date" := Today;
        MTransactions."Account No." := VendorNo;
        MTransactions.Amount := Msaccocharge;
        MTransactions.Posted := Posted;
        MTransactions."Loan No." := LoanNo;
        MTransactions."Application No." := DocNo;
        MTransactions."Transaction Type" := TransactionType;
        MTransactions."Transaction Time" := Time;
        MTransactions."Application Source" := AppSource;
        MTransactions.Insert(true);
    end;

    procedure InitLinkEffectsTxt(ReceiptNo: Code[100]; PDate: Date; AccNo: Code[100]; Desript: Text[250]; AmtPost: Decimal; UnitID: Code[100]; TransactionType: Enum MobileTransactionTypes; TransDate: Date; Source: Integer; TransDescription: Text[150]; ReferenceNo: Code[100]; ChargeCode: Code[100]; ChargeAmt: Decimal)
    var
        LinkTransaction: Record "Link Transactions";
    begin
        LinkTransaction.Init();
        LinkTransaction."Entry No" := InitNextLinkEffEntryNo();
        LinkTransaction."Trace ID" := ReceiptNo;
        LinkTransaction."Posting Date" := PDate;
        LinkTransaction."Account No" := AccNo;
        LinkTransaction.Validate(Description, Desript);
        LinkTransaction.Amount := AmtPost;
        LinkTransaction."Unit ID" := UnitID;
        LinkTransaction."Transaction Time" := Time;
        LinkTransaction."Transaction Date" := TransDate;
        if LinkTransaction.Source = LinkTransaction.Source::ATM then begin
            LinkTransaction.Validate(Source, Source);
        end else begin
            LinkTransaction.Source := Source;
        end;

        LinkTransaction."Transaction Description" := Desript;
        if LinkTransaction.Source <> LinkTransaction.Source::ATM then begin
            LinkTransaction.Validate("Transaction Charge Code", ChargeCode);
        end;
        LinkTransaction.Validate("Reference No", ReferenceNo);
        LinkTransaction."Charge Amount" := ChargeAmt;
        LinkTransaction.Insert(true)



    end;

    procedure InitUnclearedEffectsTxt(ReceiptNo: Code[100]; PDate: Date; AccNo: Code[100]; Desript: Text[250]; AmtPost: Decimal; UnitID: Code[100]; TransactionType: Enum MobileTransactionTypes; TransDate: Date; Source: Integer; TransDescription: Text[150]; ReferenceNo: Code[100]; ChargeCode: Code[100]; ChargeAmt: Decimal)
    begin

        Trans.Init();
        Trans."Entry No" := InitNextUnclearedEffEntryNo;
        Trans."Trace ID" := ReceiptNo;
        Trans."Posting Date" := PDate;
        Trans."Account No" := AccNo;
        Trans.Validate(Description, Desript);
        Trans.Amount := AmtPost;
        Trans."Unit ID" := UnitID;
        Trans."Transaction Time" := Time;
        Trans."Transaction Date" := TransDate;
        if Trans.Source = Trans.Source::ATM then begin
            Trans.Validate(Source, Source);
        end else begin
            Trans.Source := Source;
        end;

        Trans."Transaction Description" := Desript;
        if Trans.Source <> Trans.Source::ATM then begin
            Trans.Validate("Transaction Charge Code", ChargeCode);
        end;
        Trans.Validate("Reference No", ReferenceNo);
        Trans."Charge Amount" := ChargeAmt;
        Trans.Insert(true)
    end;

    procedure InitializeAltChannelEntryTxt(ReceiptNo: Code[100]; PDate: Date; AccNo: Code[100]; Desript: Text[150]; AmtPost: Decimal; UnitID: Code[50]; TransactionType: Enum MobileTransactionTypes; TransDate: Date; Source: Integer; TransDescription: Text[150]; ReferenceNo: Code[100]; ChargeCode: Code[20]; ChargeAmt: Decimal)
    var
        AltChannel: Record "Alt. Channel Entry";
    begin

        AltChannel.Init();
        AltChannel."Entry No" := InitNextAltChannelEntryNo();
        AltChannel."Trace ID" := ReceiptNo;
        AltChannel."Posting Date" := PDate;
        AltChannel."Account No" := AccNo;
        AltChannel.Description := Desript;
        AltChannel.Amount := AmtPost;
        AltChannel."Unit ID" := UnitID;
        AltChannel."Transaction Time" := Time;
        AltChannel."Transaction Date" := TransDate;
        AltChannel.Source := Source;
        AltChannel."Transaction Description" := TransDescription;
        AltChannel."Reference No" := ReferenceNo;
        AltChannel.Validate("Transaction Charge Code", ChargeCode);
        AltChannel."Charge Amount" := ChargeAmt;
        AltChannel.Insert(true)
    end;

    procedure ValuePosting(var Variant: Variant; PostInt: Integer; DocNo: Code[100]; PostDate: Date)
    var
        RecRef: RecordRef;
        UnsupportedRecordTypeErr: Label 'Action Item is not supported by this response.';
        TransTypeEntry: Record "Transaction Types-Mobile";
        Varvariants: Variant;
        TempEntry: Record "Transaction Types-Mobile";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::"Transaction Types-Mobile":
                begin
                    RecRef.SetTable(TransTypeEntry);
                    TempEntry.Reset();
                    TempEntry.SetRange(Posted, false);
                    TempEntry.SetRange("No.", DocNo);
                    TempEntry.SetRange("Interest Posting Date", Today);
                    TempEntry.SetRange("Entry No.", TransTypeEntry."Entry No.");
                    if TempEntry.FindFirst() then begin
                        TempEntry.Posted := true;
                        TempEntry."Posted By" := UserId;
                        TempEntry."Date Posted" := CurrentDateTime;
                        TempEntry.Modify(true);
                    end;
                    Variant := TransTypeEntry
                end;
            else
                Error(UnsupportedRecordTypeErr);
        end
    end;

    procedure InitializeTempEntry(PLoans: Record Loans; var RecRef: Record "Transaction Types-Mobile"; AvailBal: Decimal; BalanceLCY: Decimal; TransactionType: Enum MobileTransType; RepaymentType: Enum "LoanTransactionType"; DeductionStatus: Enum MobileDeductionStatus; AmountPost: Decimal)
    begin
        RecRef.Init();
        RecRef.Balance := AvailBal;
        RecRef."Balance (LCY)" := BalanceLCY;
        RecRef."Amount To Post" := AmountPost;
        RecRef."Transaction Type" := TransactionType;
        RecRef."Repayment Type" := RepaymentType;
        RecRef."Deduction Status" := DeductionStatus;
        RecRef.CopyFromPostedLoans(PLoans);

    end;

    procedure InitializeRecoveryLine(RecHeader: Record "Recovery Header"; var RecRef: Record "Loan Disbursement Lines"; BalanceLCY: Decimal; AccNo: Code[100])
    begin
        RecRef.Init();
        RecRef."Account No." := AccNo;
        RecRef."Shares Deposit" := BalanceLCY;
        RecRef.CopyFromRecoveryHeader(RecHeader);
    end;

    procedure InitializeAltTransTypeEntry(LoanNo: Code[100]; MemberNo: Code[100]; ReqAmount: Decimal; AmountPost: Decimal; ProductType: Code[20]; TransactionType: Enum MobileTransType; OutInt: Decimal;
                                                                                                                                                                       OutBill: Decimal;
                                                                                                                                                                       OutBal: Decimal;
                                                                                                                                                                       AvailBal: Decimal;
                                                                                                                                                                       BalanceLCY: Decimal;
                                                                                                                                                                       AccNo: Code[100];
                                                                                                                                                                       DeductionStatus: Enum MobileDeductionStatus;
                                                                                                                                                                       OutPrinc: Decimal;
                                                                                                                                                                       IntDueDate: Date;
                                                                                                                                                                       RepayType: Enum "LoanTransactionType")
    var
        TempEntry: Record "Transaction Types-Mobile";
    begin


        TempEntry.Init();
        TempEntry."Entry No." := InitNextAltTransTypesEntryNo();
        TempEntry."Application Date" := Today;
        TempEntry."Interest Posting Date" := IntDueDate;
        TempEntry."No." := LoanNo;
        TempEntry."Account No." := MemberNo;
        TempEntry."Disbursement Account No." := AccNo;
        TempEntry."Transaction Type" := TransactionType;
        TempEntry."Amount To Post" := AmountPost;
        TempEntry."Requested Amount" := ReqAmount;
        TempEntry."Approved Amount" := ReqAmount;
        TempEntry.Balance := AvailBal;
        TempEntry."Balance (LCY)" := BalanceLCY;
        TempEntry."Outstanding Bill" := OutBill;
        TempEntry."Outstanding Interest" := OutInt;
        TempEntry."Outstanding Balance" := OutBal;
        TempEntry."Outstanding Principal" := OutPrinc;
        TempEntry."Deduction Status" := DeductionStatus;
        TempEntry."Repayment Type" := RepayType;
        TempEntry.Insert(true)
    end;

    procedure InitBnkIntConfigurationTxt(ReceiptNo: Code[20]; PDate: Date; AccNo: Code[100]; Desript: Text[150]; AmtPost: Decimal; UnitID: Code[50]; TransactionType: Enum MobileTransactionTypes; TransDate: Date;
                                                                                                                                                                          Source: Integer;
                                                                                                                                                                          TransDescription: Text[150];
                                                                                                                                                                          ReferenceNo: Code[20];
                                                                                                                                                                          ChargeCode: Code[20];
                                                                                                                                                                          ChargeAmt: Decimal)
    var
        Loans: Record Loans;
    begin

        Trans.Init();
        Trans."Entry No" := InitNextUnclearedEffEntryNo;
        Trans."Trace ID" := ReceiptNo;
        Trans."Posting Date" := PDate;
        Trans.Description := Desript;
        Trans.Amount := AmtPost;
        Trans."Unit ID" := UnitID;
        Trans."Transaction Time" := Time;
        Trans."Transaction Date" := TransDate;
        Trans.Source := Trans.Source::"Bank Deposit";
        Trans."Transaction Description" := TransDescription;
        Trans."Reference No" := ReferenceNo;

        Loans.Reset();
        Loans.SetRange("No.", AccNo);
        if Loans.FindFirst() then begin
            Trans.Validate("Search Code", AccNo)
        end else begin
            Trans.Validate("Search Code", CopyStr(AccNo, 1, 1));
        end;
        case Trans."Search Code" of
            'F',
            'J',
            'D',
            'S':
                begin
                    Trans."Account No" := CopyStr(AccNo, 2, 20);
                end else begin
                Trans."Account No" := AccNo;
            end;
        end;
        Trans."Charge Amount" := ChargeAmt;
        Trans.Insert(true)
    end;

    procedure InitAccountTransferTxt(ReceiptNo: Code[20]; PDate: Date; AccToDebit: Code[100]; Desript: Text[150]; AmtPost: Decimal; UnitID: Code[50]; TransactionType: Enum MobileTransactionTypes; TransDate: Date;
                                                                                                                                                                           Source: Integer;
                                                                                                                                                                           TransDescription: Text[150];
                                                                                                                                                                           ReferenceNo: Code[20];
                                                                                                                                                                           ChargeCode: Code[20];
                                                                                                                                                                           ChargeAmt: Decimal;
                                                                                                                                                                           AccToCredit: Code[100])
    begin

        Trans.Init();
        Trans."Entry No" := InitNextUnclearedEffEntryNo;
        Trans."Trace ID" := ReceiptNo;
        Trans."Posting Date" := PDate;
        Trans."Account No" := AccToDebit;
        Trans.Description := Desript;
        Trans.Amount := AmtPost;
        Trans."Unit ID" := UnitID;
        Trans."Transaction Time" := Time;
        Trans."Transaction Date" := Today;
        Trans.Source := Source;
        Trans."Transaction Description" := TransDescription;
        Trans."Reference No" := ReferenceNo;
        Trans."Account No.(Credit)" := AccToCredit;
        Trans.Validate("Transaction Charge Code", ChargeCode);
        Trans."Charge Amount" := ChargeAmt;
        Trans.Insert(true)
    end;

    procedure CreateMembAccTxt(AgentAccount: Code[50]; TeaNoPayrollNo: Code[50]; CustName: Text; CustID: Code[50]; GenderCust: Enum CustGender; PinNo: Code[50]; MembCat: Code[10]; MobileNo: Code[50]; PhoneNo: Code[50]; DatOfBirth: Date; MaritalStat: Enum MaritalStatus; CustType: Enum CreditCustomerType; RegDate: Date;
                                                                                                                                                                                                                                                                                                                                 MContrib: Decimal;
                                                                                                                                                                                                                                                                                                                                 FAccType: Code[50];
                                                                                                                                                                                                                                                                                                                                 Rcenter: Code[50];
                                                                                                                                                                                                                                                                                                                                 ApplicCode: Code[10];
                                                                                                                                                                                                                                                                                                                                 ApplType: Integer)
    var
        Applic: Record "Member Application";
    begin
        Applic.Init();
        Applic."Created By" := userid;
        Applic."Application Source" := Applic."Application Source"::Mobile;
        Applic.Name := CustName;
        Applic.Validate("ID No.", CustID);
        Applic.Validate("Payroll No.", TeaNoPayrollNo);
        Applic."Marital Status" := MaritalStat;
        Applic.Gender := GenderCust;
        Applic."PIN No." := PinNo;
        Applic."Member Category" := MembCat;
        Applic."Mobile Phone No" := MobileNo;
        Applic."Phone No." := PhoneNo;
        Applic.Validate("Date of Birth", DatOfBirth);
        Applic."Customer Type" := CustType;
        Applic."Monthly Contribution" := MContrib;
        Applic."Application Date" := Today;
        Applic.Insert(true);

    end;

    procedure CreateNextOfKinAccTxt(AccNo: Code[50]; CustName: Text; RelationShip: Code[50]; Beneficiary: Boolean; Allocations: Decimal; KinID: Code[10]; MobileNo: Code[50]; DatOfBirth: Date; ApplicCode: Code[100]; EmailAddress: Code[50]; KinAddress: Code[50]; Gender: Enum CustGender)
    var
        Applic: Record "Next of KIN Application";
    begin
        Applic.Init();
        Applic."Account No" := AccNo;
        Applic.Name := CustName;
        Applic.Relationship := RelationShip;
        Applic.Beneficiary := Beneficiary;
        Applic."Date of Birth" := DatOfBirth;
        Applic.Address := KinAddress;
        Applic.Telephone := MobileNo;
        Applic.Gender := Gender;
        Applic.Email := EmailAddress;
        Applic."ID No." := KinID;
        Applic.Allocation := Allocations;
        Applic."Application No." := ApplicCode;
        Applic.Insert();

    end;

    procedure TestNoEntriesExist(CurrentFieldName: Code[100]) Found: Boolean
    var
        MemberLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Document No.");
        MemberLedgEntry.SetRange("Document No.", CurrentFieldName);
        if MemberLedgEntry.Find('-') then
            Found := true else
            Found := false;
        exit(Found)
    end;

    procedure InitNextAdviceEntryNo(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "Checkoff Advice Line";
    begin
        RecRef.LockTable();
        IF RecRef.FindLast() then begin
            ;
            NextEntryNo := RecRef."Entry No" + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextFDEntryNo(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "Fixed Deposit History";
    begin
        RecRef.LockTable();
        IF RecRef.FindLast() then begin
            ;
            NextEntryNo := RecRef.No + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextIntEntryNo(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "Interest Buffer";
    begin
        RecRef.LockTable();
        IF RecRef.FindLast() then begin
            NextEntryNo := RecRef.No + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextFormEntryNo(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "Temp. Form Data";
    begin
        RecRef.LockTable();
        IF RecRef.FindLast() then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextIntEntryNoCRB(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "CRB Data";
    begin
        RecRef.LockTable();
        RecRef.Reset();
        IF RecRef.FindLast() then begin
            ;
            NextEntryNo := RecRef."No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure InitNextIntDSCEntryNo(): Integer
    var
        NextEntryNo: Integer;
        RecRef: Record "DSC Mobile Loan";
    begin
        RecRef.LockTable();
        IF RecRef.FindLast() then begin
            NextEntryNo := RecRef."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
        exit(NextEntryNo)
    end;

    procedure initializeCheckoffAdviceLine(RecRef: Record "Checkoff Advice Line")
    begin
        RecRef.Init();
        RecRef."Entry No" := InitNextAdviceEntryNo();
    end;

    procedure initializeFDEntry(var RecRef: Record "Fixed Deposit History")
    begin
        RecRef.Init();
        RecRef.No := InitNextFDEntryNo();
    end;

    procedure initializeIntEntry(var RecRef: Record "Interest Buffer")
    begin
        RecRef.Init();
        RecRef.No := InitNextIntEntryNo();
    end;

    procedure CreateMonthlyDeduct(AccNo: Code[100]; LoanNo: Code[100]; AcCatType: Enum ProductAccountCategory; Amt: Decimal;
                                                                                      Remrks: Text[100];
                                                                                      AdviceType: Enum AdviseType)
    var
        MonthCont: Record "Member Monthly Contribution";
    begin
        MonthCont.Init();
        MonthCont.Type := AcCatType;
        MonthCont.Amount := Amt;
        MonthCont."Account No." := AccNo;
        MonthCont."Application No." := LoanNo;
        MonthCont."Advise Type" := AdviceType;
        MonthCont.Insert(true)

    end;

    procedure CreateFDEntry(AccNo: Code[100]; RegDate: Date; FdType: Code[10]; MatDate: Date; NegRate: Decimal; FDuration: DateFormula; FDInstruc: Option " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest"; FDAmount: Decimal)
    var
        FDHistory: Record "Fixed Deposit History";
    begin
        initializeFDEntry(FDHistory);
        FDHistory."Account No." := AccNo;
        FDHistory."Registration Date" := RegDate;
        FDHistory."Fixed Deposit Type" := FdType;
        FDHistory."FD Maturity Date" := MatDate;
        FDHistory."Neg. Interest Rate" := NegRate;
        FDHistory."FD Duration" := FDuration;
        FDHistory."FD Maturity Instructions" := FDInstruc;
        FDHistory."Fixed Amount" := FDAmount;
        if FDHistory."Fixed Amount" > 0 then
            FDHistory.Insert(true)
    end;

    procedure CreateIntBufferEntry(AccountNo: Code[100]; ProductType: Code[20]; RunDate: Date; InterestAmount: Decimal; FDMaturityDate: Date)
    InterestBuffer: Record "Interest Buffer";
    begin

        initializeIntEntry(InterestBuffer);
        InterestBuffer."Account No" := AccountNo;
        InterestBuffer."Product Type" := ProductType;
        InterestBuffer."Interest Date" := RunDate;
        InterestBuffer."Interest Amount" := InterestAmount;
        InterestBuffer.Description := 'FD INT - ' + FORMAT(FDMaturityDate, 0, ' <Day,2>-<Month Text,3>-<Year4> ');
        InterestBuffer.Description := UPPERCASE(InterestBuffer.Description);
        InterestBuffer."User ID" := UserId;
        IF InterestBuffer."Interest Amount" <> 0 THEN
            InterestBuffer.Insert(true);
    end;

    procedure CreateClosureLine(DocNo: Code[50]; AcNo: Code[100]; AcName: Text[150]; ProductType: Code[20]; MemberNo: Code[100]; Bal: Decimal; OutInt: Decimal; OutPrinc: Decimal; AccruedInt: Decimal; AmtPost: Decimal; LoanNo: Code[50]; AccountCateg: Enum ProductAccountCategory; ProdClass: Enum ProductClass)
    var
        AccLine: Record "Account Closure Line";
    begin

        AccLine.Init();
        AccLine."No." := DocNo;
        AccLine."Account No." := AcNo;
        AccLine.Name := AcName;
        AccLine."Product Type" := ProductType;
        AccLine.Close := true;
        AccLine."Member No." := MemberNo;
        AccLine.Balance := Bal;
        AccLine."Loan No." := LoanNo;
        AccLine."Outstanding Interest" := OutInt;
        AccLine."Outstanding Principal" := OutPrinc;
        AccLine."Accrued Interest" := AccruedInt;
        AccLine."Amount to Post" := AmtPost;
        AccLine."Account Category" := AccountCateg;
        AccLine."Product Class" := ProdClass;
        AccLine.Insert(true);

    end;

    procedure getMemberAccount(MemberNo: Code[100]; DocNo: Code[50]; AppType: Option " ",All,Specific,Banking; AcClosureType: Enum AccClosureType; AccNo: Code[100];
                                                                                                                                  Doctype: Option " ","Membership Closure","Account Closure";
                                                                                                                                  AccountBal: Decimal;
                                                                                                                                  TransferType: Integer; AccDim: Enum AccountDimension)
    Var
        AccBanking: Record "Account Banking";
        CreditAc: Record "Account Credit";
        LoanAc: Record loans;
        AccLine: Record "Account Closure Line";
        PeriodActMngt: Codeunit "Periodic Activities Mgt.";
        AccruedInt: Decimal;
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        RunBal: Decimal;
        AmtToPost: Decimal;
        DiffAmt: Decimal;
        PFact: Record "Product Factory";
        gensetup: Record "General Set-Up";
    begin
        StartDate := CalcDate('-CM', Today);
        EndDate := Today;
        IntDays := (EndDate - StartDate) + 1;
        RunBal := 0;
        RunBal := AccountBal;
        gensetup.Get();

        Case Doctype of

            Doctype::"Account Closure":
                begin
                    case AppType of

                        AppType::Specific:
                            begin

                                if AccDim = AccDim::Banking then begin

                                    AccBanking.Reset();
                                    AccBanking.SetRange("No.", AccNo);
                                    if AccBanking.Find('-') then begin
                                        AccBanking.CalcFields("Balance (LCY)");
                                        CreateClosureLine(DocNo, AccBanking."No.",
                                        AccBanking."Product Name", AccBanking."Product Type",
                                        AccBanking."Member No.", 0, 0, 0, 0, 0, '', AccBanking."Account Category",
                                        Enum::ProductClass::Account);
                                    end;
                                end;

                                if AccDim = AccDim::Credit then begin
                                    CreditAc.Reset();
                                    CreditAc.SetRange("No.", AccNo);
                                    if CreditAc.FindSet() then begin
                                        CreditAc.CalcFields("Balance (LCY)");
                                        CreateClosureLine(DocNo, CreditAc."No.", CreditAc."Product Name",
                                                    CreditAc."Product Type", CreditAc."Member No.",
                                                    CreditAc."Balance (LCY)", 0, 0, 0, CreditAc."Balance (LCY)", '',
                                                    CreditAc."Account Category", Enum::ProductClass::Account);
                                    end;
                                end;
                            end;
                    end;
                end;
            Doctype::"Membership Closure":
                begin
                    case AppType of

                        AppType::All:
                            begin
                                case AcClosureType of
                                    AcClosureType::"Withdrawal - Death":
                                        begin

                                            AccBanking.Reset();
                                            AccBanking.SetRange("Member No.", MemberNo);
                                            if AccBanking.Find('-') then begin
                                                repeat
                                                    AccBanking.CalcFields("Balance (LCY)");
                                                    CreateClosureLine(DocNo,
                                                    AccBanking."No.",
                                                    AccBanking."Product Name",
                                                    AccBanking."Product Type",
                                                    AccBanking."Member No.",
                                                    AccBanking."Balance (LCY)",
                                                    0, 0, 0, AccBanking."Balance (LCY)", '', AccBanking."Account Category", Enum::ProductClass::Account);
                                                until AccBanking.Next() = 0;
                                            end;

                                            CreditAc.Reset();
                                            CreditAc.SetRange("Member No.", MemberNo);
                                            CreditAc.SetRange("Account Category", CreditAc."Account Category"::"Shares Deposit");
                                            if CreditAc.Find('-') then begin
                                                repeat
                                                    CreditAc.CalcFields("Balance (LCY)");
                                                    CreateClosureLine(DocNo,
                                                    CreditAc."No.",
                                                    CreditAc."Product Name",
                                                    CreditAc."Product Type",
                                                    CreditAc."Member No.",
                                                    CreditAc."Balance (LCY)",
                                                    0, 0, 0, CreditAc."Balance (LCY)", '', CreditAc."Account Category", Enum::ProductClass::Account);
                                                until CreditAc.Next() = 0;

                                            end;
                                            LoanAc.Reset();
                                            LoanAc.SetRange("Account No.", MemberNo);
                                            LoanAc.SetFilter("Outstanding Balance", '>0');
                                            if LoanAc.Find('-') then begin
                                                repeat
                                                    LoanAc.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
                                                    AccruedInt := 0;
                                                    if gensetup."Interest Posting Method" = gensetup."Interest Posting Method"::"Charge Daily" then
                                                        AccruedInt := PeriodActMngt.fnIntEntriesonSpecificLoan(LoanAc, Today, LoanAc."No.", 1, IntDays, Today) else
                                                        AccruedInt := 0;

                                                    CreateClosureLine(DocNo, LoanAc."No.",
                                                    LoanAc."Product Description",
                                                    LoanAc."Product Type",
                                                    LoanAc."Account No.",
                                                    (LoanAc."Outstanding Balance" + AccruedInt),
                                                    (LoanAc."Outstanding Interest" + AccruedInt),
                                                    LoanAc."Outstanding Principal",
                                                    AccruedInt, (LoanAc."Outstanding Balance" + AccruedInt),
                                                    LoanAc."No.", ProdCategory::Loan, Enum::ProductClass::Loan);
                                                until LoanAc.Next() = 0;
                                            end;
                                        end;

                                    AcClosureType::"Withdrawal - Normal":
                                        begin

                                            AccBanking.Reset();
                                            AccBanking.SetRange("Member No.", MemberNo);
                                            AccBanking.SetFilter("Account Category", '<>%1 & <>%2', AccBanking."Account Category"::"Certificates of Deposit", AccBanking."Account Category"::Repayment);
                                            if AccBanking.Find('-') then begin
                                                repeat
                                                    AccBanking.CalcFields("Balance (LCY)");
                                                    CreateClosureLine(DocNo,
                                                    AccBanking."No.",
                                                    AccBanking."Product Name",
                                                    AccBanking."Product Type",
                                                    AccBanking."Member No.",
                                                    AccBanking."Balance (LCY)",
                                                    0, 0, 0, AccBanking."Balance (LCY)", '', AccBanking."Account Category", Enum::ProductClass::Account);
                                                until AccBanking.Next() = 0;
                                            end;

                                            CreditAc.Reset();
                                            CreditAc.SetRange("Member No.", MemberNo);
                                            CreditAc.SetRange("Account Category", CreditAc."Account Category"::"Shares Deposit");
                                            if CreditAc.Find('-') then begin
                                                repeat

                                                    CreditAc.CalcFields("Balance (LCY)");
                                                    CreateClosureLine(DocNo,
                                                    CreditAc."No.",
                                                    CreditAc."Product Name",
                                                    CreditAc."Product Type",
                                                    CreditAc."Member No.",
                                                    CreditAc."Balance (LCY)",
                                                    0, 0, 0, CreditAc."Balance (LCY)", '',
                                                    CreditAc."Account Category", Enum::ProductClass::Account);

                                                until CreditAc.Next() = 0;
                                            end;
                                            LoanAc.Reset();
                                            LoanAc.SetRange("Account No.", MemberNo);
                                            LoanAc.SetFilter("Outstanding Balance", '>0');
                                            if LoanAc.Find('-') then begin
                                                repeat
                                                    LoanAc.CalcFields("Outstanding Balance", "Outstanding Interest", "Outstanding Principal");
                                                    AccruedInt := 0;
                                                    if gensetup."Interest Posting Method" = gensetup."Interest Posting Method"::"Charge Daily" then
                                                        AccruedInt := PeriodActMngt.fnIntEntriesonSpecificLoan(LoanAc, Today, LoanAc."No.", 1, IntDays, Today) else
                                                        AccruedInt := 0;

                                                    CreateClosureLine(DocNo, LoanAc."No.",
                                                    LoanAc."Product Description",
                                                    LoanAc."Product Type",
                                                    LoanAc."Account No.",
                                                    (LoanAc."Outstanding Balance" + AccruedInt),
                                                    (LoanAc."Outstanding Interest" + AccruedInt),
                                                    LoanAc."Outstanding Principal",
                                                    AccruedInt, (LoanAc."Outstanding Balance" + AccruedInt),
                                                    LoanAc."No.", ProdCategory::Loan, Enum::ProductClass::Loan);
                                                until LoanAc.Next() = 0;
                                            end;

                                        end;
                                end;
                            end;

                        AppType::Banking:
                            begin
                                AccBanking.Reset();
                                AccBanking.SetRange("No.", AccNo);
                                if AccBanking.Find('-') then begin
                                    AccBanking.CalcFields("Balance (LCY)");
                                    CreateClosureLine(DocNo,
                                    AccBanking."No.",
                                    AccBanking."Product Name",
                                    AccBanking."Product Type",
                                    AccBanking."Member No.",
                                    AccBanking."Balance (LCY)",
                                    0, 0, 0, 0, '', AccBanking."Account Category", Enum::ProductClass::Account);
                                end;

                            end;

                    end;
                end;
        end;
    end;

    procedure getTransactionalCharges(TransactionType: Code[20]; AccountNo: Code[100]; Amt: Decimal) Charges: Decimal
    var
        GenSetup: Record "General Set-Up";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Teller Transaction";
    begin
        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", TransactionType);
        if TransactionCharges.Find('-') then begin
            repeat
                ChargeAmount := 0;
                case
                        TransactionCharges."Charge Type" of
                    TransactionCharges."Charge Type"::"Flat Amount":
                        begin
                            TransactionCharges.TestField("Charge Amount");
                            ChargeAmount := TransactionCharges."Charge Amount";
                        end;
                    TransactionCharges."Charge Type"::"% of Amount":
                        begin
                            TransactionCharges.TestField("Percentage of Amount");
                            ChargeAmount := Round((Amt * (TransactionCharges."Percentage of Amount" / 100)), 1, '=');
                        end;
                    TransactionCharges."Charge Type"::Staggered:
                        begin
                            TariffDetails.Reset;
                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                            if TariffDetails.Find('-') then begin
                                repeat
                                    if (Amt >= TariffDetails."Lower Limit") and (Amt <= TariffDetails."Upper Limit") then begin
                                        if TariffDetails."Use Percentage" = true then begin
                                            ChargeAmount := (Amt * TariffDetails.Percentage * 0.01);
                                        end else begin
                                            ChargeAmount := TariffDetails."Charge Amount";
                                        end;
                                    end;
                                until TariffDetails.Next = 0;
                            end;
                        end;
                end;
            until TransactionCharges.Next = 0;
            Charges := ChargeAmount;
            exit(Charges)
        end;
    end;

    procedure getcustMonthlyContrib(AcNo: Code[100]; ProdCategory: Enum ProductAccountCategory) Amt: Decimal
    var
        ContribAcc: Record "Member Monthly Contribution";
    begin
        ContribAcc.Reset();
        ContribAcc.SetRange("Application No.", AcNo);
        ContribAcc.SetRange(Type, ProdCategory);
        if ContribAcc.Find('-') then begin
            Amt := ContribAcc.Amount;
        end;
        exit(Amt)
    end;

    procedure InitializeRecLine(RecNo: Code[50])
    var
        ReceiptLine: Record "Receipt Line";
    begin
        ReceiptLine.Reset();
        ReceiptLine.SetRange(No, RecNo);
        ReceiptLine.DeleteAll();

    end;

    procedure InitializeTellerLines(RecNo: Code[50])
    var
        ReceiptLine: Record "Cashier Transaction Line";
    begin
        ReceiptLine.Reset();
        ReceiptLine.SetRange("Transaction No.", RecNo);
        if ReceiptLine.FindSet() then
            ReceiptLine.DeleteAll();
    end;

    procedure InitializeReceiptLines(RecNo: Code[50])
    var
        ReceiptLine: Record "Receipt Line";
    begin
        ReceiptLine.Reset();
        ReceiptLine.SetRange(No, RecNo);
        if ReceiptLine.FindSet() then
            ReceiptLine.DeleteAll();

    end;

    procedure getaccruedLoanInterest(DocNo: Code[50]; AsAt: Date) AccruedInt: Decimal
    var
        Loan: Record Loans;
        IntDays: Integer;
        DateFilter: Text[50];
        EndDate: Date;
        PLoan: Record Loans;
        StartDate: Date;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
    begin
        StartDate := CalcDate('-CM', Today);
        EndDate := Today;
        IntDays := (EndDate - StartDate) + 1;
        Loan.Reset();
        Loan.SetRange("No.", DocNo);
        Loan.SetFilter("Date Filter", DateFilter);
        if Loan.Find('-') then begin
            Loan.CalcFields("Outstanding Balance");
            AccruedInt := PeriodAct.fnIntEntriesonSpecificLoan(Loan, Today, Loan."No.", 1, IntDays, Today);
        end;
        exit(AccruedInt);
    end;

    procedure getaccruedLoanApplicInterest(DocNo: Code[50]; AsAt: Date) AccruedInt: Decimal
    var
        Loan: Record "Loan Application";
        IntDays: Integer;
        DateFilter: Text[50];
        EndDate: Date;
        PLoan: Record Loans;
        NoOfdaysInMonth: Integer;
        IntDue: array[3] of Decimal;
        NoOfdays: Integer;
    begin

        EndDate := CalcDate('-CM', AsAt);
        IntDays := 1;
        DateFilter := '01/01/2000..' + Format(AsAt);
        Loan.Reset();
        Loan.SetRange("No.", DocNo);
        if Loan.Find('-') then begin

            NoOfdaysInMonth := Date2DMY(CalcDate('CM', DMY2Date(1, Date2DMY(Loan."Disbursement Date", 2),
                                            Date2DMY(Loan."Disbursement Date", 3))), 1);
            IntDue[3] := Round((Loan."Interest Repayment" / NoOfdaysInMonth), 1, '=');
            NoOfdays := (Today - Loan."Disbursement Date");
            if NoOfdays < 0 then NoOfdays := 0;
            if NoOfdays = 0 then NoOfdays := 1;
            AccruedInt := Round((IntDue[3] * NoOfdays), 1, '=');
        end;
        exit(AccruedInt);

    end;

    procedure CreatCustReceipLine(ReceiptNo: Code[50]; PostSource: Integer)
    var
        ReceiptLine: Record "Receipt Line";
        CredAc: Record "Account Credit";
        RecHeader: Record "Receipts Header";
        RecType: Record "Receipts and Payment Types";
        LoanAc: Record Loans;
        Line: Integer;

    begin
        if RecHeader.Get(ReceiptNo) then begin
            RecHeader.TestField("Member No.");
            InitializeRecLine(RecHeader."No.");

            case PostSource of
                0:
                    begin

                        RecType.Reset();
                        RecType.SetRange("Account Type", RecType."Account Type"::Credit);
                        if RecType.FindFirst() then begin
                            CredAc.Reset();
                            CredAc.SetRange("Member No.", RecHeader."Member No.");
                            if CredAc.Find('-') then begin
                                repeat
                                    ReceiptLine.Init();
                                    ReceiptLine.No := RecHeader."No.";
                                    ReceiptLine."Member No." := RecHeader."Member No.";
                                    ReceiptLine.Amount := getcustMonthlyContrib(CredAc."No.", CredAc."Account Category");
                                    ReceiptLine.Validate(Amount);
                                    ReceiptLine.Validate(Type, RecType.Code);
                                    ReceiptLine."Product Category" := CredAc."Account Category";
                                    ReceiptLine.Validate("Account No.", CredAc."No.");
                                    ReceiptLine."Pay Mode" := ReceiptLine."Pay Mode"::EFT;
                                    ReceiptLine.Insert(true);
                                until CredAc.Next() = 0;
                            end;
                        end;

                        RecType.Reset();
                        RecType.SetRange("Account Type", RecType."Account Type"::Loan);
                        if RecType.FindFirst() then begin
                            LoanAc.Reset();
                            LoanAc.SetRange("Account No.", RecHeader."Member No.");
                            LoanAc.SetFilter("Outstanding Balance", '>0');
                            if LoanAc.Find('-') then begin
                                repeat
                                    LoanAc.CalcFields("Outstanding Balance");
                                    ReceiptLine.Init();
                                    ReceiptLine.No := RecHeader."No.";
                                    ReceiptLine."Member No." := RecHeader."Member No.";
                                    ReceiptLine.Validate(Type, RecType.Code);
                                    ReceiptLine."Product Category" := ReceiptLine."Product Category"::" ";
                                    ReceiptLine.Validate("Account No.", LoanAc."Loan Account");
                                    ReceiptLine."Pay Mode" := ReceiptLine."Pay Mode"::EFT;
                                    ReceiptLine.Validate("Loan No.", LoanAc."No.");
                                    ReceiptLine."Transaction Type" := ReceiptLine."Transaction Type"::Repayment;
                                    ReceiptLine.Validate(Amount, LoanAc.Repayment);
                                    ReceiptLine.Insert(true);
                                until LoanAc.Next() = 0;
                            end
                        end;

                    end;
                1:
                    begin
                        CredAc.Reset();
                        CredAc.SetRange("Member No.", RecHeader."Member No.");
                        if CredAc.Find('-') then begin
                            repeat
                                ReceiptLine.Init();
                                ReceiptLine.No := RecHeader."No.";
                                ReceiptLine."Member No." := RecHeader."Member No.";
                                RecType.Reset();
                                RecType.SetRange("Account Type", RecType."Account Type"::Credit);
                                if RecType.FindFirst() then
                                    ReceiptLine.Validate(Type, RecType.Code);
                                ReceiptLine."Product Category" := CredAc."Account Category";
                                ReceiptLine.Validate("Account No.", CredAc."No.");
                                ReceiptLine."Pay Mode" := ReceiptLine."Pay Mode"::EFT;
                                ReceiptLine.Insert(true);
                            until CredAc.Next() = 0;
                        end
                    end;
                2:
                    begin
                        LoanAc.Reset();
                        LoanAc.SetRange("Account No.", RecHeader."Member No.");
                        LoanAc.SetFilter("Outstanding Balance", '>0');
                        if LoanAc.Find('-') then begin
                            repeat
                                LoanAc.CalcFields("Outstanding Balance");
                                ReceiptLine.Init();
                                ReceiptLine.No := RecHeader."No.";
                                ReceiptLine."Member No." := RecHeader."Member No.";
                                RecType.Reset();
                                RecType.SetRange("Account Type", RecType."Account Type"::Loan);
                                if RecType.FindFirst() then
                                    ReceiptLine.Validate(Type, RecType.Code);
                                ReceiptLine."Product Category" := ReceiptLine."Product Category"::" ";
                                ReceiptLine.Validate("Account No.", LoanAc."Loan Account");
                                ReceiptLine."Pay Mode" := ReceiptLine."Pay Mode"::EFT;
                                ReceiptLine.Validate("Loan No.", LoanAc."No.");
                                ReceiptLine."Transaction Type" := ReceiptLine."Transaction Type"::Repayment;
                                ReceiptLine.Validate(Amount, LoanAc.Repayment);

                                ReceiptLine.Insert(true);
                            until LoanAc.Next() = 0;
                        end
                    end;
            end;
        end
    end;

    procedure PostBankingMngt(AccNo: Code[100]; Amt: Decimal; Descript: Text[50]; LineNo: Integer; PostingDate: Date; JTemplate: Code[20]; JBatch: Code[20]; Dim1: Code[20]; Dim2: Code[20]; DocNo: Code[20]; BalAcNo: Code[20])
    var
        JnlPostMgt: Codeunit "Journal Post Mngt.";
        AccBanking: Record "Account Banking";
        AcctType: Enum "Gen. Journal Account Type";
        TransactionType: Enum "LoanTransactionType";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
    begin
        AccBanking.Reset();
        AccBanking.SetRange("No.", AccNo);
        if AccBanking.Find('-') then begin
            LineNo := LineNo + 100;
            JnlPostMgt.PostJournal(JTemplate,
            JBatch, LineNo, AcctType::Vendor, DocNo, Descript, Amt, AccBanking."No.",
            PostingDate, AcctType::"G/L Account", BalAcNo, AccBanking."Member No.",
            Dim1, Dim2, TransactionType::" ", '', '', '', DocType::" ", '', AppliesToDocType::" ");
        end;

    end;

    procedure PostCreditMngt(AccNo: Code[100]; Amt: Decimal; Descript: Text[50]; LineNo: Integer; PostingDate: Date; JTemplate: Code[20]; JBatch: Code[20]; Dim1: Code[20]; Dim2: Code[20]; TransactionType: Enum "LoanTransactionType"; LoanNo: Code[50])
    var
        JnlPostMgt: Codeunit "Journal Post Mngt.";
        AccBanking: Record "Account Credit";
        AcctType: Enum "Gen. Journal Account Type";
        DocType: Enum "Gen. Journal Document Type";
        AppliesToDocType: Enum "Gen. Journal Document Type";
    begin
        AccBanking.Reset();
        AccBanking.SetRange("No.", AccNo);
        if AccBanking.Find('-') then begin
            LineNo := LineNo + 1000;
            JnlPostMgt.PostJournal(JTemplate,
            JBatch, LineNo, AcctType::Customer,
            AccBanking."No.", Descript,
            Amt, AccBanking."No.",
            PostingDate, AcctType::"G/L Account", '',
            AccBanking."Member No.",
            Dim1, Dim2,
            TransactionType, LoanNo, '', '',
            DocType::" ", '', AppliesToDocType::" ");
        end;
    end;

    procedure BufferFailedLoanApplicRequest(IDNo: Code[20]; MemberNo: Code[20]; TransactionalMobileNo: Code[20]; Amt: Decimal; ProductID: Code[20]; DescriptTxt: Text[150]; MStatus: Enum MobileLoanStatus; RMarks: Text[150];
                                                                                                                                                                                       DocumentNo: Code[50])
    LoanApp: Record "DSC Mobile Loan";
    begin
        LoanApp.Init();
        LoanApp."Entry No." := InitNextIntDSCEntryNo();
        LoanApp."Document No." := IDNo;
        LoanApp."Account No." := MemberNo;
        LoanApp."Phone No." := TransactionalMobileNo;
        LoanApp.Date := Today;
        LoanApp."Captured By" := UserId;
        LoanApp."Date/Time Captured" := CurrentDateTime;
        LoanApp."Requested Amount" := Amt;
        LoanApp."Product Type" := ProductID;
        LoanApp.Remarks := RMarks;
        LoanApp.Description := DescriptTxt;
        LoanApp.Status := MStatus;
        LoanApp."API Code" := DocumentNo;
        LoanApp."Document No." := DocumentNo;
        LoanApp.Insert(true);

    end;

    procedure BufferFailedLoanApplication(IDNo: Code[20]; MemberNo: Code[20]; TransactionalMobileNo: Code[20]; Amt: Decimal; ProductID: Code[20]; DescriptTxt: Text[150]; MStatus: Enum MobileLoanStatus; RMarks: Text[150];
                                                                                                                                                                                       DocumentNo: Code[50])
    LoanApp: Record "DSC Mobile Loan";
    begin
        LoanApp.Init();
        LoanApp."Entry No." := InitNextIntDSCEntryNo();
        LoanApp."Document No." := IDNo;
        LoanApp."Account No." := MemberNo;
        LoanApp."Phone No." := TransactionalMobileNo;
        LoanApp.Date := Today;
        LoanApp."Captured By" := UserId;
        LoanApp."Date/Time Captured" := CurrentDateTime;
        LoanApp."Requested Amount" := Amt;
        LoanApp."Product Type" := ProductID;
        LoanApp.Remarks := RMarks;
        LoanApp.Description := DescriptTxt;
        LoanApp.Status := MStatus;
        LoanApp."API Code" := DocumentNo;
        LoanApp."Document No." := DocumentNo;
        if LoanApp."Requested Amount" > 0 then
            LoanApp.Insert(true);

    end;

    local procedure InitializeScore(AccountNo: Code[100]; ProdFactory: Code[10])
    var
        DscAppScoring: Record "DSC Appraisal Scoring";
    begin
        DscAppScoring.Reset();
        DscAppScoring.SetRange("Account No.", AccountNo);
        if DscAppScoring.Find('-') then
            DscAppScoring.Delete();
    end;

    procedure GetDivLoanMaxCreditLimitScore(CustRec: Record Member; LoanType: Code[20]; SavingsDays: Integer; PostInt: Integer) Response: Decimal
    var
        HrDate: Codeunit "Date Conversion";
        ContMembership: Record "DSC Continous Membership";
        DscAppScoring: Record "DSC Appraisal Scoring";
        DscAppScore: Record "DSC Appraisal Scoring";
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
        MemberCust: Record Member;
        TotalScore: Decimal;
        HasExistingLoan: Boolean;
        FactProd: Record "Product Factory";
        SharesDepositMultiplier: Decimal;
        gensetup: Record "General Set-Up";

    begin

        CustomerAge := 0;
        MaxContAge := 0;
        DepositExp := 0;
        GrossDivAmt := 0;
        MembershipDuration := 0;
        SharesDeposit := 0;
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
        gensetup.Get();


        CustMember.Reset();
        CustMember.SetRange("No.", CustRec."No.");
        if CustMember.FindFirst() then begin
            MemberNo := CustRec."No."
        end;

        InitializeScore(MemberNo, LoanType);

        FirstDateMonth := CalcDate('-CM-1D', Today);

        ProdFact.Reset();
        ProdFact.SetRange("Product ID", LoanType);
        ProdFact.SetRange(Status, ProdFact.Status::Active);
        ProdFact.SetRange("Loan Span", ProdFact."Loan Span"::Dividends);
        ProdFact.SetRange("Appraisal Parameter Type", ProdFact."Appraisal Parameter Type"::Dividends);
        if ProdFact.FindFirst() then begin

            ProdFact.TestField("Deposit Multiplier");

            CustMember.Reset();
            CustMember.SetRange("No.", CustRec."No.");
            CustMember.SetRange(Status, CustMember.Status::Active);
            if CustMember.FindFirst() then begin

                case gensetup."Dividend Qualify Formula" of

                    gensetup."Dividend Qualify Formula"::"Generate Automatically":
                        begin
                            DivMngt.GenerateDividendsOnLoanAccount(CustMember."No.", CustMember."ID No.", ProdFact."Product ID");
                            DiviProgession.Reset();
                            DiviProgession.SetRange("Member No", CustMember."No.");
                            DiviProgession.SetRange("Header No.", CustMember."ID No.");
                            if DiviProgession.FindSet() then begin
                                DiviProgession.CalcSums("Gross Dividends");
                                GrossDivAmt := Round((DiviProgession."Gross Dividends"), 1, '=');
                                DepositMultiplier := Round(GrossDivAmt * (ProdFact."Deposit Multiplier" / 100), 1, '=');
                            end else begin
                                GrossDivAmt := 0;
                                DepositMultiplier := 0;

                            end;
                        end;
                    gensetup."Dividend Qualify Formula"::"Load Data":
                        begin
                            QcQualifyAmt.Reset();
                            QcQualifyAmt.SetRange("No.", CustRec."No.");
                            QcQualifyAmt.SetRange("Product Type", ProdFact."Product ID");
                            if QcQualifyAmt.FindFirst() then begin
                                GrossDivAmt := QcQualifyAmt."Qualifying Amount";
                                DepositMultiplier := (QcQualifyAmt."Qualifying Amount" / 2);
                                if QcQualifyAmt.Status <> QcQualifyAmt.Status::Active then begin
                                    DepositMultiplier := 0;
                                end;
                            end else begin
                                GrossDivAmt := 0;
                                DepositMultiplier := 0;
                            end;
                        end;
                end;

                LoanT.Reset();
                LoanT.SetRange("Product Type", 'DIVIDEND');
                LoanT.SetRange("Account No.", CustMember."No.");
                if LoanT.Find('-') then begin
                    repeat
                        LoanT.CalcFields("Outstanding Balance");
                        ExistDivLoan := (ExistDivLoan + LoanT."Outstanding Balance");
                    until LoanT.Next() = 0;
                end else begin
                    ExistDivLoan := 0;
                end;
                MaxAvailable := Round((DepositMultiplier - ExistDivLoan), 1, '=');
                if MaxAvailable < 0 then
                    MaxAvailable := 0;
                GetLoanMaxCreditLimitHistory(CustMember, ProdFact."Product ID", GrossDivAmt, MaxAvailable);
                Response := MaxAvailable;
                exit(Response);
            end else begin
                exit(0)
            end;
        end else begin
            exit(0)
        end;
    end;

    procedure GetLoanMaxCreditLimitHistory(CustRec: Record Member; LoanType: Code[20]; TotScore: Decimal; QualAmt: Decimal) Response: Decimal
    var
        HrDate: Codeunit "Date Conversion";
        ContMembership: Record "DSC Continous Membership";
        DscAppScoring: Record "DSC Appraisal Scoring";
        DscAppScore: Record "DSC Appraisal Scoring";
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
        MemberCust: Record Member;
        TotalScore: Decimal;
        HasExistingLoan: Boolean;
        FactProd: Record "Product Factory";
        SharesDepositMultiplier: Decimal;

    begin

        CustomerAge := 0;
        MaxContAge := 0;
        DepositExp := 0;
        GrossDivAmt := 0;
        MembershipDuration := 0;
        SharesDeposit := 0;
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

        FirstDateMonth := CalcDate('-CM-1D', Today);

        ProdFact.Reset();
        ProdFact.SetRange("Product ID", LoanType);
        ProdFact.SetRange(Status, ProdFact.Status::Active);
        ProdFact.SetRange("Loan Span", ProdFact."Loan Span"::Dividends);
        ProdFact.SetRange("Appraisal Parameter Type", ProdFact."Appraisal Parameter Type"::Dividends);
        if ProdFact.FindFirst() then begin

            CustMember.Reset();
            CustMember.SetRange("No.", CustRec."No.");
            if CustMember.FindFirst() then begin
                MemberNo := CustRec."No.";

                if CustMember.Rejoined then begin
                    CustMember.TestField("Rejoining Date");
                    CustomerAge := Round(((Today - CustMember."Rejoining Date") / 30.42), 1, '=');

                end else begin
                    CustomerAge := Round(((Today - CustMember."Registration Date") / 30.42), 1, '=');

                end;

                MembershipDuration := CustomerAge;
                DscAppScoring.Init();
                DscAppScoring."Account No." := CustMember."No.";
                DscAppScoring."Account Name" := CustMember.Name;
                DscAppScoring.Status := CustMember.Status;
                DscAppScoring."Registration Date" := CustMember."Registration Date";
                DscAppScoring."Product Type" := ProdFact."Product ID";

                ContMembership.Reset();
                ContMembership.SetRange(Parameter);
                if ContMembership.FindSet() then begin
                    repeat

                        if (MembershipDuration >= ContMembership."Min. Age") and (MembershipDuration <= ContMembership."Max. Age") then begin
                            MaxContAge := ContMembership.Score;
                        end;
                    until ContMembership.Next() = 0;
                end;

                DscAppScoring."Membership Age" := MaxContAge;

                Loan.Reset();
                Loan.SetRange("Account No.", CustMember."No.");
                Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
                Loan.SetFilter("Performance Indicator", '%1|%2|%3|%4', Loan."Performance Indicator"::Doubtfull,
                Loan."Performance Indicator"::Loss, Loan."Performance Indicator"::Substandard,
                Loan."Performance Indicator"::Watch);
                if Loan.FindFirst() then begin
                    Loan.CalcFields("Outstanding Balance");
                    DscAppScoring."Credit History" := 1
                end else begin
                    DscAppScoring."Credit History" := 2
                end;

                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustMember."No.");
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                if AccCredit.FindFirst() then begin
                    AccCredit.CalcFields("Balance (LCY)");
                    SharesDeposit := AccCredit."Balance (LCY)"
                end;

                Loan.Reset();
                Loan.SetRange("Account No.", CustMember."No.");
                Loan.SetFilter("Outstanding Balance", '>0');
                if Loan.FindSet() then begin
                    repeat
                        Loan.CalcFields("Outstanding Balance");
                        DepositExp := (DepositExp + Loan."Outstanding Balance");
                    until Loan.Next() = 0
                end;

                if SharesDeposit > DepositExp then begin
                    DscAppScoring."Deposit Exposure" := 3
                end else begin

                    if (DepositExp) <= (SharesDeposit * 3) then begin
                        DscAppScoring."Deposit Exposure" := 2
                    end else begin
                        DscAppScoring."Deposit Exposure" := 1
                    end;
                end;

                Contribt := GetMaxMonthlyRemittance(CustMember."No.", '', 30);
                DscAppScoring."Monthly Contribution" := Contribt;
                ShareBand := getAccountShareBand(CustMember."No.");
                DscAppScoring."Shares Banding" := ShareBand;

                if Contribt > ShareBand then begin
                    DscAppScoring."Monthly Deposit" := 2
                end else begin

                    if Contribt = ShareBand then
                        DscAppScoring."Monthly Deposit" := 1 else
                        DscAppScoring."Monthly Deposit" := 0;
                end;

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", MemberNo);
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin

                    StartDate := CalcDate('-CM', FirstDateMonth);
                    Enddate := CalcDate('CM', StartDate);

                    DateFilter := Format(StartDate) + '..' + Format(Enddate);
                    BankAccLedgerEntry.SetCurrentKey("External Document No.");
                    BankAccLedgerEntry.Reset();
                    BankAccLedgerEntry.SetRange("External Document No.", 'SALPROC');
                    BankAccLedgerEntry.SetRange("Customer No.", AccBanking."No.");
                    BankAccLedgerEntry.SetFilter("Posting Date", DateFilter);
                    if BankAccLedgerEntry.FindSet() then begin
                        DscAppScoring."Banking Remittance" := 3
                    end else begin
                        DscAppScoring."Banking Remittance" := 0;
                    end;
                end else begin
                    DscAppScoring."Banking Remittance" := 0;
                end;

                if SharesDeposit > 1000000 then begin
                    DscAppScoring."Total Deposits" := 2
                end;
                if SharesDeposit <= 1000000 then begin
                    DscAppScoring."Total Deposits" := 1
                end;

                Loan.Reset();
                Loan.SetRange("Account No.", CustMember."No.");
                Loan.SetRange("Product Type", ProdFact."Product ID");
                Loan.SetFilter("Outstanding Balance", '>0');
                if Loan.FindFirst() then begin
                    Loan.CalcFields("Outstanding Balance");
                    HasExistingLoan := true;
                end else begin
                    HasExistingLoan := false;
                end;

                if (DscAppScoring."Membership Age" >= 3) or (HasExistingLoan = false) then begin
                    TotalScore := (DscAppScoring."Total Deposits" +
                DscAppScoring."Banking Remittance" + DscAppScoring."Monthly Deposit" +
                DscAppScoring."Deposit Exposure" + DscAppScoring."Credit History" + DscAppScoring."Membership Age");
                end else begin
                    TotalScore := 0;
                end;
                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustMember."No.");
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                if AccCredit.FindFirst() then begin
                    AccCredit.CalcFields("Balance (LCY)");
                    SharesDepositMultiplier := AccCredit."Balance (LCY)";
                end;
                DscAppScoring."Total Score" := TotScore;
                DscAppScoring."Qualify Amount" := QualAmt;
                DscAppScoring.Insert(true);
            end;
        end;
    end;

    procedure GetLoanMaxCreditLimitScoreQC(CustRec: Record Member; LoanType: Code[20]; SavingsDays: Integer; PostInt: Integer) Response: Decimal
    var
        HrDate: Codeunit "Date Conversion";
        ContMembership: Record "DSC Continous Membership";
        DscAppScoring: Record "DSC Appraisal Scoring";
        DscAppScore: Record "DSC Appraisal Scoring";
        CustomerAge: Integer;
        MaxContAge: Integer;
        MemberNo: Code[50];
        AltCtrl: Codeunit "Register Management";
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
        MemberCust: Record Member;
        TotalScore: Decimal;
        HasExistingLoan: Boolean;
        FactProd: Record "Product Factory";
        SharesDepositMultiplier: Decimal;
        AgesInDays: Integer;
        ProdtCategory: Enum ProductAccountCategory;
        LStatus: Enum MobileLoanStatus;
        NotifRgt: Record "Notification Template";
        DscMobRgt: Record "DSC Mobile Loan";

    begin
        CustomerAge := 0;
        MaxContAge := 0;
        DepositExp := 0;
        GrossDivAmt := 0;
        MembershipDuration := 0;
        SharesDeposit := 0;
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

        CustMember.Reset();
        CustMember.SetRange("No.", CustRec."No.");
        if CustMember.FindFirst() then begin
            MemberNo := CustRec."No."
        end;

        DscMobRgt.Reset();
        DscMobRgt.SetRange("Account No.", CustMember."No.");
        DscMobRgt.SetRange(Status, DscMobRgt.Status::Failed);
        DscMobRgt.SetFilter("Requested Amount", '=0');
        DscMobRgt.DeleteAll();

        InitializeScore(MemberNo, LoanType);

        FirstDateMonth := CalcDate('-CM-1D', Today);
        ProdFact.Reset();
        ProdFact.SetRange("Product ID", LoanType);
        ProdFact.SetRange(Status, ProdFact.Status::Active);
        ProdFact.SetRange("Loan Span", ProdFact."Loan Span"::"Mobile Loan");
        if ProdFact.FindFirst() then begin
            ProdFact.TestField("Deposit Multiplier");

            CustMember.Reset();
            CustMember.SetRange("No.", CustRec."No.");
            if CustMember.FindFirst() then begin
                CustMember.TestField("Registration Date");
                CustMember.TestField("Date of Birth");

                if CustMember.Status <> CustMember.Status::Active then begin

                    NotifRgt.Reset();
                    NotifRgt.SetRange("Linked To Table No.", Database::"DSC Appraisal Scoring");
                    NotifRgt.SetRange("Entry Type", NotifRgt."Entry Type"::"Inactive Account");
                    if NotifRgt.FindFirst() then
                        BufferFailedLoanApplicRequest('', CustMember."No.", CustMember."Mobile Phone No", 0,
                ProdFact."Product ID", NotifRgt."Membership Application", LStatus::Failed, '', '');
                    exit(0);
                end;

                if CustMember."Mobile Status" = CustMember."Mobile Status"::Defaulter then begin

                    NotifRgt.Reset();
                    NotifRgt.SetRange("Linked To Table No.", Database::"DSC Appraisal Scoring");
                    NotifRgt.SetRange("Entry Type", NotifRgt."Entry Type"::"Non Performing Account");
                    if NotifRgt.FindFirst() then
                        BufferFailedLoanApplicRequest('', CustMember."No.", CustMember."Mobile Phone No", 0,
                ProdFact."Product ID", NotifRgt."Membership Application", LStatus::Failed, '', '');
                    exit(0);
                end;
                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustMember."No.");
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Capital");
                if AccCredit.FindFirst() then begin
                    AccCredit.CalcFields("Balance (LCY)");
                    FactProd.Reset();
                    FactProd.SetRange("Product ID", AccCredit."Product Type");
                    if FactProd.FindFirst() then
                        FactProd.TestField("Minimum Balance");
                    IF AccCredit."Balance (LCY)" < FactProd."Minimum Balance" then begin

                        NotifRgt.Reset();
                        NotifRgt.SetRange("Linked To Table No.", Database::"DSC Appraisal Scoring");
                        NotifRgt.SetRange("Entry Type", NotifRgt."Entry Type"::"Out of Bound Limit Amount");
                        if NotifRgt.FindFirst() then
                            BufferFailedLoanApplicRequest('', CustMember."No.", CustMember."Mobile Phone No", 0,
                    ProdFact."Product ID", NotifRgt."Membership Application", LStatus::Failed, '', '');
                        exit(0);
                    end;
                end;

                AccCredit.Reset();
                AccCredit.SetRange("No.", CustMember."No.");
                AccCredit.SetRange(Blocked, AccCredit.Blocked::" ");
                AccCredit.SetRange(Status, AccCredit.Status::Active);
                AccCredit.SetFilter("Balance (LCY)", '>0');
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                if AccCredit.Find('-') then begin
                    if GetMaxContribLimit(CustMember."No.", ProdFact."Product ID", 90) = 0 then begin

                        NotifRgt.Reset();
                        NotifRgt.SetRange("Linked To Table No.", Database::"DSC Appraisal Scoring");
                        NotifRgt.SetRange("Entry Type", NotifRgt."Entry Type"::"Null Value");
                        if NotifRgt.FindFirst() then
                            BufferFailedLoanApplicRequest('', CustMember."No.", CustMember."Mobile Phone No", 0,
                    ProdFact."Product ID", NotifRgt."Membership Application", LStatus::Failed, '', '');
                        exit(0);
                    end
                end;

                if CustMember.Rejoined then begin
                    CustMember.TestField("Rejoining Date");
                    CustomerAge := Round(((Today - CustMember."Rejoining Date") / 30.42), 1, '=');
                    AgesInDays := (Today - CustMember."Rejoining Date");

                end else begin
                    CustomerAge := Round(((Today - CustMember."Registration Date") / 30.42), 1, '=');
                    AgesInDays := (Today - CustMember."Registration Date");
                end;

                MembershipDuration := CustomerAge;

                DscAppScoring.Init();
                DscAppScoring."Account No." := CustMember."No.";
                DscAppScoring."Account Name" := CustMember.Name;
                DscAppScoring.Status := CustMember.Status;
                DscAppScoring."Registration Date" := CustMember."Registration Date";
                DscAppScoring."Product Type" := ProdFact."Product ID";

                ContMembership.Reset();
                ContMembership.SetRange("Score Type", ContMembership."Score Type"::Membership);
                if ContMembership.FindSet() then begin
                    repeat
                        if (MembershipDuration >= ContMembership."Min. Age") and (MembershipDuration <= ContMembership."Max. Age") then begin
                            MaxContAge := ContMembership.Score;
                        end;
                    until ContMembership.Next() = 0;
                end;

                DscAppScoring."Membership Age" := MaxContAge;

                if MaxContAge = 0 then begin

                    NotifRgt.Reset();
                    NotifRgt.SetRange("Linked To Table No.", Database::"DSC Appraisal Scoring");
                    NotifRgt.SetRange("Entry Type", NotifRgt."Entry Type"::"Membership Age");
                    if NotifRgt.FindFirst() then
                        BufferFailedLoanApplicRequest('', CustMember."No.", CustMember."Mobile Phone No", 0,
                ProdFact."Product ID", NotifRgt."Membership Application", LStatus::Failed, '', '');

                end;

                Loan.Reset();
                Loan.SetRange("Account No.", CustMember."No.");
                Loan.SetRange("Approval Status", Loan."Approval Status"::Posted);
                Loan.SetFilter("Performance Indicator", '%1|%2|%3|%4', Loan."Performance Indicator"::Doubtfull,
                Loan."Performance Indicator"::Loss, Loan."Performance Indicator"::Substandard,
                Loan."Performance Indicator"::Watch);
                if Loan.FindFirst() then begin
                    Loan.CalcFields("Outstanding Balance");
                    DscAppScoring."Credit History" := 1
                end else begin
                    DscAppScoring."Credit History" := 2
                end;

                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustMember."No.");
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                if AccCredit.FindFirst() then begin
                    AccCredit.CalcFields("Balance (LCY)");
                    SharesDeposit := AccCredit."Balance (LCY)"
                end;

                Loan.Reset();
                Loan.SetRange("Account No.", CustMember."No.");
                Loan.SetFilter("Outstanding Balance", '>0');
                if Loan.FindSet() then begin
                    repeat
                        Loan.CalcFields("Outstanding Balance");
                        DepositExp := (DepositExp + Loan."Outstanding Balance");
                    until Loan.Next() = 0
                end;

                if SharesDeposit > DepositExp then begin
                    DscAppScoring."Deposit Exposure" := 3
                end else begin

                    if (DepositExp) <= (SharesDeposit * 3) then begin
                        DscAppScoring."Deposit Exposure" := 2
                    end else begin
                        DscAppScoring."Deposit Exposure" := 1
                    end;
                end;

                Contribt := GetMaxMonthlyRemittance(CustMember."No.", '', 30);
                DscAppScoring."Monthly Contribution" := Contribt;

                ShareBand := getAccountShareBand(CustMember."No.");
                DscAppScoring."Shares Banding" := ShareBand;

                if Contribt > ShareBand then begin
                    DscAppScoring."Monthly Deposit" := 2
                end else begin
                    if Contribt = ShareBand then
                        DscAppScoring."Monthly Deposit" := 1 else
                        DscAppScoring."Monthly Deposit" := 0;
                end;

                AccBanking.Reset();
                AccBanking.SetRange("Member No.", MemberNo);
                AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                if AccBanking.FindFirst() then begin

                    StartDate := CalcDate('-CM', FirstDateMonth);
                    Enddate := CalcDate('CM', StartDate);

                    DateFilter := Format(StartDate) + '..' + Format(Enddate);
                    BankAccLedgerEntry.SetCurrentKey("External Document No.");
                    BankAccLedgerEntry.Reset();
                    BankAccLedgerEntry.SetRange("External Document No.", 'SALPROC');
                    BankAccLedgerEntry.SetRange("Customer No.", AccBanking."No.");
                    BankAccLedgerEntry.SetFilter("Posting Date", DateFilter);
                    if BankAccLedgerEntry.FindSet() then begin
                        DscAppScoring."Banking Remittance" := 3
                    end else begin
                        DscAppScoring."Banking Remittance" := 0;
                    end;
                end else begin
                    DscAppScoring."Banking Remittance" := 0;
                end;

                if SharesDeposit > 1000000 then begin
                    DscAppScoring."Total Deposits" := 2
                end;
                if SharesDeposit <= 1000000 then begin
                    DscAppScoring."Total Deposits" := 1
                end;

                Loan.Reset();
                Loan.SetRange("Account No.", CustMember."No.");
                Loan.SetRange("Product Type", ProdFact."Product ID");
                Loan.SetFilter("Outstanding Balance", '>0');
                if Loan.FindFirst() then begin
                    Loan.CalcFields("Outstanding Balance");
                    HasExistingLoan := true;
                end else begin
                    HasExistingLoan := false;
                end;
                if HasExistingLoan then begin

                    NotifRgt.Reset();
                    NotifRgt.SetRange("Linked To Table No.", Database::"DSC Appraisal Scoring");
                    NotifRgt.SetRange("Entry Type", NotifRgt."Entry Type"::"Existing Facility");
                    if NotifRgt.FindFirst() then
                        BufferFailedLoanApplicRequest('', CustMember."No.", CustMember."Mobile Phone No", 0,
                ProdFact."Product ID", NotifRgt."Membership Application", LStatus::Failed, '', '');

                end;

                if (DscAppScoring."Membership Age" >= 1) or (HasExistingLoan = false) then begin
                    TotalScore := (DscAppScoring."Total Deposits" +
                DscAppScoring."Banking Remittance" + DscAppScoring."Monthly Deposit" +
                DscAppScoring."Deposit Exposure" + DscAppScoring."Credit History" + DscAppScoring."Membership Age");
                end else begin
                    TotalScore := 0;
                end;

                QualifyAmtBanding.Reset();
                if QualifyAmtBanding.FindSet() then begin
                    repeat
                        if (TotalScore >= QualifyAmtBanding."Min. Amount") and (TotalScore <= QualifyAmtBanding."Max. Amount") then begin
                            ScoreAmt := QualifyAmtBanding.Score;
                        end;
                    until QualifyAmtBanding.Next() = 0
                end;

                if ScoreAmt > ProdFact."Maximum Loan Amount" then
                    ScoreAmt := ProdFact."Maximum Loan Amount";

                AccCredit.Reset();
                AccCredit.SetRange("Member No.", CustMember."No.");
                AccCredit.SetRange("Account Category", AccCredit."Account Category"::"Shares Deposit");
                if AccCredit.FindFirst() then begin
                    AccCredit.CalcFields("Balance (LCY)");
                    SharesDepositMultiplier := (AccCredit."Balance (LCY)" * (ProdFact."Deposit Multiplier" / 100));
                end;

                if ScoreAmt >= SharesDepositMultiplier then
                    ScoreAmt := SharesDepositMultiplier else
                    ScoreAmt := ScoreAmt;

                if (DscAppScoring."Membership Age" >= 1) or (HasExistingLoan = false) then begin
                    ScoreAmt := ScoreAmt;
                end else begin
                    ScoreAmt := 0;

                end;

                DscAppScoring."Total Score" := Round(TotalScore, 1, '=');

                QcQualifyAmt.Reset();
                QcQualifyAmt.SetRange("No.", CustMember."No.");
                QcQualifyAmt.SetRange("Product Type", ProdFact."Product ID");
                if QcQualifyAmt.FindFirst() then begin

                    if HasExistingLoan or (DscAppScoring."Membership Age" = 0) then begin
                        DscAppScoring."Qualify Amount" := 0;
                    end else begin
                        DscAppScoring."Qualify Amount" := QcQualifyAmt."Qualifying Amount";
                    end;
                end else begin
                    DscAppScoring."Qualify Amount" := ScoreAmt;
                end;

                DscAppScoring.Insert(true);
                Response := DscAppScoring."Qualify Amount";
                exit(Response)
            end else begin
                exit(0)
            end;

        end else begin
            exit(0)
        end;


    end;

    local procedure MonthlyContrib(CustNo: Code[100]) MinShare: Decimal
    var
        CustRecord: Record Member;
    begin
        CustRecord.Reset();
        CustRecord.SetRange("No.", CustNo);
        if CustRecord.FindFirst() then begin

        end;

    end;

    local procedure FetchMemberDailySavings(AcNo: Code[20])
    var
        CShedule: record "Contribution Schedule";
        SavLedgers: Record "Banking A/c Ledger Entry";

    begin
        CShedule.Reset();
        CShedule.SetRange("Account No.", AcNo);
        if CShedule.FindSet() then begin
            repeat
                SavLedgers.Reset();
                SavLedgers.SetRange("Customer No.", CShedule."Account No.");
                SavLedgers.SetRange("Posting Date", CShedule."Posting Date");
                SavLedgers.SetRange(Reversed, FALSE);
                if SavLedgers.FindSet() then begin
                    SavLedgers.CalcSums(Amount);
                    CShedule.Amount := SavLedgers.Amount * -1;
                    CShedule.Modify(true)
                end;
            until CShedule.Next() = 0;
        end;

    end;

    local procedure FetchCreditMemberDailySavings(AcNo: Code[20])
    var
        CShedule: record "Contribution Schedule";
        SavLedgers: Record "Credits A/c Ledger Entry";

    begin
        CShedule.Reset();
        CShedule.SetRange("Account No.", AcNo);
        if CShedule.FindSet() then begin
            repeat

                SavLedgers.Reset();
                SavLedgers.SetRange(Reversed, false);
                SavLedgers.SetRange("Customer No.", CShedule."Account No.");
                SavLedgers.SetRange("Posting Date", CShedule."Posting Date");
                if SavLedgers.FindSet() then begin
                    SavLedgers.CalcSums(Amount);
                    CShedule.Amount := SavLedgers.Amount * -1;
                    CShedule.Modify(true)
                end;
            until CShedule.Next() = 0;
        end;

    end;

    procedure GetMaxMonthlyRemittance(MemberNo: Code[50]; LoanType: Code[20]; SavingsDays: Integer) Response: Decimal
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
    begin

        AmtMax := 0;
        SharesContrib := 0;

        SavAcc.Reset();
        SavAcc.SetRange("Member No.", MemberNo);
        SavAcc.SetRange("Account Category", SavAcc."Account Category"::"Shares Deposit");
        if SavAcc.FindFirst() then begin

            RSchedule.Reset();
            RSchedule.SetRange("Account No.", SavAcc."No.");
            RSchedule.SetRange("Entry Type", RSchedule."Entry Type"::Qualification);
            RSchedule.DeleteAll();

            if SavingsDays = 14 then begin
                InitialInstal := 14;
                RepayPeriod := 14;
                RunDate := CalcDate('-14D', Today);
            end else begin
                InitialInstal := 30;
                RepayPeriod := 30;
                RunDate := CalcDate('-30D', Today);
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
                ScheduleTxt.CalcSums(Amount);
                IF SavingsDays = 14 then
                    AmtMax := (ScheduleTxt.Amount) * 3 else
                    AmtMax := (ScheduleTxt.Amount);
            end;
            Response := AmtMax;
        end;
    end;



    procedure GetMaxContribLimit(MemberNo: Code[50]; LoanType: Code[20]; SavingsDays: Integer) Response: Decimal
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
    begin

        SavingsDays := 90;

        AmtMax := 0;
        SharesContrib := 0;

        SavAcc.Reset();
        SavAcc.SetRange("Member No.", MemberNo);
        SavAcc.SetRange("Account Category", SavAcc."Account Category"::"Shares Deposit");
        if SavAcc.FindFirst() then begin
            RSchedule.Reset();
            RSchedule.SetRange("Account No.", SavAcc."No.");
            RSchedule.DeleteAll();

            if SavingsDays = 14 then begin
                InitialInstal := 14;
                RepayPeriod := 14;
                RunDate := CalcDate('-14D', Today);
            end else begin
                InitialInstal := 90;
                RepayPeriod := 90;
                RunDate := CalcDate('-90D', Today);
            end;
            InstalNo := 0;
            repeat
                InstalNo := InstalNo + 1;
                RSchedule.Init();
                RSchedule."Account No." := SavAcc."No.";
                RSchedule."Posting Date" := RunDate;
                RSchedule."Installment No." := InstalNo;
                RSchedule.Amount := 0;
                RSchedule.Insert(true);
                RunDate := CalcDate('1D', RunDate);
            until InstalNo = SavingsDays;
            FetchCreditMemberDailySavings(SavAcc."No.");

            ScheduleTxt.Reset();
            ScheduleTxt.SetRange("Account No.", SavAcc."No.");
            IF ScheduleTxt.Find('-') then begin
                ScheduleTxt.CalcSums(Amount);
                IF SavingsDays = 14 then
                    AmtMax := (ScheduleTxt.Amount) * 3 else
                    AmtMax := (ScheduleTxt.Amount);
            end;

            ContribTxt.Reset();
            ContribTxt.SetRange("Application No.", SavAcc."No.");
            ContribTxt.SetRange(Type, ContribTxt.Type::"Shares Deposit");
            if ContribTxt.FindFirst() then begin
                SharesContrib := ContribTxt.Amount
            end;

            ScheduleTxt.Reset();
            ScheduleTxt.SetRange("Account No.", SavAcc."No.");
            ScheduleTxt.SetFilter(Amount, '< SharesContrib');
            IF ScheduleTxt.Find('-') then
                AmtMax := 0 else
                AmtMax := AmtMax;
            if AmtMax < 0 then
                AmtMax := 0;
            Response := AmtMax;
        end;
    end;

    procedure MobLoanApplicationTxt(MemberNo: Code[20]; AmtToPost: Decimal; Descript: Text[150]; LoanType: Code[20]; DocNo: Code[20]; SavingsDays: Integer; PhoneNo: Code[20]; IntPeriod: Integer) Response: Code[100]
    var
        Post: Code[100];
        LStatus: Enum MobileLoanStatus;
        CredtMngt: Codeunit "Credit Mgmt.";
    begin
        if (AmtToPost > 0) and (LoanType <> '') and (MemberNo <> '') then begin
            Response := '0';
            Post := '0';
            Response := DscScoringMngt.CheckMemberEligibilityCreteria(MemberNo, LoanType, DocNo, AmtToPost, Descript, PhoneNo, IntPeriod);
        end else begin
            Response := '01|Invalid Entry';
            BufferFailedLoanApplication('', MemberNo, PhoneNo, AmtToPost, LoanType, Descript, LStatus::Failed, '', DocNo);
        end;
    end;

    procedure getAccountShareBand(AccountNo: Code[50]) TempAmt: Decimal
    var
        PostedLoan: Record Loans;
        PostedAmt: Decimal;
        ShareBanding: Record "Shares Banding";
        AccDredit: Record "Account Credit";
        ProdFac: Record "Product Factory";
    begin

        PostedLoan.Reset();
        PostedLoan.SetCurrentKey("Approved Amount");
        PostedLoan.Ascending(false);
        PostedLoan.SetFilter("Outstanding Balance", '>0');
        PostedLoan.SetRange("Account No.", AccountNo);
        PostedLoan.SetRange("Ignore Related Balance", false);
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
            AccDredit.Reset();
            AccDredit.SetRange("Member No.", AccountNo);
            AccDredit.SetRange("Account Category", AccDredit."Account Category"::"Shares Deposit");
            if AccDredit.FindFirst() then begin
                if ProdFac.Get(AccDredit."Product Type") then
                    ProdFac.TestField("Minimum Contribution");
                TempAmt := ProdFac."Minimum Contribution";
            end;
        end;
        exit(TempAmt)
    end;

    procedure CreateLines(DocNo: Code[50]; AccountNo: Code[100]; ProductType: Code[20]; Descript: Text[150]; AccruedInt: Decimal; InterestPayableAccount: Code[20])
    var
        InterestEntry: Record "Interest Line";
        SavingsBuffer: Record "Savings Interest Buffer";
    begin
        InterestEntry.LockTable();
        InterestEntry.Init();
        InterestEntry.No := DocNo;
        InterestEntry."Account No" := AccountNo;
        InterestEntry."Product Type" := ProductType;
        InterestEntry."Interest Date" := Today;
        InterestEntry.Description := Descript;
        InterestEntry.Amount := AccruedInt;
        InterestEntry."Interest Bills" := AccruedInt;
        InterestEntry."Interest Bills" := AccruedInt;
        InterestEntry."Bal. Account No." := InterestPayableAccount;
        InterestEntry.Insert(true);

    end;

    procedure CreateMonthlyAccruedInt(DocNo: Code[50]; AccountNo: Code[100]; AccountName: Text[150]; DBalance: decimal; IntRate: Decimal; AsAt: Date; ProductType: Code[20]; Descript: Text[150]; AccruedInt: Decimal; InterestPayableAccount: Code[20]; InterestExpenseAc: Code[20])
    var
        InterestEntry: Record "Interest Line";
        SavingsBuffer: Record "Savings Interest Buffer";
    begin

        SavingsBuffer.Init();
        SavingsBuffer."No." := DocNo;
        SavingsBuffer."Account Type" := SavingsBuffer."Account Type"::Saving;
        SavingsBuffer."Account No" := AccountNo;
        SavingsBuffer.Name := AccountName;
        SavingsBuffer.Description := Descript;
        SavingsBuffer."Interest Amount" := AccruedInt;
        SavingsBuffer."Account Balance" := DBalance;
        SavingsBuffer."Interest Date" := AsAt;
        SavingsBuffer."Interest Rate" := IntRate;
        SavingsBuffer."Product Factory Code" := ProductType;
        SavingsBuffer."Expense Account" := InterestExpenseAc;
        SavingsBuffer."Payable Account" := InterestPayableAccount;
        SavingsBuffer.Insert(true);

    end;

    procedure CopyRecord(ActionItem: Integer; RecRefId: Record "Product Factory"; AccDimension: Enum AccountDimension)
    var
        RecRef: RecordRef;
        Temp: Record "Product Factory Temp.";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        OnConfirmDialogMembTxt: Label 'Are you sure you want to create this member account?';
        VarVariant: Variant;
        PFactory: Record "Product Factory";
        Factory: Record "Product Factory Temp.";
        RegMgt: Codeunit "Register Management";
    begin


        Factory.DeleteAll();
        PFactory.Reset();
        PFactory.SetRange("Product ID", RecRefId."Product ID");
        if PFactory.FindFirst() then begin
            Factory."Entry No." := RegMgt.InitNextPFactEntryNo;
            Factory.TransferFields(PFactory);
            Factory.Insert(true);
            Commit();
            Report.Run(Report::"Copy Product", true, false, PFactory);
        end
    end;

    procedure CopyRecordRef(ActionItem: Code[20]; RecRefId: Code[20]; AccDimension: Enum AccountDimension)
    var
        RecRef: RecordRef;
        Temp: Record "Product Factory";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
        OnConfirmDialogMembTxt: Label 'Are you sure you want to create this member account?';
        VarVariant: Variant;
        PFactory: Record "Product Factory";
        PFact: Record "Product Factory";
        Factory: Record "Product Factory Temp.";
    begin

        PFactory.Reset();
        PFactory.SetRange("Product ID", RecRefId);
        if PFactory.FindFirst() then begin
            Factory.Reset();
            Factory.SetRange("Product ID", PFactory."Product ID");
            if Factory.FindFirst() then begin
                Factory."Product ID" := ActionItem;
                Factory."Account Dimension" := AccDimension;
                Factory."Posting Group" := '';
                Factory.Status := Factory.Status::Open;
                Factory.Modify(true);
                Temp.TransferFields(Factory);
                Temp.Insert(true);
            end;

            Commit();
            if PFact.Get(ActionItem) then
                Page.Run(Page::"Product Factory-Account", PFact, PFact."Product ID");
        end;
    end;

    procedure CreateEftFile(EftNo: code[100]; FileNo: Text[250]; EftOption: Enum EFTPaymentOptions; NoOfFiles: Integer; Amt: Decimal)
    var
        EftFile: Record "EFT File";
        EftHeader: Record "EFT Transfer Header";
        Bnk: Record "Bank Account";
    begin

        EftFile.Init();
        EftFile."EFT No." := EftNo;
        EftFile."File No." := FileNo;
        EftFile."EFT Options" := EftOption;
        if EftFile."EFT Options" = EftFile."EFT Options"::"Mobile Money" then
            EftFile."Sequence No." := InitNextEntryNoEftFile() else
            EftFile."Sequence No." := EftFile."Entry No.";
        EftFile."No. of Files" := NoOfFiles;
        EftFile.Amount := Amt;
        if EftHeader.Get(EftFile."EFT No.") then begin
            EftFile."Bank Code" := EftHeader."Account No.";
            EftFile."Account Name" := EftHeader."Account Name";
            EftFile."Product Type" := EftHeader."Product Type";
            if Bnk.Get(EftHeader."Account No.") then
                EftFile."Bank Account No." := Bnk."Bank Account No.";

        end;
        EftFile.Insert(true)
    end;

    procedure CreateEFTLineEntry(ValuePost: Integer; EftHeaderNo: code[100]; LoanNo: code[100]; OtherComEntryNo: Integer; PaymentDestCode: Code[100]; ExtAccountNo: Code[100]; RecipientReference: Code[100]; BranchCode: Code[20]; MobilePhoneNo: Code[20]; Amt: Decimal; ExtAccountName: Text[200]; CheckLineAmt: Boolean; PartialNo: Code[100])
    var
        EftLine: Record "EFT Transfer Lines";
        BanksList: Record Banks;
        Loans: Record Loans;
        EftHeader: Record "EFT Transfer Header";
        LnApplication: Record "Loan Application";
        CustRec: Record Member;
        CredMgt: Codeunit "Credit Mgmt.";
    begin

        if EftHeader.Get(EftHeaderNo) then begin

            EftLine.Init();
            case ValuePost of
                0:

                    begin

                        EftLine.No := '';
                        EftLine."External Committment No." := OtherComEntryNo;
                        EftLine."Document No." := EftHeaderNo;
                        EftLine."Application Source" := EftHeader."Application Source";
                        EftLine."EFT Options" := EftHeader."EFT Options";
                        EftLine.Type := EftLine.Type::Loan;
                        if Loans.Get(LoanNo) then
                            EftLine.Validate("Loan No.", Loans."No.");
                        EftLine."Product Type" := Loans."Product Type";
                        EftLine."Disbursement Date" := Loans."Disbursement Date";
                        EftLine."Account Type" := EftLine."Account Type"::Savings;
                        EftLine.Validate("Account No.", Loans."Disbursement Account No.");
                        EftLine.Validate("Bank Code", PaymentDestCode);
                        EftLine."Partial Loan No." := PartialNo;

                        BanksList.Reset();
                        BanksList.Setrange(Code, PaymentDestCode);
                        if BanksList.FindFirst() then begin

                            if BanksList."Institution Type" = BanksList."Institution Type"::Bank then begin
                                EftLine.Validate("External Account No.", ExtAccountNo);
                                EftLine."Institution Type" := EftLine."Institution Type"::Bank;
                                EftLine."Recipient Reference" := RecipientReference;
                                EftLine."Own Reference" := Loans."Account No.";
                                EftLine."Society Code" := '';

                            end else begin

                                EftLine.Validate("External Account No.", BanksList."Society Code");
                                EftLine."Institution Type" := EftLine."Institution Type"::"Building Society";
                                EftLine."Society Code" := BanksList."Society Code";
                                EftLine."Own Reference" := EftLine."Member No.";
                                EftLine."Recipient Reference" := RecipientReference;
                            end;
                            EftLine.Validate("Branch Code", BranchCode);
                        end;

                        if CheckLineAmt then begin
                            EftLine."Mobile Phone No." := MobilePhoneNo;
                            EftLine.Amount := Amt;
                            EftLine."Account Name" := ExtAccountName;
                            EftLine."External Account Name" := ExtAccountName;
                        end;

                        EftLine.insert(true);
                        CredMgt.UpdateChangesOnEftLine(EftHeader."No.", Loans."Application No.");
                    end;
                1:
                    begin
                        if Loans.Get(LoanNo) then begin
                            if Loans."Batch No." = '' then begin
                                EftLine.No := '';
                                EftLine."Document No." := EftHeader."No.";
                                EftLine."Application Source" := EftHeader."Application Source";
                                EftLine."EFT Options" := Loans."EFT Options";
                                EftLine.Type := EftLine.Type::Loan;
                                EftLine.Validate("Loan No.", Loans."No.");
                                EftLine."Account Type" := EftLine."Account Type"::Savings;
                                EftLine.Validate("Account No.", Loans."Disbursement Account No.");
                                EftLine.Validate("Bank Code", Loans."Payment Destination Code");
                                EftLine."Partial Loan No." := PartialNo;

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
                                if EftLine."Mobile Phone No." = '' then begin
                                    if CustRec.Get(EftLine."Member No.") then
                                        EftLine."Mobile Phone No." := CustRec."Mobile Phone No";
                                end;
                                if CheckLineAmt then begin
                                    EftLine.Amount := Amt;
                                end;
                            end;
                        end;
                        EftLine.insert(true);
                    end;
            end;

        end;
    end;

    procedure CheckEFTExistLine(EftHeader: Record "EFT Transfer Header"; LoanNo: Code[100])
    var
        EftTransferLine: Record "EFT Transfer Lines";
        Text0003: Label 'Loan No. %1 already attached to EFT No. %2';
    begin
        EftTransferLine.Reset();
        EftTransferLine.SetRange("Loan No.", LoanNo);
        if EftTransferLine.FindFirst() then begin
            if EftTransferLine."Document No." <> EftHeader."No." then
                Error(Text0003, EftTransferLine."Loan No.", EftTransferLine."Document No.");
        end;
    end;

    procedure getsettlementFee(LoanNo: code[100]): Decimal
    var
        TempFile: Record "Temp. Files";
    begin
        TempFile.Reset();
        TempFile.SetRange(Posted, false);
        TempFile.SetRange("Loan No.", LoanNo);
        if TempFile.FindFirst() then begin
            exit(TempFile.Amount)
        end;
        exit(0)
    end;

    procedure UpdateAccruedInt(RecRefNo: code[100]) AccruedInt: Decimal
    var
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        ReceiptLine: Record "Receipt Line";
        Loan: Record Loans;
        PeriodAct: Codeunit "Periodic Activities Mgt.";

    begin

        ReceiptLine.Reset;
        ReceiptLine.SetFilter(Amount, '>0');
        ReceiptLine.SetRange("Clear Loan", true);
        ReceiptLine.SetRange(ReceiptLine.No, RecRefNo);
        if ReceiptLine.Find('-') then begin
            Loan.SetRange("No.", ReceiptLine."Loan No.");
            Loan.CalcFields("Outstanding Balance");
            if Loan."Outstanding Balance" > 0 then begin
                EndDate := Today;
                StartDate := CalcDate('-CM', EndDate);
                IntDays := (EndDate - StartDate) + 1;
                AccruedInt := PeriodAct.fnIntEntriesonSpecificLoan(Loan, Today, Loan."No.", 1, IntDays, StartDate);
                exit(AccruedInt)
            end;
            exit(0)
        end;
    end;

    procedure UpdateReceiptLine(RecRefNo: code[100])
    var
        ReceiptLine: Record "Receipt Line";
        Loan: Record Loans;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
    begin

        ReceiptLine.Reset;
        ReceiptLine.SetFilter(Amount, '>0');
        ReceiptLine.SetRange("Clear Loan", true);
        ReceiptLine.SetRange(ReceiptLine.No, RecRefNo);
        if ReceiptLine.Find('-') then begin
            repeat
                ReceiptLine.Validate("Clear Loan");
                ReceiptLine.Modify(true);
            until ReceiptLine.Next() = 0;
        end
    end;

    procedure UpdateAccountSourcetLine(RecRefNo: code[100])
    var
        ReceiptLine: Record "Account Transfer Destination";
        Loan: Record Loans;
        PeriodAct: Codeunit "Periodic Activities Mgt.";
    begin

        ReceiptLine.Reset;
        ReceiptLine.SetFilter(Amount, '>0');
        ReceiptLine.SetRange("Clear Loan", true);
        ReceiptLine.SetRange("No.", RecRefNo);
        if ReceiptLine.Find('-') then begin
            repeat
                ReceiptLine.Validate("Clear Loan");
                ReceiptLine.Modify(true);
            until ReceiptLine.Next() = 0;
        end
    end;

    procedure ValidateDefaultDim(CustNo: Code[100])
    var
        VendAc: Record Vendor;
        CustAc: Record Customer;
        CustRecord: Record Member;
    begin
        if CustRecord.Get(CustNo) then begin

            VendAc.Reset();
            VendAc.SetRange("Member No.", CustRecord."No.");
            if VendAc.FindSet() then begin
                repeat
                    if (VendAc."Global Dimension 1 Code" = '') or (VendAc."Global Dimension 2 Code" = '') then begin
                        VendAc.Validate("Global Dimension 1 Code", CustRecord."Global Dimension 1 Code");
                        VendAc.Validate("Global Dimension 2 Code", CustRecord."Global Dimension 2 Code");
                        VendAc.Modify(true);
                    end;
                until VendAc.Next() = 0;
            end;

            CustAc.Reset();
            CustAc.SetRange("Member No.", CustRecord."No.");
            if CustAc.FindSet() then begin
                repeat
                    if (CustAc."Global Dimension 1 Code" = '') or (CustAc."Global Dimension 2 Code" = '') then begin
                        CustAc.Validate("Global Dimension 1 Code", CustRecord."Global Dimension 1 Code");
                        CustAc.Validate("Global Dimension 2 Code", CustRecord."Global Dimension 2 Code");
                        CustAc.Modify(true);
                    end;
                until CustAc.Next() = 0;
            end;
        end;
    end;

    procedure fnCalculateShareBoost(AccountNo: code[100]; LoanType: code[10]; AmountApplied: Decimal) DepositPurchase: Decimal
    var
        AccDredit: Record "Account Credit";
        FactProd: Record "Product Factory";
    begin

        AccDredit.Reset();
        AccDredit.SetRange("Member No.", AccountNo);
        AccDredit.SetRange("Account Category", AccDredit."Account Category"::"Shares Deposit");
        if AccDredit.FindFirst() then begin
            AccDredit.CalcFields("Balance (LCY)");
            if FactProd.Get(LoanType) then begin
                DepositPurchase := ((AmountApplied / FactProd."Ordinary Deposits Multiplier") - (AccDredit."Balance (LCY)"));
                if DepositPurchase < 0 then DepositPurchase := 0;
                exit(DepositPurchase)
            end
        end;

        exit(0)

    end;

    procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Post,&Post Preview';
        DefaultOption: Integer;
        PassInt: Integer;
    begin

        if DefaultOption > 2 then
            DefaultOption := 2;
        if DefaultOption <= 0 then
            DefaultOption := 0;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to Post');
        PassInt := Selection;

        if Selection = 0 then
            exit;
        exit(PassInt);
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

    procedure CheckCustDefaulterStatus(MemberNo: Code[100]; ValuePost: Boolean): Boolean
    var
        Cust: Record Member;
    begin

        case ValuePost of
            true:
                begin
                    Cust.SetRange("No.", MemberNo);
                    Cust.SetRange("Loan Status", Cust."Loan Status"::Defaulter);
                    if Cust.FindFirst() then begin
                        exit(true)
                    end;
                end;
            false:
                begin
                    Cust.SetRange("No.", MemberNo);
                    Cust.SetRange("Mobile Status", Cust."Mobile Status"::Defaulter);
                    if Cust.FindFirst() then begin
                        exit(true)
                    end;
                end;
        end;
        exit(false)
    end;

    procedure fngetmembercategory(CustNo: Code[100]): Enum MemberCategoryType
    var
        CustRec: Record Member;
        Membercategory: Record "Member Category";
    begin

        CustRec.Reset();
        CustRec.SetRange("No.", CustNo);
        if CustRec.FindFirst() then begin
            CustRec.TestField("Employer Code");
            CustRec.TestField("Member Category");

            Membercategory.Reset();
            Membercategory.SetRange("No.", CustRec."Member Category");
            if Membercategory.FindFirst() then begin
                exit(Membercategory.Type)
            end;
        end;
    end;

    procedure fngetAccountBalance(MemberNo: Code[100]; Accountcategory: Enum ProductAccountCategory): Decimal
    var
        CustRecord: Record Member;
        Loans: Record Loans;
        PFact: Record "Product Factory";
        AccountBanking: Record "Account Banking";
        CreditAcc: Record "Account Credit";
        Amt: Decimal;
    begin
        Amt := 0;
        case Accountcategory of
            Accountcategory::"Shares Deposit":
                begin
                    CreditAcc.SetRange("Member No.", MemberNo);
                    CreditAcc.SetRange("Account Category", Accountcategory);
                    if CreditAcc.FindFirst() then begin
                        CreditAcc.CalcFields("Balance (LCY)");
                        exit(CreditAcc."Balance (LCY)")
                    end;
                end;
            Accountcategory::Loan:
                begin
                    Loans.Reset();
                    Loans.SetRange("Account No.", MemberNo);
                    Loans.SetFilter("Outstanding Balance", '>0');
                    if Loans.FindSet() then begin
                        repeat
                            Loans.CalcFields("Outstanding Balance");
                            Amt := (Amt + Loans."Outstanding Balance");
                        Until Loans.Next() = 0;
                        exit(Amt)
                    end
                end;
        end;
    end;

    procedure GetMonthlyRemittanceOnSharesDeposit(MemberNo: Code[100]; LoanType: Code[20]; StartDate: Date; Enddate: Date; DocNo: Code[50]; SavingsDays: Integer)
    var

        AmtMax: Decimal;
        SavAcc: Record "Account Credit";
        RSchedule: Record "Contribution Schedule-Deposit";
        InitialInstal: Integer;
        RunDate: Date;
        RepayPeriod: Integer;
        InstalNo: Integer;
        ScheduleTxt: Record "Contribution Schedule-Deposit";
        ContribTxt: Record "Member Monthly Contribution";
        SharesContrib: Decimal;
        SavLedgers: Record "Cust. Ledger Entry";
        Dfilter: Text;

    begin
        AmtMax := 0;
        SharesContrib := 0;

        Dfilter := Format(StartDate) + '..' + Format(Enddate);

        SavAcc.Reset();
        SavAcc.SetRange("No.", MemberNo);
        if SavAcc.FindFirst() then begin

            RSchedule.SetRange("Document No.", DocNo);
            RSchedule.DeleteAll();

            InitialInstal := SavingsDays;
            RepayPeriod := SavingsDays;
            RunDate := StartDate;
            InstalNo := 0;

            SavLedgers.Reset();
            SavLedgers.SetRange(Reversed, false);
            SavLedgers.SetRange("Customer No.", SavAcc."No.");
            SavLedgers.SetFilter("Posting Date", Dfilter);
            if SavLedgers.FindSet() then begin
                repeat
                    SavLedgers.CalcFields(Amount, "Amount (LCY)");

                    InstalNo := InstalNo + 1;
                    RSchedule.Init();
                    RSchedule."Entry No." := InitNextContEntryNo();
                    RSchedule."Document No." := DocNo;
                    RSchedule."Account No." := SavAcc."No.";
                    RSchedule."No. of Days" := (Enddate - SavLedgers."Posting Date");
                    RSchedule."Product Type" := SavAcc."Product Type";
                    RSchedule."Posting Date" := SavLedgers."Posting Date";
                    RSchedule."Month Text" := Format(SavLedgers."Posting Date", 0, '<Month Text>');
                    RSchedule.Description := RSchedule."Month Text" + ' - ' + Format(Date2DMY(SavLedgers."Posting Date", 3));
                    RSchedule."Installment No." := InstalNo;
                    RSchedule."Qualifying Share" := Abs(SavLedgers."Amount (LCY)");
                    RSchedule."Member No." := SavAcc."Member No.";
                    RSchedule."Start Date" := StartDate;
                    RSchedule."End Date" := Enddate;
                    if RSchedule."Qualifying Share" > 0 then begin
                        RSchedule.Amount := Round(RSchedule."Qualifying Share" * (12 / 100) * (RSchedule."No. of Days" / (Enddate - StartDate)));
                        RSchedule.Insert(true);
                    end;
                until SavLedgers.Next() = 0;
            end;
        end;
    end;

    procedure InitNextContEntryNo(): Integer
    var

        RecRef: Record "Contribution Schedule-Deposit";
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



}




