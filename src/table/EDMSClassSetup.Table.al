table 50035 "EDMS Class Setup"
{
    Caption = 'EDMS Class Setup';
    DataClassification = SystemMetadata;

    fields
    {
        field(50009; "S/No."; Code[20])
        {
            Caption = 'S/No.';
            DataClassification = SystemMetadata;
        }
        field(50010; "Class Name"; Text[100])
        {
            Caption = 'Class Name';
            DataClassification = SystemMetadata;
        }
        field(50011; "Class Number"; Integer)
        {
            Caption = 'Class Number';
            DataClassification = SystemMetadata;
        }
        field(50012; "Ref. Code"; Code[50])
        {
            Caption = 'Ref. Code';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key("PK"; "S/No.")
        {
            Clustered = true;
        }
    }
}



