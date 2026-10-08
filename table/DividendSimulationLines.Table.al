table 50372 "Dividend Simulation Lines"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "G/L Account"; Code[20])
        {
            Caption = 'G/L Account';
            DataClassification = CustomerContent;
        }
        field(50011; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(50012; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Weighted Amount"; Decimal)
        {
            Caption = 'Weighted Amount';
            DataClassification = CustomerContent;
        }
        field(50015; "No."; Code[20])
        {
            TableRelation = "Dividend Simulation Header"."No.";
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Product Type"; Code[10])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        }
        field(50017; "Document No."; Code[10])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Document No.", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




