namespace DynamicsNav.SaccoDatabase.HrManagementMgt;
table 50016 "Hr Leave Attachments"
{
    Caption = 'Hr Leave Attachments';
    DataClassification = SystemMetadata;
    
    fields
    {
        field(1; "Employee No."; Code[100])
        {
            Caption = 'Employee No.';
        }
        field(2; "Document Description"; Text[100])
        {
            Caption = 'Document Description';
        }
        field(3; "Document Link"; Text[100])
        {
            Caption = 'Document Link';
        }
        field(4; "Attachment No."; Integer)
        {
            Caption = 'Attachment No.';
        }
        field(5; "Language Code (Default)"; Code[20])
        {
            Caption = 'Language Code (Default)';
        }
        field(6; "Attachment"; Option)
        {
            Caption = 'Attachment';
            OptionMembers = "No","Yes";
        }
    }
    keys
    {
        key("PK"; "Employee No.", "Document Description")
        {
            Clustered = true;
        }
    }
}
