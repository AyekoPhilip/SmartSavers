table 50332 "Deposit Multiplier"
{
    Caption = 'Deposit Multiplier';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Loan No."; Code[50])
        {
            Caption = 'Loan No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Deposit Multiplier"; Decimal)
        {
            Caption = 'Deposit Multiplier';
            DataClassification = ToBeClassified;
        }
        field(50011; "Account No."; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
    }
    keys
    {
        key("PK"; "Loan No.")
        {
            Clustered = true;
        }
    }
}



