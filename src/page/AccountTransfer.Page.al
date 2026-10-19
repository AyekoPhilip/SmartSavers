page 50871 "Account Transfer"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    Editable = true;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Account Transfer Header";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec.Status = Rec.Status::Open;
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = HeaderA;
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Transfer Type"; Rec."Transfer Type")
                {
                    Editable = false;
                    Caption = 'Application Type';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Member No"; Rec."Member No")
                {
                    Editable = HeaderA;
                    Caption = 'Member No.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field(Remarks; Rec.Remarks)
                {
                    Editable = HeaderA;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Total Debits"; Rec."Total Debits")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Total Credits"; Rec."Total Credits")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Non-Member A/c"; Rec."Non-Member A/c")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    Visible = false;
                    StyleExpr = true;
                }

            }
            group(Source)
            {
                part("Account Transfers-Source [ Debit ]"; "Account Transfer Source")
                {
                    Caption = 'Transfer Line [ Debit ]';
                    Editable = SourceA;
                    SubPageLink = "No." = FIELD("No."), "Member No." = field("Member No");
                    ApplicationArea = All;
                }
            }
            group(Destination)
            {
                part("Account Transfers-Destination [ Credit ]"; "Account Transfer Destination")
                {
                    Caption = 'Transfer Line [ Credit ]';
                    Editable = DestinationA;
                    SubPageLink = "No." = field("No."), "Member No." = field("Member No");
                    ApplicationArea = All;
                }
            }
            group("Trail Information")
            {
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field(Status; Rec.Status)
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AControl;
                    end;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No"),
                                             "Account Category" = const("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part("Banking History"; "Account Statistics FactBox")
            {
                Caption = 'Banking Statistics';
                SubPageLink = "Member No." = field("Member No");
                SubPageView = where("Account Category" = const("Specialty Savings"));
                ApplicationArea = All;
            }
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Member No");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Member No");
                ApplicationArea = All;
            }
            systempart(Control21; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control33; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Loan History")
            {
                Caption = 'Loan History';
                Image = Archive;
                ApplicationArea = All;
                RunObject = page "Loans List Posted";
                RunPageLink = "Account No." = field("Member No");
                RunPageView = where("Outstanding Balance" = filter(> 0));
                trigger OnAction()
                begin

                end;
            }
            action(Statement)
            {
                Caption = 'Detailed Statement';
                Image = StatisticsDocument;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustMembr: Record Member;
                begin
                    CustMembr.Reset();
                    CustMembr.SetRange("No.", Rec."Member No");
                    IF CustMembr.Find('-') then
                        Report.Run(Report::"Standard Statement-All Account", true, false, CustMembr);
                end;
            }

        }
        area(processing)
        {
            group(Posting)
            {
                Caption = 'Posting';
                action(Post)
                {
                    Caption = 'Post';
                    Image = PostedCreditMemo;
                    ApplicationArea = All;
                    trigger OnAction()

                    begin
                        RegMngt.UpdateAccountSourcetLine(Rec."No.");

                        Rec.TestField(Rec.Status, Rec.Status::Approved);
                        Rec.TestField("Member No");
                        SaccoT.PostTransfers(Rec, 1);
                        CurrPage.Close();
                    end;
                }

                action(PostPrint)
                {
                    Caption = 'Post+Print';
                    Image = PostPrint;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        RegMngt.UpdateAccountSourcetLine(Rec."No.");

                        Tempsetup.Get();
                        Rec.TestField(Rec.Status, Rec.Status::Approved);
                        Rec.TestField("Member No");
                        case Tempsetup."Post Application As" of
                            Tempsetup."Post Application As"::"Post as User":
                                begin
                                    SaccoT.PostTransfers(Rec, 1);
                                    CurrPage.Close();
                                    Commit();

                                    Rec.Reset();
                                    Rec.SetFilter("No.", Rec."No.");
                                    Report.Run(Report::"Account Transfer", true, true, Rec);
                                    Rec.Reset();
                                end;
                        end;
                    end;
                }
                action("Print Preview")
                {
                    Caption = 'Print Preview';
                    Image = Print;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.TestField(Posted, true);
                        Rec.Reset();
                        Rec.SetFilter("No.", Rec."No.");
                        Report.Run(Report::"Account Transfer", true, true, Rec);
                        Rec.Reset();

                    end;
                }
                action("Post Preview")
                {

                    Image = ViewPostedOrder;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.TestField("Member No");
                        SaccoT.PostTransfers(Rec, 0);
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
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin

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
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin

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
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin

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
                        Rec.TestField(Remarks);
                        if not Rec."Non-Member A/c" then
                            Rec.TestField("Member No");

                        Rec.CalcFields("Total Credits", "Total Debits");
                        if Round(Rec."Total Credits") = Round(Rec."Total Debits") then
                            ApprovalsMgmt.OnSendAccountTransferApprovalRequest(Rec) else
                            Error(ErrorOnNonDebitAmt, Rec."Total Credits", Rec."Total Debits");
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
                        ApprovalsMgmt.OnCancelAccountTransferApprovalRequest(Rec, true, true)
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
                        ApprovalsMgmt.OnOpenAccountTransferApprovalRequest(Rec, true, true)
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50438);
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
                actionref(PostPrint_Promoted; PostPrint)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Print Preview_Promoted"; "Print Preview")
                {
                }
                actionref("Post Preview_Promoted"; "Post Preview")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 3.';

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
                Caption = 'Account', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Loan History_Promoted"; "Loan History")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref(OpenApprovalRequest_Promoted; OpenApprovalRequest)
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 6.';

                actionref(Statement_Promoted; Statement)
                {
                }
            }
            group(Category_Category8)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
        }
        //

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transfer Type" := Rec."Transfer Type"::Self;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        AControl;
        SetControlAppearance;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        SaccoT: Codeunit "Banking Procedure Mngt.";
        DocMustbeApproved: Label 'This document must be approved before posting';
        ErrorOnNonDebitAmt: Label 'Total Credits of %1 must be equal to Total Debits of %2';
        HeaderA: Boolean;
        RegMngt: Codeunit "Register Management";
        SourceA: Boolean;
        DestinationA: Boolean;
        Tempsetup: Record "General Set-Up";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure AControl()
    begin
        case Rec.Status of
            Rec.Status::Open:
                begin
                    SourceA := true;
                    DestinationA := true;
                    HeaderA := true;
                end;

            Rec.Status::"Pending Approval", Rec.Status::Approved, Rec.Status::Rejected:
                begin
                    SourceA := false;
                    DestinationA := false;
                    HeaderA := false;
                end;
        end;
    end;
}




