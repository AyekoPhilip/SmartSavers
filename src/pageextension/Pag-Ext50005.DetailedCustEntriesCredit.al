pageextension 50005 "Detailed.Cust Entries-Credit" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            
            field("Transaction Type";Rec."Transaction Type")
            {
                ToolTip = 'Specifies the value of the Transaction Type.';
                ApplicationArea = All;

            }
            field("Loan No.";Rec."Loan No.")
            {
                ToolTip = 'Specifies the value of the Loan No.';
                ApplicationArea = All;

            }
        }

    }
}



