table 50849 "MPESA Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Receipt No."; Code[30])
        {
        }
        field(50010; "Completion Time"; DateTime)
        {
        }
        field(50011; "Status"; Option)
        {
            OptionMembers = ,Completed,Incomplete;
        }
        field(50012; Amount; Decimal)
        {
        }
        field(50013; Balance; Decimal)
        {
        }
        field(50014; "Account No."; Text[200])
        {
        }
        field(50015; "Processed"; Boolean)
        {
        }
        field(50016; "Paybil Number"; Code[50])
        {
        }
        field(50017; "Phone"; Code[50])
        {
        }
        field(50018; "Customer Name"; Text[100])
        {
        }
        field(50019; "Transaction Date"; Date)
        {
        }
        field(50020; "Posted On"; DateTime)
        {
        }
        field(50021; "Received On"; DateTime) { }
    }
    keys
    {
        key(PK; "Receipt No.")
        {
            Clustered = true;
        }
        key(Secondary; "Transaction Date")
        {
        }
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
