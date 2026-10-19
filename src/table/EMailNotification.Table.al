table 50490 "E-Mail Notification"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Document Type"; Option)
        {
            OptionCaption = ' ,Account Statement';
            OptionMembers = " ","Account Statement";
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50010; "Path To Save Report"; Text[250])
        {
            Caption = 'Path To Save Report';
            DataClassification = CustomerContent;
        }
        field(50011; "Sender Name"; Text[100])
        {
            Caption = 'Sender Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Sender E-Mail"; Text[100])
        {
            Caption = 'Sender E-Mail';
            DataClassification = CustomerContent;
        }
        field(50013; "Send To CC"; Text[250])
        {
            Caption = 'Send To CC';
            DataClassification = CustomerContent;
        }
        field(50014; "Send To BCC"; Text[250])
        {
            Caption = 'Send To BCC';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




