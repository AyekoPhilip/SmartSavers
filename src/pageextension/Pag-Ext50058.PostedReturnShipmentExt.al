pageextension 50058 "Posted Return Shipment Ext" extends "Posted Return Shipment"
{
    layout
    {
        addafter("No. Printed")
        {
            field("Cancel Comments"; Rec."Cancel Comments")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cancel Comments field';
                Caption = 'Return Comments';
                MultiLine = true;
                Editable = false;
            }
        }
    }
}



