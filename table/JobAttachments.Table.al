table 50158 "Job Attachments"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Job ID"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Job ID';
        }
        field(50010; "Attachment"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Attachments;
            Caption = 'Attachment';
        
            trigger OnValidate()
            begin

                if Attachments.Get(Attachment) then
                    Description := Attachments.Description;
            end;
        }
        field(50011; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key("Key1"; "Job ID", "Attachment")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Attachments: Record Attachments;
}


