namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;

page 50098 "Hr Leave Type Page"
{
    ApplicationArea = All;
    Caption = 'Leave Type Page';
    PageType = Card;
    SourceTable = "Hr Leave Type";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.', Comment = '%';
                }
                field(Days; Rec.Days)
                {
                    ToolTip = 'Specifies the value of the Days field.', Comment = '%';
                }
                field("Accrue Days"; Rec."Accrue Days")
                {
                    ToolTip = 'Specifies the value of the Accrue Days field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                field("Carry Forward Allowed"; Rec."Carry Forward Allowed")
                {
                    ToolTip = 'Specifies the value of the Carry Forward Allowed field.', Comment = '%';
                }
                field("Fixed Days"; Rec."Fixed Days")
                {
                    ToolTip = 'Specifies the value of the Fixed Days field.', Comment = '%';
                }
                field("Inclusive of Holidays"; Rec."Inclusive of Holidays")
                {
                    ToolTip = 'Specifies the value of the Inclusive of Holidays field.', Comment = '%';
                }
                field("Inclusive of Non Working Days"; Rec."Inclusive of Non Working Days")
                {
                    ToolTip = 'Specifies the value of the Inclusive of Non Working Days field.', Comment = '%';
                }
                field("Inclusive of Saturday"; Rec."Inclusive of Saturday")
                {
                    ToolTip = 'Specifies the value of the Inclusive of Saturday field.', Comment = '%';
                }
                field("Inclusive of Sunday"; Rec."Inclusive of Sunday")
                {
                    ToolTip = 'Specifies the value of the Inclusive of Sunday field.', Comment = '%';
                }
                field("Is Annual Leave"; Rec."Is Annual Leave")
                {
                    ToolTip = 'Specifies the value of the Is Annual Leave field.', Comment = '%';
                }
                field("Max Carry Forward Days"; Rec."Max Carry Forward Days")
                {
                    ToolTip = 'Specifies the value of the Max Carry Forward Days field.', Comment = '%';
                }
                field("Minimum Months"; Rec."Minimum Months")
                {
                    ToolTip = 'Specifies the value of the Minimum Months field.', Comment = '%';
                }
                field("Off/Holidays Days Leave"; Rec."Off/Holidays Days Leave")
                {
                    ToolTip = 'Specifies the value of the Off/Holidays Days Leave field.', Comment = '%';
                }
                field("Unlimited Days"; Rec."Unlimited Days")
                {
                    ToolTip = 'Specifies the value of the Unlimited Days field.', Comment = '%';
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
