table 50094 "Pr Employee Posting Group"
{
    Caption = 'Pr Employee Posting Group';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50010; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50011; "Salary Account"; Code[20])
        {
            Caption = 'Salary Account';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "G/L Account";
        }
        field(50012; "Income Tax Account"; Code[20])
        {
            Caption = 'Income Tax Account';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50013; "SSF Employer Account"; Code[20])
        {
            Caption = 'SSF Employer Account';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50014; "SSF Employee Account"; Code[20])
        {
            Caption = 'SSF Employee Account';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50015; "Net Salary Payable"; Code[20])
        {
            Caption = 'Net Salary Payable';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50016; "Operating Overtime"; Code[20])
        {
            Caption = 'Operating Overtime';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50017; "Tax Relief"; Code[20])
        {
            Caption = 'Tax Relief';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50018; "Employee Provident Fund A/c"; Code[20])
        {
            Caption = 'Employee Provident Fund A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50019; "Payroll Period Filter"; Date)
        {
            Caption = 'Payroll Period Filter';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50020; "Pension Employer A/c"; Code[20])
        {
            Caption = 'Pension Employer A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50021; "Pension Employee A/c"; Code[20])
        {
            Caption = 'Pension Employee A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50022; "Earnings and Deductions"; Code[20])
        {
            Caption = 'Earnings and Deductions';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50023; "Staff Benevolent"; Code[20])
        {
            Caption = 'Staff Benevolent';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50024; "Salary Expense A/c"; Code[20])
        {
            Caption = 'Salary Expense A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50025; "Director Fee A/c"; Code[20])
        {
            Caption = 'Director Fee A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50026; "Staff Gratuity"; Code[20])
        {
            Caption = 'Staff Gratuity';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50027; "NHIF Employee A/c"; Code[20])
        {
            Caption = 'NHIF Employee A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50028; "Payroll Code"; Code[20])
        {
            Caption = 'Payroll Code';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50029; "Payslip Report"; Integer)
        {
            Caption = 'Payslip Report';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50030; "Tax Code"; Code[20])
        {
            Caption = 'Tax Code';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50031; "Employment Tax Debit"; Code[20])
        {
            Caption = 'Employment Tax Debit';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50032; "Employment Tax Credit"; Code[20])
        {
            Caption = 'Employment Tax Credit';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50033; "House Levy Employer A/c"; Code[20])
        {
            Caption = 'House Levy Employer A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50034; "House Levy Employee A/c"; Code[20])
        {
            Caption = 'House Levy Employee A/c';
            TableRelation = "G/L Account";
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
    keys
    {
        key("PK"; "Code")
        {
            Clustered = true;
        }
    }
}
