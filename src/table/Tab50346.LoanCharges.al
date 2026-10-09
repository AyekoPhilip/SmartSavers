table 50346 "Loan Charges"
{
    DrillDownPageID = "Loan Charges";
    LookupPageID = "Loan Charges";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Charge Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Code';
        
            trigger OnValidate()
            var
                LoanChg: Record "Loan Charges";
            begin

            end;
        }
        field(50010; "Charge Description"; Text[70])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Charge Description';
        }
        field(50011; "Charge Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Amount';
        }
        field(50012; "Use Percentage"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Use Percentage';
        }
        field(50013; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Percentage';
        }
        field(50014; "Charge Type"; Enum "ChargeType")
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Charge Type';
        }
        field(50015; "Charging Option"; Enum "LoanChargeOptions")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Charging Option';
        }
        field(50016; "Product Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Code';
        }
        field(50017; "Charges Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No." where("Account Type" = filter(" "))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"."No."
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"."No."
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee."No."
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner".Code;
            Caption = 'Charges Account';
        }
        field(50018; "Minimum"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum';
        }
        field(50019; "Maximum"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum';
        }
        field(50020; "Additional Charge %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Charge %';
        }
        field(50021; "Effect Excise Duty"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'No,Yes';
            OptionMembers = "No","Yes";
            Caption = 'Effect Excise Duty';
        }
        field(50022; "Prorate"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Appraisal,Insurance';
            OptionMembers = " ","Appraisal","Insurance";
            Caption = 'Prorate';
        }
        field(50023; "Charge Method"; Enum "ProductChargeMethod")
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Method';
        }
        field(50024; "Staggered Charge Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Tiered Charges Header";
            Caption = 'Staggered Charge Code';
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
        field(50027; "Charged on Loan Restructure"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Charged on Loan Restructure';
        }
    }

    keys
    {
        key("Key1"; "Charge Code")
        {
            Clustered = true;
        }
        key("Key2"; "Additional Charge %")
        {

        }
    }

    fieldgroups
    {
    }
}




