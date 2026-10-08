table 50529 "Interest Line"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Interest Lines LookUp";
    LookupPageId = "Interest Lines LookUp";
    fields
    {
        field(50009; "No"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'No';
        }
        field(50010; "Account No"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account No';
        }
        field(50011; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Type';
        }
        field(50012; "Interest Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Date';
        }
        field(50013; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50014; "User ID"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
        }
        field(50015; "Account Matured"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Account Matured';
        }
        field(50016; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50017; "Late Interest"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Late Interest';
        }
        field(50018; "Transfer Interest to Susp Ac."; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Transfer Interest to Susp Ac.';
        }
        field(50019; "Mark For Deletion"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mark For Deletion';
        }
        field(50020; "Description"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(50021; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Posted';
        }
        field(50022; "Loan No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Loans;
            Caption = 'Loan No.';
        }
        field(50023; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Product Factory";
            Caption = 'Product Type';
        }
        field(50024; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50025; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50026; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50027; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
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
            IF ("Bal. Account Type" = CONST(Employee)) Employee;
        }
        field(50028; "Blocked"; Option)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = ' ,Credit,Debit,All';
            OptionMembers = " ","Credit","Debit","All";
        }
        field(50029; "Status"; Enum "MemberStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }
        field(50030; "Issued Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Issued Date';
        }
        field(50031; "Bill Loan"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Bill Loan';
        }
        field(50032; "Charge Interest"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Interest';
        }
        field(50033; "Repayment Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Repayment Account';
        }
        field(50034; "Monthly Repayment"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Monthly Repayment';
        }
        field(50035; "Bill Account"; Code[20])
        {
            Caption = 'Bill Account';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "G/L Account"."No.";
        }
        field(50036; "Outstanding Bills"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Outstanding Bills';
        }
        field(50037; "Interest Bills"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Bills';
        }
        field(50038; "Outstanding Interest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Outstanding Interest';
        }
        field(50039; "Outstanding Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Outstanding Balance';
        }
        field(50040; "Appraisal Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Appraisal Amount';
        }
        field(50041; "Date Captured"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Captured';
        }
        field(50042; "Bal. Account No. (Suspence)"; Code[100])
        {
            Caption = 'Bal. Account No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "G/L Account"."No.";
        }
        field(50043; "Loans Category-Sasra"; Enum "LoanPerformanceIndicator")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Loans Category-Sasra';
        }
        field(50044; "Penalty Bills"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Penalty Bills';
        }
        field(50045; "Transaction Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
        }
        field(50046; "Outstanding Principal"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Outstanding Principal';
        }
        field(50047; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(50048; "Accrued Interest"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50049; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50050; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50051; "Insurance Bills"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance Bills';
        }
        field(50052; "Interest Calculation Method"; Enum "InterestCalculationMethod")
        {
            Editable = false;
            Caption = 'Interest Calculation Method';
            DataClassification = CustomerContent;
        }
        field(50053; "Outstanding Insurance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Outstanding Insurance';
        }
        field(50054; "Line Status"; Enum "LoanStatus")
        {
            Editable = false;
            Caption = 'Batch Status';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key("Key1"; "No", "Loan No.", "Entry No.", "Account No", "Transaction Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CopyFromLoanLines(Loans: Record Loans)
    begin
        Loans.CalcFields("Outstanding Insurance", "Outstanding Bill",
        "Outstanding Interest", "Outstanding Principal", "Outstanding Balance");
        "Loan No." := Loans."No.";
        "Product Type" := Loans."Product Type";
        "Outstanding Balance" := Loans."Outstanding Balance";
        "Outstanding Bills" := Loans."Outstanding Bill";
        "Outstanding Interest" := Loans."Outstanding Interest";
        "Outstanding Principal" := Loans."Outstanding Principal";
        "Outstanding Insurance" := Loans."Outstanding Insurance";
        "Account No" := Loans."Loan Account";
        "Account Type" := "Account Type"::Loan
    end;

    procedure CopyFromCreditAccLines(Acc: Record "Account Credit")
    begin
        "Loan No." := '';
        "Product Type" := Acc."Product Type";
        "Account No" := Acc."No.";
    end;

    procedure CopyFromLoanApplicationLines(Loans: Record "Loan Application")
    begin
        "Loan No." := Loans."No.";
        "Product Type" := Loans."Product Type";
        "Loan No." := Loans."No.";
        "Interest Date" := Today;
        "Account No" := Loans."Account No.";
        "Issued Date" := Loans."Disbursement Date";
        "Product Type" := Loans."Product Type";
        Description := 'Interest Accrued on / ' + Loans."No." + '-' + Format(Today);
        "Account Type" := "Account Type"::Loan
    end;
}




