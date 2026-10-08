pageextension 50013 "MarketingSetupPageExt" extends "Marketing Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field(Interact; Rec.Interact)
            {
                Caption = 'Interaction Nos';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Interaction Nos field';
            }
            field("Enquiries Nos."; Rec."Enquiries Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enquiries Nos. field';
            }
        }
    }
}


