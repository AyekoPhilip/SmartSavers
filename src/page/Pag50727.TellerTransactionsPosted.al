page 50727 "Teller Transactions-Posted"
{
    CardPageID = "Teller Transaction";
    ApplicationArea = All;
    Caption = 'Teller Transactions-Posted';
    PageType = List;
    SourceTable = "Teller Transaction";
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    SourceTableView = WHERE(Posted = CONST(true));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Till Code"; Rec."Till Code")
                {
                    ToolTip = 'Specifies the value of the Till Code field.';
                    ApplicationArea = All;
                }
                field("Till Name"; Rec."Till Name")
                {
                    ToolTip = 'Specifies the value of the Till Name field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                    ApplicationArea = All;
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ToolTip = 'Specifies the value of the Transaction Description field.';
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;

                }
               
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Cashier; Rec.Cashier)
                {
                    ToolTip = 'Specifies the value of the Cashier field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}



