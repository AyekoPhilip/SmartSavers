table 50282 "Signatories"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Admission,Fees Structure,Exam Signatory,Exam Officer,Travel Request,Offer Letter';
            OptionMembers = " ","Admission","Fees Structure","Exam Signatory","Exam Officer","Travel Request","Offer Letter";
            Caption = 'Document Type';
        }
        field(50010; "Signing Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Signing Name';
        }
        field(50011; "Title/Position"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Title/Position';
        }
        field(50012; "Signature"; Media)
        {
            DataClassification = CustomerContent;
            Caption = 'Signature';
        }
        field(50013; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key("Key1"; "Document Type", "Signing Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


