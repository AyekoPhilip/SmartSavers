page 50652 "Account Closure Page"
{
    Caption = 'Account Closure Page';
    PageType = Card;
    SourceTable = "Membership closure";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field("Close Account"; Rec."Close Account")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ProductFacEditable := false;
                        case Rec."Close Account" of
                            Rec."Close Account"::All:
                                begin
                                    ProductFacEditable := false;
                                    LnsOptionFacEditable := false;
                                    LoanFieldEditable := false;
                                    NoticeEditable := false;
                                    MembEditable := true;
                                end;
                            Rec."Close Account"::Specific:
                                begin
                                    ProductFacEditable := true;
                                    LoanFieldEditable := true;
                                    Rec."Loans Option" := Rec."Loans Option"::Specific;
                                    LnsOptionFacEditable := true;
                                    NoticeEditable := true;
                                    MembEditable := false;

                                end;
                        end;
                    end;
                }
                field("Notice No."; Rec."Notice No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("Member Name"; Rec."Member Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Notice M. Date"; Rec."Notice M. Date")
                {
                    Caption = 'Maturity Date';
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
                field("Closing Date"; Rec."Closing Date")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Closure Type"; Rec."Closure Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Death" then begin
                            Rec."Close Account" := Rec."Close Account"::All;
                            ProductFacEditable := false;
                            LnsOptionFacEditable := false;
                            LoanFieldEditable := false;
                            CloseAccEditable := false;
                            Rec.Validate("Close Account");
                        end else
                            CloseAccEditable := true;
                    end;
                }
                field("Product Factory"; Rec."Product Factory")
                {
                    Caption = 'Product Type';
                    Editable = ProductFacEditable;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Loans Option"; Rec."Loans Option")
                {
                    Editable = LnsOptionFacEditable;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;

                }

                field("Total Loan"; Rec."Total Loan")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Outstanding Balance';
                }

                field("Loan No."; Rec."Loan No.")
                {
                    Caption = 'Loan No.';
                    Editable = LoanFieldEditable;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Other Charges"; Rec."Other Charges")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Fee';
                }
                field("Early Exit Charges"; Rec."Early Exit Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Penalty';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Savings"; Rec."Member Savings")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Balance (LCY)';
                    ApplicationArea = All;
                }
                field("Shares Capital"; Rec."Shares Capital")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Deposit Refundable"; Rec."Deposit Refundable")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Total Amount (LCY)"; Rec."Total Amount (LCY)")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Include Charges"; Rec."Include Charges")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Importance = Additional;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            part(Control18; "Account Closure Line")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
                Caption = 'Lines';
            }
            group("Trail Information")
            {
                Editable = false;

                field("Application Date"; Rec."Application Date")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Enabled = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Resignation Slip")
            {
                Caption = 'Withdrawal Slip';
                Image = Documents;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(Report::"Membership Closure Report", true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(Post)
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;
                trigger OnAction()
                var
                    PeriodicMngt: Codeunit "Periodic Activities Mgt.";
                begin
                    if not Rec.getAvailableAmt() then
                        PeriodicMngt.PerformPost(Rec, 1, 1);
                end;
            }
            action("Post+Print")
            {
                Image = PostPrint;
                ApplicationArea = All;
                trigger OnAction()
                var
                    PeriodicMngt: Codeunit "Periodic Activities Mgt.";
                begin
                    if not Rec.getAvailableAmt() then
                        PeriodicMngt.PerformPost(Rec, 1, 1);
                end;
            }
            action(PostPreview)
            {
                Image = PostedInventoryPick;
                Caption = 'Post Preview';
                ApplicationArea = All;
                trigger OnAction()
                var
                    PeriodicMngt: Codeunit "Periodic Activities Mgt.";
                begin
                    if not Rec.getAvailableAmt() then
                        PeriodicMngt.PerformPost(Rec, 1, 1);
                end;
            }
            action(PrintPreview)
            {
                Image = PostedInventoryPick;
                Caption = 'Print Preview';
                ApplicationArea = All;
                trigger OnAction()
                var
                    PeriodicMngt: Codeunit "Periodic Activities Mgt.";
                    RecHeader: Record "Membership closure";
                begin

                end;
            }
            action(Memberstatement)
            {
                Caption = 'Statement of Account';
                Image = PreviewChecks;
                trigger OnAction()
                begin
                    Rec.TestField("Member No.");
                    Docx.getmemberStatsAcc(Rec."Member No.", 0);
                end;

            }
            action(Loanstatement)
            {
                Caption = 'Statement-Loan';
                Image = PreviewChecks;
                trigger OnAction()
                begin
                    Rec.TestField("Member No.");
                    Docx.getmemberStatsAcc(Rec."Member No.", 2);
                end;

            }
            action(DetailedLoanstatement)
            {
                Caption = 'Detailed Statement-Loan';
                Image = PreviewChecks;
                trigger OnAction()
                begin
                    Rec.TestField("Member No.");
                    Docx.getmemberStatsAcc(Rec."Member No.", 1);
                end;

            }

            action(Memberstats)
            {
                Caption = 'Member Statistics';
                Image = PreviewChecks;
                trigger OnAction()
                begin
                    Rec.TestField("Member No.");
                    Docx.getmemberStatsAcc(Rec."Member No.", 8);
                end;

            }
            action(MemberCredAcc)
            {
                Caption = 'Credit Account';
                Image = PreviewChecks;
                RunObject = page "Account Credit List";
                RunPageLink = "Member No." = field("Member No.");
                trigger OnAction()
                begin
                end;

            }

            action(LoanCredAcc)
            {
                Caption = 'Credit Account';
                Image = PreviewChecks;
                RunObject = page "Loan Account";
                RunPageLink = "Member No." = field("Member No.");
                trigger OnAction()
                begin
                end;

            }
            action(LoanHistory)
            {
                Caption = 'Credit Account';
                Image = PreviewChecks;
                RunObject = page "Loans List Posted";
                RunPageLink = "Account No." = field("Member No.");
                trigger OnAction()
                begin
                end;

            }
            action(MemberBankingAcc)
            {
                Caption = 'Banking Account';
                Image = PreviewChecks;
                RunObject = page "Savings Account List";
                RunPageLink = "Member No." = field("Member No.");
                trigger OnAction()
                begin
                end;
            }
            action("E-Mail Receipt")
            {
                Caption = 'E-Mail Receipt';
                Image = Email;

                trigger OnAction()
                var
                    CustMembr: Record Member;
                    CreateNotif: Codeunit "SMS Notification";
                begin
                    //CreateNotif.SendEmailOnReceiptPayment(Rec."No.");    
                end;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = Job;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin

                        Rec.TestField(Remarks);
                        Rec.TestField("Closure Type");
                        Rec.TestField("Close Account");
                        Rec.TestField("Member No.");
                        VarVariant := Rec;
                        if not Rec.getAvailableAmt() then begin
                            if ApprovalsMgmt.OnSendAcclosureRequest(VarVariant) then;
                        end else begin
                            Error('Member savings must be more than outstanding liabilities');
                        end;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        if ApprovalsMgmt.OnCancelAcclosureApprovalRequest(VarVariant, true, true) then;
                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Open Approval Re&quest';
                    Enabled = true;
                    Image = Category;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        if ApprovalsMgmt.OnCancelAcclosureApprovalRequest(VarVariant, true, true) then;
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147246)
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Post_Promoted; Post)
                {
                }
                actionref("Post+Print_Promoted"; "Post+Print")
                {
                }
                actionref(PostPreview_Promoted; PostPreview)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Resignation Slip_Promoted"; "Resignation Slip")
                {
                }
                actionref(PrintPreview_Promoted; PrintPreview)
                {
                }
                actionref(Memberstatement_Promoted; Memberstatement)
                {
                }
                actionref(Loanstatement_Promoted; Loanstatement)
                {
                }
                actionref(DetailedLoanstatement_Promoted; DetailedLoanstatement)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(OpenApprovalRequest_Promoted; OpenApprovalRequest)
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref(Memberstats_Promoted; Memberstats)
                {
                }
                actionref(MemberCredAcc_Promoted; MemberCredAcc)
                {
                }
                actionref(LoanCredAcc_Promoted; LoanCredAcc)
                {
                }
                actionref(LoanHistory_Promoted; LoanHistory)
                {
                }
                actionref(MemberBankingAcc_Promoted; MemberBankingAcc)
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Attachment', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Notification', Comment = 'Generated from the PromotedActionCategories property index 9.';

                actionref("E-Mail Receipt_Promoted"; "E-Mail Receipt")
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Posted = true then
            CurrPage.Editable := false;
        SetControlAppearance;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Temp: Record "User Setup";
        ErrorOnMaxDocsTxt: Label 'There are still some unposted closures. Please utilise them first';
    begin
        if Temp.Get(UserId) then
            Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange("Close Account", Rcpt."Close Account"::Specific);
        Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
        Rcpt.SetRange(Rcpt."Entered By", UserId);
        if Rcpt.Find('-') then begin
            if Rcpt.Count > 7 then begin
                Error(ErrorOnMaxDocsTxt);
            end;
        end;
        Rec."Close Account" := Rec."Close Account"::Specific;
        Rec."Closure Type" := Rec."Closure Type"::"Withdrawal - Normal";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Close Account" := Rec."Close Account"::Specific;
        Rec."Closure Type" := Rec."Closure Type"::"Withdrawal - Normal";
    end;

    trigger OnOpenPage()
    begin
        if (Rec."Approval Status" = Rec."Approval Status"::Approved) or (Rec."Approval Status" = Rec."Approval Status"::"Pending Approval") then
            CurrPage.Editable := false;
        case Rec."Close Account" of
            Rec."Close Account"::All:
                begin
                    LnsOptionFacEditable := true;
                    ProductFacEditable := false;
                    LoanFieldEditable := false;
                end else begin
                ProductFacEditable := true;
                Rec."Loans Option" := Rec."Loans Option"::Specific;
                LnsOptionFacEditable := false;
                LoanFieldEditable := true;
            end;
        end;
        if Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Death" then begin
            Rec."Close Account" := Rec."Close Account"::All;
            ProductFacEditable := false;
            LnsOptionFacEditable := false;
            LoanFieldEditable := false;
            CloseAccEditable := false;
        end else
            CloseAccEditable := true;
    end;

    var
        CustomApprovals: Codeunit "Approval Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        Membershipclosure: Record "Membership closure";
        Txt0002: Label 'Member cannot close the account before clearing the loans';
        Rcpt: Record "Membership closure";
        ProductFacEditable: Boolean;
        LnsOptionFacEditable: Boolean;
        LoanFieldEditable: Boolean;
        CloseAccEditable: Boolean;
        NoticeEditable: Boolean;
        MembEditable: Boolean;
        Docx: Codeunit "Doc. Mngt";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




