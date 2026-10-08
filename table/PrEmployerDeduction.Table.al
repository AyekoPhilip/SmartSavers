table 50097 "Pr Employer Deduction"
{
    Caption = 'Pr Employer Deduction';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "HR Employees";
            DataClassification = CustomerContent;
        }
        field(50010; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            TableRelation = "Pr Transaction Code";
        }
        field(50011; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50012; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50013; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50014; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50015; "Payroll Code"; Code[10])
        {
            Caption = 'Payroll Code';
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Payroll Period")
        {
            Clustered = true;
        }
    }
}
