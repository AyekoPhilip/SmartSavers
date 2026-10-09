namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.AuditCodes;
using System.Reflection;
using Microsoft.Finance.GeneralLedger.Journal;
table 50010 "Hr Leave Journal Template"
{
    Caption = 'Hr Leave Journal Template';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Name"; Text[150])
        {
            Caption = 'Name';
        }
        field(2; "Description"; Text[150])
        {
            Caption = 'Description';
        }
        field(3; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
        }
        field(4; "Form ID"; Integer)
        {
            Caption = 'Form ID';
        }
        field(5; "Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';
        }
        field(6; "Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
        }
        field(7; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(8; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(9; "Test Report Name"; Text[80])
        {
            Caption = 'Test Report Name';
        }
        field(10; "Form Name"; Text[80])
        {
            Caption = 'Form Name';
        }
        field(11; "Posting Report Name"; Text[80])
        {
            Caption = 'Posting Report Name';
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(13; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(14; "Type"; Enum "Gen. Journal Template Type")
        {
            Caption = 'Type';
        
            trigger OnValidate()
            begin

            end;
        }
        field(15; "Recurring"; Boolean)
        {

        }
         field(16; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));
        
            trigger OnValidate()
            begin
                if "Page ID" = 0 then
                    Validate(Type);
            end;
        }
    }
    keys
    {
        key("PK"; "Name")
        {
            Clustered = true;
        }
    }
}
