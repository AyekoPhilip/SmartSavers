table 50498 "DCS Parameter Matrix"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Loan Product Code"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Loan Product Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Parameter Code"; Code[20])
        {
            TableRelation = "DCS Parameter".Code;
            Caption = 'Parameter Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Parameter.Get("Parameter Code") then begin
                    "Parameter Desc" := Parameter.Description;
                    //  "Parameter Scope":=Parameter."Parameter Scope";
                end;
            end;
        }
        field(50011; "Parameter Desc"; Text[100])
        {
            Caption = 'Parameter Desc';
            DataClassification = CustomerContent;
        }
        field(50012; "Factor"; Decimal)
        {
            Caption = 'Factor';
            DataClassification = CustomerContent;
        }
        field(50013; "Contributes To Score As"; Option)
        {
            OptionCaption = 'Formula Factor,Flat Rate,Range,Ceiling,Multiplier,Divisor,Frequency,Sum,Difference,Graduated Range,Exponential,Terminate,Probability,Floor';
            OptionMembers = "Formula Factor","Flat Rate","Range","Ceiling","Multiplier","Divisor","Frequency","Sum","Difference","Graduated Range","Exponential","Terminate","Probability","Floor";
            Caption = 'Contributes To Score As';
            DataClassification = CustomerContent;
        }
        field(50014; "Parameter Base"; Option)
        {
            OptionCaption = 'Open,Share Capital,Deposits,Loans,Repayment,Loans Guaranteed,Net Salary,Basic Salary,Other Income,Interest Rate,Mobile Transactions,Fixed Deposits,Dividends,Guarantors,Collateral,Date of Join,NetIncome,Gross Salary';
            OptionMembers = "Open","Share Capital","Deposits","Loans","Repayment","Loans Guaranteed","Net Salary","Basic Salary","Other Income","Interest Rate","Mobile Transactions","Fixed Deposits","Dividends","Guarantors","Collateral","Date of Join","NetIncome","Gross Salary";
            Caption = 'Parameter Base';
            DataClassification = CustomerContent;
        }
        field(50015; "Application Priority"; Integer)
        {
            Caption = 'Application Priority';
            DataClassification = CustomerContent;
        }
        field(50016; "Formula"; Text[30])
        {
            Caption = 'Formula';
            DataClassification = CustomerContent;
        }
        field(50017; "Parameter Base Unit"; Option)
        {
            OptionCaption = 'Value,Transaction date,Count';
            OptionMembers = "Value","Transaction date","Count";
            Caption = 'Parameter Base Unit';
            DataClassification = CustomerContent;
        }
        field(50018; "Success Default Value"; Decimal)
        {
            Caption = 'Success Default Value';
            DataClassification = CustomerContent;
        }
        field(50019; "Parameter Scope"; Option)
        {
            OptionCaption = 'General,Long Term,Short Term,Product Specific,LoanTopUp,Current Product,Current Application';
            OptionMembers = "General","Long Term","Short Term","Product Specific","LoanTopUp","Current Product","Current Application";
            Caption = 'Parameter Scope';
            DataClassification = CustomerContent;
        }
        field(50020; "Failure Response"; Text[100])
        {
            Caption = 'Failure Response';
            DataClassification = CustomerContent;
        }
        field(50021; "Date Formula"; DateFormula)
        {
            Caption = 'Date Formula';
            DataClassification = CustomerContent;
        }
        field(50022; "Data Source"; Code[20])
        {
            TableRelation = "DCS Data Source".Code;
            Caption = 'Data Source';
            DataClassification = CustomerContent;
        }
        field(50023; "Computation Method"; Option)
        {
            OptionCaption = 'Direct Factor,Formula Factor';
            OptionMembers = "Direct Factor","Formula Factor";
            Caption = 'Computation Method';
            DataClassification = CustomerContent;
        }
        field(50024; "Fall Back Parameter"; Code[20])
        {
            Caption = 'Fall Back Parameter';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan Product Code", "Parameter Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Parameter: Record "DCS Parameter";
}




