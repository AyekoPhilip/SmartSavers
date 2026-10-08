page 50039 "Status Change Card"
{
    ApplicationArea = All;
    Caption = 'Status Change Card';
    PageType = Card;
    SourceTable = "Status Change Permissions";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("User ID No."; Rec."User ID No.")
                {
                    ToolTip = 'Specifies the value of the User ID No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Function"; Rec."Function")
                {
                    ToolTip = 'Specifies the value of the Function field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Function Extended"; Rec."Function Extended")
                {
                    ToolTip = 'Specifies the value of the Function Extended field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Permissions)
            {
                field("Cheque Writting"; Rec."Cheque Writting")
                {
                    ToolTip = 'Specifies the value of the Cheque Writting field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit  G/L Account"; Rec."Edit  G/L Account")
                {
                    ToolTip = 'Specifies the value of the Edit  G/L Account field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Customer"; Rec."Edit Customer")
                {
                    ToolTip = 'Specifies the value of the Edit Customer field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Setup"; Rec."Edit Setup")
                {
                    ToolTip = 'Specifies the value of the Edit Setup field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Payroll"; Rec."Edit Payroll")
                {
                    ToolTip = 'Specifies the value of the Edit Payroll field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Monthly Remittance"; Rec."Edit Monthly Remittance")
                {
                    ToolTip = 'Specifies the value of the Edit Monthly Remittance field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Member Changes"; Rec."Edit Member Changes")
                {
                    ToolTip = 'Specifies the value of the Edit Member Changes field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Post Dividends"; Rec."Post Dividends")
                {
                    ToolTip = 'Specifies the value of the Post Dividends field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Next of Kin"; Rec."Edit Next of Kin")
                {
                    ToolTip = 'Specifies the value of the Edit Next of Kin field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("View Next of Kin"; Rec."View Next of Kin")
                {
                    ToolTip = 'Specifies the value of the View Next of Kin field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("View Payroll"; Rec."View Payroll")
                {
                    ToolTip = 'Specifies the value of the View Payroll field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("View Setup"; Rec."View Setup")
                {
                    ToolTip = 'Specifies the value of the View Setup field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("View G/L Account"; Rec."View G/L Account")
                {
                    ToolTip = 'Specifies the value of the View G/L Account field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Edit Data Sheet"; Rec."Edit Data Sheet")
                {
                    ToolTip = 'Specifies the value of the Edit Data Sheet field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Trail Information")
            {
                Editable=false;
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
