table 50523 "DCS Member Transaction"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Member No"; Code[20])
        {
            Caption = 'Member No';
            DataClassification = CustomerContent;
        }
        field(50010; "Last Update"; DateTime)
        {
            Caption = 'Last Update';
            DataClassification = CustomerContent;
        }
        field(50011; "Gross Salary"; Decimal)
        {
            Caption = 'Gross Salary';
            DataClassification = CustomerContent;
        }
        field(50012; "Earnings"; Decimal)
        {
            Caption = 'Earnings';
            DataClassification = CustomerContent;
        }
        field(50013; "Deductions"; Decimal)
        {
            Caption = 'Deductions';
            DataClassification = CustomerContent;
        }
        field(50014; "Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
            DataClassification = CustomerContent;
        }
        field(50015; "Loan Balance"; Decimal)
        {
            Caption = 'Loan Balance';
            DataClassification = CustomerContent;
        }
        field(50016; "Expected Loan Repayment"; Decimal)
        {
            CalcFormula = Sum("DCS Loan Summary"."Expected Repayment" WHERE("Account No" = FIELD("Member No")));
            FieldClass = FlowField;
            Caption = 'Expected Loan Repayment';
        }
        field(50017; "Last Repayment Date"; Date)
        {
            Caption = 'Last Repayment Date';
            DataClassification = CustomerContent;
        }
        field(50018; "Total Loan Repayments"; Decimal)
        {
            CalcFormula = Sum("DCS Loan Summary"."Total Paid" WHERE("Account No" = FIELD("Member No")));
            FieldClass = FlowField;
            Caption = 'Total Loan Repayments';
        }
        field(50019; "Number of Active Loans"; Decimal)
        {
            Caption = 'Number of Active Loans';
            DataClassification = CustomerContent;
        }
        field(50020; "Date of Join"; Date)
        {
            Description = 'Date of joining sacco';
            Caption = 'Date of Join';
            DataClassification = CustomerContent;
        }
        field(50021; "Loan"; Decimal)
        {
            Caption = 'Loan';
            DataClassification = CustomerContent;
        }
        field(50022; "Default Status"; Option)
        {
            OptionCaption = ' ,Watch,Doubtfull,Substandard,Default';
            OptionMembers = " ","Watch","Doubtfull","Substandard","Default";
            Caption = 'Default Status';
            DataClassification = CustomerContent;
        }
        field(50023; "Standing Orders"; Decimal)
        {
            Caption = 'Standing Orders';
            DataClassification = CustomerContent;
        }
        field(50024; "Direct Debits"; Decimal)
        {
            Caption = 'Direct Debits';
            DataClassification = CustomerContent;
        }
        field(50025; "Deposits Contribution"; Decimal)
        {
            Caption = 'Deposits Contribution';
            DataClassification = CustomerContent;
        }
        field(50026; "Loan Repayment Frequency"; Integer)
        {
            Caption = 'Loan Repayment Frequency';
            DataClassification = CustomerContent;
        }
        field(50027; "Loans Borrowing History"; Integer)
        {
            Caption = 'Loans Borrowing History';
            DataClassification = CustomerContent;
        }
        field(50028; "Deposit Guaranteed"; Decimal)
        {
            Caption = 'Deposit Guaranteed';
            DataClassification = CustomerContent;
        }
        field(50029; "Share Capital"; Decimal)
        {
            Caption = 'Share Capital';
            DataClassification = CustomerContent;
        }
        field(50030; "Basic"; Decimal)
        {
            Caption = 'Basic';
            DataClassification = CustomerContent;
        }
        field(50031; "Other Income"; Decimal)
        {
            Caption = 'Other Income';
            DataClassification = CustomerContent;
        }
        field(50032; "Qualified Amount"; Decimal)
        {
            Caption = 'Qualified Amount';
            DataClassification = CustomerContent;
        }
        field(50033; "Bridge"; Decimal)
        {
            Caption = 'Bridge';
            DataClassification = CustomerContent;
        }
        field(50034; "Pressent VAF"; Decimal)
        {
            Caption = 'Pressent VAF';
            DataClassification = CustomerContent;
        }
        field(50035; "Installments"; Decimal)
        {
            Caption = 'Installments';
            DataClassification = CustomerContent;
        }
        field(50036; "Loan Security"; Decimal)
        {
            Caption = 'Loan Security';
            DataClassification = CustomerContent;
        }
        field(50037; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
            DataClassification = CustomerContent;
        }
        field(50038; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        }
        field(50039; "Defaulter"; Boolean)
        {
            Caption = 'Defaulter';
            DataClassification = CustomerContent;
        }
        field(50040; "Has FOSA Committments"; Boolean)
        {
            Caption = 'Has FOSA Committments';
            DataClassification = CustomerContent;
        }
        field(50041; "Salary Channelled Internally"; Boolean)
        {
            Caption = 'Salary Channelled Internally';
            DataClassification = CustomerContent;
        }
        field(50042; "No. of Active Loans"; Integer)
        {
            Caption = 'No. of Active Loans';
            DataClassification = CustomerContent;
        }
        field(50043; "Last Deposit Date"; Date)
        {
            Caption = 'Last Deposit Date';
            DataClassification = CustomerContent;
        }
        field(50044; "MSACCO Trans Ferquency"; Integer)
        {
            Caption = 'MSACCO Trans Ferquency';
            DataClassification = CustomerContent;
        }
        field(50045; "MSACCO Last Trans Date"; Date)
        {
            Caption = 'MSACCO Last Trans Date';
            DataClassification = CustomerContent;
        }
        field(50046; "Long Term Repayments"; Decimal)
        {
            Caption = 'Long Term Repayments';
            DataClassification = CustomerContent;
        }
        field(50047; "Short Term Repayments"; Decimal)
        {
            Caption = 'Short Term Repayments';
            DataClassification = CustomerContent;
        }
        field(50048; "Loan Span"; Option)
        {
            OptionCaption = ' ,Short Term,Long Term';
            OptionMembers = " ","Short Term","Long Term";
            Caption = 'Loan Span';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Member No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Update" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Update" := CurrentDateTime;
        StartDate := CalcDate('-4M', Today);
        Vend.Reset;
        //Vend.SETRANGE("BOSA Account No","Member No");
        if Vend.FindFirst then begin
            TransSumm.Reset;
            TransSumm.SetRange("Account No", Vend."No.");
            TransSumm.SetRange("Posting Date", StartDate, Today);
            TransSumm.CalcSums(Amount);
            "Net Pay" := (TransSumm.Amount / 4) * -1;
            Validate("Net Pay");
        end;
    end;

    var
        TransSumm: Record "Account Trans Summary";
        Vend: Record Vendor;
        StartDate: Date;
}




