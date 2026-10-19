page 50857 "Salary Header"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Salary Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = TransType;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = AccType;
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    Editable = AccNo;
                    ApplicationArea = All;
                }
                field("Document No"; Rec."Document No")
                {
                    Editable = DocNo;
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = Rmarks;
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = Amnt;
                    ApplicationArea = All;
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Count"; Rec."Total Count")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Editable = EmployerC;
                    ApplicationArea = All;
                }
                field("Last Loan Issue Date"; Rec."Last Loan Issue Date")
                {
                    Editable = LastloanDate;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Activity';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Branch';
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Income Type"; Rec."Income Type")
                {
                    Editable = IncType;
                    ApplicationArea = All;
                }
                field("Posting date"; Rec."Posting date")
                {
                    Editable = Pdate;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
            }
            part(Control17; "Salary Line")
            {
                SubPageLink = "Salary Header No." = FIELD(No);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Salaries")
            {
                Caption = 'Import Salaries';
                Image = Import;
                ApplicationArea = All;
                //RunObject = XMLport XMLport52140643;

                trigger OnAction()
                begin
                    /*
                    RcptBufLines.RESET;
                    RcptBufLines.SETRANGE(RcptBufLines."Receipt Header No",No);
                    IF RcptBufLines.FIND('-') THEN
                    RcptBufLines.DELETEALL;
                    */

                end;
            }
            group(Process)
            {
                Caption = 'Process';
                action(Print)
                {
                    Image = ConfirmAndPrint;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.Reset;
                        Rec.SetFilter(No, Rec.No);
                        REPORT.Run(52140718, true, true, Rec);
                    end;
                }
                action(Validate)
                {
                    Image = Translation;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        SalaryLines: Record "Salary Lines";
                        SavingsAccounts: Record "Account Banking";
                        StrMenuTxt: Label '&Staff No.,&Account No.,&ID No';
                        Selection: Integer;
                    begin
                    end;
                }
                action("Check for Mutiple Salaries")
                {
                    Image = "Report";
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        SalaryLines: Record "Salary Lines";
                    begin
                        SalaryLines.Reset;
                        SalaryLines.SetRange(SalaryLines."Salary Header No.", Rec.No);
                        if SalaryLines.Find('-') then
                            REPORT.Run(52140674, true, false, SalaryLines);
                    end;
                }
                action("Unblock Accounts")
                {
                    ApplicationArea = All;
                }
            }
            group(Action22)
            {
                Caption = 'Post';
                action(Post)
                {
                    Image = Post;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        SaccoT: Codeunit "Banking Procedure Mngt.";
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        SaccoT.PostSalary(Rec);
                    end;
                }
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
                        // TESTFIELD("Document No");
                        // TESTFIELD(Remarks);
                        // TESTFIELD(Amount);
                        // TESTFIELD("Employer Code");
                        // TESTFIELD("Posting date");
                        // TESTFIELD("Last Loan Issue Date");
                        //
                        // IF Validated=FALSE THEN
                        //  ERROR('Kinldy validate the salary batch before proceeding');
                        //
                        // IF "Mutiple Salaries Checked"=FALSE THEN
                        //  ERROR('Kindly check for multiple salaries before proceeding');
                        //
                        //
                        // SalaryLines.RESET;
                        // SalaryLines.SETRANGE(SalaryLines."Salary Header No.",No);
                        // IF SalaryLines.FIND('-') THEN BEGIN
                        //  REPEAT
                        //    IF SalaryLines."Account Not Found"=TRUE THEN BEGIN
                        //      ERROR('Kinldy reconcile all the unfound accounts for this employer before proceeding');
                        //      END;
                        //        UNTIL
                        //  SalaryLines.NEXT=0;
                        //  END;
                        //
                        //
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
                actionref("Import Salaries_Promoted"; "Import Salaries")
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Process)
            {
                actionref(Validate_Promoted; Validate)
                {
                }
            }
            group(Category_Report)
            {
                actionref(Print_Promoted; Print)
                {
                }
                actionref("Check for Mutiple Salaries_Promoted"; "Check for Mutiple Salaries")
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

    trigger OnAfterGetCurrRecord()
    begin

        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        UpdateControl;

        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false;
    end;

    trigger OnInit()
    begin
        UpdateControl;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin

        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        /*IF Status<>Status::Open THEN
         CurrPage.EDITABLE:=FALSE;*/

    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        TransType: Boolean;
        AccType: Boolean;
        AccNo: Boolean;
        DocNo: Boolean;
        Rmarks: Boolean;
        Amnt: Boolean;
        EmployerC: Boolean;
        IncType: Boolean;
        Pdate: Boolean;
        LastloanDate: Boolean;

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
            AccNo := true;
            TransType := true;
            AccType := true;
            DocNo := true;
            Rmarks := true;
            Amnt := true;
            EmployerC := true;
            Pdate := true;
            IncType := true;
            LastloanDate := true;
        end;
        if Rec.Status = Rec.Status::Pending then begin
            AccNo := false;
            TransType := false;
            AccType := false;
            DocNo := false;
            Rmarks := false;
            Amnt := false;
            EmployerC := false;
            Pdate := false;
            IncType := false;
            LastloanDate := false;
        end;
        if Rec.Status = Rec.Status::Rejected then begin
            AccNo := false;
            TransType := false;
            AccType := false;
            DocNo := false;
            Rmarks := false;
            Amnt := false;
            EmployerC := false;
            Pdate := false;
            IncType := false;
            LastloanDate := false;
        end;
        if Rec.Status = Rec.Status::Approved then begin
            AccNo := false;
            TransType := false;
            AccType := false;
            DocNo := false;
            Rmarks := false;
            Amnt := false;
            EmployerC := false;
            Pdate := false;
            IncType := false;
            LastloanDate := false;
        end;
    end;
}




