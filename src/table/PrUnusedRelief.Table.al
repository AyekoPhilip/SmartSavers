table 50087 "Pr Unused Relief"
{
    Caption = 'Pr Unused Relief';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
        }
        field(50010; "Unused Relief"; Decimal)
        {
            Caption = 'Unused Relief';
        }
        field(50011; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50012; "Period Year"; Integer)
        {
            Caption = 'Period Year';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Period Month", "Period Year")
        {
            Clustered = true;
        }
    }
}
