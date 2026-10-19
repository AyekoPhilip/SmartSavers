table 50071 "Pr Payroll Variation"
{
    Caption = 'Pr Payroll Variation';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
        }
        field(50010; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(50011; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = " ","New Employee","Salary Change","Allowance Change","Overtime Claim","Staff Transfer";
        }
        field(50012; "Basic Pay"; Decimal)
        {
            Caption = 'Basic Pay';
        }
        field(50013; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(50014; "Transaction Code"; Code[10])
        {
            Caption = 'Transaction Code';
        }
        field(50015; "New Amount"; Decimal)
        {
            Caption = 'New Amount';
        }
        field(50016; "Hrs Worked"; Decimal)
        {
            Caption = 'Hrs Worked';
        }
        field(50017; "Overtime Type"; Option)
        {
            Caption = 'Overtime Type';
            OptionMembers = " ","2Hr","1.5Hr";
        }
        field(50018; "Created By"; Code[100])
        {
            Caption = 'Created By';
        }
        field(50019; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(50020; "Status"; Enum "ApprovalStatus")
        {
            Caption = 'Status';
        }
        field(50021; "Approved By"; Code[100])
        {
            Caption = 'Approved By';
        }
        field(50022; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }
        field(50023; "Date Closed"; Date)
        {
            Caption = 'Date Closed';
        }
        field(50024; "Department Code"; Code[10])
        {
            Caption = 'Department Code';
        }
        field(50025; "Transaction Name"; Text[100])
        {
            Caption = 'Transaction Name';
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
