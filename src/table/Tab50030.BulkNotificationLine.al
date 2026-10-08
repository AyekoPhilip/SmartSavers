// Reconstructed from SmartSaver symbols. Original triggers/procedure bodies are unavailable.
table 50030 "Bulk Notification Line"
{
    Caption = 'Bulk Notification Line';
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(50010; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(50011; "Phone No."; Code[20])
        {
            Caption = 'Dimension/Phone No.';
            Editable = false;
        }
        field(50012; "Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(50013; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            Editable = false;
        }
        field(50014; "Account No."; Code[100])
        {
            Caption = 'Member No.';
            TableRelation = Member."No.";
        }
    }
    keys
    {
        key("PK"; "No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}
