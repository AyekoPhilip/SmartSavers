table 50475 "ATM Linking  Statistics"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52018499;
    LookupPageID = 52018499;
 */
    fields
    {
        field(50009; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "ATM Application No."; Code[20])
        {
            Editable = false;
            Caption = 'ATM Application No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[20])
        {
            Editable = false;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Linking Type"; Option)
        {
            Editable = false;
            OptionCaption = ',Linking,Delinking';
            OptionMembers = "","Linking","Delinking";
            Caption = 'Linking Type';
            DataClassification = CustomerContent;
        }
        field(50013; "User ID"; Code[50])
        {
            Editable = false;
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50014; "Activity Date"; Date)
        {
            Editable = false;
            Caption = 'Activity Date';
            DataClassification = CustomerContent;
        }
        field(50015; "Activity Time"; Time)
        {
            Editable = false;
            Caption = 'Activity Time';
            DataClassification = CustomerContent;
        }
        field(50016; "Reason for change"; Text[250])
        {
            Caption = 'Reason for change';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




