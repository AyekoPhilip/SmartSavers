namespace SaccoDatabase.SaccoDatabase;

page 50066 "Def. Loan List"
{
    ApplicationArea = All;
    CardPageID = "Loan Application Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Caption = 'Defaulter Loan List';
    PageType = List;
    SourceTable = "Loan Application";
    SourceTableView = where("Recovery Header No."=filter(<>''));
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ToolTip = 'Specifies the value of the Product Description field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ToolTip = 'Specifies the value of the Repayment Start Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ToolTip = 'Specifies the value of the Expected Date of Completion field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Recovery Header No."; Rec."Recovery Header No.")
                {
                    ToolTip = 'Specifies the value of the Recovery Header No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Defaulted Loan No."; Rec."Defaulted Loan No.")
                {
                    ToolTip = 'Specifies the value of the Defaulted Loan No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Type";Rec."Application Type")
                {
                    ToolTip = 'Specifies the value of the Application Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
    }
}
