table 50067 "Pr PAYE"
{
    Caption = 'Pr PAYE';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(50010; "Tax Code"; Code[10])
        {
            Caption = 'Tax Code';
        }
        field(50011; "PAYE Tier"; Decimal)
        {
            Caption = 'PAYE Tier';
        }
        field(50012; "Rate"; Decimal)
        {
            Caption = 'Rate';
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
