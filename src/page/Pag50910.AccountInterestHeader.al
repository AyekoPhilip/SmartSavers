page 50910 "Account Interest Header"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    Caption = 'Account Interest';
    PageType = Card;
    SourceTable = "Savings Interest Header";
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
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Document No."; Rec."Document No.")
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {

                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("Distributed Amount"; Rec."Distributed Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

            }
            part(Control12; "Loans Interest Lines")
            {
                Editable = false;
                Caption = 'Posting Lines';
                SubPageLink = No = FIELD("No.");
                ApplicationArea = All;
            }
            part(Control13; "Savings Interest Buffer")
            {
                Editable = false;
                Caption = 'Progession Lines';
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Trail Information")
            {
                Editable = false;
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = pageEditable;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }


            }
        }
        area(factboxes)
        {
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
        area(processing)
        {
            group(Post)
            {
                Image = HRSetup;
                action(PerformPost)
                {
                    Image = PostedCreditMemo;
                    Caption = 'Post Interest';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        PostMngt: Codeunit "Dividend Process";
                    begin
                        Rec.TestField("Posting Date");
                        Rec.TestField(Description);
                        if Confirm('Are you sure want to Post this application?', true) = false then exit;
                        PostMngt.InitializePostOnInterest(Rec, Rec."Posting Date", 1, Rec.Description);
                    end;
                }
                action(PostPreview)
                {
                    Image = PostedCreditMemo;
                    Caption = 'Post Preview';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        PostMngt: Codeunit "Dividend Process";
                    begin
                        Rec.TestField("Posting Date");
                        Rec.TestField(Description);
                        if Confirm('Are you sure want to Post this application?', true) = false then exit;
                        PostMngt.InitializePostOnInterest(Rec, Rec."Posting Date", 0, Rec.Description);
                    end;
                }
            }
        }
        area(Reporting)
        {
            group(Aggreement)
            {
                action(Reports)
                {
                    Image = Group;
                    Caption = 'Generate Interest Entries';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        IntHeader: Record "Savings Interest Header";

                    begin

                        IntHeader.Reset();
                        IntHeader.SetRange("No.", Rec."No.");
                        if IntHeader.FindFirst() then begin
                            Report.Run(Report::"Generate Account Interest", true, false, IntHeader);
                        end;

                    end;
                }

            }
        }
        area(Navigation)
        {

            group("Request Approval")
            {
                Image = ApprovalSetup;
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

                        CurrPage.Close();
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

                    end;
                }
                action(OpenApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Category;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin

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

                    end;
                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(PerformPost_Promoted; PerformPost)
                {
                }
                actionref(PostPreview_Promoted; PostPreview)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(Reports_Promoted; Reports)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 3.';
            }
            group(Category_Category5)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 4.';

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
            group(Category_Category6)
            {
                Caption = 'Accounts', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Attachment', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Email', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }

    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateControls();
    end;

    trigger OnOpenPage()
    begin
        UpdateControls();
    end;

    var
        PageEditable: Boolean;
        AccHeader: Record "Savings Interest Header";

    procedure UpdateControls()
    begin
    end;
}




