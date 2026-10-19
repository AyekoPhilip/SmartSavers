page 51074 "Charge Details"
{
    ApplicationArea = All;
    Caption = 'Charge Details';
    PageType = Card;
    SourceTable = "Loan Application";
    DeleteAllowed=TRUE;
    layout
    {
        area(content)
        {
            
            group("Loan Application Charges")
            {
                ShowCaption = TRUE;
                Editable = TRUE;
                part(Control7; "Loan Application Charge")
                {
                    SubPageLink = "Application No." = field("No.");
                    Caption='Loan Application Charge';
                    ApplicationArea = All;
                }

            }
        }
    }
}
