table 50085 "Pr Time Sheet"
{
    Caption = 'Pr Time Sheet';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Schedule Code"; Text[100])
        {
            Caption = 'Schedule Code';
        }
        field(50010; "Primary File Path"; Text[100])
        {
            Caption = 'Primary File Path';
        }
        field(50011; "Secondary File Path"; Text[100])
        {
            Caption = 'Secondary File Path';
        }
        field(50012; "Deleta After Import"; Boolean)
        {
            Caption = 'Deleta After Import';
        }
    }
    keys
    {
        key("PK"; "Schedule Code")
        {
            Clustered = true;
        }
    }
}
