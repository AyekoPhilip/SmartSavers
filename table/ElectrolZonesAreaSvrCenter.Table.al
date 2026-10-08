table 50510 "Electrol Zones/Area Svr Center"
{
    LookupPageID = Denomination;
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Type"; Option)
        {
            OptionMembers = " ","Electral Zone","Area Service Centers";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Mileage (KMs)"; Decimal)
        {
            Description = '//To gather for delegates transport allowance computations';
            Caption = 'Mileage (KMs)';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




