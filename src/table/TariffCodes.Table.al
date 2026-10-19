table 50345 "Tariff Codes"
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
        field(50011; "Percentage"; Decimal)
        {
            Caption = 'Percentage';
            DataClassification = CustomerContent;
        }
         field(50012; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where(Blocked = const(false))
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset" where(Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer where(Blocked = const(" "))
            else
            if ("Account Type" = const("Bank Account")) "Bank Account" where(Blocked = const(false))
            else
            if ("Account Type" = const(Vendor)) Vendor;
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "To Use"; Option)
        {
            OptionCaption = ' ,Percentage,Amount';
            OptionMembers = " ","Percentage","Amount";
            Caption = 'To Use';
            DataClassification = CustomerContent;
        }
         field(50015; "Account Type"; Enum "Gen. Journal Account Type")
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
}




