page 50489 "Audit User Reviews"
{
    ApplicationArea = All;
    Caption = 'Audit User Reviews Credit';
    PageType = List;
    SourceTable = "Posted Approval Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
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
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver ID field.';
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Available Credit Limit (LCY) field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date-Time Sent for Approval field.';
                }
                field("Delegation Date Formula"; Rec."Delegation Date Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation Date Formula field.';
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
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Due Date field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date-Time Modified field.';
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By User ID field.';
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Limit Type field.';
                }
                field("New Entry No."; Rec."New Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Entry No. field.';
                }
                field("Number of Approved Requests"; Rec."Number of Approved Requests")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of Approved Requests field.';
                }
                field("Number of Rejected Requests"; Rec."Number of Rejected Requests")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Number of Rejected Requests field.';
                }
                field("Pending Approvals"; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pending Approvals field.';
                }
                field("Record ID to Approve"; Rec."Record ID to Approve")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Record ID to Approve field.';
                }
                field("Related to Change"; Rec."Related to Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Related to Change field.';
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salespers./Purch. Code field.';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sender ID field.';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sequence No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
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
                field("Workflow Step Instance ID"; Rec."Workflow Step Instance ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workflow Step Instance ID field.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
            }
        }
    }
}



