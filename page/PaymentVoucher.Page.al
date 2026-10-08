page 50090 "Payment Voucher"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Payments Header";
    SourceTableView = where("Payment Type" = const(Normal));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Visible = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {

                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Mode field';

                    trigger OnValidate()
                    begin
                        SetControlAppearance();
                    end;
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {

                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank Account field';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Payment Realease Date';
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field';
                }
                field(Payee; Rec.Payee)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    Editable = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Payee field';
                }

                field("On behalf of"; Rec."On behalf of")
                {

                    ApplicationArea = All;
                    Editable = true;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the On behalf of field';
                }
                field("Payment Narration"; Rec."Payment Narration")
                {

                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Narration field';
                }

                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Currency field';
                }
            }

            group("Cheque Details")
            {
                Editable = (Rec."Pay Mode" = Rec."Pay Mode"::Cheque) and (Rec."Approval Status" = Rec."Approval Status"::Open);
                Visible = Rec."Pay Mode" = Rec."Pay Mode"::Cheque;
                field("Cheque Type"; Rec."Cheque Type")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Cheque Type field';
                }
                field("Cheque No"; Rec."Cheque No")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Cheque No field';
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Cheque Date field';
                }

                field("Check Printed"; Rec."Check Printed")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Check Printed field';
                }
            }

            part(Control26; "PV Lines")
            {
                Caption = 'Lines';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                SubPageLink = No = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            group(Computation)
            {
                Editable = false;
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Total Amount field';
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Total VAT Amount field';
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Total Witholding Tax Amount field';
                }
                field("Total Witholding VAT Tax"; Rec."Total Witholding VAT Tax")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Total Witholding VAT Tax field';
                }
                field("Total Payment Amount LCY"; Rec."Total Payment Amount LCY")
                {
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Payment Amount LCY field';
                }
                field("Total Retention Amount"; Rec."Total Retention Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Total Retention Amount field';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Total Net Amount field';
                }

            }
            group("Trail Information")
            {
                Editable = false;
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted field';
                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field';
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Date field';
                }

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Created By field';
                }
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Status field';
                }


                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field';
                }
            }
        }
        area(factboxes)
        {
            part(CommentsFactBox; "Approval Comments FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = field("No.");
                Visible = ShowCommentFactbox;
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
                            Report.Run(Report::"Payment Voucher", true, false, PaymentRec)
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
                    Rec.TestField("Cheque No");
                    Rec.TestField("Cheque Date");
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
            action(CheckBudget)
            {
                Image = AuthorizeCreditCard;
                Caption = 'Check Budget Availability';
                ApplicationArea = All;
                ToolTip = 'Executes the Archive action';
                trigger OnAction()
                begin
                    //CheckBudgetAvail.CheckPayments(Rec);
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
                    Rec.TestField("On behalf of");
                    Rec.TestField("Payment Narration");

                    PLines.Reset();
                    PLines.SetRange(No, Rec."No.");
                    if PLines.FindSet() then begin
                        repeat
                            PLines.TestField("Account No.");
                            PLines.TestField(Amount);
                            PLines.TestField(Description);
                        until PLines.Next() = 0;
                    end;
                    ApprovalsMgmt.OnSendPVApprovalRequest(Rec);
                    CurrPage.Close();

                end;
            }
            action(CancelApprovalRequest)
            {
                Caption = 'Cancel Approval Re&quest';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                Image = CancelApprovalRequest;
                ApplicationArea = All;
                ToolTip = 'Executes the Cancel Approval Re&quest action';
                trigger OnAction()
                begin
                    ApprovalsMgmt.OnCancelPVApprovalRequest(Rec, true, true);
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
                    ApprovalsMgmt.OnOpenPVApprovalRequest(Rec, true, true);
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
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec."No.", Database::"Payments Header");

                end;
            }
            action(Delegate)
            {
                Caption = 'Delegate';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                Image = Delegate;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                    approvalsMgmt: Codeunit "Approval Mgmt.";
                begin
                    approvalsMgmt.findDelegatedApprovalEntry(Rec."No.");
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
                    ResponseTxt := 0;
                    ResponseTxt := ConfirmPost();
                    case ResponseTxt of
                        1:
                            begin
                                Rec."Check Line" := true;
                            end else begin
                            Rec."Check Line" := false;
                        end;
                    end;

                    bankledger.Reset();
                    bankledger.SetRange("Document No.", rec."No.");
                    if bankledger.Find('-') then begin
                        Error('Transaction Posted');
                    end;
                    FundsMngt.PostPaymentVoucher(Rec, true);
                end;
            }
            action(PostPrint)
            {
                Caption = 'P&ost+Print';
                Image = PostPrint;
                ShortCutKey = 'F9';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                ToolTip = 'Executes the P&ost action';
                trigger OnAction()
                begin

                    bankledger.Reset();
                    bankledger.SetRange("Document No.", rec."No.");
                    if bankledger.Find('-') then begin
                        Error('Transaction Posted');
                    end;
                    FundsMngt.PostPaymentVoucher(Rec, true);
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
                actionref(PostPrint_Promoted; PostPrint)
                {
                }
                actionref(CheckBudget_Promoted; CheckBudget)
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

                actionref(Delegate_Promoted; Delegate)
                {
                }
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
        ApprovalsMgmt: Codeunit "Approval Mgmt.";

        ChequePayment: Boolean;
        FundsMngt: Codeunit "Funds. Post Mngt.";
        ResponseTxt: Integer;

        DocPosted: Boolean;
        bankledger: Record "Bank Account Ledger Entry";

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

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Post,&Post Preview';
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