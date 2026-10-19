table 50480 "Bank Entries Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50012; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Card No."; Code[20])
        {
            Caption = 'Card No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Location"; Text[250])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
        }
        field(50015; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Reconciled"; Boolean)
        {
            Caption = 'Reconciled';
            DataClassification = CustomerContent;
        }
        field(50017; "Withdrawn"; Decimal)
        {
            Caption = 'Withdrawn';
            DataClassification = CustomerContent;
        }
        field(50018; "Paid In"; Decimal)
        {
            Caption = 'Paid In';
            DataClassification = CustomerContent;
        }
        field(50019; "Inserted"; Boolean)
        {
            Caption = 'Inserted';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Entry No.")
        {
            Clustered = true;
        }
        key("Key2"; "Posting Date", "Document No.", "External Document No.", "Amount", "Reconciled")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('Operation not allowed.');
    end;

    trigger OnInsert()
    begin
        Error('Operation not allowed.');
    end;

    trigger OnModify()
    begin
        Error('Operation not allowed.');
    end;

    trigger OnRename()
    begin
        Error('Operation not allowed.');
    end;
}




