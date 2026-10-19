table 50091 "Pr Employee Bank"
{
    Caption = 'Pr Employee Bank';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
            TableRelation = "HR Employees";
        }
        field(50010; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            TableRelation = "Bank Code Structure"."Bank Code";
        }
        field(50011; "Branch Code"; Code[20])
        {
            Caption = 'Brabch Code';
            TableRelation = "Bank Code Structure"."Branch Code" where("Bank Code" = field("Bank Code"));
        }
        field(50012; "Default"; Boolean)
        {
            Caption = 'Default';
        }
        field(50013; "Account No."; Code[100])
        {
            Caption = 'Account No.';
        }
        field(50014; "Percentage"; Decimal)
        {
            Caption = 'Percentage';
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50016; "Currency"; Code[20])
        {
            Caption = 'Currency';
        }
        field(50017; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
    }
    keys
    {
        key("PK"; "Employee Code", "Bank Code", "Branch Code")
        {
            Clustered = true;
        }
    }
}
