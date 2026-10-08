table 50092 "Pr Employee P9 Info"
{
    Caption = 'Pr Employee P9 Info';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "HR Employees";
            DataClassification = CustomerContent;
        }
        field(50010; "Basic Pay"; Decimal)
        {
            Caption = 'Basic Pay';
        }
        field(50011; "Allowance"; Decimal)
        {
            Caption = 'Allowance';
        }
        field(50012; "Benefits"; Decimal)
        {
            Caption = 'Benefits';
        }
        field(50013; "Value Of Quarters"; Decimal)
        {
            Caption = 'Value Of Quarters';
        }
        field(50014; "Defined Contribution"; Decimal)
        {
            Caption = 'Defined Contribution';
        }
        field(50015; "Owner Occupier Interest"; Decimal)
        {
            Caption = 'Owner Occupier Interest';
        }
        field(50016; "Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';
        }
        field(50017; "Taxable Pay"; Decimal)
        {
            Caption = 'Taxable Pay';
        }
        field(50018; "Tax Charged"; Decimal)
        {
            Caption = 'Tax Charged';
        }
        field(50019; "Insurance Relief"; Decimal)
        {
            Caption = 'Insurance Relief';
        }
        field(50020; "PAYE"; Decimal)
        {
            Caption = 'PAYE';
        }
        field(50021; "NSSF"; Decimal)
        {
            Caption = 'NSSF';
        }
        field(50022; "NHIF"; Decimal)
        {
            Caption = 'NHIF';
        }
        field(50023; "Deductions"; Decimal)
        {
            Caption = 'Deductions';
        }
        field(50024; "Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
        }
        field(50025; "Period Month"; Integer)
        {
            Caption = 'Period Month';
        }
        field(50026; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50027; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50028; "Period Filter"; Date)
        {
            Caption = 'Period Filter';
            FieldClass = FlowFilter;
            TableRelation = "Pr Payroll Period"."Date Opened";
        }
        field(50029; "Pension"; Decimal)
        {
            Caption = 'Pension';
        }
        field(50030; "HELB"; Decimal)
        {
            Caption = 'HELB';
        }
        field(50031; "Payroll Code"; Code[100])
        {
            Caption = 'Payroll Code';
        }
        field(50032; "Allowances"; Decimal)
        {

        }
        field(50033; "Tax Relief"; Decimal)
        {

        }
         field(57025; "House Levy"; Decimal)
        {

        }
    }
    keys
    {
        key("PK"; "Employee Code", "Payroll Period")
        {
            Clustered = true;
        }
    }
}
