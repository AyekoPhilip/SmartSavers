pageextension 50056 "Posted Purch Invoices Ext" extends "Posted Purchase Invoices"
{
    layout
    {
        addbefore("Currency Code")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Description field.';
                Editable = false;
            }
        }
    }
}



