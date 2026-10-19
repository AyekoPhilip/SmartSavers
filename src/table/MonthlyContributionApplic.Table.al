table 50303 "Monthly Contribution Applic."
{
    Caption = 'Monthly Contribution Applic.';
    DataClassification = ToBeClassified;
    LookupPageId = "Contributions LooakUp Page";
    DrillDownPageId = "Contributions LooakUp Page";

    fields
    {
        field(50009; "Account No."; Code[50])
        {
            Caption = 'No.';
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
            TableRelation = if (Type = filter("Shares Capital" | "Shares Deposit" | "Registration Fee")) "Account Credit"."No." else
            if
           (Type = filter(Savings | "Specialty Savings" | "Women Savings" | Junior | "Certificates of Deposit")) "Account Banking"."No." else
            if
           (Type = const(" ")) Loans."No." where("Outstanding Balance" = filter(> 0)) else
            if
           (Type = const(KinAccount)) "Account Credit";
        
            trigger OnValidate()
            var
                ProductFac: Record "Product Factory";
                AccCredit: Record "Account Credit";
                AccBank: Record "Account Banking";
                Loans: Record Loans;
            begin

                if AccBank.Get("Application No.") then begin
                    Type := AccBank."Account Category";
                end;
                if AccCredit.Get("Application No.") then begin
                    Type := AccCredit."Account Category"
                end;
                if Loans.Get("Application No.") then begin
                    Type := Type::" ";
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



