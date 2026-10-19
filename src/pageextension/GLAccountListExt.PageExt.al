pageextension 50042 "GLAccountListExt" extends "G/L Account List"
{
    layout
    {
        addlast(Control1)
        {
            field("Account Subcategory Descript."; Rec."Account Subcategory Descript.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account Subcategory Descript. field';
            }
        }
    }
}


