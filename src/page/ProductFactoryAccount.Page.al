page 50777 "Product Factory-Account"
{
    /* DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true; */
    PageType = Card;
    SourceTable = "Product Factory";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Product ID"; Rec."Product ID")
                {
                    Editable = true;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                 field("Member Segment"; Rec."Member Segment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Source Account"; Rec."Source Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
                field("Min. Customer Age"; Rec."Min. Customer Age")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Interest Rate (Min.)"; Rec."Interest Rate (Min.)")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate (Max.)"; Rec."Interest Rate (Max.)")
                {
                    Editable = true;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Dormancy Period"; Rec."Dormancy Period")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Customer Segment"; Rec."Customer Segment")
                {
                    Visible = false;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("No. Serialization"; Rec."No. Serialization")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
                field("Account No. Prefix"; Rec."Account No. Prefix")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Account No. Suffix"; Rec."Account No. Suffix")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
                field("Statement Charge"; Rec."Statement Charge")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Closure Fee"; Rec."Closure Fee")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Recovery Priority"; Rec."Recovery Priority")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Search Code"; Rec."Search Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
            }
            group(Finance)
            {
                Caption = 'Finance Mapping';
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Interest Expense Account"; Rec."Interest Expense Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Interest Payable Account"; Rec."Interest Payable Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Withholding Tax Account"; Rec."Withholding Tax Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("WithHolding Tax"; Rec."WithHolding Tax")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Over Draft Interest Account"; Rec."Over Draft Interest Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
            }
            group("Saving Product")
            {
                Caption = 'Account Parameters';
                field("Loan Disbursement Account"; Rec."Loan Disbursement Account")
                {
                    Visible = true;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Auto Open Account"; Rec."Auto Open Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Allow Multiple Accounts"; Rec."Allow Multiple Accounts")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Can Guarantee Loan"; Rec."Can Guarantee Loan")
                {
                    ToolTip = 'Specifies the value of the Can Guarantee Loan field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
               
                field("Allow Over Draft"; Rec."Allow Over Draft")
                {
                    Caption = 'Allow Overdraft';
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Earns Interest"; Rec."Earns Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Automatic Overdraft"; Rec."Automatic Overdraft")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Allow Multiple Over Draft"; Rec."Allow Multiple Over Draft")
                {
                    Caption = 'Allow Multiple Overdraft';
                    ApplicationArea = All;
                }
                field("Enforce Min. Share Rule"; Rec."Enforce Min. Share Rule")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Account Validation"; Rec."Account Validation")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Withdrawal Option"; Rec."Withdrawal Option")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Minimum Contribution"; Rec."Minimum Contribution")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Minimum Balance"; Rec."Minimum Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Withdrawal Interval"; Rec."Withdrawal Interval")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Charge Subsiquent withdrawal"; Rec."Charge Subsiquent withdrawal")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    Editable = true;

                }
                field("Interest Calc Min Balance"; Rec."Interest Calc Min Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Credit Limit (Overdraft)"; Rec."Credit Limit (Overdraft)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Over Draft Interest (%)"; Rec."Over Draft Interest (%)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Dividend Calc. Method"; Rec."Dividend Calc. Method")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Savings Duration"; Rec."Savings Duration")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Savings Withdrawal penalty"; Rec."Savings Withdrawal penalty")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                }
                field("Member Category"; Rec."Member Category")
                {
                    Caption = 'Member category';
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Min. No (Signatory)"; Rec."Min. No (Signatory)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;

                }
            }
        }
        area(factboxes)
        {
            systempart(Control32; Notes)
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
        area(creation)
        {
            group(Action79)
            {
                action("Product Charges")
                {
                    Image = SetupPayment;
                    RunObject = Page "Loan Product Charges";
                    RunPageLink = "Product Code" = FIELD("Product ID");
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        RegisterMngt.fnActionPaneItems(VarVariant, 7)
                    end;
                }
                action("Interest Rates Banding")
                {
                    Image = RegisteredDocs;
                    ApplicationArea = All;
                    RunObject = page "Interest Banding";
                    RunPageLink = "Product ID" = field("Product ID");
                }
            }
        }
        area(Processing)
        {
            action(CopyRecord)
            {
                Caption = 'Copy Record';
                Image = CopyDimensions;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecRef: Record "Product Factory";
                begin
                    RegisterMngt.CopyRecord(0, Rec, Rec."Account Dimension");
                end;
            }

        }
        area(navigation)
        {
            action("Product Application Document")
            {
                Image = Documents;
                RunObject = Page "Product Document";
                RunPageLink = "Product ID" = FIELD("Product ID");
                ApplicationArea = All;
            }
            group("Approval Requests")
            {
                Caption = 'Approval Requests';
                Image = HRSetup;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
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
                        VarVariant := Rec;
                        Rec.WorkflowRecordMngt(1);
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
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        Rec.WorkflowRecordMngt(2);
                        CurrPage.Close();
                    end;
                }
                action("Open Document")
                {
                    Image = Category;
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        Rec.WorkflowRecordMngt(3);
                        CurrPage.Close();
                    end;
                }
                action(Block)
                {
                    Image = AuthorizeCreditCard;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        Rec.WorkflowRecordMngt(4);
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
                        VarVariant := Rec;
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."Product ID", 52147135);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Product Charges', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Interest Rates Banding_Promoted"; "Interest Rates Banding")
                {
                }
                actionref("Product Charges_Promoted"; "Product Charges")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Documents', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Product Application Document_Promoted"; "Product Application Document")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Permissions', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(Block_Promoted; Block)
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
                actionref("Open Document_Promoted"; "Open Document")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category7)
            {
                Caption = 'Related Product', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(CopyRecord_Promoted; CopyRecord)
                {
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Product Class" := Rec."Product Class"::Account
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Product Class" := Rec."Product Class"::Account
    end;

    trigger OnOpenPage()
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false
    end;

    trigger OnAfterGetCurrRecord()
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false

    end;

    trigger OnModifyRecord(): Boolean
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

        if Rec.Status <> Rec.Status::Open then
            Error('You cannot edit an account whose status is active');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

        if Rec.Status <> Rec.Status::Open then
            Error('You cannot edit an account whose status is active');
    end;

    var
        RegisterMngt: Codeunit "Register Management";
        VarVariant: Variant;

    procedure DocumentControl()
    begin
    end;

    var
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';

}




