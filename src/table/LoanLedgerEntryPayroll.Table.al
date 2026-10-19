table 50265 "Loan Ledger Entry-Payroll"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(50010; "Loan No."; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(50011; "Employee No."; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Loan Customer Type" = const(Staff)) Employee
            else
            if ("Loan Customer Type" = const("External Customer")) Customer;
            Caption = 'Employee No.';
        }
        field(50012; "Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Principal,Interest,Principal Repayment,Interest Repayment,Settlement';
            OptionMembers = " ","Principal","Interest","Principal Repayment","Interest Repayment","Settlement";
            Caption = 'Transaction Type';
        }
        field(50013; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50014; "Document No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(50015; "Payment Mode"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'G/L Account,Bank Account,Cash,Cheque,EFT,RTGS,MPESA,PDQ';
            OptionMembers = "G/L Account","Bank Account","Cash","Cheque","EFT","RTGS","MPESA","PDQ";
            Caption = 'Payment Mode';
        }
        field(50016; "Payment Reference No."; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Reference No.';
        }
        field(50017; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(50018; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
        }
        field(50019; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50020; "Debtor's Code"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Debtor''s Code';
        }
        field(50021; "Shortcut Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Caption = 'Shortcut Dimension 1 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(50022; "Shortcut Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            Caption = 'Shortcut Dimension 2 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50023; "Dimension Set ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Set ID';
        }
        field(50024; "Transaction Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Date';
        }
        field(50025; "Loan Customer Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Staff,External Customer';
            OptionMembers = "Staff","External Customer";
            Caption = 'Loan Customer Type';
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

    var
        DimMgt: Codeunit DimensionManagement;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;
}


