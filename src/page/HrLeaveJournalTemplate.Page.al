namespace SaccoDatabase.SaccoDatabase;

using DynamicsNav.SaccoDatabase.HrManagementMgt;
using Microsoft.Inventory.Journal;

page 50136 "Hr Leave Journal Template"
{
    ApplicationArea = All;
    Caption = 'Leave Journal Template';
    PageType = List;
    SourceTable = "Hr Leave Journal Template";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Posting Report ID"; Rec."Posting Report ID")
                {
                    ToolTip = 'Specifies the value of the Posting Report ID field.', Comment = '%';
                }
                field("Posting Report Name"; Rec."Posting Report Name")
                {
                    ToolTip = 'Specifies the value of the Posting Report Name field.', Comment = '%';
                }
                field("Test Report ID"; Rec."Test Report ID")
                {
                    ToolTip = 'Specifies the value of the Test Report ID field.', Comment = '%';
                }
                field("Test Report Name"; Rec."Test Report Name")
                {
                    ToolTip = 'Specifies the value of the Test Report Name field.', Comment = '%';
                }
                field("Form ID"; Rec."Form ID")
                {
                    ToolTip = 'Specifies the value of the Form ID field.', Comment = '%';
                }
                field("Form Name"; Rec."Form Name")
                {
                    ToolTip = 'Specifies the value of the Form Name field.', Comment = '%';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.', Comment = '%';
                }
                field("Force Posting Report"; Rec."Force Posting Report")
                {
                    ToolTip = 'Specifies the value of the Force Posting Report field.', Comment = '%';
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
    var
    ItemJnlMgt: page "Item Journal Lines";
}
