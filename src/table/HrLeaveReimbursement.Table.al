namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Location;
using System.Security.User;
table 50019 "Hr Leave Reimbursement"
{
    Caption = 'Leave Reimbursement';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Application Code"; Code[50])
        {
            Caption = 'Application Code';
        }
        field(2; "Leave Type"; Code[20])
        {
            Caption = 'Leave Type';
            TableRelation = "Hr Leave Type".Code;
        }
        field(3; "Days Applied"; Decimal)
        {
            Caption = 'Days Applied';
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(5; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
        field(6; "Application Date"; Date)
        {
            Caption = 'Application Date';
        }
        field(7; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Status';
        }
        field(8; "Applicant Comments"; TableFilter)
        {
            Caption = 'Applicant Comments';
        }
        field(9; "No. series"; Code[10])
        {
            Caption = 'No. series';
        }
        field(10; "Selected"; Boolean)
        {
            Caption = 'Selected';
        }
        field(11; "Current Balance"; Decimal)
        {
            Caption = 'Current Balance';
        }
        field(12; "Posted"; Boolean)
        {
            Caption = 'Posted';
        }
        field(13; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            TableRelation = "User Setup";
        }
        field(14; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
        }
        field(15; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
        }
        field(16; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(17; "Total Taken"; Decimal)
        {
            Caption = 'Total Taken';
        }
        field(18; "E-mail Address"; Code[100])
        {
            Caption = 'E-mail Address';
        }
        field(19; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(21; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
        }
        field(22; "Request Leave Allowance"; Boolean)
        {
            Caption = 'Request Leave Allowance';
        }
        field(23; "Name"; Text[150])
        {
            Caption = 'Name';
        }
        field(24; "Leave Allowance Entittlement"; Boolean)
        {
            Caption = 'Leave Allowance Entittlement';
        }
        field(25; "Leave Allowance Amount"; Decimal)
        {
            Caption = 'Leave Allowance Amount';
        }
        field(26; "Details of Examination"; Text[150])
        {
            Caption = 'Details of Examination';
        }
        field(27; "Date of Exam"; Date)
        {
            Caption = 'Date of Exam';
        }
        field(28; "Reliever"; Code[100])
        {
            Caption = 'Reliever';
            TableRelation = "Hr Employees"."No." where(Status = filter(Active));
        }
        field(29; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Supervisor Email"; Code[20])
        {
            Caption = 'Supervisor Email';
        }
        field(31; "Job Title"; Code[10])
        {
            Caption = 'Job Title';
        }
        field(32; "User ID"; Code[100])
        {
            Caption = 'User ID';
            TableRelation = "User Setup";
        }
        field(33; "Employee No."; Code[100])
        {
            Caption = 'Employee No.';
            TableRelation = "Hr Employees"."No." where(Status = filter(Active));
        }
        field(34; "Supervisor"; Code[100])
        {
            Caption = 'Supervisor';
            TableRelation = "Hr Employees"."No.";
        }
        field(35; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(36; "Leave Application No."; Code[50])
        {
            Caption = 'Leave Application No.';
            TableRelation = "Hr Leave Mgt."."No.";
        }
        field(37; "Days to Reimburse"; Decimal)
        {
            Caption = 'Days to Reimburse';
        }
        field(38; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(39; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(2));
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
