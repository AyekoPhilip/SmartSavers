namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;
table 50011 "Hr Leave Journal Batch"
{
    Caption = 'Hr Leave Journal Batch';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Journal Template Name"; Code[20])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Hr Leave Journal Template".Name;
        }
        field(2; "Name"; Code[20])
        {
            Caption = 'Name';
        }
        field(3; "Description"; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(6; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(7; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Positive","Negative";
        }
        field(8; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(9; "Approval Status"; Enum "ApprovalStatus")
        {

        }
    }
    keys
    {
        key("PK"; "Journal Template Name", "Name")
        {
            Clustered = true;
        }
    }

    procedure SetupNewBatch()
    var
        IsHandled: Boolean;
        GenJnlTemplate: Record "Hr Leave Journal Template";
    begin

        GenJnlTemplate.Get("Journal Template Name");
        "No. Series" := GenJnlTemplate."No. Series";
        "Posting No. Series" := GenJnlTemplate."Posting No. Series";
        "Reason Code" := GenJnlTemplate."Reason Code";
    end;
}
