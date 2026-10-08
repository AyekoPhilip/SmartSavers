page 50063 "Product List Temp."
{
    ApplicationArea = All;
    Caption = 'Product List Temp.';
    PageType = List;
    SourceTable = "Product Factory Temp.";
    UsageCategory = Lists;
    CardPageId = "Product Factory Temp.";
    Editable=false;
    DeleteAllowed=false;
    InsertAllowed=false;
    ModifyAllowed=false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product ID field.';
                }
                field("Product Class"; Rec."Product Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Class field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
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



