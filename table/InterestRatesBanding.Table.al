table 50532 "Interest Rates Banding"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Interest Banding";
    LookupPageId = "Interest Banding";
    Caption = 'Tiered Rates and Installment';
    fields
    {
        field(50009; "Product ID"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory"."Product ID";
            Editable = false;
            Caption = 'Product ID';
        }
        field(50010; "Lower Period"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Lower Period';
        }
        field(50011; "Upper Period"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Upper Period';
        }
        field(50012; "Interest Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Interest Rate';
        }
        field(50013; "Min. Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Max. Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50015; "Installment"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Tier Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Interest Rate","Installment";
            Editable = false;
        }
    }

    keys
    {
        key("Key1"; "Product ID", "Lower Period", "Upper Period", "Max. Limit", "Min. Limit", "Tier Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




