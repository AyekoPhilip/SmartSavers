page 50120 "HR Setup"
{
    ApplicationArea = All;
    Caption = 'HR Setup';
    PageType = List;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    CardPageId = "HR Setup Page";
    SourceTable = "HR Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee Nos."; Rec."Employee Nos.")
                {
                    ToolTip = 'Specifies the value of the Employee Nos. field.';
                }
                field("Employee Requisition Nos."; Rec."Employee Requisition Nos.")
                {
                    ToolTip = 'Specifies the value of the Employee Requisition Nos. field.';
                }
                field("Hr Loan Nos."; Rec."Hr Loan Nos.")
                {
                    ToolTip = 'Specifies the value of the Hr Loan Nos. field.';
                }
                field("Job Application Nos."; Rec."Job Application Nos.")
                {
                    ToolTip = 'Specifies the value of the Job Application Nos. field.';
                }
                field("Job ID Nos."; Rec."Job ID Nos.")
                {
                    ToolTip = 'Specifies the value of the Job ID Nos. field.';
                }
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                    ToolTip = 'Specifies the value of the Leave Application Nos. field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
}
