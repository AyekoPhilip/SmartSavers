table 50402 "Interest Buffer"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No"; Integer)
        {
            AutoIncrement = false;
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No"; Code[20])
        {
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50011; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Interest Date"; Date)
        {
            Caption = 'Interest Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50015; "Account Matured"; Boolean)
        {
            Caption = 'Account Matured';
            DataClassification = CustomerContent;
        }
        field(50016; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50017; "Late Interest"; Boolean)
        {
            Caption = 'Late Interest';
            DataClassification = CustomerContent;
        }
        field(50018; "Transferred"; Boolean)
        {
            Caption = 'Transferred';
            DataClassification = CustomerContent;
        }
        field(50019; "Mark For Deletion"; Boolean)
        {
            Caption = 'Mark For Deletion';
            DataClassification = CustomerContent;
        }
        field(50020; "Reference No."; Code[30])
        {
            Caption = 'Reference No.';
            DataClassification = CustomerContent;
        }
        field(50021; "Qualifying Amount"; Decimal)
        {
            Caption = 'Qualifying Amount';
            DataClassification = CustomerContent;
        }
        field(50022; "Description"; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50023; "Header No."; Code[20])
        {
            Caption = 'Header No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No", "Account No", "Header No.")
        {
            Clustered = true;
        }
        key("Key2"; "Account No", "Transferred")
        {
            SumIndexFields = "Interest Amount";
        }
    }

    fieldgroups
    {
    }
}




