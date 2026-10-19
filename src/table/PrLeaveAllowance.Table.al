table 50101 "Pr Leave Allowance"
{
    Caption = 'Pr Leave Allowance';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Application No."; Code[50])
        {
            Caption = 'Application No.';
        }
        field(50010; "Employee No."; Code[100])
        {
            Caption = 'Employee No.';
            TableRelation = "HR Employees";
        }
        field(50011; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(50012; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(50013; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(50014; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50015; "Paid"; Boolean)
        {
            Caption = 'Paid';
        }
        field(50016; "Year"; Integer)
        {
            Caption = 'Year';
        }
        field(50017; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Application No.")
        {
            Clustered = true;
        }
    }
}
