namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 50014 "HR Leave Periods"
{
    Caption = 'HR Leave Periods';
    DataClassification = SystemMetadata;
    
    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(2; "Period Description"; Text[100])
        {
            Caption = 'Period Description';
        }
        field(3; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';
        }
        field(4; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
        }
        field(6; "Reimbursement Clossing Date"; Boolean)
        {
            Caption = 'Reimbursement Clossing Date';
        }
        field(7; "Period Code"; Code[20])
        {
            Caption = 'Period Code';
        }
    }
    keys
    {
        key("PK"; "Starting Date")
        {
            Clustered = true;
        }
    }
}
