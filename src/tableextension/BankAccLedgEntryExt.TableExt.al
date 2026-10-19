tableextension 50003 "BankAccLedgEntryExt" extends "Bank Account Ledger Entry"

{

    fields
    {
        field(50009; "Investment Code"; Code[100])
        {
            Caption = 'Investment Code';
            DataClassification = CustomerContent;
        }
        field(50010; "No. of Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Units';
        }
         field(50011; "Member No"; Code[50])
        {
            Caption = 'Member No';
            DataClassification = ToBeClassified;
        }
        field(50012;"Statement Difference";Decimal)
        {
            DataClassification = CustomerContent;

        }
    }
}



