table 50280 "Banks"
{
    DrillDownPageID = "Banks List";
    LookupPageID = "Banks List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[50])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(50010; "Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(50011; "Address"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Address';
        }
        field(50012; "Address 2"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Address 2';
        }
        field(50013; "City"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }
        field(50014; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            Caption = 'Post Code';
        
            trigger OnValidate()
            begin
                if PostCode.Get("Telex No.") then
                    "Phone No." := PostCode.City;
            end;
        }
        field(50015; "Contact"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact';
        }
        field(50016; "Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
        }
        field(50017; "Telex No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Telex No.';
        }
        field(50018; "Bank No."; Text[20])
        {
            NotBlank = false;
            DataClassification = CustomerContent;
            Caption = 'Bank No.';
        }
        field(50019; "Bank Account No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account No.';
        }
        field(50020; "Transit No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transit No.';
        }
        field(50021; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
        }
        field(50022; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
            Caption = 'Country Code';
        }
        field(50023; "County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'County';
        }
        field(50024; "Fax No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Fax No.';
        }
        field(50025; "Telex Answer Back"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Telex Answer Back';
        }
        field(50026; "Language Code"; Code[10])
        {
            TableRelation = Language;
            DataClassification = CustomerContent;
            Caption = 'Language Code';
        }
        field(50027; "E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'E-Mail';
        }
        field(50028; "Home Page"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Home Page';
        }
        field(50029; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Pay Period Filter';
        }
        field(50030; "Rounding Type"; Option)
        {
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = "Nearest","Up","Down";
            DataClassification = CustomerContent;
            Caption = 'Rounding Type';
        }
        field(50031; "Rounding Precision"; Decimal)
        {
            // DecimalPlaces is unspecified in the supplied symbols.
            DataClassification = CustomerContent;
            Caption = 'Rounding Precision';
        }
        field(50032; "Swift Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Swift Code';
        }
        field(50033; "Sort Code"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sort Code';
        }
        field(50034; "Institution Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Bank","Building Society";
            Editable = false;
        }
        field(50035; "Society Code"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50036; "Bank Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Normal","Mobile","Other";
        }
        field(50037; "Mobile Money Code"; Code[100])
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key("Key1"; "Code", "Bank No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "Post Code";
}


