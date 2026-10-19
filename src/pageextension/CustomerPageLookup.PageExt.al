pageextension 50047 "CustomerPageLookup" extends "Customer Lookup"
{
    Editable = false;
    layout
    {
        addafter(Name)
        {
            field("Member No."; Rec."Member No.")
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'Member No.';
                ToolTip = 'Specifies the different account types of customers';
            }
            field("ID No."; Rec."ID No.")
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'ID No.';
                ToolTip = 'Specifies the different account types of customers';

            }
            field("Product Type"; Rec."Product Type")
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'Product Type';
                ToolTip = 'Specifies the different account types of customers';
            }
            field("Account Type"; Rec."Account Type")
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'Account Type';
                ToolTip = 'Specifies the different account types of customers';

            }
            field("Account Category"; Rec."Account Category")
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'Account Category';
                ToolTip = 'Specifies the different account types of customers';

            }
            field("Account Dimension"; Rec."Account Dimension")
            {
                Editable = false;
                Caption = 'Account Dimension';
                ApplicationArea = All;
                ToolTip = 'Specifies the different account types of customers';
            }
        }
    }
}



