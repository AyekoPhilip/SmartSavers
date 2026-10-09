page 50087 "Imprest Type"
{
    ApplicationArea = All;
    Caption = 'Imprest Type';
    PageType = List;
    Editable=false;
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    CardPageId="Receipts & Payment Types";
    SourceTable = "Receipts and Payment Types";
    UsageCategory = Administration;
    SourceTableView = where(Type = filter(Imprest));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Default Grouping"; Rec."Default Grouping")
                {
                    ToolTip = 'Specifies the value of the Default Grouping field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
            }
        }
    }
    
    
}
