table 50396 "Schedule of Loan Payment"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Payment Options"; Option)
        {
            OptionCaption = 'Cheques,M-PESA,Others';
            OptionMembers = "Cheques","M-PESA","Others";
            Caption = 'Payment Options';
            DataClassification = CustomerContent;
        }
        field(50011; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50012; "Serial"; Integer)
        {
            Caption = 'Serial';
            DataClassification = CustomerContent;
        }
        field(50013; "Posting Dates"; Date)
        {
            Caption = 'Posting Dates';
            DataClassification = CustomerContent;
        }
        field(50014; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50015; "Cheque No."; Code[20])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Savings","Credit";
            DataClassification = CustomerContent;
        }
        field(50017; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan No.", "Serial")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




