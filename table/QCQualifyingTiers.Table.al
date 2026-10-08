table 50575 "QC Qualifying Tiers"
{
    Caption = 'QC Qualifying Tiers';
    DataClassification = CustomerContent;
    DrillDownPageId = "Qualifying Amount";
    LookupPageId = "Qualifying Amount";

    fields
    {
        field(50009; "Score"; Decimal)
        {
            Caption = 'Score';
            DataClassification = CustomerContent;
        }
        field(50010; "Min. Amount"; Decimal)
        {
            Caption = 'Min. Score';
            DataClassification = ToBeClassified;
        }
        field(50011; "Max. Amount"; Decimal)
        {
            Caption = 'Max. Score';
            DataClassification = ToBeClassified;
        }
        field(50012; "Max. Point"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Min. Point"; Integer)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key("PK"; "Score", "Max. Amount", "Min. Amount", "Max. Point", "Min. Point")
        {
            Clustered = true;
        }
    }
}



