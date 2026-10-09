table 50356 "Default Accounts Application"
{
    DataClassification = CustomerContent;


    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Product Type"; Code[10])
        {
            TableRelation = "Product Factory" WHERE("Product Class" = CONST(Account),
                                                     Status = CONST(Active));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ProductFactory.Get("Product Type") then
                    "Product Name" := ProductFactory.Description;
                "Monthly Contribution" := ProductFactory."Minimum Contribution";
                "Account Category" := ProductFactory."Account Category";
            end;
        }
        field(50011; "Product Name"; Text[100])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = CustomerContent;
        }
        field(50013; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
        field(50014; "Loan Disbursement A/c"; Boolean)
        {
            Editable = false;
            Caption = 'Loan Disbursement A/c';
            DataClassification = CustomerContent;
        }
        field(50015; "Account Source"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Source';
        }
    }

    keys
    {
        key("Key1"; "No.", "Product Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ProductFactory: Record "Product Factory";
}




