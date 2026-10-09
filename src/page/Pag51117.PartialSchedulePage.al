page 51117 "Partial Schedule Page"
{
    ApplicationArea = All;
    Caption = 'Partial Schedule Page';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "Partial Disbursement Schedule";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;

                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.';
                    Style = StandardAccent;
                    Visible = false;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Style = StandardAccent;
                    Caption = 'Loan No.';
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    Caption = 'Member No.';
                    StyleExpr = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                    Style = StandardAccent;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ToolTip = 'Specifies the value of the Account Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ToolTip = 'Specifies the value of the EFT Options field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("External Account No."; Rec."External Account No.")
                {
                    ToolTip = 'Specifies the value of the External Account No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("External Account Name"; Rec."External Account Name")
                {
                    ToolTip = 'Specifies the value of the External Account Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Payment Destination Code"; Rec."Payment Destination Code")
                {
                    ToolTip = 'Specifies the value of the Pay Point field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Own Reference"; Rec."Own Reference")
                {
                    ToolTip = 'Specifies the value of the Own Reference field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Recipient Reference"; Rec."Recipient Reference")
                {
                    ToolTip = 'Specifies the value of the Recipient Reference field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            group("Other Information")
            {
                Editable = false;
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ToolTip = 'Specifies the value of the Application Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Application No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                }

                field("Disbursement Destination"; Rec."Disbursement Destination")
                {
                    ToolTip = 'Specifies the value of the Disbursement Destination field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Institution Type"; Rec."Institution Type")
                {
                    ToolTip = 'Specifies the value of the Institution Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Payment Destination"; Rec."Payment Destination")
                {
                    ToolTip = 'Specifies the value of the Destination A/c field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    Visible = false;
                }
                field(Repayment; Rec.Repayment)
                {
                    ToolTip = 'Specifies the value of the Repayment field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Amount Approved"; Rec."Amount Approved")
                {
                    ToolTip = 'Specifies the value of the Amount Approved field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Amount Disbursed"; Rec."Amount Disbursed")
                {
                    ToolTip = 'Specifies the value of the Amount Disbursed field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ToolTip = 'Specifies the value of the Outstanding Balance field.';
                    Style = StandardAccent;
                    StyleExpr = true;

                }

                field("Scheduled Disbursement Date"; Rec."Scheduled Disbursement Date")
                {
                    ToolTip = 'Specifies the value of the Disbursement Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Society Code"; Rec."Society Code")
                {
                    ToolTip = 'Specifies the value of the Society Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Suggested for Disbursement"; Rec."Suggested for Disbursement")
                {
                    ToolTip = 'Specifies the value of the Suggested for Disbursement field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            group("Trail Information")
            {
                Editable = false;
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Captured By"; Rec."Captured By")
                {
                    ToolTip = 'Specifies the value of the Captured By field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ToolTip = 'Specifies the value of the Time Posted field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Time Posted"; Rec."Time Posted")
                {
                    ToolTip = 'Specifies the value of the Time Posted field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }

        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
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
            part(Comment; "Loan Comment Line")
            {
                Visible = false;
                SubPageLink = "No." = field("Account No.");
                Caption = 'Comment Line';
            }
            part(Picture; "Member Picture")
            {
                Caption = 'Picture';
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;
            }
            part(Signature; "Member Signature")
            {
                Caption = 'Signature';
                SubPageLink = "Member No." = FIELD("Account No.");
                ApplicationArea = All;

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
                    ResponseTxt := 0;
                    ResponseTxt := ConfirmPost();
                    case ResponseTxt of
                        1:
                            Rec."Preview Journal" := true;
                        else
                            Rec."Preview Journal" := false;
                    end;
                    Rec.Modify(true);
                    if ResponseTxt > 0 then begin
                        LoanPostMngt.InitPostPartSched(Rec);
                    end else
                        exit;
                end;
            }
            action("Post Preview")
            {
                Image = PostPrint;
                Enabled = Rec."Approval Status" <> Rec."Approval Status"::Approved;
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                var

                begin
                    // GenPostMngt.CodePostPartialDisb(Rec."Loan No.", false, Today, Rec."Loan No.", 0);
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
            group("Accounts")
            {
                action("Loan Card")
                {
                    Caption = 'Loan Card';
                    Image = LinkAccount;
                    ApplicationArea = All;
                    RunObject = page "Loans Card";
                    RunPageLink = "No." = field("Loan No.");
                }
                action("Partial Disbursement Posted")
                {
                    Image = History;
                    Caption = 'Posted Partial Schedule';
                    ApplicationArea = All;
                    RunObject = page "Partial Disbursement-Posted";
                    RunPageLink = "Loan No." = field("Loan No.");
                    trigger OnAction()
                    begin

                    end;
                }

            }
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
                        Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
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
                Caption = 'Associated Account', Comment = 'Generated from the PromotedActionCategories property index 6.';

                actionref("Loan Card_Promoted"; "Loan Card")
                {
                }
                actionref("Partial Disbursement Posted_Promoted"; "Partial Disbursement Posted")
                {
                }
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
    var
        LoanAc: Record "Partial Disbursement Schedule";
    begin
        LoanAc.Reset;
        LoanAc.SetRange("Captured By", UserId);
        LoanAc.SetFilter("Approval Status", '%1 | %2', LoanAc."Approval Status"::Open,
        LoanAc."Approval Status"::"Pending Approval");
        if LoanAc.Count > 2 then begin
            Error(ErrorOnMaxNoTransactions);
        end;
        Rec."Account Type" := Rec."Account Type"::Customer;
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

    local procedure ConfirmPost(): Integer
    var
        Selection: Integer;
        ShipInvoiceQst: Label '&Generate Batch,&Post Application';
        DefaultOption: Integer;
        PassInt: Integer;
    begin
        if DefaultOption > 2 then
            DefaultOption := 2;
        if DefaultOption <= 0 then
            DefaultOption := 0;
        Selection := StrMenu(ShipInvoiceQst, DefaultOption, 'Please select option to Post');
        PassInt := Selection;

        if Selection = 0 then
            exit;
        exit(PassInt);
    end;

    var
        GenPostMngt: Codeunit "Gen.Jnl.+Preview";
        RecRef: Record Loans;
        LoanPostMngt: Codeunit "Loan Post Mngt. (Yes/No)";
        ResponseTxt: Integer;
        ErrorOnEditPage: Label 'You cannot Edit a posted document';
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
}
