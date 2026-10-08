tableextension 50031 "ContactExt" extends Contact
{
    fields
    {
        field(50009; "Application No."; Code[50])
        {
            Caption = 'Application No.';
            DataClassification = CustomerContent;
        }
        field(50010; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(key1; "Application No.", "ID No.")
        {

        }

    }


}



