page 51093 "Sal. Details Loan Calculator"
{
    ApplicationArea = All;
    Caption = 'Sal. Details Loan Calculator ';
    PageType = ListPart;
    DeleteAllowed=false;
    InsertAllowed=false;
    SourceTable = "Appraisal Salary Details";
    
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
                    StyleExpr = TRUE;
                }
                field(Description;Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Desription field.';
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field(Type;Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
        }
    }
}
