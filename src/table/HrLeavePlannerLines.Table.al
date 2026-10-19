namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using Microsoft.Finance.Dimension;
table 50021 "Hr Leave Planner Lines"
{
    Caption = 'Leave Planner Lines';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Enrty No."; Integer)
        {
            Caption = 'Enrty No.';
        }
        field(2; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            TableRelation = "Hr Employees"."No.";
        }
        field(3; "Staff Name"; Text[150])
        {
            Caption = 'Staff Name';
        }
        field(4; "January"; Decimal)
        {
            Caption = 'January';
        }
        field(5; "Feburuary"; Decimal)
        {
            Caption = 'Feburuary';
        }
        field(6; "March"; Decimal)
        {
            Caption = 'March';
        }
        field(7; "April"; Decimal)
        {
            Caption = 'April';
        }
        field(8; "May"; Decimal)
        {
            Caption = 'May';
        }
        field(9; "June"; Decimal)
        {
            Caption = 'June';
        }
        field(10; "July"; Decimal)
        {
            Caption = 'July';
        }
        field(11; "August"; Decimal)
        {
            Caption = 'August';
        }
        field(12; "September"; Decimal)
        {
            Caption = 'September';
        }
        field(13; "October"; Decimal)
        {
            Caption = 'October';
        }
        field(14; "November"; Decimal)
        {
            Caption = 'November';
        }
        field(15; "December"; Decimal)
        {
            Caption = 'December';
        }
        field(16; "Year"; Integer)
        {
            Caption = 'Year';
        }
        field(17; "Global Dimension 1 Code"; Code[10])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
        }
        field(18; "Global Dimension 2 Code"; Code[10])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
        }
        field(19; "Shortcut Dimension 3 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,1,3';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;
        }
        field(20; "Shortcut Dimension 4 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,1,4';
            Editable = false;
            TableRelation = "Dimension Value".Code Where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
        }
        field(21; "Document No."; Code[10])
        {
            Caption = 'Document No.';
        }
    }
    keys
    {
        key("PK"; "Enrty No.", "Year")
        {
            Clustered = true;
        }
    }
}
