tableextension 50033 "Return Shipment Header Ext" extends "Return Shipment Header"
{
    fields
    {
        field(50009; "Cancel Comments"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cancel Comments';
        }
    }
}



