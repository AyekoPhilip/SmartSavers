table 50398 "Loan Disbursement Lines"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No"; Code[20])
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Pay Mode"; Enum "PaymentMode")
        {
            Caption = 'Pay Mode';
            DataClassification = CustomerContent;
        }
        field(50012; "Cheque No"; Code[20])
        {
            Caption = 'Cheque No';
            DataClassification = CustomerContent;
        }
        field(50013; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        }
        field(50014; "Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        }
        field(50015; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50016; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50017; "Account Name"; Text[150])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50018; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50019; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = CustomerContent;
        }
        field(50020; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = CustomerContent;
        }
        field(50021; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50022; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50023; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50024; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50025; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50026; "Line No."; Integer)
        {
            AutoIncrement = false;
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(50027; "Disbursement Serial - PD"; Integer)
        {
            Caption = 'Disbursement Serial - PD';
            DataClassification = CustomerContent;
        }
        field(50028; "Shares Deposit"; Decimal)
        {
            Caption = 'Shares Deposit';
            DataClassification = CustomerContent;
        }
        field(50029; "Default Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Account No.';
        }
        field(50030; "Accrued Interest"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50031; "No. of Guarantors"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50032; "Interest Balance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50033; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Generate Demand Letter"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50035; "Principal Balance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50036; "Outstanding Insurance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50037; "Outstanding Bills"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50038; "Ledger Fee"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50039; "Application No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50040; "Loan Entry No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Entry No.';
        }
        field(50041; "Member No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(50042; "Line Status"; Enum "LoanStatus")
        {
            Editable = false;
            Caption = 'Batch Status';
            DataClassification = CustomerContent;
        }
        field(50043; "Buff. Applic No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Application No.';
        }
        field(50044; "Buff.Loan Entry No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Entry No.';
        }

    }

    keys
    {
        key("Key1"; "No", "Account No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CopyFromGuarantorLine(GuarantorSecurity: Record "Guarantor & Security Posted")
    begin
        "Shares Deposit" := GuarantorSecurity."Amount Guaranteed";
        "Default Account No." := GuarantorSecurity."Member No. (Loanee)";
        "Loan No." := GuarantorSecurity."Loan No.";
        OnAfterCopyLinesFromGuarantors(GuarantorSecurity, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyLinesFromGuarantors(GuarantorSecurity: Record "Guarantor & Security Posted"; var VarVariant: Record "Loan Disbursement Lines")
    begin
    end;

    procedure CopyFromRecoveryHeader(RecovHeader: Record "Recovery Header")
    begin
        No := RecovHeader."No.";
        "Loan No." := RecovHeader."Loan No.";
        Date := RecovHeader."Posting Date";
        "Default Account No." := RecovHeader."Account No.";
        Date := RecovHeader."Posting Date";
        "Account Name" := RecovHeader.Name;
        "Global Dimension 1 Code" := RecovHeader."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := RecovHeader."Shortcut Dimension 2 Code";
    end;
}




