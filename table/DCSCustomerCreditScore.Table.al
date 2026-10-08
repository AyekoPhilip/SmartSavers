table 50499 "DCS Customer Credit Score"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Customer No."; Code[20])
        {
            TableRelation = "Social Listening Sites App.";
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
        field(50019; "Application Priority"; Integer)
        {
            Caption = 'Application Priority';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Customer No.", "Product Code", "Parameter Code")
        {
            Clustered = true;
        }
        key("Key2"; "Application Priority")
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
}




