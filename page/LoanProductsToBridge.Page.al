page 50962 "Loan Products To Bridge"
{
    PageType = List;
    SourceTable = "Loan Products to Bridge";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product To Bridge"; Rec."Product To Bridge")
                {
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
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




