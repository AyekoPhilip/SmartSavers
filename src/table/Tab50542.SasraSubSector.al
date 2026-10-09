table 50542 "Sasra-Sub Sector"
{
    DataClassification = CustomerContent;
    LookupPageId = "Sasra Subsector";
    DrillDownPageId = "Sasra Subsector";

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
        field(50011; "Sector"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sector';
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




