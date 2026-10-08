pageextension 50019 "CustomerAccountType" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("Account Type"; Rec."Account Type")
            {
                Editable = true;
                ApplicationArea = All;
                ToolTip = 'Specifies the different account types of customers';
            }
        }
    }
}



