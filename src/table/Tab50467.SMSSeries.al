table 50467 "SMS Series"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Message Body"; Text[130])
        {
            Caption = 'Message Body';
            DataClassification = CustomerContent;
        }
        field(50012; "Email Body"; Text[250])
        {
            Caption = 'Email Body';
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




