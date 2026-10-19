page 50855 "Banking User Template"
{
    CardPageID = "Banking Template";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Banking User Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account ID"; Rec."Account ID")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {

                    ApplicationArea = All;
                }
                field("No of Open Transactions"; Rec."No of Open Transactions")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Default  Bank"; Rec."Default  Bank")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnModifyRecord(): Boolean
    begin

        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Banking User Template", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

    end;

    var
        StatusPermission: Record "Status Change Permissions";
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
}




