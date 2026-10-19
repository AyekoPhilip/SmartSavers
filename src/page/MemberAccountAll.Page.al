page 51113 "Member Account (All)"
{
    ApplicationArea = All;
    Caption = 'Member Account (All)';
    PageType = List;
    SourceTable = "Member Account (All)";
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Old Member No."; Rec."Old Member No.")
                {
                    ToolTip = 'Specifies the value of the Old Member No. field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Member Category"; Rec."Member Category")
                {
                    ToolTip = 'Specifies the value of the Member Category field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ToolTip = 'Specifies the value of the Employer Code field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ToolTip = 'Specifies the value of the Payroll/Staff No. field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ToolTip = 'Specifies the value of the Registration Date field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Shares Capital"; Rec."Shares Capital")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Specialty Savings"; Rec."Specialty Savings")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Caption = 'School Fee Savings';
                    Style = StandardAccent;

                }
                field("Total Savings"; Rec."Total Savings")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;

                }
                field("Global Dimension 1 Code";Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;

                }

            }
        }
    }
    actions
    {
        area(Reporting)
        {
            group(Action37)
            {
                Caption = 'Statement';
                action("Loan Statement")
                {
                    Image = ServiceOrderSetup;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CustMembr: Record Member;
                    begin
                        CustMembr.Reset();
                        CustMembr.SetRange("No.", Rec."No.");
                        if CustMembr.Find('-') then
                            Report.Run(Report::"Standard Statement-Loans", true, false, CustMembr);
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
                        CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                        IF CustMembr.FIND('-') then
                            Report.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                    end;
                }
                action("Member Analysis Report")
                {
                    Caption = 'Statement of Quotation';
                    Image = ReservationLedger;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        CustomerMemb: Record Member;
                    begin
                        VarVariant := Rec;
                        CustomerMemb.SetRange("No.", Rec."No.");
                        if CustomerMemb.FindFirst() then
                            Report.Run(Report::"Member Analysis", true, false, CustomerMemb);
                    end;
                }
            }

        }
        area(Navigation)
        {
            group(Accounts)
            {
                Caption = 'Accounts';
                action("Member Statistics")
                {
                    Image = StatisticsGroup;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Varvariant := Rec;
                        DocMngt.DocPrintstatement(Varvariant, 3)
                    end;
                }
                action("Accounts Banking")
                {
                    Image = Capacity;
                    RunObject = Page "Savings Account List";
                    RunPageLink = "Member No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Accounts Credit")
                {
                    Image = ChangeBatch;
                    RunObject = Page "Account Credit List";
                    RunPageLink = "Member No." = FIELD("No.");
                    ApplicationArea = All;
                }
                action("Repayment Account")
                {
                    Image = CashFlowSetup;
                    RunObject = Page "Savings Account List";
                    RunPageLink = "Member No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }

        }
        area(Processing)
        {
            action("Generate Accounts")
            {
                Image = CashFlowSetup;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Report.Run(Report::"Sacco Regulatory (Form 3B)");
                end;
            }
            action("Generate Form 3")
            {
                Image = HRSetup;
                Caption = 'Generate Form 3B';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Report.Run(Report::"Gen. Regulatory Form 3B");
                end;
            }


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Generate Accounts_Promoted"; "Generate Accounts")
                {
                }
                actionref("Generate Form 3_Promoted"; "Generate Form 3")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Loan Statement_Promoted"; "Loan Statement")
                {
                }
                actionref(Statement_Promoted; Statement)
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
                Caption = 'Dividends', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Advice', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }

    }
    var
        VarVariant: Variant;
        DocMngt: Codeunit "Doc. Mngt";
}
