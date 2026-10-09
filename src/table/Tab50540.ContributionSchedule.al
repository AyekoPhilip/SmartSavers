table 50540 "Contribution Schedule"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Account No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
        }
        field(50010; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(50011; "Installment No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Installment No.';
        }
        field(50012; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50013; "Last Mod By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Mod By';
        }
        field(50014; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
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
    }

    keys
    {
        key("Key1"; "Posting Date", "Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Mod By" := UserId
    end;
}




