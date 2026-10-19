table 50848 TestDataCopy
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "G/L Account"; Code[20]) { }
        field(3; "Table No"; Integer) { }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}