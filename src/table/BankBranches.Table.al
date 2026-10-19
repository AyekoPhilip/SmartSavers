table 50281 "Bank Branches"
{
    DrillDownPageID = "Bank Branches List";
    LookupPageID = "Bank Branches List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Bank Code"; Code[50])
        {
            NotBlank = true;
            TableRelation = Banks;
            DataClassification = CustomerContent;
            Caption = 'Bank Code';
        }
        field(50010; "Branch Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Code';
        }
        field(50011; "Branch Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Name';
        }
        field(50012; "Address"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Address';
        }
        field(50013; "Address 2"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Address 2';
        }
        field(50014; "City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }
        field(50015; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            Caption = 'Post Code';
        
            trigger OnValidate()
            begin
                if PostCode.Get("Post Code") then
                    City := PostCode.City;
            end;
        }
        field(50016; "Contact"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact';
        }
        field(50017; "Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
        }
        field(50018; "Telex No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Telex No.';
        }
        field(50019; "Bank Branch No."; Text[20])
        {
            NotBlank = false;
            DataClassification = CustomerContent;
            Caption = 'Bank Branch No.';
        }
        field(50020; "Bank Account No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.';
        }
        field(50021; "Transit No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transit No.';
        }
        field(50022; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
        }
        field(50023; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
            Caption = 'Country Code';
        }
        field(50024; "County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'County';
        }
        field(50025; "Fax No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Fax No.';
        }
        field(50026; "Telex Answer Back"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Telex Answer Back';
        }
        field(50027; "Language Code"; Code[10])
        {
            TableRelation = Language;
            DataClassification = CustomerContent;
            Caption = 'Language Code';
        }
        field(50028; "E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'E-Mail';
        }
        field(50029; "Home Page"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Home Page';
        }
        field(50030; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Pay Period Filter';
        }
        field(50031; "Rounding Type"; Option)
        {
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = "Nearest","Up","Down";
            DataClassification = CustomerContent;
            Caption = 'Rounding Type';
        }
        field(50032; "Rounding Precision"; Decimal)
        {
            // DecimalPlaces is unspecified in the supplied symbols.
            DataClassification = CustomerContent;
            Caption = 'Rounding Precision';
        }
        field(50033; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
            DataClassification = CustomerContent;
        }
        field(50034; "Stopped"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Open","Closed";
            OptionCaption = 'Open,Closed';
        }
    }

    keys
    {
        key("Key1"; "Bank Code", "Branch Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Bank Code", "Branch Code", "Branch Name")
        {
        }
    }

    var
        PostCode: Record "Post Code";
}


