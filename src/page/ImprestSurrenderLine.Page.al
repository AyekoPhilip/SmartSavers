page 50085 "Imprest Surrender Line"
{
    ApplicationArea = All;
    Caption = 'Imprest Surrender Line';
    PageType = ListPart;
    SourceTable = "Imprest Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Actual Spent"; Rec."Actual Spent")
                {
                    ToolTip = 'Specifies the value of the Actual Spent field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Receipt No"; Rec."Receipt No.")

                {
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Receipt Amount"; Rec."Receipt Amount")
                {
                    ToolTip = 'Specifies the value of the Receipt Amount field.';
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Imprest Holder"; Rec."Imprest Holder")
                {
                    ToolTip = 'Specifies the value of the Imprest Holder field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
            }
        }
    }
}
