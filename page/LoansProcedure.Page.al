page 50024 "Loans Procedure"
{

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loans (Procedure)";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Account"; Rec."Loan Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Interest Posting Date"; Rec."Interest Posting Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Available Balance"; Rec."Available Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Outstanding Bill"; Rec."Outstanding Bill")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Deduction Status"; Rec."Deduction Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }

                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control12; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control13; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Accounts)
            {
                Caption = 'Accounts';
                action("Member Statistics")
                {
                    Image = StatisticsGroup;
                    ApplicationArea = All;
                    RunObject = Page "Member Statistics";
                    RunPageLink = "No." = FIELD("Account No.");
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
                action("Repayment Account")
                {
                    Image = CashFlowSetup;
                    RunObject = Page "Savings Account List";
                    RunPageLink = "Member No." = FIELD("Account No.");
                    ApplicationArea = All;
                }
                action("Loan History")
                {
                    Image = History;
                    RunObject = Page "Loans List Posted";
                    Visible = true;
                    RunPageLink = "Account No." = field("Account No.");
                    ApplicationArea = All;
                }

            }
        }
        area(Processing)
        {
            group(Process)
            {

                action("GenerateEntries")
                {
                    Image = Category;
                    Caption = 'Generate Entries';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Report.Run(Report::"Generate QC. Loan Entry");
                    end;
                }
                action("Post+Print")
                {
                    Image = CustomerGroup;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Report.Run(Report::"Alt. Channel Jnl. Post");
                    end;
                }

            }
        }
        area(reporting)
        {

            group(Action37)
            {
                Caption = 'Reports';
                action("GenerateDefaultEntries")
                {
                    Image = Category;
                    Caption = 'Generate Defaulter Entries';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Report.Run(Report::"Generate QC. Loan Entry");
                    end;
                }
                action("Clear Entries")
                {
                    Image = CustomerGroup;

                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        LoansProcedure: Record "Loans (Procedure)";

                    begin
                        LoansProcedure.SetRange(Posted, false);
                        LoansProcedure.DeleteAll();
                    end;
                }
                action("Account Statement")
                {
                    Image = CustomerGroup;
                    Visible = false;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Loan Statement (Summary)")
                {
                    Image = ServiceMan;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                    end;
                }
                action("Loan Statement (Detailed)")
                {
                    Image = ShowMatrix;
                    Visible = false;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin

                    end;
                }
                action("Member Analysis Report")
                {
                    Caption = 'Member Analysis';
                    Image = ReservationLedger;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        CustomerMemb: Record Member;
                    begin
                        CustomerMemb.SetRange("No.", Rec."Account No.");
                        if CustomerMemb.FindFirst() then
                            Report.Run(Report::"Member Analysis", true, false, CustomerMemb);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(GenerateEntries_Promoted; GenerateEntries)
                {
                }
                actionref("Post+Print_Promoted"; "Post+Print")
                {
                }
                actionref(GenerateDefaultEntries_Promoted; GenerateDefaultEntries)
                {
                }
                actionref("Clear Entries_Promoted"; "Clear Entries")
                {
                }
                actionref("Account Statement_Promoted"; "Account Statement")
                {
                }
                actionref("Loan Statement (Summary)_Promoted"; "Loan Statement (Summary)")
                {
                }
                actionref("Loan Statement (Detailed)_Promoted"; "Loan Statement (Detailed)")
                {
                }
                actionref("Member Analysis Report_Promoted"; "Member Analysis Report")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Accounts Banking_Promoted"; "Accounts Banking")
                {
                }
                actionref("Accounts Credit_Promoted"; "Accounts Credit")
                {
                }
                actionref("Repayment Account_Promoted"; "Repayment Account")
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
                Caption = 'Notices', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Attachments', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }
}


