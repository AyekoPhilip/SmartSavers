tableextension 50021 "DocumentAttachExt" extends "Document Attachment"
{
    fields
    {
        field(50009; "New Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(50010; "Record No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Record No.';
        }
    }
}



