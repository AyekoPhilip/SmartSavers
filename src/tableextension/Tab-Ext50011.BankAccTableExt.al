tableextension 50011 "BankAccTableExt" extends "Bank Account"
{
    fields
    {
        field(50009; "Bank Type"; Enum "BankTypes")
        {
            DataClassification = CustomerContent;
        }
        field(50010; "CashierID"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(50011; "Address 4"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Address 5"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Narration"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value" where("Global Dimension No." = const(3));
            CaptionClass = '1,2,3';
            DataClassification = CustomerContent;
        }
        field(50015; "Sort Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Check Bank Limit"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Bank Limit (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
         field(50018; "Responsibility Centre"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
        }
        field(50019;"Reconciliation Type";Option)
        {
            OptionMembers=" ",Manual;
        }
        field(50020;"Previous Statement No.";Code[20])
        {
            DataClassification = CustomerContent;
        }
    }
}


