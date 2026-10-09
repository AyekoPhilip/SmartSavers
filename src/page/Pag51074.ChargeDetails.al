page 51074 "Charge Details"
{
    ApplicationArea = All;
    Caption = 'Charge Details';
    PageType = Card;
    SourceTable = "Loan Application";
    DeleteAllowed=false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = false;
                part(Control6; "Application Charge")
                {
                    SubPageLink = "Application No." = field("No.");
                    Caption='Bond & Valuation Fee';
                    ApplicationArea = All;
                }

            }
            group("Other Charges")
            {
                ShowCaption = false;
                Editable = false;
                part(Control7; "Loan Application Charge")
                {
                    SubPageLink = "Application No." = field("No.");
                    Caption='Other Charges';
                    ApplicationArea = All;
                }

            }
        }
    }
}
