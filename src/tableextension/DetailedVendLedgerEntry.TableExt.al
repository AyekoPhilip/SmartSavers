tableextension 50056 "DetailedVendLedgerEntry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(50009; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key18; "Posting Date")
        {

        }
    }
    

}



