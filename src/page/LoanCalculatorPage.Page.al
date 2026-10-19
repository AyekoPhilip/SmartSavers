page 50295 "Loan Calculator Page"
{
    Caption = 'Loan Calculator Page';
    PageType = Card;
    DeleteAllowed = true;
    InsertAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    SourceTable = "Loan Calculator";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("CRM Application No."; Rec."CRM Application No.")
                {
                    Caption = 'CRM Application No.';
                    Editable = ApplicationEditables;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        CustMember: Record Member;
                    begin
                        MemberAge := Rec.getCustomerAge();
                    end;
                }
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Importance = Additional;
                    ApplicationArea = All;
                }

                field("Shares Banding"; Rec."Shares Banding")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Importance = Additional;
                    ApplicationArea = All;
                }

                field("Product Type"; Rec."Product Type")
                {
                    Editable = ApplicationEditable;
                    ApplicationArea = All;
                }

                field(Installments; Rec.Installments)
                {
                    Editable = ApplicationEditable;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Caption = 'Amount Applied';
                    Editable = ApplicationEditable;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Caption = 'Approved Amount';
                    Editable = true;
                    Visible = true;
                    Importance = Additional;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        if Rec.Repayment < xRec.Repayment then
                            Error(ErrorMessageOnRepayAmountTxt);
                    end;
                }
            }
            part(Control26; "Sal. Details Loan Calculator")
            {
                Caption = 'Salary Details';
                SubPageLink = "Loan Application No." = field("No."), "Client Code" = field("Account No.");
                ApplicationArea = All;
            }
            part(Control25; "Repayment Schedule")
            {
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Account No."),
                                             "Account Category" = const("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part("Banking History"; "Account Statistics FactBox")
            {
                Caption = 'Banking Statistics';
                SubPageLink = "Member No." = field("Account No.");
                SubPageView = where("Account Category" = const("Specialty Savings"));
                ApplicationArea = All;
            }

            part(Comment; "Loan Comment Line")
            {
                SubPageLink = "No." = field("Account No.");
                Caption = 'Comment Line';
                Visible = false;
            }
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                Visible = false;
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                Visible = false;
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Loan Payment Schedule")
            {
                Caption = 'Payment Schedule';
                Image = CalculateCost;
                RunObject = Page "Loan Payment Schedule";
                Visible = false;
                ApplicationArea = All;
            }
            action("Commitments Clearance")
            {
                Caption = ' Other Clearance';
                Image = Cost;
                RunObject = Page "Other Commitments Clearance";
                Visible = false;
                ApplicationArea = All;
            }
            action(Collateral)
            {
                Image = SocialSecurity;
                RunObject = Page "Collateral Registers";
                RunPageLink = "Account No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            action("Repayment  Schedule")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    PeriodItems.ApplicationDocPane(VarVariant, ActItems::RepaymentSchedule)
                end;
            }
            action("Loan Appraisal Report")
            {
                Caption = 'Loan Appraisal';
                Image = ReservationLedger;
                ApplicationArea = All;
                trigger OnAction()
                var
                    MultDep: Record "Deposit Multiplier";
                    Loan: Record Loans;
                    FactP: Record "Product Factory";
                    MultDeposit: Record "Deposit Multiplier";
                begin

                    VarVariant := Rec;
                    PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Loan Appraisal")
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
                    VarVariant := Rec;
                    CustomerMemb.SetRange("No.", Rec."Account No.");
                    if CustomerMemb.FindFirst() then
                        Report.Run(Report::"Member Analysis", true, false, CustomerMemb);

                end;
            }

            action("Member Dividend")
            {
                Caption = 'Dividend Statement';
                Image = ReservationLedger;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DivProg: Record "Dividend Progression";
                begin
                    DivProg.Reset();
                    DivProg.SetRange("Member No", Rec."Account No.");
                    if DivProg.FindFirst() then begin
                        Report.Run(Report::"Dividend Statement", true, false, DivProg);
                    end;
                end;
            }
            action("Comment Line")
            {
                Caption = 'Comment Line';
                Image = Comment;
                Visible = false;
                ApplicationArea = All;
                RunObject = page "Comment Sheet Line";
                RunPageLink = "No." = field("Account No.");
                trigger OnAction()
                var
                    CustomerMemb: Record Member;
                begin

                end;
            }
            action("Create Account")
            {
                Image = PrepaymentCreditMemo;
                Visible = false;
                ApplicationArea = All;
                Enabled = false;
                trigger OnAction()
                begin
                    VarVariant := Rec;
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Post Application")
                end;
            }
        }
        area(processing)
        {
            group(Action3)
            {
                Caption = 'Approvals';
                Image = HRSetup;
                Visible = false;
                group("Approval Requests")
                {
                    Caption = 'Approval Requests';
                    Image = HRSetup;
                    action(SendApprovalRequest)
                    {
                        Caption = 'Send A&pproval Request';
                        Enabled = NOT OpenApprovalEntriesExist;
                        Image = SendApprovalRequest;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            LoanApp: Record Loans;
                            ProdFac: Record "Product Factory";
                            LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                            TotGuarant: Decimal;
                        begin
                            Rec.TestField("Loan Status", Rec."Loan Status"::Appraisal);
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Send Approval Request");
                            CurrPage.Close();
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        Caption = 'Cancel Approval Re&quest';
                        Image = CancelApprovalRequest;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Cancel Approval Request");
                            CurrPage.Close();
                        end;
                    }
                    action(DefferApprovalRequest)
                    {
                        Caption = 'Deffer Approval Re&quest';
                        Image = DefaultFault;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            VarVariant := Rec;
                            CurrPage.Close();
                        end;
                    }
                    action("Open Document")
                    {
                        Image = Category;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Open Request");
                            CurrPage.Close();
                        end;
                    }
                    action(Approvals)
                    {
                        Caption = 'Approvals';
                        Image = Approval;
                        Visible = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147369);
                        end;
                    }
                }
            }
            group("Associated Items")
            {
                Caption = 'Associated Items';
                Image = ProductDesign;
                Visible = false;
                group(Items)
                {
                    Caption = 'Items';
                    Image = ExecuteBatch;
                    action("Loan History")
                    {
                        Image = History;
                        RunObject = Page "Loans List Posted";
                        Visible = true;
                        RunPageLink = "Account No." = field("Account No.");
                        ApplicationArea = All;
                    }
                    action("Member Statement")
                    {
                        Caption = 'Account Statement';
                        Image = TaskList;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            PLoan: Record "Collateral Register";
                            CustMembr: Record Member;
                        begin
                            CustMembr.RESET;
                            CustMembr.SETRANGE(CustMembr."No.", Rec."No.");
                            IF CustMembr.FIND('-') then
                                REPORT.RUN(Report::"Statement of Account", true, false, CustMembr);
                        end;
                    }
                    action("Loan [File]")
                    {
                        Image = Category;
                        ApplicationArea = All;
                        Visible = false;

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
                    action("Partial Disbursement")
                    {
                        Image = PutAwayWorksheet;
                        ApplicationArea = All;
                        Visible = false;
                        RunObject = page "Partial Disbursement Schedule";
                        RunPageLink = "Loan No." = field("No.");
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Mandatory Requirements")
                    {
                        Image = RegisteredDocs;
                        Visible = false;

                        RunObject = Page "Loan Required Documents";
                        ApplicationArea = All;
                    }
                }
            }
            group(Process)
            {
                Caption = 'Process';
                group("Process Item")
                {
                    Caption = 'Process Item';
                    Image = RegisteredDocs;
                    action("Loan Top Up")
                    {
                        Caption = 'Loan Refinance';
                        Image = AllocatedCapacity;
                        RunObject = Page "Loan Topup- Ln. Calculator";
                        RunPageLink = "No." = FIELD("No."),
                                      "Account No." = FIELD("Account No.");
                        ApplicationArea = All;
                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                        end;
                    }
                    action("Guarantors & Security")
                    {
                        Caption = 'Security';
                        Image = HRSetup;
                        RunObject = Page "Loan Guarantors and Security";
                        RunPageLink = "No." = FIELD("No."), "Member No. (Loanee)" = field("Account No.");
                        ApplicationArea = All;
                    }
                    action("Salary Details")
                    {
                        Image = StepOver;
                        Visible = true;
                        ApplicationArea = All;

                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(
                            VarVariant, ActItems::"Salary Details")
                        end;
                    }
                    action(Charges)
                    {
                        Image = Travel;
                        RunObject = Page "Loan Application Charges";
                        RunPageLink = "Application No." = FIELD("No.");
                        ApplicationArea = All;
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Loan Top Up_Promoted"; "Loan Top Up")
                {
                }
                actionref("Guarantors & Security_Promoted"; "Guarantors & Security")
                {
                }
                actionref("Salary Details_Promoted"; "Salary Details")
                {
                }
                actionref(Charges_Promoted; Charges)
                {
                }
                actionref("Loan Payment Schedule_Promoted"; "Loan Payment Schedule")
                {
                }
                actionref("Commitments Clearance_Promoted"; "Commitments Clearance")
                {
                }
                actionref(Collateral_Promoted; Collateral)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Repayment  Schedule_Promoted"; "Repayment  Schedule")
                {
                }
                actionref("Loan Appraisal Report_Promoted"; "Loan Appraisal Report")
                {
                }
                actionref("Member Analysis Report_Promoted"; "Member Analysis Report")
                {
                }
                actionref("Member Dividend_Promoted"; "Member Dividend")
                {
                }
                actionref("Comment Line_Promoted"; "Comment Line")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 3.';
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
                Caption = 'Associated Accounts', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref("Partial Disbursement_Promoted"; "Partial Disbursement")
                {
                }
                actionref("Create Account_Promoted"; "Create Account")
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(DefferApprovalRequest_Promoted; DefferApprovalRequest)
                {
                }
                actionref("Open Document_Promoted"; "Open Document")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;

        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := UpperCase(ObjEmp.Name);
        Rec."Disbursement Destination" := Rec."Disbursement Destination"::"Banking Account";
        Rec."Application Type" := Rec."Application Type"::"Loan Calculator";
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            Rec.Validate("Disbursement Date", Today);
        MemberAge := Rec.getCustomerAge();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        LoanAc.Reset;
        LoanAc.SetRange("Captured By", UserId);
        LoanAc.SetRange("Approval Status", LoanAc."Approval Status"::Open);
        LoanAc.SetRange("Application Type", LoanAc."Application Type"::"Loan Calculator");
        if LoanAc.Count > 2 then begin
            Error(ErrorOnMaxNoTransactions);
        end;

        Rec."Disbursement Destination" := Rec."Disbursement Destination"::"Banking Account";
        Rec."Application Type" := Rec."Application Type"::"Loan Calculator";
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            Rec.Validate("Disbursement Date", Today);
    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
        UpdateControls
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        ObjEmp: Record Customer;
        ObjName: Text[200];
        Temp: Record "User Setup";
        LoanAc: Record "Loan Application";
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
        PeriodItems: Codeunit "Credit Mgmt.";
        ActionPanesItem: Option Agreement,"Loan BuyOff","Salary Details",RepaymentSchedule,Statement,"Loan Appraisal","Loan History","Post Application",File,"Send Approval Request","Cancel Approval Request","Open Request",Approvals;
        ErrorMessageOnRepayAmountTxt: Label 'Repayment Amount cannot be less than minimum repayment of %1';
        ApplicationEditable: Boolean;
        ActItems: Enum ActionPanesItems;
        GeneralSetUp: Record "General Set-Up";
        ApplicationEditables: Boolean;
        MemberAge: Integer;
        HrDate: Codeunit "Date Conversion";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure UpdateControls()
    begin
        GeneralSetUp.Get;
        GeneralSetUp.TestField("Application Source (Loan)");
        case GeneralSetUp."Application Source (Loan)" of
            GeneralSetUp."Application Source (Loan)"::CRM:
                begin
                    ApplicationEditables := true;
                    ApplicationEditable := false;

                end;
            GeneralSetUp."Application Source (Loan)"::CBS:
                begin
                    ApplicationEditables := false;
                    ApplicationEditable := true;
                end;
        end
    end;
}



