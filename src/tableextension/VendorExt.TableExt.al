tableextension 50045 "VendorExt" extends Vendor
{


    fields
    {
        field(50009; "KRA PIN"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PIN';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Vendor Type"; Enum "Vendor Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Type';
        }
        field(50011; "Sort Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Sort Code';
        }
        field(50012; "Vendor Bank Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Banks;
            Caption = 'Vendor Bank Code';
        
            trigger OnValidate()
            begin
                if Banks.Get("Vendor Bank Code") then
                    "Vendor Bank Code Name" := banks.Name;
            end;
        }
        field(50013; "Vendor Bank Branch Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Branches"."Branch Code" where("Bank Code" = field("Vendor Bank Code"));
            Caption = 'Vendor Bank Branch Code';
        
            trigger OnValidate()
            begin
                if BankBranches.Get("Vendor Bank Code", "Vendor Bank Branch Code") then
                    "Vendor Bank Branch Name" := BankBranches."Branch Name";
            end;
        }
        field(50014; "Vendor Bank Account No"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Bank Account No';
        }
        field(50015; "NSSF Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'NSSF Number';
        }
        field(50016; "Vendor Swift Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Swift Code';
        }
        field(50017; "Vendor Bank Code Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Bank Code Name';
        }
        field(50018; "Vendor Bank Branch Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Bank Branch Name';
        }
        field(50019; "PIN Certificate Expiry"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'PIN Certificate Expiry';
        }
        field(50020; "Staff No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            Caption = 'Staff No.';
        }
        field(50021; "Prospective No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Prospective No.';
        }
        field(50022; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(50023; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            Editable = false;
        }
        field(50024; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            Editable = false;
        }

        field(50025; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            Editable = false;
        }
        field(50026; "Account Category"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Category';
            Editable = false;
        }
        field(50027; "Account Type"; Option)
        {
            Caption = 'Account Type';
            Editable = false;
            OptionCaption = ' ,Banking,Others';
            OptionMembers = " ","Banking","Others";
        }
        field(50028; "Net Balance"; Decimal)
        {

            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = field("No."),
                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                         "Posting Date" = FIELD("Date Filter")));

            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;

        }

    }
    keys
    {
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        BankBranches: Record "Bank Branches";
        Banks: Record Banks;
}


