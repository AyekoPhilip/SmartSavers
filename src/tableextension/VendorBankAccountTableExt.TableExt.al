tableextension 50001 "VendorBankAccountTableExt" extends "Vendor Bank Account"
{
    fields
    {
        modify(Code)
        {
            TableRelation = Banks;
            Caption = 'Bank Code';

            trigger OnAfterValidate()
            begin
                if Banks.Get(Code) then begin
                    "Bank Name" := Banks.Name;
                    Name := Banks.Name;
                end;
            end;
        }
        modify("Bank Branch No.")
        {
            TableRelation = "Bank Branches"."Branch Code" where("Bank Code" = field(Code));
            trigger OnAfterValidate()
            begin
                if BankBranches.Get(Code, "Bank Branch No.") then
                    "Bank Branch Name" := BankBranches."Branch Name";
            end;
        }
        field(50009; "Bank Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Name';
        }
        field(50010; "Bank Branch Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Branch Name';
        }
    }

    var
        BankBranches: Record "Bank Branches";
        Banks: Record Banks;
}


