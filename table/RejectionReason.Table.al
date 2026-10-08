table 50495 "Rejection Reason"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[50])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Rejection Reason"; Code[100])
        {
            Caption = 'Rejection Reason';
            DataClassification = CustomerContent;
        }
        field(50011; "Creation Date"; Date)
        {
            Editable = false;
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Created By"; Code[50])
        {
            Editable = false;
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code", "Rejection Reason")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(a; "Code", "Rejection Reason")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Creation Date" := Today;
    end;
}




