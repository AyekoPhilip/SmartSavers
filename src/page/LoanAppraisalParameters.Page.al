page 50838 "Loan Appraisal Parameters"
{
    PageType = List;
    SourceTable = "Loan Application Credit Score";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                }
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ApplicationArea = All;
                }
                field(Score; Rec.Score)
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




