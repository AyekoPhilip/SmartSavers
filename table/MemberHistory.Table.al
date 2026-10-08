table 50586 "Member History"
{
    Caption = 'Member History';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[100])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "No. of Active Loans"; Integer)
        {
            Caption = 'No. of Active Loans';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(<> 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "No. of Closed A/c"; Integer)
        {
            Caption = 'No. of Closed A/c';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(= 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "No. of Application"; Integer)
        {
            Caption = 'No. of Application';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(<> 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Pending Payments"; Integer)
        {
            Caption = 'Pending Payments';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(<> 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "No. of Quotes"; Integer)
        {
            Caption = 'No. of Quotes';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(<> 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "No. of Sales Docs"; Integer)
        {
            Caption = 'No. of Sales Docs';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(<> 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "No. of Credit Memo"; Integer)
        {
            Caption = 'No. of Credit Memo';
            CalcFormula = Count(Loans where("Outstanding Balance" = filter(<> 0),
                                             "Account No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }

    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
}
