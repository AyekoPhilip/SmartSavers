namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.AuditCodes;
using System.Security.User;
using Microsoft.Finance.Dimension;
table 50028 "Hr Leave Ledger Entry"
{
    Caption = 'Leave Ledger Entry';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Leave Calendar Code"; Code[20])
        {
            Caption = 'Leave Calendar Code';
            TableRelation = "Hr Leave Calendar"."Calendar Code";
        }
        field(3; "Closed"; Boolean)
        {
            Caption = 'Closed';
        }
        field(4; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            TableRelation = "Hr Employees";
        }
        field(5; "Staff Name"; Text[150])
        {
            Caption = 'Staff Name';
            Editable = false;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Leave Entry Type"; Option)
        {
            Caption = 'Leave Entry Type';
            OptionMembers = "Positive","Negative","Reimbursement";
        }
        field(8; "Leave Approval Date"; Date)
        {
            Caption = 'Leave Approval Date';
        }
        field(9; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(11; "Job ID"; Code[20])
        {
            Caption = 'Job ID';
        }
        field(12; "Job Group"; Code[20])
        {
            Caption = 'Job Group';
        }
        field(13; "Contract Type"; Code[20])
        {
            Caption = 'Contract Type';
        }
        field(14; "No. of Days"; Decimal)
        {
            Caption = 'No. of Days';
        }
        field(15; "Leave Start Date"; Date)
        {
            Caption = 'Leave Start Date';
        }
        field(16; "Leave Posting Description"; Text[150])
        {
            Caption = 'Leave Posting Description';
        }
        field(17; "Leave End Date"; Date)
        {
            Caption = 'Leave End Date';
        }
        field(18; "Leave Return Date"; Date)
        {
            Caption = 'Leave Return Date';
        }
        field(19; "Global Dimension 1 Code"; Code[10])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(20; "Global Dimension 2 Code"; Code[10])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
        }
        field(21; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(22; "User ID"; Code[10])
        {
            Caption = 'User ID';
            TableRelation = "User Setup";
        }
        field(23; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(24; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(25; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(26; "Index Entry"; Boolean)
        {
            Caption = 'Index Entry';
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(28; "Leave Recalled No."; Code[10])
        {
            Caption = 'Leave Recalled No.';
            TableRelation = "Hr Leave Mgt."."No." where("Applicant Staff No." = field("Staff No."));
        }
        field(29; "Leave Type"; Code[10])
        {
            Caption = 'Leave Type';
            TableRelation = "Hr Leave Type";
        }
        field(30; "Is For Annual Leave"; Boolean)
        {
            Caption = 'Is For Annual Leave';
        }
    }
    keys
    {
        key("PK"; "Entry No.")
        {
            Clustered = true;
        }
        key("PK2"; "Leave Calendar Code", "Posting Date")
        {
            SumIndexFields = "No. of Days";
        }
        key("PK3"; "Leave Calendar Code", "Closed", "Posting Date")
        {
            SumIndexFields = "No. of Days";
        }
        key("PK4"; "Staff No.", "Leave Calendar Code", "Posting Date")
        {
            SumIndexFields = "No. of Days";
        }
        key("PK5"; "Staff No.", "Closed", "Posting Date")
        {
            SumIndexFields = "No. of Days";
        }
        key("PK6"; "Posting Date", "Leave Entry Type", "Staff No.")
        {
            SumIndexFields = "No. of Days";
        }
        key("PK7"; "Staff No.")
        {
            SumIndexFields = "No. of Days";
        }
        key("PK8"; "Leave Entry Type", "Staff No.", "Closed")
        {
            SumIndexFields = "No. of Days";
        }
    }
}
