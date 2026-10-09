page 51103 "BBF Entitlement Setup"
{
    ApplicationArea = All;
    Caption = 'BBF Entitlement Setup';
    PageType = List;
    SourceTable = "BBF Entitlement";
    UsageCategory = Lists;

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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    Visible=false;
                    StyleExpr = true;
                }
                field("Max No."; Rec."Max No.")
                {
                    ToolTip = 'Specifies the value of the Max No. field.';
                    Style = StandardAccent;
                    Visible=false;
                    StyleExpr = true;
                }
                field(Minor; Rec.Minor)
                {
                    ToolTip = 'Specifies the value of the Minor field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Self; Rec.Self)
                {
                    ToolTip = 'Specifies the value of the Self field.';
                    Style = StandardAccent;
                    Visible=false;
                    StyleExpr = true;
                }
            }
        }
    }
}
