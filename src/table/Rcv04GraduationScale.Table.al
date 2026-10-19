table 90003 "Rcv04 Graduation Scale"
{
    Caption = 'Graduation Scale';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
        }
        field(2; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
        }
        field(3; "Max. Amount"; Decimal)
        {
            Caption = 'Max. Amount';
        }
        field(4; Scale; Integer)
        {
            Caption = 'Scale';
            DataClassification = CustomerContent;
        }
        field(5; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            TableRelation="Product Factory";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Lower Limit", "Upper Limit", "Max. Amount")
        {
            Clustered = true;
        }
    }
}
