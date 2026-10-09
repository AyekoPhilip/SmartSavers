page 50953 "DCS Parameter Matrix Appl."
{
    PageType = List;
    SourceTable = "DCS Parameter Matrix Appl.";
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
                field("Parameter Code"; Rec."Parameter Code")
                {
                    ApplicationArea = All;
                }
                field("Parameter Desc"; Rec."Parameter Desc")
                {
                    ApplicationArea = All;
                }
                field("Parameter Base"; Rec."Parameter Base")
                {
                    ApplicationArea = All;
                }
                field("Parameter Base Unit"; Rec."Parameter Base Unit")
                {
                    ApplicationArea = All;
                }
                field("Computation Method"; Rec."Computation Method")
                {
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = All;
                }
                field("Date Formula"; Rec."Date Formula")
                {
                    ApplicationArea = All;
                }
                field(Factor; Rec.Factor)
                {
                    ApplicationArea = All;
                }
                field("Contributes To Score As"; Rec."Contributes To Score As")
                {
                    ApplicationArea = All;
                }
                field("Application Priority"; Rec."Application Priority")
                {
                    ApplicationArea = All;
                }
                field("Success Default Value"; Rec."Success Default Value")
                {
                    ApplicationArea = All;
                }
                field("Parameter Scope"; Rec."Parameter Scope")
                {
                    ApplicationArea = All;
                }
                field("Failure Response"; Rec."Failure Response")
                {
                    ApplicationArea = All;
                }
                field("Fall Back Parameter"; Rec."Fall Back Parameter")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action23)
            {
                action("Product Charges")
                {
                    Image = SetupPayment;
                    RunObject = Page "Loan Product Charge Appl.";
                    ApplicationArea = All;
                }
                action("Appraisal Parameters")
                {
                    Image = Evaluate;
                    ApplicationArea = All;
                    //RunObject = Page Page52018671;
                }
                action("Related Product")
                {
                    Image = Relatives;
                    RunObject = Page "Related Product Appl. List";
                    ApplicationArea = All;
                }
            }
        }
        area(navigation)
        {
            action("Product Application Document")
            {
                Image = Documents;
                RunObject = Page "Product Application Document";
                ApplicationArea = All;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref("Related Product_Promoted"; "Related Product")
                {
                }
            }
            group(Category_Process)
            {
                actionref("Product Charges_Promoted"; "Product Charges")
                {
                }
                actionref("Appraisal Parameters_Promoted"; "Appraisal Parameters")
                {
                }
            }
            group(Category_Category4)
            {
                actionref("Product Application Document_Promoted"; "Product Application Document")
                {
                }
            }
        }
    }
}




