page 50030 "ATM Transactions"
{
    ApplicationArea = All;
    Caption = 'ATM Transactions';
    PageType = List;
    SourceTable = "ATM Transaction";
    UsageCategory = Lists;
    DeleteAllowed=false;
    ModifyAllowed=false;
    InsertAllowed=false;
    Editable=false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                 field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit ID field.';
                }
               
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field("Account No.(Credit)"; Rec."Account No.(Credit)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account to credit field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Card Acceptor Terminal ID"; Rec."Card Acceptor Terminal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card Acceptor Terminal ID field.';
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
                field("Error Log"; Rec."Error Log")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Error Log field.';
                }
                field("Is Coop Bank"; Rec."Is Coop Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Coop Bank field.';
                }
                field("POS Vendor"; Rec."POS Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POS Vendor field.';
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
                field(Postings; Rec.Postings)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Postings field.';
                }
                field("Process Code"; Rec."Process Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Process Code field.';
                }
                field("Reference No"; Rec."Reference No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reference No field.';
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
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field("Trace ID"; Rec."Trace ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trace ID field.';
                }
                field("Trans Time"; Rec."Trans Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Trans Time field.';
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
               
            }
        }
    }
}



