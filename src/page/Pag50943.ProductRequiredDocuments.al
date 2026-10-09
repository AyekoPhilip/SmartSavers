page 50943 "Product Required Documents"
{
    PageType = List;
    SourceTable = "Product Checklist";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                }
                field("Mandatory Requirement"; Rec."Mandatory Requirement")
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




