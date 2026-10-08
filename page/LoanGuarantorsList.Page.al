page 50902 "Loan Guarantors List"
{
    PageType = ListPart;
    SourceTable = "Loan Guarantors Sub";
    Caption = 'Subsitution Lines';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Security Type";Rec."Security Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Savings Account No."; Rec."Savings Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Original Guarantor"; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Loan No"; Rec."Loan No")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Shares; Rec.Shares)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    Editable = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Substituted; Rec.Substituted)
                {
                    Caption = 'Substitute';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin


                    end;
                }

                field("Self Guarantee"; Rec."Self Guarantee")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Non Subsituted"; Rec."Non Subsituted")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field(Posted; Rec.Posted)
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

            }
        }
    }

    actions
    {
    }
}




