namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

page 90008 "Hr Calender List"
{
    ApplicationArea = All;
    Caption = 'Leave Calender List';
    PageType = List;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Hr Leave Calender Page";
    Editable = false;
    SourceTable = "Hr Leave Calendar";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Calendar Code"; Rec."Calendar Code")
                {
                    ToolTip = 'Specifies the value of the Calendar Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
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
