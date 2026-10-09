table 50561 "Repayment Schedule"
{
    DataClassification = CustomerContent;
    LookupPageId = "Loan Repayment Schedule";
    DrillDownPageId = "Loan Repayment Schedule";
    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
        }
        field(50013; "Monthly Repayment"; Decimal)
        {
            Caption = 'Monthly Repayment';
            DataClassification = CustomerContent;
        }
        field(50014; "Monthly Interest"; Decimal)
        {
            Caption = 'Monthly Interest';
            DataClassification = CustomerContent;
        }
        field(50015; "Repayment Date"; Date)
        {
            Caption = 'Repayment Date';
            DataClassification = CustomerContent;
        }
        field(50016; "Principal Repayment"; Decimal)
        {
            Caption = 'Principal Repayment';
            DataClassification = CustomerContent;
        }
        field(50017; "Instalment No"; Integer)
        {
            Caption = 'Instalment No';
            DataClassification = CustomerContent;
        }
        field(50018; "Repayment Code"; Code[20])
        {
            Caption = 'Repayment Code';
            DataClassification = CustomerContent;
        }
        field(50019; "Loan Application No."; Code[20])
        {
            Caption = 'Loan Application No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Loan Balance"; Decimal)
        {
            Caption = 'Loan Balance';
            DataClassification = CustomerContent;
        }
        field(50021; "Monthly Insurance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Monthly Insurance';
        }
    }

    keys
    {
        key("Key1"; "No.", "Account No.", "Repayment Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CopyFromLoanApplication(LoanApplication: Record "Loan Application")
    begin
        "Principal Repayment" := LoanApplication."Approved Amount";
        "Account No." := LoanApplication."Account No.";
        "Product Type" := LoanApplication."Product Type";
    end;


    procedure CopyFromLoanRecEntry(LoanApplication: Record Loans)
    begin
        "Principal Repayment" := LoanApplication."Approved Amount";
        "Account No." := LoanApplication."Account No.";
        "Product Type" := LoanApplication."Product Type";
    end;
}




