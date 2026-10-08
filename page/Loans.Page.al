page 51038 "Loans"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                field("Shares Deposit"; Rec."Shares Deposit")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("TopUp Loan"; Rec."TopUp Loan")
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
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Amount to Post"; Rec."Amount to Post")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = true;
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Amount to Disburse"; Rec."Amount to Disburse")
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    Caption = 'Recommended Amount';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
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
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
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
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = true;
                    Visible = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
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
                field("Application No."; Rec."Application No.")
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
                field("EFT Options"; Rec."EFT Options")
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
                field("Loan Payment Destination"; Rec."Loan Payment Destination")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Payment Destination"; Rec."Payment Destination")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Total TopUp"; Rec."Total TopUp")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                field("Repayment Mode"; Rec."Repayment Mode")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Appraisal Parameter Type"; Rec."Appraisal Parameter Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Check Line"; Rec."Check Line")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
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
            action("Mark as Posted")
            {
                Image = PutAwayWorksheet;
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CreditLedger: Record "Cust. Ledger Entry";
                begin
                    CreditLedger.Reset();
                    CreditLedger.SetRange("Loan No.", Rec."No.");
                    CreditLedger.SetRange("Transaction Type", CreditLedger."Transaction Type"::Loan);
                    if CreditLedger.FindFirst() then begin
                        Rec."Posted By" := CreditLedger."User ID";
                        Rec."Date Posted" := CreditLedger."Posting Date";
                        Rec."Time Posted" := Time;
                        Rec.Validate("Disbursement Date", CreditLedger."Posting Date");
                        Rec."Interest Posting Date" := CreditLedger."Posting Date";
                        Rec."Loan Status" := Rec."Loan Status"::Issued;
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify(true);
                    end;

                end;
            }
            action("Monthly Remmittance")
            {
                Image = ServiceAccessories;
                RunObject = Page "Member Contribution";
                RunPageLink = "Application No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Guarantors & Security")
            {
                Caption = 'Security';
                Image = HRSetup;
                RunObject = Page "Guarantors & Security";
                RunPageLink = "Loan No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Loan Top Up")
            {
                Caption = 'Loan Refinance';
                Image = AllocatedCapacity;
                RunObject = Page "Loans Top Up Posted";
                RunPageLink = "Loan No." = field("No.");
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
            action("Salary Details")
            {
                Image = StepOver;
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
                RunPageLink = "Application No." = field("No.");
                ApplicationArea = All;
            }
            action("Repayment  Schedule")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CredMgt: Codeunit "Credit Mgmt.";
                    LoanRec: Record Loans;
                begin
                    CredMgt.fncreateRepayschedule(false, Rec."No.", 2)
                end;
            }
            action("Partial Disbursement")
            {
                Image = PutAwayWorksheet;
                ApplicationArea = All;
                RunObject = page "Partial Disbursement Schedule";
                RunPageLink = "Loan No." = field("No."), "Approval Status" = filter(Open | "Pending Approval" | Approved);
                trigger OnAction()
                begin

                end;
            }
            action("Posted Partial Disbursement")
            {
                Image = PutAwayWorksheet;
                Caption = 'Posted Partial Disbursement';
                ApplicationArea = All;
                RunObject = page "Partial Disbursement-Posted";
                RunPageLink = "Loan No." = field("No."), "Approval Status" = filter(Posted);
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
            action("Loan History")
            {
                Image = History;
                RunObject = Page "Loan History";
                Visible = true;
                ApplicationArea = All;
            }
            action("Member Statement")
            {
                Caption = 'Statement';
                Image = TaskList;
                ApplicationArea = All;
                trigger OnAction()
                var
                begin

                end;
            }
            action("Loan Appraisal Report")
            {
                Caption = 'Loan Appraisal';
                Image = ReservationLedger;
                ApplicationArea = All;
                trigger OnAction()

                begin
                     
                end;
            }
            action("Post")
            {
                Image = PostedCreditMemo;
                Caption = 'Post';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    PeriodItems.ApplicationDocPane(VarVariant, ActItems::"Post Application")
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
                    TempBlob: Codeunit "Temp Blob";
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
                        Enabled = false;

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
                        Enabled = false;
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
                        Enabled = false;
                        ApplicationArea = All;
                        Caption = 'Open Approval Request';
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
                    action("Mark as Reversed")
                    {
                        Caption = 'Mark As Reversed';
                        Image = Approval;
                        Enabled = Rec."Approval Status" = Rec."Approval Status"::Posted;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprovalEntries: Page "Approval Entries";
                            BnkProcMgnt: Codeunit "Banking Procedure Mngt.";
                        begin

                            if Rec."Loan Status" <> Rec."Loan Status"::Reversed then
                                BnkProcMgnt.MarkLoanAsReversed(Rec);
                        end;
                    }
                    action(Approvals)
                    {
                        Caption = 'Approvals';
                        Image = Approval;
                        Enabled = false;
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
            group(Category_New)
            {
                Caption = 'New', Comment = 'Generated from the PromotedActionCategories property index 0.';

                actionref("Mark as Reversed_Promoted"; "Mark as Reversed")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Loan Payment Schedule_Promoted"; "Loan Payment Schedule")
                {
                }
                actionref("Guarantors & Security_Promoted"; "Guarantors & Security")
                {
                }
                actionref("Loan Top Up_Promoted"; "Loan Top Up")
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
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Associated Account', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref("Partial Disbursement_Promoted"; "Partial Disbursement")
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref("Mark as Posted_Promoted"; "Mark as Posted")
                {
                }
                actionref("Monthly Remmittance_Promoted"; "Monthly Remmittance")
                {
                }
                actionref("Posted Partial Disbursement_Promoted"; "Posted Partial Disbursement")
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
        LoanTopUp: Record "Loans Top up Posted";
        LoaApp: Record "Loan Application";
        GenjPostMgt: Codeunit "Gen.Jnl.+Preview";
    begin
        SetControlAppearance;

        if ObjEmp.Get(Rec."Employer Code") then
            ObjName := UpperCase(ObjEmp.Name);
        Rec."Application Type" := Rec."Application Type"::Normal;

        if LoaApp.Get(Rec."Application No.") then begin

            Rec."Mode of Disbursement" := LoaApp."Mode of Disbursement";
            Rec."Amount to Disburse" := LoaApp."Amount to Disburse";
            if Rec."Total Charges" = 0 then
                Rec."Total Charges" := GenjPostMgt.getLoanCharge(Rec."No.", Rec."Approved Amount");
            Rec.Modify(true);
        end;

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
        VarVariant: Variant;
        ObjEmp: Record Customer;
        StandardStatement: Report "Standard Statement-Loans";
        CustRecord: Record Member;
        ActItems: Enum ActionPanesItems;
        ObjName: Text[200];
        Temp: Record "User Setup";
        LoanAc: Record "Loan Application";
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
        PeriodItems: Codeunit "Credit Mgmt.";
        ActionPanesItem: Option Agreement,"Loan BuyOff","Salary Details",RepaymentSchedule,Statement,"Loan Appraisal","Loan History","Post Application",File,"Send Approval Request","Cancel Approval Request","Open Request",Approvals;
        ErrorMessageOnRepayAmountTxt: Label 'Repayment Amount cannot be less than minimum repayment of %1';
        ErrorOnPostedEntries: Label 'One or more entries already posted. This document cannot change approval status to Open';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




