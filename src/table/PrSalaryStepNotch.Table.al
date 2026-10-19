table 50082 "Pr Salary Step/Notch"
{
    Caption = 'Pr Salary Step/Notch';
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(50009; "Salary Grade"; Code[50])
        {
            Caption = 'Salary Grade';
        }
        field(50010; "Salary Step/Notch"; Code[10])
        {
            Caption = 'Salary Step/Notch';
        }
        field(50011; "Transaction Code"; Code[10])
        {
            Caption = 'Transaction Code';
        }
        field(50012; "Transaction Name"; Text[100])
        {
            Caption = 'Transaction Name';
        }
        field(50013; "Transaction Type"; Enum "PayrollTransType")
        {
            Caption = 'Transaction Type';
        }
        field(50014; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50015; "Formula"; Code[50])
        {
            Caption = 'Formula';
        }
        field(50016; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(50017; "Annual Amount"; Decimal)
        {
            Caption = 'Annual Amount';
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
    keys
    {
        key("PK"; "Salary Grade", "Salary Step/Notch", "Entry No.")
        {
            Clustered = true;
        }
    }
}
