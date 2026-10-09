page 50778 "Individual Application List"
{
    CardPageID = "Individual Application";
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Member Application";
    SourceTableView = sorting("No.")
                      order(Ascending)
                      where("Approval Status" = filter(Open | "Pending Approval"),
                            "Group Account" = const(false),
    "Customer Type" = const(Individual), "Application Type" = const("New Member"));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control13)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Date"; Rec."Application Date")
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

                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
        }
        area(factboxes)
        {
            systempart(Control113; Notes)
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
    trigger OnInit()
    begin

    end;

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnOpenPage()
    var
        Filterstring: Text[250];
        FilterRespCentre: Code[10];
    begin

        Usersetup.Reset();
        Usersetup.SetRange("User ID", UserId);
        if Usersetup.FindFirst() then begin

            case Usersetup."User Type" of
                Usersetup."User Type"::"Approval Limits",
                Usersetup."User Type"::"Limited to User":
                    begin
                        Rec.SetRange("Created By", Usersetup."User ID");
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
        end else begin
            Error('User ID not found');
        end;
    end;

    var
        Usersetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
}




