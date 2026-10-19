pageextension 50011 "GLAccountCardExt" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Votebook Entry"; Rec."Votebook Entry")
            {
                Caption = 'Check Budget';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Check Budget field';
            }
        }
    }
}


