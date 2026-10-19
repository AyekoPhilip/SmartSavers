table 50521 "DCS Loan Summary"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Loan No"; Code[20])
        {
            Caption = 'Loan No';
            DataClassification = CustomerContent;
        }
        field(50011; "Loan Product Type"; Code[20])
        {
            Editable = true;
            Caption = 'Loan Product Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Loan Amount"; Decimal)
        {
            Editable = true;
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50015; "Total Paid"; Decimal)
        {
            Editable = true;
            Caption = 'Total Paid';
            DataClassification = CustomerContent;
        }
        field(50016; "Expected Repayment"; Decimal)
        {
            Caption = 'Expected Repayment';
            DataClassification = CustomerContent;
        }
        field(50017; "Source"; Code[20])
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(50018; "Account No"; Code[20])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50019; "Last Update Date"; DateTime)
        {
            Caption = 'Last Update Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Member No.", "Loan No", "Loan Product Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Update Date" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Update Date" := CurrentDateTime;
    end;
}




