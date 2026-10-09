table 50098 "Pr Formula Result"
{
    Caption = 'Pr Formula Result';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Result Figure"; Decimal)
        {
            Caption = 'Result Figure';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Result Figure")
        {
            Clustered = true;
        }
    }
}
