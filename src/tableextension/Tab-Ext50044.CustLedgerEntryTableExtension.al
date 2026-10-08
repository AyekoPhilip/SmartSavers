tableextension 50044 "CustLedgerEntryTableExtension" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50009; "Period Reference"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Reference';
        }

        field(50010; "Payroll Loan No."; Code[50])
        {
            Caption = 'Loan No. (Customer)';
            DataClassification = CustomerContent;
        }
        field(50011; "Extra Payment"; Boolean)
        {
            Caption = 'Extra Payment';
            DataClassification = CustomerContent;
        }
        field(50012; "Transaction Priority"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Priority';
        }
        field(50013; "Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
            Editable = false;
        }
        field(50014; "Transaction Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
            Editable = false;
        }
        field(50015; "Member No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Member No.';
            Editable = false;
        }


    }
}


