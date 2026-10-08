table 90001 "Rcv02 Contribution Schedule-De"
{
    Caption = 'Contribution Schedule-Deposit';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(3; "Installment No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Installment No.';
        }
        field(4; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(5; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified By';
        }
        field(6; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Member;
            Editable = false;
            Caption = 'Member No.';
        }
        field(7; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = Qualification,Graduation;
        }
        field(8; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Account No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
        }
        field(10; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Type';
            TableRelation = "Product Factory";
        }
        field(11; RandomDigit; Code[50])
        {
            Caption = 'Random Digit';
            DataClassification = CustomerContent;
        }
        field(12; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }
        field(13; "Share Banding"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Share Banding';
        }
          field(14; Balance; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance';
        }
        field(15; "Document No."; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Document No.';
        }
         field(16; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
    }
    keys
    {
        key(PK; RandomDigit,"Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        RandomDigit := CreateGuid();
        RandomDigit := DelChr(RandomDigit, '=', '{}-01');
        RandomDigit := CopyStr(RandomDigit, 1, 8);
        "Last Modified By" := UserId;
    end;
}
