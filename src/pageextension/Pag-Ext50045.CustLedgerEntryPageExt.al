pageextension 50045 "CustLedgerEntryPageExt" extends "Customer Ledger Entries"
{
    Editable=false;
    layout
    {
        addlast(Control1)
        {
            field("Loan No"; Rec."Payroll Loan No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan No field';
            }
          
            field("Period Reference"; Rec."Period Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Period Reference field';
            }
            field("Extra Payment"; Rec."Extra Payment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Extra Payment field';
            }
            field("Member No."; Rec."Member No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the member field';

            }
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of Transaction Type field';

            }
            field("Loan No."; Rec."Loan No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of loan field';

            }
        }
    }
}


