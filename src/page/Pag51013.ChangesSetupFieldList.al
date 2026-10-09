page 51013 "Changes Setup (Field) List"
{
    Caption = 'Changes Field CheckList';
    DataCaptionExpression = PageCaptionTxt;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Field";
    SourceTableView = WHERE(TableNo = CONST(52140542));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No.';
                    Editable = false;
                    Lookup = false;
                    ToolTip = 'Specifies the number of the field.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Field Caption';
                    DrillDown = false;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the caption of the field, that is, the name that will be shown in the user interface.';
                }
                field("Log Insertion"; LogIns)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Insertion';
                    Editable = PageIsEditable;
                    Enabled = false;
                    ToolTip = 'Specifies whether to log the insertion for the selected line on the change log.';

                    trigger OnValidate()
                    begin
                        if not InsVisible then begin
                            LogInsertionVisible := false;
                            Error(CannotChangeColumnErr);
                        end;
                        UpdateRec;
                    end;
                }
                field("Log Modification"; LogMod)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Modification';
                    Editable = PageIsEditable;
                    Enabled = PageIsEditable;
                    ToolTip = 'Specifies whether to log the modification for the selected line on the change log.';
                    Visible = LogModificationVisible;

                    trigger OnValidate()
                    begin

                        case Rec."No." of
                            1,
                            3,
                            4,
                            13,
                            20,
                            35,
                            31,
                            50001,
                            50002,
                            52140546,
                            52140547:
                                begin
                                    if LogMod then
                                        Error(CannotChangeColumnErr);
                                end
                        end;
                        UpdateRec;
                    end;
                }
                field("Log Deletion"; LogDel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Deletion';
                    Editable = PageIsEditable;
                    Enabled = false;
                    ToolTip = 'Specifies whether to log the deletion for the selected line on the change log.';

                    trigger OnValidate()
                    begin
                        if not DelVisible then begin
                            if Rec."No." = 1 then
                                //LogDeletionVisible := FALSE;
                                Error(CannotChangeColumnErr);
                        end;
                        UpdateRec;
                    end;
                }
                field(TableNo; Rec.TableNo)
                {
                    Caption = 'Table No.';
                    ApplicationArea = All;
                }
                field(TableName; Rec.TableName)
                {
                    Caption = 'Table Name';
                    ApplicationArea = All;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
                field(LogModF; LogModF)
                {
                    Caption = 'LogModF';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageIsEditable := CurrPage.Editable;
        GetRec;
        TransFromRec;
    end;

    trigger OnAfterGetRecord()
    begin
        GetRec;
        //TransFromRec;
    end;

    trigger OnInit()
    begin
        LogDeletionVisible := true;
        LogModificationVisible := true;
        LogInsertionVisible := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(Class, Rec.Class::Normal);
        Rec.FilterGroup(0);
        PageCaptionTxt := Format(Rec.TableNo) + ' ' + Rec.TableName;
        LogMod := false
    end;

    var
        ChangeLogSetupField: Record "Change Log Setup (Field)";
        CannotChangeColumnErr: Label 'You cannot change this column.';
        LogIns: Boolean;
        LogMod: Boolean;
        LogDel: Boolean;
        InsVisible: Boolean;
        ModVisible: Boolean;
        DelVisible: Boolean;
        
        LogInsertionVisible: Boolean;
        
        LogModificationVisible: Boolean;
        
        LogDeletionVisible: Boolean;
        PageCaptionTxt: Text[250];
        PageIsEditable: Boolean;
        LogModF: Boolean;

    procedure SelectColumn(NewInsVisible: Boolean; NewModVisible: Boolean; NewDelVisible: Boolean)
    begin
        InsVisible := NewInsVisible;
        ModVisible := NewModVisible;
        DelVisible := NewDelVisible;

        LogInsertionVisible := InsVisible;
        LogModificationVisible := ModVisible;
        LogDeletionVisible := DelVisible;
    end;

    local procedure UpdateRec()
    begin
        GetRec;
        TransToRec;
        if not (ChangeLogSetupField."Log Insertion" or ChangeLogSetupField."Log Modification" or ChangeLogSetupField."Log Deletion") then begin
            if ChangeLogSetupField.Delete then;
        end else
            if not ChangeLogSetupField.Modify then
                ChangeLogSetupField.Insert;
    end;

    local procedure GetRec()
    begin
        if not ChangeLogSetupField.Get(Rec.TableNo, Rec."No.") then begin
            ChangeLogSetupField.Init;
            ChangeLogSetupField."Table No." := Rec.TableNo;
            ChangeLogSetupField."Field No." := Rec."No.";
        end;
    end;

    local procedure TransFromRec()
    begin
        LogIns := ChangeLogSetupField."Log Insertion";
        LogMod := false;
        LogDel := ChangeLogSetupField."Log Deletion";
    end;

    local procedure TransToRec()
    begin
        ChangeLogSetupField."Log Insertion" := LogIns;
        ChangeLogSetupField."Log Modification" := LogMod;
        ChangeLogSetupField."Log Deletion" := LogDel;
    end;


    procedure fnGetRecord(RecRef: Record Member) AccNo: Code[20]
    begin
        AccNo := RecRef."No.";
        exit(AccNo);
    end;
}




