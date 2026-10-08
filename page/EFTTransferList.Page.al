page 50814 "EFT Transfer List"
{
    CardPageID = "EFT Transfer Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "EFT Transfer Header";
    ApplicationArea = All;
    SourceTableView = where("Application Source" = filter(Credit));
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
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Record Total"; Rec."Record Total")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Record Count"; Rec."Record Count")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document Type"; Rec."Document Type")
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
                        Rec.SetRange("Created By", Usersetup."User ID");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Centre", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end else begin
                    if UserMgt.GetLimitedUserFilter() <> '' then begin
                        Rec.FilterGroup(2);
                        Rec.SetRange("Responsibility Centre", UserMgt.GetLimitedUserFilter());
                        Rec.FilterGroup(0);
                    end;
                end;
            end;
        end else
            Error('User %1 ID not found', Usersetup."User ID");
    end;

    var
        Usersetup: Record "User Setup";
        FilterApproverID: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
}




