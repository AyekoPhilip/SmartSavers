table 50531 "Loan Recovery Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan No."; Code[10])
        {
            Editable = false;
            TableRelation = Loans."No.";
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Header No."; Code[10])
        {
            Editable = false;
            Caption = 'Header No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[10])
        {
            Editable = false;
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50012; "Loan Account No."; Code[10])
        {
            Editable = false;
            Caption = 'Loan Account No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan Product Type"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class" = CONST(Loan));
            Caption = 'Loan Product Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Interest"; Decimal)
        {
            Editable = false;
            Caption = 'Interest';
            DataClassification = CustomerContent;
        }
        field(50016; "Line Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(50017; "Outstanding Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50018; "Member No."; Code[10])
        {
            Editable = false;
            TableRelation = Member."No.";
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Account Name"; Text[30])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50020; "Date Posted"; Date)
        {
            Editable = false;
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50021; "Posted By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50022; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50023; "Time Posted"; Time)
        {
            Editable = false;
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50024; "Account Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Account Balance';
            DataClassification = CustomerContent;
        }
        field(50025; "Exiting Loan"; Code[80])
        {
            TableRelation = Loans."No.";
            Caption = 'Exiting Loan';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan No.", "Header No.", "Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




