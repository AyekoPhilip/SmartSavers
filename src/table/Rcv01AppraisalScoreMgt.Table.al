table 90000 "Rcv01 Appraisal Score Mgt."
{
    Caption = 'Score Matrix Mgt.';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; Parameter; Text[150])
        {
            Caption = 'Parameter';
            DataClassification = CustomerContent;
        }
        field(4; "Score (Max. Score)"; Integer)
        {
            Caption = 'Score (Max. Score)';
            DataClassification = CustomerContent;
        }
        field(5; "Membership Age"; Integer)
        {
            Caption = 'Membership Age';
            DataClassification = CustomerContent;
        }
        field(6; "Credit History"; Integer)
        {
            Caption = 'Credit History';
            DataClassification = CustomerContent;
        }
        field(7; "Deposit Exposure"; Integer)
        {
            Caption = 'Deposit Exposure';
            DataClassification = CustomerContent;
        }
        field(8; "Monthly Deposit"; Integer)
        {
            Caption = 'Remittance Amount (Banding Met)';
            DataClassification = CustomerContent;
        }
        field(9; "Banking Remittance"; Integer)
        {
            Caption = 'Fosa Remittance';
            DataClassification = CustomerContent;
        }
        field(10; "Total Deposits"; Integer)
        {
            Caption = 'Total Deposits';
            DataClassification = CustomerContent;
        }
        field(11; "Individual Score"; Integer)
        {
            Caption = 'Individual Score';
            DataClassification = CustomerContent;
        }
        field(12; "Account Name"; Text[150])
        {
            DataClassification = CustomerContent;

        }
        field(13; "Registration Date"; Date)
        {
            DataClassification = CustomerContent;

        }
        field(14; "Total Score"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Qualify Amount"; Decimal)
        {
            DataClassification = CustomerContent;

        }
        field(16; "Monthly Contribution"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Monthly Deposit Remittance';

        }
        field(17; "Shares Banding"; Decimal)
        {
            DataClassification = CustomerContent;

        }
        field(18; "Existing Member"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; Status; Enum MemberStatus)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory";
            Editable = false;

        }
        field(21; "Has Exiting Loan"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Shares Multiplier"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; Rejoined; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Deposits (Above Limit)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Max Available"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Shares Deposit Multiplier"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Score Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Loan Status"; Enum MemberStatus)
        {
            Caption = 'Loan Status';
            DataClassification = CustomerContent;
        }
        field(29; "Mobile Status"; Enum MemberStatus)
        {
            Caption = 'Mobile Loan';
            DataClassification = CustomerContent;
        }
        field(30; "Error Log"; Text[250])
        {
            Caption = 'Error Log';
            DataClassification = CustomerContent;
        }
        field(31; "Loan Paid on Time"; Integer)
        {
            Caption = 'Loan Paid on Time';
            DataClassification = CustomerContent;
        }
        field(32; "Has Graduated"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Previously Defaulted Facility"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Last Approved Loans"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Allow Min. Banding"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(36; "Adjusted Score"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(37; "Adjusted Score Amount"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(38; "Score On Loan"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Account No.")
        {
            Clustered = true;
        }
    }

    procedure CopyfromCustDetailMgt(CustMember: Record Member)
    begin
        "Account No." := CustMember."No.";
        "Account Name" := CustMember.Name;
        Status := CustMember.Status;
        "Loan Status" := CustMember."Loan Status";
        "Mobile Status" := CustMember."Mobile Status";
    end;
}
