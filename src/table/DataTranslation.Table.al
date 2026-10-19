table 50451 "Data Translation"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Cheque Account No"; Code[10])
        {
            Caption = 'Cheque Account No';
            DataClassification = CustomerContent;
        }
        field(50012; "Member Name"; Text[50])
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Used"; Boolean)
        {
            Caption = 'Used';
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




