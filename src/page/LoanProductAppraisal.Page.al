page 50839 "Loan Product Appraisal"
{
    PageType = List;
    SourceTable = "Loan Product Parameters";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Product Code"; Rec."Loan Product Code")
                {
                    ApplicationArea = All;
                }
                field("Parameter Base"; Rec."Parameter Base")
                {
                    ApplicationArea = All;
                }
                field("Computation Method"; Rec."Computation Method")
                {
                    ApplicationArea = All;
                }
                field(Factor; Rec.Factor)
                {
                    ApplicationArea = All;
                }
                field("Application Priority"; Rec."Application Priority")
                {
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                }
                field("Parameter Base Unit"; Rec."Parameter Base Unit")
                {
                    ApplicationArea = All;
                }
                field("Success Default Value"; Rec."Success Default Value")
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




