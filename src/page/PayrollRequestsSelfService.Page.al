page 50578 "Payroll Requests-Self Service"
{
    CardPageID = "Payroll Request Card";
    PageType = List;
    SourceTable = "Payroll Requests";
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Created By", UserId);
        end else
            Error('%1 does not exist in the Users Setup', UserId);
    end;

    var
        UserSetup: Record "User Setup";

}