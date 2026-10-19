table 50365 "Account Application"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(50011; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50013; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50014; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        }
        field(50015; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50016; "Comment"; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Blocked"; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ","Credit","Debit","All";
            DataClassification = CustomerContent;
        }
        field(50018; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50020; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50021; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50022; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50023; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            DataClassification = CustomerContent;
        }
        field(50024; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50025; "Group Account No"; Code[20])
        {
            Caption = 'Group Account No';
            DataClassification = CustomerContent;
        }
        field(50026; "Group Account"; Boolean)
        {
            Caption = 'Group Account';
            DataClassification = CustomerContent;
        }
        field(50027; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory" WHERE("Product Class" = CONST(Account),
                                                     Status = CONST(Active), "Auto Open Account" = const(false));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ProductApplicationDocuments: Record "Product Documents";
                ApplicationDocuments: Record "Application Documents";
                SigApp: Record "Signatory Application";
                CustRecord: Record Member;
            begin

                fnValidateMultipleAccountCreation;
                if ProductFactory.Get("Product Type") then begin
                    if ProductFactory."Account Category" <> ProductFactory."Account Category"::Junior then
                        ProductFactory.TestField("Minimum Balance");
                    if ProductFactory."Source Account" = ProductFactory."Source Account"::Member then begin
                        //TestField("Member No.");
                        MemberNoEditable := true;
                    end else begin
                        MemberNoEditable := false
                    end;
                    "Product Name" := ProductFactory.Description;
                    "Customer Posting Group" := ProductFactory."Posting Group";
                    "Account Type" := ProductFactory."Account Category";
                    "Account Source" := ProductFactory."Account Dimension";
                    if "Account Type" = "Account Type"::"Certificates of Deposit" then begin
                        SavingsAccount.Reset;
                        SavingsAccount.SetRange("Member No.", "Member No.");
                        SavingsAccount.SetRange("Loan Disbursement Account", true);
                        if SavingsAccount.Find('-') then begin
                            SavingsAccount.CalcFields("Balance (LCY)");
                            if (SavingsAccount."Balance (LCY)" = 0) or (SavingsAccount."Balance (LCY)" < ProductFactory."Minimum Balance") then
                                Error('No enough balance in your account to facilitate this account creation');
                            "Savings Account No." := SavingsAccount."No.";
                        end
                    end;
                    if "Account Type" = "Account Type"::Junior then begin
                        if CustRecord.Get("Member No.") then begin
                            Name := '';
                            "Date of Birth" := 0D;

                            SigApp.Reset();
                            SigApp.SetRange("Account No.", "No.");
                            if SigApp.Find('-') then
                                SigApp.Delete();
                            getsigapplication("No.", CustRecord);
                        end;
                    end;
                end;
            end;
        }
        field(50028; "Product Name"; Text[50])
        {
            Editable = false;
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50029; "Fixed Deposit Status"; Option)
        {
            OptionCaption = ' ,Active,Matured,Closed,Not Matured';
            OptionMembers = " ","Active","Matured","Closed","Not Matured";
            Caption = 'Fixed Deposit Status';
            DataClassification = CustomerContent;
        }
        field(50030; "Birth Certificate No."; Code[20])
        {
            Caption = 'Birth Certificate No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Birth Certificate No." <> '' then begin
                    SavingsAccounts.Reset;
                    SavingsAccounts.SetRange("Birth Certificate No.", "Birth Certificate No.");
                    if SavingsAccounts.FindFirst then
                        Error(
                       AccountExistsError,
                       SavingsAccounts."No.",
                       SavingsAccounts.Name);
                end;
            end;
        }
        field(50031; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50032; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            DataClassification = CustomerContent;
        }
        field(50033; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(50034; "FD Marked for Closure"; Boolean)
        {
            Caption = 'FD Marked for Closure';
            DataClassification = CustomerContent;
        }
        field(50035; "Expected Maturity Date"; Date)
        {
            Caption = 'Expected Maturity Date';
            DataClassification = CustomerContent;
        }
        field(50036; "Savings Account No."; Code[20])
        {
            TableRelation = "Account Banking";
            Caption = 'Savings Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50037; "Parent Account No."; Code[20])
        {
            Caption = 'Parent Account No.';
            DataClassification = CustomerContent;
        }
        field(50038; "Fixed Deposit Type"; Code[20])
        {
            TableRelation = "Fixed Deposit Type" WHERE(Blocked = CONST(false));
            Caption = 'Fixed Deposit Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Application Date");
                if FixedDepositType.Get("Fixed Deposit Type") then begin
                    "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "Application Date");
                    "FD Duration" := FixedDepositType.Duration;
                    Validate("FD Duration");
                    "Account Type" := "Account Type"::"Certificates of Deposit";
                end;
            end;
        }
        field(50039; "FD Maturity Date"; Date)
        {
            Caption = 'FD Maturity Date';
            DataClassification = CustomerContent;
        }
        field(50040; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
            end;
        }
        field(50041; "Account Type"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50042; "Negotiated Interest Rate"; Decimal)
        {
            Editable = false;
            Caption = 'Negotiated Interest Rate';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                FDTypes: Record "Fixed Deposit Type";
            begin
                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if ("Fixed Deposit Amount" >= FDCalcRules."Minimum Amount") and
                              ("Fixed Deposit Amount" <= FDCalcRules."Maximum Amount") then
                                if ("Negotiated Interest Rate" > (FDCalcRules."Interest Rate" + FDCalcRules."Allowed Margin")) or
                                   ("Negotiated Interest Rate" < (FDCalcRules."Interest Rate" - FDCalcRules."Allowed Margin")) then
                                    Error(ErrorOnNegInt, FDCalcRules."Allowed Margin");
                        end;
                    until FDCalcRules.Next = 0;
                end;
            end;
        }
        field(50043; "FD Duration"; DateFormula)
        {
            Caption = 'FD Duration';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "FD Maturity Date" := CalcDate("FD Duration", "Application Date");
            end;
        }
        field(50044; "FD Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Transfer all to Savings,Renew Principal,Renew Principal & Interest';
            OptionMembers = " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest";
            Caption = 'FD Maturity Instructions';
            DataClassification = CustomerContent;
        }
        field(50045; "Fixed Deposit Cert. No."; Code[30])
        {
            Caption = 'Fixed Deposit Cert. No.';
            DataClassification = CustomerContent;
        }
        field(50046; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Microfinance';
            OptionMembers = " ","Welfare","Microfinance";
            Caption = 'Group Type';
            DataClassification = CustomerContent;
        }
        field(50047; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Application Date", Today);
            end;
        }
        field(50048; "Application Source"; Option)
        {
            OptionCaption = ' ,Navision,CRM,Web,Mobile';
            OptionMembers = " ","Navision","CRM","Web","Mobile";
            Caption = 'Application Source';
            DataClassification = CustomerContent;
        }
        field(50049; "Fixed Deposit Amount"; Decimal)
        {
            Caption = 'Fixed Deposit Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if ("Fixed Deposit Amount" <= FDCalcRules."Minimum Amount") and ("Fixed Deposit Amount" >= FDCalcRules."Maximum Amount") then
                                Error(ErrorOnFDamountMarginTxt);
                        end;
                    until FDCalcRules.Next = 0;
                end;


                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if ("Fixed Deposit Amount" >= FDCalcRules."Minimum Amount") and ("Fixed Deposit Amount" <= FDCalcRules."Maximum Amount") then
                                "Negotiated Interest Rate" := FDCalcRules."Interest Rate";
                        end;
                    until FDCalcRules.Next = 0;
                end;

                SavingsAccount.Reset;
                SavingsAccount.SetRange("Member No.", "Member No.");
                SavingsAccount.SetRange("Loan Disbursement Account", true);
                if SavingsAccount.Find('-') then
                    SavingsAccount.CalcFields("Balance (LCY)");
                if "Fixed Deposit Amount" > SavingsAccount."Balance (LCY)" then
                    Error(ErrorOnFDamountMarginTxt);

            end;
        }
        field(50050; "Remarks"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(50051; "Member No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Document Type" = filter("New Account")) Member."No." where(Status = filter(Active| New)) else
            if ("Document Type" = filter("Kin Details")) Member."No." where(Status = filter(Active | Deceased));
            Caption = 'Member No.';
        
            trigger OnValidate()
            begin
                if Cust.Get("Member No.") then begin

                    if "Document Type" <> "Document Type"::"Kin Details" then
                        Name := Cust.Name;
                    "Group Account No" := Cust."Group Account No.";
                    "Group Account" := Cust."Group Account";
                    "Date of Birth" := Cust."Date of Birth"
                end;

            end;
        }
        field(50052; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        
            trigger OnValidate()
            var
                GeneralSetUp: Record "General Set-Up";
                MinimumAgeError: Label 'Date of birth must not be more than %1';
                Prod: Record "Product Factory";
            begin

                if "Date of Birth" >= Today then
                    Error('Date cannot be today or greater than today');
                GeneralSetUp.Get();
                if Prod.Get("Product Type") then
                    if Prod."Source Account" = Prod."Source Account"::Member then
                        if CalcDate(GeneralSetUp."Min. Member Age", "Date of Birth") < Today then begin
                            Error(MinimumAgeError, GeneralSetUp."Min. Member Age");
                        end;

            end;
        }
        field(50053; "Account Source"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Source';
        }
        field(50054; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50055; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50056; "CRM Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "CRM Application"."No." WHERE("Application Type" = CONST(Account),
                                                           "Approval Status" = FILTER(Deffered | Open),
                                                           Created = CONST(false));
            Caption = 'CRM Application No.';
        
            trigger OnValidate()
            begin
                Varvariant := Rec;
                RegistryMngt.ApplicationRegistration(Varvariant, 0)
            end;
        }
        field(50057; "Transaction Type"; Code[10])
        {
            TableRelation = "Transaction Types".Code where(Blocked = const(false));
        }
        field(50058; "ID No."; Code[50])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Cred: Record "Account Banking";
            begin
                if "ID No." <> '' then begin
                    Cred.Reset;
                    Cred.SetRange("ID/Passport No.", "ID No.");
                    if Cred.FindFirst then begin
                        Error(MemberExistError, "ID No.", Cred."No.", Cred.Name);
                    end;
                end;
            end;
        }
        field(50059; "Signing Mandates"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50060; "Mobile Phone"; Code[50])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Cred: Record "Account Banking";
            begin
                if "Mobile Phone" <> '' then begin
                    Cred.Reset;
                    Cred.SetRange("Mobile No.", "Mobile Phone");
                    if Cred.FindFirst then begin
                        Error(MemberExistError, "Mobile Phone", Cred."No.", Cred.Name);
                    end;
                end;
            end;
        }
        field(50061; "E-Mail"; Text[50])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
                Cred: Record "Account Banking";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
                if "E-Mail" <> '' then begin
                    Cred.Reset;
                    Cred.SetRange("E-Mail", "E-Mail");
                    if Cred.FindFirst then begin
                        Error(MemberExistError, "E-Mail", Cred."No.", Cred.Name);
                    end;
                end;
            end;
        }
        field(50062; "Nationality"; Code[20])
        {
            TableRelation = "Country/Region".Code;
            ValidateTableRelation = false;
            Caption = 'Nationality';
            DataClassification = CustomerContent;
        }

        field(50063; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", "Country/Region", Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50064; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
            TableRelation = if ("Country/Region" = const()) "Post Code".City
            else
            if ("Country/Region" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region"));
            ValidateTableRelation = false;
        
            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", "Country/Region", Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50065; "Country/Region"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Country/Region';
            TableRelation = "Country/Region";
        
            trigger OnValidate()
            var
                CountryCode: Record "Country/Region";
            begin
                if CountryCode.Get("Country/Region") then
                    "Mobile Phone" := CountryCode."Intrastat Code";
            end;
        }
        field(50066; "Current Address"; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(50067; "Application Type"; Option)
        {
            OptionMembers = "Account Application","Account Changes";
            DataClassification = CustomerContent;
        }
        field(50068; "Account No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50069; "Kin Account No."; Text[250])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Document Type" = filter("Kin Details")) "Next of KIN".Name where("Account No" = field("Member No."));
        
            trigger OnValidate()
            var
                Applic: Record "Account Application";
            begin
                TestField("Member No.");
                TestField("Product Type");
                TestField("Document Type", "Document Type"::"Kin Details");
                KinDetail.Reset();
                KinDetail.SetRange(Name, "Kin Account No.");
                if KinDetail.FindFirst() then begin
                    Name := KinDetail.Name;
                    "Date of Birth" := KinDetail."Date of Birth";
                    "Birth Certificate No." := KinDetail."ID No.";
                end;

                Applic.Reset();
                Applic.SetRange("Kin Account No.", "Kin Account No.");
                if Applic.FindFirst() then begin
                    if Applic."No." <> "No." then
                        Error(ErrorOnexistingApp, Applic."Kin Account No.");
                end;
            end;
        }
        field(50070; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "New Account","Kin Details";
        }
        field(50071; "Bank Account Source"; Option)
        {
            Editable = false;
            OptionMembers = "Member","Account","Credit";
            DataClassification = CustomerContent;
        }
        field(50072; "Changes Type"; Enum "AccountChangesTypes")
        {
            DataClassification = CustomerContent;
            Caption = 'Changes Type';
        }
        field(50073; "Response"; Integer)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                case Response of
                    1:
                        "Changes Type" := "Changes Type"::"Membership Details";
                    2:
                        "Changes Type" := "Changes Type"::Images;
                    3:
                        "Changes Type" := "Changes Type"::"Bank Account";
                end;
            end;
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

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField("Accounts Application");
            "No. Series" := SeriesSetup."Accounts Application";
            if NoSeriesMgt.AreRelated(SeriesSetup."Accounts Application", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        "Application Date" := Today;
        "Created By" := UserId;

        UserSetup.Get(UserId);
        UserSetup.TestField(UserSetup."Global Dimension 1 Code");
        UserSetup.TestField(UserSetup."Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");

        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Center" := UserSetup."Responsibility Centre";
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Cust: Record Member;
        ProductFactory: Record "Product Factory";
        FixedDepositType: Record "Fixed Deposit Type";
        KinDetail: Record "Next of KIN";
        MemberExistError: Label '%1 Already exists with member %2 Name: %3';
        UserSetup: Record "User Setup";
        SavingsAccounts: Record "Account Banking";
        AccountExistsError: Label 'Applicant already has a similar Account No.%1 Name %2 .';
        FDCalcRules: Record "FD Interest Calculation Rules";
        SavingsAccount: Record "Account Banking";
        CredAccount: Record "Account Credit";
        RepayAccount: Record "Repayment Account";
        ErrorOnexistingApp: Label 'Application with %1 already exists';
        ErrorOnNegInt: Label 'The negotiated rate must be within the allowed margin of %1';
        ErrorOnFDamountMarginTxt: Label 'The Fixed Deposit amount must be within the allowed margin.';
        RegistryMngt: Codeunit "Registry Mngt.";
        PostCode: Record "Post Code";
        Varvariant: Variant;



    procedure fnValidateMultipleAccountCreation()
    var
        AllowMultipleAcntError: Label 'Applicant already has %1, Kindly ensure this product allows multiple account creations to proceed.';
    begin
        if ProductFactory.Get("Product Type") then begin

            case ProductFactory."Account Dimension" of
                ProductFactory."Account Dimension"::Banking:
                    begin

                        SavingsAccounts.Reset;
                        SavingsAccounts.SetRange("Member No.", "Member No.");
                        SavingsAccounts.SetRange("Product Type", "Product Type");
                        if SavingsAccounts.Find('-') then begin
                            if not ProductFactory."Allow Multiple Accounts" then
                                if SavingsAccounts.Count >= 1 then
                                    Error(AllowMultipleAcntError, SavingsAccounts."Product Name");
                        end;
                    end;

                ProductFactory."Account Dimension"::Credit:
                    begin
                        CredAccount.Reset;
                        CredAccount.SetRange("Member No.", "Member No.");
                        CredAccount.SetRange("Product Type", "Product Type");
                        if CredAccount.Find('-') then begin
                            if not ProductFactory."Allow Multiple Accounts" then
                                if CredAccount.Count >= 1 then
                                    Error(AllowMultipleAcntError, CredAccount."Product Name");
                        end;
                    end;
                ProductFactory."Account Dimension"::Repayment:
                    begin
                        RepayAccount.Reset;
                        RepayAccount.SetRange("Member No.", "Member No.");
                        RepayAccount.SetRange("Product Type", "Product Type");
                        if RepayAccount.Find('-') then begin
                            if not ProductFactory."Allow Multiple Accounts" then
                                if RepayAccount.Count >= 1 then
                                    Error(AllowMultipleAcntError, RepayAccount."Product Name");
                        end;
                    end
            end
        end;
    end;


    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;

    local procedure fnCheckValidCharacters(CodeNo: Code[10]) StringTxt: Code[10]
    begin
        StringTxt := DelChr(CodeNo, '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?');
    end;


    procedure fnCheckDetails()
    ProdFact: Record "Product Factory";
    var
        SignatoryApplication: Record "Signatory Application";
    begin
        if ProdFact.Get("Product Type") then
            TestField(Name);
        TestField("Product Type");
        TestField("Global Dimension 1 Code");
        TestField("Global Dimension 2 Code");
        TestField("Responsibility Center");
        if ProdFact."Source Account" = ProdFact."Source Account"::Member then begin
            TestField("Member No.");
        end else begin
            TestField("ID No.");
            TestField("Mobile Phone");
            TestField("Date of Birth");
            TestField("Post Code");
            TestField("Country/Region");
            TestField(Nationality);
            TestField("E-Mail");
            TestField("Current Address");
            TestField("Signing Mandates");
            SignatoryApplication.Reset;
            SignatoryApplication.SetRange("Account No.", Rec."No.");
            if not SignatoryApplication.Find('-') then begin
                Error('No signatories attached to this account.');
            end;


            SignatoryApplication.Reset;
            SignatoryApplication.SetRange("Account No.", Rec."No.");
            if SignatoryApplication.Find('-') then begin
                repeat
                    SignatoryApplication.TestField(Names);
                    SignatoryApplication.TestField("ID No.");
                    SignatoryApplication.TestField(Type);
                    SignatoryApplication.TestField("Date Of Birth");
                    if SignatoryApplication."Signatory Category" = SignatoryApplication."Signatory Category"::Member then
                        SignatoryApplication.TestField("Member No.");
                    SignatoryApplication.TestField("Pin No.");
                    SignatoryApplication.TestField(Picture);
                    SignatoryApplication.TestField(Signature);
                until SignatoryApplication.Next() = 0
            end;
        end;

        if ProductFactory.Get("Product Type") then begin

            case ProductFactory."Account Category" of
                ProductFactory."Account Category"::"Shares Capital",
                ProductFactory."Account Category"::"Shares Deposit":
                    begin
                        TestField("Monthly Contribution");
                    end;
                ProductFactory."Account Category"::Junior:
                    begin
                        TestField("Date of Birth");
                        TestField("Parent Account No.");
                        TestField("Birth Certificate No.");
                    end;
                ProductFactory."Account Category"::"Certificates of Deposit":
                    begin
                        TestField("FD Duration");
                        TestField("FD Maturity Date");
                        TestField("FD Maturity Instructions");
                        TestField("Fixed Deposit Amount");
                        TestField("Fixed Deposit Type");
                        TestField("Negotiated Interest Rate");
                        TestField("Savings Account No.");

                        SavingsAccount.Reset;
                        SavingsAccount.SetRange("Member No.", "Member No.");
                        SavingsAccount.SetRange("Account Category", SavingsAccount."Account Category"::Savings);
                        if SavingsAccount.Find('-') then
                            SavingsAccount.CalcFields("Balance (LCY)");
                        if "Fixed Deposit Amount" > SavingsAccount."Balance (LCY)" then
                            Error(ErrorOnFDamountMarginTxt);
                    end;
            end;
        end
    end;

    local procedure getsigapplication(AppNo: Code[50]; Cust: Record Member)
    var
        AccSignatory: Record "Signatory Application";
        ImageData: Record "Image Data";
    begin
        AccSignatory.Init();
        AccSignatory."Account No." := AppNo;
        AccSignatory."Member No." := Cust."No.";
        AccSignatory.Address := Cust."Current Address";
        AccSignatory.Names := Cust.Name;
        AccSignatory."Staff/Payroll" := Cust."Payroll/Staff No.";
        AccSignatory."Must be Present" := true;
        AccSignatory."Must Sign" := true;
        AccSignatory."Date Of Birth" := Cust."Date of Birth";
        AccSignatory.City := Cust.City;
        AccSignatory."ID No." := Cust."ID No.";
        AccSignatory."Passport No." := Cust."Passport No.";
        AccSignatory.Gender := Cust.Gender;
        AccSignatory.Nationality := Cust.Nationality;
        AccSignatory.City := Cust.City;
        AccSignatory."Post Code" := Cust."Post Code";
        AccSignatory."Pin No." := Cust."PIN No.";
        AccSignatory.Signatory := true;

        ImageData.Reset();
        ImageData.SetRange("Member No.", Cust."No.");
        if ImageData.FindFirst() then begin
            AccSignatory.Picture := ImageData.Picture;
            AccSignatory.Signature := ImageData.Signature;
        end;

        AccSignatory.Insert(true);
    end;

    procedure CopyFromAccountBanking(AccBanking: Record "Account banking")
    begin
        "Member No." := AccBanking."Member No.";
        Name := AccBanking.Name;
        Validate("Product Type", AccBanking."Product Type");
        "Date of Birth" := AccBanking."Date of Birth";
        "Birth Certificate No." := AccBanking."Birth Certificate No.";
    end;

    procedure PostAccountChange(Acc: Code[100])
    var
        BankingRec: Record "Account Banking";
        RecRef: Record "Account Application";
    begin
        if Confirm('Are you sure you want to Post this application?', true) = false then exit;
        if RecRef.Get("No.") then begin

            BankingRec.Reset();
            BankingRec.SetRange("No.", Acc);
            if BankingRec.FindFirst() then begin
                if BankingRec.Name <> Name then
                    BankingRec.Validate(Name, Name);
                if BankingRec."Date of Birth" <> "Date of Birth" then
                    BankingRec.Validate("Date of Birth", "Date of Birth");
                if BankingRec."Birth Certificate No." <> "Birth Certificate No." then
                    BankingRec.Validate("Birth Certificate No.", "Birth Certificate No.");
                BankingRec.Modify(true)
            end;
            RecRef."Approval Status" := RecRef."Approval Status"::Posted;
            RecRef."Posted By" := UserId;
            RecRef."Date Posted" := CurrentDateTime;
            RecRef.Modify(true)
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRef: Record "Account Application";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRef.Get(Rec."No.") then begin
                SeriesSetup.Get();
                NoSeriesMgt.TestManual(SeriesSetup."Accounts Application");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Account Application"; xRecRef: Record "Account Application"; var IsHandled: Boolean)
    begin
    end;

    var
        MemberNoEditable: Boolean;
}




