page 50988 "Loan Application Charges"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Application Charge";
    SourceTableView = WHERE("Post Charge" = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Product Code"; Rec."Product Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Charge Method"; Rec."Charge Method")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Effect Excise Duty"; Rec."Effect Excise Duty")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charging Option"; Rec."Charging Option")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Minimum; Rec.Minimum)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Maximum; Rec.Maximum)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Additional Charge %"; Rec."Additional Charge %")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Prorate; Rec.Prorate)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Staggered Charge Code"; Rec."Staggered Charge Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
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

    trigger OnOpenPage()
    begin
        CurrPage.Editable := false;
        Rec.FilterGroup(2);
        Rec.SetRange("Post Charge", true);
        Rec.FilterGroup(0);
    end;
}




