page 50972 "Member Statistics"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Member;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                part(Control4; "Banking Statistics")
                {
                    SubPageLink = "Member No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part(Control5; "Credit Statistics")
                {
                    SubPageLink = "Member No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
            group(Control6)
            {
                ShowCaption = false;
                part(Control8; "Loans Statistics")
                {
                    SubPageLink = "Account No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
            group("Loan Performance")
            {
                part(Control9; "Loan Performance")
                {
                    SubPageLink = "Account No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




