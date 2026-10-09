namespace SaccoDatabase.SaccoDatabase;

using Microsoft.Sales.Customer;

page 50143 "Loans-Closed Account"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Caption = 'Loans-Closed Account';
    PageType = List;
    SourceTable = "Loans-Closed Account";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Old Account No."; Rec."Old Account No.")
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
                field(Gender; Rec.Gender)
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
                field("Product Description"; Rec."Product Description")
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
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payroll/Staff No."; Rec."Payroll/Staff No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = ShowIntAccrued;
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
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Insurance"; Rec."Outstanding Insurance")
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
                field("Last Pay Date"; Rec."Last Pay Date")
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
                field("Repayment Start Date"; Rec."Repayment Start Date")
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
                field("Recovery Mode"; Rec."Recovery Mode")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Options"; Rec."Interest Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mode of Disbursement"; Rec."Billing Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
        }

    }
    actions
    {
        area(navigation)
        {
            action("Monthly Remmittance")
            {
                Image = ServiceAccessories;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                RunObject = Page "Member Contribution";
                RunPageLink = "Application No." = FIELD("No.");
                ApplicationArea = All;
            }
            action(Charges)
            {
                Image = Travel;
                RunObject = Page "Application Charges Posted";
                RunPageLink = "Loan No." = field("No.");
                ApplicationArea = All;
            }

            action("Member Statement")
            {
                Caption = 'Account Statement';
                Image = TaskList;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                ApplicationArea = All;
                trigger OnAction()
                var

                begin

                end;
            }
        }
        area(Processing)
        {
            action(Post)
            {
                Image = PostedCreditMemo;
                Caption = 'Post Retrieval';
                ApplicationArea = All;
                trigger OnAction()
                var
                    LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                    TotGuarant: Decimal;
                    GenPostMngt: Codeunit "Gen.Jnl.+Preview";
                    OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
                    CredMngt: Codeunit "Credit Mgmt.";
                begin
                    Rec.OnRetrieveRecord(Rec, xRec, false);
                end;
            }
            action("Loan [File]")
            {
                Image = Category;
                ApplicationArea = All;
                trigger OnAction()
                var
                    FileName: Text;
                    NVInStream: InStream;
                    TempFile: File;
                    NewStream: InStream;
                    ToFileName: Variant;
                begin

                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Charges_Promoted; Charges)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Loan [File]_Promoted"; "Loan [File]")
                {
                }
                actionref("Member Statement_Promoted"; "Member Statement")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref("Monthly Remmittance_Promoted"; "Monthly Remmittance")
                {
                }
            }
            group(Category_Category10)
            {
                Caption = 'Preview Posting', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Gensetup: Record "General Set-Up";
    begin
        Gensetup.Get();
        ShowIntAccrued := false;
        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := ObjEmp.Name;
        EndDate := Today;
        StartDate := CalcDate('-CM', Today);
        IntDays := (EndDate - StartDate) + 1;

        case Gensetup."Interest Posting Method" of
            Gensetup."Interest Posting Method"::"Charge Daily":
                begin
                    ShowIntAccrued := true;
                end;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin


    end;

    var
        ObjEmp: Record Customer;
        ObjName: Text[150];
        PeriodAct: Codeunit "Periodic Activities Mgt.";
        StartDate: Date;
        EndDate: Date;
        IntDays: Integer;
        ShowIntAccrued: Boolean;
}
