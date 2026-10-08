table 50330 "Qualifying Amount"
{
    Caption = 'Qualifying Amount Banding';
    DataClassification = ToBeClassified;
    fields
    {
        field(50009; "Score"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(50010; "Min. Amount"; Integer)
        {
            Caption = 'Min. Score';
            DataClassification = ToBeClassified;
        }
        field(50011; "Max. Amount"; Integer)
        {
            Caption = 'Max. Score';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "Score", "Max. Amount", "Min. Amount")
        {
            Clustered = true;
        }
    }
}



