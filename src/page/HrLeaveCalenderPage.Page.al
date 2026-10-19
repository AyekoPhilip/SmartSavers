namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

page 50114 "Hr Leave Calender Page"
{
    ApplicationArea = All;
    Caption = 'Hr Leave Calender Page';
    PageType = Card;
    SourceTable = "Hr Leave Calendar";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Current Leave Calendar"; Rec."Current Leave Calendar")
                {
                    ToolTip = 'Specifies the value of the Current Leave Calendar field.', Comment = '%';
                }
            }
            part(LeaveCalenderLine; "Hr Leave Calender Line")
            {
                Caption = 'Lines';
                SubPageLink = Code = field("Calendar Code");
            }
            group("Trail Information")
            {
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Date Modified"; Rec."Date Modified")
                {
                    ToolTip = 'Specifies the value of the Date Modified field.', Comment = '%';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.', Comment = '%';
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
