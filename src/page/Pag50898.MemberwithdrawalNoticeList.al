page 50898 "Member withdrawal Notice List"
{
    CardPageID = "Member withdrawal Notice";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Member withdrawal Notice";
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
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Reason for withdrawal"; Rec."Reason for withdrawal")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Withdrawa Noticel Date"; Rec."Withdrawal Notice Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
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
                        Rec.SetRange("Entered By", Usersetup."User ID");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end else begin
                    if UserMgt.GetLimitedUserFilter() <> '' then begin
                        Rec.FilterGroup(2);
                        Rec.SetRange("Responsibility Center", UserMgt.GetLimitedUserFilter());
                        Rec.FilterGroup(0);
                    end;
                end;
            end;
        end else
            Error('User ID not found');
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    var
        ObjEmp: Record Customer;
        ObjName: Text[150];
        Usersetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
}




