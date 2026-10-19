namespace DynamicsNav.DynamicsNav;

page 90006 "Batch Lines"
{
    ApplicationArea = All;
    Caption = 'Batch Lines';
    Editable=false;
    ModifyAllowed=false;
    DeleteAllowed=false;
    InsertAllowed=false;
    PageType = ListPart;
    SourceTable = "Loan Disbursement Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable=false;
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Default Account No."; Rec."Default Account No.")
                {
                    ToolTip = 'Specifies the value of the Default Account No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ToolTip = 'Specifies the value of the Pay Mode field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Line Status";Rec."Line Status")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
