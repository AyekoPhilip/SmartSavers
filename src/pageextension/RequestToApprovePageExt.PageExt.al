pageextension 50025 "Request To Approve Page Ext" extends "Requests to Approve"
{
    layout
    {
        modify(Details)
        {
            Visible = false;
        }
        addafter(ToApprove)
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field';
            }
        }
        addlast(Control1)
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document No. field';
            }
            field("Document Type"; Rec."Document Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Type field';
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approver ID field';
            }
        }
    }
}


