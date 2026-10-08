table 50315 "Contribution-Changes"
{
    Caption = 'Contribution-Changes';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Account No."; Code[50])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Type"; Enum "ProductAccountCategory")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        field(50011; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        
            trigger OnValidate()
            begin
                "Amount Off" := xRec.Amount
            end;
        }
        field(50012; "Remarks"; Text[150])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(50013; "Application No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = if (Type = filter("Shares Capital" | "Shares Deposit" | "Registration Fee")) "Account Credit"."No." where("Member No." = field("Account No."), "Account Category" = field(Type)) else
            if
           (Type = filter(Savings | "Specialty Savings" | "Women Savings" | Junior | "Certificates of Deposit")) "Account Banking"."No." where("Member No." = field("Account No."), "Account Category" = field(Type)) else
            if
           (Type = const(" ")) Loans."No." where("Outstanding Balance" = filter(> 0), "Account No." = field("Account No."));
        
            trigger OnValidate()
            var
                ProductFac: Record "Product Factory";
                AccCredit: Record "Account Credit";
                AccBank: Record "Account Banking";
                Loans: Record Loans;
            begin
                case Type of
                    Type::"Certificates of Deposit",
                Type::Savings,
                Type::"Money Market",
                Type::"Specialty Savings",
                Type::"Women Savings",
                Type::Repayment,
                Type::"Benevolent Fund":
                        Error('Selected Option not application');
                end;
            end;
        }
        field(50014; "Amount Off"; Decimal)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50015; "Advise Type"; Enum "AdviseType")
        {
            Caption = 'Advise Type';
        }
        field(50016; "Entry No."; Code[50])
        {

        }
        field(50017; "Application Type"; Option)
        {
            OptionMembers = "New Application","Changes";
        }
    }
    keys
    {
        key("PK"; "Account No.", "Type", "Application No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}



