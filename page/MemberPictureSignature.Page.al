page 50795 "Member Picture & Signature"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Image Data";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field(Picture; Rec.Picture)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                }
                field(Signature; Rec.Signature)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




