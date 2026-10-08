table 50309 "Apprvals. Comment Line"
{
    Caption = 'Apprvals. Comment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = ToBeClassified;
        }
        field(50011; "Document Type"; Enum "CustomApprovalEntriesDocType")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(50012; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(50013; "User ID"; Code[100])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(50014; "Date and Time"; DateTime)
        {
            Caption = 'Date and Time';
            DataClassification = ToBeClassified;
        }
        field(50015; "Comment"; Text[150])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50016; "Record ID to Approve"; RecordId)
        {
            Caption = 'Record ID to Approve';
            DataClassification = ToBeClassified;
        }
        field(50017; "Workflow Step Instance ID"; Guid)
        {
            Caption = 'Workflow Step Instance ID';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "Entry No.")
        {
            Clustered = true;
        }
        key("key2"; "Table ID", "Document Type", "Document No.", "Record ID to Approve")
        {

        }
        key("key3"; "Workflow Step Instance ID")
        {

        }
    }
    var
        ApprovalCommentLine: Record "Apprvals. Comment Line";
}



