page 50990 "Collateral Register Lines"
{
    PageType = ListPart;
    SourceTable = "Collateral Register Line";
    InsertAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Mortgage Bond"; Rec."Mortgage Bond")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Rate Clearance"; Rec."Rate Clearance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Deed Transfer"; Rec."Deed Transfer")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Evaluation Invoice"; Rec."Evaluation Invoice")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Property Plan"; Rec."Property Plan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Municipal Permit"; Rec."Municipal Permit")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Letters Of Guaranteed"; Rec."Letters Of Guaranteed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
    }

    actions
    {
    }
}




