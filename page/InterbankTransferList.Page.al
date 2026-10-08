page 50089 "Interbank Transfer List"
{
    ApplicationArea = All;
    Caption = 'Interbank Transfer List';
    PageType = List;
    DeleteAllowed=false;
    Editable=false;
    InsertAllowed=false;
    ModifyAllowed=false;
    CardPageId="Interbank Transfer Card";
    SourceTable = "Interbank Transfer";
    UsageCategory = Lists;

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
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Paying Account"; Rec."Paying Account No.")
                {
                    ToolTip = 'Specifies the value of the Paying Account field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Status; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("On Behalf Of"; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
            }
        }
    }
}
