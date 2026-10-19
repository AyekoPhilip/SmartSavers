table 50435 "Bankers Cheques Register"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Cheque No."; Code[6])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Pending,Approved,Cancelled,stopped,Dishonoured';
            OptionMembers = "Pending","Approved","Cancelled","stopped","Dishonoured";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50011; "Approval Date"; Date)
        {
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Application No."; Code[10])
        {
            Caption = 'Application No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Cancelled/Stopped By"; Code[50])
        {
            Caption = 'Cancelled/Stopped By';
            DataClassification = CustomerContent;
        }
        field(50014; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
            Caption = 'Bank Account';
            DataClassification = CustomerContent;
        }
        field(50015; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50016; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50017; "Leaf Limit Amount"; Decimal)
        {
            Caption = 'Leaf Limit Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Cheque No.", "Bank Account")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




