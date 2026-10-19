page 51085 "EFT Receipt List"
{
    ApplicationArea = All;
    Caption = 'EFT Receipt List';
    PageType = List;
    CardPageId = "EFT Receipt Header";
    SourceTable = "EFT Transfer Header";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    SourceTableView = where("Application Source" = filter(Teller | Benefits));
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ToolTip = 'Specifies the value of the Date Entered field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
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
                Usersetup."User Type"::"Limited to User":
                    begin
                        Rec.SetRange("Created By", Usersetup."User ID");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Centre", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end;
                Usersetup."User Type"::"Approval Limits":
                    begin
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            Rec.SetRange("Responsibility Centre", UserMgt.GetLimitedUserFilter());
                            Rec.FilterGroup(0);
                        end;
                    end;
                Usersetup."User Type"::"View All":
                    begin
                        Usersetup.TestField("Office/Group");
                        if UserMgt.GetLimitedUserFilter() <> '' then begin
                            Rec.FilterGroup(2);
                            FilterApproverID := '';
                            FilterApproverID := Usersetup."Office/Group";
                            Rec.SetFilter("Responsibility Centre", ('%1|%2'), FilterApproverID, UserMgt.GetLimitedUserFilter());
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
