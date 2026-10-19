tableextension 50030 "DetailedCustCvExtention" extends "Detailed CV Ledg. Entry Buffer"
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
}



