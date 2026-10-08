page 50843 "Teller Transaction"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Teller Transaction";
    SourceTableView = SORTING("No.")
                      ORDER(Descending);
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Transactions)
            {
                Caption = 'Transactions';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = Amont;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = AccNo;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    trigger OnValidate()
                    begin
                        if FactProd.Get(Rec."Product Type") then begin
                            if FactProd."Account Validation" = FactProd."Account Validation"::Signatories then begin
                                SigVisible := true;
                                SignatoryEditable := true
                            end else begin
                                SigVisible := false;
                                SignatoryEditable := false;
                            end;
                        end
                    end;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(mNO; Rec."Member No.")
                {
                    Caption = 'Member No.';
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = Amont;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = TransType;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                    trigger OnValidate()
                    begin
                        FChequeVisible := false;
                        BChequeVisible := false;
                        BReceiptVisible := false;
                        BOSAReceiptChequeVisible := false;
                        AllAmount := false;
                        DiscCH := false;
                        FLien := false;

                        if Rec.Type = Rec.Type::"Cheque Deposit" then begin
                            FChequeVisible := true;
                            DiscCH := true;
                        end;
                        if (Rec.Type = Rec.Type::"Bankers Cheque") or (Rec.Type = Rec.Type::"Account Zerolize") then
                            BChequeVisible := true;
                        if Rec.Type = Rec.Type::"Credit Receipt" then begin
                            BReceiptVisible := true;
                            AllAmount := true;
                        end;
                        if Rec.Type = Rec.Type::"Credit Cheque" then begin
                            FChequeVisible := true;
                            BOSAReceiptChequeVisible := true;
                            AllAmount := true;
                        end;
                        if Rec.Type = Rec.Type::Lien then begin
                            FLien := true;
                        end;
                        if FactProd.Get(Rec."Product Type") then begin
                            if FactProd."Account Validation" = FactProd."Account Validation"::Signatories then begin
                                SigVisible := true;
                                SignatoryEditable := true
                            end else begin
                                SigVisible := false;
                                SignatoryEditable := false;
                            end;
                        end;
                    end;
                }
                field("Transaction Options"; Rec."Transaction Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Deposited By"; Rec.Remarks)
                {
                    Editable = Remarrrks;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = Currr;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Visible = false;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Product Type"; Rec."Product Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Allocated Amount"; Rec."Allocated Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                group(BCheque)
                {
                    Caption = '.';
                    Visible = BChequeVisible;
                    field(Payee; Rec.Payee)
                    {
                        ApplicationArea = All;
                    }
                    field("Post Dated"; Rec."Post Dated")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            Rec.TestField("Post Dated", false);
                        end;
                    }
                    field("Bankers Cheque No"; Rec."Bankers Cheque No")
                    {
                        Caption = 'Bankers Cheque No';
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                }
                group(BReceipt)
                {
                    Caption = '.';
                    Visible = BReceiptVisible;
                    field("Member No."; Rec."Member No.")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                }
                group("Lien Transaction")
                {
                    Caption = '.';
                    Visible = FLien;
                    field("Expiry Date"; Rec."Expected Maturity Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
                group(FCheque)
                {
                    Caption = '.';
                    Visible = FChequeVisible;
                    field("Drawee Bank Code"; Rec."Drawee Bank Code")
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field("Drawee Bank Branch"; Rec."Drawee Bank Branch")
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field("Cheque Type"; Rec."Cheque Type")
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field(BchequeNo; Rec."Cheque No")
                    {
                        Caption = ' Cheque No';
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }

                    field("Bank Account"; Rec."Bank Account")
                    {
                        Caption = 'Clearing Bank';
                        Editable = false;
                        Visible = true;
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field("Cheque Date"; Rec."Cheque Date")
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field("Cheque Status"; Rec."Cheque Status")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field("Expected Maturity Date"; Rec."Expected Maturity Date")
                    {
                        Editable = false;
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    field("Cheque stopping Reasons"; Rec."Cheque stopping Reasons")
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        ShowMandatory = true;
                        StyleExpr = TRUE;
                    }
                    group(BOSAReceiptCheque)
                    {
                        Caption = '.';
                        Visible = BOSAReceiptChequeVisible;
                    }
                }

                field("Book Balance"; Rec."Book Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Available Balance"; Rec."Available Balance")
                {
                    Caption = 'Available Balance';
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("New Account Balance"; Rec."New Account Balance")
                {
                    Caption = 'New Balance';
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("ID No"; Rec."ID No")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

            }
            group("Signing Mandates")
            {
                Editable = false;
                Visible = SigVisible;
                field("Signing Instructions"; Rec."Signing Instructions")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    ShowCaption = false;
                    StyleExpr = true;
                }
            }
            part(Lines; "Signing Instructions")
            {
                Caption = 'Instruction Lines';
                ApplicationArea = All;
                Editable = true;
                Visible = SignatoryEditable;

                SubPageLink = "No." = field("No.");

            }
            group("Trail Information")
            {
                field(Cashier; Rec.Cashier)
                {
                    Caption = 'Teller ID';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Till Name"; Rec."Till Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Attempted Self Transaction"; Rec."Attempted Self Transaction")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

            }
        }
        area(factboxes)
        {
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Member No.");
                ApplicationArea = All;
            }
            part(Control11; "Account Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Account No.");
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Transaction)
            {
                Caption = 'Transaction';
                action(Statement)
                {
                    Image = SendAsPDF;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Account.Reset;
                        Account.SetRange(Account."No.", Rec."Account No.");
                        if Account.Find('-') then
                            Report.RUN(Report::"Statement of Account Banking", true, false, Account);
                    end;
                }
                action("Account Page")
                {
                    Caption = 'Account Page';
                    Image = Vendor;
                    RunObject = Page "Savings Account Card";
                    RunPageLink = "No." = FIELD("Account No.");
                    ApplicationArea = All;
                }
                action("Stop Cheques")
                {
                    Caption = 'Stop Cheque';
                    Image = Stop;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        BnkProcedureMngt: Codeunit "Banking Procedure Mngt.";
                    begin
                        Rec.TestField("Cheque stopping Reasons");
                        BnkProcedureMngt.StopCheque(Rec);
                    end;
                }
                action("Mark Cheques as Reversed")
                {
                    Caption = 'Mark Cheque as Reversed';
                    Image = Stop;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        BnkProcedureMngt: Codeunit "Banking Procedure Mngt.";
                    begin
                        if Confirm('Are you sure you want to Mark this Cheque as Reversed?', true) = false then exit;
                        BnkProcedureMngt.MarkChequeAsReversed(Rec);
                    end;
                }
                action("Credit Receipts")
                {
                    Image = Allocate;
                    RunObject = Page "Teller Transaction Line";
                    RunPageLink = "Transaction No." = FIELD("No.");
                    Visible = AllAmount;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        TLines: Record "Cashier Transaction Line";
                        TellerLine: Record "Cashier Transaction Line";
                        Accredit: Record "Account Credit";
                        Loan: Record Loans;
                        ProductType: Record "Product Factory";
                        MemberContribt: Record "Member Monthly Contribution";
                        BnkMngt: Codeunit "Banking Procedure Mngt.";
                    begin
                        if Rec.Type = Rec.Type::"Credit Receipt" then begin
                            Rec.TestField(Amount);
                        end;
                    end;
                }
                action(Signatory)
                {
                    Image = SocialListening;
                    RunObject = Page "Signatories List";
                    RunPageLink = "Account No." = FIELD("Account No.");
                    ApplicationArea = All;
                }

                action("Kin Details")
                {
                    Image = Group;
                    RunObject = Page "Account kin List";
                    RunPageLink = "Account No." = FIELD("Account No.");
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            action("Post & Print")
            {
                Image = PostPrint;
                ShortCutKey = 'F9';
                ApplicationArea = All;
                trigger OnAction()
                var
                    SaccoT: Codeunit "Banking Procedure Mngt.";
                    BankAccount: Record "Bank Account";
                    Text00001: Label 'WARNING! Till balance almost below the minimum Reorder level. Kindly make sure you replenish';
                begin
                    Temp.Get(UserId);
                    BankAccount.Reset;
                    BankAccount.SetRange(BankAccount."No.", Temp."Default  Bank");
                    if BankAccount.Find('-') then begin
                        BankAccount.CalcFields(BankAccount."Balance (LCY)");
                        if BankAccount."Balance (LCY)" = 0 then
                            Error('This Bank account has zero Balance');
                        if BankAccount."Balance (LCY)" <= Temp."Reorder Level" then
                            Message(Text00001);
                    end;
                    Rec.TestField("Attempted Self Transaction", false);
                    CODEUNIT.Run(CODEUNIT::"Alt. Channel (Teller Mngt.)", Rec);
                    Commit;
                    VarVariant := Rec;
                    if Rec."Approval Status" <> Rec."Approval Status"::"Pending Approval" then
                        DocMngt.DocPrintstatement(VarVariant, 0);
                    CurrPage.Close;
                end;
            }
            action("Reset Date")
            {
                Image = Category;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Trans.Reset;
                    Trans.SetRange(Trans.Posted, false);
                    Trans.SetRange(Trans."No.", Rec."No.");
                    if Trans.Find('-') then begin
                        Rec."Transaction Date" := Today;
                        Rec."Transaction Time" := Time;
                        Rec.Modify;
                        Message('Transaction date updated');
                    end else
                        Error('Transaction already posted');
                end;
            }
            action("Reprint Slip")
            {
                Caption = 'Reprint Slip';
                Image = DepositSlip;
                ApplicationArea = All;

                trigger OnAction()
                var
                    TellerTrans: Record "Teller Transaction";
                begin
                    Rec.TestField(Posted);
                    Trans.Reset;
                    Trans.SetRange(Trans."No.", Rec."No.");
                    if Trans.Find('-') then begin
                        Trans.Dublicate := true;
                        Trans.Modify;
                        Commit;
                    end;
                    VarVariant := Rec;
                    DocMngt.DocPrintstatement(VarVariant, 0);
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = PostedCreditMemo;
                ShortCutKey = 'F9';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SaccoT: Codeunit "Banking Procedure Mngt.";
                    BankAccount: Record "Bank Account";
                    Temp: Record "Banking User Template";

                begin
                    Temp.Get(UserId);

                    BankAccount.Reset;
                    BankAccount.SetRange(BankAccount."No.", Temp."Default  Bank");
                    if BankAccount.Find('-') then begin
                        BankAccount.CalcFields(BankAccount."Balance (LCY)");
                        if BankAccount."Balance (LCY)" = 0 then
                            Error('This Bank account has zero Balance');
                    end;

                    CODEUNIT.Run(CODEUNIT::"Alt. Channel (Teller Mngt.)", Rec);
                    CurrPage.Close;
                end;
            }

            action(PostPreview)
            {

                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ShortCutKey = 'F9';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SaccoT: Codeunit "Banking Procedure Mngt.";
                    BankAccount: Record "Bank Account";
                    Temp: Record "Banking User Template";
                    TellMngt: Codeunit "Teller-Post (Yes/No)";

                begin
                    Temp.Get(UserId);
                    BankAccount.Reset;
                    BankAccount.SetRange(BankAccount."No.", Temp."Default  Bank");
                    if BankAccount.Find('-') then begin
                        BankAccount.CalcFields(BankAccount."Balance (LCY)");
                        if BankAccount."Balance (LCY)" = 0 then
                            Error('This Bank account has zero Balance');
                    end;
                    TellMngt.InitPost(Rec.Type, Rec, Rec."Journal Template Name",
                        Rec."Journal Batch Name",
                          Rec."Till Code", Rec."Global Dimension 1 Code",
                          Rec."Global Dimension 2 Code", 0);
                end;
            }
            action("Till Balance")
            {
                Image = BankAccountLedger;
                Enabled = true;
                RunObject = Page "Teller Tills";
                RunPageLink = "No." = FIELD("Till Code");
                ApplicationArea = All;
            }


            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = false;
                    Image = SendApprovalRequest;
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        ApprovalsMgmt.OnSendTellerTransactionApprovalRequest(VarVariant)

                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = CancelApprovalRequest;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        ApprovalsMgmt.OnCancelTellerTransactionApprovalRequest(VarVariant, true, true)
                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Open Approval Re&quest';
                    Enabled = false;
                    Image = Category;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        VarVariant := Rec;
                        ApprovalsMgmt.OnOpenTellerTransactionApprovalRequest(VarVariant, true, true)
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approval;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147202);
                    end;
                }
            }
            group(Action13)
            {
                action("Discount Cheque")
                {
                    Image = MakeAgreement;
                    Visible = DiscCH;
                    ApplicationArea = All;
                }
                action("Stop Cheque")
                {
                    Image = VoidCheck;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        SaccoT: Codeunit "Banking Procedure Mngt.";
                    begin
                        SaccoT.StopCheque(Rec);
                    end;
                }
                action("Clear Lien")
                {
                    Image = Allocate;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        if Rec.Type <> Rec.Type::Lien then
                            Error('Only applicable to Lien');
                        if Confirm('Are you sure you want to process the selected transactions?', false) = false then exit;
                        approvalsMgmt.OnSendTellerTransactionApprovalRequest(Rec);
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
                actionref(PostPreview_Promoted; PostPreview)
                {
                }
                actionref("Credit Receipts_Promoted"; "Credit Receipts")
                {
                }
                actionref("Post & Print_Promoted"; "Post & Print")
                {
                }
                actionref("Stop Cheques_Promoted"; "Stop Cheques")
                {
                }
                actionref("Mark Cheques as Reversed_Promoted"; "Mark Cheques as Reversed")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Reset Date_Promoted"; "Reset Date")
                {
                }
                actionref("Reprint Slip_Promoted"; "Reprint Slip")
                {
                }
                actionref("Till Balance_Promoted"; "Till Balance")
                {
                }
                actionref("Discount Cheque_Promoted"; "Discount Cheque")
                {
                }
                actionref("Stop Cheque_Promoted"; "Stop Cheque")
                {
                }
                actionref("Clear Lien_Promoted"; "Clear Lien")
                {
                }
                actionref(Statement_Promoted; Statement)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';

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
            group(Category_Category5)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Account Page_Promoted"; "Account Page")
                {
                }
                actionref(Signatory_Promoted; Signatory)
                {
                }
                actionref("Kin Details_Promoted"; "Kin Details")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Category10_caption', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        FChequeVisible := false;
        BChequeVisible := false;
        BReceiptVisible := false;
        BOSAReceiptChequeVisible := false;
        AllAmount := false;
        DiscCH := false;
        FLien := false;
        SignatoryEditable := false;
        SigVisible := false;

        if FactProd.Get(Rec."Product Type") then begin
            if FactProd."Account Validation" = FactProd."Account Validation"::Signatories then begin
                SigVisible := true;
                SignatoryEditable := true
            end else begin
                SigVisible := false;
                SignatoryEditable := false;
            end;
        end;

        if Rec.Type = Rec.Type::"Cheque Deposit" then begin
            FChequeVisible := true;
            DiscCH := true;
        end;

        if (Rec.Type = Rec.Type::"Bankers Cheque") or (Rec.Type = Rec.Type::"Account Zerolize") then
            BChequeVisible := true;
        if Rec.Type = Rec.Type::"Credit Receipt" then begin
            BReceiptVisible := true;
            AllAmount := true;
        end;

        if Rec.Type = Rec.Type::"Credit Cheque" then begin
            FChequeVisible := true;
            BOSAReceiptChequeVisible := true;
            AllAmount := true;
        end;

        if Rec.Type = Rec.Type::Lien then begin
            FLien := true;
        end;

        SetControlAppearance;
        UpdateControl;
    end;

    trigger OnInit()
    begin
        UpdateControl;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Trans.Reset;
        Trans.SetRange(Trans.Cashier, UserId);
        Trans.SetRange(Trans.Posted, false);
        if Trans.Count > 100 then begin
            Error(ErrorOnExcessDocsInit);
        end;
    end;

    trigger OnOpenPage()
    begin

        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;


    var
        
        FChequeVisible: Boolean;
        
        BChequeVisible: Boolean;
        
        BReceiptVisible: Boolean;
        
        BOSAReceiptChequeVisible: Boolean;
        SigVisible: Boolean;
        FLien: Boolean;
        Account: Record "Account Banking";
        Temp: Record "Banking User Template";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        AccNo: Boolean;
        TransType: Boolean;
        Amont: Boolean;
        Remarrrks: Boolean;
        AllAmount: Boolean;
        Trans: Record "Teller Transaction";
        FactProd: Record "Product Factory";
        Currr: Boolean;
        DiscCH: Boolean;
        SignatoryEditable: Boolean;
        ErrorOnExcessDocsInit: Label 'There are still some pending document(s) on your account. Please list & select the pending document to use.';
        DocMngt: Codeunit "Doc. Mngt";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;


    procedure UpdateControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            AccNo := true;
            TransType := true;
            Remarrrks := true;
            Amont := true;
            Currr := true;
        end;


        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then begin
            AccNo := false;
            TransType := false;
            Remarrrks := false;
            Amont := false;
            Currr := false;
        end;


        if Rec."Approval Status" = Rec."Approval Status"::Rejected then begin
            AccNo := false;
            TransType := false;
            Remarrrks := false;
            Amont := false;
            Currr := false;
        end;

        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
            AccNo := false;
            TransType := false;
            Remarrrks := false;
            Amont := false;
            Currr := false;

        end;
    end;
}




