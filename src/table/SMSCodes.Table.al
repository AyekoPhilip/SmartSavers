table 50469 "SMS Codes"
{
    Caption = 'Dynamic Request Page Field';
    LookupPageID = "Dynamic Request Page Fields";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = "Table Metadata".ID;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CalcFields("Table Name", "Table Caption");
            end;
        }
        field(50010; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            NotBlank = true;
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table ID"));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CalcFields("Field Name", "Field Caption");
            end;
        }
        field(50011; "Table Name"; Text[30])
        {
            CalcFormula = Lookup("Table Metadata".Name WHERE(ID = FIELD("Table ID")));
            Caption = 'Table Name';
            FieldClass = FlowField;
        }
        field(50012; "Table Caption"; Text[80])
        {
            CalcFormula = Lookup("Table Metadata".Caption WHERE(ID = FIELD("Table ID")));
            Caption = 'Table Caption';
            FieldClass = FlowField;
        }
        field(50013; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table ID"),
                                                        "No." = FIELD("Field ID")));
            Caption = 'Field Name';
            FieldClass = FlowField;
        }
        field(50014; "Field Caption"; Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Table ID"),
                                                              "No." = FIELD("Field ID")));
            Caption = 'Field Caption';
            FieldClass = FlowField;
        }
        field(50015; "Code"; Text[30])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Table ID", "Field ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




