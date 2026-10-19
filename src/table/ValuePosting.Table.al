table 50341 "Value Posting"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "UserID"; Code[50])
        {
            TableRelation = User."User Name";
            Caption = 'UserID';
            DataClassification = CustomerContent;
        }
        field(50010; "Value Posting"; Integer)
        {
            Caption = 'Value Posting';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "UserID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




