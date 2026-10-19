table 50320 "DSC Appraisal Scoring"
{
    Caption = 'DSC Appraisal Scoring';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Parameter"; Text[150])
        {
            Caption = 'Parameter';
            DataClassification = ToBeClassified;
        }
        field(50012; "Score (Max. Score)"; Integer)
        {
            Caption = 'Score (Max. Score)';
            DataClassification = ToBeClassified;
        }
        field(50013; "Membership Age"; Integer)
        {
            Caption = 'Membership Age';
            DataClassification = ToBeClassified;
        }
        field(50014; "Credit History"; Integer)
        {
            Caption = 'Credit History';
            DataClassification = ToBeClassified;
        }
        field(50015; "Deposit Exposure"; Integer)
        {
            Caption = 'Deposit Exposure';
            DataClassification = ToBeClassified;
        }
        field(50016; "Monthly Deposit"; Integer)
        {
            Caption = 'Monthly Deposit';
            DataClassification = ToBeClassified;
        }
        field(50017; "Banking Remittance"; Integer)
        {
            Caption = 'Banking Remittance';
            DataClassification = ToBeClassified;
        }
        field(50018; "Total Deposits"; Integer)
        {
            Caption = 'Total Deposits';
            DataClassification = ToBeClassified;
        }
        field(50019; "Individual Score"; Integer)
        {
            Caption = 'Individual Score';
            DataClassification = ToBeClassified;
        }
        field(50020; "Account Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Total Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Qualify Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Monthly Contribution"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Shares Banding"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Existing Member"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50027; "Status"; Enum "MemberStatus")
        {
            DataClassification = CustomerContent;
        }
        field(50028; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory";
            Editable = false;
        }
        field(50029; "Shares Deposits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "School Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        

    }
    keys
    {
        key("PK"; "Account No.")
        {
            Clustered = true;
        }
    }
}



