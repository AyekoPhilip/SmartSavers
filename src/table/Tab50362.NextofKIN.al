table 50362 "Next of KIN"
{
    DrillDownPageID = "Next of KIN";
    LookupPageID = "Next of KIN";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(50010; "Account No"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No';
            TableRelation = Member;
        }
        field(50011; "Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        
            trigger OnValidate()
            begin
                Name := UpperCase(Name);
            end;
        }
        field(50012; "Relationship"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Relationship Types";
            Caption = 'Relationship';
        }
        field(50013; "Beneficiary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Beneficiary';
        }
        field(50014; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
            begin
            end;
        }
        field(50015; "Address"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Address';
        
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
            DataClassification = CustomerContent;
            Caption = 'Fax';
        }
        field(50018; "Email"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
        }
        field(50019; "ID No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID No.';
        
            trigger OnValidate()
            begin
                "ID No." := DelChr("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
                FieldLength("ID No.", 20);
            end;
        }
        field(50020; "Allocation"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Allocation';
        }
        field(50021; "Type"; Enum "NextOfKinTYpe")
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(50022; "Deceased"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Deceased';
        }
        field(50023; "BBF Entitlement Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "BBF Entitlement".Code;
            Caption = 'BBF Entitlement Code';
        
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
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'BBF Entitlement';
        }
        field(50025; "Specify If Others"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Specify If Others';
        }
        field(50026; "Application No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50027; "Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Post Code';
        }
        field(50028; "Kin Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Next of Kin,Spouse,Benevolent Beneficiary,Family Member,Referee';
            OptionMembers = " ","Next of Kin","Spouse","Benevolent Beneficiary","Family Member","Referee";
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
    }

    keys
    {
        key("Key1"; "Account No", "Name", "Application No.")
        {
            Clustered = true;
            SumIndexFields = "Allocation";
        }
        key("Key2"; "Entry No.")
        {

        }
    }

    fieldgroups
    {
    }

    var
        BEntitlement: Record "BBF Entitlement";


    procedure FieldLength(VarVariant: Text; FldLength: Integer): Text
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        if StrLen(VarVariant) > FldLength then
            Error(FieldLengthError, FldLength);
    end;

    procedure CopyFromApplicationKinDetails(Application: Record "Next of KIN Application")
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
    local procedure OnAfterCopyLinesFromApplicationKin(KinDetails: Record "Next of KIN Application"; var VarVariant: Record "Next of KIN")
    begin
    end;
}




