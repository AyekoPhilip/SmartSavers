page 50294 "Loan Calculator List"
{
    ApplicationArea = All;
    Caption = 'Loan Calculator List';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Calculator";
    CardPageId = "Loan Calculator Page";
    SourceTableView = where("Application Type" = const("Loan Calculator"));
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Description field.';
                }
            }
        }
    }
}



