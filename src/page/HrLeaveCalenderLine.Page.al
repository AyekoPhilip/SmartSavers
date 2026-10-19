namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

page 50123 "Hr Leave Calender Line"
{
    ApplicationArea = All;
    Caption = 'Hr Leave Calender Line';
    PageType = ListPart;
    SourceTable = "Hr Leave Calendar Lines";
    
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
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field(Day; Rec.Day)
                {
                    ToolTip = 'Specifies the value of the Day field.', Comment = '%';
                }
                field("Non Working"; Rec."Non Working")
                {
                    ToolTip = 'Specifies the value of the Non Working field.', Comment = '%';
                }
                field(Reason; Rec.Reason)
                {
                    ToolTip = 'Specifies the value of the Reason field.', Comment = '%';
                }
            }
        }
    }
}
