table 50090 "Pr Employee Allowance"
{
    Caption = 'Pr Employee Allowance';
    DataClassification = CustomerContent;
    
    fields
    {
        field(50009; "Job Grade"; Code[10])
        {
            Caption = 'Job Grade';
            TableRelation = "HR Lookup Values".Code where(Type=filter(Grade));
        }
        field(50010; "County"; Code[10])
        {
            Caption = 'County';
        }
        field(50011; "Transaction Code"; Code[10])
        {
            Caption = 'Transaction Code';
            TableRelation = "Pr Transaction Code";
        }
        field(50012; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(50013; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Job Grade")
        {
            Clustered = true;
        }
    }
}
