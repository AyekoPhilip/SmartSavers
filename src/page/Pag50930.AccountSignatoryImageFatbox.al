page 50930 "Account Signatory Image Fatbox"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Account Signatories";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = All;
            }
            field(Signature; Rec.Signature)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




