namespace AltChannelPostMgt.AltChannelPostMgt;

page 90004 "Rcv06 Loans Score Mgt."
{
    ApplicationArea = All;
    Caption = 'Loans Score Mgt.';
    PageType = List;
    SourceTable = "Rcv05 Loan (Score Mgt)";
    UsageCategory = Administration;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.', Comment = '%';
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Member No. field.', Comment = '%';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                    Caption='Last Pay Date';
                }
                
                field("Expected Completion Date"; Rec."Expected Completion Date")
                {
                    ToolTip = 'Specifies the value of the Expected Completion Date field.', Comment = '%';
                }
                field("Loan Paid on Time"; Rec."Loan Paid on Time")
                {
                    ToolTip = 'Specifies the value of the Loan Paid on Time field.', Comment = '%';
                }
            }
        }
    }
}
