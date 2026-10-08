table 50413 "Member Changes"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Name"; Text[80])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                NameBreakdown
            end;
        }
        field(50011; "Member No."; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Changes Type" = filter("Membership Details")) Member."No." where(Status = filter(<> Withdrawn)) else
            if ("Changes Type" = filter("Account Activation")) Member."No." where(Status = filter(New | Closed | Dormant | Active)) else
            if ("Changes Type" = filter("Account Deactivation")) Member."No." where(Blocked = filter(All)) else
            if
            ("Changes Type" = filter("Block Account" | "Deceased Account")) Member."No." where(Status = filter(<> Withdrawn));
            Caption = 'Member No.';
        
            trigger OnValidate()
            var
                MngtRegt: Codeunit "Registry Mngt.";
                Cust: Record Member;
            begin
                if "Changes Type" = "Changes Type"::Readmission then begin
                    if Cust.Get("Member No.") then
                        MngtRegt.fnCustomerEntries(Cust, 7);
                end;
            end;
        }
        field(50012; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(50013; "Current Address"; Text[50])
        {
            Caption = 'Current Address';
            DataClassification = CustomerContent;
        }
        field(50014; "Home Address"; Text[50])
        {
            Caption = 'Home Address';
            DataClassification = CustomerContent;
        }
        field(50015; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(50016; "Contact"; Text[50])
        {
            Caption = 'Contact';
            DataClassification = CustomerContent;
        }
        field(50017; "Phone No."; Text[80])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
        field(50018; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            DataClassification = CustomerContent;
            TableRelation = Territory;
        }
        field(50021; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50022; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50023; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
            TableRelation = if ("Recruited By Type" = const(Marketer)) "Salesperson/Purchaser".Code else
            if
            ("Recruited By Type" = const(Member)) Member."No." else
            if ("Recruited By Type" = const(Others)) Customer."No.";
        }
        field(50024; "Nationality"; Code[10])
        {
            Caption = 'Nationality';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(50025; "Comment"; Text[30])
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(50026; "Blocked"; Option)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ","Credit","Debit","All";
        }
        field(50027; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50028; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(50029; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(50030; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            ValidateTableRelation = false;
        }
        field(50031; "County"; Code[30])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(50032; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(50033; "Current Location"; Text[80])
        {
            Caption = 'Home Page';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(50034; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50035; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
        }
        field(50036; "Customer Type"; Enum "CreditCustomerType")
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Type';
        }
        field(50037; "Registration Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Registration Date';
        }
        field(50038; "Status"; Enum "MemberStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(50039; "Employer Code"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Employer Code';
        }
        field(50040; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
            end;
        }
        field(50041; "Location"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Location';
        }
        field(50042; "Resons for Status Change"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Resons for Status Change';
        }
        field(50043; "Payroll/Staff No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll/Staff No.';
        }
        field(50044; "ID No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'ID No.';
        }
        field(50045; "Mobile Phone No"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Mobile Phone No';
        }
        field(50046; "Marital Status"; Enum "MaritalStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Marital Status';
        }
        field(50047; "Passport No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Passport No.';
        }
        field(50048; "Gender"; Enum "CustGender")
        {
            DataClassification = CustomerContent;
            Caption = 'Gender';
        }
        field(50049; "First Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'First Name';
        }
        field(50050; "Office Telephone No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Office Telephone No.';
        }
        field(50051; "Account Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Member,Staff Members,Board Members,Delegates';
            OptionMembers = "Member","Staff Members","Board Members","Delegates";
            Caption = 'Account Category';
        }
        field(50052; "MPESA Mobile No"; Code[20])
        {
            CharAllowed = '0123456789';
            DataClassification = CustomerContent;
            Caption = 'MPESA Mobile No';
        }
        field(50053; "Group Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Account No.';
        }
        field(50054; "Group Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Group Account';
            TableRelation = Member where("Group Account" = const(true));
        }
        field(50055; "Second Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Second Name';
        }
        field(50056; "Last Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Name';
        }
        field(50057; "Employment/Occupation Detail"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Employment/Occupation Detail';
        }
        field(50058; "Employers Postal Address"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Employers Postal Address';
        }
        field(50059; "Member Segment"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = filter(Contract | Permanent | Pension | Staff | "Board Member" | "Early Retirement"));
            Caption = 'Member Segment';
        }
        field(50060; "Membership Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Ordinary,Preferential';
            OptionMembers = " ","Ordinary","Preferential";
            Caption = 'Membership Type';
        }
        field(50061; "Account Type"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
        field(50062; "Relates to Business/Group"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Relates to Business/Group';
        }
        field(50063; "Type of Business"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Sole Proprietor,Paerneship,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor","Paerneship","Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
            Caption = 'Type of Business';
        }
        field(50064; "Other Business Type"; Text[15])
        {
            DataClassification = CustomerContent;
            Caption = 'Other Business Type';
        }
        field(50065; "Ownership Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares";
            Caption = 'Ownership Type';
        }
        field(50066; "Other Account Type"; Text[15])
        {
            DataClassification = CustomerContent;
            Caption = 'Other Account Type';
        }
        field(50067; "Nature of Business"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Nature of Business';
        }
        field(50068; "Company Registration No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Company Registration No.';
        }
        field(50069; "Date of Business Reg."; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Business Reg.';
        }
        field(50070; "Business/Group Location"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Business/Group Location';
        }
        field(50071; "Plot/Bldg/Street/Road"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Plot/Bldg/Street/Road';
        }
        field(50072; "Group Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Welfare,Microfinance';
            OptionMembers = " ","Welfare","Microfinance";
            Caption = 'Group Type';
        }
        field(50073; "Single Party/Multiple"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = "Single","Multiple","Business";
            Caption = 'Single Party/Multiple';
        }
        field(50074; "Birth Certificate No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Birth Certificate No.';
        }
        field(50075; "Current Residence"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Current Residence';
        }
        field(50076; "Protected Account"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Protected Account';
        }
        field(50077; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(50078; "Bank Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Code Structure";
            Caption = 'Bank Code';
        }
        field(50079; "Branch Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
            Caption = 'Branch Code';
        }
        field(50080; "Bank Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.';
        }
        field(50081; "PIN No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PIN No.';
        }
        field(50082; "Source"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Navision,CRM,Web';
            OptionMembers = " ","Navision","CRM","Web";
            Caption = 'Source';
        }
        field(50083; "Application No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50084; "Member Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Ordinary,Preferential';
            OptionMembers = "Ordinary","Preferential";
            Caption = 'Member Type';
        }
        field(50085; "Member Category"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Member Category";
            Caption = 'Member Category';
        }
        field(50086; "Recruited By Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Marketer,Member,Others';
            OptionMembers = "Marketer","Member","Others";
            Caption = 'Recruited By Type';
        }
        field(50108; "Relationship Manager"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Relationship Manager';
        }
        field(50109; "Contract Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Permanent,Internship,Contract,Casual,Consultancy';
            OptionMembers = "Permanent","Internship","Contract","Casual","Consultancy";
            Caption = 'Contract Type';
        }
        field(50110; "Classification"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
            Caption = 'Classification';
        }
        field(50111; "Electrol Zone"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Electral Zone"));
            Caption = 'Electrol Zone';
        }
        field(50112; "Salutation"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
            Caption = 'Salutation';
        }
        field(50113; "Member Station"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Member Station';
        }
        field(50114; "Pay Point"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                Cusr: Record Customer;
            begin
            end;
        }
        field(50115; "Designation"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Designation';
        }
        field(50116; "Station/Department"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
            Caption = 'Station/Department';
        }
        field(50117; "Witness"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Member;
            Caption = 'Witness';
        }
        field(50118; "Application Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Application Date';
        }
        field(50119; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Approval Status';
        }
        field(50120; "Picture"; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'Picture';
        }
        field(50121; "Signature"; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'Signature';
        }
        field(50122; "Changes Type"; Enum "AccountChangesTypes")
        {
            DataClassification = CustomerContent;
            Caption = 'Changes Type';
        
            trigger OnValidate()
            begin
                if "Changes Type" = "Changes Type"::"Deceased Account" then begin
                    "Operation Type" := "Operation Type"::"All Accounts";
                    "Account Category" := "Account Category"::Member;
                    "Account Type" := "Account Type"::" ";
                end;

            end;
        }
        field(50123; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50124; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50125; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionMembers = "Member Change","Account Activation","Kin Signatories","Card Link";
        }
        field(50087; "Product Type"; Enum "ProductAccountCategory")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Category';
        }
        field(50088; "Operation Type"; Option)
        {
            Caption = 'Operation Type';
            OptionCaption = ' ,All Accounts, Single Account';
            OptionMembers = "","All Accounts","Single Account";
        }
        field(50089; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const(Banking),
            "Changes Type" = const("Account Activation"))
            "Account Banking" where(Status = filter(Withdrawn | Closed | Frozen | New | Dormant),
            "Member No." = field("Member No."), "Account Category" = field("Product Type"))
            else
            if ("Account Type" = const(Banking), "Changes Type" = const("Card Link"))
            "Account Banking" where(Status = filter(Active), "Member No." = field("Member No."), "Account Category" = const(Savings)) else
            if
            ("Account Type" = const(Banking), "Changes Type" = filter("Block Account" | "Account Deactivation"),
            "Account Type" = const(Banking)) "Account Banking" where("Member No." = field("Member No."), "Account Category" = filter("Specialty Savings" | Savings | "Women Savings" | Junior | "Money Market")) else

            if ("Account Type" = const(Banking), "Changes Type" = filter("Block Account" | "Account Deactivation"),
            "Account Type" = const(Credit)) "Account Credit" where("Member No." = field("Member No."), "Account Category" = filter("Shares Capital" | "Shares Deposit" | "Benevolent Fund"));
        
            trigger OnValidate()
            var
                TellerMngt: Codeunit "Teller-Post (Yes/No)";
                TransType: Record "Transaction Charge";
                ChargesType: Decimal;
            begin

                case "Changes Type" of
                    "Changes Type"::"Card Link":
                        begin
                            TestField("Transaction Type");
                            TransType.Reset();
                            TransType.SetRange("Transaction Type", "Transaction Type");
                            if TransType.FindFirst() then begin
                                repeat
                                    ChargesType := ChargesType + TransType."Charge Amount";
                                until TransType.Next() = 0;
                            end;
                            if ChargesType >= TellerMngt.CalcAvailableBal("Account No.") then
                                Error('No enough funds to facilitate this transaction.');
                        end;
                end;

            end;
        }
        field(50090; "Posting Type"; Integer)
        {
            Caption = 'Post Type';
        }
        field(50091; "ATM Card No."; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                AttachCrmApplicationNo();
                fnValidateIdentityMask();
            end;
        }
        field(50092; "Application Reason"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","New Application","Replacement","Renewal","Block Card","Unblock Card";
            OptionCaption = ' ,New Card,Replacement,Renewal,Block Card,Unblock Card';
        }
        field(50093; "ATM Provision No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50094; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = filter("ATM Applications"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
            end;
        }

        field(50095; "E-mail (Personal)"; Code[50])
        {
            Caption = 'Email (Personal)';
            DataClassification = CustomerContent;
        }
        field(50096; "Expiry Date (Card)"; Date)
        {

        
            trigger OnValidate()
            begin
                if "Expiry Date (Card)" <= today then
                    Error('Card Expiry Date cannot be less than or equals to Today');

            end;
        }
        field(50097; "Idemnity"; Boolean)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50098; "Other Name"; Text[100])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50099; "Passport Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50100; "Identification Type"; Enum "MemberIdentificationType")
        {
            DataClassification = CustomerContent;
            Caption = 'Identification Type';
        
            trigger OnValidate()
            begin
                "ID No." := '';
                "Passport No." := ''
            end;
        }
        field(50101; "Date Created"; Date)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50102; "Picture ID"; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(50103; "Signature ID"; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(50104; "Contract End Date"; Date)
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Rec."Terms of Employment" = Rec."Terms of Employment"::Contract then begin
                    if "Contract End Date" <= Today then
                        Error('Contract cannot be less than or equal to today');
                end;
            end;
        }
        field(50105; "Terms of Employment"; Enum "TermsOfEmployment")
        {
            Caption = 'Terms of Employment';
            DataClassification = CustomerContent;
        }
        field(50106; "Value Change"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Change Log Entry" where("Primary Key Field 1 Value" = field("No."), "User ID" = field("Created By")));
        }
        field(50107; "Response"; Integer)
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
                        "Changes Type" := "Changes Type"::"Kin Details";
                    4:
                        "Changes Type" := "Changes Type"::"Account Signatories";
                    5:
                        "Changes Type" := "Changes Type"::"Block Account";
                    6:
                        "Changes Type" := "Changes Type"::Contribution;
                    7:
                        "Changes Type" := "Changes Type"::Readmission;

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
            SeriesSetup.TestField(SeriesSetup."Member Reactivation Nos.");
            "No. Series" := SeriesSetup."Member Reactivation Nos.";
            if NoSeriesMgt.AreRelated(SeriesSetup."Member Reactivation Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        "Application Date" := CurrentDateTime;
        "Created By" := UserId;
        "Date Created" := Today;
        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        "Global Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Global Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Center" := Temp."Responsibility Centre";
        "Last Date Modified" := Today
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Member Changes";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                SeriesSetup.Get();
                NoSeriesMgt.TestManual(SeriesSetup."Member Reactivation Nos.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Member Changes"; xRecRef: Record "Member Changes"; var IsHandled: Boolean)
    begin
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Temp: Record "User Setup";
        RegMngt: Codeunit "Register Management";
        Varvariant: Variant;
        RegistryMngt: Codeunit "Registry Mngt.";

    local procedure NameBreakdown()
    var
        NamePart: array[30] of Text[100];
        TempName: Text[250];
        FirstName250: Text[250];
        i: Integer;
        NoOfParts: Integer;
    begin
        TempName := Name;

        while StrPos(TempName, ' ') > 0 do begin
            if StrPos(TempName, ' ') > 1 then begin
                i := i + 1;
                NamePart[i] := CopyStr(TempName, 1, StrPos(TempName, ' ') - 1);
            end;
            TempName := CopyStr(TempName, StrPos(TempName, ' ') + 1);
        end;
        i := i + 1;
        NamePart[i] := CopyStr(TempName, 1, MaxStrLen(NamePart[i]));
        NoOfParts := i;

        "First Name" := '';
        "Second Name" := '';
        "Last Name" := '';
        for i := 1 to NoOfParts do
            if (i = NoOfParts) and (NoOfParts > 1) then
                "Last Name" := CopyStr(NamePart[i], 1, MaxStrLen("Last Name"))
            else
                if (i = NoOfParts - 1) and (NoOfParts > 2) then
                    "Second Name" := CopyStr(NamePart[i], 1, MaxStrLen("Second Name"))
                else begin
                    FirstName250 := DelChr("First Name" + ' ' + NamePart[i], '<', ' ');
                    "First Name" := CopyStr(FirstName250, 1, MaxStrLen("First Name"));
                end;
    end;


    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;

    procedure fnValidateIdentityMask()
    var
        AccT: Record "Account Banking";
        MemberExistError: label 'This card No. already attached to Account %1-%2';
    begin
        Rec."ATM Card No." := DelChr(Rec."ATM Card No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+');
        if Rec."ATM Card No." <> '' then begin
            AccT.Reset;
            AccT.SetRange("ATM No.", Rec."ATM Card No.");
            if AccT.FindFirst then begin
                if "Application Reason" = "Application Reason"::"New Application" then begin
                    if AccT."ATM No." <> '' then Error('ATM Card must not be null in account No. %1', AccT."No.");
                end;
                Error(MemberExistError, AccT."ATM No.", AccT.Name);
            end;
        end;
    end;

    procedure CopyFromCustomerMember(MemberApplication: Record Member)
    begin

        "Single Party/Multiple" := MemberApplication."Single Party/Multiple";
        Idemnity := MemberApplication.Idemnity;
        "First Name" := UpperCase(MemberApplication."First Name");
        "Second Name" := UpperCase(MemberApplication."Second Name");
        "Last Name" := UpperCase(MemberApplication."Last Name");
        "Other Name" := UpperCase(MemberApplication."Other Name");
        Name := UpperCase(MemberApplication.Name);
        "Registration Date" := MemberApplication."Registration Date";
        "Pay Point" := MemberApplication."Pay Point";
        Gender := MemberApplication.Gender;
        "Passport No." := MemberApplication."Passport No.";
        County := MemberApplication.City;
        "Passport Expiry Date" := MemberApplication."Passport Expiry Date";
        "Terms of Employment" := MemberApplication."Terms of Employment";
        "Contract End Date" := MemberApplication."Contract End Date";

        "Phone No." := MemberApplication."Phone No.";
        "Mobile Phone No" := MemberApplication."Mobile Phone No";
        "Current Address" := MemberApplication."Current Address";

        "Post Code" := MemberApplication."Post Code";
        City := MemberApplication.City;
        Designation := MemberApplication.Designation;
        "Recruited By Type" := MemberApplication."Recruited by Type";

        Nationality := MemberApplication.Nationality;
        "Marital Status" := MemberApplication."Marital Status";
        "Member Segment" := MemberApplication."Member Segment";
        "Member Category" := MemberApplication."Member Category";
        Status := Status::New;

        "Responsibility Center" := MemberApplication."Responsibility Center";
        "Employer Code" := MemberApplication."Employer Code";
        "Home Address" := MemberApplication."Home Address";
        "Payroll/Staff No." := MemberApplication."Payroll/Staff No.";
        "Recruited By" := MemberApplication."Recruited By";
        "Marital Status" := MemberApplication."Marital Status";
        "Customer Type" := MemberApplication."Customer Type";
        Gender := MemberApplication.Gender;

        "Type of Business" := MemberApplication."Type of Business";
        "Other Business Type" := MemberApplication."Other Business Type";
        "Ownership Type" := MemberApplication."Ownership Type";
        "Other Account Type" := MemberApplication."Other Account Type";
        "Nature of Business" := MemberApplication."Nature of Business";

        "Business/Group Location" := MemberApplication."Business/Group Location";
        "Plot/Bldg/Street/Road" := MemberApplication."Plot/Bldg/Street/Road";
        "Group Account" := MemberApplication."Group Account";
        "Group Type" := MemberApplication."Group Type";
        "Group Account" := MemberApplication."Group Account";
        "Bank Code" := MemberApplication."Bank Code";
        "Branch Code" := MemberApplication."Branch Code";
        "Bank Account No." := MemberApplication."Bank Account No.";
        "Application No." := MemberApplication."No.";
        "Date of Birth" := MemberApplication."Date of Birth";
        "Identification Type" := MemberApplication."Identification Type";
        "PIN No." := MemberApplication."PIN No.";
        "E-Mail" := MemberApplication."E-Mail";
        "E-mail (Personal)" := MemberApplication."E-mail (Personal)";
        Salutation := MemberApplication.Salutation;
        "Company Registration No." := MemberApplication."Company Registration No.";
        "Date of Business Reg." := MemberApplication."Date of Business Reg.";
        "Office Telephone No." := MemberApplication."Office Telephone No.";

    end;

    procedure IndividualEntriesFromCustMember()
    var
        CustBankAc: Record "Cust. Bank Account";
        CustBankChange: Record "Bank Account-Change";
        CustomerRecord: Record Member;
    begin

        case "Changes Type" of
            "Changes Type"::"Membership Details":
                begin

                    CustomerRecord.Reset();
                    CustomerRecord.SetRange("No.", Rec."Member No.");
                    if CustomerRecord.FindFirst() then begin

                        Varvariant := Rec;
                        CustomerRecord.Validate(Name, UpperCase(Name));
                        CustomerRecord."Other Name" := "Other Name";
                        if CustomerRecord."Old Member No." = '' then
                            CustomerRecord."Old Member No." := CustomerRecord."No.";
                        CustomerRecord.Idemnity := Idemnity;
                        CustomerRecord."Terms of Employment" := "Terms of Employment";
                        CustomerRecord."Contract End Date" := "Contract End Date";
                        CustomerRecord."Registration Date" := "Registration Date";
                        CustomerRecord."Office Telephone No." := "Office Telephone No.";
                        CustomerRecord.Validate("Date of Birth", "Date of Birth");
                        CustomerRecord.Validate("ID No.", "ID No.");
                        CustomerRecord.Validate("PIN No.", "PIN No.");
                        CustomerRecord.Validate("Passport Expiry Date", "Passport Expiry Date");
                        CustomerRecord."Identification Type" := "Identification Type";
                        CustomerRecord."Pay Point" := "Pay Point";
                        CustomerRecord.Gender := Gender;
                        CustomerRecord."Passport No." := "Passport No.";
                        CustomerRecord.County := City;
                        CustomerRecord."Member Segment" := "Member Segment";
                        CustomerRecord.Validate("Phone No.", "Phone No.");
                        CustomerRecord.Validate("Mobile Phone No", "Mobile Phone No");
                        CustomerRecord."Current Address" := "Current Address";
                        CustomerRecord."Post Code" := "Post Code";
                        CustomerRecord.City := City;
                        CustomerRecord.Designation := Designation;
                        CustomerRecord."Recruited by Type" := "Recruited By Type";
                        CustomerRecord."Recruited By" := "Recruited By";
                        CustomerRecord.Nationality := Nationality;
                        CustomerRecord."Country/Region" := Nationality;
                        CustomerRecord."Marital Status" := "Marital Status";
                        CustomerRecord."Member Category" := "Member Category";
                        CustomerRecord.Validate("Employer Code", "Employer Code");
                        CustomerRecord."Home Address" := "Home Address";
                        CustomerRecord."Payroll/Staff No." := "Payroll/Staff No.";
                        CustomerRecord."E-Mail" := "E-Mail";
                        CustomerRecord.Salutation := Salutation;
                        CustomerRecord."Bank Code" := "Bank Code";
                        CustomerRecord."Branch Code" := "Branch Code";
                        CustomerRecord."Bank Account No." := "Bank Account No.";
                        CustomerRecord."Date of Business Reg." := "Date of Business Reg.";
                        CustomerRecord.Validate("E-mail (Personal)", "E-mail (Personal)");
                        CustomerRecord.Modify(true);

                        CustBankAc.Reset();
                        CustBankAc.SetRange("Member No.", CustomerRecord."No.");
                        if CustBankAc.Find('-') then
                            CustBankAc.DeleteAll();

                        CustBankChange.Reset();
                        CustBankChange.SetRange("Application No.", "No.");
                        if CustBankChange.Find('-') then begin
                            repeat
                                CustBankAc.Init();
                                CustBankAc.TransferFields(CustBankChange);
                                CustBankAc.Insert(true)
                            until CustBankChange.Next() = 0;
                        end;

                        RegMngt.fnPostAccountchanges(Varvariant, CustomerRecord.Name, CustomerRecord."Global Dimension 2 Code",
                        0, CustomerRecord."Group Account No.", CustomerRecord."Group Account", CustomerRecord."ID No.",
                        CustomerRecord."Mobile Phone No", CustomerRecord."Employer Code", CustomerRecord."Date of Birth",
                        CustomerRecord."Phone No.");

                        Rec."Posted By" := UserId;
                        Rec."Date Posted" := CurrentDateTime;
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify(true)
                    end
                end;
            "Changes Type"::"Kin Details":
                begin

                    RegistryMngt.PostKinDetailsChanges(Rec);
                    Rec."Posted By" := UserId;
                    Rec."Date Posted" := CurrentDateTime;
                    Rec."Approval Status" := Rec."Approval Status"::Posted;
                    Rec.Modify(true)
                end;

            "Changes Type"::Images:
                begin

                    RegistryMngt.PostMediaChanges(Rec);
                    Rec."Posted By" := UserId;
                    Rec."Date Posted" := CurrentDateTime;
                    Rec."Approval Status" := Rec."Approval Status"::Posted;
                    Rec.Modify(true)
                end;
        end
    end;

    procedure CopyIndividualEntriesFromCustMember(CustomerRecord: Record Member)
    var
        CustBankAc: Record "Cust. Bank Account";
        CustBankChange: Record "Bank Account-Change";
    begin
        if CustomerRecord.Get("Member No.") then begin
            Varvariant := Rec;
            CustomerRecord.Validate(Name, UpperCase(Name));
            CustomerRecord."Other Name" := "Other Name";
            if CustomerRecord."Old Member No." = '' then
                CustomerRecord."Old Member No." := CustomerRecord."No.";
            CustomerRecord.Idemnity := Idemnity;
            CustomerRecord."Terms of Employment" := "Terms of Employment";
            CustomerRecord."Contract End Date" := "Contract End Date";
            CustomerRecord."Registration Date" := "Registration Date";
            CustomerRecord."Office Telephone No." := "Office Telephone No.";
            CustomerRecord."Date of Birth" := "Date of Birth";
            CustomerRecord.Validate("ID No.", "ID No.");
            CustomerRecord.Validate("PIN No.", "PIN No.");
            CustomerRecord.Validate("Passport Expiry Date", "Passport Expiry Date");
            CustomerRecord."Identification Type" := "Identification Type";
            CustomerRecord."Pay Point" := "Pay Point";
            CustomerRecord.Gender := Gender;
            CustomerRecord."Passport No." := "Passport No.";
            CustomerRecord.County := City;
            CustomerRecord."Member Segment" := "Member Segment";
            CustomerRecord.Validate("Phone No.", "Phone No.");
            CustomerRecord.Validate("Mobile Phone No", "Mobile Phone No");
            CustomerRecord."Current Address" := "Current Address";
            CustomerRecord."Post Code" := "Post Code";
            CustomerRecord.City := City;
            CustomerRecord.Designation := Designation;
            CustomerRecord."Recruited by Type" := "Recruited By Type";
            CustomerRecord."Recruited By" := "Recruited By";
            CustomerRecord.Nationality := Nationality;
            CustomerRecord."Marital Status" := "Marital Status";
            CustomerRecord."Member Segment" := "Member Segment";
            CustomerRecord."Member Category" := "Member Category";
            CustomerRecord."Employer Code" := "Employer Code";
            CustomerRecord."Home Address" := "Home Address";
            CustomerRecord."Payroll/Staff No." := "Payroll/Staff No.";
            CustomerRecord."E-Mail" := "E-Mail";
            CustomerRecord.Salutation := Salutation;
            CustomerRecord."Bank Code" := "Bank Code";
            CustomerRecord."Branch Code" := "Branch Code";
            CustomerRecord."Bank Account No." := "Bank Account No.";
            CustomerRecord."Mobile Phone No" := "Mobile Phone No";
            CustomerRecord."Marital Status" := "Marital Status";
            CustomerRecord.Gender := Gender;
            CustomerRecord."Date of Business Reg." := "Date of Business Reg.";
            CustomerRecord.Validate("E-mail (Personal)", "E-mail (Personal)");
            CustomerRecord.Modify;

            CustBankAc.Reset();
            CustBankAc.SetRange("Member No.", CustomerRecord."No.");
            if CustBankAc.Find('-') then
                CustBankAc.DeleteAll();

            CustBankChange.Reset();
            CustBankChange.SetRange("Application No.", "No.");
            if CustBankChange.Find('-') then begin
                repeat
                    CustBankAc.Init();
                    CustBankAc.TransferFields(CustBankChange);
                    CustBankAc.Insert(true)
                until CustBankChange.Next() = 0;
            end;

            RegMngt.fnPostAccountchanges(Varvariant,
            CustomerRecord.Name, CustomerRecord."Global Dimension 2 Code", 0,
            CustomerRecord."Group Account No.", CustomerRecord."Group Account",
            CustomerRecord."ID No.", CustomerRecord."Mobile Phone No",
            CustomerRecord."Employer Code", CustomerRecord."Date of Birth", CustomerRecord."Phone No.")
        end
    end;

    procedure CopyGroupEntriesFromCustMember(CustomerRecord: Record Member)
    begin
        if CustomerRecord.Get("Member No.") then begin
            Varvariant := Rec;
            if Name <> UpperCase(CustomerRecord.Name) then
                CustomerRecord.Name := UpperCase(Name);
            if "ID No." <> CustomerRecord."ID No." then
                CustomerRecord."ID No." := "ID No.";
            if "PIN No." <> CustomerRecord."ID No." then
                CustomerRecord."PIN No." := "PIN No.";
            if "Other Name" <> CustomerRecord."Other Name" then
                CustomerRecord."Other Name" := "Other Name";
            if County <> CustomerRecord.City then
                CustomerRecord.County := City;

            if "Phone No." <> CustomerRecord."Phone No." then
                CustomerRecord."Phone No." := "Phone No.";

            if "Mobile Phone No" <> CustomerRecord."Mobile Phone No" then
                CustomerRecord."Mobile Phone No" := "Mobile Phone No";

            if "Current Address" <> CustomerRecord."Current Address" then
                CustomerRecord."Current Address" := "Current Address";
            if "Post Code" <> CustomerRecord."Post Code" then
                CustomerRecord."Post Code" := "Post Code";
            if City <> CustomerRecord.City then
                CustomerRecord.City := City;

            if "Recruited By Type" <> CustomerRecord."Recruited by Type" then
                CustomerRecord."Recruited by Type" := "Recruited By Type";
            if "Recruited By" <> CustomerRecord."Recruited By" then
                CustomerRecord."Recruited By" := "Recruited By";

            if "Home Address" <> CustomerRecord."Home Address" then
                CustomerRecord."Home Address" := "Home Address";

            if "E-Mail" <> CustomerRecord."E-Mail" then
                CustomerRecord."E-Mail" := "E-Mail";
            if "Single Party/Multiple" <> CustomerRecord."Single Party/Multiple" then
                CustomerRecord."Single Party/Multiple" := "Single Party/Multiple";
            if "Type of Business" <> CustomerRecord."Type of Business" then
                CustomerRecord."Type of Business" := "Type of Business";
            if "Other Business Type" <> CustomerRecord."Other Business Type" then
                CustomerRecord."Other Business Type" := "Other Business Type";
            if "Ownership Type" <> CustomerRecord."Ownership Type" then
                CustomerRecord."Ownership Type" := "Ownership Type";

            if "Other Account Type" <> CustomerRecord."Other Account Type" then
                CustomerRecord."Other Account Type" := "Other Account Type";
            if "Nature of Business" <> CustomerRecord."Nature of Business" then
                CustomerRecord."Nature of Business" := "Nature of Business";

            if "Business/Group Location" <> CustomerRecord."Business/Group Location" then
                CustomerRecord."Business/Group Location" := "Business/Group Location";
            if "Plot/Bldg/Street/Road" <> CustomerRecord."Plot/Bldg/Street/Road" then
                CustomerRecord."Plot/Bldg/Street/Road" := "Plot/Bldg/Street/Road";
            if "Group Account" <> CustomerRecord."Group Account" then
                CustomerRecord."Group Account" := "Group Account";
            if "Group Type" <> CustomerRecord."Group Type" then
                CustomerRecord."Group Type" := "Group Type";

            if "Bank Code" <> CustomerRecord."Bank Code" then
                CustomerRecord."Bank Code" := "Bank Code";
            if "Branch Code" <> CustomerRecord."Branch Code" then
                CustomerRecord."Branch Code" := "Branch Code";
            if "Bank Account No." <> CustomerRecord."Bank Account No." then
                CustomerRecord."Bank Account No." := "Bank Account No.";
            if "Company Registration No." <> CustomerRecord."Company Registration No." then
                CustomerRecord."Company Registration No." := "Company Registration No.";
            if "Date of Business Reg." <> CustomerRecord."Date of Business Reg." then
                CustomerRecord."Date of Business Reg." := "Date of Business Reg.";
            if CustomerRecord."E-mail (Personal)" <> "E-mail (Personal)" then
                CustomerRecord.Validate("E-mail (Personal)", "E-mail (Personal)");
            CustomerRecord.Modify;

            RegMngt.fnPostAccountchanges(Varvariant,
            CustomerRecord.Name, CustomerRecord."Global Dimension 2 Code", 0,
            CustomerRecord."Group Account No.", CustomerRecord."Group Account",
            CustomerRecord."ID No.", CustomerRecord."Mobile Phone No",
            CustomerRecord."Employer Code", CustomerRecord."Date of Birth", CustomerRecord."Phone No.")
        end;
    end;


    procedure fnTestFields()
    begin
        TestField("Approval Status", "Approval Status"::Open);
        TestField("Changes Type");
        TestField("Resons for Status Change")
    end;

    procedure AttachCrmApplicationNo()
    var
        LoansApp: Record "Account Banking";
        CRMLoanApplication: Record "CRM Application";
        Err002: Label 'ATM Card is already attached to Account No. %1';
    begin
        LoansApp.Reset;
        LoansApp.SetRange("ATM No.", Rec."ATM Card No.");
        if LoansApp.Find('-') then begin
            if Rec."ATM Card No." <> '' then
                if LoansApp."No." <> Rec."No." then
                    Error(Err002, LoansApp.Name);
        end;
        Rec."ATM Card No." := DelChr(Rec."ATM Card No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
    end;

    procedure SendEmailNotif()
    var
        SendNotif: Codeunit "SMS Notification";
    begin

        if Rec.Idemnity then begin
            VarVariant := Rec;
            if Rec."E-Mail" <> '' then
                SendNotif.SendEmailNotification(VarVariant, 1, Rec."No.");
        end;
    end;
}




