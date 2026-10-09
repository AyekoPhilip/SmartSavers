page 50933 "Required Documents"
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
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
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
            }
        }
    }

    actions
    {
    }
}




