page 50860 "Cheque Receipts Header"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Cheque Receipt";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Clearing Bank"; Rec."Clearing Bank")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unpaid By"; Rec."Unpaid By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Refference Document"; Rec."Refference Document")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Unpaid; Rec.Unpaid)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Control13)
            {
                ShowCaption = false;
                part(Control12; "Cheque Receipt Line")
                {
                    SubPageLink = "Chq Receipt No" = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Import)
            {
                Image = Import;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    InwardFile.Reset;
                    //InwardFile.SETRANGE(InwardFile.CurrentUserID,USERID);
                    if InwardFile.Find('-') then
                        InwardFile.DeleteAll;


                    Commit;

                    XMLPORT.Run(52140644, true);


                    Commit;

                    REPORT.Run(52140714, true);


                    Commit;

                    REPORT.Run(39004327, true);

                    Rec."Created By" := UserId;
                    Rec.Modify;
                end;
            }
            action(Post)
            {
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        Error(DocMustbeApproved);

                    if Rec.Posted then
                        Error('Transaction already Posted');
                    SaccoT.PostCheques(Rec);
                end;
            }
            action("Post Unpay Accounts")
            {
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        Error(DocMustbeApproved);

                    if Rec.Unpaid then
                        Error('Transaction already unpaid');
                    SaccoT.PostUnpayCheques(Rec);
                end;
            }
            action("Export Unpay Accounts")
            {
                Image = Export;
                ApplicationArea = All;

                trigger OnAction()
                begin


                    ChqRecLines.Reset;
                    ChqRecLines.SetRange(ChqRecLines."Chq Receipt No", Rec."No.");
                    XMLPORT.Run(39003902, true, false, ChqRecLines);
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //
                        // IF Status<>Status::Open THEN
                        //      ERROR(DocMustbeOpen);
                        //
                        // TESTFIELD("Transaction Type");
                        // TESTFIELD("Clearing Bank");
                        //
                        // VarVariant := Rec;
                        // IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        //  CustomApprovals.OnSendDocForApproval(VarVariant);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //
                        //  IF Status<>Status::Pending THEN
                        //      ERROR(DocMustbePending);
                        //
                        // VarVariant := Rec;
                        // CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        approvalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                actionref(Import_Promoted; Import)
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref("Post Unpay Accounts_Promoted"; "Post Unpay Accounts")
                {
                }
                actionref("Export Unpay Accounts_Promoted"; "Export Unpay Accounts")
                {
                }
            }
            group(Category_Category4)
            {
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
            group(Category_Category9)
            {
                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    var
        ChqRecLines: Record "Cheque Issue Line";
        //RefNoRec: Record "Refference Number";
        InwardFile: Record "Inward file Buffer";
        SaccoT: Codeunit "Banking Procedure Mngt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        DocMustbeApproved: Label 'This application request must be Approved before proceeding';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




