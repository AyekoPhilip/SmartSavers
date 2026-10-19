page 50879 "Tiered Charges Header"
{
    PageType = Card;
    SourceTable = "Tiered Charges Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
            group(Control6)
            {
                ShowCaption = false;
                part(Control5; "Tiered Charges Lines")
                {
                    SubPageLink = Code = FIELD(Code);
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




