table 50520 "Withdrawal Reason"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code", "Description")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




