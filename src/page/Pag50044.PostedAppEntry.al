page 50044 "Posted App. Entry"
{
    ApplicationArea = All;
    Caption = 'Posted App. Entry';
    PageType = List;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    SourceTable = "Posted Approval Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Code field.';
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Type field.';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sender ID field.';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver ID field.';
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Limit Type field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Due Date field.';
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By User ID field.';
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date-Time Modified field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date-Time Sent for Approval field.';
                }
            }
        }
    }
}



