table 50457 "Checkoff Buffer"
{
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
            OptionCaption = ' ,sInterest,sLoan,sShare,wCont,sJoining';
            OptionMembers = " ","sInterest","sLoan","sShare","wCont","sJoining";
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
        field(50018; "Checkoff No"; Code[20])
        {
            Caption = 'Checkoff No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "User ID" := UserId;
            end;
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
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50028; "Product Category"; Enum "ProductAccountCategory")
        {
            CalcFormula = Lookup("Product Factory"."Account Category" WHERE("Product ID" = FIELD("Product ID")));
            Description = 'Option to help identify type of savings accounts';
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Product Category';
        }
        field(50029; "Product ID"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product ID';
            DataClassification = CustomerContent;
        }
        field(50030; "Employer No."; Code[10])
        {
            Caption = 'Employer No.';
            DataClassification = CustomerContent;
        }
        field(50031; "Repayment Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Repayment Account';
        }
        field(50032; "Description"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50033; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(50034; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
        }
        field(50035; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
        }
        field(50036; "Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Loan,Repayment,Interest Due,Interest Paid,Penalty Due,Penalty Paid';
            OptionMembers = " ","Loan","Repayment","Interest Due","Interest Paid","Bills","Appraisal";
            Caption = 'Transaction Type';
        }
        field(50037; "Product Class Type"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Whether Loan Accounts or Operational accounts';
            OptionCaption = ' ,Loan,Savings';
            OptionMembers = " ","Loan","Savings";
            Caption = 'Product Class Type';
        }
    }

    keys
    {
        key("Key1"; "No", "Checkoff No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




