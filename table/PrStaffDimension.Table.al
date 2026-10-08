table 50083 "Pr Staff Dimension"
{
    Caption = 'Pr Staff Dimension';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Employee Code"; Code[100])
        {
            Caption = 'Employee Code';
        }
        field(50010; "Dimension 0"; Text[100])
        {
            Caption = 'Dimension 0';
        }
        field(50011; "Dimension 1"; Text[100])
        {
            Caption = 'Dimension 1';
        }
        field(50012; "Dimension 2"; Text[100])
        {
            Caption = 'Dimension 2';
        }
        field(50013; "Dimension 3"; Text[100])
        {
            Caption = 'Dimension 3';
        }
        field(50014; "Dimension 4"; Text[100])
        {
            Caption = 'Dimension 4';
        }
        field(50015; "Dimension 5"; Text[100])
        {
            Caption = 'Dimension 5';
        }
        field(50016; "Percentage"; Decimal)
        {
            Caption = 'Percentage';
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
