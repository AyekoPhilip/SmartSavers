namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 99001 "Hr Non Working Day & Date"
{
    Caption = 'Hr Non Working Day & Date';
    DataClassification = SystemMetadata;
    
    fields
    {
        field(1; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(2; Reason; Text[100])
        {
            Caption = 'Reason';
        }
        field(3; Recurring; Boolean)
        {
            Caption = 'Recurring';
        }
    }
    keys
    {
        key(PK; "Date")
        {
            Clustered = true;
        }
    }
}
