table 50519 "Checkoff Buffer Consolidation"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Integer)
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Payroll"; Code[20])
        {
            Caption = 'Payroll';
            DataClassification = CustomerContent;
        }
        field(50012; "Account No"; Code[20])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50013; "Loan No"; Code[20])
        {
            Caption = 'Loan No';
            DataClassification = CustomerContent;
        }
        field(50014; "Type"; Option)
        {
            OptionCaption = ' ,SShares,Loan';
            OptionMembers = " ","SShares","Loan";
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Interest"; Decimal)
        {
            Caption = 'Interest';
            DataClassification = CustomerContent;
        }
        field(50017; "Search Code"; Code[20])
        {
            Caption = 'Search Code';
            DataClassification = CustomerContent;
        }
        field(50018; "Checkoff No"; Code[10])
        {
            Caption = 'Checkoff No';
            DataClassification = CustomerContent;
        }
        field(50019; "Employer Code"; Code[20])
        {
            TableRelation = Customer;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50020; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50021; "Savings Account"; Boolean)
        {
            Caption = 'Savings Account';
            DataClassification = CustomerContent;
        }
        field(50022; "Credit Account"; Boolean)
        {
            Caption = 'Credit Account';
            DataClassification = CustomerContent;
        }
        field(50023; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50024; "Upload Response"; Integer)
        {
            Editable = false;
            Caption = 'Upload Response';
            DataClassification = CustomerContent;
        }
        field(50025; "Upload No."; Code[20])
        {
            Caption = 'Upload No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Not Found"; Boolean)
        {
            Editable = false;
            Caption = 'Not Found';
            DataClassification = CustomerContent;
        }
        field(50027; "User ID"; Code[100])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50028; "Product Category"; Option)
        {
            Description = 'Option to help identify type of savings accounts';
            Editable = false;
            OptionCaption = ' ,Share Capital,Deposit Contribution,Registration Fees,Benevolent Fund,Shares Drive,Eldoret House,Ukulima House,Savings,Fixed Deposit,Junior,Pamoja,Holiday,Elimu';
            OptionMembers = " ","Share Capital","Deposit Contribution","Registration Fees","Benevolent Fund","Shares Drive","Eldoret House","Ukulima House","Savings","Fixed Deposit","Junior","Pamoja","Holiday","Elimu";
            Caption = 'Product Category';
            DataClassification = CustomerContent;
        }
        field(50029; "Product ID"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product ID';
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




