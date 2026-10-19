page 50261 "Savings Interest Buffer"
{
    Caption = 'Savings Interest Buffer';
    PageType = ListPart;
    SourceTable = "Savings Interest Buffer";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Interest Date"; Rec."Interest Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Date field.';
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Amount field.';
                }

                field("Account Balance"; Rec."Account Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Balance field.';
                }

                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }

                field("Expense Account"; Rec."Expense Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Account field.';
                }
                field("Payable Account"; Rec."Payable Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payable Account field.';
                }

                field("Product Factory Code"; Rec."Product Factory Code")
                {
                    ApplicationArea = All;
                    Caption = 'Product Type';
                    ToolTip = 'Specifies the value of the Product Factory Code field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                }

            }
        }
    }
}



