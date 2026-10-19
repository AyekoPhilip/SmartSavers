table 50352 "Member Application"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                NameBreakdownTxt;
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(50011; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Current Address"; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(50013; "Home Address"; Text[50])
        {
            Caption = 'Home Address';
            DataClassification = CustomerContent;
        }
        field(50014; "Phone No."; Text[20])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Country/Region");
                "Phone No." := DelChr("Phone No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');
            end;
        }
        field(50015; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50016; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50017; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50018; "Second Name"; Text[20])
        {
            Editable = false;
            Caption = 'Second Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Second Name" := DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50019; "Last Name"; Text[20])
        {
            Editable = false;
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Last Name" := DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50020; "Customer Type"; Enum "CreditCustomerType")
        {
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
        }
        field(50021; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Application Date" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(50022; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50023; "Employer Code"; Code[20])
        {
            TableRelation = Customer where("Account Type" = const(Employer));
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Customer.Get("Employer Code") then begin
                    "Employer Name" := Customer.Name;
                end;
            end;
        }
        field(50024; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" >= Today then
                    Error(DateofBirthError);
                GeneralSetUp.Get;
                if CalcDate(GeneralSetUp."Min. Member Age", "Date of Birth") > Today then begin
                    Error(MinimumAgeError, GeneralSetUp."Min. Member Age");
                    if (CalcDate(GeneralSetUp."Max. Member Age - Disabled", "Date of Birth")) < Today
                          then
                        Error('The Member age of %1 is exceeded', GeneralSetUp."Max. Member Age - Disabled");
                end;
            end;
        }
        field(50025; "E-Mail"; Text[50])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
                "Secondary E-Mail" := "E-Mail";
            end;
        }
        field(50026; "Station/Department"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Station));
            Caption = 'Station/Department';
            DataClassification = CustomerContent;
        }
        field(50027; "Nationality"; Code[20])
        {
            TableRelation = "Country/Region".Code;
            ValidateTableRelation = false;
            Caption = 'Nationality';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                CountCode: Record "Country/Region";
            begin
                if CountCode.Get(Nationality) then
                    "Mobile Phone No" := CountCode."Intrastat Code";
                "Phone No." := CountCode."Intrastat Code";
                "Other Phone" := CountCode."Intrastat Code";
            end;
        }
        field(50028; "Payroll No."; Code[20])
        {
            Caption = 'Payroll No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Payroll No." <> '' then begin

                    MemberApplication.Reset;
                    MemberApplication.SetFilter("Employer Code", "Employer Code");
                    MemberApplication.SetFilter("Payroll No.", "Payroll No.");
                    if MemberApplication.FindFirst then
                        if (MemberApplication."Approval Status" in [MemberApplication."Approval Status"::Open, MemberApplication."Approval Status"::"Pending Approval", MemberApplication."Approval Status"::Approved]) then
                            Error(MemberExistError, MemberApplication."No.", MemberApplication.Name);
                    Cust.Reset;
                    Cust.SetRange(Cust."Employer Code", "Employer Code");
                    Cust.SetRange(Cust."Payroll/Staff No.", "Payroll No.");
                    if Cust.FindFirst then
                        Error(MemberExistError, "Employer Code", Cust."No.", Cust.Name);
                end;
            end;
        }
        field(50029; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                fnValidateID();
            end;
        }
        field(50030; "Mobile Phone No"; Code[20])
        {
            Caption = 'Mobile Phone No';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        
            trigger OnValidate()
            begin
                if "Mobile Phone No" <> '' then
                    FieldLength("Mobile Phone No", 8, 20);

                "Mobile Phone No" := DelChr("Mobile Phone No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|-|_');

                if "Mobile Phone No" <> '' then begin
                    MemberApplication.Reset;
                    MemberApplication.SetRange(MemberApplication."Mobile Phone No", "Mobile Phone No");
                    MemberApplication.SetFilter(MemberApplication."Approval Status", '%1', MemberApplication."Approval Status"::Open);
                    if MemberApplication.Find('-') then begin
                        repeat
                            if (MemberApplication."Approval Status" in [MemberApplication."Approval Status"::Open, MemberApplication."Approval Status"::"Pending Approval",
                                MemberApplication."Approval Status"::Approved]) then
                                Error(MemberExistError, MemberApplication."Approval Status", MemberApplication."No.", MemberApplication.Name);
                        until MemberApplication.Next = 0;
                    end;
                    if "Mobile Phone No" <> '' then begin
                        if "Application Type" = "Application Type"::"New Member" then begin
                            Cust.Reset;
                            Cust.SetRange(Cust."Mobile Phone No", "Mobile Phone No");
                            Cust.SetFilter(Cust.Status, '<>%1', Cust.Status::Closed);
                            if Cust.FindFirst then
                                Error(MemberExistError, "Mobile Phone No", Cust."No.", Cust.Name);
                        end
                    end
                end;
            end;
        }
        field(50031; "Marital Status"; Enum "MaritalStatus")
        {
            Caption = 'Marital Status';
            DataClassification = CustomerContent;
        }
        field(50032; "Passport No."; Code[20])
        {
            Caption = 'Passport No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Passport No." <> '' then begin
                    if "Application Type" = "Application Type"::"New Member" then begin

                        Cust.Reset;
                        Cust.SetRange("Passport No.", "Passport No.");
                        if Cust.FindFirst then
                            Error(MemberExistError, "Passport No.", Cust."No.", Cust.Name);
                        case "Identification Type" of
                            "Identification Type"::Passport:
                                begin
                                    if Rec."ID No." = '' then
                                        Rec."ID No." := Rec."Passport No.";
                                end;
                        end;
                    end
                end;
            end;
        }
        field(50033; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50034; "First Name"; Text[20])
        {
            Editable = false;
            Caption = 'First Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50035; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50036; "Occupation"; Text[30])
        {
            Caption = 'Occupation';
            DataClassification = CustomerContent;
        }
        field(50037; "Designation"; Text[30])
        {
            Caption = 'Designation';
            DataClassification = CustomerContent;
        }
        field(50038; "Terms of Employment"; Enum "TermsOfEmployment")
        {
            Caption = 'Terms of Employment';
            DataClassification = CustomerContent;
        }
        field(50039; "Post Code"; Code[20])
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
        field(50040; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
            TableRelation = if (Nationality = const()) "Post Code".City
            else
            if (Nationality = filter(<> '')) "Post Code".City where("Country/Region Code" = field(Nationality));
            ValidateTableRelation = false;
        
            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", "Country/Region", Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50041; "Responsibility Center"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50042; "County"; Code[30])
        {
            Caption = 'County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
            DataClassification = CustomerContent;
        }
        field(50043; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Code Structure";
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50044; "Branch Code"; Code[20])
        {
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50045; "Recruited By"; Code[100])
        {
            Caption = 'Salesperson Code';
            TableRelation = IF ("Recruited by Type" = CONST(Marketer)) "Salesperson/Purchaser".Code
            ELSE
            IF ("Recruited by Type" = CONST(Members)) Member."No."
            ELSE
            IF ("Recruited by Type" = CONST(Others)) Customer."No.";
            DataClassification = CustomerContent;
        }
        field(50046; "Member Segment"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = filter(Contract | Permanent | Pension | Staff | "Board Member" | "Early Retirement" | Religion | Segment));
            Caption = 'Member Segment';
            DataClassification = CustomerContent;
        }
        field(50047; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Partnership,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor","Partnership","Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
            Caption = 'Type of Business';
            DataClassification = CustomerContent;
        }
        field(50048; "Other Business Type"; Text[15])
        {
            Caption = 'Other Business Type';
            DataClassification = CustomerContent;
        }
        field(50049; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares,Corporate';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares","Corporate";
            Caption = 'Ownership Type';
            DataClassification = CustomerContent;
        }
        field(50050; "Other Account Type"; Text[15])
        {
            Caption = 'Other Account Type';
            DataClassification = CustomerContent;
        }
        field(50051; "Nature of Business"; Text[30])
        {
            Caption = 'Nature of Business';
            DataClassification = CustomerContent;
        }
        field(50052; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if StrLen("Bank Account No.") > 14 then
                    Error(BankAccountErr);
            end;
        }
        field(50053; "Company Registration No."; Code[20])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Company Registration No." <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."Company Registration No.", "Company Registration No.");
                    if Cust.FindFirst then
                        Error(MemberExistError, "Company Registration No.", Cust."No.", Cust.Name);
                end;
                "ID No." := "Company Registration No.";
                "Passport No." := "Company Registration No.";
            end;
        }
        field(50054; "Date of Business Reg."; Date)
        {
            Caption = 'Date of Business Reg.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Date of Business Reg." > Today then
                    Error(DateofBirthError);
            end;
        }
        field(50055; "Business/Group Location"; Text[50])
        {
            Caption = 'Business/Group Location';
            DataClassification = CustomerContent;
        }
        field(50056; "PIN No."; Code[20])
        {
            Caption = 'PIN No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                if "PIN No." <> '' then begin
                    FieldLength("PIN No.", 7, 20);

                    Cust.Reset;
                    Cust.SetRange(Cust."PIN No.", "PIN No.");
                    if Cust.FindFirst then
                        Error(MemberExistError, "PIN No.", Cust."No.", Cust.Name);
                end;
            end;
        }
        field(50057; "Plot/Bldg/Street/Road"; Text[50])
        {
            Caption = 'Plot/Bldg/Street/Road';
            DataClassification = CustomerContent;
        }
        field(50058; "Group Type"; Option)
        {
            OptionCaption = ' Joint,Group';
            OptionMembers = " Joint","Group";
            Caption = 'Group Type';
            DataClassification = CustomerContent;
        }
        field(50059; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Joint,Multiple,Business';
            OptionMembers = "Joint","Multiple","Business";
            Caption = 'Single Party/Multiple/Business';
            DataClassification = CustomerContent;
        }
        field(50060; "Birth Certificate No."; Code[15])
        {
            Caption = 'Birth Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50061; "Group Account No."; Code[20])
        {
            TableRelation = Member."No." WHERE("Group Account" = CONST(true));
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }
        field(50062; "Created By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50063; "Application Source"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Navision,CRM,Web,Mobile';
            OptionMembers = " ","Navision","CRM","Web","Mobile";
            Caption = 'Application Source';
            DataClassification = CustomerContent;
        }
        field(50064; "Picture"; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(50065; "Signature"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50066; "Transaction Mobile No."; Code[13])
        {
            CharAllowed = '0123456789';
            Caption = 'Transaction Mobile No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if StrLen("Transaction Mobile No.") > 13 then begin
                    "Transaction Mobile No." := '';
                    Modify;
                end;
            end;
        }
        field(50067; "Group Account"; Boolean)
        {
            Caption = 'Group Account';
            DataClassification = CustomerContent;
        }
        field(50068; "Recruited by Type"; Option)
        {
            OptionCaption = 'Marketer,Members,Others';
            OptionMembers = "Marketer","Members","Others";
            Caption = 'Recruited by Type';
            DataClassification = CustomerContent;
        }
        field(50069; "Employer Name"; Text[50])
        {
            Caption = 'Employer Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50070; "Member Category"; Code[10])
        {
            TableRelation = "Member Category"."No.";
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
            end;
        }
        field(50071; "Old Member No."; Code[20])
        {
            Caption = 'Union Member No.';
            DataClassification = CustomerContent;
        }
        field(50072; "CRM Application No."; Code[50])
        {
            TableRelation = "CRM Application"."No." WHERE("Application Type" = CONST(Membership),
                                                           "Approval Status" = FILTER(Deffered | Open),
                                                           Created = CONST(false));
            Caption = 'CRM Application No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                AttachCrmApplicNo();
            end;
        }
        field(50073; "Salutation"; Code[50])
        {
            TableRelation = "Salutation Tittles".Code WHERE(Type = CONST(Tittle));
            Caption = 'Salutation';
            DataClassification = CustomerContent;
        }
        field(50074; "Pay Point"; Code[10])
        {
            Caption = 'Pay Point';
            DataClassification = CustomerContent;
            TableRelation = Customer where("Account Type" = filter(Employer));
        
            trigger OnValidate()
            var
                Cusr: Record Customer;
            begin
                IF Cusr.GET("Pay Point") THEN
                    "Pay Point Name" := Cusr.Name;
            end;
        }
        field(50075; "Pay Point Name"; Text[100])
        {
            Editable = false;
            Caption = 'Pay Point Name';
            DataClassification = CustomerContent;
        }
        field(50076; "ID Specimen [Front]"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50077; "ID Specimen [Back]"; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'ID Specimen [Back]';
        }
        field(50078; "Country/Region"; Text[100])
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
                    "Phone No." := CountryCode."Intrastat Code";
                "Mobile Phone No" := CountryCode."Intrastat Code";
            end;
        }
        field(50079; "Posted By"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
            Caption = 'Posted By';
        }
        field(50080; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50081; "Other Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Other Name';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50082; "Identification Type"; Enum "MemberIdentificationType")
        {
            DataClassification = CustomerContent;
            Caption = 'Identification Type';
        
            trigger OnValidate()
            begin
                "ID No." := '';
                "Passport No." := ''
            end;
        }
        field(50083; "Monthly Contribution"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Monthly Contribution';
        }
        field(50084; "Secondary E-Mail"; Text[50])
        {
            Caption = 'Secondary E-Mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("Secondary E-Mail");
            end;
        }
        field(50085; "Indemnity"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Indeminty';
        
            trigger OnValidate()
            var

            begin
                case Indemnity of
                    true:
                        begin

                        end;
                end;
            end;
        }
        field(50086; "Other Phone"; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(50087; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "New Member","Readmission";
        }
        field(50088; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Member."No." where(Status = filter(Withdrawn));
        }
        field(50089; "Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Expiry Date (Passport)';
        
            trigger OnValidate()
            begin
                if "Expiry Date" < Today then
                    Error('Expiry cannot be less than today');
            end;
        }
        field(50090; "Application Type"; Option)
        {
            OptionMembers = "New Member","Readmission";
        }
        field(50091; "Account No."; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Member where(Status = const(Withdrawn));
        
            trigger OnValidate()
            begin
                Cust.Reset();
                Cust.SetRange("No.", "Account No.");
                if Cust.FindFirst() then begin
                    CopyFromCustomerMemberLine(Cust);
                end;
            end;
        }
        field(50092; "Principal Member"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Member;
        
            trigger OnValidate()
            begin
                Rec.TestField("Member Category");
                if Type <> Type::"Next of KIN" then Error('This field only applies to next of Kin member category');
                PrincipalMemberDetails();
            end;
        }
        field(50093; "Type"; Enum "MemberCategoryType")
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            Editable = false;
        }
        field(50094; "Picture ID"; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(50095; "Signature ID"; MediaSet)
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Person;
        }
        field(50096; "Idemnity"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'High Risk Classified';
            Editable = false;
        }
        field(50097; "Contract End Date"; Date)
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
        field(50098; "Application Code"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin

            end;
        }

        field(50099; "Mode of Payment"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
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

            case "Customer Type" of
                "Customer Type"::" ",
                "Customer Type"::"Non-Member",
                "Customer Type"::Individual:
                    begin
                        SeriesSetup.TestField(SeriesSetup."Member Application Nos.");
                        "No. Series" := SeriesSetup."Member Application Nos.";
                        if NoSeriesMgt.AreRelated(SeriesSetup."Member Application Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;
                "Customer Type"::Corporate,
                "Customer Type"::Joint,
                "Customer Type"::Groups:
                    begin
                        SeriesSetup.TestField(SeriesSetup."Group Application Nos.");
                        "No. Series" := SeriesSetup."Group Application Nos.";
                        
                        if NoSeriesMgt.AreRelated(SeriesSetup."Group Application Nos.", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series")
                    end;
            end;
            fnValidateFields
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Member Application";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                
                SeriesSetup.Get();
                case "Customer Type" of
                    "Customer Type"::" ",
                    "Customer Type"::"Non-Member",
                    "Customer Type"::Individual:
                        begin
                            SeriesSetup.TestField(SeriesSetup."Member Application Nos.");
                            NoSeriesMgt.TestManual(SeriesSetup."Member Application Nos.");
                            "No. Series" := '';
                        end;
                    "Customer Type"::Corporate,
                    "Customer Type"::Joint,
                    "Customer Type"::Groups:
                        begin
                            SeriesSetup.TestField(SeriesSetup."Group Application Nos.");
                            NoSeriesMgt.TestManual(SeriesSetup."Group Application Nos.");
                            "No. Series" := '';
                        end;
                end;
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Member Application"; xRecRef: Record "Member Application"; var IsHandled: Boolean)
    begin
    end;




    trigger OnModify()
    begin
        "Created By" := UserId;
        "Application Date" := Today;
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Cust: Record Member;
        PostCode: Record "Post Code";
        ProductFactory: Record "Product Factory";
        GeneralSetUp: Record "General Set-Up";
        DateofBirthError: Label 'Date cannot be greater than today.';
        MinimumAgeError: Label 'Date of birth must not be less than %1';
        MemberExistError: Label '%1 Already exists with member %2 Name: %3';
        Customer: Record Customer;
        HighRiskCust: Record "High Risk Customer";
        MemberApplication: Record "Member Application";
        BankAccountErr: Label 'Bank Account No cannot be more then 14 characters.';
        RegistryMngt: Codeunit "Registry Mngt.";
        RegMngt: Codeunit "Register Management";
        Varvariant: Variant;
        Gensetup: Record "General Set-Up";


    procedure FieldLength(VarVariant: Text; MinLength: Integer; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be less than %1 or more than %2 Characters.';
    begin
        if (StrLen(VarVariant) < MinLength) or (StrLen(VarVariant) > FldLength) then
            Error(FieldLengthError, MinLength, FldLength);
    end;

    local procedure NameBreakdownTxt()
    var
        NamePart: array[30] of Text[100];
        TempName: Text[250];
        FirstName250: Text[250];
        i: Integer;
        NoOfParts: Integer;
    begin
        case "Customer Type" of
            "Customer Type"::Individual:
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
                    "Other Name" := '';
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
        end;
    end;


    procedure CheckBlockedCustOnJnls(App: Record "Member Application"; DocNo: Code[20]): Boolean
    var
        Approval: Record "Posted Approval Entries";
    begin
        Approval.Reset;
        Approval.SetRange("Document No.", DocNo);
        Approval.SetRange(Status, Approval.Status::Approved);
        if not Approval.FindFirst then begin
            exit(false)
        end else begin
            exit(true)
        end
    end;


    procedure CheckMinimumRegistrationEntry()
    var
        NextofKINApplication: Record "Next of KIN Application";
        NextofKinError: Label 'You must specify next of Kin for this application.';
        Appsignatories: Record "Signatory Application";
        ErrorOnMissingAppsigTxt: Label 'You must specify signatories for this application.';
        ErrorOnMissingAppsig: Label 'You must specify Risk Assessment for this application.';
        MonthlyContrib: Record "Monthly Contribution Applic.";
        ErrorOnMissMonthlyContrib: Label 'Member monthly contribution must have a Value in %1. it cannot be blank';
        ErrorOnMinNoOfAccSigText: Label 'Minimum No. of signatory must not be less than %1';
        VarVariant: Variant;
        SendNotif: Codeunit "SMS Notification";
        CustomerBank: Record "Cust. Bank Account";
        RiskMatrix: Record "Risk Assessment Matrix";
        ErrorOnMissCustBank: Label 'Bank Accounts Information must be provided. %1. it cannot be blank';
        ErrorOnMissingRiskAssessment: Label 'Risk Assessment Information missing in %1. it cannot be blank';
        ErrorOnMissingDefaultAccount: Label 'No Default account found. it cannot be blank';
        DefaultAcc: Record "Default Accounts Application";

    begin

        TestField(Name);
        TestField("E-Mail");
        TestField("Mobile Phone No");
        DefaultAcc.SetRange("No.", Rec."No.");
        if not DefaultAcc.Find('-') then
            Error(ErrorOnMissingDefaultAccount);

        case "Group Account" of
            false:
                begin
                    TestField("ID No.");
                    TestField("Date of Birth");
                    TestField("Picture ID");
                    TestField("Member Category");
                    TestField("Member Segment");
                    TestField("Signature ID");
                    TestField(Name);
                    TestField("Payroll No.");
                    TestField("Customer Type");
                    TestField("Mobile Phone No");
                    if Rec."Terms of Employment" = Rec."Terms of Employment"::Contract then
                        TestField("Contract End Date");
                    if Nationality = 'KE' then begin
                        TestField("PIN No.");
                    end else begin
                        if "Country/Region" = 'KE' then begin
                            TestField("PIN No.");
                        end;
                    end;

                    TestField(Gender);
                    TestField("Employer Code");
                    TestField("Identification Type");
                    if "Identification Type" = "Identification Type"::Passport then
                        TestField("Expiry Date");
                    if Type = Type::"Next of KIN" then
                        TestField("Principal Member");

                    NextofKINApplication.Reset;
                    NextofKINApplication.SetRange("Account No", "No.");
                    NextofKINApplication.SetRange(Type, NextofKINApplication.Type::"Next of Kin");
                    if not NextofKINApplication.FindFirst then
                        Error(NextofKinError);

                    NextofKINApplication.Reset;
                    NextofKINApplication.SetRange("Account No", "No.");
                    NextofKINApplication.SetRange(Type, NextofKINApplication.Type::"Next of Kin");
                    if NextofKINApplication.Find('-') then begin
                        repeat
                            NextofKINApplication.TestField(Relationship);
                            NextofKINApplication.TestField(Name);
                            if NextofKINApplication.Beneficiary then
                                NextofKINApplication.TestField(Allocation);
                        until NextofKINApplication.Next = 0;
                    end;

                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", "No.");
                    if not MonthlyContrib.FindFirst() then begin
                        Error(ErrorOnMissMonthlyContrib, "No.");
                    end;

                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", "No.");
                    if MonthlyContrib.FindFirst() then begin
                        repeat
                            MonthlyContrib.TestField(Amount);
                            MonthlyContrib.TestField(Type);
                        until MonthlyContrib.Next() = 0;
                    end;

                    /* CustomerBank.Reset();
                    CustomerBank.SetRange("Customer No.", Rec."No.");
                    if not CustomerBank.Find('-') then
                        Error(ErrorOnMissCustBank, Rec."No.");

                    CustomerBank.Reset();
                    CustomerBank.SetRange("Customer No.", Rec."No.");
                    if CustomerBank.Find('-') then begin
                        repeat
                            CustomerBank.TestField("Bank Account No.");
                            CustomerBank.TestField(Code);
                            CustomerBank.TestField("Bank Branch No.");
                        until CustomerBank.Next() = 0;
                    end; */

                    /* RiskMatrix.Reset();
                    RiskMatrix.SetRange("Account No.", Rec."No.");
                    if not RiskMatrix.Find('-') then
                        Error(ErrorOnMissingAppsig, Rec."No."); */

                    Case Indemnity of
                        true:
                            begin
                                VarVariant := Rec;
                                //if Rec."E-Mail" <> '' then
                                //SendNotif.SendEmailNotification(VarVariant, 1, Rec."No.");
                            end;
                    end;
                end;
            true:
                begin
                    GeneralSetUp.Get();
                    GeneralSetUp.TestField("Min No. of Kin-Signatory");
                    TestField("Company Registration No.");
                    TestField("Ownership Type");
                    TestField("Company Registration No.");
                    Appsignatories.Reset;
                    Appsignatories.SetRange("Account No.", "No.");
                    if not Appsignatories.FindFirst then
                        Error(ErrorOnMissingAppsigTxt);

                    Appsignatories.Reset;
                    Appsignatories.SetRange("Account No.", "No.");
                    if Appsignatories.Find('-') then begin
                        if Appsignatories.Count < GeneralSetUp."Min No. of Kin-Signatory" then
                            error(ErrorOnMinNoOfAccSigText, GeneralSetUp."Min No. of Kin-Signatory");
                        repeat
                            Appsignatories.TestField(Names);
                            Appsignatories.TestField("Date Of Birth");
                            Appsignatories.TestField("ID No.");
                            Appsignatories.TestField(Picture);
                            Appsignatories.TestField(Signature);
                        until Appsignatories.Next = 0;
                    end
                end;
        end
    end;

    procedure fnValidateFields()
    var
        UserSetup: Record "User Setup";
        MContributions: Record "Monthly Contribution Applic.";
        AutoOpenSavingAccs: Record "Default Accounts Application";
    begin
        GeneralSetUp.Get();
        GeneralSetUp.TestField("Application Source (Member)");
        "Application Date" := Today;
        "Created By" := UserId;

        UserSetup.Get(UserId);
        UserSetup.TestField(UserSetup."Global Dimension 1 Code");
        UserSetup.TestField(UserSetup."Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Center" := UserSetup."Responsibility Centre";

        case GeneralSetUp."Application Source (Member)" of
            GeneralSetUp."Application Source (Member)"::CBS:
                "Application Source" := "Application Source"::Navision;

            GeneralSetUp."Application Source (Member)"::CRM:
                "Application Source" := "Application Source"::CRM;

            GeneralSetUp."Application Source (Member)"::Mobile:
                "Application Source" := "Application Source"::Mobile;

            GeneralSetUp."Application Source (Member)"::Online:
                "Application Source" := "Application Source"::Web;
        end;

        case "Customer Type" of

            "Customer Type"::"Non-Member",
            "Customer Type"::" ",
                "Customer Type"::Individual:
                begin
                    ProductFactory.SetRange(ProductFactory."Auto Open Account", true);
                    ProductFactory.SetRange(ProductFactory.Status, ProductFactory.Status::Active);
                    ProductFactory.SetFilter("Account Dimension", '<>%1', ProductFactory."Account Dimension"::"Micro Credit");
                    if ProductFactory.Find('-') then begin
                        repeat

                            ProductFactory.TestField("Minimum Contribution");
                            RegistryMngt.fnCreateDefaultAccount("No.",
                            ProductFactory."Loan Disbursement Account",
                            ProductFactory."Minimum Contribution",
                            ProductFactory."Product ID",
                            ProductFactory."Account Dimension",
                            ProductFactory."Account Category");

                            case ProductFactory."Account Dimension" of
                                productfactory."Account Dimension"::"Micro Credit",
                                    productfactory."Account Dimension"::Credit:
                                    begin
                                        RegistryMngt.fnCreateDefaultContribution("No.",
                                        ProductFactory."Account Category",
                                        ProductFactory."Minimum Contribution");
                                    end;
                            end;
                        until ProductFactory.Next = 0;
                    end;
                    RegistryMngt.fnCreateRiskAssesmentMatrix("No.");
                end;
            "Customer Type"::Joint,
            "Customer Type"::Corporate,
                "Customer Type"::Groups:
                begin
                    ProductFactory.SetRange(ProductFactory."Auto Open Account", true);
                    ProductFactory.SetRange(ProductFactory.Status, ProductFactory.Status::Active);
                    ProductFactory.SetFilter("Account Dimension", '<>%1', ProductFactory."Account Dimension"::Credit);
                    if ProductFactory.Find('-') then begin
                        repeat

                            ProductFactory.TestField("Minimum Contribution");
                            RegistryMngt.fnCreateDefaultAccount("No.",
                            ProductFactory."Loan Disbursement Account",
                            ProductFactory."Minimum Contribution",
                            ProductFactory."Product ID",
                            ProductFactory."Account Dimension",
                            ProductFactory."Account Category");

                            case ProductFactory."Account Dimension" of
                                productfactory."Account Dimension"::"Micro Credit",
                                    productfactory."Account Dimension"::Credit:
                                    begin
                                        RegistryMngt.fnCreateDefaultContribution("No.",
                                        ProductFactory."Account Category",
                                        ProductFactory."Minimum Contribution");
                                    end;
                            end;
                        until ProductFactory.Next = 0;
                    end;
                end;
        end;

        if not Rec."Group Account" then begin
            AutoOpenSavingAccs.Reset();
            AutoOpenSavingAccs.SetRange("No.", Rec."No.");
            AutoOpenSavingAccs.SetRange("Account Category", AutoOpenSavingAccs."Account Category"::"Money Market");
            if AutoOpenSavingAccs.FindFirst() then
                AutoOpenSavingAccs.Delete();

            MContributions.Reset();
            MContributions.SetRange("Account No.", Rec."No.");
            MContributions.SetRange(Type, MContributions.Type::"Money Market");
            if MContributions.FindFirst() then
                MContributions.Delete()
        end;
    end;

    procedure fnValidateID()
    begin
        if not "Group Account" then begin
            case "Identification Type" of
                "Identification Type"::"National ID":
                    begin
                        "ID No." := DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                        IF "ID No." <> '' then
                            FieldLength("ID No.", 7, 20);
                        Idemnity := false;

                        if "ID No." <> '' then begin
                            HighRiskCust.Reset();
                            HighRiskCust.SetRange("No.", "ID No.");
                            if HighRiskCust.FindFirst() then begin
                                Idemnity := true;
                            end
                        end;
                    end;
                "Identification Type"::Passport:
                    begin
                        "Passport No." := "ID No."
                    end;
            end
        end;

        if "ID No." <> '' then begin
            MemberApplication.Reset;
            MemberApplication.SetRange(MemberApplication."ID No.", "ID No.");
            MemberApplication.SetFilter(MemberApplication."Approval Status", '%1', MemberApplication."Approval Status"::Open);
            if MemberApplication.Find('-') then begin
                repeat
                    if (MemberApplication."Approval Status" in [MemberApplication."Approval Status"::Open, MemberApplication."Approval Status"::"Pending Approval",
                                                     MemberApplication."Approval Status"::Approved]) then
                        Error(MemberExistError, MemberApplication."No.", MemberApplication.Name);
                until MemberApplication.Next = 0;
            end;
            if "Application Type" = "Application Type"::"New Member" then begin

                Cust.Reset;
                Cust.SetRange(Cust."ID No.", "ID No.");
                if Cust.FindFirst then begin
                    Error(MemberExistError, "ID No.", Cust."No.", Cust.Name);
                end;
            end;
        end;
    end;

    local procedure CheckSpecialCharacters(FieldCode: Code[50]): Boolean
    var
        SpecialCharacters: Text;
    begin
        SpecialCharacters := '!@#$%^&*()_-+=[{]};:<>|./?';
    end;

    procedure CopyFromCustomerMemberLine(MemberApplication: Record Member)
    var
        ImageData: Record "Image Data";
        MonthlyContrib: Record "Member Monthly Contribution";
        ApplicationContrib: Record "Monthly Contribution Applic.";
        KinDetail: Record "Next of KIN";
        KinApplication: Record "Next of KIN Application";
        Contribt: Record "Member Monthly Contribution";
        VarVariant: Variant;
    begin

        "Single Party/Multiple/Business" := MemberApplication."Single Party/Multiple";
        Validate(Name, MemberApplication.Name);
        Validate("ID No.", MemberApplication."ID No.");
        Validate("Passport No.", MemberApplication."Passport No.");
        "Pay Point" := MemberApplication."Pay Point";
        "Date of Birth" := MemberApplication."Date of Birth";
        "PIN No." := MemberApplication."PIN No.";
        "Identification Type" := MemberApplication."Identification Type";
        "Pay Point Name" := MemberApplication."Pay Point Name";
        Gender := MemberApplication.Gender;
        "Passport No." := MemberApplication."Passport No.";
        County := MemberApplication.County;
        "Old Member No." := MemberApplication."Union Member No.";
        "Phone No." := MemberApplication."Phone No.";
        "Mobile Phone No" := MemberApplication."Mobile Phone No";
        "Current Address" := MemberApplication."Current Address";
        "Mobile Phone No" := MemberApplication."Mobile Phone No";
        "Post Code" := MemberApplication."Post Code";
        "Mode of Payment" := MemberApplication."Mode of Payment";
        "Contract End Date" := MemberApplication."Contract End Date";
        City := MemberApplication.City;
        Designation := MemberApplication.Designation;
        "Recruited by Type" := MemberApplication."Recruited by Type";
        Nationality := MemberApplication.Nationality;
        "Marital Status" := MemberApplication."Marital Status";
        "Member Segment" := MemberApplication."Member Segment";
        "Member Category" := MemberApplication."Member Category";
        "Responsibility Center" := MemberApplication."Responsibility Center";
        "Employer Code" := MemberApplication."Employer Code";
        "Home Address" := MemberApplication."Home Address";
        "Payroll No." := MemberApplication."Payroll/Staff No.";
        "Recruited By" := MemberApplication."Recruited By";
        "Marital Status" := MemberApplication."Marital Status";
        Gender := MemberApplication.Gender;
        "Contract End Date" := MemberApplication."Contract End Date";

        "Country/Region" := MemberApplication."Country/Region";
        "Type of Business" := MemberApplication."Type of Business";
        "Other Business Type" := MemberApplication."Other Business Type";
        "Ownership Type" := MemberApplication."Ownership Type";
        "Other Account Type" := MemberApplication."Other Account Type";
        "Nature of Business" := MemberApplication."Nature of Business";
        "Business/Group Location" := MemberApplication."Business/Group Location";
        "Plot/Bldg/Street/Road" := MemberApplication."Plot/Bldg/Street/Road";
        "Group Account" := MemberApplication."Group Account";
        "Terms of Employment" := MemberApplication."Terms of Employment";

        "Group Type" := MemberApplication."Group Type";
        "Identification Type" := MemberApplication."Identification Type";
        "Group Account" := MemberApplication."Group Account";
        "Bank Code" := MemberApplication."Bank Code";
        "Branch Code" := MemberApplication."Branch Code";
        "Bank Account No." := MemberApplication."Bank Account No.";
        "Created By" := UserId;
        "Country/Region" := MemberApplication."Country/Region";
        County := MemberApplication.County;
        "E-Mail" := MemberApplication."E-Mail";
        "Station/Department" := MemberApplication."Station/Department";
        "Secondary E-Mail" := MemberApplication."E-mail (Personal)";
        Salutation := MemberApplication.Salutation;
        "Customer Type" := MemberApplication."Customer Type";

        ImageData.Reset();
        ImageData.SetRange("Member No.", "Account No.");
        if ImageData.FindFirst() then begin
            Picture := ImageData.Picture;
            Signature := ImageData.Signature
        end;

        KinDetail.Reset();
        KinDetail.SetRange("Account No", "Account No.");
        if KinDetail.FindSet() then begin
            KinDetail.DeleteAll();
        end;

        Contribt.Reset();
        Contribt.SetRange("Account No.", "Account No.");
        if Contribt.FindSet() then begin
            Contribt.DeleteAll();
        end;
    end;

    procedure AttachCrmApplicNo()
    var
        RecRef: RecordRef;
        MemberAppl: Record "Member Application";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this response.', Comment = 'Record type Customer is not supported by this workflow response.';
        CRMApplication: Record "CRM Application";
        ErrorOnExistingApplicationTxt: Label 'Apllication already attached to application No. %1-%2';
        AccountApplication: Record "Account Application";
        Gensetup: Record "General Set-Up";
        App: Record "Member Application";
        Err002: Label 'CRM application is already in use by Loan No. %1';
    begin
        Gensetup.Get();
        Gensetup.TestField("Application Source (Member)");
        case Gensetup."Application Source (Member)" of
            Gensetup."Application Source (Member)"::CRM:
                begin

                    App.Reset;
                    App.SetRange("CRM Application No.", "CRM Application No.");
                    if App.Find('-') then begin
                        if "CRM Application No." <> '' then
                            Error(Err002, App."No.");
                    end;
                    CRMApplication.Reset;
                    CRMApplication.SetRange(Created, false);
                    CRMApplication.SetRange("No.", "CRM Application No.");
                    if CRMApplication.FindFirst then begin
                        CRMApplication.fnValidateMinRequiredItems;
                        Validate(Name, CRMApplication.Name);
                        Validate("Identification Type", CRMApplication."Identification Type");
                        case CRMApplication."Identification Type" of
                            CRMApplication."Identification Type"::"National ID":
                                begin
                                    Validate("ID No.", CRMApplication."ID No.");
                                end else begin
                                Validate("Passport No.", CRMApplication."ID No.");
                            end;
                        end;
                    end;

                end;
        end

    end;

    procedure CopyIndividualEntriesFromCustMember(CustomerRecord: Record Member)
    var
        ImageMedia: Record "Image Data";
        ImageData: Record "Image Data";
        KinDetail: Record "Next of KIN";
        KinDetails: Record "Next of KIN";
        Contribt: Record "Member Monthly Contribution";
        MonthlyContrib: Record "Monthly Contribution Applic.";
        Contribution: Record "Member Monthly Contribution";
        AccountB: Record "Account Banking";
        CredAc: Record "Account Credit";
        Applic: Record "Member Application";
        FactP: Record "Product Factory";
        Notif: Codeunit "SMS Notification";
        CustBankAcc: Record "Cust. Bank Account";
    begin
        if CustomerRecord.Get("Account No.") then begin
            Varvariant := Rec;

            if Name <> UpperCase(CustomerRecord.Name) then
                CustomerRecord.Name := UpperCase(Name);
            if CustomerRecord."Date of Birth" <> "Date of Birth" then
                CustomerRecord."Date of Birth" := "Date of Birth";
            if "ID No." <> CustomerRecord."ID No." then
                CustomerRecord."ID No." := "ID No.";
            if "PIN No." <> CustomerRecord."ID No." then
                CustomerRecord."PIN No." := "PIN No.";
            if "Pay Point" <> CustomerRecord."Pay Point" then
                CustomerRecord."Pay Point" := "Pay Point";
            if Gender <> CustomerRecord.Gender then
                CustomerRecord.Gender := Gender;
            if "Contract End Date" <> CustomerRecord."Contract End Date" then
                CustomerRecord."Contract End Date" := "Contract End Date";
            if "Passport No." <> CustomerRecord."Passport No." then
                CustomerRecord."Passport No." := "Passport No.";
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
            if Designation <> CustomerRecord.Designation then
                CustomerRecord.Designation := Designation;

            if "Recruited By Type" <> CustomerRecord."Recruited by Type" then
                CustomerRecord."Recruited by Type" := "Recruited By Type";
            if "Recruited By" <> CustomerRecord."Recruited By" then
                CustomerRecord."Recruited By" := "Recruited By";
            if "Country/Region" <> CustomerRecord."Country/Region" then
                CustomerRecord."Country/Region" := "Country/Region";
            if County <> CustomerRecord.County then
                CustomerRecord.County := County;

            if Nationality <> CustomerRecord.Nationality then
                CustomerRecord.Nationality := Nationality;
            if "Marital Status" <> CustomerRecord."Marital Status" then
                CustomerRecord."Marital Status" := "Marital Status";
            if "Member Segment" <> CustomerRecord."Member Segment" then
                CustomerRecord."Member Segment" := "Member Segment";
            if "Member Category" <> CustomerRecord."Member Category" then
                CustomerRecord."Member Category" := "Member Category";
            if "Employer Code" <> CustomerRecord."Employer Code" then
                CustomerRecord."Employer Code" := "Employer Code";
            if "Home Address" <> CustomerRecord."Home Address" then
                CustomerRecord."Home Address" := "Home Address";
            if "Payroll No." <> CustomerRecord."Payroll/Staff No." then
                CustomerRecord."Payroll/Staff No." := "Payroll No.";
            if "E-Mail" <> CustomerRecord."E-Mail" then
                CustomerRecord."E-Mail" := "E-Mail";
            if Salutation <> CustomerRecord.Salutation then
                CustomerRecord.Salutation := Salutation;
            if "Station/Department" <> CustomerRecord."Station/Department" then
                CustomerRecord."Station/Department" := "Station/Department";
            if "Secondary E-Mail" <> CustomerRecord."E-mail (Personal)" then
                CustomerRecord."E-mail (Personal)" := "Secondary E-Mail";

            if "Bank Code" <> CustomerRecord."Bank Code" then
                CustomerRecord."Bank Code" := "Bank Code";
            if "Branch Code" <> CustomerRecord."Branch Code" then
                CustomerRecord."Branch Code" := "Branch Code";
            if "Bank Account No." <> CustomerRecord."Bank Account No." then
                CustomerRecord."Bank Account No." := "Bank Account No.";
            if CustomerRecord."Terms of Employment" <> "Terms of Employment" then
                CustomerRecord."Terms of Employment" := "Terms of Employment";

            if "Marital Status" <> CustomerRecord."Marital Status" then
                CustomerRecord."Marital Status" := "Marital Status";
            if Gender <> CustomerRecord.Gender then
                CustomerRecord.Gender := Gender;
            CustomerRecord.Rejoined := true;

            CredAc.Reset();
            CredAc.SetRange("Member No.", CustomerRecord."No.");
            CredAc.SetRange("Account Category", CredAc."Account Category"::"Shares Capital");
            if CredAc.FindFirst() then begin
                CredAc.CalcFields("Balance (LCY)");
                if FactP.Get(CredAc."Product Type") then
                    FactP.TestField("Minimum Balance");
                CredAc.ModifyAll(Blocked, CredAc.Blocked::" ");
                CredAc.ModifyAll(Status, CredAc.Status::New);
            end;

            CustomerRecord.Status := CustomerRecord.Status::New;
            CustomerRecord.Blocked := CustomerRecord.Blocked::" ";
            CustomerRecord."Rejoining Date" := Today;
            CustomerRecord.Modify;

            CustBankAcc.Reset();
            CustBankAcc.SetRange("Customer No.", "No.");
            if CustBankAcc.FindSet() then begin
                CustBankAcc.ModifyAll("Member No.", CustomerRecord."No.");
            end;

            Contribt.Reset();
            Contribt.SetRange("Account No.", CustomerRecord."No.");
            Contribt.DeleteAll();

            ImageData.Reset();
            ImageData.SetRange("Member No.", CustomerRecord."No.");
            if ImageData.Find('-') then
                ImageData.Delete();

            AccountB.Reset;
            AccountB.SetRange("Member No.", CustomerRecord."No.");
            if AccountB.Find('-') then begin
                repeat
                    AccountB.Validate(Name, Name);
                    AccountB."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    AccountB."Group Account No" := "Group Account No.";
                    AccountB."Group Account" := "Group Account";
                    AccountB."ID/Passport No." := "ID No.";
                    AccountB."Mobile No." := "Mobile Phone No";
                    AccountB."Date of Birth" := "Date of Birth";
                    AccountB."Employer Code" := "Employer Code";
                    if AccountB."Account Category" = AccountB."Account Category"::Savings then begin
                        AccountB.Status := AccountB.Status::New;
                    end;
                    AccountB.Modify;
                until AccountB.Next = 0;
            end;

            CredAc.Reset;
            CredAc.SetRange("Member No.", CustomerRecord."No.");
            if CredAc.Find('-') then begin
                repeat
                    CredAc.Validate(Name, Name);
                    CredAc."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    CredAc."Group Account No." := "Group Account No.";
                    CredAc."Group Account" := "Group Account";
                    CredAc."ID/Passport No." := "ID No.";
                    CredAc."Mobile No." := "Mobile Phone No";
                    CredAc."Date of Birth" := "Date of Birth";
                    CredAc."Employer Code" := "Employer Code";
                    CredAc.Status := CredAc.Status::New;
                    CredAc.Modify;

                    MonthlyContrib.LockTable();
                    MonthlyContrib.Reset();
                    MonthlyContrib.SetRange("Account No.", "No.");
                    if MonthlyContrib.FindFirst() then begin
                        Contribution.Init();
                        Contribution.Type := CredAc."Account Category";
                        Contribution.Amount := MonthlyContrib.Amount;
                        Contribution.Remarks := MonthlyContrib.Remarks;
                        Contribution.Type := CredAc."Account Category";
                        Contribution."Account No." := CustomerRecord."No.";
                        Contribution."Application No." := CredAc."No.";
                        Contribution.Insert(true);
                    end;
                until CredAc.Next = 0;
            end;

            ImageMedia.LockTable;
            ImageMedia.Init();
            ImageMedia.Picture := Picture;
            ImageMedia.Signature := Signature;
            ImageData."Signature ID" := "Signature ID";
            ImageData."Picture ID" := "Picture ID";
            ImageMedia."Member No." := CustomerRecord."No.";
            ImageMedia."ID No." := CustomerRecord."ID No.";
            ImageMedia.Insert(true);

            if Applic.Get("No.") then begin
                Applic."Approval Status" := Applic."Approval Status"::Posted;
                Applic."Date Posted" := CurrentDateTime;
                Applic."Posted By" := UserId;
                Applic.Modify(true);
                Varvariant := Applic;
                //Notif.SendEmailNotification(Varvariant, 0, Applic."No.");
            end;
            Message('Process Complete. Application successfully Posted.');
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
            if CustomerRecord."Contract End Date" <> "Contract End Date" then
                CustomerRecord."Contract End Date" := "Contract End Date";
            if CustomerRecord."Terms of Employment" <> "Terms of Employment" then
                CustomerRecord."Terms of Employment" := "Terms of Employment";

            if "Recruited By Type" <> CustomerRecord."Recruited by Type" then
                CustomerRecord."Recruited by Type" := "Recruited By Type";
            if "Recruited By" <> CustomerRecord."Recruited By" then
                CustomerRecord."Recruited By" := "Recruited By";

            if "Home Address" <> CustomerRecord."Home Address" then
                CustomerRecord."Home Address" := "Home Address";

            if "E-Mail" <> CustomerRecord."E-Mail" then
                CustomerRecord."E-Mail" := "E-Mail";
            if "Single Party/Multiple/Business" <> CustomerRecord."Single Party/Multiple" then
                CustomerRecord."Single Party/Multiple" := "Single Party/Multiple/Business";
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
            CustomerRecord.Modify;
            RegMngt.fnPostAccountchanges(Varvariant,
            CustomerRecord.Name, CustomerRecord."Global Dimension 2 Code", 0,
            CustomerRecord."Group Account No.", CustomerRecord."Group Account",
            CustomerRecord."ID No.", CustomerRecord."Mobile Phone No",
            CustomerRecord."Employer Code", CustomerRecord."Date of Birth", CustomerRecord."Phone No.")
        end;
    end;

    local procedure PrincipalMemberDetails()
    var
        CustMember: Record Member;
        KinDetail: Record "Next of KIN Application";
    begin
        if CustMember.Get("Principal Member") then begin

            KinDetail.Init();
            KinDetail."Account No" := "No.";
            KinDetail.Name := CustMember.Name;
            KinDetail."ID No." := CustMember."ID No.";
            KinDetail."Date of Birth" := CustMember."Date of Birth";
            KinDetail.Address := CustMember."Current Address";
            KinDetail.Type := KinDetail.Type::"Next of Kin";
            KinDetail."Kin Type" := KinDetail."Kin Type"::Referee;
            KinDetail."Post Code" := CustMember."Post Code";
            KinDetail.Email := CustMember."E-Mail";
            KinDetail.Telephone := CustMember."Mobile Phone No";
            KinDetail.Beneficiary := true;
            KinDetail."Principal Member" := CustMember."No.";
            KinDetail.Allocation := 100;
            KinDetail.Insert(true)
        end else begin
            Error('No Principal Member found');
        end;
    end;
}




