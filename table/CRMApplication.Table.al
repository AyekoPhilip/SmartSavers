table 50484 "CRM Application"
{
    DrillDownPageID = "CRM Application List";
    LookupPageID = "CRM Application List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Application Form No."; Code[100])
        {
            Editable = true;
            Caption = 'Application Form No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Captured By"; Code[100])
        {
            Editable = true;
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50012; "Date"; DateTime)
        {
            Editable = true;
            Enabled = true;
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Member No."; Code[100])
        {
            Editable = true;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Created"; Boolean)
        {
            Editable = false;
            Caption = 'Created';
            DataClassification = CustomerContent;
        }
        field(50015; "Application Type"; Enum "CrmApplicationType")
        {
            Caption = 'Application Type';
            DataClassification = CustomerContent;
        }
        field(50016; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50017; "Time"; Time)
        {
            Caption = 'Time';
            DataClassification = CustomerContent;
        }
        field(50018; "Source"; Option)
        {
            OptionMembers = "BOSA","FOSA","INVESTMENT","MICRO";
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(50019; "Product Type"; Code[100])
        {
            Caption = 'Product Factory';
            Editable = true;
            TableRelation = "Product Factory";
            DataClassification = CustomerContent;
        }
        field(50020; "Payroll No."; Code[100])
        {
            Caption = 'Payroll No.';
            DataClassification = CustomerContent;
        }
        field(50021; "ID No."; Code[100])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50022; "Certificate No."; Code[100])
        {
            Caption = 'Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Amount On"; Decimal)
        {
            Caption = 'Amount On';
            DataClassification = CustomerContent;
        }
        field(50024; "Closure Type"; Option)
        {
            OptionCaption = 'Normal,Retirement,Business loans,Risk';
            OptionMembers = "Normal","Retirement","Business loans","Risk";
            Caption = 'Closure Type';
            DataClassification = CustomerContent;
        }
        field(50025; "Buyer No."; Code[100])
        {
            Caption = 'Buyer No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Buyer ID No."; Code[100])
        {
            Caption = 'Buyer ID No.';
            DataClassification = CustomerContent;
        }
        field(50027; "Adviced"; Boolean)
        {
            Caption = 'Adviced';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                "Date Adviced" := Today;
                "Time Adviced" := Time;
                "Adviced By" := UserId;
                Modify;
            end;
        }
        field(50028; "Date Adviced"; Date)
        {
            Caption = 'Date Adviced';
            DataClassification = CustomerContent;
        }
        field(50029; "Time Adviced"; Time)
        {
            Caption = 'Time Adviced';
            DataClassification = CustomerContent;
        }
        field(50030; "Adviced By"; Code[100])
        {
            Caption = 'Adviced By';
            DataClassification = CustomerContent;
        }
        field(50031; "Modification Type"; Option)
        {
            OptionCaption = 'Member Details,BBF Details';
            OptionMembers = "Member Details","BBF Details";
            Caption = 'Modification Type';
            DataClassification = CustomerContent;
        }
        field(50032; "Shedule Type"; Option)
        {
            OptionCaption = 'Normal Transfer,Institutional Capital Transfer';
            OptionMembers = "Normal Transfer","Institutional Capital Transfer";
            Caption = 'Shedule Type';
            DataClassification = CustomerContent;
        }
        field(50033; "In coming Guarantor No."; Code[100])
        {
            Caption = 'In coming Guarantor No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Replaced Guarantor No."; Code[100])
        {
            Caption = 'Replaced Guarantor No.';
            DataClassification = CustomerContent;
        }
        field(50035; "Temp. Name"; Code[100])
        {
            Caption = 'Temp. Name';
            DataClassification = CustomerContent;
        }
        field(50036; "Case360_Docs"; Integer)
        {
            Caption = 'Case360_Docs';
            DataClassification = CustomerContent;
        }
        field(50037; "User ID"; Code[80])
        {
            TableRelation = "User Setup"."User ID";
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50038; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50039; "Loan status"; Enum "LoanStatus")
        {
            FieldClass = Normal;
            Caption = 'Loan status';
            DataClassification = CustomerContent;
        }
        field(50040; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        }
        field(50041; "Amount Off"; Decimal)
        {
            Caption = 'Amount Off';
            DataClassification = CustomerContent;
        }
        field(50042; "First Name"; Text[50])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50043; "Second Name"; Text[30])
        {
            Caption = 'Second Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Second Name" := DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50044; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Last Name" := DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Name := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' + DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50045; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50046; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50047; "Customer Type"; Option)
        {
            OptionCaption = ' ,Individual,Joint,Corporate,Group';
            OptionMembers = " ","Individual","Joint","Corporate","Group";
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
        }
        field(50048; "Employer Code"; Code[20])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Customer.Get("Employer Code") then begin
                    "Employer Name" := Customer.Name;
                end;
            end;
        }
        field(50049; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" > Today then
                    Error(DateofBirthError);

                GeneralSetUp.Get;
                if "Date of Birth" > CalcDate(GeneralSetUp."Min. Member Age", Today) then
                    Error(MinimumAgeError, CalcDate(GeneralSetUp."Min. Member Age", Today));
            end;
        }
        field(50050; "E-Mail"; Text[50])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(50051; "Station/Department"; Code[20])
        {
            TableRelation = Customer;
            Caption = 'Station/Department';
            DataClassification = CustomerContent;
        }
        field(50052; "Nationality"; Code[20])
        {
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
            Caption = 'Nationality';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //IF CountryRegion.GET(Nationality) THEN
                // "Mobile Phone No":=CountryRegion."County Phone Code";
            end;
        }
        field(50053; "Gender"; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ","Male","Female";
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50054; "Occupation"; Text[30])
        {
            Caption = 'Occupation';
            DataClassification = CustomerContent;
        }
        field(50055; "Designation"; Text[30])
        {
            Caption = 'Designation';
            DataClassification = CustomerContent;
        }
        field(50056; "Terms of Employment"; Option)
        {
            OptionMembers = " ","Permanent","Contract","Casual";
            Caption = 'Terms of Employment';
            DataClassification = CustomerContent;
        }
        field(50057; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code",County,Nationality,(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50058; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code",County,Nationality,(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50059; "Responsibility Center"; Code[20])
        {
            Description = 'LookUp to Responsibility Center BR';
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50060; "County"; Code[20])
        {
            Caption = 'County';
            Description = 'LookUp to Member Segment Table where Type = County';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
            DataClassification = CustomerContent;
        }
        field(50061; "Bank Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "Bank Code Structure";
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50062; "Branch Code"; Code[20])
        {
            Description = 'LookUp to Banks Table';
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50063; "Recruited By"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(50064; "Member Segment"; Code[20])
        {
            Description = 'LookUp to Member Segment Table where Type = Segment';
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(Segment));
            Caption = 'Member Segment';
            DataClassification = CustomerContent;
        }
        field(50065; "Type of Business"; Option)
        {
            OptionCaption = ' ,Sole Proprietor,Partnership,Limited Liability Company,Informal Body,Registered Group,Other(Specify)';
            OptionMembers = " ","Sole Proprietor","Partnership","Limited Liability Company","Informal Body","Registered Group","Other(Specify)";
            Caption = 'Type of Business';
            DataClassification = CustomerContent;
        }
        field(50066; "Other Business Type"; Text[15])
        {
            Caption = 'Other Business Type';
            DataClassification = CustomerContent;
        }
        field(50067; "Ownership Type"; Option)
        {
            OptionCaption = ' ,Personal Account,Joint Account,Group/Business,FOSA Shares';
            OptionMembers = " ","Personal Account","Joint Account","Group/Business","FOSA Shares";
            Caption = 'Ownership Type';
            DataClassification = CustomerContent;
        }
        field(50068; "Other Account Type"; Text[15])
        {
            Caption = 'Other Account Type';
            DataClassification = CustomerContent;
        }
        field(50069; "Nature of Business"; Text[30])
        {
            Caption = 'Nature of Business';
            DataClassification = CustomerContent;
        }
        field(50070; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        }
        field(50071; "Company Registration No."; Code[20])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*IF "Company Registration No." <>'' THEN BEGIN
                Cust.RESET;
                Cust.SETRANGE(Cust."Company Registration No.","Company Registration No.");
                IF Cust.FINDFIRST THEN
                 ERROR(MemberExistError,Cust."No.",Cust.Name);
                END;
                */

            end;
        }
        field(50072; "Date of Business Reg."; Date)
        {
            Caption = 'Date of Business Reg.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Date of Business Reg." > Today then
                    Error(DateofBirthError);
            end;
        }
        field(50073; "Business/Group Location"; Text[50])
        {
            Caption = 'Business/Group Location';
            DataClassification = CustomerContent;
        }
        field(50074; "P.I.N Number"; Code[20])
        {
            Caption = 'P.I.N Number';
            DataClassification = CustomerContent;
        }
        field(50075; "Plot/Bldg/Street/Road"; Text[50])
        {
            Caption = 'Plot/Bldg/Street/Road';
            DataClassification = CustomerContent;
        }
        field(50076; "Group Type"; Option)
        {
            OptionCaption = ' ,Welfare,Microfinance';
            OptionMembers = " ","Welfare","Microfinance";
            Caption = 'Group Type';
            DataClassification = CustomerContent;
        }
        field(50077; "Single Party/Multiple/Business"; Option)
        {
            OptionCaption = 'Single,Multiple,Business';
            OptionMembers = "Single","Multiple","Business";
            Caption = 'Single Party/Multiple/Business';
            DataClassification = CustomerContent;
        }
        field(50078; "Birth Certificate No."; Code[15])
        {
            Caption = 'Birth Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50079; "Group Account No."; Code[20])
        {
            Description = 'LookUp to Member where Group Account = Yes';
            TableRelation = Member WHERE("Group Account" = FILTER(true));
            Caption = 'Group Account No.';
            DataClassification = CustomerContent;
        }
        field(50080; "Electrol Zone"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Electral Zone"));
            Caption = 'Electrol Zone';
            DataClassification = CustomerContent;
        }
        field(50081; "Area Service Center"; Code[20])
        {
            TableRelation = "Electrol Zones/Area Svr Center".Code WHERE(Type = CONST("Area Service Centers"));
            Caption = 'Area Service Center';
            DataClassification = CustomerContent;
        }
        field(50082; "Type"; Option)
        {
            OptionCaption = ' ,From Other Sacco';
            OptionMembers = " ","From Other Sacco";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50083; "Dividend Payment Method"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST("Dividend Payment Type"));
            Caption = 'Dividend Payment Method';
            DataClassification = CustomerContent;
        }
        field(50084; "Old Member No."; Code[20])
        {
            Caption = 'Old Member No.';
            DataClassification = CustomerContent;
        }
        field(50085; "Employer Name"; Text[100])
        {
            Caption = 'Employer Name';
            DataClassification = CustomerContent;
        }
        field(50086; "Identification Type"; Enum "MemberIdentificationType")
        {
            DataClassification = CustomerContent;
            Caption = 'Identification Type';
        }
        field(50087; "Mobile Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Mobile Phone No.';
        }
        field(50088; "Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Application No.';
        }
        field(50089; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
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
            SeriesSetup.TestField(SeriesSetup."Member Application Nos.");
            "No. Series" := SeriesSetup."Member Application Nos.";
            if NoSeriesMgt.AreRelated(SeriesSetup."Member Application Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;
        "Customer Type" := "Customer Type"::Individual
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "CRM Application";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                SeriesSetup.Get();
                NoSeriesMgt.TestManual(SeriesSetup."Member Application Nos.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "CRM Application"; xRecRef: Record "CRM Application"; var IsHandled: Boolean)
    begin
    end;



    var
        MinimumAgeError: Label 'Date of birth must be less than %1';
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        GeneralSetUp: Record "General Set-Up";
        Customer: Record Customer;
        DateofBirthError: Label 'Date cannot be greater than today.';


    procedure fnValidateMinRequiredItems()
    begin

        TestField(Name);
        TestField("ID No.");
        case "Customer Type" of
            "Customer Type"::Corporate,
            "Customer Type"::Group,
            "Customer Type"::Joint:
                begin
                    TestField("Date of Business Reg.");
                end;
        end
    end;
}




