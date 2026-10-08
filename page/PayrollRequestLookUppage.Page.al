namespace DynamicsNav.SaccoDatabase.HrManagementMgt;

using System.Security.User;

page 90005 "Payroll Request LookUp page"
{
    ApplicationArea = All;
    Caption = 'Payroll Request LookUp page';
    PageType = List;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Payroll Requests";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name field';
                }
                field("Responsibility Code"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field';
                }
                field("Code Descripton"; Rec."Code Descripton")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code Descripton field';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field';
                }
                field("Date of Activity"; Rec."Date of Activity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Activity field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reject)
            {
                Image = Reject;
                ApplicationArea = All;
                ToolTip = 'Executes the Reject action';
                Caption = 'Reject Request';
                Enabled = PayrollUser;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to reject this request?', false) then begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                        Message('%1 rejected successfully', Rec."No.");
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Reject_Promoted; Reject)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        
    end;

    var
        UserSetup: Record "User Setup";
        PayrollUser: Boolean;
}
