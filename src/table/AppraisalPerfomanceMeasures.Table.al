table 50295 "Appraisal Perfomance Measures"
{
    Caption = 'Appraisal Perfomance Measures';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Workplan Code"; Code[50])
        {
            Caption = 'Workplan Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[50])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Workplan Code", "Code")
        {
            Clustered = true;
        }
    }
}



