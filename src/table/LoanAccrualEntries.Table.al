table 50602 "Loan Accrual Entries"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Loan Accrual Entries";
    LookupPageId = "Loan Accrual Entries";
    fields
    {
        field(1; "Entry No"; BigInteger)
        {
            AutoIncrement = true;

        }
        field(2; "Posting Date"; Date) { }
        field(3; "Loan No"; Code[20]) { }
        field(4; Amount; Decimal) { }
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