table 90004 "Rcv05 Loan (Score Mgt)"
{
    Caption = 'Loan (Score Mgt)';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Expected Completion Date"; Date)
        {
            Caption = 'Expected Completion Date';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
         field(7; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            TableRelation=Member;
            DataClassification = CustomerContent;
        }
         field(8; "Loan Paid on Time"; Boolean)
        {
            Caption = 'Loan Paid on Time';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
