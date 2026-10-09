page 50088 "Interbank Transfer Card"
{
    ApplicationArea = All;
    Caption = 'Interbank Transfer Card';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "Interbank Transfer";
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
                    Visible = false;
                    Style = StandardAccent;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
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
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ToolTip = 'Specifies the value of the Amount Recieved field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Amount Recieved LCY"; Rec."Amount Recieved LCY")
                {
                    ToolTip = 'Specifies the value of the Amount Recieved LCY field.';
                    Editable = false;
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Paying Account No."; Rec."Paying Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Paying Account Name"; Rec."Paying Account Name")
                {
                    ToolTip = 'Specifies the value of the Paying Account Name. field.';
                    StyleExpr = true;
                    Editable = false;
                    Style = StandardAccent;
                }

            }
            group("Trail Information")
            {
                Editable = false;
                field(Cashier; Rec.Cashier)
                {
                    ToolTip = 'Specifies the value of the Cashier field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }

                field("Interbank Journal Batch"; Rec."Interbank Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Interbank Journal Batch field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Interbank Journal Template"; Rec."Interbank Journal Template")
                {
                    ToolTip = 'Specifies the value of the Interbank Journal Template field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ToolTip = 'Specifies the value of the Created Date Time field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ToolTip = 'Specifies the value of the Date Posted field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }

                field("Time Posted"; Rec."Time Posted")
                {
                    ToolTip = 'Specifies the value of the Time Posted field.';
                    StyleExpr = true;
                    Style = StandardAccent;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
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
                    CurrPage.Close();
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
                    Rec.CheckRequiredItem(0);
                    ApprovalMngt.OnSendInterBankApprovalRequest(Rec);
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
                    ApprovalMngt.OnCancelInterBankApprovalRequest(Rec, true, true);
                    CurrPage.Close();
                end;
            }
            action("Open Approval Request")
            {
                Image = Category;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    ApprovalMngt.OnOpenInterBankApprovalRequest(Rec, true, true);
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
                    ApprovalMngt.OpenApprovalEntriesPage(Rec."No.", Database::"Interbank Transfer");

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
                    ResponseTxt := RegMngt.ConfirmPost();
                    case ResponseTxt of
                        1:
                            begin
                                Rec."Check Line" := true;
                            end else begin
                            Rec."Check Line" := false;
                        end;
                    end;
                    FundsMngt.PostInterBankTransfer(Rec, true);
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
                    FundsMngt.PostInterBankTransfer(Rec, true);
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
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("&Print_Promoted"; "&Print")
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

                actionref("Open Approval Request_Promoted"; "Open Approval Request")
                {
                }
                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
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
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
        Rec.Validate(Date, Today);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
        Rec.Validate(Date, Today);

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
        ResponseTxt: Integer;
        RegMngt: Codeunit "Register Management";
        PaymentRec: Record "Payments Header";
        CanCancelApprovalForPayment: Boolean;
        FundsMngt: Codeunit "Funds. Post Mngt.";

        ChequePayment: Boolean;
        ApprovalMngt: Codeunit "Approval Mgmt.";

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
