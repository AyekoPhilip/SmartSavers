table 50553 "Fields Change Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'No.';
        }
        field(50010; "Field caption"; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Field caption';
        }
        field(50011; "Log Insertion"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Insertion';
        }
        field(50012; "Log Deletion"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Deletion';
        }
        field(50013; "Log Modification"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Modification';
        }
        field(50014; "Table No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Table No.';
        }
        field(50015; "Table Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Table Name';
        }
        field(50016; "Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Enabled';
        }
        field(50017; "Record No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Record No.';
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




