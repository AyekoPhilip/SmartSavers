table 50151 "Imprest Lines"
{
    Caption = 'Imprest Lines';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin

               
            end;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            TableRelation = Customer where("Account Type" = filter("Travel Advance" | "Training Advance" | "Staff Advance"));
        }
        field(50011; "Account Name"; Text[150])
        {
            Caption = 'Account Name';
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50013; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(50014; "Imprest Holder"; Code[100])
        {
            Caption = 'Imprest Holder';
            TableRelation = Customer where("Account Type" = filter("Travel Advance" | "Training Advance" | "Staff Advance"));
        }
        field(50015; "Actual Spent"; Decimal)
        {
            Caption = 'Actual Spent';
        }
        field(50016; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
        }
        field(50017; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(50018; "Surrendered"; Boolean)
        {
            Caption = 'Surrendered';
        }
        field(50019; "Date Issued"; Date)
        {
            Caption = 'Date Issued';
        }
        field(50020; "Type of Surrender"; Option)
        {
            Caption = 'Type of Surrender';
            OptionMembers = " ","Cash","Receipt";
        }
        field(50021; "Cash Surrender Amt"; Decimal)
        {
            Caption = 'Cash Surrender Amt';
        }
        field(50022; "Surrender Doc No."; Code[50])
        {
            Caption = 'Surrender Doc No.';
        }
        field(50023; "Date Taken"; Date)
        {
            Caption = 'Date Taken';
        }
        field(50024; "Purpose"; Text[150])
        {
            Caption = 'Purpose';
        }
        field(50025; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
        }
        field(50026; "Budgetary Control A/C"; Boolean)
        {
            Caption = 'Budgetary Control A/C';
        }
        field(50027; "Committed"; Boolean)
        {
            Caption = 'Committed';
        }
        field(50028; "Advance Type"; Code[20])
        {
            Caption = 'Advance Type';
        }
        field(50029; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
        }
        field(50030; "Amount LCY"; Decimal)
        {
            Caption = 'Amount LCY';
        }
        field(50031; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(50032; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        }
        field(50033; "Destination Code"; Code[20])
        {
            Caption = 'Destination Code';
        }
        field(50034; "No of Days"; Integer)
        {
            Caption = 'No of Days';
        }
        field(50035; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
        }
        field(50036; "Receipt Amount"; Decimal)
        {
            Caption = 'Receipt Amount';
        }

    }
    keys
    {
        key("PK"; "No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin


    end;

    trigger OnModify()
    begin

    end;

    procedure GetPettyCashBank() PettyBank: Code[50]
    var
        Banks: Record "Bank Account";
    begin
        Banks.Reset();
        Banks.SetRange("Bank Type", Banks."Bank Type"::"Petty Cash");
        if Banks.FindFirst() then begin
            PettyBank := Banks."No.";
            exit(PettyBank);
        end;
    end;

    procedure PaymentLinesExist(): Boolean
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange(No, "No.");
        exit(PaymentLine.FindFirst());
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    var
        Bank: Record "Bank Account";
        CashMgt: Record "Cash Management Setups";
        ChequeRegister: Record "Cheque Register";
        CurrencyRec: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Customer: Record Customer;
        Employee: Record Employee;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ImpSurrLines: Record "Payment Lines";
        PaymentLine: Record "Payment Lines";

        UserSetup: Record "User Setup";
        Vendor: Record Vendor;
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit "No. Series";
        ImpBalance: Decimal;
        Text003: Label 'By disabling Multi-Donor the dimensions on the lines shall be reset \ You wish to proceed?';
        SurrExistsError: Label 'Imprest issued document %1 has been used in another Imprest Surrender document %2';
        MultiDocError: Label 'Kindly utilize your open documents before creating a new one';
        AccountError: Label 'Please account for your previous %1 before applying for a new one';
        NoStaffNoError: Label 'Staff No. %1 can not be found in the Employees List. Kindly contact the system administrator.';
        Text001: Label 'The imprest %1 has been fully surrendered';
        Text002: Label 'The petty cash %1 has been fully surrendered';
        NoUserAcc: Label 'You do not have a user account. Please contact the system administrator.';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        CompletionDateFormula: Text;
}
