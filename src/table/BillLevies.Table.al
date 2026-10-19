table 50246 "Bill Levies"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Bill Code"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bill Types";
            Caption = 'Bill Code';
        }
        field(50010; "Levy Code"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Levy Code';
        }
        field(50011; "Levy Description"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Levy Description';
        }
        field(50012; "G/L Account"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
        }
        field(50013; "Percentage Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage Amount';
        }
    }

    keys
    {
        key("Key1"; "Bill Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


