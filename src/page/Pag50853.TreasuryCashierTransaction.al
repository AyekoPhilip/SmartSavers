page 50853 "Treasury Cashier Transaction"
{
    DeleteAllowed = false;
    SourceTable = "Treasury Cashier Transaction";
    SourceTableView = WHERE(Posted = CONST(False));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = TransType;
                    OptionCaption = 'Teller Request,Return To Treasury,Issue From Bank,Return To Bank,Inter Teller Transfers,Branch Treasury Transactions,End of Day Return to Treasury';
                    ApplicationArea = All;
                }
                field("From Account"; Rec."From Account")
                {
                    Caption = 'From';
                    Editable = FrAccount;
                    ApplicationArea = All;
                }
                field("From Till"; Rec."From Till")
                {
                    ApplicationArea = All;
                }
                field("From Till Balance"; Rec."From Till Balance")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("To Account"; Rec."To Account")
                {
                    Caption = 'To';
                    Editable = ToAccount;
                    ApplicationArea = All;
                }
                field("To Till"; Rec."To Till")
                {
                    ApplicationArea = All;
                }
                field("To Till Balance"; Rec."To Till Balance")
                {
                    ApplicationArea = All;

                }
                field("Till/Treasury Balance"; Rec."Till/Treasury Balance")
                {
                    Caption = 'End Of Day Till Balance';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    Caption = 'Vault Balance';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = Amnt;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = Currr;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                    Editable = ExternDoc;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Issued; Rec.Issued)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Issued"; Rec."Date Issued")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Time Issued"; Rec."Time Issued")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Issued By"; Rec."Issued By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Received; Rec.Received)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Received"; Rec."Date Received")
                {
                    ApplicationArea = All;
                }
                field("Time Received"; Rec."Time Received")
                {
                    ApplicationArea = All;
                }
                field("Received By"; Rec."Received By")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Total Cash on Treasury Coinage"; Rec."Total Cash on Treasury Coinage")
                {
                    Caption = 'Total Cash on Treasury/Teller Coinage';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Excess/Shortage Amount"; Rec."Excess/Shortage Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cashier ID"; Rec."Cashier ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Coinage; Coinage)
            {
                Caption = 'Coinage';
                Editable = Cnage;
                SubPageLink = No = FIELD(No);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Issue/Return")
            {
                Caption = 'Issue/Return';
                Image = Interaction;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SaccoT: Codeunit "Banking Procedure Mngt.";

                begin

                    Temp.Get(UserId);
                    TillNo := Temp."Default  Bank";
                    case Rec."Transaction Type" of
                        //Rec."Transaction Type"::"Issue To Teller",
                        Rec."Transaction Type"::"Return To Treasury",
                        Rec."Transaction Type"::"Inter Teller Transfers",
                        Rec."Transaction Type"::"Branch Treasury Transactions":
                            begin

                                BankingSetup.Reset;
                                BankingSetup.SetRange(BankingSetup."Account ID", Rec."From Account");
                                if BankingSetup.Find('-') then begin

                                    Banks.Reset;
                                    Banks.SetRange(Banks."No.", BankingSetup."Default  Bank");
                                    if Banks.Find('-') then begin
                                        Banks.CalcFields(Banks."Balance (LCY)");
                                        if Banks."Balance (LCY)" <= 0 then
                                            Error('Till Balance is below zero or has zero balance');
                                    end;
                                end;
                            end;
                    end;
                    Rec.TestField(Status, Rec.Status::Approved);
                    SaccoT.PostTCIssue(Rec);
                end;
            }
            action(Receive)
            {
                Caption = 'Receive';
                Image = ReceiveLoaner;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SaccoT: Codeunit "Banking Procedure Mngt.";
                begin
                    Temp.Get(UserId);
                    TillNo := Temp."Default  Bank";
                    case Rec."Transaction Type" of

                        Rec."Transaction Type"::"Issue To Teller",
                        Rec."Transaction Type"::"Return To Treasury",
                        Rec."Transaction Type"::"Inter Teller Transfers",
                        Rec."Transaction Type"::"Branch Treasury Transactions":
                            //Rec."Transaction Type"::"End of Day Return to Treasury":
                            begin

                                BankingSetup.Reset;
                                BankingSetup.SetRange(BankingSetup."Account ID", Rec."From Account");
                                if BankingSetup.Find('-') then begin
                                    //   if UpperCase(UserId) <> BankingSetup."Account ID" then
                                    //       Error(Text0005);
                                end;

                                Banks.Reset;
                                Banks.SetRange(Banks."No.", TillNo);
                                if Banks.Find('-') then begin
                                    Banks.CalcFields(Banks."Balance (LCY)");
                                    if Rec.Amount > Banks."Balance (LCY)" then begin
                                        //Error('You cannot issue more than the account balance.')
                                    end;
                                end;
                            end;
                    end;
                    Rec.TestField(Status, Rec.Status::Approved);
                    SaccoT.PostTCReceive(Rec);
                end;
            }
            action("Print/Preview")
            {
                Image = PrintDocument;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Treasury.Reset;
                    Treasury.SetRange(No, Rec.No);
                    if Treasury.Find('-') then begin
                        REPORT.Run(52140722, true, false, Treasury);
                    end;
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
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
                        Banks.Reset;
                        Banks.SetRange(Banks."No.", TillNo);
                        if Banks.Find('-') then begin
                            Banks.CalcFields(Banks."Balance (LCY)");
                            if Rec.Amount > Banks."Balance (LCY)" then begin
                                Error('You cannot issue more than the account balance.')
                            end;
                        end;
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Approval Comments";
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        Temp.Get(UserId);
                        TillNo := Temp."Default  Bank";
                        case Rec."Transaction Type" of

                            Rec."Transaction Type"::"Inter Teller Transfers":
                                begin

                                    Banks.Reset;
                                    Banks.SetRange(Banks."No.", TillNo);
                                    if Banks.Find('-') then begin
                                        Banks.CalcFields(Banks."Balance (LCY)");
                                        if Banks."Balance (LCY)" <= 0 then
                                            Error('Till Balance is below zero or has zero balance');
                                    end;

                                    Banks.Reset;
                                    Banks.SetRange(Banks."No.", TillNo);
                                    if Banks.Find('-') then begin
                                        Banks.CalcFields(Banks."Balance (LCY)");
                                        if (Rec.Amount + Banks."Balance (LCY)") > Temp."Max. Cashier Withholding" then begin
                                            Error('You cannot transfer more than available Till Balance.')
                                        end;
                                    end;
                                end;
                        end;
                        ApprovalsMgmt.OnSendTreasuryTransactionApprovalRequest(Rec)
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
                        if ApprovalsMgmt.OnCancelTreasuryTransactionApprovalRequest(Rec, true, true) then;
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
                        if ApprovalsMgmt.OnOpenTreasuryTransactionApprovalRequest(Rec, true, true) then;
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec.No, 52147204);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Issue/Return_Promoted"; "Issue/Return")
                {
                }
                actionref(Receive_Promoted; Receive)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Print/Preview_Promoted"; "Print/Preview")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
                actionref(Comment_Promoted; Comment)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Loan File', Comment = 'Generated from the PromotedActionCategories property index 4.';
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
                actionref(OpenApprovalRequest_Promoted; OpenApprovalRequest)
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
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ErrorOnExcessDocsInit: Label 'There are still some pending document(s) on your account. Please list & select the pending document to use.';
        Temp: Record "Banking User Template";
        Trans: Record "Treasury Cashier Transaction";
    begin

        Temp.Get(UserId);
        Trans.Reset;
        Trans.SetRange(Trans."Cashier ID", UserId);
        Trans.SetFilter(Trans.Status, '%1|%2', Trans.Status::Open, Trans.Status::Pending);
        if Trans.Count > Temp."No of Open Transactions" then begin
            Error(ErrorOnExcessDocsInit);
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        if (Rec.Posted = true) or (rec.Status <> Rec.Status::Open) then
            CurrPage.Editable := false;
    end;

    var
        TransType: Boolean;
        FrAccount: Boolean;
        ToAccount: Boolean;
        BankingSetup: Record "Banking User Template";
        Banks: Record "Bank Account";
        Text0005: Label 'You do not have permission to transact on this teller till/Account.';
        Temp: Record "Banking User Template";
        TillNo: Code[20];
        Amnt: Boolean;
        Currr: Boolean;
        ExternDoc: Boolean;
        Excess: Boolean;
        Cnage: Boolean;
        Typee: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        Treasury: Record "Treasury Cashier Transaction";

    local procedure UpdateControls()
    begin
        if (Rec.Issued = Rec.Issued::Yes) or (Rec.Received = Rec.Received::Yes) then begin
            TransType := false;
            FrAccount := false;
            ToAccount := false;
            Amnt := false;
            Excess := false;
            Currr := false;
            Cnage := false;
            ExternDoc := false;
            Typee := false;
        end else begin
            TransType := true;
            FrAccount := true;
            ToAccount := true;
            Amnt := true;
            Excess := true;
            Currr := true;
            Cnage := true;
            ExternDoc := true;
            Typee := true;

        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




