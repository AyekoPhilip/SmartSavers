page 50948 "Electrol Zones/Area Svr Center"
{
    PageType = List;
    SourceTable = "Electrol Zones/Area Svr Center";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Mileage (KMs)"; Rec."Mileage (KMs)")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control6; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




