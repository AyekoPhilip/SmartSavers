page 50081 "Imprest Header"
{
    ApplicationArea = All;
    Caption = 'Imprest Header';
    PageType = Card;
    SourceTable = "Imprest Header";
    SourceTableView = where("Payment Type" = const(Imprest));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    StyleExpr = true;
                    Visible=false;
                    Style = StandardAccent;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Payee; Rec.Payee)
                {
                    ToolTip = 'Specifies the value of the Payee field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Payment Narration"; Rec."Payment Narration")
                {
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Total Amount field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Total Payment Amount LCY"; Rec."Total Payment Amount LCY")
                {
                    ToolTip = 'Specifies the value of the Total Payment Amount LCY field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
            }
            part(Control26; "Imprest Lines")
            {
                Caption = 'Lines';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            group("Trail Information")
            {
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ToolTip = 'Specifies the value of the Posted Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }

                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Cashier; Rec.Cashier)
                {
                    ToolTip = 'Specifies the value of the Cashier field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                    Visible = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }

            }
        }
        area(factboxes)
        {
            part(CommentsFactBox; "Approval Comments FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = field("No.");
            }
            systempart(Control21; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control20; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Attachments; Links)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(Reporting)
        {

            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ApplicationArea = All;
                ToolTip = 'Executes the &Print action';
                trigger OnAction()
                begin
                    PaymentRec.Reset();
                    PaymentRec.SetRange(PaymentRec."No.", Rec."No.");
                    if PaymentRec.FindFirst() then begin
                        PLines.Reset();
                        PLines.SetRange(No, PaymentRec."No.");
                        if PLines.FindFirst() then begin
                           // if PLines."Account Type" <> PLines."Account Type"::Vendor then
                            //    Report.Run(Report::"Payment Voucher", true, false, PaymentRec)
                            //else
                             //   Report.Run(Report::"Payment Voucher-Vendor", true, false, PaymentRec);
                        end;
                    end;
                end;
            }
            action(PrintCheck)
            {
                Caption = 'Print Cheque';
                Image = PrintCheck;
                Enabled = Rec."Pay Mode" = Rec."Pay Mode"::Cheque;
                Visible = true;
                ApplicationArea = All;
                ToolTip = 'Executes the Print Cheque action';

                trigger OnAction()
                begin
                    Rec.TestField("Check Printed", false);
                    PaymentRec.Reset();
                    PaymentRec.SetRange("No.", Rec."No.");
                    if PaymentRec.FindFirst() then begin
                        // Report.Run(Report::"PV Check", true, false, PaymentRec);
                    end;
                end;
            }
            action(ImportPayments)
            {
                Caption = 'Import Bulk Payments';
                Image = Import;
                ApplicationArea = All;
                ToolTip = 'Executes the Import Bulk Payments action';
                trigger OnAction()
                begin

                end;
            }
            action(Archive)
            {
                Image = AuthorizeCreditCard;
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Executes the Archive action';
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to archive this document?', false) = true then begin
                        // Committment.UncommitPV(Rec);
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify();
                    end;
                end;
            }

        }
        area(navigation)
        {

            action(SendApprovalRequest)
            {
                Caption = 'Send A&pproval Request';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                Image = SendApprovalRequest;
                ApplicationArea = All;
                ToolTip = 'Executes the Send A&pproval Request action';

                trigger OnAction()
                begin
                    Rec.TestField("Paying Bank Account");
                    Rec.TestField(Payee);
                    Rec.TestField("Payment Narration");
                    PLines.Reset();
                    PLines.SetRange(No, Rec."No.");
                    if PLines.FindSet() then begin
                        repeat
                            if PLines."Account No." = '' then
                                Error('Account No. Field is Blank. Please Fill the Line No. %1 with amount %2.', PLines."Line No", PLines.Amount);
                            PLines.TestField(Description);
                        until PLines.Next() = 0;
                    end;
                    //ApprovalsMgmt.OnSendPaymentsForApproval(Rec);
                    Commit();
                    CurrPage.Close();

                end;
            }
            action(CancelApprovalRequest)
            {
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForPayment and not DocPosted;
                Image = CancelApprovalRequest;
                ApplicationArea = All;
                ToolTip = 'Executes the Cancel Approval Re&quest action';
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to cancel the approval request? Please note this will uncommit previous committments regarding %1', false, Rec."No.") = true then begin
                    end;
                    CurrPage.Close();
                end;
            }
            action("Open Approval Request")
            {
                Image = Category;
                Visible = true;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approval;
                ApplicationArea = All;
                ToolTip = 'Executes the Approvals action';
                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalEntries: Page "Approval Entries";
                begin

                end;
            }
        }
        area(processing)
        {
            action(Post)
            {
                Caption = 'P&ost';
                Image = PostOrder;
                ShortCutKey = 'F9';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                ToolTip = 'Executes the P&ost action';
                trigger OnAction()
                begin

                    //Uncommented the code
                    //PaymentsPost."Post Payment Voucher"(Rec);
                    Commit();
                    CurrPage.Close();
                end;
            }

            action(GenerateEFT)
            {
                Caption = 'Generate EFT File';
                Enabled = true;
                Image = ExportToExcel;
                visible = true;
                ApplicationArea = All;
                ToolTip = 'Executes the Generate EFT File action';

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to generate an EFT file for PV %1', false, Rec."No.") = true then begin

                        //PaymentsPost.GenerateEFT(Rec);
                        //BankingProcedure.GeneratePVBankTemplate(Rec);
                    end;
                end;
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
                actionref(Archive_Promoted; Archive)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("&Print_Promoted"; "&Print")
                {
                }
                actionref(PrintCheck_Promoted; PrintCheck)
                {
                }
                actionref(ImportPayments_Promoted; ImportPayments)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(GenerateEFT_Promoted; GenerateEFT)
                {
                }
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
                actionref("Open Approval Request_Promoted"; "Open Approval Request")
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

    trigger OnAfterGetCurrRecord()
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", Rec."No.");
        if ApprovalEntry.Find('-') then begin
            ShowCommentFactbox := CurrPage.CommentsFactBox.Page.SetFilterFromApprovalEntry(ApprovalEntry);
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Payment Type" := Rec."Payment Type"::Normal;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Payment Type" := Rec."Payment Type"::Normal;
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance();
    end;

    var
        ApprovalEntry: Record "Approval Entry";
        BankingProcedure: Codeunit "Banking Procedure Mngt.";
        CashManagementSetup: Record "Cash Management Setups";
        PLines: Record "Payment Lines";
        PayMethod: Record "Payment Method";
        PaymentRec: Record "Payments Header";
        CanCancelApprovalForPayment: Boolean;

        ChequePayment: Boolean;

        DocPosted: Boolean;

        DocReleased: Boolean;
        EFTPayment: Boolean;

        OpenApprovalEntriesExist: Boolean;
        RTGSPayment: Boolean;
        ShowCommentFactbox: Boolean;
        ErrorMsg: Text;

    local procedure SetControlAppearance()
    var
        PaymentMethod: Record "Payment Method";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

    end;
}
