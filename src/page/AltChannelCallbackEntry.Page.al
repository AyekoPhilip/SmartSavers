page 50022 "Alt.Channel Callback Entry"
{
    ApplicationArea = All;
    Caption = 'Alt.Channel Callback Entry';
    PageType = List;
    SourceTable = "Alt. Channel Entry";
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
                field("Trace ID"; Rec."Trace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trace ID field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field("Account No.(Credit)"; Rec."Account No.(Credit)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No.(Credit) field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
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
                field("Customer Names"; Rec."Customer Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Names field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Reversal Trace ID"; Rec."Reversal Trace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversal Trace ID field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
                field("Reversed Posted"; Rec."Reversed Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed Posted field.';
                }
                field("Search Code"; Rec."Search Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Search Code field.';
                }
                field("Transaction Charge Code"; Rec."Transaction Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Charge Code field.';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Description field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Transaction Type Charges"; Rec."Transaction Type Charges")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type Charges field.';
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit ID field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field("Reference No"; Rec."Reference No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference No field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source field.';
                }
            }
        }
    }
}



