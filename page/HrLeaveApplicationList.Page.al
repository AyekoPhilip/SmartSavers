namespace DynamicsNav.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;
using SaccoDatabase.SaccoDatabase;

page 50139 "Hr Leave Application List"
{
    ApplicationArea = All;
    Caption = 'Leave Application List';
    PageType = List;
    CardPageId="Hr Leave Application";
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Hr Leave Mgt.";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Applicant Staff No."; Rec."Applicant Staff No.")
                {
                    ToolTip = 'Specifies the value of the Staff No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Days Applied"; Rec."Days Applied")
                {
                    ToolTip = 'Specifies the value of the Days Applied field.', Comment = '%';
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
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }
}
