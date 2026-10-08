pageextension 50067 "Reverse Reg. Credt Mgt" extends "Reverse Transaction Entries"
{

    layout
    {

    }
    trigger OnOpenPage()
    begin
        if not DoctMngt.PostReversalMngt(UserId) then
            Error(ErrorOnPermsMngt);
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
        UserSettings: Page "User Setup";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        ErrorOnPermsMngt: Label 'You do not have permission on Post Reversal Page.';
}
