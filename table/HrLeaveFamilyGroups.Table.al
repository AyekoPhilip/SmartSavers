namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 50017 "Hr Leave Family Groups"
{
    Caption = 'Leave Family Groups';
    DataClassification = SystemMetadata;
    
    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
        }
        field(4; "Max Employees On Leave"; Integer)
        {
            Caption = 'Max Employees On Leave';
        }
    }
    keys
    {
        key("PK"; "Code")
        {
            Clustered = true;
        }
    }
}
