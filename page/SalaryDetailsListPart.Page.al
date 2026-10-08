page 51071 "Salary Details ListPart"
{
    ApplicationArea = All;
    Caption = 'Salary Details ListPart';
    PageType = ListPart;
    SourceTable = "Appraisal Salary Details";
    SourceTableView = where("Auto Computed" = const(true));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Style = StandardAccent;
                    StyleExpr = true;
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
