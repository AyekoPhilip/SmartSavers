table 50414 "Transaction Types"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(50010; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50011; "Type"; Enum "TellerTypes")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID" WHERE("Product Class" = CONST(Account));
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
            begin
                if ProductFactory.Get("Product Type") then
                    "Product Name" := ProductFactory.Description;
            end;
        }
        field(50013; "Default Mode"; Option)
        {
            OptionCaption = 'Cash,Cheque';
            OptionMembers = "Cash","Cheque";
            Caption = 'Default Mode';
            DataClassification = CustomerContent;
        }
        field(50014; "Requires Finger Verification"; Boolean)
        {
            Caption = 'Requires Finger Verification';
            DataClassification = CustomerContent;
        }
        field(50015; "Product Name"; Text[50])
        {
            Editable = false;
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50016; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
            DataClassification = CustomerContent;
        }
        field(50017; "Category"; Option)
        {
            OptionCaption = ' ,Cashier,Loans';
            OptionMembers = " ","Cashier","Loan";
            Caption = 'Category';
            DataClassification = CustomerContent;
        }
        field(50018; "Blocked"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnInsert()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnModify()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnRename()
    begin
        RestrictAccess(UserId)
    end;


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




