pageextension 50065 "Configuration Package Ext." extends "Config. Packages"
{
    layout
    {

    }
    trigger OnOpenPage()
    begin
      DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
       if not DoctMngt.RecordRestrictMngt(UserId, Database::"Config. Package", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt); 
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnClosePage()
    begin

    end;

    trigger OnDeleteRecord(): Boolean
    begin
      /*   DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Config. Package", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
 */
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
       DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
       if not DoctMngt.RecordRestrictMngt(UserId, Database::"Config. Package", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /* DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Config. Package", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt); */

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
}
