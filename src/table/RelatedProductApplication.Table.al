table 50511 "Related Product Application"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Product Code"; Code[10])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Related Product Code"; Code[10])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Related Product Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Product.Get("Related Product Code") then
                    "Related Product Desc" := Product.Description;
            end;
        }
        field(50011; "Related Product Desc"; Text[100])
        {
            Caption = 'Related Product Desc';
            DataClassification = CustomerContent;
        }
        field(50012; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Entry No."; Integer)
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
        Product: Record "Product Factory";
}




