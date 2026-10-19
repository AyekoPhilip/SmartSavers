pageextension 50046 "CustomerMember" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Member No."; Rec."Member No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Member No. field';
            }
            field("ID No."; Rec."ID No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ID No. field';
            }
            field("Product Type"; Rec."Product Type")
            {
                ApplicationArea = All;
                Caption = 'Product Type';
                ToolTip = 'Specifies the value of the Product Type field';
            }
            field("Account Type"; Rec."Account Type")
            {
                ApplicationArea = All;
                Caption = 'Account Type';
                ToolTip = 'Specifies the value of the Account Type field';
            }
            field("Account Category"; Rec."Account Category")
            {
                ApplicationArea = All;
                Caption = 'Account Category';
                ToolTip = 'Specifies the value of the Account Category field';
            }
            field("Account Dimension"; Rec."Account Dimension")
            {
                ApplicationArea = All;
                Caption = 'Account Dimension';
                ToolTip = 'Specifies the value of the Account Dimension field';

            }


        }
    }
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Product Type", '');
        Rec.FilterGroup(0)
    end;
}



