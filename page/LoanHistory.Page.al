page 50932 "Loan History"
{
    Editable = false;
    PageType = List;
    SourceTable = "Loan History";
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
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = All;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Outanding Bill"; Rec."Outanding Bill")
                {
                    ApplicationArea = All;
                }
                field("Loan Issued Date"; Rec."Loan Issued Date")
                {
                    ApplicationArea = All;
                }
                field("Loan Expiry Date"; Rec."Loan Expiry Date")
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




