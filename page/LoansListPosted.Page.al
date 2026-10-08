page 51037 "Loans List Posted"
{
    CardPageID = Loans;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Loans;
    SourceTableView = where("Approval Status" = const(Posted));
    ApplicationArea = All;
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
                field("Schedule  Repayment";Rec."Schedule  Repayment")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Schedule Interest";Rec."Schedule Interest")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Average Payment";Rec."Average Payment")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
               field("Sasra Category";Rec."Sasra Category")
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
                field("Outstanding Interest"; Rec."Outstanding Interest")
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
                field("Total Schedule Repayment"; Rec."Total Schedule Repayment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amount in Arrears"; Rec."Amount in Arrears")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Days in Arrears";Rec."Days in Arrears")
                {
                     ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Months In arrears"; Rec."Months In arrears")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Dimension"; Rec."Product Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
        }
        area(FactBoxes)
        {
            part(LoanFactBox; "Loan Performance FactBox")
            {
                Caption = 'Loan Factbox';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Associated Account', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
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
                    Rec."Accrued Interest" := PeriodAct.fnIntEntriesonSpecificLoan(Rec, Today, Rec."No.", 1, IntDays, StartDate);
                    Rec.Modify(true);
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




