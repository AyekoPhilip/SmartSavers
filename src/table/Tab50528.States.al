table 50528 "States"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(50010; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "Country"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code WHERE(Code = FIELD(Country));
            Caption = 'Country';
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




