pageextension 50040 "GenBatchExt" extends "General Journal Batches"
{
    layout
    {
        
        addafter(Description)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the User ID field';
            }
            field("Responsibility Centre"; Rec."Responsibility Centre")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Responsibility Centre field';
            }
            

        }
        
    }

    actions
    {

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Batch", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Batch", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Batch", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnOpenPage()
    begin

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Batch", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Gen. Journal Batch", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

    end;
    trigger OnClosePage()
    begin
        Rec.TestField("User ID");
        Rec.TestField("Responsibility Centre");
    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        Temp: Record "User Setup";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

}











