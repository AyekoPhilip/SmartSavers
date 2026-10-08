page 50900 "Guarantor Substitution"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Guarantors Substitution";
    Caption = 'Substitution Page';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Send Notification"; Rec."Send Notification")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Substitution Type"; Rec."Substitution Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Post As"; Rec."Post As")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;

                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Caption = 'Loan No.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Guarantors To Be Substituted"; Rec."Guarantors To Be Substituted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Loan Account No."; Rec."Loan Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Account Status"; Rec."Account Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("Current Savings"; Rec."Current Savings")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }

                field("Guarantors Name"; Rec."Guarantors Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = Rec."Application Type" = Rec."Application Type"::"Update Amount Guaranteed";
                    ShowMandatory = true;
                    StyleExpr = TRUE;
                }
                field("Distributed Amount"; Rec."Distributed Amount")
                {
                    ApplicationArea = All;
                }

            }
            part(Lines; "Loan Guarantors List")
            {
                Caption = 'Lines';
                Editable = LinesEdit;
                Visible = Rec."Application Type" <> Rec."Application Type"::"Update Amount Guaranteed";
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Trail Information")
            {
                Editable = false;
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
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
                action("Post Changes")
                {
                    Image = PostedCreditMemo;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        PostMngt: Codeunit "Register Management";
                    begin
                        //Rec.CheckMinRequiredInfo();
                        //Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                        case Rec."Post As" of
                            Rec."Post As"::"Create as User":
                                PostMngt.PostSubstitutionLine(Rec, 1);
                        end
                    end;
                }
            }
        }
        area(Reporting)
        {
            group(Aggreement)
            {
                action(Guarantors)
                {
                    Caption = 'View Guarantors';
                    Image = Group;
                    ApplicationArea = All;
                    RunObject = page "Guarantors & Security";
                    RunPageLink = "Loan No." = field("Loan No.");
                    trigger OnAction()
                    begin

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
                        Rec.CheckMinRequiredInfo();
                        Rec.PostApprovalRequest(0);
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
                        Rec.PostApprovalRequest(1);
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
                        Rec.PostApprovalRequest(2);
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147250);
                    end;
                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Post Changes_Promoted"; "Post Changes")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref(Guarantors_Promoted; Guarantors)
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

    trigger OnAfterGetRecord()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
        SetControlAppearance;
        LInesEditable;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        LInesEditable;
    end;

    trigger OnOpenPage()
    begin
        LInesEditable;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        MembApplic.Reset;
        MembApplic.SetRange("Captured By", UserId);
        MembApplic.SetFilter("Approval Status", '%1|%2', MembApplic."Approval Status"::Open, MembApplic."Approval Status"::"Pending Approval");
        if MembApplic.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnTransactions);
        end;
        Rec."Post As" := Rec."Post As"::"Post Automatically";

    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        LinesEdit: Boolean;
        MembApplic: Record "Guarantors Substitution";
        ErrorOnTransactions: Label 'There are still some pending document(s) on your account. Please list & select the pending document to use';
        Temp: Record "User Setup";

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);

        if (Rec."Approval Status" = Rec."Approval Status"::Approved) or (Rec."Approval Status" = Rec."Approval Status"::"Pending Approval") then
            LinesEdit := false
        else
            LinesEdit := true;
    end;

    procedure LInesEditable()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then begin
            CurrPage.Editable := false;
            LinesEdit := false;
        end;

        if Rec."Approval Status" = Rec."Approval Status"::Open then
            LinesEdit := true;
    end;
}




