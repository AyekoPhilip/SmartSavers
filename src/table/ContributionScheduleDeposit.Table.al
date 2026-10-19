table 50601 "Contribution Schedule-Deposit"
{
    Caption = 'Contribution Schedule-Deposit';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50010; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
            Editable = false;
        }
        field(50011; "Installment No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Installment No.';
            Editable = false;
        }
        field(50012; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Amount';
        }
        field(50013; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified By';
        }
        field(50014; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Member;
            Editable = false;
            Caption = 'Member No.';
        }
        field(50015; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = "Qualification","Graduation";
        }
        field(50016; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50017; "Account No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
            Editable = false;
        }
        field(50018; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Type';
            TableRelation = "Product Factory";
            Editable = false;
        }
        field(50019; "No. of Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Days';
            Editable = false;
        }
        field(50020; "Document No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
            Editable = false;
        }
        field(50021; "Qualifying Share"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qualifying Share';
            Editable = false;
        }
        field(50022; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50023; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
         field(50024; "Month Text"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
    keys
    {
        key("PK"; "Entry No.", "Document No.")
        {
            Clustered = true;
        }
    }
}
