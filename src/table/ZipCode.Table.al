table 50527 "Zip Code"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(50010; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "State"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = States.Code;
            Caption = 'State';
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
