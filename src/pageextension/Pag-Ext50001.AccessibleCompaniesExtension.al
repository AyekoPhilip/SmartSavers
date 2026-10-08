pageextension 50001 "Accessible Companies-Extension" extends "Accessible Companies"
{
    layout
    {

    }
    trigger OnOpenPage()
    begin
       DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);

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
}



