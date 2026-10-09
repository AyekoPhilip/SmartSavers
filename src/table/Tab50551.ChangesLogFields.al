table 50551 "Changes Log (Fields)"
{
    Caption = 'Change Log Setup (Field)';
    ReplicateData = false;
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = "Change Log Setup (Table)";
            DataClassification = CustomerContent;
        }
        field(50010; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table No."));
            DataClassification = CustomerContent;
        }
        field(50011; "Field Caption"; Text[100])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Table No."),
                                                              "No." = FIELD("Field No.")));
            Caption = 'Field Caption';
            FieldClass = FlowField;
        }
        field(50012; "Log Insertion"; Boolean)
        {
            Caption = 'Log Insertion';
            DataClassification = CustomerContent;
        }
        field(50013; "Log Modification"; Boolean)
        {
            Caption = 'Log Modification';
            DataClassification = CustomerContent;
        }
        field(50014; "Log Deletion"; Boolean)
        {
            Caption = 'Log Deletion';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




