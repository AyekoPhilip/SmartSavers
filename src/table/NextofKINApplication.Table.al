table 50353 "Next of KIN Application"
{
    LookupPageID = "Next of KIN Application";
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No"; Code[20])
        {
            Caption = 'Account No';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Name := UpperCase(Name);
            end;
        }
        field(50012; "Relationship"; Text[50])
        {
            TableRelation = "Relationship Types";
            Caption = 'Relationship';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                RelationshipTypes.Reset;
                RelationshipTypes.SetRange(Description, Relationship);
                if RelationshipTypes.Find('-') then begin
                    NOK.Reset;
                    NOK.SetRange(NOK."Account No", "Account No");
                    if NOK.Find('-') then begin
                        repeat
                            TotRel += 1;
                        until NOK.Next = 0;
                    end;
                end;
            end;
        }
        field(50013; "Beneficiary"; Boolean)
        {
            Caption = 'Beneficiary';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50014; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date of Birth" >= Today then Error(DateofBirthError);
            end;
        }
        field(50015; "Address"; Text[150])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Address := UpperCase(Address);
            end;
        }
        field(50016; "Telephone"; Code[20])
        {
            Caption = 'Mobile No.';
            DataClassification = CustomerContent;
        }
        field(50017; "Fax"; Code[10])
        {
            Caption = 'Fax';
            DataClassification = CustomerContent;
        }
        field(50018; "Email"; Text[30])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                MailManagement.ValidateEmailAddressField("Email");
            end;
        }
        field(50019; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                FieldLength("ID No.", 7, 13);
            end;
        }
        field(50020; "Allocation"; Decimal)
        {
            Caption = 'Allocation';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TotalA := 0;
                NokCount := 0;
                NokCount := CountKinMaxAllocation("Account No");
                if NokCount = 1 then
                    TotalA := Allocation else
                    TotalA := (CalculateKinMaxAllocation("Account No") + Allocation);
                if TotalA > 100 then
                    Error('Total allocation cannot be more than 100%');
            end;
        }
        field(50021; "Type"; Enum "NextOfKinTYpe")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            Editable = true;
        
            trigger OnValidate()
            begin
                if Type=Type::"Benevolent Beneficiary" then
                Beneficiary:=true else
                Beneficiary:=false;
            end;
        }
        field(50022; "Deceased"; Boolean)
        {
            Editable = false;
            Caption = 'Deceased';
            DataClassification = CustomerContent;
        }
        field(50023; "BBF Entitlement Code"; Code[10])
        {
            TableRelation = "BBF Entitlement".Code;
            Caption = 'BBF Entitlement Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                BEntitlement.Reset;
                BEntitlement.SetRange(Code, "BBF Entitlement Code");
                if BEntitlement.Find('-') then begin
                    "BBF Entitlement" := BEntitlement.Amount;
                end;
            end;
        }
        field(50024; "BBF Entitlement"; Decimal)
        {
            Editable = false;
            Caption = 'BBF Entitlement';
            DataClassification = CustomerContent;
        }
        field(50025; "Specify If Others"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Specify If Others';
        }
        field(50026; "Application No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50027; "Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            Caption = 'Post Code';
            ValidateTableRelation = false;
        
            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", "Country/Region", Nationality, (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50028; "Kin Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Next of Kin,Spouse,Benevolent Beneficiary,Family Member,Referee,Guardian';
            OptionMembers = " ","Next of Kin","Spouse","Benevolent Beneficiary","Family Member","Referee","Guardian";
            Caption = 'Kin Type';
        
            trigger OnValidate()
            var
                BBFEntitlement: Record "BBF Entitlement";
            begin
                case Type of
                    Type::Spouse:
                        begin
                            BBFEntitlement.Reset;
                            BBFEntitlement.SetRange(BBFEntitlement.Entitlement, Relationship);
                            if BBFEntitlement.Find('-') then begin
                                "BBF Entitlement Code" := BBFEntitlement.Code;
                                "BBF Entitlement" := BBFEntitlement.Amount;
                            end;
                        end else begin
                        "BBF Entitlement Code" := '';
                        "BBF Entitlement" := 0;
                    end;
                end;
            end;
        }
        field(50029; "Guardian"; Text[100])
        {

        }
        field(50030; "Country/Region"; Text[100])
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
                    Telephone := CountryCode."Intrastat Code";
            end;
        }
        field(50031; "City"; Text[30])
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
        field(50032; "Nationality"; Code[20])
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
                    Telephone := CountCode."Intrastat Code";
            end;
        }
        field(50033; "Gender"; Enum "CustGender")
        {
            DataClassification = CustomerContent;
        }
         field(50034; "Principal Member"; Code[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Account No", "Name", "Application No.")
        {
            Clustered = true;
            SumIndexFields = "Allocation";
        }
    }
    fieldgroups
    {
    }

    var
        NOK: Record "Next of KIN Application";
        TotalA: Decimal;
        MailManagement: Codeunit "Mail Management";
        BEntitlement: Record "BBF Entitlement";
        RelationshipTypes: Record "Relationship Types";
        TotRel: Integer;
        NokCount: Integer;
        PostCode: Record "Post Code";

    procedure FieldLength(VarVariant: Text; MinLength: Integer; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be less than %1 or more than %2 Characters.';
    begin
        if (StrLen(VarVariant) < MinLength) or (StrLen(VarVariant) > FldLength) then
            Error(FieldLengthError, MinLength, FldLength);
    end;

    procedure CountKinMaxAllocation(ApplicNo: Code[10]) AllocAmt: Integer
    var
        KinApplications: Record "Next of KIN Application";
    begin

        AllocAmt := 0;
        KinApplications.Reset;
        KinApplications.SetRange("Account No", ApplicNo);
        KinApplications.SetRange(Type, KinApplications.Type::"Next of Kin");
        if KinApplications.FindSet then begin
            AllocAmt := KinApplications.Count;
        end;
        exit(AllocAmt)
    end;


    procedure CalculateKinMaxAllocation(ApplicNo: Code[10]) AllocAmt: Decimal
    var
        KinApplications: Record "Next of KIN Application";
    begin

        AllocAmt := 0;
        KinApplications.Reset;
        KinApplications.SetRange("Account No", ApplicNo);
        KinApplications.SetRange(Type, KinApplications.Type::"Next of Kin");
        if KinApplications.FindSet then begin
            KinApplications.CalcSums(Allocation);
            AllocAmt := KinApplications.Allocation;
        end;
        exit(AllocAmt)
    end;


    procedure CopyFromApplicationKinDetails(Application: Record "Next of KIN")
    begin

        Name := UpperCase(Application.Name);
        Relationship := Application.Relationship;
        Beneficiary := Application.Beneficiary;
        "Date of Birth" := Application."Date of Birth";
        Address := Application.Address;
        Telephone := Application.Telephone;
        Fax := Application.Fax;
        Email := Application.Email;
        Allocation := Application.Allocation;
        Type := Application.Type;
        "BBF Entitlement" := Application."BBF Entitlement";
        "BBF Entitlement Code" := Application."BBF Entitlement Code";
        "ID No." := Application."ID No.";
        OnAfterCopyLinesFromApplicationKin(Application, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyLinesFromApplicationKin(KinDetails: Record "Next of KIN"; var VarVariant: Record "Next of KIN Application")
    begin
    end;
}




