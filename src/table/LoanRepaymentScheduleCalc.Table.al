table 50496 "Loan Repayment Schedule-Calc"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Loan Category"; Code[20])
        {
            Caption = 'Loan Category';
            DataClassification = CustomerContent;
        }
        field(50012; "Closed Date"; Date)
        {
            Caption = 'Closed Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
            DataClassification = CustomerContent;
        }
        field(50015; "Monthly Repayment"; Decimal)
        {
            Caption = 'Monthly Repayment';
            DataClassification = CustomerContent;
        }
        field(50016; "Member Name"; Text[30])
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(50017; "Monthly Interest"; Decimal)
        {
            Caption = 'Monthly Interest';
            DataClassification = CustomerContent;
        }
        field(50018; "Amount Repayed"; Decimal)
        {
            FieldClass = Normal;
            Caption = 'Amount Repayed';
            DataClassification = CustomerContent;
        }
        field(50019; "Repayment Date"; Date)
        {
            Caption = 'Repayment Date';
            DataClassification = CustomerContent;
        }
        field(50020; "Principal Repayment"; Decimal)
        {
            Caption = 'Principal Repayment';
            DataClassification = CustomerContent;
        }
        field(50021; "Paid"; Boolean)
        {
            Caption = 'Paid';
            DataClassification = CustomerContent;
        }
        field(50022; "Remaining Debt"; Decimal)
        {
            Editable = false;
            Caption = 'Remaining Debt';
            DataClassification = CustomerContent;
        }
        field(50023; "Instalment No"; Integer)
        {
            Caption = 'Instalment No';
            DataClassification = CustomerContent;
        }
        field(50024; "Actual Loan Repayment Date"; Date)
        {
            Caption = 'Actual Loan Repayment Date';
            DataClassification = CustomerContent;
        }
        field(50025; "Repayment Code"; Code[20])
        {
            Caption = 'Repayment Code';
            DataClassification = CustomerContent;
        }
        field(50026; "Group Code"; Code[20])
        {
            Caption = 'Group Code';
            DataClassification = CustomerContent;
        }
        field(50027; "Loan Application No"; Code[20])
        {
            Caption = 'Loan Application No';
            DataClassification = CustomerContent;
        }
        field(50028; "Actual Principal Paid"; Decimal)
        {
            Caption = 'Actual Principal Paid';
            DataClassification = CustomerContent;
        }
        field(50029; "Actual Interest Paid"; Decimal)
        {
            Caption = 'Actual Interest Paid';
            DataClassification = CustomerContent;
        }
        field(50030; "Actual Installment Paid"; Decimal)
        {
            Caption = 'Actual Installment Paid';
            DataClassification = CustomerContent;
        }
        field(50031; "Repayment Adjustment"; Decimal)
        {
            Caption = 'Repayment Adjustment';
            DataClassification = CustomerContent;
        }
        field(50032; "Reset Schedule"; Boolean)
        {
            Caption = 'Reset Schedule';
            DataClassification = CustomerContent;
        }
        field(50033; "Reset Doc No."; Code[10])
        {
            Caption = 'Reset Doc No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan No.", "Member No.", "Repayment Date")
        {
            Clustered = true;
            SumIndexFields = "Monthly Interest","Principal Repayment","Monthly Repayment";
        }
        key("Key2"; "Member No.")
        {

        }
        key("Key3"; "Paid")
        {

        }
        key("Key4"; "Loan No.", "Member No.", "Paid")
        {

        }
        key("Key5"; "Loan Category")
        {

        }
        key("Key6"; "Loan No.", "Member No.", "Paid", "Loan Category")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    trigger OnInsert()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    trigger OnModify()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    trigger OnRename()
    begin
        if LoanApp.Get("Loan No.") then begin
            if (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Banking Account") or (LoanApp."Disbursement Destination" = LoanApp."Disbursement Destination"::"Mobile Money") then
                Error(Text001, LoanApp."Disbursement Destination");
        end;
    end;

    var
        LoanApp: Record Loans;
        Text001: Label 'Loan is already %1 and cannot modify';
}




