pageextension 50036 "CustomerBankAccountPageExt" extends "Customer Bank Account Card"
{
    layout
    {
        addafter("Bank Branch No.")
        {
            field("Bank Branch Name"; Rec."Bank Branch Name")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Branch Name field';
            }
        }
    }
}


