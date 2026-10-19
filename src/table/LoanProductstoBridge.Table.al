table 50505 "Loan Products to Bridge"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            TableRelation = "Product Factory";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Product To Bridge"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class" = CONST(Loan));
            Caption = 'Product To Bridge';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ProdFac.Get("Product To Bridge") then
                    "Product Name" := ProdFac.Description;
            end;
        }
        field(50011; "Product Name"; Text[100])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Refinance %"; Decimal)
        {
            Caption = 'Refinance %';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Product Code", "Product To Bridge")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ProdFac: Record "Product Factory";
}




