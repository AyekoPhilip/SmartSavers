table 90002 "Rcv03 Contribution Schedule Mg"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
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
        field(9; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; RandomDigit; Code[50])
        {
            Caption = 'Random Digit';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Posting Date", "Account No.", "Entry No.", RandomDigit)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        RandomDigit := CreateGuid();
        RandomDigit := DelChr(RandomDigit, '=', '{}-01');
        RandomDigit := CopyStr(RandomDigit, 1, 8);
        "Last Modified By" := UserId;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId
    end;
}

