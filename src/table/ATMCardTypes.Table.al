table 50482 "ATM Card Types"
{
    DrillDownPageID = "Segment/County/Dividend/Signat";
    LookupPageID = "Segment/County/Dividend/Signat";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[200])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Application Charge Code"; Code[50])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = FILTER("ATM Applications"));
            Caption = 'Application Charge Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Replacement Charge Code"; Code[50])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = FILTER("ATM Replacement"));
            Caption = 'Replacement Charge Code';
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




