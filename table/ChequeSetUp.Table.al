table 50433 "Cheque Set Up"
{
    DrillDownPageID = "EFT Transfer List";
    LookupPageID = "EFT Transfer List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Cheque Code"; Code[30])
        {
            Caption = 'Cheque Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Number Of Leaf"; Code[20])
        {
            Caption = 'Number Of Leaf';
            DataClassification = CustomerContent;
        }
        field(50011; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Cheque Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cheque Code", "Number Of Leaf", Amount)
        {
        }
    }
}




