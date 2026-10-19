page 51073 "Application Charge"
{
    ApplicationArea = All;
    Caption = 'Application Charge';
    PageType = ListPart;
    SourceTable = "Loan Application Charge";
    DeleteAllowed=false;
    InsertAllowed=false;
    SourceTableView =where("Charge Type"=filter("Valuation Fee" | Bond));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Application No.";Rec."Application No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;
                    ApplicationArea=All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;
                    ApplicationArea=All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;
                    ApplicationArea=All;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    ToolTip = 'Specifies the value of the Charge Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ToolTip = 'Specifies the value of the Charge Description field.';
                    Style = StandardAccent;
                    Editable=false;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ToolTip = 'Specifies the value of the Charge Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field("Use Percentage"; Rec."Use Percentage")
                {
                    ToolTip = 'Specifies the value of the Use Percentage field.';
                    Style = StandardAccent;
                    Editable=false;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable=false;
                    ApplicationArea=All;
                }
                field(Minimum; Rec.Minimum)
                {
                    ToolTip = 'Specifies the value of the Minimum field.';
                    Style = StandardAccent;
                    Editable=false;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field(Maximum; Rec.Maximum)
                {
                    ToolTip = 'Specifies the value of the Maximum field.';
                    Style = StandardAccent;
                    Editable=false;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field("Charge Method"; Rec."Charge Method")
                {
                    ToolTip = 'Specifies the value of the Charge Method field.';
                    Style = StandardAccent;
                    Editable=false;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ToolTip = 'Specifies the value of the Charge Type field.';
                    Style = StandardAccent;
                    Editable=false;
                    StyleExpr = true;
                    ApplicationArea=All;
                }
            }
        }
    }
}
