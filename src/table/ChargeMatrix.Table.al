table 50591 "Charge Matrix"
{
    Caption = 'Charge Matrix';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(50010; "Banking A/c (Balance Enquiry)"; Boolean)
        {
            Caption = 'Charge Banking A/c (Balance Enquiry)';
            DataClassification = CustomerContent;
        }
        field(50011; "Credit A/c (Balance Equiry)"; Boolean)
        {
            Caption = 'Charge Credit A/c (Balance Equiry)';
            DataClassification = CustomerContent;
        }
        field(50012; "Charge Account Withdrawals"; Boolean)
        {
            Caption = 'Charge Account Withdrawals';
            DataClassification = CustomerContent;
        }
        field(50013; "Mini-Statement (Banking)"; Boolean)
        {
            Caption = 'Charge Mini-Statement (Banking)';
            DataClassification = CustomerContent;
        }
        field(50014; "Charge Mini-Statement (Credit)"; Boolean)
        {
            Caption = 'Charge Mini-Statement (Credit)';
            DataClassification = CustomerContent;
        }
        field(50015; "Charge Full- Statement"; Boolean)
        {
            Caption = 'Charge Full- Statement';
            DataClassification = CustomerContent;
        }
        field(50016; "Posting A/c"; Code[100])
        {
            Caption = 'Posting Account';
            TableRelation = "Banking User Template"."Account ID" where("Account Type" = filter("Automated Posting"));
            DataClassification = CustomerContent;
        }
        field(50017; "Charge A/c Transfer"; Boolean)
        {
            Caption = 'Charge Account Transfer';
            DataClassification = CustomerContent;
        }
    field(50018; "Charge A/c Deposit"; Boolean)
        {
            Caption = 'Charge Account Deposits';
            DataClassification = CustomerContent;
        }
    field(50019; "Charge Utilities"; Boolean)
        {
            Caption = 'Charge Untilities';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Primary Key")
        {
            Clustered = true;
        }
    }
}
