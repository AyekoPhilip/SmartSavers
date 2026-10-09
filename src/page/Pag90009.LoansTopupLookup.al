namespace SaccoDatabase.SaccoDatabase;

page 90009 "Loans Topup Lookup"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Caption = 'Loans Topup Lookup';
    PageType = List;
    SourceTable = "Loans Top up";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ToolTip = 'Specifies the value of the Loan Top Up field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Type"; Rec."Application Type")
                {
                    ToolTip = 'Specifies the value of the Application Type field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ToolTip = 'Specifies the value of the Outstanding Bill field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Fee"; Rec."Outstanding Fee")
                {
                    ToolTip = 'Specifies the value of the Outstanding Fee field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
                {
                    ToolTip = 'Specifies the value of the Outstanding Insurance field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ToolTip = 'Specifies the value of the Outstanding Interest field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Principle"; Rec."Outstanding Principle")
                {
                    ToolTip = 'Specifies the value of the Outstanding Principle field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ToolTip = 'Specifies the value of the Outstanding Balance field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Untransfered Interest"; Rec."Untransfered Interest")
                {
                    ToolTip = 'Specifies the value of the Untransfered Interest field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Ignore Charges"; Rec."Ignore Charges")
                {
                    ToolTip = 'Specifies the value of the Ignore Charges field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Commision; Rec.Commision)
                {
                    ToolTip = 'Specifies the value of the Fee & Charges field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Outstanding Amount"; Rec."Total Outstanding Amount")
                {
                    ToolTip = 'Specifies the value of the Total Outstanding Amount field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Total Up"; Rec."Total Total Up")
                {
                    ToolTip = 'Specifies the value of the Total Total Up field.', Comment = '%';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
    }
}
