table 50422 "Banking No. Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(50010; "Cashier Transaction Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Cashier Transaction Nos.';
            DataClassification = CustomerContent;
        }
        field(50011; "Treasury & Teller Trans Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Treasury & Teller Trans Nos.';
            DataClassification = CustomerContent;
        }
        field(50012; "Standing Order Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Standing Order Nos.';
            DataClassification = CustomerContent;
        }
        field(50013; "EFT Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'EFT Nos.';
            DataClassification = CustomerContent;
        }
        field(50014; "Salary Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Salary Nos.';
            DataClassification = CustomerContent;
        }
        field(50015; "Standing Order Reg. Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Standing Order Reg. Nos.';
            DataClassification = CustomerContent;
        }
        field(50016; "Cheque Receipts Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Cheque Receipts Nos';
            DataClassification = CustomerContent;
        }
        field(50017; "Cheque Application Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Cheque Application Nos';
            DataClassification = CustomerContent;
        }
        field(50018; "Bankers Cheque Application Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Bankers Cheque Application Nos';
            DataClassification = CustomerContent;
        }
        field(50019; "Overdraft Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Overdraft Nos';
            DataClassification = CustomerContent;
        }
        field(50020; "Mobile Application Nos"; Code[30])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50021; "Mobile Change Nos"; Code[30])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50022; "Change Mobile PIN Nos"; Code[30])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50023; "BULK SMS Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'BULK SMS Nos';
            DataClassification = CustomerContent;
        }
        field(50024; "Account Transfer Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Account Transfer Nos';
            DataClassification = CustomerContent;
        }
        field(50025; "ATM Application Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'ATM Application Nos';
            DataClassification = CustomerContent;
        }
        field(50026; "FOSA Interest Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'FOSA Interest Nos';
            DataClassification = CustomerContent;
        }
        field(50027; "Investment Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Investment Nos';
            DataClassification = CustomerContent;
        }
        field(50028; "Standing Order Control Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Standing Order Control Nos.';
            DataClassification = CustomerContent;
        }
        field(50029; "ATM Linking Application Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'ATM Linking Application Nos';
            DataClassification = CustomerContent;
        }
        field(50030; "Online Transactions"; Code[30])
        {
            Caption = 'Online Transactions';
            DataClassification = CustomerContent;
        }
        field(50031; "Document Apprvls."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Document Apprvls.';
            DataClassification = CustomerContent;
        }
        field(50032; "EFT Line Nos"; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'EFT Line Nos';
            DataClassification = CustomerContent;
        }
        field(50033; "Delegate Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Delegate Nos.';
            DataClassification = CustomerContent;
        }
        field(50034; "Delegate Sub Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Delegate Sub Nos.';
            DataClassification = CustomerContent;
        }
        field(50035; "Delegate Application Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Delegate Application Nos.';
            DataClassification = CustomerContent;
        }
        field(50036; "Delegate Payment Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Delegate Payment Nos.';
            DataClassification = CustomerContent;
        }
        field(50037; "Delegate Minutes Nos."; Code[30])
        {
            TableRelation = "No. Series";
            Caption = 'Delegate Minutes Nos.';
            DataClassification = CustomerContent;
        }
        field(50038; "EFT Post Days"; DateFormula)
        {
            Caption = 'EFT Post Days';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnInsert()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnModify()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnRename()
    begin
        RestrictAccess(UserId)
    end;


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




