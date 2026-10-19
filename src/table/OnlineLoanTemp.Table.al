table 50598 "Online Loan Temp."
{
    Caption = 'Online Loan Temp.';
    DataClassification = CustomerContent;

    fields
    {
        
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(50010; "API Code"; Code[100])
        {
            Caption = 'API Code';
        }
        field(50011; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            TableRelation = "Product Factory";
        }
        field(50012; "Requested Amount"; Decimal)
        {
            Caption = 'Requested Amount';
        }
        field(50013; "Member  No."; Code[100])
        {
            Caption = 'Member  No.';
            TableRelation = Member;
        }
        field(50014; "Account No. (Guarantor)"; Code[100])
        {
            Caption = 'Account No. (Guarantor)';
            TableRelation = "Account Credit";
        }
        field(50015; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
        }
        field(50016; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
        }
        field(50017; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50018; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("PK"; "Entry No.", "API Code")
        {
            Clustered = true;
        }
    }
}
