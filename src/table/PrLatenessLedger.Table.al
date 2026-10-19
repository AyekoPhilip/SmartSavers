table 50100 "Pr Lateness Ledger"
{
    Caption = 'Pr Lateness Ledger';
    DataClassification = OrganizationIdentifiableInformation;

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
        field(50011; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50012; "No. of Days"; Integer)
        {
            Caption = 'No. of Days';
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Transaction Code", "Payroll Period")
        {
            Clustered = true;
        }
    }
}
