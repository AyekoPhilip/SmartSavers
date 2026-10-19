table 50535 "Loan Interest Entries"
{
    DrillDownPageID = "Loan Interest Entries";
    LookupPageID = "Loan Interest Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Entry No.';
        }
        field(50010; "Loan Account No"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Loan Account No';
        }
        field(50011; "Account Type"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Account Type';
        }
        field(50012; "Interest Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Interest Date';
        }
        field(50013; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Amount';
        }
        field(50014; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            TableRelation = "User Setup";
            Caption = 'User ID';
        }
        field(50015; "Account Matured"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Account Matured';
        }
        field(50016; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50017; "Late Interest"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Late Interest';
        }
        field(50018; "Transferred"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Transferred';
        }
        field(50019; "Mark For Deletion"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Mark For Deletion';
        }
        field(50020; "Description"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Description';
        }
        field(50021; "Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Loan No.';
        }
        field(50022; "Product Type"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Product Type';
        }
        field(50023; "Repayment Account No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Repayment Account No.';
        }
        field(50024; "Account No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Account No.';
        }
        field(50025; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Time Posted';
        }
        field(50026; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50027; "Posted By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Posted By';
        }
        field(50028; "Outstanding Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Outstanding Balance';
        }
        field(50029; "Outstanding Interest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Outstanding Interest';
        }
        field(50030; "Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            Editable = true;
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Penalty Due,Penalty Paid';
            OptionMembers = " ","Loan","Repayment","Interest Due","Interest Paid","Bills","Appraisal";
            Caption = 'Transaction Type';
        }
        field(50031; "Outstanding Bills"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Outstanding Bills';
        }
        field(50032; "Due date"; Date)
        {
            FieldClass = Normal;
            Caption = 'Due date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




