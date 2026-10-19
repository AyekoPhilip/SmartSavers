table 50102 "Pr Membership Group"
{
    Caption = 'Pr Membership Group';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Group No."; Code[100])
        {
            Caption = 'Group No.';
        }
        field(50010; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(50011; "Comments"; Text[100])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Group No.")
        {
            Clustered = true;
        }
    }
}
