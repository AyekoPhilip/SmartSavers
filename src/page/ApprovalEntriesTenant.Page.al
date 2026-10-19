page 51080 "Approval Entries (Tenant)"
{
    ApplicationArea = All;
    Caption = 'Approval Entries (Tenant)';
    PageType = List;
    SourceTable = "Approval Entries";
    UsageCategory = Lists;
    Editable=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    InsertAllowed=false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Approval Code"; Rec."Approval Code")
                {
                    ToolTip = 'Specifies the value of the Approval Code field.';
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ToolTip = 'Specifies the value of the Approval Type field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ToolTip = 'Specifies the value of the Sequence No. field.';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ToolTip = 'Specifies the value of the Sender ID field.';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the value of the Approver ID field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ToolTip = 'Specifies the value of the Date-Time Sent for Approval field.';
                }
                field("Delegation Date Formula"; Rec."Delegation Date Formula")
                {
                    ToolTip = 'Specifies the value of the Delegation Date Formula field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Approval Due Date field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date-Time Modified field.';
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ToolTip = 'Specifies the value of the Last Modified By User ID field.';
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ToolTip = 'Specifies the value of the Limit Type field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ToolTip = 'Specifies the value of the Available Credit Limit (LCY) field.';
                }
            }
        }
    }
}
