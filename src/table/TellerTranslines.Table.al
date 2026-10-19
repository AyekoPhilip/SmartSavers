table 50450 "Teller Translines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Teller Translines No"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Teller Translines No';
            DataClassification = CustomerContent;
        }
        field(50010; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50011; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50013; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50014; "Name"; Text[200])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50015; "Description"; Text[60])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50016; "User"; Code[20])
        {
            Caption = 'User';
            DataClassification = CustomerContent;
        }
        field(50017; "Batch No."; Code[30])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(50018; "Account No"; Code[20])
        {
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Acc.Reset;
                Acc.SetRange(Acc."No.", "Account No");
                if Acc.Find('-') then begin
                    Name := Acc.Name;
                    Description := 'Cash Deposit';
                end;
            end;
        }
        field(50019; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Teller Transheader No"; Code[20])
        {
            TableRelation = "Teller Transheader";
            Caption = 'Teller Transheader No';
            DataClassification = CustomerContent;
        }
        field(50021; "Account Name"; Code[30])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50022; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Teller Translines No", "Teller Transheader No")
        {
            Clustered = true;
            SumIndexFields = "Amount";
        }
    }

    fieldgroups
    {
    }

    var
        Acc: Record Vendor;
}




