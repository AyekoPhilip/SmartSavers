table 50509 "DCS Data Source"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
            DataClassification = CustomerContent;
        }
        field(50011; "API Private Key"; Code[100])
        {
            Caption = 'API Private Key';
            DataClassification = CustomerContent;
        }
        field(50012; "API Public Key"; Code[100])
        {
            Caption = 'API Public Key';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




