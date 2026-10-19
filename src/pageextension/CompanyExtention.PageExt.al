pageextension 50063 "Company Extention" extends Companies
{

    Editable =true;
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

    trigger OnDeleteRecord(): Boolean
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);

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
