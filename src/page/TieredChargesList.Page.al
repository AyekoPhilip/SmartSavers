page 50880 "Tiered Charges List"
{
    CardPageID = "Tiered Charges Header";
    Editable = false;
    PageType = List;
    SourceTable = "Tiered Charges Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
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
        }
    }

    actions
    {
    }
}




