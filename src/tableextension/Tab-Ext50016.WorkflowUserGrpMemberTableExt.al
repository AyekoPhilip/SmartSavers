tableextension 50016 "WorkflowUserGrpMemberTableExt" extends "Workflow User Group Member"
{
    fields
    {
        field(50009; "Approval Stages"; Code[20])
        {
            TableRelation = "Approval Stages"."Approval Stage";
            DataClassification = CustomerContent;
            Caption = 'Approval Stages';
        }
        field(50010; "Delegated From"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'Delegated From';
        }
    }
}
