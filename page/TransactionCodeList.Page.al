page 50125 "Transaction Code List"
{
    ApplicationArea = All;
    Caption = 'Transaction Code List';
    PageType = List;
    CardPageId = "Transaction Codes";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    SourceTable = "Pr Transaction Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable=false;
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                     Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                     Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
        
    }
}
