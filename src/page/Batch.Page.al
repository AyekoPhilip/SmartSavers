page 50825 "Batch"
{
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Loan Disbursement Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ValuesAllowed = 3, 52146423;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Enabled = Rec."Account Type" = Rec."Account Type"::"Bank Account";
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Editable = Rec."Account Type" = Rec."Account Type"::Saving;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Remarks"; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Enforce Min. Share Rule"; Rec."Enforce Min. Share Rule")
                {
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Enforce Perform Loan Rule"; Rec."Enforce Perform Loan Rule")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            part("Batch Lines"; "Batch Lines")
            {
                Visible = Rec."Payment Type" = Rec."Payment Type"::Refund;
                Editable = false;
                Caption = 'Batch Lines';
                SubPageLink = No = field("No.");
                ApplicationArea = All;
            }
            part("Loan Lines"; "Loan Batch List")
            {
                Visible = Rec."Payment Type" = Rec."Payment Type"::Loans;
                Editable = false;
                Caption = 'Loan Lines';
                SubPageLink = "Batch No." = field("No.");
                ApplicationArea = All;
            }
            group("Trail Information")
            {
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }

        }
        area(factboxes)
        {
            systempart(Control18; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control19; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = PostedVoucherGroup;
                Enabled = Rec.Posted = false;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.OnPostApplic();
                end;
            }
            action(GenerateFunds)
            {
                Caption = 'Create Entries';
                Image = PostedVoucherGroup;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CredJnlMgt: Codeunit "Credit. Jnl.-Post Batch";
                begin
                    Rec.CreateEntry();
                end;
            }
            action(ReverseFunds)
            {
                Caption = 'Reverse Entries';
                Image = PostedVoucherGroup;
                Enabled = false;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CredJnlMgt: Codeunit "Credit. Jnl.-Post Batch";
                begin
                    CredJnlMgt.CreateReverseLine(Rec."No.", Enum::BatchPaymentType::Refund, '', '',
                    Rec."Global Dimension 1 Code", Rec."Global Dimension 2 Code",Enum::BCObjectTypes::System);
                end;
            }
            action(SendApprovalRequest)
            {
                Caption = 'Send A&pproval Request';
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                Image = SendApprovalRequest;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    VarVariant := Rec;
                    CredMgt.ApplicationDocPane(VarVariant, ActItems::"Send Approval Request")
                end;
            }
            action(CancelApprovalRequest)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    VarVariant := Rec;
                    CredMgt.ApplicationDocPane(VarVariant, ActItems::"Cancel Approval Request")
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
                    approvalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    approvalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action("Open Approval Request")
            {
                Image = Category;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CredMgt.ApplicationDocPane(VarVariant, ActItems::"Open Request")
                end;
            }
            action("Disbursement Schedule")
            {
                Image = ResourcePlanning;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CredMgt.ApplicationDocPane(VarVariant, ActItems::RepaymentSchedule)
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(GenerateFunds_Promoted; GenerateFunds)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Disbursement Schedule_Promoted"; "Disbursement Schedule")
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
                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref("Open Approval Request_Promoted"; "Open Approval Request")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StatusControl;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        StatusControl;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Subsequent Disbursements" = Rec."Subsequent Disbursements"::Yes then
            SubseqDisb := true
        else
            SubseqDisb := false;
        StatusControl;
        SetControlAppearance;
        if Rec."Approval Status" = Rec."Approval Status"::Approved then
            CurrPage.Editable := false;
    end;

    var
        CredMgt: Codeunit "Credit Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        SubseqDisb: Boolean;
        ApprovedEdit: Boolean;
        UserSetup: Record "User Setup";
        ActItems: Enum ActionPanesItems;

    local procedure GetIfNothingSelected()
    begin
    end;


    procedure StatusControl()
    begin
        ApprovedEdit := true;
        case Rec."Approval Status" of
            Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Approved, Rec."Approval Status"::Rejected:
                begin
                    ApprovedEdit := false;
                end;
            Rec."Approval Status"::Open:
                begin
                    ApprovedEdit := true;
                end;
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




