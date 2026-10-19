table 50078 "Pr Salary Arrears"
{
    Caption = 'Pr Salary Arrears';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
        }
        field(50011; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(50012; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(50013; "Salary Arrears"; Decimal)
        {
            Caption = 'Salary Arrears';
        }
        field(50014; "PAYE Arrears"; Decimal)
        {
            Caption = 'PAYE Arrears';
        }
        field(50015; "Period Month"; Integer)
        {
            Caption = 'Prriod Month';
        }
        field(50016; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50017; "Current Basic"; Decimal)
        {
            Caption = 'Current Basic';
        }
        field(50018; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50019; "No."; Integer)
        {
            Caption = 'No.';
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
