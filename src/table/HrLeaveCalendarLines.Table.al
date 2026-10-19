namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 50026 "Hr Leave Calendar Lines"
{
    Caption = 'Leave Calendar Lines';
    DataClassification = SystemMetadata;
    
    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Day"; Text[50])
        {
            Caption = 'Day';
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; "Non Working"; Boolean)
        {
            Caption = 'Non Working';
        }
        field(5; "Reason"; Text[100])
        {
            Caption = 'Reason';
        }
    }
    keys
    {
        key("PK"; "Code", "Date")
        {
            Clustered = true;
        }
    }
}
