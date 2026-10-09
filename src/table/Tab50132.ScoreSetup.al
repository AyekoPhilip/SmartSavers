table 50132 "Score Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Score ID"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Score ID';
        }
        field(50010; "Score"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Score';
        }
    }

    keys
    {
        key("Key1"; "Score ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


