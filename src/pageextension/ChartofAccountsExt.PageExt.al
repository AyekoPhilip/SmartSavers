pageextension 50048 "Chart of Accounts Ext" extends "Chart of Accounts"
{
    Editable = true;
    layout
    {
        addafter("No.")
        {
            field("Old Account No"; Rec."Old Account No")
            {
                ToolTip = 'Specifies the value of the Old Account No.';
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {

            field(Commitment; Rec.Commitment)
            {
                ToolTip = 'Specifies the value of the Commitment field.';
                ApplicationArea = All;
            }
            field(Encumberance; Rec.Encumberance)
            {
                ToolTip = 'Specifies the value of the Encumberance field.';
                ApplicationArea = All;
            }
            field("Budgeted Amount"; Rec."Budgeted Amount")
            {
                ToolTip = 'Specifies either the G/L account''s total budget or, if you have specified a name in the Budget Name field, a specific budget.';
                ApplicationArea = All;
            }
            field("Approved Budget"; Rec."Approved Budget")
            {
                ToolTip = 'Specifies the value of the Approved Budget field.';
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()

    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"G/L Account", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end; 

    trigger OnDeleteRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"G/L Account", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"G/L Account", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    var
        Text016: Label 'You cannot Delete/Modify %1-%2 because there is at least one entry is related to this Account.';
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';
}


