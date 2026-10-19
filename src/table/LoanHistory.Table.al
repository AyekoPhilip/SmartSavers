table 50470 "Loan History"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan Product Type"; Code[10])
        {
            Caption = 'Loan Product Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Loan Status"; Option)
        {
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = "Perfoming","Watch","Substandard","Doubtful","Loss";
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(50012; "Outstanding Interest"; Decimal)
        {
            Caption = 'Outstanding Interest';
            DataClassification = CustomerContent;
        }
        field(50013; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50014; "Outanding Bill"; Decimal)
        {
            Caption = 'Outanding Bill';
            DataClassification = CustomerContent;
        }
        field(50015; "Loan Application No."; Code[50])
        {
            Caption = 'Loan Application No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Loan Issued Date"; Date)
        {
            Caption = 'Loan Issued Date';
            DataClassification = CustomerContent;
        }
        field(50017; "Loan Expiry Date"; Date)
        {
            Caption = 'Loan Expiry Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan No.", "Loan Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




