page 50092 "Petty Cash"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Payments Header";
    SourceTableView = where("Payment Type" = filter("Petty Cash"));
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
                    StyleExpr = true;
                    Visible = false;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field(Date; Rec.Date)
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Date field';
                }

                field(Currency; Rec.Currency)
                {

                    Enabled = true;
                    Visible = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency field';
                }
                field("Account Type"; Rec."Account Type")
                {

                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency field';
                }
                field("Account No."; Rec."Account No.")
                {
                    Enabled = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field';
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field';
                }

                field("Paying Bank Account"; Rec."Paying Bank Account")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Paying Bank Account field';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    Caption = 'Posting Date';
                    StyleExpr = true;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field';
                }
                field(Payee; Rec.Payee)
                {

                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payee field';
                }
                field("Payment Narration"; Rec."Payment Narration")
                {

                    ShowMandatory = true;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Narration field';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {

                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Pay Mode field';

                    trigger OnValidate()
                    begin
                        SetControlAppearance();
                    end;
                }
            }
            part(ImprestLines; "Petty Cash Lines")
            {
                Caption = 'Lines';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                SubPageLink = No = field("No.");
                ApplicationArea = All;
            }
            group(Control49)
            {
                Caption = 'Trail Information';
                Editable = false;
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field';
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Date field';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    StyleExpr = true;
                    Style = StandardAccent;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Cashier field';
                }

                field("User Id"; Rec."Created By")
                {
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Id field';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    StyleExpr = true;
                    Style = StandardAccent;
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
            systempart(Control16; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control17; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; Links)
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
                    Rec.TestField(Posted, true);
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(Report::"Payment Voucher", true, true, Rec);
                    Rec.Reset;
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
                    Rec.TestField("Payment Narration");
                    ApprovalsMgmt.OnSendPVApprovalRequest(Rec);
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

    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance();


    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Payment Type" := Rec."Payment Type"::"Petty Cash";
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance();

    end;

    var
        ApprovalEntry: Record "Approval Entry";
        CashManagementSetup: Record "Cash Management Setups";
        GeneralLedgerSetup: Record "General Ledger Setup";
        PaymentMethod: Record "Payment Method";
        Payments: Record "Payments Header";
        UserSetup: Record "User Setup";
        FundsMngt: Codeunit "Funds. Post Mngt.";
        ResponseTxt: Integer;

        ApprovalsMgmt: Codeunit "Approval Mgmt.";
        CanCancelApprovalForPayment: Boolean;

        ChequePayment: Boolean;

        DocPosted: Boolean;

        OpenApprovalEntriesExist: Boolean;
        ShowCommentFactbox: Boolean;
        bankledger: Record "Bank Account Ledger Entry";

        ShowDim: Boolean;
        ErrorMsg: Text;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin



    end;

    local procedure ShowDimFields()
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