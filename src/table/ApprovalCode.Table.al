table 50547 "Approval Code"
{
    DrillDownPageID = "Approval Code";
    LookupPageID = "Approval Code";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Linked To Table Name"; Text[50])
        {
            Caption = 'Linked To Table Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Linked To Table No."; Integer)
        {
            Caption = 'Linked To Table No.';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));
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
    }

    keys
    {
        key("Key1"; "Code")
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




