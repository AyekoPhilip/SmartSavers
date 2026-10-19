table 50052 "EDMS Class Subject"
{
    Caption = 'EDMS Class Subject';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Class S/No."; Code[20])
        {
            Caption = 'Class S/No.';
            DataClassification = SystemMetadata;
        }
        field(50010; "S/No."; Code[20])
        {
            Caption = 'S/No.';
            DataClassification = SystemMetadata;
        }
        field(50011; "Subject"; Enum "EDMS Document Type")
        {
            Caption = 'Subject';
            DataClassification = SystemMetadata;
        }
        field(50012; "Reference Number"; Code[50])
        {
            Caption = 'Reference Number';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key("PK"; "Class S/No.", "S/No.")
        {
            Clustered = true;
        }
    }
}



