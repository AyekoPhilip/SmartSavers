table 50105 "Pr NHIF"
{
    Caption = 'Pr NHIF';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(50010; "NHIF Tier"; Decimal)
        {
            Caption = 'NHIF Tier';
        }
        field(50011; "Lower Tier"; Decimal)
        {
            Caption = 'Lower Tier';
        }
        field(50012; "Upper Tier"; Decimal)
        {
            Caption = 'Upper Tier';
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
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
