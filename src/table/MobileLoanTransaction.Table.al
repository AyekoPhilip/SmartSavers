table 50300 "Mobile Loan Transaction"
{
    Caption = 'Mobile Loan Transaction';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
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
        field(50017; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = ToBeClassified;
        }
        field(50018; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = ToBeClassified;
        }
        field(50019; "Comments"; Text[150])
        {
            Caption = 'Comments';
            DataClassification = ToBeClassified;
        }
        field(50020; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            DataClassification = ToBeClassified;
        }
        field(50021; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Pending","Posted","Failed";
            DataClassification = ToBeClassified;
        }
        field(50022; "Application No."; Code[50])
        {
            Caption = 'Application No.';
            DataClassification = ToBeClassified;
        }
        field(50023; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            DataClassification = ToBeClassified;
        }
        field(50024; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
         field(50025; "Application Source"; Enum "DocApplicationSource")
        {
            Caption = 'Application Source';
            DataClassification = CustomerContent;
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



