table 50477 "Savings Interest Buffer"
{

    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Account Type"; Enum "Gen. Journal Account Type")
        {
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
            Caption = 'Interest Rate';
            Editable = false;
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
        field(50018; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            Editable = false;
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
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
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
        field(50023; "Status"; Enum "MemberStatus")
        {
            Editable = false;
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
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
            Caption = 'Expense Account';
            DataClassification = CustomerContent;
        }
        field(50027; "Name"; Text[80])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50028; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No.", "Interest Date", "Account No")
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




