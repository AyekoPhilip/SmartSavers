page 50770 "Checkoff Header Posted"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Checkoff Header";
    SourceTableView = WHERE(Posted = FILTER(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Control22; "Remittance Lines")
            {
                Editable = EditCheckoff;
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Control19; Outlook)
            {
                ApplicationArea = All;
            }
            systempart(Control20; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control21; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        SetUpdateControl;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EditCheckoff: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure SetUpdateControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            EditCheckoff := true;
        end else begin
            EditCheckoff := false;
        end;
    end;
}




