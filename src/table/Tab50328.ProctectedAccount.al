table 50328 "Proctected Account"
{
    Caption = 'Proctected Account';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(50010; "Account No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Account Banking";
        }
        field(50011; "Member No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
            TableRelation = Member;
        }
        field(50012; "Restrict Viewship (Balance)"; Boolean)
        {
            Caption = 'Restrict Viewship (Balance)';
            DataClassification = ToBeClassified;
        }
        field(50013; "Restrict Viewship (Statement)"; Boolean)
        {
            Caption = 'Restrict Viewship (Statement)';
            DataClassification = ToBeClassified;
        }
        field(50014; "Restrcit Viewship (Record)"; Boolean)
        {
            Caption = 'Restrcit Viewship (Record)';
            DataClassification = ToBeClassified;
        }
        field(50015; "Restrict Viewship (ATM Card)"; Boolean)
        {
            Caption = 'Restrict Viewship (Account Card)';
            DataClassification = ToBeClassified;
        }
        field(50016; "Restrict Viewship (Mobile No.)"; Boolean)
        {
            Caption = 'Restrict Viewship (Transactional Mobile No.)';
            DataClassification = ToBeClassified;
        }

    
        field(50017; "Mobile Transaction"; Enum "ProtectedMobTransaction")
        {

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



