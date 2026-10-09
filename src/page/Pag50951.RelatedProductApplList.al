page 50951 "Related Product Appl. List"
{
    PageType = List;
    SourceTable = "Related Product Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Related Product Code"; Rec."Related Product Code")
                {
                    ApplicationArea = All;
                }
                field("Related Product Desc"; Rec."Related Product Desc")
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




