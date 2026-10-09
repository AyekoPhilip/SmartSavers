page 51075 "Loan Application Charge"
{
    ApplicationArea = All;
    Caption = 'Loan Application Charge';
    PageType = ListPart;
    SourceTable = "Loan Application Charge";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;

                field("Charge Code"; Rec."Charge Code")
                {
                    ToolTip = 'Specifies the value of the Charge Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ToolTip = 'Specifies the value of the Charge Description field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Use Percentage"; Rec."Use Percentage")
                {
                    ToolTip = 'Specifies the value of the Use Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charge Amount"; Rec."Charge Amount")
                {
                    ToolTip = 'Specifies the value of the Charge Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amount to Post"; Rec."Amount to Post")
                {
                    ToolTip = 'Specifies the value of the Amount Posted field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ToolTip = 'Specifies the value of the Charge Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charging Option"; Rec."Charging Option")
                {
                    ToolTip = 'Specifies the value of the Charging Option field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Minimum; Rec.Minimum)
                {
                    ToolTip = 'Specifies the value of the Minimum field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Maximum; Rec.Maximum)
                {
                    ToolTip = 'Specifies the value of the Maximum field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}
