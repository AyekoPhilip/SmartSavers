table 50850 "Keyword Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Key Word"; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Post-To Account Type"; Option)
        {
            OptionMembers = " ","Savings Account","Loan Account";
        }
        field(3; "Post-To Account Code"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
        }
    }

    keys
    {
        key(Key1; "Key Word")
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