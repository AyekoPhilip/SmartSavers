table 50564 "BBF Entitlement"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50012; "Max No."; Integer)
        {
            Caption = 'Max No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Minor"; Boolean)
        {
            Caption = 'Minor';
            DataClassification = CustomerContent;
        }
        field(50014; "Self"; Boolean)
        {
            Caption = 'Self';
            DataClassification = CustomerContent;
        }
        field(50015; "Entitlement"; Text[80])
        {
            TableRelation = "Relationship Types";
            Caption = 'Entitlement';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Relations.Get(Entitlement) then
                    Description := Relations.Description;
            end;
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Relations: Record "Relationship Types";
}




