table 50084 "Pr Statutory Exemption"
{
    Caption = 'Pr Statutory Exemption';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
        }
        field(50010; "NSSF"; Boolean)
        {
            Caption = 'NSSF';
        }
        field(50011; "NHIF"; Boolean)
        {
            Caption = 'NHIF';
        }
        field(50012; "PAYE"; Boolean)
        {
            Caption = 'PAYE';
        }
        field(50013; "Recurring"; Boolean)
        {
            Caption = 'Recurring';
        }
        field(50014; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50015; "Period Year"; Integer)
        {
            Caption = 'Period Year';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Employee Code")
        {
            Clustered = true;
        }
    }
}
