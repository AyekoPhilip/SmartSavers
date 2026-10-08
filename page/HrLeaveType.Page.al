namespace DynamicsNav.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;
using SaccoDatabase.SaccoDatabase;

page 50097 "Hr Leave Type"
{
    ApplicationArea = All;
    Caption = 'Leave Type';
    PageType = List;
    DeleteAllowed=false;
    InsertAllowed=false;
    ModifyAllowed=false;
    Editable=false;
    CardPageId="Hr Leave Type Page";
    SourceTable = "Hr Leave Type";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Days; Rec.Days)
                {
                    ToolTip = 'Specifies the value of the Days field.', Comment = '%';
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.', Comment = '%';
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
