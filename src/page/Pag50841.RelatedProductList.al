page 50841 "Related Product List"
{
    PageType = List;
    SourceTable = "Related Product";
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
                field("Refinance %"; Rec."Refinance %")
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




