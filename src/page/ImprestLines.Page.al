page 50082 "Imprest Lines"
{
    ApplicationArea = All;
    Caption = 'Imprest Lines';
    PageType = ListPart;
    SourceTable = "Imprest Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Advance Type"; Rec."Advance Type")
                {
                    ToolTip = 'Specifies the value of the Advance Type field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
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
                field("Destination Code"; Rec."Destination Code")
                {
                    ToolTip = 'Specifies the value of the Destination Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("No of Days"; Rec."No of Days")
                {
                    ToolTip = 'Specifies the value of the No of Days field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Imprest Holder"; Rec."Imprest Holder")
                {
                    ToolTip = 'Specifies the value of the Imprest Holder field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ToolTip = 'Specifies the value of the Amount LCY field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    ToolTip = 'Specifies the value of the Date Issued field.';
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
