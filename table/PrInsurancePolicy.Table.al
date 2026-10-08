table 50099 "Pr Insurance Policy"
{
    Caption = 'Pr Insurance Policy';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            TableRelation = "HR Employees";
        }
        field(50010; "Policy No."; Code[20])
        {
            Caption = 'Policy No.';
        }
        field(50011; "Insurance Code"; Code[20])
        {
            Caption = 'Insurance Code';
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50013; "Deduct Premium"; Boolean)
        {
            Caption = 'Deduct Premium';
        }
        field(50014; "Balance"; Decimal)
        {
            Caption = 'Balance';
        }
        field(50015; "Lumpsum Items"; Boolean)
        {
            Caption = 'Lumpsum Items';
        }
        field(50016; "Is Insurance Policy"; Boolean)
        {
            Caption = 'Is Insurance Policy';
        }
        field(50017; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Insurance Code", "Policy No.")
        {
            Clustered = true;
        }
    }
}
