page 50423 "Fixed Deposit History"
{
    ApplicationArea = All;
    Caption = 'Fixed Deposit History';
    PageType = List;
    SourceTable = "Fixed Deposit History";
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("FD Duration"; Rec."FD Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FD Duration field.';
                }
                field("FD Maturity Date"; Rec."FD Maturity Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FD Maturity Date field.';
                }
                field("FD Maturity Instructions"; Rec."FD Maturity Instructions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FD Maturity Instructions field.';
                }
                field("Fixed Deposit Type"; Rec."Fixed Deposit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fixed Deposit Type field.';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field.';
                }
                field("Fixed Amount"; Rec."Fixed Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fixed Amount field.';
                }
                field("Interest Earned"; Rec."Interest Earned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Interest Earned field.';
                }
                field("Neg. Interest Rate"; Rec."Neg. Interest Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Neg. Interest Rate field.';
                }
            }
        }
    }
}



