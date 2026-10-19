table 50068 "Pr Payroll Period"
{
    Caption = 'Pr Payroll Period';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Period Month"; Integer)
        {
            Caption = 'Period Month';
            DataClassification = CustomerContent;
        }
        field(50010; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
        field(50011; "Period Name"; Text[100])
        {
            Caption = 'Period Name';
        }
        field(50012; "Date Closed"; Date)
        {
            Caption = 'Date Closed';
        }
        field(50013; "Date Opened"; Date)
        {
            Caption = 'Date Opened';
        }
        field(50014; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }
        field(50015; "Created By"; Code[100])
        {
            Caption = 'Created By';
            TableRelation = "User Setup";
        }
        field(50016; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            TableRelation = "User Setup";
        }
        field(50017; "Payroll Code"; Code[10])
        {

        }
    }
    keys
    {
        key("PK"; "Date Opened")
        {
            Clustered = true;
        }
    }
    
}
