// Reconstructed from SmartSaver symbols. Original triggers/procedure bodies are unavailable.
table 50032 "HR Non Working Days & Dates"
{
    Caption = 'HR Non Working Days & Dates';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(2; "Reason"; Text[100])
        {
            Caption = 'Reason';
        }
        field(3; "Recurring"; Boolean)
        {
            Caption = 'Recurring';
        }
    }
    keys
    {
        key("PK"; "Date")
        {
            Clustered = true;
        }
    }
}
