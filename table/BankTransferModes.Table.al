table 50485 "Bank Transfer Modes"
{
    DataClassification = CustomerContent;
    //LookupPageID = 52018524;

    fields
    {
        field(50009; "Document No."; Code[10])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types" WHERE(Type = CONST("Bank Transfer Mode"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




