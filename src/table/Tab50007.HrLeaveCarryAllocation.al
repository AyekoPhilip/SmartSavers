namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Location;
using System.Security.User;
using Microsoft.Finance.Dimension;
table 50007 "Hr Leave Carry Allocation"
{
    Caption = 'Hr Leave Carry Allocation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Application Code"; Code[50])
        {
            Caption = 'Application Code';
        }
        field(2; "Application Date"; Date)
        {
            Caption = 'Application Date';
        }
        field(3; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "New","Pending Approval","HOD Approval","HR Approval","MD Approval","Rejected","Canceled","Approved","On leave","Resumed","Posted";
            OptionCaption = 'New,Pending Approval,HOD Approval,HR Approval,Final Approval,Rejected,Canceled,Approved,On leave,Resumed,Posted';
        }
        field(4; "Applicant Comments"; Text[150])
        {
            Caption = 'Applicant Comments';
        }
        field(5; "No series"; Code[10])
        {
            Caption = 'No series';
            TableRelation = "No. Series";
        }
        field(6; "Selected"; Boolean)
        {
            Caption = 'Selected';
        }
        field(7; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(8; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(9; "Name"; Text[150])
        {
            Caption = 'Name';
        }
        field(10; "Description"; Text[150])
        {
            Caption = 'Description';
        }
        field(11; "Job Title"; Code[10])
        {
            Caption = 'Job Title';
        }
        field(12; "User ID"; Code[100])
        {
            Caption = 'User ID';
            TableRelation = "User Setup"."User ID";
        }
        field(13; "Employee No."; Code[100])
        {
            Caption = 'Employee No.';
            TableRelation = "Hr Employees"."No.";
        }
        field(14; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(15; "Approved Days"; Integer)
        {
            Caption = 'Approved Days';
        }
        field(16; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
        }
        field(17; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(18; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Application Code")
        {
            Clustered = true;
        }
    }
}
