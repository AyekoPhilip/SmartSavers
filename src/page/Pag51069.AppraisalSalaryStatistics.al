page 51069 "Appraisal Salary Statistics"
{
    ApplicationArea = All;
    Caption = 'Appraisal Salary Statistics';
    PageType = Card;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                ShowCaption = false;
                part(Control4; "Appraisal Salary ListPart")
                {
                    Caption = 'Salary Details';
                    SubPageLink = "Loan Application No." = field("No."), "Client Code" = field("Account No.");
                    ApplicationArea = All;
                }
            }
            group("Other Information")
            {
                ShowCaption = false;
                Caption = 'Salary Computation';
                part(Control5; "Salary Details ListPart")
                {
                    Editable = false;
                    SubPageLink = "Loan Application No." = field("No."), "Client Code" = field("Account No.");
                    ApplicationArea = All;
                }
            }
           
        }
    }
}
