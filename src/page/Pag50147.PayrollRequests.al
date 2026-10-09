page 50147 "Payroll Requests"
{
    CardPageID = "Payroll Request Card";
    PageType = List;
    SourceTable = "Payroll Requests";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Employee No. field';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Employee Name field';
                }
                field("Responsibility Code"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Code field';
                }
                field("Code Descripton"; Rec."Code Descripton")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Code Descripton field';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Remarks field';
                }
                field("Date of Activity"; Rec."Date of Activity")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date of Activity field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    var
        Filterstring: Text[250];
        FilterRespCentre: Code[10];
    begin

        if Usersetup.Get(UserId) then begin

            case Usersetup."User Type" of
                Usersetup."User Type"::"Approval Limits",
                Usersetup."User Type"::"Limited to User":
                    begin
                        Rec.SetFilter("Created By", Usersetup."User ID");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end else begin
                    if UserMgt.GetLimitedUserFilter() <> '' then begin
                        Rec.FilterGroup(2);
                        Rec.SetFilter("Responsibility Center", UserMgt.GetLimitedUserFilter());
                        Rec.FilterGroup(0);
                    end;
                end;
            end;
        end else
            Error('User ID not found');
    end;

    var
        UserSetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";

}


