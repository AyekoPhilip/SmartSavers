page 51089 "Stop Order List"
{
    ApplicationArea = All;
    Caption = 'Stop Order List';
    PageType = List;
    SourceTable = "Member Monthly Contribution";
    UsageCategory = Lists;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Application No."; Rec."Application No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Type"; Rec."Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Amount; Rec.Amount)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount Off"; Rec."Amount Off")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount off field.';
                }
                field("Advise Type"; Rec."Advise Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advise field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Loan Product Type"; Rec."Product Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Product Type field.';
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {

        }
        area(Navigation)
        {


        }
        area(Processing)
        {
            action("Generate Stop Order")
            {
                trigger OnAction()
                begin
                    Report.Run(Report::"Generate Stop Order Advise");
                end;
            }
        }
        area(Reporting)
        {
            action("Detailed Stop Order Advise")
            {
                trigger OnAction()
                begin
                    Report.Run(Report::"Detailed Cust. Advice Analysis");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Attachment', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Notification', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }
}
