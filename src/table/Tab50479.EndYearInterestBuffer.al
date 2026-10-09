table 50479 "End Year Interest Buffer"
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
        field(50010; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Savings","Credit";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No"; Code[20])
        {
            Editable = false;
            TableRelation = "Account Banking";
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50012; "Interest Date"; Date)
        {
            Caption = 'Interest Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Rate"; Decimal)
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50014; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50016; "Description"; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50017; "Product Factory Code"; Code[10])
        {
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Product Factory Code';
            DataClassification = CustomerContent;
        }
        field(50018; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Member,None,Staff';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Member","None","Staff";
            DataClassification = CustomerContent;
        }
        field(50019; "Payable Account"; Code[20])
        {
            Caption = 'Payable Account';
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
        field(50020; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50021; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50022; "Blocked"; Option)
        {
            Caption = 'Blocked';
            Editable = false;
            OptionCaption = ' ,Ship,Invoice,All';
            OptionMembers = " ","Ship","Invoice","All";
            DataClassification = CustomerContent;
        }
        field(50023; "Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Non-Active,Blocked,Dormant,Re-instated,Deceased,Withdrawal,Retired,Termination,Resigned,Ex-Company,Casuals,Family Member,Defaulter,Apportioned,Suspended,Awaiting Verdict,New';
            OptionMembers = "Active","Non-Active","Blocked","Dormant","Re-instated","Deceased","Withdrawal","Retired","Termination","Resigned","Ex-Company","Casuals","Family Member","Defaulter","Apportioned","Suspended","Awaiting Verdict","New";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50024; "Account Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Account Balance';
            DataClassification = CustomerContent;
        }
        field(50025; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50026; "Expense Account"; Code[20])
        {
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
            Caption = 'Expense Account';
            DataClassification = CustomerContent;
        }
        field(50027; "Name"; Text[80])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Account No", "Interest Date")
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




