table 50595 "Temp. Form Data"
{
    Caption = 'Temp. Form Data';
    DataClassification = CustomerContent;
    
    fields
    {
        
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(50010; "No."; Code[100])
        {
            Caption = 'No.';
        }
        field(50011; "Name"; Text[250])
        {
            Caption = 'Name';
        }
        field(50012; "Shares Deposits"; Decimal)
        {
            Caption = 'Shares Deposits';
        }
        field(50013; "Shares Capital"; Decimal)
        {
            Caption = 'Shares Capital';
        }
        field(50014; "Savings"; Decimal)
        {
            Caption = 'Savings';
        }
        field(50015; "Junior Savings"; Decimal)
        {
            Caption = 'Junior Savings';
        }
        field(50016; "Fixed Deposits"; Decimal)
        {
            Caption = 'Fixed Deposits';
        }
        field(50017; "Speciality Savings"; Decimal)
        {
            Caption = 'Speciality Savings';
        }
        field(50018; "Loans"; Decimal)
        {
            Caption = 'Loans';
            DataClassification = CustomerContent;
        }
        field(50019; "Transaction Type"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50020; "Total Savings"; Decimal)
        {
            Caption = 'Total Savings';
        }
    }
    keys
    {
        key("PK"; "Entry No.")
        {
            Clustered = true;
        }
    }
}
