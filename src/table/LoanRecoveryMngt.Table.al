table 50324 "Loan Recovery Mngt."
{
    Caption = 'Loan Recovery Mngt.';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Account Name"; Text[150])
        {
            Caption = 'Account Name';
            DataClassification = ToBeClassified;
        }
        field(50012; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            DataClassification = ToBeClassified;
        }
        field(50013; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = ToBeClassified;
        }
        field(50014; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
            DataClassification = ToBeClassified;
        }
        field(50015; "Shares Deposit"; Decimal)
        {
            Caption = 'Shares Deposit';
            DataClassification = ToBeClassified;
        }
        field(50016; "Shares Deducted"; Decimal)
        {
            Caption = 'Shares Deducted';
            DataClassification = ToBeClassified;
        }
        field(50017; "Recovery Type"; Option)
        {
            Caption = 'Recovery Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Shares","Guarantors","Banking";
        }
        field(50018; "Date Posted"; Date)
        {
            Caption = 'Date Posted';
            DataClassification = ToBeClassified;
        }
        field(50019; "Posted By"; Code[100])
        {
            Caption = 'Posted By';
            DataClassification = ToBeClassified;
        }
        field(50020; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            DataClassification = ToBeClassified;
        }
        field(50021; "Outstanding Interest"; Decimal)
        {
            Caption = 'Outstanding Interest';
            DataClassification = ToBeClassified;
        }
        field(50022; "Outstanding Principal"; Decimal)
        {
            Caption = 'Outstanding Principal';
            DataClassification = ToBeClassified;
        }
        field(50023; "Member No."; Code[100])
        {
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            var
                Cust: Record Member;
            begin
                if Cust.Get("Member No.") then
                    "Account Name" := Cust.Name;

            end;
        }
        field(50024; "Haeder No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key("PK"; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Rec."Date Posted" := Today;
        Rec."Posted By" := UserId;

    end;
}



