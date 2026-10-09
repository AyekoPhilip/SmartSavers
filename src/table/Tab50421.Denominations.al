table 50421 "Denominations"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140603;
    LookupPageID = 52140603; */

    fields
    {
        field(50009; "Code"; Code[30])
        {
            NotBlank = true;
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Value"; Decimal)
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(50012; "Type"; Option)
        {
            OptionMembers = "Note","Coin";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Priority"; Integer)
        {
            Caption = 'Priority';
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




