tableextension 50038 "PurchCrMemoHdrExt" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50009; "Reason Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Description';
        }
    }
}


