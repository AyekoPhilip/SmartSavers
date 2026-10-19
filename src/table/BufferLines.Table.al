table 50487 "Buffer Lines"
{
    DrillDownPageID = "Dividend Progression";
    LookupPageID = "Dividend Progression";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Code[20])
        {
            Editable = false;
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No"; Code[20])
        {
            Editable = false;
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50011; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Savings","Credit";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Interest Date"; Date)
        {
            Caption = 'Interest Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "User ID"; Code[100])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50015; "Account Matured"; Boolean)
        {
            Caption = 'Account Matured';
            DataClassification = CustomerContent;
        }
        field(50016; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50017; "Late Interest"; Boolean)
        {
            Caption = 'Late Interest';
            DataClassification = CustomerContent;
        }
        field(50018; "Transferred"; Boolean)
        {
            Caption = 'Transferred';
            DataClassification = CustomerContent;
        }
        field(50019; "Mark For Deletion"; Boolean)
        {
            Caption = 'Mark For Deletion';
            DataClassification = CustomerContent;
        }
        field(50020; "Description"; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50021; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50022; "Loan No."; Code[50])
        {
            Editable = false;
            TableRelation = Loans;
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Loan Product type"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Loan Product type';
            DataClassification = CustomerContent;
        }
        field(50024; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Member","None","Staff";
            DataClassification = CustomerContent;
        }
        field(50025; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50026; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50027; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            Editable = false;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Member)) Member;
            DataClassification = CustomerContent;
        }
        field(50028; "Blocked"; Option)
        {
            Caption = 'Blocked';
            Editable = false;
            OptionCaption = ' ,Ship,Invoice,All';
            OptionMembers = " ","Ship","Invoice","All";
            DataClassification = CustomerContent;
        }
        field(50029; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Apportioned,Suspended,Awaiting Verdict,New';
            OptionMembers = "Active","Non-Active","Blocked","Dormant","Re-instated","Deceased","Withdrawal","Retired","Termination","Resigned","Ex-Company","Casuals","Family Member","Defaulter","Apportioned","Suspended","Awaiting Verdict","New";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50030; "Issued Date"; Date)
        {
            Editable = false;
            Caption = 'Issued Date';
            DataClassification = CustomerContent;
        }
        field(50031; "Bill Loan"; Boolean)
        {
            Caption = 'Bill Loan';
            DataClassification = CustomerContent;
        }
        field(50032; "Charge Interest"; Boolean)
        {
            Caption = 'Charge Interest';
            DataClassification = CustomerContent;
        }
        field(50033; "Repayment Amount"; Decimal)
        {
            Caption = 'Repayment Amount';
            DataClassification = CustomerContent;
        }
        field(50034; "Monthly Repayment"; Decimal)
        {
            Caption = 'Monthly Repayment';
            DataClassification = CustomerContent;
        }
        field(50035; "Bill Account"; Code[20])
        {
            Caption = 'Bill Account';
            Editable = false;
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;
        }
        field(50036; "Repayment Bill"; Decimal)
        {
            Caption = 'Repayment Bill';
            DataClassification = CustomerContent;
        }
        field(50037; "Interest Bill"; Decimal)
        {
            Caption = 'Interest Bill';
            DataClassification = CustomerContent;
        }
        field(50038; "Outstanding Interest"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Interest';
            DataClassification = CustomerContent;
        }
        field(50039; "Outstanding Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50040; "Appraisal Amount"; Decimal)
        {
            Caption = 'Appraisal Amount';
            DataClassification = CustomerContent;
        }
        field(50041; "Date Captured"; Date)
        {
            Caption = 'Date Captured';
            DataClassification = CustomerContent;
        }
        field(50042; "Bal. Account No.(Suspended)"; Code[100])
        {
            Caption = 'Bal. Account No.';
            Editable = false;
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;
        }
        field(50043; "Shares Account No."; Code[100])
        {
            Caption = 'Shares Account No.';
            DataClassification = CustomerContent;
        }
        field(50044; "Deposits Account No."; Code[100])
        {
            Caption = 'Deposits Account No.';
            DataClassification = CustomerContent;
        }
        field(50045; "Shares Balance"; Decimal)
        {
            Caption = 'Shares Balance';
            DataClassification = CustomerContent;
        }
        field(50046; "Deposit Balance"; Decimal)
        {
            Caption = 'Deposit Balance';
            DataClassification = CustomerContent;
        }
        field(50047; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50048; "Product Category"; Option)
        {
            Description = 'Option to help identify type of savings accounts';
            OptionCaption = ' ,Share Capital,Deposit Contribution,Registration Fees,Benevolent Fund,Shares Drive,Eldoret House,Ukulima House,Savings,Fixed Deposit,Junior,Pamoja,Holiday,Elimu';
            OptionMembers = " ","Share Capital","Deposit Contribution","Registration Fees","Benevolent Fund","Shares Drive","Eldoret House","Ukulima House","Savings","Fixed Deposit","Junior","Pamoja","Holiday","Elimu";
            Caption = 'Product Category';
            DataClassification = CustomerContent;
        }
        field(50049; "Member No."; Code[80])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50050; "Shares Drive Balance"; Decimal)
        {
            Caption = 'Shares Drive Balance';
            DataClassification = CustomerContent;
        }
        field(50051; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(50052; "Product Minimum Bal."; Decimal)
        {
            Caption = 'Product Minimum Bal.';
            DataClassification = CustomerContent;
        }
        field(50053; "Dep Blocked"; Option)
        {
            Caption = 'Blocked';
            Editable = false;
            OptionCaption = ' ,Ship,Invoice,All';
            OptionMembers = " ","Ship","Invoice","All";
            DataClassification = CustomerContent;
        }
        field(50054; "Email"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
        }
        field(50055; "Email Personal"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Email Personal';
        }
    }

    keys
    {
        key("Key1"; "No", "Account No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
          IF No = '' THEN BEGIN
          NoSetup.GET(0);
          NoSetup.TESTFIELD(NoSetup."Interest Buffer No");
          NoSeriesMgt.InitSeries(NoSetup."Interest Buffer No",xRec."No. Series",0D,No,"No. Series");
          END;
        */

    end;
}




