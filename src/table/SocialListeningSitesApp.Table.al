table 50491 "Social Listening Sites App."
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Address"; Text[150])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Account No.", "Address")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




