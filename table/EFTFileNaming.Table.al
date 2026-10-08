table 50006 "EFT File Naming"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Value"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }
        field(50010; "Character"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Character';
        }
    }

    keys
    {
        key("Key1"; "Value")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


