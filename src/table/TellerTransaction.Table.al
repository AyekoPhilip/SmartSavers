table 50417 "Teller Transaction"
{
    DataClassification = CustomerContent;
    DrillDownPageID = "Teller Transactions Logs";
    LookupPageID = "Teller Transactions Logs";
    fields
    {
        field(50009; "No."; Code[20])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = if ("Document Type" = const("Teller Transactions"), "Account Dimension" = const(Savings)) "Account Banking" where(Status = filter(<> Deceased), Blocked = filter(" "))
            else
            if ("Document Type" = const("Account Zerolizing")) "Account Banking" where(Status = filter(Deceased | Withdrawn), Blocked = filter(" "))
            else
            if ("Document Type" = const("Teller Transactions"), "Account Dimension" = const(Prepayment)) "Repayment Account";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ProdFact: Record "Product Factory";
                ImageData: Record "Image Data";
                AccKins: Record "Account Kins";

            begin
                CheckRequiredItems;

                Account.Reset;
                Account.SetRange("No.", "Account No.");
                if Account.Find('-') then begin
                    Account.CalcFields(Account."Balance (LCY)", Balance);
                    "Account Name" := Account.Name;
                    Remarks := Account.Name;
                    Payee := Account.Name;
                    "Member No." := Account."Member No.";
                    "Product Type" := Account."Product Type";
                    "Currency Code" := Account."Currency Code";
                    "ID No" := Account."ID/Passport No.";
                    "Member No." := Account."Member No.";
                    "Book Balance" := Account."Balance (LCY)";
                    "Product Category" := Account."Account Category";
                    "Employer Code" := Account."Employer Code";
                    "Signing Instructions" := Account."Signing Mandates";

                end;

                case "Document Type" of
                    "Document Type"::"Teller Transactions":
                        begin
                            Amount := 0;
                            "Available Balance" := 0;
                        end else begin
                        Amount := Account."Balance (LCY)";
                        "Available Balance" := Account."Balance (LCY)";
                    end;
                end;

                if ProdFact.Get("Product Type") then begin
                    case ProdFact."Account Validation" of
                        prodfact."Account Validation"::"Photo Signature":
                            begin
                                ImageData.Reset();
                                ImageData.SetRange("ID No.", "ID No");
                                ImageData.SetRange("Member No.", "Member No.");
                                if ImageData.Find('-') then
                                    if not ImageData.Picture.HasValue then
                                        Error('This account does not have Picture/Signature attached to it');

                                ImageData.Reset();
                                ImageData.SetRange("ID No.", "ID No");
                                ImageData.SetRange("Member No.", "Member No.");
                                if ImageData.Find('-') then
                                    if not ImageData.Signature.HasValue then
                                        Error('This account does not have Picture/Signature attached to it');

                            end;

                        ProdFact."Account Validation"::"Account Kin":
                            begin
                                AccKins.Reset();
                                AccKins.SetRange("Account No.", "Account No.");
                                if AccKins.Find('-') then begin
                                    repeat
                                        if not AccKins.Picture.HasValue then
                                            Error('No Picture attached to this account');
                                        if not AccKins.Signature.HasValue then
                                            Error('No Signature attached to this account');
                                    until AccKins.Next() = 0;
                                end else begin
                                    Error('This account has no account Kins attached to it');
                                end;
                            end;
                        ProdFact."Account Validation"::Signatories:
                            begin
                                Signatories.Reset();
                                Signatories.SetRange("Account No.", "Account No.");
                                if Signatories.Find('-') then begin
                                    repeat
                                        if not Signatories.Picture.HasValue then
                                            Error('Signatory does not have a photo attached to it');
                                        if not Signatories.Signature.HasValue then
                                            Error('Signatory does not have a signature attached to it');

                                        SignInstruction.Reset();
                                        SignInstruction.SetRange("No.", Rec."No.");
                                        if SignInstruction.FindSet() then exit;

                                        SignInstruction.Init();
                                        SignInstruction."No." := Rec."No.";
                                        SignInstruction."Account No." := Signatories."Account No.";
                                        SignInstruction."Member No." := Signatories."Member No.";
                                        SignInstruction.Name := Signatories.Names;
                                        SignInstruction."ID No." := Signatories."ID No.";
                                        SignInstruction."Date of Birth" := Signatories."Date Of Birth";
                                        SignInstruction.Signatory := Signatories.Signatory;
                                        SignInstruction."Must be Present" := Signatories."Must be Present";
                                        SignInstruction."Must Sign" := Signatories."Must Sign";
                                        SignInstruction.Insert();
                                    until Signatories.Next() = 0;
                                end else begin
                                    Error('This account has no signatories attached to it');
                                end;
                            end;
                    end;
                end;
                BUserSetup.Reset();
                BUserSetup.SetRange("Account ID", UserId);
                BUserSetup.SetRange("Account No.", "Account No.");
                if BUserSetup.Find('-') then begin
                    "Attempted Self Transaction" := true;
                end;

                if (Type = Type::"Credit Receipt") or (Type = Type::"Credit Cheque") then begin
                    RegMngt.InitializeTellerLines(Rec."No.");
                end;
                CalcAvailableBal;
                Validate("Member No.");
            end;
        }
        field(50011; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Transaction Type"; Code[20])
        {
            TableRelation = if ("Document Type" = const("Teller Transactions")) "Transaction Types".Code WHERE("Product Type" = FIELD("Product Type"),
                                                            Category = CONST(Cashier)) else
            if ("Document Type" = const("Account Zerolizing")) "Transaction Types".Code WHERE("Product Type" = FIELD("Product Type"),
                                                            Category = CONST(Cashier), Type = const("Account Zerolize"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CheckRequiredItems;
                if TransactionTypes.Get("Transaction Type") then begin
                    "Transaction Description" := TransactionTypes.Description;
                    Type := TransactionTypes.Type;
                end;
                if (Type = Type::"Cheque Deposit") or (Type = Type::"Credit Cheque") then begin
                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup."Account ID", UserId);
                    if BUserSetup.Find('-') then begin
                        "Bank Account" := BUserSetup."Cheque Clearance Account";
                    end;
                end;

                case Type of
                    Type::"Bank Cheques",
                    Type::"Cash Withdrawal",
                    Type::"Cheque Deposit":
                        begin
                            Account.Reset;
                            Account.SetRange("No.", "Account No.");
                            if Account.Find('-') then begin
                                if Account.Status <> Account.Status::Active then
                                    Error('This account is not allowed to transaction. The status is %1', Account.Status);
                            end;
                            RegMngt.InitializeTellerLines(Rec."No.");
                        end;
                    Type::"Credit Cheque",
                    Type::"Credit Receipt":
                        begin
                            Rec.TestField(Amount);
                            BnkMgt.CreateCredReceiptLine(Rec, 0, "Transaction Options");
                        end;
                end;
                CalcAvailableBal;
            end;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                SavAcc: Record "Account Banking";
                FactP: Record "Product Factory";
            begin
                CheckRequiredItems;
                if Amount < 0 then
                    Error(ErrorOnNegatedValueTxt);
                CalcAvailableBal;
                if (Type = Type::"Credit Receipt") or (Type = Type::"Credit Cheque") then begin
                    CalcFields("Allocated Amount");
                    if Amount <> 0 then begin
                        if "Allocated Amount" > 0 then
                            Rec.TestField(Amount, "Allocated Amount");
                    end
                end;

                case "Document Type" of
                    "Document Type"::"Account Zerolizing":
                        begin
                            Account.Reset;
                            Account.SetRange("No.", "Account No.");
                            if Account.Find('-') then begin
                                Account.CalcFields(Account."Balance (LCY)", Balance);
                                if Amount >= Account."Balance (LCY)" then
                                    Amount := Account."Balance (LCY)"
                            end;

                        end;
                end;

                case Type of
                    Type::"Cash Withdrawal",
                    Type::"Bank Cheques":
                        begin

                            if FactP.Get("Product Type") then begin
                                if FactP."Account Validation" = FactP."Account Validation"::Signatories then begin

                                    SignInstruction.Reset();
                                    SignInstruction.SetRange("No.", Rec."No.");
                                    SignInstruction.DeleteAll();

                                    Signatories.Reset();
                                    Signatories.SetRange("Account No.", "Account No.");
                                    if Signatories.Find('-') then begin
                                        repeat
                                            if not Signatories.Picture.HasValue then
                                                Error('Signatory does not have a photo attached to it');
                                            if not Signatories.Signature.HasValue then
                                                Error('Signatory does not have a signature attached to it');

                                            SignInstruction.Init();
                                            SignInstruction."No." := Rec."No.";
                                            SignInstruction."Account No." := Signatories."Account No.";
                                            SignInstruction."Member No." := Signatories."Member No.";
                                            SignInstruction.Name := Signatories.Names;
                                            SignInstruction."ID No." := Signatories."ID No.";
                                            SignInstruction."Date of Birth" := Signatories."Date Of Birth";
                                            SignInstruction.Signatory := Signatories.Signatory;
                                            SignInstruction."Must be Present" := Signatories."Must be Present";
                                            SignInstruction."Must Sign" := Signatories."Must Sign";
                                            SignInstruction.Insert();

                                        until Signatories.Next() = 0;
                                    end else begin
                                        Error('This account has no signatories attached to it');
                                    end;
                                end
                            end;
                        end;
                end;

            end;
        }
        field(50014; "Cashier"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Cashier';
            DataClassification = CustomerContent;
        }
        field(50015; "Transaction Date"; Date)
        {
            Editable = false;
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50016; "Transaction Time"; Time)
        {
            Editable = false;
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(50017; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50018; "No. Series"; Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50019; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50020; "Cheque Type"; Code[20])
        {
            TableRelation = "Cheque Type";
            Caption = 'Cheque Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                WeekDay: Text;
            begin
                TestField(Amount);
                WeekDay := Format(WorkDate, 0, '<Weekday Text>');

                if ChequeTypes.Get("Cheque Type") then begin
                    if (ChequeTypes."Cheque Limit" <> 0) and (Amount > ChequeTypes."Cheque Limit") then
                        Error(Text0003, ChequeTypes."Cheque Limit");
                    CDays := ChequeTypes."Clearing  Days";
                    EMaturity := "Transaction Date";
                    if i < CDays then begin
                        repeat
                            EMaturity := CalcDate('1D', EMaturity);
                            if (Date2DWY(EMaturity, 1) <> 6) and (Date2DWY(EMaturity, 1) <> 7) then
                                i := i + 1;
                        until i = CDays;
                    end;
                    "Expected Maturity Date" := EMaturity;
                    if ChequeTypes."Clearing  Days" = 0 then
                        "Cheque Status" := "Cheque Status"::Honoured
                    else
                        "Cheque Status" := "Cheque Status"::Pending;
                end;
            end;
        }
        field(50021; "Cheque No"; Code[6])
        {
            Caption = 'Cheque No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                TellerTrans: Record "Teller Transaction";
                Err002: Label 'Cheque No. is already in use by No. %1';
            begin
                TellerTrans.Reset();
                TellerTrans.SetRange("Cheque No", "Cheque No");
                if TellerTrans.FindFirst() then
                    if TellerTrans."Cheque No" <> '' then
                        Error(Err002, "Cheque No");

            end;
        }
        field(50022; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CheqType: Record "Cheque Type";
                MinimumStaleChequeError: Label 'Cheque Date must not be more than %1';
            begin

                if "Cheque Date" > Today then
                    Error(ErrorInvalidDateTxt);

                if CheqType.Get("Cheque Type") then begin
                    CheqType.TestField(CheqType."Cheque Period");

                    if CalcDate(CheqType."Cheque Period", "Cheque Date") < Today then
                        Error(MinimumStaleChequeError, CheqType."Cheque Period");
                end;
            end;
        }
        field(50023; "Payee"; Text[100])
        {
            Caption = 'Payee';
            DataClassification = CustomerContent;
        }
        field(50024; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50025; "Type"; Enum "TellerTypes")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                case Type of
                    Type::"Credit Cheque":
                        begin

                            TestField("Account No.");
                            TestField("Member No.");
                            "Account Dimension" := "Account Dimension"::Prepayment;
                            RepaymentAccount.Reset;
                            RepaymentAccount.SetRange("Member No.", "Member No.");
                            if RepaymentAccount.FindFirst then
                                Validate("Account No.", RepaymentAccount."No.") else
                                Error(ErrorOnInvalidPrepaymentAcTxt);
                        end;
                end;
            end;
        }
        field(50026; "Transaction Description"; Text[100])
        {
            Caption = 'Transaction Description';
            DataClassification = CustomerContent;
        }
        field(50027; "Approval Status"; Enum "TellerTransactionOption")
        {
            DataClassification = CustomerContent;
        }
        field(50028; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50029; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50030; "Posted By"; Code[50])
        {
            Editable = false;
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50031; "Expected Maturity Date"; Date)
        {
            Editable = false;
            Caption = 'Expected Maturity Date';
            DataClassification = CustomerContent;
        }
        field(50032; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(50033; "Post Dated"; Boolean)
        {
            Caption = 'Post Dated';
            DataClassification = CustomerContent;
        }
        field(50034; "Book Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Book Balance';
            DataClassification = CustomerContent;
        }
        field(50035; "Overdraft"; Boolean)
        {
            Caption = 'Overdraft';
            DataClassification = CustomerContent;
        }
        field(50036; "Protected Account"; Boolean)
        {
            Caption = 'Protected Account';
            DataClassification = CustomerContent;
        }
        field(50037; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50038; "Banked By"; Code[50])
        {
            Caption = 'Banked By';
            DataClassification = CustomerContent;
        }
        field(50039; "Date Banked"; Date)
        {
            Caption = 'Date Banked';
            DataClassification = CustomerContent;
        }
        field(50040; "Time Banked"; Time)
        {
            Caption = 'Time Banked';
            DataClassification = CustomerContent;
        }
        field(50041; "Cleared By"; Code[50])
        {
            Caption = 'Cleared By';
            DataClassification = CustomerContent;
        }
        field(50042; "Date Cleared"; Date)
        {
            Caption = 'Date Cleared';
            DataClassification = CustomerContent;
        }
        field(50043; "Time Cleared"; Time)
        {
            Caption = 'Time Cleared';
            DataClassification = CustomerContent;
        }
        field(50044; "ID No"; Code[20])
        {
            Caption = 'ID No';
            DataClassification = CustomerContent;
        }
        field(50045; "Bank Account"; Code[20])
        {
            Editable = false;
            TableRelation = "Bank Account";
            Caption = 'Bank Account';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Validate("Cheque No");
                if BankAccount.Get("Bank Account") then
                    "Cheque Issueing Bank" := BankAccount.Name;
            end;
        }
        field(50046; "Printed"; Boolean)
        {
            Caption = 'Printed';
            DataClassification = CustomerContent;
        }
        field(50047; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50048; "Available Balance"; Decimal)
        {
            Caption = 'Available Balance';
            DataClassification = CustomerContent;
        }
        field(50049; "Attempted Self Transaction"; Boolean)
        {
            Caption = 'Attempted Self Transaction';
            DataClassification = CustomerContent;
        }
        field(50050; "Responsibility Centre"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50051; "Change Log"; Integer)
        {
            Caption = 'Change Log';
            DataClassification = CustomerContent;
        }
        field(50052; "Cheque Status"; Option)
        {
            OptionCaption = 'Pending,Stopped,Bounced,Honoured,Reversed';
            OptionMembers = "Pending","Stopped","Bounced","Honoured","Reversed";
            Caption = 'Cheque Status';
            DataClassification = CustomerContent;
        }
        field(50053; "Bankers Cheque No"; Code[6])
        {
            TableRelation = "Bankers Cheques Register"."Cheque No." WHERE(Status = FILTER(Pending),
                                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Code"));
            Caption = 'Bankers Cheque No';
            DataClassification = CustomerContent;
        }
        field(50054; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50055; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50056; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum("Cashier Transaction Line"."Total Amount" WHERE("Transaction No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Allocated Amount';
        }
        field(50057; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(50058; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Gen. Journal Template";
        }
        field(50059; "Cheque stopping Reasons"; Text[150])
        {
            Caption = 'Reasons-Cheque Cancelling';
            DataClassification = CustomerContent;
        }
        field(50060; "Transaction Options"; Enum "OptionsCreditReceipts")
        {
            Caption = 'Transaction Options-Credit Receipts';
            DataClassification = CustomerContent;
        }
        field(50061; "Document Type"; Option)
        {
            OptionMembers = "Teller Transactions","Account Zerolizing";
            DataClassification = CustomerContent;
        }
        field(50062; "External Document No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50063; "FingerPrint Verified"; Boolean)
        {
            Editable = false;
            Caption = 'FingerPrint Verified';
            DataClassification = CustomerContent;
        }
        field(50064; "SystemGeneratedGuid"; Guid)
        {
            Caption = 'SystemGeneratedGuid';
            DataClassification = CustomerContent;
        }
        field(50065; "Select"; Boolean)
        {
            Caption = 'Select';
            DataClassification = CustomerContent;
        }
        field(50066; "Discounting Amount"; Decimal)
        {
            Caption = 'Discounting Amount';
            DataClassification = CustomerContent;
        }
        field(50067; "Discounted Amount"; Decimal)
        {
            Caption = 'Discounted Amount';
            DataClassification = CustomerContent;
        }
        field(50068; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50069; "Signing Instructions"; Text[250])
        {
            Caption = 'Signing Instructions';
            DataClassification = CustomerContent;
        }
        field(50070; "Till Name"; Code[50])
        {
            Editable = false;
            Caption = 'Till Name';
            DataClassification = CustomerContent;
        }
        field(50071; "Product Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Product Category';
            DataClassification = CustomerContent;
        }
        field(50072; "Till Code"; Code[20])
        {
            Caption = 'Till Code';
            DataClassification = CustomerContent;
        }
        field(50073; "New Account Balance"; Decimal)
        {
            Caption = 'New Account Balance';
            DataClassification = CustomerContent;
        }
        field(50074; "Employer Code"; Code[20])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50075; "Dublicate"; Boolean)
        {
            Caption = 'Dublicate';
            DataClassification = CustomerContent;
        }
        field(50076; "Cheque Issueing Bank"; Text[100])
        {
            Editable = false;
            Caption = 'Cheque Issueing Bank';
            DataClassification = CustomerContent;
        }
        field(50077; "Drawee Bank Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Bank Code";
            Caption = 'Drawee Bank Code';
            DataClassification = CustomerContent;
        }
        field(50078; "Drawee Bank Branch"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Branch Code" where("Bank Code" = field("Drawee Bank Code"));
            Caption = 'Drawee Bank Branch';
            DataClassification = CustomerContent;
        }
        field(50079; "Account Dimension"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Savings,Prepayment';
            OptionMembers = "Savings","Prepayment";
            Caption = 'Account Dimension';
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('You cannot delete this transaction');
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Cashier Transaction Nos.");

        end;
        CheckRequiredItems;
    end;

    var
        NoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Account: Record "Account Banking";
        TransactionTypes: Record "Transaction Types";
        ChequeTypes: Record "Cheque Type";
        CDays: Integer;
        EMaturity: Date;
        i: Integer;
        UserSetup: Record "User Setup";
        TCharges: Decimal;
        TransactionCharges: Record "Transaction Charge";
        ChargeAmount: Decimal;
        TariffDetails: Record "Tiered Charges Line";
        Trans: Record "Teller Transaction";
        TChargeAmount: Decimal;
        RegMngt: Codeunit "Register Management";
        Signatories: Record "Account Signatories";
        GenSetup: Record "General Set-Up";
        AccountTypes: Record "Product Factory";
        TransType: Record "Transaction Types";
        BUserSetup: Record "Banking User Template";
        BankAcc: Record "Bank Account";
        Text0003: Label 'The cheque limit should not exceed the cheque amount limit of %1';
        BankAccount: Record "Bank Account";
        Temp: Record "Banking User Template";
        BnkMgt: Codeunit "Banking Procedure Mngt.";
        ErrorOnNegatedValueTxt: Label 'Amount cannot be less than zero.';
        ErrorInvalidDateTxt: Label 'Cheque Date cannot be greater than today.';
        RepaymentAccount: Record "Repayment Account";
        SignInstruction: Record "Signing Instructions";
        ErrorOnInvalidPrepaymentAcTxt: Label 'This Customer does not have a prepayment account for Credit Cheque depositing.';

    local procedure CalcAvailableBal()
    var
        MinBalance: Decimal;
        Account: Record "Account Banking";
        ProdType: Record "Product Factory";
    begin
        CalcCharges;
        "Available Balance" := 0;
        MinBalance := 0;

        if Account.Get("Account No.") then begin
            Account.CalcFields(Account.Balance, "Balance (LCY)", Account."Uncleared Cheques",
              Account."Authorised Over Draft", Account."Lien Placed", "ATM Transactions");
            ProdType.Reset;
            ProdType.SetRange(ProdType."Product ID", "Product Type");
            if ProdType.Find('-') then begin
                MinBalance := ProdType."Minimum Balance";

                case Type of
                    Type::"Account Zerolize":
                        begin
                            "Available Balance" := Account."Balance (LCY)";
                        end else begin
                        "Available Balance" := (Account.Balance + Account."Authorised Over Draft") - (MinBalance + Account."Uncleared Cheques" + TChargeAmount + Account."Lien Placed" + Account."ATM Transactions");
                    end;
                end;

                if Type = Type::"Cash Withdrawal" then
                    "New Account Balance" := "Available Balance" - Amount
                else
                    if Type = Type::"Cash Deposit" then
                        "New Account Balance" := "Available Balance" + Amount
                    else
                        if Type = Type::"Bankers Cheque" then
                            "New Account Balance" := "Available Balance" - Amount
            end;
        end;
    end;

    local procedure CalcCharges()
    begin

        GenSetup.Get;
        TChargeAmount := 0;
        TransactionCharges.Reset;
        TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
        if TransactionCharges.Find('-') then begin
            repeat
                ChargeAmount := 0;
                if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::Normal) or
                (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Stamp Duty") then begin
                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                        ChargeAmount := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                    else
                        ChargeAmount := TransactionCharges."Charge Amount";

                    if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                        TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                        TariffDetails.Reset;
                        TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                        if TariffDetails.Find('-') then begin
                            repeat
                                if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                    if TariffDetails."Use Percentage" = true then begin
                                        ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                    end else begin
                                        ChargeAmount := TariffDetails."Charge Amount";
                                    end;
                                end;
                            until TariffDetails.Next = 0;
                        end;
                    end;
                    TChargeAmount := TChargeAmount + ChargeAmount;
                    if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                        TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                        ;
                    end;
                end;
            until TransactionCharges.Next = 0;
        end;

        if Type = Type::"Cash Withdrawal" then begin
            if Account.Get("Account No.") then begin
                if AccountTypes.Get(Account."Product Type") then begin
                    if Account."Last Withdrawal Date" <> 0D then begin
                        if CalcDate(AccountTypes."Withdrawal Interval", Account."Last Withdrawal Date") > Today then begin
                            TransactionCharges.Reset;
                            TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
                            if TransactionCharges.Find('-') then begin
                                repeat
                                    if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Withdrawal Frequency") then begin
                                        ChargeAmount := 0;
                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                            ChargeAmount := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                                        else
                                            ChargeAmount := TransactionCharges."Charge Amount";
                                        if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                            TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");
                                            TariffDetails.Reset;
                                            TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                            if TariffDetails.Find('-') then begin
                                                repeat
                                                    if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                                        if TariffDetails."Use Percentage" = true then begin
                                                            ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                                        end else begin
                                                            ChargeAmount := TariffDetails."Charge Amount";
                                                        end;
                                                    end;
                                                until TariffDetails.Next = 0;
                                            end;
                                        end;
                                        TChargeAmount := TChargeAmount + ChargeAmount;
                                        if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                                            TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                                        end;
                                    end;
                                until TransactionCharges.Next = 0;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if Type = Type::"Cash Withdrawal" then begin
            if TransType.Get("Transaction Type") then begin

                Trans.Reset;
                Trans.SetRange(Trans."Transaction Date", Today);
                Trans.SetRange(Trans."Account No.", "Account No.");
                Trans.SetRange(Posted, true);
                Trans.SetRange(Trans.Type, Trans.Type::"Cash Withdrawal");
                if Trans.FindSet then begin
                    Trans.CalcSums(Trans.Amount);
                end;
            end;
            if Trans.Amount > TransType."Upper Limit" then begin

                TCharges := 0;

                TransactionCharges.Reset;
                TransactionCharges.SetRange(TransactionCharges."Transaction Type", "Transaction Type");
                if TransactionCharges.Find('-') then begin
                    repeat
                        if (TransactionCharges."Transaction Charge Category" = TransactionCharges."Transaction Charge Category"::"Withdrawn Amount") then begin
                            ChargeAmount := 0;
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::"% of Amount" = true then
                                ChargeAmount := (Amount * TransactionCharges."Percentage of Amount") * 0.01
                            else
                                ChargeAmount := TransactionCharges."Charge Amount";
                            if TransactionCharges."Charge Type" = TransactionCharges."Charge Type"::Staggered then begin
                                TransactionCharges.TestField(TransactionCharges."Staggered Charge Code");

                                TariffDetails.Reset;
                                TariffDetails.SetRange(TariffDetails.Code, TransactionCharges."Staggered Charge Code");
                                if TariffDetails.Find('-') then begin
                                    repeat
                                        if (Amount >= TariffDetails."Lower Limit") and (Amount <= TariffDetails."Upper Limit") then begin
                                            if TariffDetails."Use Percentage" = true then begin
                                                ChargeAmount := Amount * TariffDetails.Percentage * 0.01;
                                            end else begin
                                                ChargeAmount := TariffDetails."Charge Amount";
                                            end;
                                        end;
                                    until TariffDetails.Next = 0;
                                end;
                            end;
                            TChargeAmount := TChargeAmount + ChargeAmount;
                            if TransactionCharges."Transaction Charge Category" <> TransactionCharges."Transaction Charge Category"::"Stamp Duty" then begin
                                TChargeAmount := TChargeAmount + (ChargeAmount * GenSetup."Excise Duty (%)") * 0.01;
                            end;
                        end;
                    until TransactionCharges.Next = 0;
                end;
            end;
        end;
    end;


    procedure CheckRequiredItems()
    begin

        UserSetup.Get(UserId);
        UserSetup.TestField(UserSetup."Global Dimension 1 Code");
        UserSetup.TestField(UserSetup."Global Dimension 2 Code");
        UserSetup.TestField(UserSetup."Responsibility Centre");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Centre" := UserSetup."Responsibility Centre";
        Cashier := UpperCase(UserId);
        "Transaction Date" := Today;
        "Transaction Time" := Time;

        Temp.Get(UserId);
        Temp.TestField("Cashier Journal Template");
        Temp.TestField("Cashier Journal Batch");

        case Temp.Type of

            Temp.Type::Cashier,
            Temp.Type::Receipts,
            Temp.Type::Treasury:
                begin

                    Temp.TestField("Default  Bank");
                    Temp.TestField("Excess Account");
                    Temp.TestField("Shortage Account");
                    Temp.TESTFIELD("Account No.");
                    Temp.TestField(Type, Temp.Type::Cashier);
                    Rec."Journal Template Name" := Temp."Cashier Journal Template";
                    Rec."Journal Batch Name" := Temp."Cashier Journal Batch";

                    BUserSetup.Reset;
                    BUserSetup.SetRange(BUserSetup."Account ID", UserId);
                    if BUserSetup.Find('-') then begin
                        BUserSetup.TestField("Default  Bank");
                        "Till Code" := BUserSetup."Default  Bank";
                        BankAcc.Reset;
                        BankAcc.SetRange("No.", BUserSetup."Default  Bank");
                        if BankAcc.Find('-') then begin
                            "Till Name" := PadStr(BUserSetup."Default  Bank" + ' ' + BankAcc.Name, 50)
                        end;
                    end;
                end;
        end;
    end;
}




