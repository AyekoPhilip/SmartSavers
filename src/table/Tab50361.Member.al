table 50361 "Member"
{
    DrillDownPageID = "Member List";
    LookupPageID = "Member List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(50010; "Name"; Text[80])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
                NameBreakdown
            end;
        }
        field(50011; "Search Name"; Code[80])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
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
            TableRelation = if ("Country/Region" = const()) "Post Code".City
            else
            if ("Country/Region" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region"));
            ValidateTableRelation = false;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50016; "Contact"; Text[50])
        {
            Caption = 'Contact';
            DataClassification = CustomerContent;
        }
        field(50017; "Phone No."; Text[20])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Phone No." <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."Phone No.", "Phone No.");
                    if Cust.FindFirst then
                        if Cust."No." <> "No." then begin
                            if Cust.Count > 1 then
                                Error(MemberExistErrorPhone, "Phone No.", Cust."No.", Cust.Name);
                        end;
                end;
            end;
        }
        field(50018; "Telex No."; Text[20])
        {
            Caption = 'Allocated File No.';
            FieldClass = FlowField;
            CalcFormula = lookup("File Allocation"."ID No." where("ID No." = field("ID No.")));
            Editable = false;
        }
        field(50019; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
            DataClassification = CustomerContent;
        }
        field(50021; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50022; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50023; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50024; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
        }
        field(50025; "Nationality"; Code[10])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(50026; "Comment"; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50027; "Blocked"; Enum "Customer Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50028; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50029; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50030; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50031; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50032; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(50033; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(50034; "Picture"; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
            DataClassification = CustomerContent;
        }
        field(50035; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Post Code" := CopyStr("Post Code", 1, 20);
            end;
        }
        field(50036; "County"; Code[250])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(50037; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50038; "Current Location"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
            DataClassification = CustomerContent;
        }
        field(50039; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50040; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50041; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
            end;
        }
        field(50042; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";
            DataClassification = CustomerContent;
        }
        field(50043; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
            DataClassification = CustomerContent;
        }
        field(50044; "Customer Type"; Enum "CreditCustomerType")
        {
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
        }
        field(50045; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(50046; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50047; "Employer Code"; Code[100])
        {
            TableRelation = Customer where("Account Type" = const(Employer));
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50048; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
            end;
        }
        field(50049; "Location"; Text[50])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
        }
        field(50050; "Resons for Status Change"; Text[80])
        {
            Caption = 'Resons for Status Change';
            DataClassification = CustomerContent;
        }
        field(50051; "Payroll/Staff No."; Code[20])
        {
            Caption = 'Payroll/Staff No.';
            DataClassification = CustomerContent;
        }
        field(50052; "ID No."; Code[50])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                fnValidateID
            end;
        }
        field(50053; "Mobile Phone No"; Code[50])
        {
            Caption = 'Mobile Phone No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Mobile Phone No" <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."Mobile Phone No", "Mobile Phone No");
                    if Cust.Count > 1 then
                        Error(MemberExistErrorPhone, Cust."No.", Cust.Name);
                end;
                "MPESA Mobile No" := "Mobile Phone No";
            end;
        }
        field(50054; "Marital Status"; Enum "MaritalStatus")
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(50055; "Passport No."; Code[50])
        {
            Caption = 'Passport No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50056; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50057; "First Name"; Text[50])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Name := "First Name" + ' ' + "Second Name" + ' ' + "Last Name";
                "Created By" := UserId;
            end;
        }
        field(50058; "Office Telephone No."; Code[50])
        {
            Caption = 'Office Telephone No.';
            DataClassification = CustomerContent;
        }
        field(50059; "Account Category"; Option)
        {
            OptionCaption = 'Member,Staff Members,Board Members,Delegates';
            OptionMembers = "Member","Staff Members","Board Members","Delegates";
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50060; "MPESA Mobile No"; Code[20])
        {
            CharAllowed = '0123456789';
            Caption = 'MPESA Mobile No';
            DataClassification = CustomerContent;
        }
        field(50061; "Group Account No."; Code[20])
        {
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }
        field(50062; "Group Account"; Boolean)
        {
            Caption = 'Group Account';
            DataClassification = CustomerContent;
        }
        field(50063; "Second Name"; Text[50])
        {
            Caption = 'Second Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Name := "First Name" + ' ' + "Second Name" + ' ' + "Last Name";
            end;
        }
        field(50064; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Name := "First Name" + ' ' + "Second Name" + ' ' + "Last Name";
            end;
        }
        field(50065; "Employment / Occupation Detail"; Text[50])
        {
            Caption = 'Employment / Occupation Detail';
            DataClassification = CustomerContent;
        }
        field(50066; "Employer's Postal Address"; Text[150])
        {
            Caption = 'Employer''s Postal Address';
            DataClassification = CustomerContent;
        }
        field(50067; "Member Segment"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = filter(Contract | Pension | Permanent | "Standing Order" | Staff | "Early Retirement" | "Board Member" | Segment));
            Caption = 'Member Segment';
            DataClassification = CustomerContent;
        }
        field(50068; "Membership Type"; Option)
        {
            OptionCaption = ' ,Ordinary,Preferential';
            OptionMembers = " ","Ordinary","Preferential";
            Caption = 'Membership Type';
            DataClassification = CustomerContent;
        }
        field(50069; "Account Type"; Option)
        {
            OptionCaption = ' ,Savings Account,Personal Savings,Microfinance Savings,Salary Account,Share Deposit Account,Fixed Deposit Account,Others(Specify)';
            OptionMembers = " ","Savings Account","Personal Savings","Microfinance Savings","Salary Account","Share Deposit Account","Fixed Deposit Account","Others(Specify)";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50070; "Relates to Business/Group"; Boolean)
        {
            Caption = 'Relates to Business/Group';
            DataClassification = CustomerContent;
        }
        field(50071; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Paerneship,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor","Paerneship","Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
            Caption = 'Type of Business';
            DataClassification = CustomerContent;
        }
        field(50072; "Other Business Type"; Text[15])
        {
            Caption = 'Other Business Type';
            DataClassification = CustomerContent;
        }
        field(50073; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares";
            Caption = 'Ownership Type';
            DataClassification = CustomerContent;
        }
        field(50074; "Other Account Type"; Text[15])
        {
            Caption = 'Other Account Type';
            DataClassification = CustomerContent;
        }
        field(50075; "Nature of Business"; Text[30])
        {
            Caption = 'Nature of Business';
            DataClassification = CustomerContent;
        }
        field(50076; "Company Registration No."; Code[20])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;
        }
        field(50077; "Date of Business Reg."; Date)
        {
            Caption = 'Date of Business Reg.';
            DataClassification = CustomerContent;
        }
        field(50078; "Business/Group Location"; Text[50])
        {
            Caption = 'Business/Group Location';
            DataClassification = CustomerContent;
        }
        field(50079; "Plot/Bldg/Street/Road"; Text[50])
        {
            Caption = 'Plot/Bldg/Street/Road';
            DataClassification = CustomerContent;
        }
        field(50080; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Microfinance';
            OptionMembers = " ","Welfare","Microfinance";
            Caption = 'Group Type';
            DataClassification = CustomerContent;
        }
        field(50081; "Single Party/Multiple"; Option)
        {
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = "Single","Multiple","Business";
            Caption = 'Single Party/Multiple';
            DataClassification = CustomerContent;
        }
        field(50082; "Birth Certificate No."; Code[20])
        {
            Caption = 'Birth Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50083; "Current Residence"; Text[250])
        {
            Caption = 'Current Residence';
            DataClassification = CustomerContent;
        }
        field(50084; "Protected Account"; Boolean)
        {
            Caption = 'Protected Account';
            DataClassification = CustomerContent;
        }
        field(50085; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50086; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50087; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Code Structure";
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50088; "Branch Code"; Code[20])
        {
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50089; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        }
        field(50090; "PIN No."; Code[20])
        {
            Caption = 'PIN No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                FieldLength("ID No.", 20);
            end;
        }
        field(50091; "Source"; Option)
        {
            OptionCaption = ' ,Navision,CRM,Web';
            OptionMembers = " ","Navision","CRM","Web";
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(50092; "Application No."; Code[50])
        {
            Caption = 'Application No.';
            DataClassification = CustomerContent;
        }
        field(50093; "Member Type"; Option)
        {
            OptionCaption = 'Ordinary,Preferential';
            OptionMembers = "Ordinary","Preferential";
            Caption = 'Member Type';
            DataClassification = CustomerContent;
        }
        field(50094; "Member Category"; Code[10])
        {
            TableRelation = "Member Category";
            Caption = 'Member Category';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                MembCat: Record "Member Category";
            begin
                MembCat.Reset();
                MembCat.SetRange("No.", "Member Category");
                if MembCat.FindFirst() then
                    Type := MembCat.Type;
                "Terms of Employment" := MembCat."Terms of Service";
            end;
        }
        field(50095; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Member,Others';
            OptionMembers = "Marketer","Member","Others";
            Caption = 'Recruited by Type';
            DataClassification = CustomerContent;
        }
        field(50096; "Pay Point"; Code[10])
        {
            TableRelation = Customer;
            Caption = 'Pay Point';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Cusr: Record Customer;
            begin
                if Cusr.Get("Pay Point") then
                    "Pay Point Name" := Cusr.Name;
            end;
        }
        field(50097; "FingerPrint Verified"; Boolean)
        {
            Editable = false;
            Caption = 'FingerPrint Verified';
            DataClassification = CustomerContent;
        }
        field(50099; "SystemGeneratedGuid"; Guid)
        {
            Caption = 'SystemGeneratedGuid';
            DataClassification = CustomerContent;
        }
        field(50100; "Relationship Manager"; Code[10])
        {
            Caption = 'Relationship Manager';
            DataClassification = CustomerContent;
        }
        field(50101; "Statement E-Mail Freq."; DateFormula)
        {
            Caption = 'Statement E-Mail Freq.';
            DataClassification = CustomerContent;
        }
        field(50102; "Contract Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Permanent,Internship,Contract,Casual,Consultancy';
            OptionMembers = "Permanent","Internship","Contract","Casual","Consultancy";
            Caption = 'Contract Type';
        }
        field(50103; "Last Transaction Date"; Date)
        {
            CalcFormula = Max("Banking A/c Ledger Entry"."Posting Date" WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
            Caption = 'Last Transaction Date';
        }
        field(50104; "Classification"; Option)
        {
            OptionCaption = ' ,Good Standing,Bad Standing';
            OptionMembers = " ","Good Standing","Bad Standing";
            Caption = 'Classification';
            DataClassification = CustomerContent;
        }
        field(50105; "Electrol Zone"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Electral Zone"));
            Caption = 'Electrol Zone';
            DataClassification = CustomerContent;
        }
        field(50106; "Area Service Center"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Area Service Centers"));
            Caption = 'Area Service Center';
            DataClassification = CustomerContent;
        }
        field(50107; "Type"; Enum "MemberCategoryType")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50108; "Dividend Payment Method"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST("Dividend Payment Type"));
            Caption = 'Dividend Payment Method';
            DataClassification = CustomerContent;
        }
        field(50109; "Associated Member No."; Code[20])
        {
            Caption = 'Associated Member No.';
            DataClassification = CustomerContent;
        }
        field(50110; "Hide"; Boolean)
        {
            Caption = 'Hide';
            DataClassification = CustomerContent;
        }
        field(50111; "Virtual Members"; Boolean)
        {
            Caption = 'Virtual Members';
            DataClassification = CustomerContent;
        }
        field(50112; "Principal Member No."; Code[20])
        {
            Caption = 'Principal Member No.';
        }
        field(50113; "Recruited By Name"; Text[100])
        {
            Editable = false;
            Caption = 'Recruited By Name';
            DataClassification = CustomerContent;
        }
        field(50114; "Salutation"; Code[50])
        {
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
            Caption = 'Salutation';
            DataClassification = CustomerContent;
        }
        field(50115; "Member Station"; Code[20])
        {
            Caption = 'Member Station';
            DataClassification = CustomerContent;
        }
        field(50116; "Pay Point Name"; Text[100])
        {
            Editable = false;
            Caption = 'Pay Point Name';
            DataClassification = CustomerContent;
        }
        field(50117; "Rejoined"; Boolean)
        {
            Caption = 'Rejoined';
            DataClassification = CustomerContent;
        }
        field(50118; "Rejoining Date"; Date)
        {
            Editable = false;
            Caption = 'Rejoining Date';
            DataClassification = CustomerContent;
        }
        field(50119; "Designation"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Designation';
        }
        field(50120; "Station/Department"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
            Caption = 'Station/Department';
        }
        field(50121; "Old Member No."; Code[20])
        {
            Caption = 'Old Member No.';
            DataClassification = CustomerContent;
        }
        field(50122; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Dimension';
        }
        field(50123; "Identification Type"; Enum "MemberIdentificationType")
        {
            DataClassification = CustomerContent;
            Caption = 'Identification Type';
        
            trigger OnValidate()
            begin
                "ID No." := '';
                "Passport No." := ''
            end;
        }
        field(50124; "E-mail (Personal)"; Code[50])
        {
            Caption = 'Email (Personal)';
        }
        field(50125; "Other Name"; Text[150])
        {
            Editable = false;
        }
        field(50126; "Country/Region"; Code[30])
        {
            TableRelation = "Country/Region".Code;
            ValidateTableRelation = false;
            Caption = 'Nationality';
            DataClassification = CustomerContent;
        }
        field(50127; "File No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50128; "Idemnity"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'High Risk Classified';
            Editable = false;
        }
        field(50129; "Withdrawal Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50130; "Gross Dividends"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50131; "Interest on Deposit"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50132; "Statement Frequency"; DateFormula)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50133; "Last Statement Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50134; "Ufaa"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'UFAA';
            Editable = false;
        }
        field(50135; "Member No. Notified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50136; "Allow Min. Banding"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allow Minimum Banding';
        }
        field(50137; "Passport Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50138; "Loan Status"; Enum "MemberStatus")
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(50139; "Mobile Status"; Enum "MemberStatus")
        {
            Caption = 'Mobile Loan';
            DataClassification = CustomerContent;
        }
        field(50140; "Union Member No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50141; "Terms of Employment"; Enum "TermsOfEmployment")
        {
            Caption = 'Terms of Employment';
            DataClassification = CustomerContent;
        }

        field(50142; "Contract End Date"; Date)
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
        field(50143; "Notification Option"; Option)
        {
            Caption = 'Notification Options';
            OptionMembers = "All Notification","Statement","Birthday Reminders","Promotions","Opted Out";
            OptionCaption = 'All Notification,Statement,Birthday Reminders,Event & Promotions,Opted Out';
            Editable = false;
        }
        field(50144; "Mode of Payment"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
        }
        field(50098; "Contract Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Expiry Date (Contract)';
        
            trigger OnValidate()
            begin
                if "Contract Expiry Date" < Today then Error('Expiry cannot be less than today');
                TestField("Terms of Employment", "Terms of Employment"::Contract);
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
        fieldgroup(Dropdown; "No.", Name, "Old Member No.")
        {

        }
    }

    trigger OnInsert()
    begin
        SeriesSetup.Get;
        if "No." = '' then begin
            case "Group Account" of
                false:
                    begin
                        SeriesSetup.TestField(SeriesSetup."Member Nos.");
                        "No. Series" := SeriesSetup."Member Nos.";
                        if NoSeriesMgt.AreRelated(SeriesSetup."Member Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;
                true:
                    begin
                        SeriesSetup.TestField(SeriesSetup."Group Nos.");
                        "No. Series" := SeriesSetup."Group Nos.";
                        if NoSeriesMgt.AreRelated(SeriesSetup."Group Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;
            end;
        end;

        "Created By" := UserId;
        "Last Date Modified" := Today;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record Member;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                SeriesSetup.Get();
                case "Group Account" of
                    false:
                        begin
                            NoSeriesMgt.TestManual(SeriesSetup."Member Nos.");
                            "No. Series" := '';
                        end else begin
                        NoSeriesMgt.TestManual(SeriesSetup."Group Nos.");
                        "No. Series" := '';
                    end;
                end;
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record Member; xRecRef: Record Member; var IsHandled: Boolean)
    begin
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
        MemberExistError: Label 'ID/Passport already exists with member %1 Name: %2';
        MemberExistErrorPhone: Label 'Phone No. Already exists with member %1 Name: %2';
        Text004: Label 'Post';
        Text005: Label 'Create';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        PostCode: Record "Post Code";

    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNO: Code[20])
    var
        MemberLedgEntry: Record "Cust. Ledger Entry";
        Text000: Label '';
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "No.");
        if MemberLedgEntry.Find('-') then
            Error(Text000,
                  CurrentFieldName);
    end;

    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
    begin
        DocumentSendingProfile.GetDefaultForCustomer("No.", DocumentSendingProfile);
        Commit;

        TempDocumentSendingProfile.Init;
        TempDocumentSendingProfile.Code := DocumentSendingProfile.Code;
        TempDocumentSendingProfile.Validate("One Related Party Selected", IsSingleCustomerSelected);
        TempDocumentSendingProfile.SetDocumentUsage(Rec);
        TempDocumentSendingProfile.Insert;

        if PAGE.RunModal(PAGE::"Select Sending Options", TempDocumentSendingProfile) = ACTION::LookupOK then begin
            CheckDocumentSendingProfileIsSupported(TempDocumentSendingProfile);
        end;
    end;


    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
    begin
        TempDocumentSendingProfile.Init;

        if ShowRequestForm then
            TempDocumentSendingProfile.Printer := TempDocumentSendingProfile.Printer::"Yes (Prompt for Settings)"
        else
            TempDocumentSendingProfile.Printer := TempDocumentSendingProfile.Printer::"Yes (Use Default Settings)";
        TempDocumentSendingProfile.Insert;
    end;


    procedure EmailRecords(ShowRequestForm: Boolean)
    var
        TempDocumentSendingProfile: Record "Document Sending Profile" temporary;
    begin
        TempDocumentSendingProfile.Init;

        if ShowRequestForm then
            TempDocumentSendingProfile."E-Mail" := TempDocumentSendingProfile."E-Mail"::"Yes (Prompt for Settings)"
        else
            TempDocumentSendingProfile."E-Mail" := TempDocumentSendingProfile."E-Mail"::"Yes (Use Default Settings)";
        TempDocumentSendingProfile."E-Mail Attachment" := TempDocumentSendingProfile."E-Mail Attachment"::PDF;
        TempDocumentSendingProfile.Insert;
    end;

    local procedure IsSingleCustomerSelected(): Boolean
    var
        SelectedCount: Integer;
        CustomerCount: Integer;
        BillToCustomerNoFilter: Text;
    begin
        SelectedCount := Count;

        if SelectedCount < 1 then
            exit(false);

        if SelectedCount = 1 then
            exit(true);
        BillToCustomerNoFilter := GetFilter("No.");
        SetRange("No.", "No.");
        CustomerCount := Count;
        SetFilter("No.", BillToCustomerNoFilter);

        exit(SelectedCount = CustomerCount);
    end;

    local procedure CheckDocumentSendingProfileIsSupported(var TempDocumentSendingProfile: Record "Document Sending Profile" temporary)
    var
        CannotSendMultipleStatementsElectronicallyErr: Label 'You can only send one electronic statements at a time.';
    begin
        if (Count > 1) and
        (TempDocumentSendingProfile."Electronic Document" <> TempDocumentSendingProfile."Electronic Document"::No)
        then
            Error(CannotSendMultipleStatementsElectronicallyErr);
    end;

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

    procedure CopyFromApplicationLine(MemberApplication: Record "Member Application")
    begin
        "Old Member No." := "Old Member No.";
        "Single Party/Multiple" := MemberApplication."Single Party/Multiple/Business";
        "Application No." := MemberApplication."No.";
        "First Name" := UpperCase(MemberApplication."First Name");
        "Second Name" := UpperCase(MemberApplication."Second Name");
        "Last Name" := UpperCase(MemberApplication."Last Name");
        Name := UpperCase(MemberApplication.Name);
        "Registration Date" := Today;
        "Pay Point" := MemberApplication."Pay Point";
        "Pay Point Name" := MemberApplication."Pay Point Name";
        Gender := MemberApplication.Gender;
        "Passport No." := MemberApplication."Passport No.";
        County := MemberApplication.County;
        "Customer Type" := MemberApplication."Customer Type";
        "Phone No." := MemberApplication."Phone No.";
        "Mobile Phone No" := MemberApplication."Mobile Phone No";
        "Current Address" := MemberApplication."Current Address";
        "MPESA Mobile No" := MemberApplication."Other Phone";

        "Post Code" := MemberApplication."Post Code";
        City := MemberApplication.City;
        Designation := MemberApplication.Designation;
        "Recruited by Type" := MemberApplication."Recruited by Type";
        "Contract End Date" := MemberApplication."Contract End Date";

        Nationality := MemberApplication.Nationality;
        "Marital Status" := MemberApplication."Marital Status";
        "Member Segment" := MemberApplication."Member Segment";
        "Member Category" := MemberApplication."Member Category";
        Status := Status::New;
        "Terms of Employment" := MemberApplication."Terms of Employment";

        "Responsibility Center" := MemberApplication."Responsibility Center";
        "Employer Code" := MemberApplication."Employer Code";
        "Home Address" := MemberApplication."Home Address";
        "Payroll/Staff No." := MemberApplication."Payroll No.";
        "Recruited By" := MemberApplication."Recruited By";
        "Marital Status" := MemberApplication."Marital Status";
        "Customer Type" := MemberApplication."Customer Type";
        Gender := MemberApplication.Gender;
        "Country/Region" := MemberApplication."Country/Region";

        "Type of Business" := MemberApplication."Type of Business";
        "Other Business Type" := MemberApplication."Other Business Type";
        "Ownership Type" := MemberApplication."Ownership Type";
        "Other Account Type" := MemberApplication."Other Account Type";
        "Nature of Business" := MemberApplication."Nature of Business";

        "Business/Group Location" := MemberApplication."Business/Group Location";
        "Plot/Bldg/Street/Road" := MemberApplication."Plot/Bldg/Street/Road";
        "Group Account" := MemberApplication."Group Account";
        "Group Account" := MemberApplication."Group Account";
        "Group Type" := MemberApplication."Group Type";
        "Identification Type" := MemberApplication."Identification Type";
        Idemnity := MemberApplication.Indemnity;
        "Group Account" := MemberApplication."Group Account";
        "Bank Code" := MemberApplication."Bank Code";
        "Branch Code" := MemberApplication."Branch Code";
        "Single Party/Multiple" := MemberApplication."Single Party/Multiple/Business";
        "Bank Account No." := MemberApplication."Bank Account No.";
        "Application No." := MemberApplication."No.";
        "Created By" := UserId;
        "Union Member No." := MemberApplication."Old Member No.";
        "E-Mail" := MemberApplication."E-Mail";
        Salutation := MemberApplication.Salutation;
    end;

    procedure CheckBlockedCustOnJnls(Cust2: Record Member; DocType: Enum MemberStatus; Transaction: Boolean)
    begin
        if Cust2."Group Account" then begin
            Cust2.TestField("Company Registration No.");
            Cust2.TestField("Date of Business Reg.");
        end else begin
            Cust2.TestField("ID No.");
            Cust2.TestField("Date of Birth");
            Cust2.TestField("Employer Code");
            Cust2.TestField("Registration Date");
        end;

        if (Cust2.Blocked = Cust2.Blocked::All) or
            ((Cust2.Blocked = Cust2.Blocked::Invoice) and (DocType in [DocType::Closed,
            DocType::Defaulter, DocType::Deceased, DocType::Dormant, Cust2.Status::New,
            DocType::Frozen, DocType::New, DocType::"Withdrawal Application",
            DocType::Withdrawn]))
          then
            Cust2.CustBlockedErrorMessage(Cust2, Transaction)
    end;

    procedure CustBlockedErrorMessage(Cust2: Record Member; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Cust2."No.", Cust2.Blocked);
    end;


    procedure fnValidateID()
    begin
        if not "Group Account" then begin
            case "Identification Type" of
                "Identification Type"::"National ID":
                    begin
                        "ID No." := DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                        FieldLength("ID No.", 20);
                    end;
                "Identification Type"::Passport:
                    begin
                        "Passport No." := "ID No."
                    end;
            end
        end;
        if "ID No." <> '' then begin
            Cust.Reset;
            Cust.SetRange(Cust."ID No.", "ID No.");
            if Cust.FindFirst then begin
                if Cust."No." <> "No." then begin
                    if Cust.Count > 1 then
                        Error(MemberExistError, Cust."ID No.", Cust.Name);
                end;

            end;
        end;
    end;


}




