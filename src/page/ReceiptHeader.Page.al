page 50894 "Receipt Header"
{
    DeleteAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    PopulateAllFields = true;
    SourceTable = "Receipts Header";
    SourceTableView = where("Receipt Type" = const(Bank));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Control1)
            {
                Caption = 'General';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Posting Date"; Rec.Date)
                {
                    Editable = statuseditable;
                    Caption = 'Transaction Date';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Type';
                    Editable = false;
                    Visible = false;

                }
                field("Allow Multiple Receipts"; Rec."Allow Multiple Receipts")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    ApplicationArea = All;
                    visible = false;
                }
                field(ExchangeRate; Rec.ExchangeRate)
                {
                    Caption = 'ExchangeRate';
                    ApplicationArea = All;
                    visible = false;
                }
                field("Bank Date"; Rec."Document Date")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Document Date';
                    ApplicationArea = All;
                }
                field("Copy Receipt"; Rec."Copy Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Copy Receipt field.';
                }
                field("Bulk Receipt"; Rec."Bulk Receipt")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bulk Receipt field.';
                    visible = false;
                }
                group("Copy Old Receipt")
                {
                    Visible = Rec."Copy Receipt";
                    field("Copy Receipt No."; Rec."Copy Receipt No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Copy Receipt No. field.';
                    }
                }
                field("Account Type"; Rec."Account Type")
                {

                    Caption = 'Account Type';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = statuseditable;
                    Caption = 'Bank No.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    Editable = statuseditable;
                    Visible = false;
                    Caption = 'Bank Code';
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    Caption = 'Bank Name';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Caption = 'Cheque No.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Amount Recieved';
                    ApplicationArea = All;
                }

                field("Amount Recieved LCY"; Rec."Amount Recieved LCY")
                {
                    Editable = true;
                    Caption = 'Amount Recieved LCY';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Transaction Options"; Rec."Transaction Options")
                {
                    ApplicationArea = All;
                    caption = 'Suggest Account';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    Caption = 'Member No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }


                field("Received From"; Rec."Received From")
                {
                    Editable = statuseditable;
                    Caption = 'Received From';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    Caption = 'On Behalf Of';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Total Amount"; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }

                field("Group Code"; Rec."Group Code")
                {
                    Visible = false;
                    Caption = 'Group Code';
                    ApplicationArea = All;
                }
                field("Group Name"; Rec."Group Name")
                {
                    Visible = false;
                    Caption = 'Group Name';
                    ApplicationArea = All;
                }
            }
            part("Receipt Lines"; "Receipts Line")
            {
                Caption = 'Receipt Line';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                SubPageLink = No = FIELD("No."), "Member No." = field("Member No."),
                "Allow Multiple Receipts" = field("Allow Multiple Receipts");
                ApplicationArea = All;
                Visible = not Rec."Bulk Receipt";
                UpdatePropagation = Both;
            }
            part("Bulk Receipt Lines"; "Bulk Receipts Line")
            {
                Caption = 'Bulk Receipt Line';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                SubPageLink = No = FIELD("No.");
                ApplicationArea = All;
                Visible = Rec."Bulk Receipt";
                UpdatePropagation = Both;
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                Editable = false;
                field("Receipt Journal Template"; Rec."Receipt Journal Template")
                {
                    Caption = 'Journal Template';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Receipt Journal Batch"; Rec."Receipt Journal Batch")
                {
                    Caption = 'Journal Batch';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        FunctionName := '';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 1);
                        DimVal.SetRange(DimVal.Code, Rec."Global Dimension 1 Code");
                        if DimVal.Find('-') then begin
                            FunctionName := DimVal.Name;
                        end;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        BudgetCenterName := '';
                        DimVal.Reset;
                        DimVal.SetRange(DimVal."Global Dimension No.", 2);
                        DimVal.SetRange(DimVal.Code, Rec."Shortcut Dimension 2 Code");
                        if DimVal.Find('-') then begin
                            BudgetCenterName := DimVal.Name;
                        end;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Caption = 'Responsibility Center';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Cashier; Rec.Cashier)
                {
                    Editable = false;
                    Caption = 'Cashier';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    Editable = false;
                    Caption = 'Date Posted';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    Editable = false;
                    Caption = 'Time Posted';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    Caption = 'Posted';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }

        }
        area(FactBoxes)
        {

            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No."),
                                             "Account Category" = const("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part(Control8; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No."),
                                             "Account Category" = const("Shares Capital");
                Visible = true;
                ApplicationArea = All;
            }
           
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Member  List")
            {
                Image = Customer;
                RunObject = Page "Membership Individual List";
                Caption = 'Member  List';
                ApplicationArea = All;
            }
            action(Print)
            {
                Caption = 'Print Preview';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TestField(Posted, true);
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(Report::"Official Receipt", true, true, Rec);
                    Rec.Reset;
                end;
            }

            action("Print Uncleared-Cheque Receipt")
            {
                Caption = 'Print Uncleared-Cheque Receipt';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    REPORT.Run(Report::"Official Receipt", true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Enabled = Rec."Approval Status" <> Rec."Approval Status"::Posted;
                Image = PostedCreditMemo;
                ShortCutKey = 'F9';
                ApplicationArea = All;

                trigger OnAction()

                var
                    CustMember: Record Member;
                begin

                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');
                    Rec.TestField("Application Type");
                    Rec.TestField("Account Type");
                    Rec.TestField("Account No.");
                    Rec.CalcFields("Total Amount");
                    if Rec."Amount Recieved" <> Rec."Total Amount" then Error(ErrorOnAmtDifference);
                    if Rec."Application Type" = Rec."Application Type"::Member then begin
                        Rec.TestField("Member No.");
                        Rec.TestField(Posted, false);
                    end;
                    case ConfirmPost() of
                        1:
                            begin
                                Rec.TestField("Account Type");
                                Rec.TestField("Account No.");

                                Rec.TestField(Posted, false);
                                if CheckPostDated then
                                    Error('One of the Receipt Lines is Post Dated');
                                Rec.TestField("Application Type");
                                BnkMngt.PerformPostReceipt(Rec, Rec."Receipt Journal Template", Rec."Receipt Journal Batch",
                                Rec."Global Dimension 1 Code", Rec."Shortcut Dimension 2 Code", 0, 1);

                            end;
                        2:
                            begin
                                Rec.TestField("Account Type");
                                Rec.TestField("Application Type");
                                Rec.TestField("Account No.");
                                Rec.TestField(Posted, false);
                                if CheckPostDated then
                                    Error('One of the Receipt Lines is Post Dated');
                                BnkMngt.PerformPostReceipt(Rec, Rec."Receipt Journal Template", Rec."Receipt Journal Batch",
                                Rec."Global Dimension 1 Code", Rec."Shortcut Dimension 2 Code", 1, 1);
                            end;
                        3:
                            begin
                                Rec.TestField("Account Type");
                                Rec.TestField("Account No.");
                                Rec.TestField("Application Type");
                                Rec.TestField(Posted, false);
                                if CheckPostDated then
                                    Error('One of the Receipt Lines is Post Dated');
                                BnkMngt.PerformPostReceipt(Rec, Rec."Receipt Journal Template", Rec."Receipt Journal Batch",
                                Rec."Global Dimension 1 Code", Rec."Shortcut Dimension 2 Code", 0, 0);
                            end;
                        4:
                            begin
                                exit
                            end;
                    end;
                end;
            }

            action("Post & Print")
            {
                Caption = 'Post + Print';
                Image = PostPrint;
                ShortCutKey = 'Shift+F9';
                Enabled = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TestField("Account Type");
                    Rec.TestField("Account No.");
                    Rec.TestField(Posted, false);
                    Rec.CalcFields("Total Amount");
                    if Rec."Amount Recieved" <> Rec."Total Amount" then Error(ErrorOnAmtDifference);
                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');
                    RegMngt.UpdateReceiptLine(Rec."No.");

                    if ConfirmPost() = 1 then begin
                        BnkMngt.PerformPostReceipt(Rec, Rec."Receipt Journal Template",
                        Rec."Receipt Journal Batch", Rec."Global Dimension 1 Code",
                        Rec."Shortcut Dimension 2 Code", 1, 1);
                    end else begin
                        exit
                    end;
                end;
            }

            action("Post Preview")
            {
                Caption = 'Post Preview';
                Image = PreviewChecks;
                ShortCutKey = 'Shift+F9';
                Enabled = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    JournalLine: Record "Gen. Journal Line";
                begin
                    Rec.TestField("Account Type");
                    Rec.TestField("Account No.");
                    Rec.TestField(Posted, false);
                    if Rec."Amount Recieved" <> Rec."Total Amount" then Error(ErrorOnAmtDifference);
                    if CheckPostDated then
                        Error('One of the Receipt Lines is Post Dated');
                    BnkMngt.PerformPostReceipt(Rec, Rec."Receipt Journal Template",
                    Rec."Receipt Journal Batch", Rec."Global Dimension 1 Code",
                    Rec."Shortcut Dimension 2 Code", 0, 0);

                end;
            }

            action("Suggest Account")
            {
                Caption = 'Suggest Accounts';
                Image = Group;
                ShortCutKey = 'Shift+F9';
                Enabled = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    JournalLine: Record "Gen. Journal Line";
                begin
                    Rec.TestField("Account Type");
                    Rec.TestField("Account No.");
                    Rec.TestField(Posted, false);
                    Rec.TestField("Member No.");
                    case SuggestAccount() of
                        0:
                            exit;
                        1:
                            RegMgt.CreatCustReceipLine(Rec."No.", 1);
                        2:
                            RegMgt.CreatCustReceipLine(Rec."No.", 2);
                        3:
                            RegMgt.CreatCustReceipLine(Rec."No.", 0);
                    end;


                end;
            }
            action(Memberstatement)
            {
                Caption = 'Statement of Account';
                Image = PreviewChecks;
                ApplicationArea = All;
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
                ApplicationArea = All;
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
                ApplicationArea = All;
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
                ApplicationArea = All;
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
                ApplicationArea = All;
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
                ApplicationArea = All;
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
                ApplicationArea = All;
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
                ApplicationArea = All;
                trigger OnAction()
                begin
                end;
            }
            action("E-Mail Receipt")
            {
                Caption = 'E-Mail Receipt';
                Image = Email;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustMembr: Record Member;
                    CreateNotif: Codeunit "SMS Notification";
                begin
                    CreateNotif.SendEmailOnReceiptPayment(Rec."No.");
                end;
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
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
                actionref("Post & Print_Promoted"; "Post & Print")
                {
                }
                actionref("Post Preview_Promoted"; "Post Preview")
                {
                }
                actionref("Suggest Account_Promoted"; "Suggest Account")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(Print_Promoted; Print)
                {
                }
                actionref("Print Uncleared-Cheque Receipt_Promoted"; "Print Uncleared-Cheque Receipt")
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
            }
            group(Category_Category6)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Member  List_Promoted"; "Member  List")
                {
                }
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

                actionref(Attachments_Promoted; Attachments)
                {
                }
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
        OnAfterGetCurrRecords;
        CurrPageUpdate;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin


        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt."Created By", UserId);
        if Rcpt.Count > 3 then begin
            if Confirm('There are still some unposted receipts. Continue?', false) = false then begin
                Error('There are still some unposted receipts. Please utilise them first');
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec."Shortcut Dimension 3 Code" := UserMgt.GetSetDimensions(UserId, 3);
        Rec.Validate("Shortcut Dimension 3 Code");
        Rec."Shortcut Dimension 4 Code" := UserMgt.GetSetDimensions(UserId, 4);
        Rec.Validate("Shortcut Dimension 4 Code");
        Rec."Receipt Type" := Rec."Receipt Type"::Bank;
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
        Rec."Application Type" := Rec."Application Type"::Member;

        UpdateControls;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("Receipt Journal Template");
        UserSetup.TestField("Receipt Journal Batch");

        if UserMgt.GetSalesFilter() <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter());
            Rec.FilterGroup(0);
        end;
        if Rec.Posted then CurrPage.Editable := false;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        ReceiptLine: Record "Receipt Line";
        tAmount: Decimal;
        DefaultBatch: Record "Gen. Journal Batch";
        FunctionName: Text[100];
        BudgetCenterName: Text[100];
        BankName: Text[100];
        Rcpt: Record "Receipts Header";
        RunPeriodic: Codeunit "Credit Mgmt.";
        RcptNo: Code[20];
        DimVal: Record "Dimension Value";
        BankAcc: Record "Bank Account";
        UserSetup: Record "Cash Office User Template";
        JTemplate: Code[10];
        JBatch: Code[10];
        GLine: Record "Gen. Journal Line";
        LineNo: Integer;
        SavingsAc: Record "Account Banking";
        BAmount: Decimal;
        LInterest: Decimal;
        SRSetup: Record "Sales & Receivables Setup";

        Post: Boolean;
        USetup: Record "Cash Office User Template";
        RegMngt: Codeunit "Register Management";
        RegisterNumber: Integer;
        PrdFac: Record "Product Factory";
        FactPrd: Record "Product Factory";
        FromNumber: Integer;
        ToNumber: Integer;
        StrInvoices: Text[250];
        UserMgt: Codeunit "User Setup Management BR";
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";
        IsCashAccount: Boolean;
        RegMgt: Codeunit "Register Management";
        ErrorOnAmtDifference: Label 'Amount received must be equal to total amount';

        StatusEditable: Boolean;
        DocNoVisible: Boolean;
        Line: Integer;
        SavingsAccounts: Record "Account Banking";
        CreditAccounts: Record "Credit Account";
        Loans: Record Loans;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        MgtUnit: Codeunit "Periodic Activities Mgt.";
        CustEmployer: Record Customer;
        DAMOUNT: Decimal;
        LoanCharges: Record "Loan Product Charges";
        Docx: Codeunit "Doc. Mngt";
        ReceiptHeader: Record "Receipts Header";

        Filename: Text[50];

        MailContents: Text[200];
        MailContents2: Text[100];
        MailContent: Text;
        SavingsAccountsRec: Record "Account Banking";
        SavingsLedgerEntryRec: Record "Banking A/c Ledger Entry";
        CreditLedgerEntryRec: Record "Loan Ledger Entry";
        CreditAccountsRec: Record "Credit Account";
        SavingProductName: array[100] of Text;
        SavingsAmount: array[100] of Decimal;
        MailContents3: Text[200];
        i: Integer;
        BnkMngt: Codeunit "Banking Procedure Mngt.";

    procedure CheckPostDated() Exists: Boolean
    begin

        Exists := false;
        BAmount := 0;
        ReceiptLine.Reset;
        ReceiptLine.SetRange(ReceiptLine.No, Rec."No.");
        ReceiptLine.SetRange(ReceiptLine."Pay Mode", ReceiptLine."Pay Mode"::Cheque);
        if ReceiptLine.Find('-') then begin
            repeat
                if ReceiptLine."Cheque/Deposit Slip Date" > Today then begin
                    Exists := true;
                    exit;

                end;
            until ReceiptLine.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CheckBnkCurrency(BankAcc: Code[20]; CurrCode: Code[20])
    var
        BankAcct: Record "Bank Account";
    begin
        BankAcct.Reset;
        BankAcct.SetRange(BankAcct."No.", BankAcc);
        if BankAcct.Find('-') then begin
            if BankAcct."Currency Code" <> CurrCode then begin
                if BankAcct."Currency Code" = '' then
                    Error('This bank [%1:- %2] can only transact in LOCAL Currency', BankAcct."No.", BankAcct.Name)
                else
                    Error('This bank [%1:- %2] can only transact in %3', BankAcct."No.", BankAcct.Name, BankAcct."Currency Code");
            end;
        end;
    end;

    local procedure OnAfterGetCurrRecords()
    begin

        FunctionName := '';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.", 1);
        DimVal.SetRange(DimVal.Code, Rec."Global Dimension 1 Code");
        if DimVal.Find('-') then begin
            FunctionName := DimVal.Name;
        end;
        BudgetCenterName := '';
        DimVal.Reset;
        DimVal.SetRange(DimVal."Global Dimension No.", 2);
        DimVal.SetRange(DimVal.Code, Rec."Shortcut Dimension 2 Code");
        if DimVal.Find('-') then begin
            BudgetCenterName := DimVal.Name;
        end;
        BankName := '';
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.", Rec."Bank Code");
        if BankAcc.Find('-') then begin
            BankName := BankAcc.Name;
        end;
    end;

    procedure UpdateControls()
    begin
        if Rec.Posted = false then
            StatusEditable := true
        else
            StatusEditable := false;
    end;

    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        OnAfterGetCurrRecords;

    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer;
    begin

    end;

    local procedure ConfirmPost(): Integer
    var
        DefaultOption: Integer;
        ShipInvoiceQst: Label '&Post,&Post+Print,&Post Preview,&Cancel';
        Selection: Integer;
        PassInt: Integer;
    begin
        IF DefaultOption > 4 THEN
            DefaultOption := 4;
        IF DefaultOption <= 0 THEN
            DefaultOption := 1;
        Selection := STRMENU(ShipInvoiceQst, DefaultOption, 'Post Option');
        PassInt := Selection;
        IF Selection = 0 THEN
            EXIT;
        exit(PassInt);
    end;

    local procedure SuggestAccount(): Integer
    var
        DefaultOption: Integer;
        ShipInvoiceQst: Label '&Bosa,&Loan,&Bosa+Fosa,&Cancel';
        Selection: Integer;
        PassInt: Integer;
    begin
        IF DefaultOption > 3 THEN
            DefaultOption := 3;
        IF DefaultOption <= 0 THEN
            DefaultOption := 1;
        Selection := STRMENU(ShipInvoiceQst, DefaultOption, 'Suggest Accounts Options');
        PassInt := Selection;
        IF Selection = 0 THEN
            EXIT;
        exit(PassInt);
    end;
}




