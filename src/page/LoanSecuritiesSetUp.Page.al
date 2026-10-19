page 50956 "Loan Securities Set-Up"
{
    CardPageID = "Loan Securites Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Loan Securities Set-up";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Security Description"; Rec."Security Description")
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




