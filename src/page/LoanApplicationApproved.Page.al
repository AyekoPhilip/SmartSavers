page 51032 "Loan Application Approved"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Loan Application";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Account No."; Rec."Account No.")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }

                field(Age; MemberAge)
                {
                    Style = StandardAccent;
                    Caption = 'Age';
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Total Balance"; Rec."Total Balance")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                }
                field("Shares Banding"; Rec."Shares Banding")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }

                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowCaption = false;
                }
                field("TopUp Loan"; Rec."TopUp Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                    Caption = 'Repayment Method';
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
                    Caption = 'Amount Applied';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Caption = 'Approved Amount';
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Amount to Disburse"; Rec."Amount to Disburse")
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    Caption = 'Recommended Amount';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
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
                field("Interest Repayment"; Rec."Interest Repayment")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Accrued Interest"; Rec."Accrued Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }


                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    Editable = false;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    Editable = false;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Sectors; Rec.Sectors)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Sub Sectors"; Rec."Sub Sectors")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Purpose of Loan"; Rec."Purpose of Loan")
                {
                    Visible = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Deposit Purchase"; Rec."Deposit Purchase")
                {
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Deposit Purchase Account"; Rec."Deposit Purchase Account")
                {
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Loan Rejection Reason"; Rec."Loan Rejection Reason")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Self Guarantee"; Rec."Self Guarantee")
                {
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
            group("Batch Information")
            {
                Caption = 'Batch Information';
                Editable = false;
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;

                }
                field("Payment Destination"; Rec."Payment Destination")
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field(CustBankName; CustBankName)
                {
                    ShowCaption = false;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Disbursement Date"; Rec."Disbursement Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disbursement Destination"; Rec."Disbursement Destination")
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
                field("Loan Account"; Rec."Loan Account")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Total TopUp"; Rec."Total TopUp")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                field("Check Line"; Rec."Check Line")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Minute; Rec.Minute)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Minute No.';
                }
                field("Charge Interest on Posting"; Rec."Charge Interest on Posting")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;

                }
                field("Repayment Mode"; Rec."Repayment Mode")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                }
                field("Appraisal Parameter Type"; Rec."Appraisal Parameter Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Captured By"; Rec."Captured By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            systempart(Control29; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control51; MyNotes)
            {
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
            action(Collateral)
            {
                Image = SocialSecurity;
                Visible = false;
                RunObject = Page "Collateral Registers";
                RunPageLink = "Account No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Repayment  Schedule")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    PeriodItems.ApplicationDocPane(
                    VarVariant, ActItems::RepaymentSchedule)
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
                    PeriodItems.ApplicationDocPane(
                    VarVariant, ActItems::"Loan Appraisal")
                end;
            }
            action("Mark as Posted")
            {
                Caption = 'Mark as Posted';
                Image = ReservationLedger;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocMngt: Codeunit "Doc. Mngt";
                    LoanApplic: Record "Loan Application";
                    TellerMngt: Codeunit "Teller-Post (Yes/No)";
                    Loans: Record Loans;

                begin
                    if Rec."TopUp Loan" <> '' then begin
                        if TellerMngt.TestExtDocNoEntriesExist(Rec."Account Name", Rec."No.", 0) then begin
                            Rec."Posted By" := UserId;
                            Rec."Date Posted" := Today;
                            Rec."Time Posted" := Time;
                            Rec."Loan Status" := Rec."Loan Status"::Issued;
                            Rec."Approval Status" := Rec."Approval Status"::Posted;
                            Rec.Modify;
                        end;
                    end else begin

                        Loans.Reset();
                        Loans.SetRange("Application No.", Rec."No.");
                        if Loans.FindFirst() then begin

                            if TellerMngt.TestNoEntriesExist(Rec."Account Name", Loans."No.", 0) then begin
                                Rec."Posted By" := UserId;
                                Rec."Date Posted" := Today;
                                Rec."Time Posted" := Time;
                                Rec."Loan Status" := Rec."Loan Status"::Issued;
                                Rec."Approval Status" := Rec."Approval Status"::Posted;
                                Rec.Modify;
                                Message('Loan Entry marked as Posted');
                            end;
                        end;
                    end;
                end;
            }
            action(Statement)
            {
                Caption = 'Statement';
                Image = CustomerGroup;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Account No.");
                    IF CustMembr.Find('-') then
                        Report.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;
            }
            action("Loan History")
            {
                Image = History;
                RunObject = Page "Loans List Posted";
                Visible = true;
                RunPageLink = "Account No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Member Page")
            {
                Image = Customer;
                Caption = 'Member';
                RunObject = Page "Membership Individual";
                Visible = true;
                RunPageLink = "No." = field("Account No.");
                ApplicationArea = All;
            }
            action("Member Dividend")
            {
                Caption = 'Dividend Statement';
                Image = ReservationLedger;
                Visible = false;
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
                ApplicationArea = All;
                trigger OnAction()
                var
                    GenPostMngt: Codeunit "Gen.Jnl.+Preview";
                    CredMngt: Codeunit "Credit Mgmt.";
                    LoansRec: Record Loans;
                begin
                    if Rec."TopUp Loan" = '' then begin
                        Rec.OnBeforeDocPostMgtLoanRegistration(Rec, 0);
                    end else begin
                        LoansRec.Reset();
                        LoansRec.SetRange("No.", Rec."TopUp Loan");
                        if LoansRec.FindFirst() then begin
                            LoansRec.OnBeforeValidatePerformPostOnLoansPostMgt(LoansRec, 0);
                        end;
                    end;
                end;
            }
            action("Agreement Form")
            {
                Image = Receipt;
                ApplicationArea = All;
                Enabled = true;
                trigger OnAction()
                var
                    LnApplic: Record "Loan Application";
                    AggreemtForm: Report "Loan Agreement Form";
                begin
                    LnApplic.Reset();
                    LnApplic.SetRange("No.", Rec."No.");
                    if LnApplic.FindFirst() then
                        Report.Run(Report::"Loan Agreement Form", true, false, LnApplic);
                end;
            }
        }
        area(processing)
        {
            group(Action3)
            {
                Caption = 'Approvals';
                Image = HRSetup;
                group("Approval Requests")
                {
                    Caption = 'Approval Requests';
                    Image = HRSetup;
                    action(SendApprovalRequest)
                    {
                        Caption = 'Send A&pproval Request';
                        Enabled = NOT OpenApprovalEntriesExist;
                        Image = SendApprovalRequest;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            LoanApp: Record Loans;
                            ProdFac: Record "Product Factory";
                            LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                            TotGuarant: Decimal;
                        begin

                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Send Approval Request");
                            CurrPage.Close();
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        Caption = 'Cancel Approval Re&quest';
                        Image = CancelApprovalRequest;
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
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            VarVariant := Rec;
                            ApprovalsMgmt.OnDefferLoanApplicationApprovalRequest(Rec, true, true);
                            CurrPage.Close();
                        end;
                    }
                    action("Open Document")
                    {
                        Image = Category;
                        Caption = 'Open Approval Request';
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Open Request");
                            CurrPage.Close();
                        end;
                    }
                    action("Reject Application")
                    {
                        Image = Reject;
                        Caption = 'Reject Approval Request';
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprvlsMngt: Codeunit "Approval Mgmt.";
                            ApprovalEntries: Record "Approval Entries";
                        begin
                            ApprvlsMngt.RejectApprovalApplication(Rec."No.");
                            CurrPage.Close();
                        end;
                    }
                    action(Approvals)
                    {
                        Caption = 'Approvals';
                        Image = Approval;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50554);
                        end;
                    }
                }
            }
            group("Associated Items")
            {
                Caption = 'Associated Items';
                Image = ProductDesign;
                group(Items)
                {
                    Caption = 'Items';
                    Image = ExecuteBatch;

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
                    action("External Payments")
                    {
                        Image = StepInto;
                        Caption = 'External Payment';
                        Visible = true;
                        RunObject = page "External Commitments";
                        RunPageLink = "Application No." = field("No.");
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Mandatory Requirements")
                    {
                        Image = RegisteredDocs;

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
                        Enabled = Rec."TopUp Loan" = '';
                        RunObject = Page "Loan Top Up";
                        RunPageLink = "No." = FIELD("No."),
                                      "Account No." = FIELD("Account No.");
                        ApplicationArea = All;
                        trigger OnAction()
                        begin
                            VarVariant := Rec;
                            PeriodItems.ApplicationDocPane(
                            VarVariant, ActItems::"Loan BuyOff")
                        end;
                    }
                    action("Loan Liquidation")
                    {
                        Caption = 'Loan Liquidation';
                        Image = AllocatedCapacity;
                        Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                        RunObject = Page "Loan Liquidation";
                        RunPageLink = "No." = field("No."), "Account No." = field("Account No.");
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

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
                    action("External Commitments")
                    {
                        Image = StepInto;
                        Visible = true;
                        RunObject = page "Other Commitments Clearance";
                        RunPageLink = "Application No." = field("No.");
                        ApplicationArea = All;

                        trigger OnAction()
                        begin

                        end;
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
                    action("Salary Statistics")
                    {
                        Image = StepOut;
                        Visible = true;
                        ApplicationArea = All;
                        RunObject = page "Appraisal Salary Statistics";
                        RunPageLink = "No." = field("No.");
                        trigger OnAction()

                        begin

                        end;
                    }
                    action(Charges)
                    {
                        Image = Payment;
                        RunObject = Page "Charge Details";
                        RunPageLink = "No." = field("No.");
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
                actionref("External Commitments_Promoted"; "External Commitments")
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
                actionref(Collateral_Promoted; Collateral)
                {
                }
                actionref("Loan Liquidation_Promoted"; "Loan Liquidation")
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
                actionref("Mark as Posted_Promoted"; "Mark as Posted")
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
                actionref("Member Dividend_Promoted"; "Member Dividend")
                {
                }
                actionref("Comment Line_Promoted"; "Comment Line")
                {
                }
                actionref("Agreement Form_Promoted"; "Agreement Form")
                {
                }
                actionref("Loan History_Promoted"; "Loan History")
                {
                }
                actionref("Member Page_Promoted"; "Member Page")
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

                actionref("Create Account_Promoted"; "Create Account")
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 8.';

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
                actionref("Reject Application_Promoted"; "Reject Application")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref("External Payments_Promoted"; "External Payments")
                {
                }
                actionref("Salary Statistics_Promoted"; "Salary Statistics")
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
    var
        LoanApp: Record "Loan Application";
    begin
        SetControlAppearance;

        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := UpperCase(ObjEmp.Name);
        Rec."Application Type" := Rec."Application Type"::Normal;
        MemberAge := Rec.getCustomerAge();
        CustBankName := '';

        case Rec."Loan Payment Destination" of
            Rec."Loan Payment Destination"::"Bank Account":
                begin
                    CustBank.Reset();
                    CustBank.SetRange(Code, Rec."Payment Destination Code");
                    if CustBank.FindFirst() then
                        CustBankName := CustBank.Name
                end;
            Rec."Loan Payment Destination"::Supplier:
                begin
                    if Vend.Get(Rec."Payment Destination Code") then
                        CustBankName := Vend.Name

                end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        LoanAc.Reset;
        LoanAc.SetRange("Captured By", UserId);
        LoanAc.SetRange("Approval Status", LoanAc."Approval Status"::Open);
        if LoanAc.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnMaxNoTransactions);
        end;
        Rec."Application Type" := Rec."Application Type"::Normal
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ResponseTxt: Integer;
        VarVariant: Variant;
        CustBankName: Text[150];
        Vend: Record Vendor;
        ObjEmp: Record Customer;
        CustBank: Record "Cust. Bank Account";
        ActItems: Enum ActionPanesItems;
        MemberAge: Integer;
        ObjName: Text[200];
        Temp: Record "User Setup";
        LoanAc: Record "Loan Application";
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
        PeriodItems: Codeunit "Credit Mgmt.";
        ActionPanesItem: Option Agreement,"Loan BuyOff","Salary Details",RepaymentSchedule,Statement,"Loan Appraisal","Loan History","Post Application",File,"Send Approval Request","Cancel Approval Request","Open Request",Approvals;
        ErrorMessageOnRepayAmountTxt: Label 'Repayment Amount cannot be less than minimum repayment of %1';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Generate Batch,&Post Application';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 2 then
            DefaultOption := 2;
        if DefaultOption <= 0 then
            DefaultOption := 0;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to Post');
        PassInt := Selection;

        if Selection = 0 then
            exit;
        exit(PassInt);
    end;
}




