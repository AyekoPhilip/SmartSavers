page 50896 "Membership Closure"
{
    DeleteAllowed = false;
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
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field("Notice No."; Rec."Notice No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    Editable = true;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    trigger OnValidate()
                    begin
                        SetLocalControl();
                        SetControlAppearance();
                    end;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ApplicationArea = All;
                    Editable = Rec."Pay Mode" = Rec."Pay Mode"::EFT;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }

                field("Close Account"; Rec."Close Account")
                {
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
                                    case Rec."Closure Type" of
                                        Rec."Closure Type"::"Withdrawal - Normal":
                                            begin
                                                ProductFacEditable := true;
                                                LoanFieldEditable := true;
                                                Rec."Loans Option" := Rec."Loans Option"::Specific;
                                                LnsOptionFacEditable := true;
                                                NoticeEditable := true;
                                                MembEditable := false;
                                            end;
                                        Rec."Closure Type"::"Withdrawal - Death":
                                            begin
                                                ProductFacEditable := false;
                                                LnsOptionFacEditable := false;
                                                LoanFieldEditable := false;
                                                NoticeEditable := false;
                                                MembEditable := true;
                                            end;
                                    end;

                                end;
                        end;
                    end;
                }
                field("Closure Type"; Rec."Closure Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    Editable = Rec."Document Type" = Rec."Document Type"::"Membership Closure";
                    trigger OnValidate()
                    begin
                        if Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Death" then begin
                            ProductFacEditable := false;
                            LnsOptionFacEditable := false;
                            LoanFieldEditable := false;
                            CloseAccEditable := false;
                            Rec.Validate("Close Account");
                        end else
                            CloseAccEditable := true;
                    end;
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                    Visible = false;
                    Editable = false;
                    ShowMandatory = true;

                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Member Name"; Rec."Member Name")
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                 field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Savings"; Rec."Member Savings")
                {
                    Editable = false;
                    Caption = 'Balance (LCY)';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Include Charges"; Rec."Include Charges")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
                field("Other Charges"; Rec."Other Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Fee';
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Early Exit Charges"; Rec."Early Exit Charges")
                {
                    ApplicationArea = All;
                    Caption = 'Early Exit Fee';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ValuesAllowed = 0, 3;
                    Editable = True;
                    ShowMandatory = true;
                }
                field("Paying Account No."; Rec."Paying Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field("EFT Bank Account"; Rec."EFT Bank Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ShowMandatory = true;
                }
                field("Cheques Type";Rec."Rcv Cheques Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field("Cheque No";Rec."Rcv Cheque No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ShowMandatory = true;
                }
                field("Payment Destination"; Rec."Payment Destination")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                    ShowMandatory = true;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
            }
            group("Account Closure")
            {
                Caption = 'Account Closure Details';
                Visible = Rec."Document Type" = Rec."Document Type"::"Account Closure";
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }
            }
            group("Account Statistics")
            {
                Visible = MembershipClosureVisible;
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Closing Date"; Rec."Closing Date")
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
                    Importance = Additional;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Product Factory"; Rec."Product Factory")
                {
                    Caption = 'Product Type';
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Loans Option"; Rec."Loans Option")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Outstanding Principal"; Rec."Outstanding Principal")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Total Loan"; Rec."Total Loan")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Outstanding Balance';
                }
                field("Sum Insured"; Rec."Sum Insured")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Loan No."; Rec."Loan No.")
                {
                    Caption = 'Loan No.';
                    Editable = LoanFieldEditable;
                    Visible = false;
                    ApplicationArea = All;
                }

                field("Shares Capital"; Rec."Shares Capital")
                {
                    Editable = false;
                    Caption = 'Shares Capital';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deposit Refundable"; Rec."Deposit Refundable")
                {
                    Editable = false;
                    Caption = 'Net Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Savings"; Rec."Total Savings")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;

                }
                field("Total Liabilities"; Rec."Total Liabilities")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Amount (LCY)"; Rec."Total Amount (LCY)")
                {
                    Editable = false;
                    Importance = Additional;
                    Visible = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }

            part(Control18; "Account Closure Line")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
                Editable = false;
                Caption = 'Account(s) to Close';
            }
            group("Trail Information")
            {
                Editable = false;
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }

                field("Application Date"; Rec."Application Date")
                {

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
        area(FactBoxes)
        {
            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No."), "Account Category" = filter("Shares Capital");
                Visible = true;
                ApplicationArea = All;
            }
            part(Control8; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No."), "Account Category" = filter("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part("Banking History"; "Account Statistics FactBox")
            {
                Caption = 'Banking Statistics';
                SubPageLink = "Member No." = field("Member No.");
                SubPageView = where("Account Category" = const("Specialty Savings"));
                ApplicationArea = All;
            }
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = field("Member No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = field("Member No.");
                ApplicationArea = All;
            }
            systempart(Control10; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; MyNotes)
            {
                ApplicationArea = All;
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
            action("External Payment")
            {
                Image = Allocate;
                Caption = 'EFT Payment';
                ApplicationArea = All;
                RunObject = Page "External Payment-Closure";
                RunPageLink = "Application No." = field("No."), "Member No." = field("Member No.");
                trigger OnAction()
                begin

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
                    Rec.OnBeforeOnValidateAccPost(Rec, xRec, true, false);
                    CurrPage.Close();
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
                    Rec.OnBeforeOnValidateAccPost(Rec, xRec, true, true);
                    CurrPage.Close();
                end;
            }
            action(PrintPreview)
            {
                Image = PostedInventoryPick;
                Visible = false;
                Caption = 'Print Preview';
                ApplicationArea = All;
                trigger OnAction()
                var
                    PeriodicMngt: Codeunit "Periodic Activities Mgt.";
                    RecHeader: Record "Membership closure";
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    Report.Run(Report::"Membership Closure Report", true, true, Rec);
                    Rec.Reset;
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
            action("Generate EFT File")
            {
                Image = PreviewChecks;
                trigger OnAction()
                var
                    BnkMgt: Codeunit "Banking Procedure Mngt.";
                    PeriodicMngt: Codeunit "Periodic Activities Mgt.";
                begin
                    if Rec."Pay Mode" = Rec."Pay Mode"::EFT then begin
                        PeriodicMngt.GenerateEftFileOnClosure(Rec, 1, 0)
                    end
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
                Image = RelatedInformation;
                trigger OnAction()
                begin
                    Rec.TestField("Member No.");
                    Docx.getmemberStatsAcc(Rec."Member No.", 8);
                end;

            }
            action(MemberCredAcc)
            {
                Caption = 'Credit Account';
                Image = Customer;
                RunObject = page "Account Credit List";
                RunPageLink = "Member No." = field("Member No.");
                trigger OnAction()
                begin
                end;
            }

            action(LoanCredAcc)
            {
                Caption = 'Loan Account';
                Image = WorkCenterLoad;
                RunObject = page "Loan Account";
                RunPageLink = "Member No." = field("Member No.");
                trigger OnAction()
                begin
                end;

            }
            action(LoanHistory)
            {
                Caption = 'Loan History';
                Image = History;
                RunObject = page "Loans List Posted";
                RunPageLink = "Account No." = field("Member No.");
                trigger OnAction()
                begin
                end;

            }
            action(MemberBankingAcc)
            {
                Caption = 'Banking Account';
                Image = Vendor;
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
                    CreateNotif.SendEmailOnReceiptPayment(Rec."No.");
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
                        VarVariant := Rec;
                        Rec.CheckMinRequirement(0);
                        ApprovalsMgmt.OnSendAcclosureRequest(VarVariant);
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
                        if ApprovalsMgmt.OpenAcclosureApprovalRequest(VarVariant, true, true) then;
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", Database::"Membership closure")
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("External Payment_Promoted"; "External Payment")
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref("Post+Print_Promoted"; "Post+Print")
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
                actionref("Reject Application_Promoted"; "Reject Application")
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

                actionref("Generate EFT File_Promoted"; "Generate EFT File")
                {
                }
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
    trigger OnAfterGetCurrRecord()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    CurrPage.Editable := true;
                end else begin
                CurrPage.Editable := false;
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    CurrPage.Editable := true;
                end else begin
                CurrPage.Editable := false;
            end;
        end;
        SetControlAppearance;
        SetLocalControl();
        if Rec."Approval Status" <> Rec."Approval Status"::Open
       then
            CurrPage.Editable := false;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Temp: Record "User Setup";
        ErrorOnMaxDocsTxt: Label 'There are still some unposted closures. Please utilise them first';
    begin

        if Temp.Get(UserId) then
            Temp.TestField("Max. No. [Open Documents]");

        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt."Entered By", UserId);
        Rcpt.SetFilter("Approval Status", '%1|%2', Rcpt."Approval Status"::Open, Rcpt."Approval Status"::"Pending Approval");
        if Rcpt.Find('-') then begin
            if Rcpt.Count > Temp."Max. No. [Open Documents]" then begin
                Error(ErrorOnMaxDocsTxt);
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Customer Type" := Rec."Customer Type"::Individual;
        Rec."Pay Mode" := Rec."Pay Mode"::Cheque;

    end;

    trigger OnOpenPage()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    CurrPage.Editable := true;
                end else begin
                CurrPage.Editable := false;
            end;
        end;

        if Rec."Document Type" = Rec."Document Type"::"Account Closure" then begin
            Rec."Destination Type" := Rec."Destination Type"::Credit;
        end;
    end;

    procedure SetLocalControl()
    begin
        case Rec."Document Type" of
            Rec."Document Type"::"Account Closure":
                begin
                    MembershipClosureVisible := false;
                    AccountClosureVisible := true;
                    CloseAccEditable := false;
                    CloseAccEdit := false;
                    CloseTypeEditable := false;
                    NoticeNoEditable := false;

                end;
            Rec."Document Type"::"Membership Closure":
                begin

                    MembershipClosureVisible := true;
                    AccountClosureVisible := false;
                    CloseAccEditable := true;
                    CloseAccEdit := true;
                    CloseTypeEditable := true;
                    NoticeNoEditable := true;

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
                        ProductFacEditable := false;
                        LnsOptionFacEditable := false;
                        LoanFieldEditable := false;
                        CloseAccEditable := false;
                    end else begin
                        CloseAccEditable := true;
                    end;
                end;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
        then
            Error(ErrorPermsTxt);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
        then
            Error(ErrorPermsTxt);
    end;

    var
        NoticeVisible: Boolean;
        ClosingDateVisible: Boolean;
        MembershipClosureVisible: Boolean;
        AccountClosureVisible: Boolean;
        CustomApprovals: Codeunit "Approval Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        gensetup: Record "General Set-Up";
        Membershipclosure: Record "Membership closure";
        ErrorPermsTxt: Label 'You cannot edit or Delete a which status is not Open';
        Txt0002: Label 'Member cannot close the account before clearing the loans';
        ErrorOnOutstandLiabilitiesTxts: Label 'Member savings must be more than outstanding liabilities';
        Rcpt: Record "Membership closure";
        ProductFacEditable: Boolean;
        LnsOptionFacEditable: Boolean;
        LoanFieldEditable: Boolean;
        CloseAccEditable: Boolean;
        CloseAccEdit: Boolean;
        NoticeEditable: Boolean;
        MembEditable: Boolean;
        CloseAcEditable: Boolean;
        CloseTypeEditable: Boolean;
        NoticeNoEditable: Boolean;
        ErrorOnMinBalTxt: Label 'No enough funds for this transaction';
        Docx: Codeunit "Doc. Mngt";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure SetControlEditable(): Boolean
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                exit(true)
            else
                exit(false)
        end
    end;

}




