table 50483 "Suspended Interest Account"
{
    DataClassification = CustomerContent;
    /*  DrillDownPageID = 52141077;
     LookupPageID = 52141077; */

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Credit Account"; Code[30])
        {
            Caption = 'Credit Account';
            DataClassification = CustomerContent;
        }
        field(50012; "Loan Product"; Code[20])
        {
            Caption = 'Loan Product';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Date"; Date)
        {
            Caption = 'Interest Date';
            DataClassification = CustomerContent;
        }
        field(50014; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "Loan Product type"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Loan Product type';
            DataClassification = CustomerContent;
        }
        field(50016; "Issued Date"; Date)
        {
            Editable = false;
            Caption = 'Issued Date';
            DataClassification = CustomerContent;
        }
        field(50017; "Loans Category-SASRA"; Option)
        {
            FieldClass = Normal;
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = "Perfoming","Watch","Substandard","Doubtful","Loss";
            Caption = 'Loans Category-SASRA';
            DataClassification = CustomerContent;
        }
        field(50018; "Transferred to income Ac"; Boolean)
        {
            Editable = false;
            Caption = 'Transferred to income Ac';
            DataClassification = CustomerContent;
        }
        field(50019; "Amount Paid"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Paid';
        }
        field(50020; "Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Bills,Appraisal,Prepayment';
            OptionMembers = " ","Loan","Repayment","Interest Due","Interest Paid","Bills","Appraisal","Prepayment";
            Caption = 'Transaction Type';
        }
    }

    keys
    {
        key("Key1"; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




