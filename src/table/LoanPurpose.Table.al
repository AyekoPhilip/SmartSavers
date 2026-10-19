table 50516 "Loan Purpose"
{
    DrillDownPageID = "Loan Purpose";
    LookupPageID = "Loan Purpose";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Sector"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sector';
        }
        field(50012; "Sub Sector"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Sector';
        }
        field(50013; "Amount"; Decimal)
        {
            CalcFormula = Sum(Loans."Approved Amount" where("Purpose of Loan" = field(Code),"Approval Status" = const(Posted),
                                                             "Disbursement Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Amount';
        }
        field(50014; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




