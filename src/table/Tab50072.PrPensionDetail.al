table 50072 "Pr Pension Detail"
{
    Caption = 'Pr Pension Detail';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(50010; "Pension No."; Code[20])
        {
            Caption = 'Pension No.';
        }
        field(50011; "Company"; Text[100])
        {
            Caption = 'Company';
        }
        field(50012; "Deduct Premium"; Boolean)
        {
            Caption = 'Deduct Premium';
        }
        field(50013; "Balance"; Decimal)
        {
            Caption = 'Balance';
        }
        field(50014; "Lumpsum Items"; Boolean)
        {
            Caption = 'Lumpsum Items';
        }
        field(50015; "Is Insurance Policy"; Boolean)
        {
            Caption = 'Is Insurance Policy';
        }
        field(50016; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
        }
        field(50017; "Inception Date"; Date)
        {
            Caption = 'Inception Date';
        }
        field(50018; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Pension No.", "Company")
        {
            Clustered = true;
        }
    }
}
