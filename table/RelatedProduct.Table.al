table 50410 "Related Product"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Product Code"; Code[10])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Code';
            Editable = false;
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
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50012; "Refinance %"; Decimal)
        {
            Caption = 'Refinancing %';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Product Code", "Related Product Code")
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




