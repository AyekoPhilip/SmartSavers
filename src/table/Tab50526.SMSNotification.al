table 50526 "SMS Notification"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No"; Integer)
        {
            AutoIncrement = true;
            NotBlank = true;
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "Source"; Enum "NotifSourceType")
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(50011; "Telephone No"; Code[20])
        {
            Caption = 'Telephone No';
            DataClassification = CustomerContent;
        }
        field(50012; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50013; "Time Entered"; Time)
        {
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50014; "Entered By"; Code[150])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50015; "SMS Message"; Text[250])
        {
            Caption = 'SMS Message';
            DataClassification = CustomerContent;
        }
        field(50016; "Sent To Server"; Option)
        {
            OptionCaption = 'No,Yes,Failed';
            OptionMembers = "No","Yes","Failed";
            Caption = 'Sent To Server';
            DataClassification = CustomerContent;
        }
        field(50017; "Date Sent to Server"; Date)
        {
            Caption = 'Date Sent to Server';
            DataClassification = CustomerContent;
        }
        field(50018; "Account No"; Code[30])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50019; "Document No"; Code[100])
        {
            Caption = 'Document No';
            DataClassification = CustomerContent;
        }
        field(50020; "System Created Entry"; Boolean)
        {
            Caption = 'System Created Entry';
            DataClassification = CustomerContent;
        }
        field(50021; "Bulk SMS Balance"; Decimal)
        {
            Caption = 'Bulk SMS Balance';
            DataClassification = CustomerContent;
        }
        field(50022; "IsChargeable"; Boolean)
        {
            Caption = 'IsChargeable';
            DataClassification = CustomerContent;
        }
        field(50023; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50024; "Source2"; Code[20])
        {
            Caption = 'Source2';
            DataClassification = CustomerContent;
        }
        field(50025; "Entry No2"; Integer)
        {
            AutoIncrement = false;
            Caption = 'Entry No2';
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




