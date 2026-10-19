table 50569 "Bank Code Account"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Bank Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Code';
        }
        field(50010; "Bank Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Name';
        }
    }

    keys
    {
        key("Key1"; "Bank Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




