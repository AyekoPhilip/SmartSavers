page 50062 "Product Factory Temp."
{
    Caption = 'Product Factory Temp.';
    PageType = Card;
    SourceTable = "Product Factory Temp.";
    DeleteAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product ID field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Product Class"; Rec."Product Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Class field.';
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Category field.';
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Dimension field.';
                }
            }
        }
    }
}



