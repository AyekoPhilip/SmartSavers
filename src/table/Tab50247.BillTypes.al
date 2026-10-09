table 50247 "Bill Types"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Bill Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill Code';
        }
        field(50010; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "G/L Account"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
        }
    }

    keys
    {
        key("Key1"; "Bill Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


