table 50512 "Loan Product Charge Appl."
{
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
                    "Use Percentage" := LoanChg."Use Percentage";
                    Percentage := LoanChg.Percentage;
                    "Charging Option" := LoanChg."Charging Option";

                end;
            end;
        }
        field(50010; "Charge Description"; Text[70])
        {
            Caption = 'Charge Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Charge Amount"; Decimal)
        {
            Caption = 'Charge Amount';
            DataClassification = CustomerContent;
        }
        field(50012; "Use Percentage"; Boolean)
        {
            Caption = 'Use Percentage';
            DataClassification = CustomerContent;
        }
        field(50013; "Percentage"; Decimal)
        {
            Caption = 'Percentage';
            DataClassification = CustomerContent;
        }
        field(50014; "Charge Type"; Option)
        {
            OptionCaption = 'General,Top up,External Loan,Boosting';
            OptionMembers = "General","Top up","External Loan","Boosting";
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
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50017; "Charges G_L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Charges G_L Account';
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
        field(50020; "Additional Conditional Charge"; Decimal)
        {
            Caption = 'Additional Conditional Charge';
            DataClassification = CustomerContent;
        }
        field(50021; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50022; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Document No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LoanChg: Record "Loan Charges";
}




