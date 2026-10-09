namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Location;
table 50020 "Hr Leave Planner Header"
{
    Caption = 'Leave Planner Header';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'No.';
        }
        field(2; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "New","Pending Approval","HOD Approval","HR Approval","MD Approval","Rejected","Canceled","Approved","On leave","Resumed","Posted";
            OptionCaption = 'New,Pending Approval,HOD Approval,HR Approval,Final Approval,Rejected,Canceled,Approved,On leave,Resumed,Posted';
        }
        field(3; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "HOD"; Code[100])
        {
            Caption = 'HOD';
        }
        field(6; "Year"; Integer)
        {
            Caption = 'Year';
        }
        field(7; "User ID"; Code[100])
        {
            Caption = 'User ID';
        }
        field(8; "Employee No."; Code[100])
        {
            Caption = 'Employee No.';
        }
        field(9; "Supervisor"; Code[100])
        {
            Caption = 'Supervisor';
        }
        field(10; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(11; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(12; "Global Dimension 2 Code"; Code[10])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
        }
        field(13; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
        }
        field(14; "Document Type"; Enum "CustomApprovalEntriesDocType")
        {
            Caption = 'Document Type';
        }
        field(15; "Shortcut Dimension 3 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,1,3';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;
        }
        field(16; "Shortcut Dimension 4 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,1,4';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}
