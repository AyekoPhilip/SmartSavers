table 50500 "DCS Parameter Range"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "RangeID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'RangeID';
            DataClassification = CustomerContent;
        }
        field(50010; "Parameter Code"; Code[20])
        {
            TableRelation = "DCS Parameter".Code;
            Caption = 'Parameter Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Range Min."; Decimal)
        {
            Caption = 'Range Min.';
            DataClassification = CustomerContent;
        }
        field(50012; "Range Max."; Decimal)
        {
            Caption = 'Range Max.';
            DataClassification = CustomerContent;
        }
        field(50013; "Evaluation Method"; Option)
        {
            OptionCaption = 'Flat Rate,Percentage,Perc. Inc.,Perc. Decs.,Average,Summation,Multiplication,Division,Subtraction,Range,Graduated Range,Exponential';
            OptionMembers = "Flat Rate","Percentage","Perc. Inc.","Perc. Decs.","Average","Summation","Multiplication","Division","Subtraction","Range","Graduated Range","Exponential";
            Caption = 'Evaluation Method';
            DataClassification = CustomerContent;
        }
        field(50014; "Evaluation Factor"; Decimal)
        {
            Caption = 'Evaluation Factor';
            DataClassification = CustomerContent;
        }
        field(50015; "Qualification Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Check-Off Loan,Secured Lending';
            OptionMembers = "Check-Off Loan","Secured Lending";
            Caption = 'Qualification Type';
        }
        field(50016; "Variable Score"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Variable Score';
        }
    }

    keys
    {
        key("Key1"; "RangeID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




