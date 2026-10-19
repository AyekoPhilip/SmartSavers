page 50005 "Transaction Charges Log"
{
    ApplicationArea = All;
    Caption = 'Transaction Charges Log';
    PageType = List;
    SourceTable = "Transaction Charge";
    UsageCategory = Lists;
    Editable=false;
    ModifyAllowed=false;
    DeleteAllowed=false;
    InsertAllowed=false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account Closure"; Rec."Account Closure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Closure field.';
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Amount field.';
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Code field.';
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Amount field.';
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Amount field.';
                }
                field("Percentage of Amount"; Rec."Percentage of Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage of Amount field.';
                }
                field("Recover Excise Duty"; Rec."Recover Excise Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recover Excise Duty field.';
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staggered Charge Code field.';
                }
                field("Transaction Charge Category"; Rec."Transaction Charge Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Charge Category field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
            }
        }
    }
}



