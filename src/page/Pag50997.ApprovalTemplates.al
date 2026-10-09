page 50997 "Approval Templates"
{
    Caption = 'Approval Templates';
    DeleteAllowed = true;
    PageType = List;
    SourceTable = "Approval Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = All;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                }
                field("Additional Approvers"; Rec."Additional Approvers")
                {
                    ApplicationArea = All;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Use Responsibility Centre"; Rec."Use Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AdditionalAppr)
            {
                Caption = '&Additional Appr.';
                Image = Approval;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    AddApprovers.Init;
                    AddApprovers.SetRange("Approval Code", Rec."Approval Code");
                    AddApprovers.SetRange("Approval Type", Rec."Approval Type");
                    AddApprovers.SetRange("Document Type", Rec."Document Type");
                    AddApprovers.SetRange("Limit Type", Rec."Limit Type");
                    AddApproverForm.SetTableView(AddApprovers);
                    AddApproverForm.Run;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(AdditionalAppr_Promoted; AdditionalAppr)
                {
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnOpenPage()
    begin

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Approval Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

    end;

    trigger OnClosePage()
    begin

    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        AddApprovers: Record "Additional Approver";
        AddApproverForm: Page "Additional Approvers";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';


}




