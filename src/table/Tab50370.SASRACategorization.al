table 50370 "SASRA Categorization"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loans Category-SASRA"; Option)
        {
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = "Perfoming","Watch","Substandard","Doubtful","Loss";
            Caption = 'Loans Category-SASRA';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




