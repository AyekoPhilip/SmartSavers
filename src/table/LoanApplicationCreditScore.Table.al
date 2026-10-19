table 50407 "Loan Application Credit Score"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52141088;
    LookupPageID = 52141088; */

    fields
    {
        field(50009; "Customer No."; Code[20])
        {
            Editable = false;
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Product Code"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Parameter Code"; Code[20])
        {
            TableRelation = "DCS Parameter".Code;
            Caption = 'Parameter Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Score"; Decimal)
        {
            Caption = 'Score';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Score Value" := Score;
                "System Gen. Score" := Score;
            end;
        }
        field(50013; "Calculated Success"; Decimal)
        {
            Caption = 'Calculated Success';
            DataClassification = CustomerContent;
        }
        field(50014; "Calculated Failure"; Decimal)
        {
            Caption = 'Calculated Failure';
            DataClassification = CustomerContent;
        }
        field(50015; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Qualifying Amount"; Decimal)
        {
            Caption = 'Qualifying Amount';
            DataClassification = CustomerContent;
        }
        field(50017; "RequestTime"; DateTime)
        {
            Caption = 'RequestTime';
            DataClassification = CustomerContent;
        }
        field(50018; "General Output"; Text[100])
        {
            Caption = 'General Output';
            DataClassification = CustomerContent;
        }
        field(50019; "Loan No."; Code[20])
        {
            Editable = false;
            Caption = 'Loan No.';
            DataClassification = CustomerContent;
        }
        field(50020; "Parameter Calculation"; Text[250])
        {
            Caption = 'Parameter Calculation';
            DataClassification = CustomerContent;
        }
        field(50021; "Priority"; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(50022; "Variable"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Variable';
        }
        field(50023; "Qualification Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Check-Off Loan,Secured Lending';
            OptionMembers = "Check-Off Loan","Secured Lending";
            Caption = 'Qualification Type';
        }
        field(50024; "System Gen. Score"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'System Gen. Score';
        }
        field(50025; "Score Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Score Value';
        }
        field(50026; "Very Low"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Very Low';
        }
        field(50027; "Low"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Low';
        }
        field(50028; "Moderate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Moderate';
        }
        field(50029; "High"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'High';
        }
        field(50030; "Very High"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Very High';
        }
        field(50031; "Non Value Parameters"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Non Value Parameters';
        }
        field(50032; "Risk Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Risk Value';
        }
        field(50033; "Risk Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Very Low,Low,Moderate,High,Very High';
            OptionMembers = " ","Very Low","Low","Moderate","High","Very High";
            Caption = 'Risk Option';
        }
    }

    keys
    {
        key("Key1"; "Customer No.", "Loan No.", "Parameter Code", "Qualification Type")
        {
            Clustered = true;
        }
        key("Key2"; "Priority")
        {

        }
        key("Key3"; "Qualification Type")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        RequestTime := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        RequestTime := CurrentDateTime;
    end;
}




