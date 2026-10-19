table 50111 "Rules & Regulations"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(50010; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(50011; "Rules & Regulations"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Rules & Regulations';
        }
        field(50012; "Document Link"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Link';
        }
        field(50013; "Remarks"; Text[200])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Remarks';
        }
        field(50014; "Language Code (Default)"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Language Code (Default)';
        }
        field(50015; "Attachement"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "No","Yes";
            Caption = 'Attachement';
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


