page 50859 "Cheque Application"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Cheque Book Application";
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
                    Editable = TransType;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = accNo;
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("ID No."; Rec."ID No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Book Type"; Rec."Cheque Book Type")
                {
                    Editable = chbktype;
                    ApplicationArea = All;
                }
                field("Begining Cheque No."; Rec."Begining Cheque No.")
                {
                    Editable = beginCh;
                    ApplicationArea = All;
                }
                field("End Cheque No."; Rec."End Cheque No.")
                {
                    Editable = endCh;
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last check"; Rec."Last check")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Account No."; Rec."Cheque Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Translation Code"; Rec."Translation Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Register Generated"; Rec."Cheque Register Generated")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Book charges Posted"; Rec."Cheque Book charges Posted")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Application Exported"; Rec."Application Exported")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Issue/Generate Cheque Register")
            {
                Image = Interaction;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //
                    // IF Status<>Status::Approved THEN
                    // ERROR('The document must be fully approved');
                    //
                    // IF "Application Exported"<>TRUE THEN
                    //  ERROR('You cannot generate the cheque book before the application is exported');
                    //
                    // IF "Cheque Register Generated" THEN
                    // ERROR('Cheque generation already done');
                    // TESTFIELD("Begining Cheque No.");
                    // TESTFIELD("End Cheque No.");
                    // IncrNo:="Begining Cheque No.";
                    //
                    // IF "End Cheque No."<"Begining Cheque No." THEN
                    // ERROR('Beginning number is more than ending number');
                    //
                    //
                    // WHILE IncrNo<="End Cheque No." DO BEGIN
                    // CheqReg.INIT;
                    // CheqReg."Account No.":="Cheque Account No.";
                    // CheqReg."Cheque No.":=IncrNo;
                    // CheqReg."Application No.":="No.";
                    // CheqReg.INSERT;
                    //
                    // IncrNo:=INCSTR(IncrNo);
                    // END;
                    // "Cheque Register Generated":=TRUE;
                    // MODIFY;
                    //
                    // IF Vend.GET("Account No.") THEN BEGIN
                    //  MobNo:=Vend."Transactional Mobile No";
                    //  END;
                    //
                    //
                    // SendSMS.SendSms(SourceType::"Chq Book",MobNo,Text0001 +FORMAT(TODAY)+' '+FORMAT(TIME)
                    // +' '+COMPANYNAME,"No.","No.",FALSE);
                    //
                    // MESSAGE('Register generated successfully');
                end;
            }
            action("Cheque Register")
            {
                Image = GetLines;
                RunObject = Page "Cheque Register List";
                RunPageLink = "Application No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Post Cheque Book Charges")
            {
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // IF CONFIRM('Do you want post the charges',FALSE) = TRUE THEN BEGIN
                    //
                    //
                    // IF Status=Status::"Pending Approval" THEN
                    // ERROR('The transaction must be fully approved before proceeding');
                    //
                    // SaccoT.PostBankChequeCharges(Rec);
                    //
                    // END;
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
                        // IF Status<>Status::Open THEN
                        //      ERROR(DocMustbeOpen);
                        //
                        // TESTFIELD("Account No.");
                        // TESTFIELD("Cheque Book Type");
                        // //TESTFIELD("Begining Cheque No.");
                        // //TESTFIELD("End Cheque No.");
                        // TESTFIELD("Transaction Type");
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
                        // IF Status<>Status::"Pending Approval" THEN
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
                actionref("Issue/Generate Cheque Register_Promoted"; "Issue/Generate Cheque Register")
                {
                }
                actionref("Cheque Register_Promoted"; "Cheque Register")
                {
                }
                actionref("Post Cheque Book Charges_Promoted"; "Post Cheque Book Charges")
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
        UpdateControl;
    end;

    trigger OnInit()
    begin
        UpdateControl;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        chbktype: Boolean;
        beginCh: Boolean;
        endCh: Boolean;
        accNo: Boolean;
        TransType: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;


    procedure UpdateControl()
    begin
        if Rec.Status = Rec.Status::Open then begin
            accNo := true;
            endCh := false;
            beginCh := false;
            chbktype := true;
            TransType := true;
        end;
        if Rec.Status = Rec.Status::"Pending Approval" then begin
            accNo := false;
            endCh := false;
            beginCh := false;
            chbktype := false;
            TransType := false;
        end;
        if Rec.Status = Rec.Status::Rejected then begin
            accNo := false;
            endCh := false;
            beginCh := false;
            chbktype := false;
            TransType := false;
        end;
        if Rec.Status = Rec.Status::Approved then begin
            accNo := false;
            endCh := true;
            beginCh := true;
            chbktype := false;
            TransType := false;
        end;
        if Rec."Cheque Register Generated" = true then begin
            accNo := false;
            endCh := false;
            beginCh := false;
            chbktype := false;
            TransType := false;
        end;
    end;
}




