table 50541 "Sasra Sector"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Sasra Sectors";
    LookupPageId = "Sasra Sectors";

    fields
    {
        field(50009; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(50010; "Description"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
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




