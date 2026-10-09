table 50579 "Transaction Types-Mobile"
{
    Caption = 'Transaction Types-Mobile';
    DataClassification = ToBeClassified;
    LookupPageId = "Transaction Type-Mobile";
    DrillDownPageId = "Transaction Type-Mobile";
    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Transaction Type"; Enum "MobileTransType")
        {
            Caption = 'Transaction Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "No."; Code[100])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50012; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin

            end;
        }
        field(50014; "Account No."; Code[20])
        {
            TableRelation = Member."No.";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin

            end;
        }
        field(50015; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50016; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var

            begin

            end;
        }
        field(50017; "Outstanding Interest"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Interest';
        }
        field(50018; "Outstanding Bill"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Bill';
        }
        field(50019; "Outstanding Balance"; Decimal)
        {
            Editable = false;
        }
        field(50020; "Outstanding Principal"; Decimal)
        {
            Editable = false;
            Caption = 'Outstanding Principal';
        }
        field(50021; "Balance"; Decimal)
        {
            Caption = 'Available Balance';
            Editable = false;
        }
        field(50022; "Balance (LCY)"; Decimal)
        {
            Caption = 'Balance (LCY)';
            Editable = false;
        }
        field(50023; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50024; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50025; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50026; "Deduction Status"; Enum "MobileDeductionStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50027; "Disbursement Account No."; Code[100])
        {
            Editable = false;
            TableRelation = "Account Banking"."No.";
            DataClassification = CustomerContent;
        }
        field(50028; "Amount To Post"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50029; "Interest Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Posting Date';
            Editable = false;
        }
        field(50030; "Repayment Type"; Enum "LoanTransactionType")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
    keys
    {
        key("PK"; "Entry No.", "No.")
        {
            Clustered = true;
        }
    }
    procedure CopyFromPostedLoans(TempEntry: Record Loans)
    begin
        TempEntry.CalcFields(
                  "Outstanding Balance",
                  "Outstanding Bill",
                  "Outstanding Interest",
                  "Outstanding Principal");
        "Product Type" := TempEntry."Product Type";
        "Application Date" := Today;
        "Interest Posting Date" := TempEntry."Interest Posting Date";
        "No." := TempEntry."No.";
        "Account No." := TempEntry."Account No.";
        "Disbursement Account No." := TempEntry."Disbursement Account No.";
        "Requested Amount" := TempEntry."Requested Amount";
        "Approved Amount" := TempEntry."Approved Amount";
        "Outstanding Bill" := TempEntry."Outstanding Bill";
        "Outstanding Interest" := TempEntry."Outstanding Interest";
        "Outstanding Balance" := TempEntry."Outstanding Balance";
        "Outstanding Principal" := TempEntry."Outstanding Principal";
    end;

}



