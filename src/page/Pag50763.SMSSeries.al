page 50763 "SMS Series"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "SMS Series";
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
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Message Body"; Rec."Message Body")
                {
                    ApplicationArea = All;
                }
                field("Email Body"; Rec."Email Body")
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




