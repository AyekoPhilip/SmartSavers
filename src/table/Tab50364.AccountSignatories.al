table 50364 "Account Signatories"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            NotBlank = true;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Names"; Text[150])
        {
            NotBlank = true;
            Caption = 'Names';
            DataClassification = CustomerContent;
        }
        field(50012; "Date Of Birth"; Date)
        {
            Caption = 'Date Of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
                if "Date Of Birth" > Today then
                    Error(DateofBirthError);
            end;
        }
        field(50013; "Staff/Payroll"; Code[20])
        {
            Caption = 'Staff/Payroll';
            DataClassification = CustomerContent;
        }
        field(50014; "ID No."; Code[50])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Signatory"; Boolean)
        {
            Caption = 'Signatory';
            DataClassification = CustomerContent;
        }
        field(50016; "Must Sign"; Boolean)
        {
            Caption = 'Must Sign';
            DataClassification = CustomerContent;
        }
        field(50017; "Must be Present"; Boolean)
        {
            Caption = 'Must be Present';
            DataClassification = CustomerContent;
        }
        field(50018; "Picture"; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(50019; "Signature"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50020; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50021; "Type"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Type WHERE(Type = CONST("Signatory Type"));
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50022; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Members: Record Member;
                ImageData: Record "Image Data";
            begin
                if Members.Get("Member No.") then begin
                    Names := Members.Name;
                    "ID No." := Members."ID No.";
                    "Date Of Birth" := Members."Date of Birth";
                    "Staff/Payroll" := Members."Payroll/Staff No.";

                    ImageData.Reset;
                    ImageData.SetRange(ImageData."Member No.", Members."No.");
                    if ImageData.Find('-') then begin
                        ImageData.CalcFields(Picture, Signature);
                        Picture := ImageData.Picture;
                        Signature := ImageData.Signature;
                    end;
                end;
            end;
        }
        field(50023; "Entry Type"; Option)
        {
            OptionCaption = 'Initial,Changes';
            OptionMembers = "Initial","Changes";
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(50024; "Signatory Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Member,Staff,Non Member';
            OptionMembers = "Member","Staff","Non Member";
            Caption = 'Signatory Category';
        }
        field(50025; "Non Member A/c No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Non Member A/c No.';
        }
        field(50026; "First Name"; Text[30])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(50027; "Second Name"; Text[30])
        {
            Caption = 'Second Name';
            DataClassification = CustomerContent;
        }
        field(50028; "Pin No."; Code[20])
        {
            Caption = 'Pin No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Occupation"; Text[30])
        {
            Caption = 'Occupation';
            DataClassification = CustomerContent;
        }
        field(50030; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50031; "Address"; Code[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(50032; "Apartment/Suite"; Code[10])
        {
            Caption = 'Apartment/Suite';
            DataClassification = CustomerContent;
        }
        field(50033; "State ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'State ID';
        }
        field(50034; "State"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = States.Code;
            Caption = 'State';
        }
        field(50035; "Zip Code"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Zip Code';
        }
        field(50036; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50037; "Nationality"; Code[10])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50038; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50039; "ID Image"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50040; "Last Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Name';
        }
        field(50041; "Current Address"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Current Address';
        }
        field(50042; "Mobile Number"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Mobile Number';
        }
        field(50043; "Passport No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Passport No.';
        }
        field(50044; "Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }
        field(50045; "Substituted"; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key("Key1"; "Account No.", "ID No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CopyFromApplicationsignatoriesDetails(Application: Record "Signatory Application")
    begin

        "Date Of Birth" := Application."Date Of Birth";
        "Staff/Payroll" := Application."Staff/Payroll";
        "ID No." := Application."ID No.";
        Signatory := Application.Signatory;
        "Must Sign" := Application."Must Sign";
        "Must be Present" := Application."Must be Present";
        Picture := Application.Picture;
        Signature := Application.Signature;
        "Expiry Date" := Application."Expiry Date";
        "First Name" := Application."First Name";
        "Second Name" := Application."Second Name";
        "Pin No." := Application."Pin No.";
        Occupation := Application.Occupation;
        Gender := Application.Gender;
        Address := Application.Address;
        "Apartment/Suite" := Application."Apartment/Suite";
        "State ID" := Application."State ID";
        State := Application.State;
        "Zip Code" := Application."Zip Code";
        "Post Code" := Application."Post Code";
        Nationality := Application.Nationality;
        City := Application.City;
        Names := UpperCase(Application."First Name" + ' ' + Application."Second Name");

        OnAfterCopyLinesFromApplicsignatories(Application, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyLinesFromApplicsignatories(SignatoryDetails: Record "Signatory Application"; var VarVariant: Record "Account Signatories")
    begin
    end;
}




