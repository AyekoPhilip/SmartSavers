namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using System.Security.User;
table 50024 "Hr Leave Calendar"
{
    Caption = 'Leave Calendar';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Calendar Code"; Code[20])
        {
            Caption = 'Calendar Code';
        }
        field(2; "Created By"; Code[100])
        {
            Caption = 'Created By';
            TableRelation = "User Setup";
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(4; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(5; "Current Leave Calendar"; Boolean)
        {
            Caption = 'Current Leave Calendar';
        }
        field(6; "Description"; Text[150])
        {
            Caption = 'Description';
        }
        field(7; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(8; "Last Modified By"; Code[100])
        {
            Caption = 'Last Modified By';
            TableRelation = "User Setup"."User ID";
        }
        field(9; "Date Modified"; Date)
        {
            Caption = 'Date Modified';
        }
    }
    keys
    {
        key("PK"; "Calendar Code")
        {
            Clustered = true;
        }
    }
}
