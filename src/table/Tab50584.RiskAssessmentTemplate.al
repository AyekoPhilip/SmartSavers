table 50584 "Risk Assessment Template"
{
    Caption = 'Risk Assessment Template';
    DataClassification = ToBeClassified;
    LookupPageId="Risk Assessment Template";
    DrillDownPageId="Risk Assessment Template";
    
    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Code")
        {
            Clustered = true;
        }
    }
}
