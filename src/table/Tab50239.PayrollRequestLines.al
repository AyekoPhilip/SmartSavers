table 50239 "Payroll Request Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(50010; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(50011; "Employee Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Name';
        }
        field(50012; "Previous Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Previous Value';
        }
        field(50013; "New Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'New Value';
        }
        field(50014; "Change"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Change';
        }
    }

    keys
    {
        key("Key1"; "No.", "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


