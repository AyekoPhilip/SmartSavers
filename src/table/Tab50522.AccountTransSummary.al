table 50522 "Account Trans Summary"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No"; Code[20])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50012; "Transaction Type"; Option)
        {
            OptionCaption = 'Salary,Dividend';
            OptionMembers = "Salary","Dividend";
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Document No"; Code[20])
        {
            Caption = 'Document No';
            DataClassification = CustomerContent;
        }
        field(50014; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modified Date" := CurrentDateTime;
    end;
}




