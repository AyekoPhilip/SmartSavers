page 51096 "Temp. Files"
{
    ApplicationArea = All;
    Caption = 'Temp. Files';
    PageType = List;
    SourceTable = "Temp. Files";
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
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Installment Amount"; Rec."Installment Amount")
                {
                    ToolTip = 'Specifies the value of the Installment Amount field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }
}
