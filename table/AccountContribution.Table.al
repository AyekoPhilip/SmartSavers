table 50539 "Account Contribution"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(50010; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50011; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Member No.';
        }
    }

    keys
    {
        key("Key1"; "Posting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




