page 50008 "Base Calender Change List"
{
    ApplicationArea = All;
    Caption = 'Base Calender Change List';
    PageType = List;
    SourceTable = "Base Calendar Change";
    UsageCategory = Lists;
    ModifyAllowed=false;
    DeleteAllowed=false;
    Editable=false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the base calendar in the entry.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date to change associated with the base calendar in this entry.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the day of the week associated with this change entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the change in this entry.';
                }
                field(Nonworking; Rec.Nonworking)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the date entry was defined as a nonworking day when the base calendar was set up.';
                }
                field("Recurring System"; Rec."Recurring System")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a date or day is a recurring nonworking day. It can be either Annual Recurring or Weekly Recurring.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }
}



