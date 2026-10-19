pageextension 50000 "Roles List-Extension" extends Roles
{
    layout
    {

    }
    trigger OnOpenPage()
    begin
     // if not DoctMngt.RecordRestrictMngt(UserId, Database::"All Profile", FunctionStrng::Administrator) then
     // Error(MsgOnPermissionTxt)
    end;

    trigger OnAfterGetRecord()
    begin

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



