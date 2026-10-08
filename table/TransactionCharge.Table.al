table 50415 "Transaction Charge"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types";
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50010; "Charge Code"; Code[20])
        {
            Editable = true;
            Enabled = true;
            Caption = 'Charge Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TransactionTypes.Reset;
                TransactionTypes.SetRange(TransactionTypes.Code, "Charge Code");
                if TransactionTypes.Find('-') then
                    Description := TransactionTypes.Description;
            end;
        }
        field(50011; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Charge Type"; Option)
        {
            OptionCaption = 'Flat Amount,% of Amount,Staggered';
            OptionMembers = "Flat Amount","% of Amount","Staggered";
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Charge Amount"; Decimal)
        {
            Editable = true;
            Caption = 'Charge Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Percentage of Amount"; Decimal)
        {
            Editable = true;
            Caption = 'Percentage of Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "G/L Account"; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Minimum Amount"; Decimal)
        {
            Caption = 'Minimum Amount';
            DataClassification = CustomerContent;
        }
        field(50017; "Maximum Amount"; Decimal)
        {
            Caption = 'Maximum Amount';
            DataClassification = CustomerContent;
        }
        field(50018; "Staggered Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
            Caption = 'Staggered Charge Code';
            DataClassification = CustomerContent;
        }
        field(50019; "Transaction Charge Category"; Option)
        {
            OptionMembers = "Normal","Stamp Duty","Withdrawal Frequency","Withdrawn Amount","Failed STO Charge";
            Caption = 'Transaction Charge Category';
            DataClassification = CustomerContent;
        }
        field(50020; "Recover Excise Duty"; Boolean)
        {
            Caption = 'Recover Excise Duty';
            DataClassification = CustomerContent;
        }
        field(50021; "Account Closure"; Boolean)
        {
            Caption = 'Account Closure';
            DataClassification = CustomerContent;
        }
        field(50022; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50023; "ATM Clearing Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50024; "ATM Fee (Income)"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50025; "ATM Clearing Account Comms. %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'ATM Clearing Comms. (Amount / %)';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50026; "ATM Fee. %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Fee (%)';
        
            trigger OnValidate()
            begin
            end;
        }
    }

    keys
    {
        key("Key1"; "Transaction Type", "Description")
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
        RestrictAccess(UserId);
        "Recover Excise Duty" := true;
    end;

    trigger OnModify()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnRename()
    begin
        RestrictAccess(UserId);
    end;

    var
        TransactionTypes: Record "Transaction Types";


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




