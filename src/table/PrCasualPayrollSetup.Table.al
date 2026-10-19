table 50089 "Pr Casual Payroll Setup"
{
    Caption = 'Pr Casual Payroll Setup';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Setup Code"; Code[10])
        {
            Caption = 'Setup Code';
        }
        field(50010; "Normal Hours Rate Per Hour"; Decimal)
        {
            Caption = 'Normal Hours Rate Per Hour';
        }
        field(50011; "Overtime Hours Rate Per Hour"; Decimal)
        {
            Caption = 'Overtime Hours Rate Per Hour';
        }
        field(50012; "PHs Weekends Rate Per Hours"; Decimal)
        {
            Caption = 'PHs and Weekends Rate Per Hours';
        }
      
       
    }
    keys
    {
        key("PK"; "Setup Code")
        {
            Clustered = true;
        }
    }
}
