table 50590 "Temp. Files"
{
    Caption = 'Temp. Files';
    DataClassification = CustomerContent;
    DrillDownPageId = "Temp. Files";
    LookupPageId = "Temp. Files";
    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            TableRelation = Member;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Loans: Record Loans;
            begin
                if "Product Type" <> '' then begin
                    Loans.Reset();
                    Loans.SetRange("Account No.", "Account No.");
                    Loans.SetRange("Product Type", "Product Type");
                    Loans.SetFilter("Outstanding Balance", '>0');
                    if Loans.FindFirst() then begin
                        Loans.CalcFields("Outstanding Balance");
                        "Loan No." := Loans."No.";
                    end
                end
            end;
        }
        field(50011; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Loans: Record Loans;
            begin
                if "Account No." <> '' then begin
                    Loans.Reset();
                    Loans.SetRange("Account No.", "Account No.");
                    Loans.SetRange("Product Type", "Product Type");
                    Loans.SetFilter("Outstanding Balance", '>0');
                    if Loans.FindFirst() then begin
                        Loans.CalcFields("Outstanding Balance");
                        "Loan No." := Loans."No.";
                    end
                end
            end;
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50013; "Installment Amount"; Decimal)
        {
            Caption = 'Installment Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50015; "Loan No."; Code[100])
        {
            Caption = 'Loan No.';
            TableRelation = Loans;
            DataClassification = CustomerContent;
        }
        field(50016; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Entry No.")
        {
            Clustered = true;
        }
    }
}
