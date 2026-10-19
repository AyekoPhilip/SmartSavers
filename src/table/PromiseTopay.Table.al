table 50518 "Promise Topay"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Loan No."; Code[10])
        {
            TableRelation = Loans WHERE("Purpose of Loan" = FILTER(> '0'));
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Loans.Get("Loan No.") then begin
                    Loans.CalcFields("Outstanding Balance");
                    "Account No." := Loans."Account No.";
                    Name := Loans."Account Name";
                    "Outstanding Balance" := Loans."Outstanding Balance";
                end else begin
                    "Account No." := '';
                    Name := '';
                    "Outstanding Balance" := 0;
                end;
            end;
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Amount > "Outstanding Balance" then
                    Error(Err001);
            end;
        }
        field(50013; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50015; "Outstanding Balance"; Decimal)
        {
            Caption = 'Outstanding Balance';
            DataClassification = CustomerContent;
        }
        field(50016; "User ID"; Code[10])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.", "Loan No.", "Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;
    end;

    var
        Loans: Record Loans;
        Err001: Label 'Amount cannot be greater than outstanding balance';
}




