table 50301 "Mobile Money Transaction"
{
    Caption = 'Mobile Money Transaction';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = ToBeClassified;
        }
        field(50011; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50012; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(50014; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(50015; "Transaction Type"; Enum "MobileTransactionTypes")
        {
            Caption = 'Transaction Type';
            DataClassification = ToBeClassified;
        }
        field(50016; "Transaction Time"; Time)
        {
            Caption = 'Transaction Time';
            DataClassification = ToBeClassified;
        }
        field(50017; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
        }
        field(50018; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(50019; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = ToBeClassified;
        }
        field(50020; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = ToBeClassified;
        }
        field(50021; "Message"; Text[150])
        {
            Caption = 'Message';
            DataClassification = ToBeClassified;
        }
        field(50022; "Need Change"; Boolean)
        {
            Caption = 'Need Change';
            DataClassification = ToBeClassified;
        }
        field(50023; "Old Account No."; Code[100])
        {
            Caption = 'Old Account No.';
            DataClassification = ToBeClassified;
        }
        field(50024; "Changed"; Boolean)
        {
            Caption = 'Changed';
            DataClassification = ToBeClassified;
        }
        field(50025; "Date Changed"; Date)
        {
            Caption = 'Date Changed';
            DataClassification = ToBeClassified;
        }
        field(50026; "Time Changed"; Time)
        {
            Caption = 'Time Changed';
            DataClassification = ToBeClassified;
        }
        field(50027; "Telephone No."; Code[20])
        {
            Caption = 'Telephone No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "Document No.")
        {
            Clustered = true;
        }
    }
}



