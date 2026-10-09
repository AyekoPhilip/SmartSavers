table 50066 "Pr Other Setup"
{
    Caption = 'Pr Other Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Range"; Integer)
        {
            Caption = 'Range';
        }
        field(50010; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50011; "Period"; Decimal)
        {
            Caption = 'Period';
        }
        field(50012; "Transaction Code"; Code[10])
        {
            Caption = 'Transaction Code';
        }
        field(50013; "Period Type"; Option)
        {
            Caption = 'Period Type';
            OptionMembers = "Day","Month";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Range")
        {
            Clustered = true;
        }
    }
}
