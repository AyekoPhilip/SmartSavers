table 50305 "Property Type"
{
    Caption = 'Property Type';
    DataClassification = ToBeClassified;
    LookupPageId = "Property Type";
    DrillDownPageId = "Property Type";

    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(50010; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50011; "Value %"; Decimal)
        {
            Caption = 'Value %';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "Code")
        {
            Clustered = true;
        }
    }
}



