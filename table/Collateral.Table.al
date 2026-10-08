table 50401 "Collateral"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = CustomerContent;
        }
        field(50011; "Member Name"; Text[70])
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Date Collateralised"; Date)
        {
            Caption = 'Date Collateralised';
            DataClassification = CustomerContent;
        }
        field(50013; "Collateral Value"; Decimal)
        {
            Caption = 'Collateral Value';
            DataClassification = CustomerContent;
        }
        field(50014; "Collateral Type"; Option)
        {
            OptionCaption = ' ,Land,Motor Vehicles,Buildings,Chattels,Bonds and Stocks,Insurance Policies,Lien';
            OptionMembers = " ","Land","Motor Vehicles","Buildings","Chattels","Bonds and Stocks","Insurance Policies","Lien";
            Caption = 'Collateral Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Registration/Certificate No."; Code[20])
        {
            Caption = 'Registration/Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Internal Account(Lien)"; Code[20])
        {
            TableRelation = "Account Banking"."No." WHERE("No." = FIELD("No."));
            Caption = 'Internal Account(Lien)';
            DataClassification = CustomerContent;
        }
        field(50017; "Serial"; Integer)
        {
            Caption = 'Serial';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Member No", "Serial")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




