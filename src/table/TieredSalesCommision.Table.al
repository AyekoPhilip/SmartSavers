table 50538 "Tiered Sales Commision"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Min. No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Min. No.';
        }
        field(50010; "Max. No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. No.';
        }
        field(50011; "Amount Payable"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Payable';
        }
    }

    keys
    {
        key("Key1"; "Min. No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




