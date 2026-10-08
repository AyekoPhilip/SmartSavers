tableextension 50026 "DetailedCustLedgerEntry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(50009; "Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
            Editable = false;
        }
        field(50010; "Transaction Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
            Editable = false;
        }
        field(50011; "Member No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Member No.';
            Editable = false;
        }

    }
    keys
    {
        key(Key18; "Posting Date")
        {

        }
    }

}




