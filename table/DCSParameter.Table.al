table 50497 "DCS Parameter"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Qualification Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Check-Off Loan,Secured Lending';
            OptionMembers = "Check-Off Loan","Secured Lending";
            Caption = 'Qualification Type';
        }
        field(50012; "Calculation"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Calculation';
        }
    }

    keys
    {
        key("Key1"; "Code", "Qualification Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




