page 50960 "Account Transfer-Approved"
{
    ApplicationArea = All;
    Caption = 'Account Transfer-Approved';
    PageType = List;
    CardPageId = "Account Transfer";
    SourceTable = "Account Transfer Header";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where(Status = filter(Approved), Posted = const(false));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Time field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Type field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }
}



