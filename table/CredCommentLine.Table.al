table 50329 "Cred. Comment Line"
{
    Caption = 'Cred. Comment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50010; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50011; "Comment"; Text[250])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(50012; "Date"; Date)
        {
            Caption = 'Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50013; "Entered By"; Code[100])
        {
            Caption = 'Entered By';
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(50014; "Table No."; Integer)
        {
            Caption = 'Table No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("PK"; "No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Date := Today;
        "Entered By" := UserId;
    end;
}



