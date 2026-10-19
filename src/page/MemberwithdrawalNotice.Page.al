page 50899 "Member withdrawal Notice"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Member withdrawal Notice";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                 field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Closure Type"; Rec."Closure Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                    Style = StandardAccent;
                    ShowCaption = false;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Withdrawa Noticel Date"; Rec."Withdrawal Notice Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = Rec."Document Type" = Rec."Document Type"::"Account Closure";
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Document Type" = Rec."Document Type"::"Account Closure";
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Death"; Rec."Date of Death")
                {
                    ApplicationArea = All;
                    Editable = Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Death";
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Reason for withdrawal"; Rec."Reason for withdrawal")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Description For Withdrawal"; Rec."Description For Withdrawal")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Description';
                }
                field("Total Savings"; Rec."Total Savings")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Total Liabilities"; Rec."Total Liabilities")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Member Email"; Rec.Email)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            part(Control18; "Loan List Part")
            {
                Editable = false;
                SubPageLink = "Account No." = field("Member No.");
                SubPageView = where("Outstanding Balance" = filter('>0'));
                ApplicationArea = All;
                Caption = 'Lines';
            }

            group("Trail Information")
            {
                Editable = false;
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Expired; Rec.Expired)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(FactBoxes)
        {
            part(Control8; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No."),
                                             "Account Category" = const("Shares Capital");
                Visible = true;
                ApplicationArea = All;
            }
            part(Control7; "Credit Statistics FactBox")
            {
                Caption = 'Credit Statistics FactBox';
                SubPageLink = "Member No." = field("Member No."),
                                             "Account Category" = const("Shares Deposit");
                Visible = true;
                ApplicationArea = All;
            }
            part("Banking History"; "Account Statistics FactBox")
            {
                Caption = 'Banking Statistics';
                SubPageLink = "Member No." = field("Member No.");
                SubPageView = where("Account Category" = const("Specialty Savings"));
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Risk Analysis")
            {
                Enabled = false;
                Image = Allocate;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Notice: Record "Member withdrawal Notice";
                begin
                    Rec.TestField("Closure Type", Rec."Closure Type"::"Withdrawal - Death");
                    Notice.SetRange("No.", Rec."No.");
                    if Notice.FindFirst() then begin
                        Report.Run(Report::"Risk Claim Form", true, false, Notice);
                    end;
                end;
            }
        }
        area(Processing)
        {
            action("Kin Beneficiary")
            {
                Caption = 'Kin Beneficiary';
                Enabled = false;
                Image = Relationship;
                RunObject = page "Kin Beneficiary";
                RunPageLink = "Account No" = field("Member No."), "Application No." = field("No.");
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approval Mgmt.";
                begin

                end;
            }
            action("Next of Kin")
            {
                Caption = 'Next of Kin';
                Enabled = false;
                Image = Group;
                RunObject = page "Next of KIN";
                RunPageLink = "Account No" = field("Member No.");
                ApplicationArea = All;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approval Mgmt.";
                begin

                end;
            }

        }

        area(creation)
        {
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
                        TellMngt: Codeunit "Teller-Post (Yes/No)";
                        KinDetail: Record "Next of KIN";
                    begin
                        Rec.TestField("Reason for withdrawal");
                        Rec.TestField("Withdrawal Notice Date");
                        Rec.TestField("Document Type");
                        Rec.TestField("Closure Type");

                        case Rec."Document Type" of
                            Rec."Document Type"::"Account Closure":
                                begin
                                    Rec.TestField("Account Dimension");
                                    Rec.TestField("Account No.");
                                end;
                        end;

                        if Members.Get(Rec."Member No.") then begin

                            case Rec."Application Type" of
                                Rec."Application Type"::"Recovery from Deposit":
                                    begin
                                        CreditAc.Reset();
                                        CreditAc.SetRange("Member No.", Members."No.");
                                        CreditAc.SetRange("Account Category", CreditAc."Account Category"::"Shares Deposit");
                                        if CreditAc.FindFirst() then begin
                                            if Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Normal" then begin
                                                if RegMngt.getCustLoanBalance(0, CreditAc."Member No.", 0) > RegMngt.GetOperationAccBalanceTxt(CreditAc."Account Category", CreditAc."Member No.", 2) then
                                                    Error(ErrorOnExcessLiability, RegMngt.getCustLoanBalance(0, CreditAc."Member No.", 0), RegMngt.GetOperationAccBalanceTxt(CreditAc."Account Category", CreditAc."Member No.", 2));
                                            end;
                                            if Rec."Closure Type" = Rec."Closure Type"::"Withdrawal - Normal" then begin
                                                Rec.CheckMinRequirement();
                                            end;
                                        end;
                                    end;

                                Rec."Application Type"::"Recovery from Fosa":
                                    begin
                                        AccBanking.Reset();
                                        AccBanking.SetRange("Member No.", Members."No.");
                                        AccBanking.SetRange("Account Category", AccBanking."Account Category"::Savings);
                                        if AccBanking.FindFirst() then begin
                                            if RegMngt.getCustLoanBalance(0, CreditAc."Member No.", 0) > TellMngt.CalcAvailableBal(AccBanking."No.") then
                                                Error(ErrorOnExcessLiability);
                                        end;

                                    end;
                            end;
                        end;

                        ApprovalsMgmt.OnSendAccnoticeRequest(Rec)
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
                        ApprovalsMgmt.OnCancelAccNoticeApprovalRequest(Rec, true, true);
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
                        ApprovalsMgmt.OpenAccNoticeApprovalRequest(Rec, true, true)
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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50461);
                    end;
                }
                action(MarkAsPosted)
                {
                    Caption = 'Mark as Posted';
                    Image = MakeAgreement;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify(true)
                    end;
                }

            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Kin Beneficiary_Promoted"; "Kin Beneficiary")
                {
                }
                actionref("Next of Kin_Promoted"; "Next of Kin")
                {
                }
                actionref("Risk Analysis_Promoted"; "Risk Analysis")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
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
                actionref(MarkAsPosted_Promoted; MarkAsPosted)
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
    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        LoanAgreement: Record "Guarantor & Security Posted";
        CreditAc: Record "Account Credit";
        AccBanking: Record "Account Banking";
        Members: Record Member;
        RegMngt: Codeunit "Register Management";
        Descript: Text[250];
        SegMnt: Record "Segment/County/Dividend/Signat";
        ErrorOnExcessLiability: Label 'Liabilities of %1 more than available balance of %2 to allow for member exit';
        ErrorOnNonsubCust: Label 'This member account is still attached as a guarantor. Kindly substitute before you continue';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

}




