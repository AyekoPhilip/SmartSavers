table 50545 "Notification Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Text Label';
        }
        field(50010; "Membership Application"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50011; "Loan Application"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Application';
        }
        field(50012; "Linked To Table No."; Integer)
        {
            Caption = 'Linked To Table No.';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = CONST(Table));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Objects.SetRange("Object Type", Objects."Object Type"::Table);
                Objects.SetRange("Object ID", "Linked To Table No.");
                if Objects.FindFirst then
                    "Linked To Table Name" := Objects."Object Name"
                else
                    "Linked To Table Name" := '';
            end;
        }
        field(50013; "Linked To Table Name"; Text[50])
        {
            Caption = 'Linked To Table Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; "Entry Type"; Enum "NotifEntryType")
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Linked To Table No.", "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    var
        Objects: Record AllObjWithCaption;
}




