pageextension 50017 "DimensionValuePageExt" extends "Dimension Values"
{
    layout
    {
        addlast(Control1)
        {
            field("Global Dimension No."; Rec."Global Dimension No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension No. field';
            }
        }
    }
}


