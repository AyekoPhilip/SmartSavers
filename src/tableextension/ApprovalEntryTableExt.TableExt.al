tableextension 50012 "ApprovalEntryTableExt" extends "Approval Entry"
{
    fields
    {
        field(50009; "Approval Stage"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50011; "Workflow User Group Code"; Code[20])
        {
            TableRelation = "Workflow User Group".Code;
            DataClassification = CustomerContent;
        }
        field(50012; "Delegated From"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(50013; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Staff No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50015; "Approver Staff No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Payroll period start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }
}


