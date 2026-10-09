page 50976 "Partial Disbursement Schedule"
{
    PageType = List;
    SourceTable = "Partial Disbursement Schedule";
    ApplicationArea = All;
    SourceTableView=where("Approval Status"=filter(Open| "Pending Approval"| Approved));
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Caption = 'Entry No.';
                    StyleExpr = true;
                    Editable = false;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("External Account No."; Rec."External Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("External Account Name"; Rec."External Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Own Reference"; Rec."Own Reference")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Recipient Reference"; Rec."Recipient Reference")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
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
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Image = PostedCreditMemo;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    GenPostMngt.CodePostPartialDisb(Rec."Loan No.", true, Today, Rec."Loan No.", 0);
                end;
            }
            action("Post Preview")
            {
                Image = PostPrint;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    GenPostMngt.CodePostPartialDisb(Rec."Loan No.", false, Today, Rec."Loan No.", 0);
                end;
            }
        }
        area(Reporting)
        {
            action("Repayment  Schedule")
            {
                Image = Allocate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoansR: Record Loans;
                    Varvariant: Variant;
                    DocMngt: Codeunit "Doc. Mngt";
                    CredMgt: Codeunit "Credit Mgmt.";
                begin
                    LoansR.Reset;
                    LoansR.SetRange("No.", Rec."Loan No.");
                    if LoansR.Find('-') then begin
                        CredMgt.fncreateRepayschedule(false, LoansR."No.", 2)
                    end
                end;
            }
        }
        area(Navigation)
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
                        Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                        Image = SendApprovalRequest;
                        ApplicationArea = All;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                            LoanApp: Record Loans;
                            ProdFac: Record "Product Factory";
                            LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                            TotGuarant: Decimal;
                        begin
                            Rec.CheckMinRequirement(5);
                            Rec.CheckMinRequirement(1);
                            CurrPage.Close();
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
                            Rec.CheckMinRequirement(2);
                            CurrPage.Close();
                        end;
                    }
                    action(DefferApprovalRequest)
                    {
                        Caption = 'Deffer Approval Re&quest';
                        Image = DefaultFault;
                        Visible = false;
                        Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
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
                        Enabled = Rec.Posted = false;
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin
                            Rec.CheckMinRequirement(3);
                            CurrPage.Close();
                        end;
                    }
                    action("Reject Application")
                    {
                        Image = Reject;
                        Caption = 'Reject Approval Request';
                        Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                        Visible = true;
                        ApplicationArea = All;
                        trigger OnAction()
                        var
                            ApprvlsMngt: Codeunit "Approval Mgmt.";
                            ApprovalEntries: Record "Approval Entries";
                        begin
                            ApprvlsMngt.RejectApprovalApplication(Format(Rec."Entry No"));
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
                            approvalsMgmt.OpenApprovalEntriesPage(Format(Rec."Entry No"), 50411);
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

                actionref(Post_Promoted; Post)
                {
                }
                actionref("Post Preview_Promoted"; "Post Preview")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Repayment  Schedule_Promoted"; "Repayment  Schedule")
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
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 7.';
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
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Account Type" := Rec."Account Type"::Vendor;
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            Error(ErrorOnEditPage);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Account Type" := Rec."Account Type"::Vendor;
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            Error(ErrorOnEditPage);

    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            Error(ErrorOnEditPage);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            Error(ErrorOnEditPage);
    end;

    var
        GenPostMngt: Codeunit "Gen.Jnl.+Preview";
        ErrorOnEditPage: Label 'You cannot Edit a posted document';
}




