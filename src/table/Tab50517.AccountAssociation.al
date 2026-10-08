table 50517 "Account Association"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "EntyNo"; Integer)
        {
            Caption = 'EntyNo';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Type"; Code[20])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Account Name"; Text[50])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "EntyNo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




