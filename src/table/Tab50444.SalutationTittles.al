table 50444 "Salutation Tittles"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52018515;
    LookupPageID = 52018515; */

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Type"; Option)
        {
            OptionCaption = ',Tittle,Position';
            OptionMembers = "","Tittle","Position";
            Caption = 'Type';
            DataClassification = CustomerContent;
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
}




