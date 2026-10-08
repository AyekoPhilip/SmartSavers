page 50983 "Standing Order Control Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Standing Order Control";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = DocumentTypeEdit;
                    ValuesAllowed = Open, Rejected, Stopped;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = DescriptionEdit;
                    ApplicationArea = All;
                }
                field("Standing Order No"; Rec."Standing Order No")
                {
                    Editable = SONumberEdit;
                    ApplicationArea = All;
                }
                field("Source Account No."; Rec."Source Account No.")
                {
                    ApplicationArea = All;
                }
                field("Source Account Name"; Rec."Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Income Type"; Rec."Income Type")
                {
                    ApplicationArea = All;
                }
                field("Allow Partial Deduction"; Rec."Allow Partial Deduction")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field(Frequency; Rec.Frequency)
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control22; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control23; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control24; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Process)
            {
                Image = Add;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SOProcess: Codeunit "Registry Mngt.";
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    //SOProcess.PostPerformingLoanInt(Rec);
                end;
            }
            action("Standing Order")
            {
                Image = Answers;
                RunObject = Page "Standing Order";
                RunPageLink = "No." = FIELD("Standing Order No");
                ApplicationArea = All;
            }
        }
        area(processing)
        {
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
                        Rec.TestField(Status, Rec.Status::Pending);
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
                        Rec.TestField(Status, Rec.Status::Pending);
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
                        Rec.TestField(Status, Rec.Status::Pending);
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
                        NextofKinError: Label 'You must specify next of Kin for this application.';
                    begin
                        // TESTFIELD(Status,Status::Open);
                        //
                        // TESTFIELD("Standing Order No");
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
                        // TESTFIELD(Status,Status::Pending);
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
                        // approvalsMgmt.OpenApprovalEntriesPage(RECORDID);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Process_Promoted; Process)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 3.';

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
            group(Category_Category6)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 5.';

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
            group(Category_Category7)
            {
                Caption = 'View', Comment = 'Generated from the PromotedActionCategories property index 6.';

                actionref("Standing Order_Promoted"; "Standing Order")
                {
                }
            }
            group(Category_Category8)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        statusControl;
    end;

    var
        DocumentTypeEdit: Boolean;
        DescriptionEdit: Boolean;
        SONumberEdit: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;


    procedure statusControl()
    begin
        // CASE Status OF
        // Status::Open :
        // BEGIN
        //   DocumentTypeEdit:=TRUE; DescriptionEdit:=TRUE; SONumberEdit:=TRUE;
        //   //OpenApprovalEntriesExist:=TRUE;
        //   END;
        //
        // Status::Pending,Status::Approved,Status::Rejected,Status::"5" :
        // BEGIN
        //   DocumentTypeEdit:=FALSE; DescriptionEdit:=FALSE; SONumberEdit:=FALSE;
        //   //OpenApprovalEntriesExist:=FALSE;
        //   END;
        // END;
    end;


    procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




