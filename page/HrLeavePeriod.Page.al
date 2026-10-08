namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

page 50135 "Hr Leave Period"
{
    ApplicationArea = All;
    Caption = 'Leave Period';
    PageType = List;
    SourceTable = "HR Leave Periods";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Period Description"; Rec."Period Description")
                {
                    ToolTip = 'Specifies the value of the Period Description field.', Comment = '%';
                }
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                }
                field("New Fiscal Year"; Rec."New Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the New Fiscal Year field.', Comment = '%';
                }
                field("Date Locked"; Rec."Date Locked")
                {
                    ToolTip = 'Specifies the value of the Date Locked field.', Comment = '%';
                }
                field("Reimbursement Clossing Date"; Rec."Reimbursement Clossing Date")
                {
                    ToolTip = 'Specifies the value of the Reimbursement Clossing Date field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
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
