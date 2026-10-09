page 50017 "Hr Employee Lookup"
{
    ApplicationArea = All;
    Caption = 'Hr Employee Lookup';
    PageType = List;
    SourceTable = "HR Employees";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Join"; Rec."Date of Join")
                {
                    ToolTip = 'Specifies the value of the Date of Join field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ToolTip = 'Specifies the value of the PIN No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
               
                field("Job ID"; Rec."Job ID")
                {
                    ToolTip = 'Specifies the value of the Job ID field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
              
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
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
