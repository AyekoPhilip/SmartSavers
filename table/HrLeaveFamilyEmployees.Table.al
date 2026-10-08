namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 50018 "Hr Leave Family Employees"
{
    Caption = 'Leave Family Employees';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Family"; Code[20])
        {
            Caption = 'Family';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = "Hr Employees"."No.";
        }
        field(3; "Remarks"; Text[100])
        {
            Caption = 'Remarks';
        }
    }
    keys
    {
        key("PK"; "Family")
        {
            Clustered = true;
        }
    }
}
