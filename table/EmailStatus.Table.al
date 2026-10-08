table 50465 "Email Status"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No"; Code[10])
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = CustomerContent;
        }
        field(50011; "Period"; Date)
        {
            Caption = 'Period';
            DataClassification = CustomerContent;
        }
        field(50012; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Sent"; Boolean)
        {
            Caption = 'Sent';
            DataClassification = CustomerContent;
        }
        field(50014; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50015; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50016; "Time"; Time)
        {
            Caption = 'Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




