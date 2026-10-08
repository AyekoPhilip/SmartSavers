page 50427 "Loan-Performance Indicator"
{
    ApplicationArea = All;
    Caption = 'Loan-Performance Indicator';
    PageType = List;
    SourceTable = "Loans Categorization";
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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Payroll/Staff No. field.';

                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Approved Amount field.';
                }

                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Product Type field.';
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Product Type field.';

                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Installments field.';
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("OverDue Date"; Rec."OverDue Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Next Installment Date"; Rec."Next Installment Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Expected Date of Completion field.';
                }
                field("Last Pay Date"; Rec."Last Pay Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Last Pay Date field.';
                }

                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Repayment field.';
                }

                field("Days in Arrears"; Rec."Days in Arrears")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Amount In Arrears"; Rec."Amount In Arrears")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Outstanding Interest";Rec."Outstanding Interest")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Outstanding Principal";Rec."Outstanding Principal")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Outstanding Balance";Rec."Outstanding Balance")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Performance Indicator field.';
                }


            }
        }
        area(FactBoxes)
        {
            part(LoanFactBox; "Loan Performance FactBox")
            {
                Caption = 'Performance Factbox';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;

            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Update Loans")
            {
                Image = UpdateShipment;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin
                    Report.Run(Report::"Gen. Loan Categorization");
                end;
            }
            action("Generate Arrears")
            {
                Image = Relatives;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin
                    Report.Run(Report::"Generate Loan Arrears");
                end;
            }
            action(GenerateArrears)
            {
                Image = Excel;
                Caption = 'Create Excel File';
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempFile: File;
                    Name: Text[250];
                    NewStream: InStream;
                    ToFile: Text[250];
                    ReturnValue: Boolean;
                    OutS: OutStream;
                    GenerateLoanArrears: Report "Generate Loan Arrears";
                    TempBlob: Codeunit "Temp Blob";
                begin
                    TempBlob.CreateOutStream(OutS);
                    if GenerateLoanArrears.SaveAs('', ReportFormat::Excel, OutS) then begin
                        TempBlob.CreateInStream(NewStream);
                        ReturnValue := DownloadFromStream(
                    NewStream, 'Save file to client',
                    '', 'Excel File *.xls| *.xls',
                    ToFile);
                    end;
                end;
            }

            action("Repayment  Schedule")
            {
                Image = PrintCheck;
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
            action("Member Statistics")
            {
                Image = StatisticsGroup;
                RunObject = Page "Member Statistics";
                RunPageLink = "No." = FIELD("Account No.");
                ApplicationArea = All;
                trigger OnAction()
                begin

                end;
            }
            action("Accounts Banking")
            {
                Image = Capacity;
                RunObject = Page "Savings Account List";
                RunPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            action("Accounts Credit")
            {
                Image = ChangeBatch;
                RunObject = Page "Account Credit List";
                RunPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
        }
        area(Reporting)
        {
            action(Loans)
            {
                Image = SetupColumns;
                ApplicationArea = All;

                trigger OnAction()
                Var
                    CustMembr: Record Member;
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", Rec."Account No.");
                    IF CustMembr.FIND('-') THEN
                        REPORT.RUN(Report::"Statement of Account-Loan", TRUE, FALSE, CustMembr);
                end;
            }
            action("Loans Detailed")
            {
                Image = ServiceOrderSetup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", Rec."Account No.");
                    IF CustMembr.FIND('-') THEN
                        REPORT.RUN(Report::"Statement-Loans", TRUE, FALSE, CustMembr);
                end;
            }
            action(Statement)
            {
                Caption = 'Detailed Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", Rec."Account No.");
                    IF CustMembr.FIND('-') then
                        REPORT.RUN(Report::"Statement of Account", true, false, CustMembr);
                end;
            }
            action("Loans Guaranteed")
            {
                Caption = 'Guarateed Loan Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.RESET;
                    CustMembr.SETRANGE(CustMembr."No.", Rec."Account No.");
                    IF CustMembr.FIND('-') then
                        REPORT.RUN(Report::"Member Loan Guaranteed", true, false, CustMembr);
                end;
            }
            action("Loan Guarantors")
            {
                Caption = 'Guarantor Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PLoan: Record Loans;
                begin
                    PLoan.Reset();
                    PLoan.SetRange("Account No.", Rec."Account No.");
                    if PLoan.Find('-') then
                        Report.Run(Report::"Member Loan Guarantors", true, false, PLoan);
                end;
            }

        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Repayment  Schedule_Promoted"; "Repayment  Schedule")
                {
                }
                actionref(Loans_Promoted; Loans)
                {
                }
                actionref("Loans Detailed_Promoted"; "Loans Detailed")
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
                actionref("Loans Guaranteed_Promoted"; "Loans Guaranteed")
                {
                }
                actionref("Loan Guarantors_Promoted"; "Loan Guarantors")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Update Loans_Promoted"; "Update Loans")
                {
                }
                actionref("Generate Arrears_Promoted"; "Generate Arrears")
                {
                }
                actionref(GenerateArrears_Promoted; GenerateArrears)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
                actionref("Accounts Banking_Promoted"; "Accounts Banking")
                {
                }
                actionref("Accounts Credit_Promoted"; "Accounts Credit")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Dividends', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }

    }
}



