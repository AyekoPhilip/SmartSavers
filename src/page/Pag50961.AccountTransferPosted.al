page 50961 "Account Transfer-Posted"
{
    ApplicationArea = All;
    Caption = 'Account Transfer-Posted';
    PageType = List;
    CardPageId = "Account Transfer";
    SourceTable = "Account Transfer Header";
    UsageCategory = History;
    SourceTableView = where(Posted = const(true));

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
                field("Total Debits"; Rec."Total Debits")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Debits field.';
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



