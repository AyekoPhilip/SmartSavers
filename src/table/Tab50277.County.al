table 50277 "County"
{
    DrillDownPageId = "County List";
    LookupPageId = "County List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "County"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'County Code';
        }
        field(50010; "County Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'County Code';
        }
        field(50011; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key("Key1"; "County")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; County, Description)
        {
        }
    }
}


