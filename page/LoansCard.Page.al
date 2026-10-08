page 51027 "Loans Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Loans;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = true;
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
                field(MemberAge; MemberAge)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Importance = Additional;
                    ApplicationArea = All;
                    Caption = 'Age';

                }
                field(LoanBal; LoanBal)
                {
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = TRUE;
                    Importance = Additional;
                    ApplicationArea = All;
                    Caption = 'Total Loan Balance';

                }
                field(SharesBanding; SharesBanding)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                    Caption = 'Shares Banding';

                }
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;

                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                    Caption = 'Repayment Method';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Caption = 'Amount Applied';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Caption = 'Approved Amount';
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Amount to Post"; Rec."Amount to Post")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Amount Disbursed"; Rec."Total Amount Disbursed")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(DisburseBal; DisburseBal)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Remaining Disbursement';

                }
                field("Amount to Disburse"; Rec."Amount to Disburse")
                {
                    Style = StandardAccent;
                    Caption = 'Net Take Home';
                    StyleExpr = true;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    Caption = 'Recommended Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        if Rec.Repayment < xRec.Repayment then
                            Error(ErrorMessageOnRepayAmountTxt);
                    end;
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Importance = Additional;
                    ApplicationArea = All;
                }

                field(Remarks; Rec.Remarks)
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Self Guarantee"; Rec."Self Guarantee")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
            }
            group("Savings & Purchase")
            {
                Editable = true;
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
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Deposit Purchase"; Rec."Deposit Purchase")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Deposit Purchase Account"; Rec."Deposit Purchase Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Loan Rejection Reason"; Rec."Loan Rejection Reason")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
            group("Batch Information")
            {
                Caption = 'Payment Information';
                Editable = True;
                field("Post Application As"; Rec."Post Application As")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Cheque Types"; Rec."Cheques Type")
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
                field("Cheque Option"; Rec."Cheque Option")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Loan Payment Destination"; Rec."Loan Payment Destination")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ApplicationArea = All;

                }
                field("Disbursement Destination"; Rec."Disbursement Destination")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("External Payment"; Rec."External Payment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Enabled = Rec."Cheque Option" = Rec."Cheque Option"::"Multiple Cheque";
                }
                field("Total Charges"; Rec."Total Charges")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
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
            group("Individual Cheque")
            {

                Visible = Rec."Cheque Option" = Rec."Cheque Option"::"Individual Cheque";
                Editable = Rec."Approval Status" = Rec."Approval Status"::Approved;
                field("Cheque Type"; Rec."Cheques Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Payment Destination"; Rec."Payment Destination")
                {
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Disbursement Account No."; Rec."Disbursement Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Loan Account"; Rec."Loan Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
            part(Control10; "External Committment Listpart")
            {
                Caption = 'External Payment';
                Visible = Rec."Cheque Option" = Rec."Cheque Option"::"Multiple Cheque";
                Editable = Rec."Approval Status" = Rec."Approval Status"::Approved;
                SubPageLink = "Loan No." = field("No.");
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                Editable = true;


                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(AccruedInt; AccruedInt)
                {
                    Caption = 'Accrued Interest';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    Importance = Additional;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field("Repayment Mode"; Rec."Repayment Mode")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
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
                    StyleExpr = TRUE;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Captured By"; Rec."Captured By")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Time Created"; Rec."Time Created")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
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
        }
    }

    actions
    {
        area(navigation)
        {
            action("Loan Application Card")
            {
                Caption = 'Application Card';
                Image = CalculateCost;
                RunObject = Page "Loan Application Card";
                RunPageLink = "No." = field("Application No.");
                ApplicationArea = All;
            }
            action("Partial Disbursement")
            {
                Image = PutAwayWorksheet;
                Visible = true;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                ApplicationArea = All;
                RunObject = page "Partial Disbursement Schedule";
                RunPageLink = "Loan No." = field("No."), Posted = filter(false);

                trigger OnAction()
                begin

                end;
            }
            action("Monthly Remmittance")
            {
                Image = ServiceAccessories;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                RunObject = Page "Member Contribution";
                RunPageLink = "Application No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Partial Disbursement Posted")
            {
                Image = History;
                Caption = 'Posted Partial Schedule';
                Visible = true;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                ApplicationArea = All;
                RunObject = page "Partial Disbursement-Posted";
                RunPageLink = "Loan No." = field("No."), Posted = filter(true);
                trigger OnAction()
                begin

                end;
            }
            action("Guarantors & Security")
            {
                Caption = 'Security';
                Image = HRSetup;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                RunObject = Page "Guarantors & Security";
                RunPageLink = "Loan No." = field("No.");
                ApplicationArea = All;
            }
            action("Loan Top Up")
            {
                Caption = 'Loan Refinance';
                Image = AllocatedCapacity;
                RunObject = Page "Loans Top Up Posted";
                RunPageLink = "Loan No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Loan Liquidation")
            {
                Caption = 'Loan Liquidation';
                Image = AllocatedCapacity;
                Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                RunObject = Page "Loan Liquidation";
                RunPageLink = "No." = field("Application No."), "Account No." = field("Account No.");
                ApplicationArea = All;
                trigger OnAction()
                begin

                end;
            }
            action("Commitments Clearance")
            {
                Caption = ' Other Clearance';
                Image = Cost;
                RunObject = Page "Other Commitments Clearance";
                Visible = false;
                ApplicationArea = All;
            }
            action("Salary Details")
            {
                Image = StepOver;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    LoanRec: Record Loans;
                begin

                    LoanRec.Reset();
                    LoanRec.SetRange("No.", Rec."No.");
                    if LoanRec.FindFirst() then
                        Report.Run(Report::"Appraisal Salary Details", true, false, LoanRec);
                end;
            }
            action(Charges)
            {
                Image = Travel;
                RunObject = Page "Application Charges Posted";
                RunPageLink = "Loan No." = field("No.");
                ApplicationArea = All;
            }
            action("Repayment  Schedule")
            {
                Image = PrintCheck;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CredMgt: Codeunit "Credit Mgmt.";
                    LoanRec: Record Loans;
                begin
                    CredMgt.fncreateRepayschedule(false, Rec."No.", 2)
                end;
            }
            action("Mandatory Requirements")
            {
                Image = RegisteredDocs;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                RunObject = Page "Loan Required Documents";
                ApplicationArea = All;
            }
            action("Loan History")
            {
                Image = History;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                RunObject = Page "Loan List";
                RunPageLink = "Account No." = FIELD("Account No.");
                RunPageView = WHERE("Approval Status" = CONST(Posted));
                Visible = true;
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
                    PLoan: Record "Collateral Register";
                begin
                    VarVariant := Rec;
                    ActionPanesItem := ActionPanesItem::Statement;
                end;
            }
            action("Loan Appraisal Report")
            {
                Caption = 'Loan Appraisal';
                Image = ReservationLedger;
                Enabled = Rec."Application Type" = Rec."Application Type"::Normal;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.OnBeforePrintDocument(Rec, xRec, Rec."Check Line");
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
                begin
                    if TellerMngt.TestNoEntriesExist(Rec."Account Name", Rec."No.", 0) then begin

                        Rec."Posted By" := UserId;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec.Validate("Disbursement Date", Today);
                        Rec."Interest Posting Date" := Today;
                        Rec."Loan Status" := Rec."Loan Status"::Issued;
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify;

                    end;
                end;
            }
            action(Post)
            {
                Image = PostedCreditMemo;
                Caption = 'Post';
                Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                ApplicationArea = All;
                trigger OnAction()
                var

                    LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                    TotGuarant: Decimal;
                    GenPostMngt: Codeunit "Gen.Jnl.+Preview";
                    OnConfirmDialogTxt: Label 'Are you sure you want to Post this application?';
                    CredMngt: Codeunit "Credit Mgmt.";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    Rec.OnBeforeValidatePerformPostOnLoansPostMgt(Rec, 0);
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
                    action(Approve)
                    {
                        Caption = 'Approve';
                        Image = Approve;
                        Visible = OpenApprovalEntriesExistForCurrUser;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        end;
                    }
                    action(SendApprovalRequest)
                    {
                        Caption = 'Send A&pproval Request';
                        Image = SendApprovalRequest;
                        Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.OnSendLoansApprovalResquest(Rec)
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        Caption = 'Cancel Approval Re&quest';
                        Image = CancelApprovalRequest;
                        Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.OnCancelLoansApprovalRequest(Rec, true, true);
                        end;
                    }
                    action("Open Document")
                    {
                        Image = OrderByDueDate;
                        Visible = true;
                        Enabled = Rec."Application Type" <> Rec."Application Type"::Defaulter;
                        Caption = 'Open Approval Request';
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                            TellMngt: Codeunit "Teller-Post (Yes/No)";

                        begin
                            if not TellMngt.TestNoEntriesExist(Rec."Account Name", Rec."No.", 0) then begin
                                approvalsMgmt.OnOpenLoansApprovalRequest(Rec, true, true)
                            end else begin
                                Error(ErrorOnPostedEntries);
                            end;
                        end;
                    }
                    action(Approvals1)
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
                            approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", Database::Loans);
                        end;
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Guarantors & Security_Promoted"; "Guarantors & Security")
                {
                }
                actionref("Loan Top Up_Promoted"; "Loan Top Up")
                {
                }
                actionref("Loan Liquidation_Promoted"; "Loan Liquidation")
                {
                }
                actionref("Commitments Clearance_Promoted"; "Commitments Clearance")
                {
                }
                actionref("Salary Details_Promoted"; "Salary Details")
                {
                }
                actionref(Charges_Promoted; Charges)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Repayment  Schedule_Promoted"; "Repayment  Schedule")
                {
                }
                actionref("Mandatory Requirements_Promoted"; "Mandatory Requirements")
                {
                }
                actionref("Loan Appraisal Report_Promoted"; "Loan Appraisal Report")
                {
                }
                actionref("Mark as Posted_Promoted"; "Mark as Posted")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref("Open Document_Promoted"; "Open Document")
                {
                }
                actionref(Approvals1_Promoted; Approvals1)
                {
                }
                actionref("Reject Application_Promoted"; "Reject Application")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Loan History_Promoted"; "Loan History")
                {
                }
                actionref("Member Statement_Promoted"; "Member Statement")
                {
                }
                actionref("Loan [File]_Promoted"; "Loan [File]")
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

                actionref("Loan Application Card_Promoted"; "Loan Application Card")
                {
                }
                actionref("Partial Disbursement_Promoted"; "Partial Disbursement")
                {
                }
                actionref("Monthly Remmittance_Promoted"; "Monthly Remmittance")
                {
                }
                actionref("Partial Disbursement Posted_Promoted"; "Partial Disbursement Posted")
                {
                }
            }
            group(Category_Category10)
            {
                Caption = 'Preview Posting', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        LoaApp: Record "Loan Application";
        GenjPostMgt: Codeunit "Gen.Jnl.+Preview";
        LoanTopUp: Record "Loans Top up Posted";

    begin
        MobilePhone := '';

        if LoaApp.Get(Rec."Application No.") then begin

            if Rec."Captured By" = '' then begin
                Rec."Captured By" := LoaApp."Captured By";
            end;
            Rec."Recovery Mode" := LoaApp."Recovery Mode";
            MobilePhone := LoaApp."Mobile Phone No.";
        end;

        ObjBankDescript := '';
        ObjtBankDetails.Reset();
        ObjtBankDetails.SetRange(Code, Rec."Payment Destination Code");
        if ObjtBankDetails.FindFirst() then
            ObjBankDescript := ObjtBankDetails.Name;
    end;

    trigger OnAfterGetRecord()
    var
        LoaApp: Record "Loan Application";
        GenjPostMgt: Codeunit "Gen.Jnl.+Preview";
        LoanTopUp: Record "Loans Top up Posted";
    begin
        SetControlAppearance;

        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := UpperCase(ObjEmp.Name);
        if LoaApp.Get(Rec."Application No.") then begin
            MinuteNo := LoaApp.Minute;
            Rec."Mode of Disbursement" := LoaApp."Mode of Disbursement";
            Rec."Amount to Disburse" := LoaApp."Amount to Disburse";
            Rec."Cheques Type" := Rec."Cheques Type"::"Manual Check";
            if Rec."Total Charges" = 0 then
                Rec."Total Charges" := GenjPostMgt.getLoanCharge(Rec."No.", Rec."Approved Amount");
            Rec.Modify(true);
        end;

        Rec.CalcFields("Total Amount Disbursed");

        DisburseBal := 0;
        DisburseBal := (Rec."Approved Amount" - Rec."Total Amount Disbursed");

        getApplicDetails(Rec."Application No.");

        LoanTopUp.Reset();
        LoanTopUp.SetRange("Loan No.", Rec."No.");
        if LoanTopUp.FindSet() then begin
            repeat
                LoanTopUp.getAcruedInterest(Rec."No.");
            until LoanTopUp.Next() = 0
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        LoanAc.Reset;
        LoanAc.SetRange("Loan Account", UserId);
        LoanAc.SetRange("Disbursement Destination", LoanAc."Disbursement Destination"::" ");
        if LoanAc.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnMaxNoTransactions);
        end;
    end;

    trigger OnOpenPage()
    begin
        BatchInfoEditable := true
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        ObjEmp: Record Customer;
        ObjtMember: Record Member;
        ResponseTxt: Integer;
        ObjtBankDetails: Record Banks;
        ObjBankDescript: Text[150];
        MobilePhone: Code[20];
        DisburseBal: Decimal;
        ActItems: Enum ActionPanesItems;
        ObjName: Text[200];
        Temp: Record "User Setup";
        LoanAc: Record Loans;
        MinuteNo: Code[50];
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
        PeriodItems: Codeunit "Credit Mgmt.";
        ActionPanesItem: Option Agreement,"Loan BuyOff","Salary Details",RepaymentSchedule,Statement,"Loan Appraisal","Loan History","Post Application",File,"Send Approval Request","Cancel Approval Request","Open Request",Approvals;
        ErrorMessageOnRepayAmountTxt: Label 'Repayment Amount cannot be less than minimum repayment of %1';
        ErrorOnPostedEntries: Label 'One or more entries already posted. This document cannot change approval status to Open';
        BatchInfoEditable: Boolean;
        MemberAge: Integer;
        SharesBanding: Decimal;
        AccruedInt: Decimal;
        LoanBal: Decimal;
        loantopup: Record "Loans Top up Posted";
        generaljv: Record "Gen. Journal Line";




    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure getApplicDetails(AppNo: Code[50])
    var
        Application: Record "Loan Application";
    begin
        if Application.Get(AppNo) then begin
            Application.CalcFields("Accrued Interest");
            SharesBanding := Application."Shares Banding";
            LoanBal := Application."Total Balance";
            MemberAge := Application.getCustomerAge();
            AccruedInt := Application."Accrued Interest";
        end;

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




