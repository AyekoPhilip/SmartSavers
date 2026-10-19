table 50536 "Collateral Register Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Collateral Register"."No.";
            Caption = 'No.';
        }
        field(50010; "Model"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Model';
        }
        field(50011; "Make"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Make';
        }
        field(50012; "Engine No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Engine No.';
        }
        field(50013; "Chasis No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Chasis No.';
        }
        field(50014; "Year of Manufacture"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Year of Manufacture';
        }
        field(50015; "Country of Origin"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;
            Caption = 'Country of Origin';
        }
        field(50016; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Line No.';
        }
        field(50017; "Mortgage Bond"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50018; "Rate Clearance"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Deed Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50020; "Evaluation Invoice"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50021; "Property Plan"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50022; "Valuation Report"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50023; "Municipal Permit"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50024; "Letters Of Guaranteed"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




