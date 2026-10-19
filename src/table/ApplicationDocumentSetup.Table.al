table 50385 "Application Document Setup"
{
    DrillDownPageID = "Application Document Setup";
    LookupPageID = "Application Document Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Document No."; Code[10])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Document Type"; Option)
        {
            OptionCaption = ' ,Member,Account,Loan';
            OptionMembers = " ","Member","Account","Loan";
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Single Party/Multiple"; Option)
        {
            OptionCaption = ' ,Single,Multiple,Business';
            OptionMembers = " ","Single","Multiple","Business";
            Caption = 'Single Party/Multiple';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




