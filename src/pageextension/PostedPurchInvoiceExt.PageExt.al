pageextension 50055 "Posted Purch Invoice Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addbefore("Posting Date")
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



