page 51012 "Changes Setup (Table) List"
{
    Caption = 'Changes Setup Tables';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = true;
    PageType = List;
    SourceTable = AllObjWithCaption;
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ID';
                    Editable = false;
                    ToolTip = 'Specifies the ID of the table. ';
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the name of the table.';
                }
                field(LogInsertion; ChangeLogSetupTable."Log Insertion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Insertion';
                    Editable = PageIsEditable;
                    Enabled = false;
                    OptionCaption = ' ,Some Fields,All Fields';
                    ToolTip = 'Specifies where insertions of new data are logged. Blank: No insertions in any fields are logged. Some fields: Insertions are logged for selected fields. All fields: Insertions are logged for all fields.';

                    trigger OnAssistEdit()
                    begin
                        ChangeLogSetupTable.TestField("Log Insertion", ChangeLogSetupTable."Log Insertion"::"Some Fields");
                        AssistEdit;
                    end;

                    trigger OnValidate()
                    var
                        ConfirmManagement: Codeunit "Confirm Management";
                        NewValue: Option;
                    begin
                        if ChangeLogSetupTable."Table No." <> Rec."Object ID" then begin
                            NewValue := ChangeLogSetupTable."Log Insertion";
                            GetRec;
                            ChangeLogSetupTable."Log Insertion" := NewValue;
                        end;

                        if xChangeLogSetupTable.Get(ChangeLogSetupTable."Table No.") then begin
                            if (xChangeLogSetupTable."Log Insertion" = xChangeLogSetupTable."Log Insertion"::"Some Fields") and
                               (xChangeLogSetupTable."Log Insertion" <> ChangeLogSetupTable."Log Insertion") then
                                ;
                            /* then
                                if ConfirmManagement.ConfirmProcess(
                                     StrSubstNo(Text002, xChangeLogSetupTable.FieldCaption("Log Insertion"), xChangeLogSetupTable."Log Insertion"), true)
                                then
                                    ChangeLogSetupTable.DelChangeLogFields(0); */
                        end;
                        ChangeLogSetupTableLogInsertio;
                    end;
                }
                field(LogModification; ChangeLogSetupTable."Log Modification")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Modification';
                    Editable = PageIsEditable;
                    Enabled = PageIsEditable;
                    OptionCaption = ' ,Some Fields,All Fields';
                    ToolTip = 'Specifies that any modification of data is logged.';

                    trigger OnAssistEdit()
                    begin
                        ChangeLogSetupTable.TestField("Log Modification", ChangeLogSetupTable."Log Modification"::"Some Fields");
                        AssistEdit;
                    end;

                    trigger OnValidate()
                    var
                        ConfirmManagement: Codeunit "Confirm Management";
                        NewValue: Option;
                    begin
                        /* if ChangeLogSetupTable."Table No." <> "Object ID" then begin
                            NewValue := ChangeLogSetupTable."Log Modification";
                            GetRec;
                            ChangeLogSetupTable."Log Modification" := NewValue;
                        end;

                        if xChangeLogSetupTable.Get(ChangeLogSetupTable."Table No.") then begin
                            if (xChangeLogSetupTable."Log Modification" = xChangeLogSetupTable."Log Modification"::"Some Fields") and
                               (xChangeLogSetupTable."Log Modification" <> ChangeLogSetupTable."Log Modification")
                            then
                                if ConfirmManagement.ConfirmProcess(
                                     StrSubstNo(Text002, xChangeLogSetupTable.FieldCaption("Log Modification"), xChangeLogSetupTable."Log Modification"), true)
                                then
                                    ChangeLogSetupTable.DelChangeLogFields(1);
                        end;
                        ChangeLogSetupTableLogModifica; */
                    end;
                }
                field(LogDeletion; ChangeLogSetupTable."Log Deletion")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Deletion';
                    Editable = PageIsEditable;
                    Enabled = false;
                    OptionCaption = ' ,Some Fields,All Fields';
                    ToolTip = 'Specifies that any deletion of data is logged.';

                    trigger OnAssistEdit()
                    begin
                        ChangeLogSetupTable.TestField("Log Deletion", ChangeLogSetupTable."Log Deletion"::"Some Fields");
                        AssistEdit;
                    end;

                    trigger OnValidate()
                    var
                        ConfirmManagement: Codeunit "Confirm Management";
                        NewValue: Option;
                    begin
                        /* if ChangeLogSetupTable."Table No." <> "Object ID" then begin
                            NewValue := ChangeLogSetupTable."Log Deletion";
                            GetRec;
                            ChangeLogSetupTable."Log Deletion" := NewValue;
                        end;

                        if xChangeLogSetupTable.Get(ChangeLogSetupTable."Table No.") then begin
                            if (xChangeLogSetupTable."Log Deletion" = xChangeLogSetupTable."Log Deletion"::"Some Fields") and
                               (xChangeLogSetupTable."Log Deletion" <> ChangeLogSetupTable."Log Deletion")
                            then
                                if ConfirmManagement.ConfirmProcess(
                                     StrSubstNo(Text002, xChangeLogSetupTable.FieldCaption("Log Deletion"), xChangeLogSetupTable."Log Deletion"), true)
                                then
                                    ChangeLogSetupTable.DelChangeLogFields(2);
                        end;
                        ChangeLogSetupTableLogDeletion; */
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action3)
            {
                action(Tables)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Tables';
                    Image = "Table";
                    ToolTip = 'View what must be logged for each table.';

                    trigger OnAction()
                    var
                        ChangeLogSetupList: Page "Changes Setup (Table) List";
                    begin

                        ChangeLogSetupList.SetSource;
                        ChangeLogSetupList.RunModal;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                actionref(Tables_Promoted; Tables)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageIsEditable := CurrPage.Editable;
    end;

    trigger OnAfterGetRecord()
    begin
        GetRec;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Object Type", Rec."Object Type"::Table);
        Rec.SetRange("Object ID", 0, 2000000000);
        Rec.FilterGroup(0);
    end;

    var
        ChangeLogSetupTable: Record "Changes Setup (Table)";
        xChangeLogSetupTable: Record "Changes Setup (Table)";
        PageIsEditable: Boolean;

    local procedure AssistEdit()
    var
        "Field": Record "Field";
        ChangeLogSetupFieldList: Page "Changes Setup (Field) List";
    begin
        Field.FilterGroup(2);
        Field.SetRange(TableNo, Rec."Object ID");
        Field.SetFilter(ObsoleteState, '<>%1', Field.ObsoleteState::Removed);
        Field.FilterGroup(0);
        ChangeLogSetupFieldList.SelectColumn(
  ChangeLogSetupTable."Log Insertion" = ChangeLogSetupTable."Log Insertion"::"Some Fields",
  ChangeLogSetupTable."Log Modification" = ChangeLogSetupTable."Log Modification"::"Some Fields",
  ChangeLogSetupTable."Log Deletion" = ChangeLogSetupTable."Log Deletion"::"Some Fields");
        ChangeLogSetupFieldList.SetTableView(Field);
        ChangeLogSetupFieldList.Run;
    end;

    local procedure UpdateRec()
    begin
        if (ChangeLogSetupTable."Log Insertion" = ChangeLogSetupTable."Log Insertion"::" ") and (ChangeLogSetupTable."Log Modification" = ChangeLogSetupTable."Log Modification"::" ") and
   (ChangeLogSetupTable."Log Deletion" = ChangeLogSetupTable."Log Deletion"::" ")
then begin
            if ChangeLogSetupTable.Delete then;
        end else
            if not ChangeLogSetupTable.Modify then
                ChangeLogSetupTable.Insert;
    end;

    local procedure GetRec()
    begin
        if not ChangeLogSetupTable.Get(Rec."Object ID") then begin
            ChangeLogSetupTable.Init;
            ChangeLogSetupTable."Table No." := Rec."Object ID";
        end;
    end;

    procedure SetSource()
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        Rec.DeleteAll;
        AllObjWithCaption.SetCurrentKey("Object Type", "Object ID");
        AllObjWithCaption.SetRange("Object Type", Rec."Object Type"::Table);
        //AllObjWithCaption.SETRANGE("Object ID",0,2000000006);
        AllObjWithCaption.SetRange("Object ID", 52140542);
        if AllObjWithCaption.Find('-') then
            repeat
                Rec := AllObjWithCaption;
                Rec.Insert;
            until AllObjWithCaption.Next = 0;
    end;

    local procedure ChangeLogSetupTableLogInsertio()
    begin
        UpdateRec;
    end;

    local procedure ChangeLogSetupTableLogModifica()
    begin
        UpdateRec;
    end;

    local procedure ChangeLogSetupTableLogDeletion()
    begin
        UpdateRec;
    end;
}




