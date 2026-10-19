pageextension 50041 "Gen Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        modify("G/L Account Name")
        {
            Visible = true;
        }
        addafter("Entry No.")
        {
            field("Transaction Type"; Rec."Transaction Type")
            {
                ToolTip = 'Specifies the value of the Transaction Type field.';
                ApplicationArea = All;
            }
            field("Loan No."; Rec."Loan No.")
            {
                ToolTip = 'Specifies the value of the Loan No. field.';
                ApplicationArea = All;
            }
            field("Product Type"; Rec."Product Type")
            {
                ToolTip = 'Specifies the value of the Product Type field.';
                ApplicationArea = All;
            }
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
            }
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = All;
            }
            field("Fixed Asset Number"; Rec."Fixed Asset Number")
            {
                ApplicationArea = All;
            }

        }

    }



}











