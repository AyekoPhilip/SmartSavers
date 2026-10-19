// Reconstructed from SmartSaver symbols. Original triggers/procedure bodies are unavailable.
table 50027 "Bulk Notification Header"
{
    Caption = 'Bulk Notification Header';
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(50010; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
        }
        field(50011; "Time Entered"; Time)
        {
            Caption = 'Time Entered';
        }
        field(50012; "Entered By"; Code[100])
        {
            Caption = 'Entered By';
            TableRelation = "User Setup";
        }
        field(50013; "SMS Type"; Option)
        {
            Caption = 'SMS Type';
            OptionMembers = "Dimension","Telephone","Everyone";
        }
        field(50014; "SMS Status"; Option)
        {
            Caption = 'SMS Status';
            OptionMembers = "Pending","Sent","Cancelled";
        }
        field(50015; "Status Date"; Date)
        {
            Caption = 'Status Date';
        }
        field(50016; "Status Time"; Time)
        {
            Caption = 'Status Time';
        }
        field(50017; "Status By"; Code[100])
        {
            Caption = 'Status By';
        }
        field(50018; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
        }
        field(50019; "Messages"; Text[250])
        {
            Caption = 'Messages';
        }
        field(50020; "No. Series"; Code[50])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(50021; "Use Line Message"; Boolean)
        {
            Caption = 'Use Line Message';
        }
        field(50022; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
        }
        field(50023; "Group Code"; Code[50])
        {
            Caption = 'Group Code';
        }
        field(50024; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50025; "Posted By"; Code[100])
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(50026; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionMembers = "Sms","Email";
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}
