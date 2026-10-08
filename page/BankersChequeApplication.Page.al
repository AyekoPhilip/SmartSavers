page 50865 "Bankers Cheque Application"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Bankers Cheque Application";
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
                field("Application Date"; Rec."Application Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Begining Cheque No."; Rec."Begining Cheque No.")
                {
                    Editable = BeginCHNo;
                    ApplicationArea = All;
                }
                field("No of Leaves"; Rec."No of Leaves")
                {
                    Editable = NoOfLives;
                    ApplicationArea = All;
                }
                field("Leaf Limit Amount"; Rec."Leaf Limit Amount")
                {
                    Editable = LeafLimit;
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    Editable = Bnk;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Cheque Register Generated"; Rec."Cheque Register Generated")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Cheque Register")
            {
                Image = Interaction;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec."Cheque Register Generated" = true then
                        Error('Register already generated');

                    if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                        Error('The document must be fully approved before proceeding');

                    if Confirm('Are you sure you want to generate bankers cheque register ?', false) = false then
                        exit;

                    i := 0;

                    repeat
                        i := i + 1;

                        BankerR.Init;
                        BankerR."Cheque No." := Rec."Begining Cheque No.";
                        BankerR."Application No." := Rec."No.";
                        BankerR."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
                        BankerR."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                        BankerR."Bank Account" := Rec."Bank Account";
                        BankerR."Leaf Limit Amount" := Rec."Leaf Limit Amount";
                        BankerR.Insert;

                        BankerR.Validate(BankerR."Bank Account");

                        Rec."Begining Cheque No." := IncStr(Rec."Begining Cheque No.");
                    until i = Rec."No of Leaves";

                    Rec."Cheque Register Generated" := true;
                    Rec.Modify;
                    Message('Register generated successfuly');
                end;
            }
            action("Cheque Register")
            {
                Image = GetLines;
                RunObject = Page "Bankers Cheque Register List";
                RunPageLink = "Application No." = FIELD("No.");
                ApplicationArea = All;
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
                    Enabled = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin

                        Rec.TESTFIELD("Begining Cheque No.");
                        Rec.TESTFIELD("Bank Account");
                        IF Rec."Leaf Limit Amount" = 0 THEN
                            ERROR('Kindly specify the leaf limit before proceeding');
                        ApprovalsMgmt.OnSendBankersChequeApprovalRequest(Rec)
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        if ApprovalsMgmt.OnCancelBankersChequeApprovalRequest(Rec, true, true) then;
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
                actionref("Generate Cheque Register_Promoted"; "Generate Cheque Register")
                {
                }
                actionref("Cheque Register_Promoted"; "Cheque Register")
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
        i: Integer;
        BankerR: Record "Bankers Cheques Register";
        BeginCHNo: Boolean;
        NoOfLives: Boolean;
        Bnk: Boolean;
        LeafLimit: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure UpdateControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            BeginCHNo := true;
            NoOfLives := true;
            Bnk := true;
            LeafLimit := true;
        end;
        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then begin
            BeginCHNo := false;
            NoOfLives := false;
            Bnk := false;
            LeafLimit := false;
        end;
        if Rec."Approval Status" = Rec."Approval Status"::Rejected then begin
            BeginCHNo := false;
            NoOfLives := false;
            Bnk := false;
            LeafLimit := false;
        end;

        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
            BeginCHNo := false;
            NoOfLives := false;
            Bnk := false;
            LeafLimit := false;
        end;
    end;
}




