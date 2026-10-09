table 50408 "Loan Product Parameters"
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
        field(50013; "Computation Method"; Option)
        {
            OptionCaption = 'Formula,Flat Rate,Range,Ceiling,Multiplier,Divisor,Frequency,Sum,Difference,Graduated Range,Exponential,Terminate';
            OptionMembers = "Formula","Flat Rate","Range","Ceiling","Multiplier","Divisor","Frequency","Sum","Difference","Graduated Range","Exponential","Terminate";
            Caption = 'Computation Method';
            DataClassification = CustomerContent;
        }
        field(50014; "Parameter Base"; Option)
        {
            OptionCaption = ',Basic Pay,Earnings,Deductions,Net Pay,Deposits,Loan Balance - Long Term,Loan Balance - Short Term,Curr. Repayment - Short Term,Curr. Repayment - Long Term,Guarantors Amt,Collateral Amt,Net Income';
            OptionMembers = "","Basic Pay","Earnings","Deductions","Net Pay","Deposits","Loan Balance - Long Term","Loan Balance - Short Term","Curr. Repayment - Short Term","Curr. Repayment - Long Term","Guarantors Amt","Collateral Amt","Net Income";
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
            OptionCaption = 'Value,Transaction date';
            OptionMembers = "Value","Transaction date";
            Caption = 'Parameter Base Unit';
            DataClassification = CustomerContent;
        }
        field(50018; "Success Default Value"; Decimal)
        {
            Caption = 'Success Default Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Loan Product Code", "Parameter Base")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




