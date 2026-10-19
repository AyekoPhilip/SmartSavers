table 50486 "Daily Loans Interest Buffer"
{
    DrillDownPageID = "Dividend Progression";
    LookupPageID = "Dividend Progression";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan No."; Code[50])
        {
            Editable = false;
            TableRelation = Loans;
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Interest Date"; Date)
        {
            Caption = 'Interest Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Savings","Credit";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Account No"; Code[20])
        {
            Editable = false;
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan Product type"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Loan Product type';
            DataClassification = CustomerContent;
        }
        field(50015; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "User ID"; Code[100])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50017; "Transferred"; Boolean)
        {
            Caption = 'Transferred';
            DataClassification = CustomerContent;
        }
        field(50018; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Repayment Amount"; Decimal)
        {
            Caption = 'Repayment Amount';
            DataClassification = CustomerContent;
        }
        field(50020; "Monthly Repayment"; Decimal)
        {
            Caption = 'Monthly Repayment';
            DataClassification = CustomerContent;
        }
        field(50021; "Interest Matured"; Boolean)
        {
            Caption = 'Interest Matured';
            DataClassification = CustomerContent;
        }
        field(50022; "Late Interest"; Boolean)
        {
            Caption = 'Late Interest';
            DataClassification = CustomerContent;
        }
        field(50023; "Product Category"; Option)
        {
            Description = 'Option to help identify type of savings accounts';
            OptionCaption = ' ,Share Capital,Deposit Contribution,Registration Fees,Benevolent Fund,Shares Drive,Eldoret House,Ukulima House,Savings,Fixed Deposit,Junior,Pamoja,Holiday,Elimu';
            OptionMembers = " ","Share Capital","Deposit Contribution","Registration Fees","Benevolent Fund","Shares Drive","Eldoret House","Ukulima House","Savings","Fixed Deposit","Junior","Pamoja","Holiday","Elimu";
            Caption = 'Product Category';
            DataClassification = CustomerContent;
        }
        field(50024; "Commison %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commison %';
        }
        field(50025; "Salesperson No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson No.';
        }
        field(50026; "No. of Members [Payable]"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'No. of Members [Payable]';
        }
        field(50027; "Salesperson Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson Name';
        }
        field(50028; "Header No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Interest Header"."No.";
            Caption = 'Header No.';
        }
        field(50029; "Application No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50030; "SalesAgent Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'SalesAgent Phone No.';
        }
        field(50031; "Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Receipt No.';
        }
        field(50032; "Total No. of Accounts"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'Total No. of Accounts';
            DataClassification = CustomerContent;
        }
        field(50033; "No. of MPesa Transaction"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'No. of MPesa Transaction';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




