table 50355 "Segment/County/Dividend/Signat"
{
    DrillDownPageID = "Segment/County/Dividend/Signat";
    LookupPageID = "Segment/County/Dividend/Signat";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Type"; Enum "SegmentTypes")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[30])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Market Ninch Details"; Text[80])
        {
            Caption = 'Market Ninch Details';
            DataClassification = CustomerContent;
        }
        field(50013; "County"; Code[30])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = CONST(County));
            Caption = 'County';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Type", "Code", "Description")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}




