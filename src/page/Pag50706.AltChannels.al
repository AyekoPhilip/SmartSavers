page 50706 "Alt. Channels"
{
    ApplicationArea = All;
    Caption = 'Alt. Channels';
    PageType = List;
    SourceTable = "ATM Transaction";
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
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field("Trace ID"; Rec."Trace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trace ID field.';
                }
                field("Reference No"; Rec."Reference No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference No field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';

                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field("Account No.(Credit)"; Rec."Account No.(Credit)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account to credit field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
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

                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                }
                field("Terminal Source Charge"; Rec."Terminal Source Charge")
                {
                    ApplicationArea = All;
                }
                field("Transaction Charge Code"; Rec."Transaction Charge Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Charge Code field.';
                }

                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Description field.';
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
                field("Transaction Type Charges"; Rec."Transaction Type Charges")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type Charges field.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Search Code"; Rec."Search Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';

                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversed field.';

                }
                field("Reversal Trace ID"; Rec."Reversal Trace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reversal Trace ID field.';

                }

            }
        }
         area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
}



