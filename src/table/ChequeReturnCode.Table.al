table 50430 "Cheque Return Code"
{
    DrillDownPageID = "Loan List";
    LookupPageID = "Loan List";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Return Code"; Code[2])
        {
            Caption = 'Return Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Code Interpretation"; Text[100])
        {
            Caption = 'Code Interpretation';
            DataClassification = CustomerContent;
        }
        field(50011; "Charges"; Decimal)
        {
            Caption = 'Charges';
            DataClassification = CustomerContent;
        }
        field(50012; "Bounced Charges GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Bounced Charges GL Account';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Return Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Return Code", "Code Interpretation")
        {
        }
    }
}




