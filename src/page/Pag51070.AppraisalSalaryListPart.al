page 51070 "Appraisal Salary ListPart"
{
    ApplicationArea = All;
    Caption = 'Appraisal Salary ListPart';
    PageType = ListPart;
    SourceTable = "Appraisal Salary Details";
    SourceTableView = where("Auto Computed" = const(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Code"; Rec."Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Amount; Rec.Amount)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                
            }
        }
    }
}
