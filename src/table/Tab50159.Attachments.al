table 50159 "Attachments"
{
    DrillDownPageID = "Attachments Setup";
    LookupPageID = "Attachments Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Attachment"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment';
        }
        field(50010; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key("Key1"; "Attachment")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


