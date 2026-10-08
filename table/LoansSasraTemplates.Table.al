table 50344 "Loans-Sasra Templates"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[80])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan Type"; Code[20])
        {
            Caption = 'Loan Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Loan Type Name"; Text[150])
        {
            Caption = 'Loan Type Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Member No."; Code[80])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Member Name"; Text[150])
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50014; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50016; "Disbursement Date"; Date)
        {
            Caption = 'Disbursement Date';
            DataClassification = CustomerContent;
        }
        field(50017; "Staff/Payroll No."; Code[80])
        {
            Caption = 'Staff/Payroll No.';
            DataClassification = CustomerContent;
        }
        field(50018; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Installments"; Integer)
        {
            Caption = 'Installments';
            DataClassification = CustomerContent;
        }
        field(50020; "Shares Deposits"; Decimal)
        {
            Caption = 'Shares Deposits';
            DataClassification = CustomerContent;
        }
        field(50021; "Nature of Security"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien';
            OptionMembers = "Guarantor","Collateral","Lien";
            Caption = 'Nature of Security';
            DataClassification = CustomerContent;
        }
        field(50022; "Repayment Start Date"; Date)
        {
            Caption = 'Repayment Start Date';
            DataClassification = CustomerContent;
        }
        field(50023; "Loans Category-Sasra"; Option)
        {
            DataClassification = CustomerContent;
            Editable = true;
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = "Perfoming","Watch","Substandard","Doubtful","Loss";
            Caption = 'Loans Category-Sasra';
        }
        field(50024; "XRec Loans Category-Sasra"; Option)
        {
            DataClassification = CustomerContent;
            Editable = true;
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = "Perfoming","Watch","Substandard","Doubtful","Loss";
            Caption = 'XRec Loans Category-Sasra';
        }
        field(50025; "Loan Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Account';
        }
        field(50026; "Repayment Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Repayment Account';
        }
    }

    keys
    {
        key("Key1"; "Loan No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




