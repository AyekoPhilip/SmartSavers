table 50409 "Collateral Types Ratings"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Collateral Type"; Option)
        {
            OptionCaption = ' ,Land,Motor Vehicles,Buildings,Chattels,Bonds and Stocks,Insurance Policies,Lien';
            OptionMembers = " ","Land","Motor Vehicles","Buildings","Chattels","Bonds and Stocks","Insurance Policies","Lien";
            Caption = 'Collateral Type';
            DataClassification = CustomerContent;
        }
        field(50010; "Collateral % Applicable"; Decimal)
        {
            MaxValue = 100;
            MinValue = 1;
            Caption = 'Collateral % Applicable';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Collateral Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




