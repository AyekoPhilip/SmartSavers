table 50095 "Pr Employee Repeating Tx"
{
    Caption = 'Pr Employee Repeating Tx';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "HR Employees";
        }
        field(50010; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            TableRelation = "Pr Transaction Code";
        }
        field(50011; "Transaction Name"; Text[100])
        {
            Caption = 'Transaction Name';
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50013; "Balance"; Decimal)
        {
            Caption = 'Balance';
        }
        field(50014; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50015; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50016; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50017; "No. of Repayment"; Integer)
        {
            Caption = 'No. of Repayment';
        }
        field(50018; "Reference No."; Text[50])
        {
            Caption = 'Reference No.';
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
