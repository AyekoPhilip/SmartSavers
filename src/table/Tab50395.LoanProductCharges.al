table 50395 "Loan Product Charges"
{
    DrillDownPageID = "Loan Product Charges";
    LookupPageID = "Loan Product Charges";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Charge Code"; Code[20])
        {
            TableRelation = "Loan Charges"."Charge Code";
            Caption = 'Charge Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if LoanChg.Get("Charge Code") then begin
                    "Charge Description" := LoanChg."Charge Description";
                    "Charge Amount" := LoanChg."Charge Amount";
                    "Charge Method" := LoanChg."Charge Method";
                    Percentage := LoanChg.Percentage;
                    "Charging Option" := LoanChg."Charging Option";
                    "Use Percentage" := LoanChg."Use Percentage";
                    if LoanChg."Use Percentage" then
                        "Charge Method" := "Charge Method"::"% of Amount";
                    "Charge Type" := LoanChg."Charge Type";
                    Percentage := LoanChg.Percentage;
                    "Account Type" := LoanChg."Account Type";
                    "Charges Account" := LoanChg."Charges Account";
                    Maximum := LoanChg.Maximum;
                    Minimum := LoanChg.Minimum;
                    "Staggered Charge Code" := LoanChg."Staggered Charge Code"
                end;
            end;
        }
        field(50010; "Charge Description"; Text[70])
        {
            Editable = false;
            Caption = 'Charge Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Charge Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Charge Amount';
            DataClassification = CustomerContent;
        }
        field(50012; "Use Percentage"; Boolean)
        {
            Editable = false;
            Enabled = true;
            Caption = 'Use Percentage';
            DataClassification = CustomerContent;
        }
        field(50013; "Percentage"; Decimal)
        {
            Editable = false;
            Caption = 'Percentage';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Use Percentage", true);
                "Charge Method" := "Charge Method"::"% of Amount";
            end;
        }
        field(50014; "Charge Type"; Enum "ChargeType")
        {
            Editable = true;
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
        }
        field(50015; "Charging Option"; Enum "LoanChargeOptions")
        {
            Caption = 'Charging Option';
            DataClassification = CustomerContent;
        }
        field(50016; "Product Code"; Code[20])
        {
            Editable = false;
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50017; "Charges Account"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"."No."
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"."No."
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee."No."
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner".Code;
            Caption = 'Charges Account';
            DataClassification = CustomerContent;
        }
        field(50018; "Minimum"; Decimal)
        {
            Caption = 'Minimum';
            DataClassification = CustomerContent;
        }
        field(50019; "Maximum"; Decimal)
        {
            Caption = 'Maximum';
            DataClassification = CustomerContent;
        }
        field(50020; "Additional Charge %"; Decimal)
        {
            Caption = 'Additional Charge %';
            DataClassification = CustomerContent;
        }
        field(50021; "Effect Excise Duty"; Option)
        {
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = "No","Yes";
            Caption = 'Effect Excise Duty';
            DataClassification = CustomerContent;
        }
        field(50022; "Prorate"; Option)
        {
            OptionCaption = ' ,Appraisal,Insurance,Fee';
            OptionMembers = " ","Appraisal","Insurance","Fee";
            Caption = 'Prorate';
            DataClassification = CustomerContent;
        }
        field(50023; "Charge Method"; Enum "ProductChargeMethod")
        {
            Caption = 'Charge Method';
            DataClassification = CustomerContent;
        }
        field(50024; "Staggered Charge Code"; Code[20])
        {
            TableRelation = "Tiered Charges Header";
            Caption = 'Staggered Charge Code';
            DataClassification = CustomerContent;
        }
        field(50025; "Loan No."; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan No.';
        }
        field(50026; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Charge Code", "Product Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // if fnCheckOnValidation then
        //    Error(UnsupportedRecordTypeErr)
    end;

    trigger OnModify()
    begin
        //  if fnCheckOnValidation then
        //     Error(UnsupportedRecordTypeErr)
    end;

    trigger OnRename()
    begin
        // if fnCheckOnValidation then
        //     Error(UnsupportedRecordTypeErr)
    end;

    var
        LoanChg: Record "Loan Charges";
        UnsupportedRecordTypeErr: Label 'You cannot Edit,Delete or Rename this record as associated product %1 has an active status.';


    procedure fnCheckOnValidation(): Boolean
    var
        PFact: Record "Product Factory";
    begin
        PFact.Reset;
        PFact.SetRange("Product ID", "Product Code");
        if PFact.Find('-') then begin
            if PFact.Status = PFact.Status::Open then
                exit(true) else
                exit(false)
        end
    end;
}




