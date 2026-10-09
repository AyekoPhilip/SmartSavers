table 50059 "HR Job Qualification"
{
    Caption = 'Job Qualification';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Qualification Type"; Code[50])
        {
            Caption = 'Qualification Type';
        }
        field(50010; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Qualification Type", "Code")
        {
            Clustered = true;
        }
    }
}
