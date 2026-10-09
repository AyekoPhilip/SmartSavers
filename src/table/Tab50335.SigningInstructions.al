table 50335 "Signing Instructions"
{
    Caption = 'Signing Instructions';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Signing Instructions";
    LookupPageId = "Signing Instructions";
    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50011; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50012; "ID No."; Code[50])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50013; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50014; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50015; "Signatory"; Boolean)
        {
            Caption = 'Signatory';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50016; "Must be Present"; Boolean)
        {
            Caption = 'Must be Present';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50017; "Must Sign"; Boolean)
        {
            Caption = 'Must Sign';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50018; "Available"; Boolean)
        {
            Caption = 'Available';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "No.", "Account No.", "ID No.")
        {
            Clustered = true;
        }
    }
}



