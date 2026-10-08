table 50507 "DCS CRB Data"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "NationalID"; Code[20])
        {
            Caption = 'NationalID';
            DataClassification = CustomerContent;
        }
        field(50010; "Account Type"; Code[20])
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Account Ref"; Code[20])
        {
            Caption = 'Account Ref';
            DataClassification = CustomerContent;
        }
        field(50012; "Listing Sector"; Code[20])
        {
            Caption = 'Listing Sector';
            DataClassification = CustomerContent;
        }
        field(50013; "Credit Score"; Decimal)
        {
            Caption = 'Credit Score';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "Overdue Amount"; Decimal)
        {
            Caption = 'Overdue Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Days in Arrears"; Integer)
        {
            Caption = 'Days in Arrears';
            DataClassification = CustomerContent;
        }
        field(50017; "Last Query Date"; Date)
        {
            Caption = 'Last Query Date';
            DataClassification = CustomerContent;
        }
        field(50018; "Last Query Time"; Time)
        {
            Caption = 'Last Query Time';
            DataClassification = CustomerContent;
        }
        field(50019; "Query Reason"; Code[10])
        {
            Caption = 'Query Reason';
            DataClassification = CustomerContent;
        }
        field(50020; "Date of Listing"; Date)
        {
            Caption = 'Date of Listing';
            DataClassification = CustomerContent;
        }
        field(50021; "Mobile Phone No"; Code[20])
        {
            Caption = 'Mobile Phone No';
            DataClassification = CustomerContent;
        }
        field(50022; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
            DataClassification = CustomerContent;
        }
        field(50023; "Has Fraud"; Boolean)
        {
            Caption = 'Has Fraud';
            DataClassification = CustomerContent;
        }
        field(50024; "Deliquency Code"; Code[10])
        {
            Caption = 'Deliquency Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "NationalID", "Account Type", "Account Ref")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




