table 50304 "Shares Banding"
{
    Caption = 'Shares Banding';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Shares Banding";
    LookupPageId = "Shares Banding";

    fields
    {
        field(50009; "Minimum"; Decimal)
        {
            Caption = 'Minimum';
            DataClassification = ToBeClassified;
        }
        field(50010; "Maximum"; Decimal)
        {
            Caption = 'Maximum';
            DataClassification = ToBeClassified;
        }
        field(50011; "Shares Amount"; Decimal)
        {
            Caption = 'Shares Amount';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "Minimum", "Maximum")
        {
            Clustered = true;
        }
    }
}



