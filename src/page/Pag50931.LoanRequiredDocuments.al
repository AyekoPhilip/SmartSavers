page 50931 "Loan Required Documents"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Loan Required Documents";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                }
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Single Party/Multiple"; Rec."Single Party/Multiple")
                {
                    ApplicationArea = All;
                }
                field(Provided; Rec.Provided)
                {
                    ApplicationArea = All;
                }
                field("License Expiry Date"; Rec."License Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document Path"; Rec."Document Path")
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




