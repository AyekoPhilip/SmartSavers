table 50448 "Fixed Deposit History"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No"; Integer)
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Fixed Deposit Type"; Code[20])
        {
            TableRelation = "Fixed Deposit Type";
            Caption = 'Fixed Deposit Type';
            DataClassification = CustomerContent;
        }
        field(50013; "FD Maturity Date"; Date)
        {
            Caption = 'FD Maturity Date';
            DataClassification = CustomerContent;
        }
        field(50014; "Neg. Interest Rate"; Decimal)
        {
            Caption = 'Neg. Interest Rate';
            DataClassification = CustomerContent;
        }
        field(50015; "FD Duration"; DateFormula)
        {
            Caption = 'FD Duration';
            DataClassification = CustomerContent;
        }
        field(50016; "FD Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Transfer all to Savings,Renew Principal,Renew Principal & Interest';
            OptionMembers = " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest";
            Caption = 'FD Maturity Instructions';
            DataClassification = CustomerContent;
        }
        field(50017; "Interest Earned"; Decimal)
        {
            Editable = false;
            Caption = 'Interest Earned';
            DataClassification = CustomerContent;
        }
        field(50018; "Fixed Amount"; Decimal)
        {
            Caption = 'Fixed Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No", "Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




