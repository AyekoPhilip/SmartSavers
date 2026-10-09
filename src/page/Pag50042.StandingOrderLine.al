page 50042 "Standing Order Line"
{
    ApplicationArea = All;
    Caption = 'Standing Order Line';
    PageType = List;
    SourceTable = "Standing Order Lines";
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Selected. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Destination Account Type"; Rec."Destination Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Destination Account Type field.';
                }
                field("Destination Account No."; Rec."Destination Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Destination Account No. field.';
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Member No. field.';
                }
                field("Destination Account Name"; Rec."Destination Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Destination Account Name field.';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount LCY field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}



