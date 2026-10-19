pageextension 50068 "Profile Role Ext. Mngt" extends "Profile List"
{
    layout
    {

    }
    trigger OnOpenPage()
    begin
       // DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
      //  if not DoctMngt.RecordRestrictMngt(UserId, Database::"All Profile", FunctionStrng::Administrator) then
      //      Error(MsgOnPermissionTxt); 
    end;

    trigger OnAfterGetRecord()
    begin
       // if not DoctMngt.RecordRestrictMngt(UserId, Database::"All Profile", FunctionStrng::Administrator) then
        //    CurrPage.Editable := false; 

    end;

    trigger OnClosePage()
    begin

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
