page 50053 "User Setup Card"
{
    Caption = 'User Setup Card';
    PageType = Card;
    SourceTable = "User Setup";
    DeleteAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies automated Posting ID.';

                }
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post to the company.';
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date on which the user is allowed to post to the company.';
                }
                field("Allow Posting From [Time]"; Rec."Allow Posting From [Time]")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Posting From [Time] field.';
                }
                field("Allow Posting To [Time]"; Rec."Allow Posting To [Time]")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Posting To [Time] field.';
                }
                field("Allow FA Posting From"; Rec."Allow FA Posting From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow FA Posting From field.';
                }
                field("Allow FA Posting To"; Rec."Allow FA Posting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow FA Posting To field.';
                }
                field("Register Time"; Rec."Register Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you want to register time for this user. This is based on the time spent from when the user logs in to when the user logs out.';
                }

                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user ID of the person who must approve records that are made by the user in the User ID field before the record can be released.';
                }
                field("Allow Deferral Posting From"; Rec."Allow Deferral Posting From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post deferrals to the company.';
                }
                field("Allow Deferral Posting To"; Rec."Allow Deferral Posting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date on which the user is allowed to post deferrals to the company.';
                }

                field("Delegated From"; Rec."Delegated From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegated From field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the approver that you can use if you want to send approval mail notifications.';
                }

                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Member No. field';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user''s phone number.';
                }



            }
            group(Administration)
            {

                field("Allow Login After Hours"; Rec."Allow Login After Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Login After Hours field.';
                }

                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who has rights to unblock approval workflows, for example, by delegating approval requests to new substitute approvers and deleting overdue approval requests.';
                }

                field("Post Bank Reconcilliation"; Rec."Post Bank Reconcilliation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Bank Reconcilliation field.';
                }
                field("Post Journals"; Rec."Post Journals")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Journals field.';
                }
                field("Post Reversals"; Rec."Post Reversals")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Reversals field.';
                }
                field("Reverse Register"; Rec."Reverse Register")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reverse Register field.';
                }
                field("Show Hidden"; Rec."Show Hidden")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show Hidden field.';
                }
                field("Show All"; Rec."Show All")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show All field';
                }
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the user type field.';

                }
                field("Multiple Login"; Rec."Multiple Login")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Multiple Login field.';
                }
                field("Max. No. [Open Documents]"; Rec."Max. No. [Open Documents]")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. No. [Open Documents] field.';
                }
                field("Office/Group"; Rec."Office/Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Office/Group field.';
                }
                field("Account Department"; Rec."Account Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department field.';

                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Responsibility Center field';
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }

            }
            group("Human Resource")
            {
                field("HOD User"; Rec."HOD User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HOD User field';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field';
                }

                field("Immediate Supervisor"; Rec."Immediate Supervisor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Immediate Supervisor field.';
                }

            }
            group("Funds Management")
            {
                field("Request Admin"; Rec."Request Admin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Admin field.';
                }
                field("Unlimited Loan Amt Appr"; Rec."Unlimited Loan Amt Appr")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unlimited Loan Amt Appr field.';
                }
                field("Unlimited PV Amount Approval"; Rec."Unlimited PV Amount Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unlimited PV Amount Approval field.';
                }
                field("Unlimited Purchase Approval"; Rec."Unlimited Purchase Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the user on this line is allowed to approve purchase records with no maximum amount. If you select this check box, then you cannot fill the Purchase Amount Approval Limit field.';
                }
                field("Unlimited Request Approval"; Rec."Unlimited Request Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the user on this line can approve all purchase quotes regardless of their amount. If you select this check box, then you cannot fill the Request Amount Approval Limit field.';
                }
                field("Unlimited Sales Approval"; Rec."Unlimited Sales Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the user on this line is allowed to approve sales records with no maximum amount. If you select this check box, then you cannot fill the Sales Amount Approval Limit field.';
                }
                field("Time Sheet Admin."; Rec."Time Sheet Admin.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the user can edit, change, and delete time sheets.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field';
                }
                field("HOD Imprest Approver"; Rec."HOD Imprest Approver")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HOD Imprest Approver field.';
                }
                field("Imprest Account"; Rec."Imprest Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Imprest Account field.';
                }
                field("Purchase Amount Approval Limit"; Rec."Purchase Amount Approval Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum amount in LCY that this user is allowed to approve for this record.';
                }
                field("Purchase Resp. Ctr. Filter"; Rec."Purchase Resp. Ctr. Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }

                field("Request Amount Approval Limit"; Rec."Request Amount Approval Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum amount in LCY that this user is allowed to approve for this record.';
                }

            }
        }
    }
    actions
    {

        area(Navigation)
        {
            action("User Signature")
            {
                Image = Signature;
                RunObject = page "User Signatures";
                RunPageLink = "User ID" = field("User ID");
                ApplicationArea = All;
                ToolTip = 'Executes the User Signature action';
            }
        }
        area(Processing)
        {
            group(Action3)
            {
                Caption = 'Approvals';
                Image = HRSetup;
                group("Approval Requests")
                {
                    Caption = 'Approval Requests';
                    Image = HRSetup;
                    action(SendApprovalRequest)
                    {
                        Caption = 'Send A&pproval Request';
                        Enabled = true;
                        Image = SendApprovalRequest;
                        ApplicationArea = All;

                        trigger OnAction()
                        var

                            LoanApp: Record Loans;
                            ProdFac: Record "Product Factory";
                            LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                            TotGuarant: Decimal;
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.SendUsersetupRequest(Rec);
                            CurrPage.Close();
                        end;
                    }
                    action(CancelApprovalRequest)
                    {
                        Caption = 'Cancel Approval Re&quest';
                        Image = CancelApprovalRequest;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.CancelUsersetupApprovalRequest(Rec, true, true);
                            CurrPage.Close();
                        end;
                    }
                    action(DefferApprovalRequest)
                    {
                        Caption = 'Deffer Approval Re&quest';
                        Image = DefaultFault;
                        Enabled = false;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            CurrPage.Close();
                        end;
                    }
                    action("Open Document")
                    {
                        Image = Category;
                        Caption = 'Open Approval Request';
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            approvalsMgmt: Codeunit "Approval Mgmt.";
                        begin
                            approvalsMgmt.OpenUsersetupApprovalRequest(Rec, true, true);
                            CurrPage.Close();
                        end;
                    }
                    action("Reject Application")
                    {
                        Image = Reject;
                        Caption = 'Reject Approval Request';
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprvlsMngt: Codeunit "Approval Mgmt.";
                            ApprovalEntries: Record "Approval Entries";
                        begin
                            ApprvlsMngt.RejectApprovalApplication(Rec."User ID");
                            CurrPage.Close();
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
                            approvalsMgmt.OpenApprovalEntriesPage(Rec."User ID", Database::"User Setup");
                        end;
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("User Signature_Promoted"; "User Signature")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 3.';
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
                actionref(DefferApprovalRequest_Promoted; DefferApprovalRequest)
                {
                }
                actionref("Open Document_Promoted"; "Open Document")
                {
                }
                actionref("Reject Application_Promoted"; "Reject Application")
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
    trigger OnOpenPage()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            CurrPage.Editable := true else
            CurrPage.Editable := false;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Approved,
            Rec."Approval Status"::Deffered,
            Rec."Approval Status"::"Pending Approval":
                begin
                    Error('Approval status must be open, the current status is %1', Rec."Approval Status");
                end;
        end;

    end;

    trigger OnDeleteRecord(): Boolean
    begin

        case Rec."Approval Status" of
            Rec."Approval Status"::Approved,
            Rec."Approval Status"::Deffered,
            Rec."Approval Status"::"Pending Approval":
                begin
                    Error('Approval status must be open, the current status is %1', Rec."Approval Status");
                end;
        end;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
}



