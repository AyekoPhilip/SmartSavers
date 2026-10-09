table 50323 "Mobile Application Line"
{
    Caption = 'Mobile Application Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(50011; "Account Type"; Enum "CreditAccountTypes")
        {
            Caption = 'Account Type';
        }
        field(50012; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Savings)) "Account Banking"."No." where(Status = const(Active), "Account Category" = const(Savings), Blocked = const(" "));
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Account: Record "Account Banking";
            begin
                if Account.Get("Account No.") then
                    Description := Account.Name;
            end;
        }
        field(50013; "Description"; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }



    }
    keys
    {
        key("PK"; "No.", "Account No.")
        {
            Clustered = true;
        }
    }
}



