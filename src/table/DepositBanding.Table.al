table 50493 "Deposit Banding"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
            DataClassification = CustomerContent;
        }
        field(50011; "Upper Limt"; Decimal)
        {
            Caption = 'Upper Limt';
            DataClassification = CustomerContent;
        }
        field(50012; "Minimum Contribution"; Decimal)
        {
            Caption = 'Minimum Contribution';
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




