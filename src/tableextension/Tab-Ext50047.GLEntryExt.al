tableextension 50047 "GL_EntryExt" extends "G/L Entry"
{
    fields
    {
        field(50009; "Apportioned"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Apportioned';
        }
        field(50010; "No. Of Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Of Units';
        }
        field(50011; "Investment Code"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Investment Code';
        }
        field(50012; "Nominal Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Nominal Value';
        }
        field(50013; "Loan No."; Code[50])
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Loan No." where("Entry No." = field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Loan No.';
        }
        field(50014; "Product Type"; Code[20])
        {
            CalcFormula = lookup(Loans."Product Type" where("No." = field("Loan No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Product Type';
        }
        field(50015; "Transaction Type"; Enum "LoanTransactionType")
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Transaction Type" where("Entry No." = field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Transaction Type';
        }
        field(50016; "Customer Posting Group"; Code[50])
        {
            CalcFormula = lookup(Customer."Customer Posting Group" where("No."=field("Source No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Customer Posting Group';
        }

        field(50017; "Vendor Posting Group"; Code[50])
        {
            CalcFormula = lookup(Vendor."Vendor Posting Group" where("No."=field("Source No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Vendor Posting Group';
        }

        field(50018; "Fixed Asset Number"; Code[50])
        {
            CalcFormula = lookup("FA Ledger Entry"."FA No." where("G/L Entry No." = field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Fixed Posting Group';
        }



    }
}


