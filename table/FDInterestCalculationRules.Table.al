table 50367 "FD Interest Calculation Rules"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Code"; Code[30])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Minimum Amount"; Decimal)
        {
            NotBlank = true;
            Caption = 'Minimum Amount';
            DataClassification = CustomerContent;
        }
        field(50012; "Maximum Amount"; Decimal)
        {
            NotBlank = true;
            Caption = 'Maximum Amount';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
            DataClassification = CustomerContent;
        }
        field(50014; "Allowed Margin"; Decimal)
        {
            Caption = 'Allowed Margin';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




