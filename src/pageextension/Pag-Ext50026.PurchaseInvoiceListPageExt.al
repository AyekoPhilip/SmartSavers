pageextension 50026 "Purchase Invoice List PageExt" extends "Purchase Invoices"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Description field';
            }
        }
    }
}


