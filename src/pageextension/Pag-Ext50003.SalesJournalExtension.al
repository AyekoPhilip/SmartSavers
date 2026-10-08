pageextension 50003 "Sales Journal-Extension" extends "Sales Journal"
{
     layout
    {

    }
    actions
    {

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnOpenPage()
    begin
        
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Line", FunctionStrng::Administrator) then
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
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

}



