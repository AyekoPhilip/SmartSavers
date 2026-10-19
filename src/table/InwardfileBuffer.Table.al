table 50431 "Inward file Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Clearing System"; Code[20])
        {
            Caption = 'Clearing System';
            DataClassification = CustomerContent;
        }
        field(50010; "Serial No"; Code[20])
        {
            Caption = 'Serial No';
            DataClassification = CustomerContent;
        }
        field(50011; "Transaction Code"; Code[20])
        {
            Caption = 'Transaction Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50013; "Account No"; Code[20])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50014; "Branch Code 2"; Code[20])
        {
            Caption = 'Branch Code 2';
            DataClassification = CustomerContent;
        }
        field(50015; "Cheque No"; Code[20])
        {
            Caption = 'Cheque No';
            DataClassification = CustomerContent;
        }
        field(50016; "Currency"; Code[20])
        {
            Caption = 'Currency';
            DataClassification = CustomerContent;
        }
        field(50017; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50018; "Date Code1"; Code[20])
        {
            Caption = 'Date Code1';
            DataClassification = CustomerContent;
        }
        field(50019; "Date Code2"; Code[20])
        {
            Caption = 'Date Code2';
            DataClassification = CustomerContent;
        }
        field(50020; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50021; "Unused 1"; Code[20])
        {
            Caption = 'Unused 1';
            DataClassification = CustomerContent;
        }
        field(50022; "Unused 2"; Code[20])
        {
            Caption = 'Unused 2';
            DataClassification = CustomerContent;
        }
        field(50023; "Unused 3"; Code[20])
        {
            Caption = 'Unused 3';
            DataClassification = CustomerContent;
        }
        field(50024; "Bank Code 2"; Code[20])
        {
            Caption = 'Bank Code 2';
            DataClassification = CustomerContent;
        }
        field(50025; "Branch Code 3"; Code[20])
        {
            Caption = 'Branch Code 3';
            DataClassification = CustomerContent;
        }
        field(50026; "Unused 4"; Code[20])
        {
            Caption = 'Unused 4';
            DataClassification = CustomerContent;
        }
        field(50027; "Unused 5"; Code[20])
        {
            Caption = 'Unused 5';
            DataClassification = CustomerContent;
        }
        field(50028; "Unused 6"; Code[20])
        {
            Caption = 'Unused 6';
            DataClassification = CustomerContent;
        }
        field(50029; "Unused 7"; Code[20])
        {
            Caption = 'Unused 7';
            DataClassification = CustomerContent;
        }
        field(50030; "CurrentUserID"; Code[100])
        {
            Caption = 'CurrentUserID';
            DataClassification = CustomerContent;
        }
        field(50031; "Primary"; Integer)
        {
            Caption = 'Primary';
            DataClassification = CustomerContent;
        }
        field(50032; "Transaction Code2"; Code[20])
        {
            Caption = 'Transaction Code2';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Transaction Code", "Serial No", "Clearing System")
        {
            Clustered = true;
        }
        key("Key2"; "Clearing System")
        {

        }
    }

    fieldgroups
    {
    }
}




