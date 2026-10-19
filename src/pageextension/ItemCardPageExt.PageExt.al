pageextension 50009 "ItemCardPageExt" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Item G/L Budget Account"; Rec."Item G/L Budget Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item G/L Budget Account field';
            }
        }
    }
}


