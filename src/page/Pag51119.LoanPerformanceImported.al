page 51119 "Loan Performance-Imported"
{
    ApplicationArea = All;
    Caption = 'Loan Performance-Imported';
    PageType = List;
    SourceTable = "Loans Categorization";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
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
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Product Description"; Rec."Product Description")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ToolTip = 'Specifies the value of the Requested Amount field.';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.';
                }
                field(Installments; Rec.Installments)
                {
                    ToolTip = 'Specifies the value of the Installments field.';
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ToolTip = 'Specifies the value of the Disbursement Account No. field.';
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    ToolTip = 'Specifies the value of the Loan Account field.';
                }
                field("Last Pay Date"; Rec."Last Pay Date")
                {
                    ToolTip = 'Specifies the value of the Last Pay Date field.';
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ToolTip = 'Specifies the value of the Performance Indicator field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportPackage)
            {
                Image = ImportExport;
                Enabled = false;
                Caption = 'Import Package';
                ApplicationArea = All;
                trigger OnAction()
                var
                    ConfigPackgt: Record "Config. Package";
                begin
                    ConfigPackgt.Reset();
                    ConfigPackgt.SetRange(Code, 'LNCATIMP');
                    if ConfigPackgt.FindFirst() then begin
                        Page.Run(Page::"Loan Config.Package", ConfigPackgt, ConfigPackgt.Code);
                    end else begin
                        Error('No Configuration Package related to this process found');
                    end;
                end;
            }

        }
        area(Reporting)
        {
            action(ViewSchedule)
            {
                Image = Report;
                Caption = 'View Schedule';
                ApplicationArea = All;
                trigger OnAction()
                var
                    CredMgt: Codeunit "Credit Mgmt.";
                    LoanRec: Record Loans;
                begin
                    LoanRec.Reset();
                    LoanRec.SetRange("No.", Rec."No.");
                    if LoanRec.FindFirst() then
                        Report.Run(Report::"Repayment Schedule-Loans", true, false, LoanRec);
                end;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(ImportPackage_Promoted; ImportPackage)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(ViewSchedule_Promoted; ViewSchedule)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Dividends', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
        }
    }
    var
        CredMngt: Codeunit "Credit Mgmt.";
}
