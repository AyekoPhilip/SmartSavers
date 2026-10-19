table 50169 "Temp. Data (Reporting)"
{
    Caption = 'Temp. Data (Reporting)';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(50011; "Decription"; Text[150])
        {
            Caption = 'Decription';
            DataClassification = ToBeClassified;
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(50013; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(50014; "Found"; Boolean)
        {
            Caption = 'Found';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}



