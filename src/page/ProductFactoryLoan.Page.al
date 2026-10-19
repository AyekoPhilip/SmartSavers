page 50993 "Product Factory-Loan"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true; 
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
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Member Segment"; Rec."Member Segment")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Loan Span"; Rec."Loan Span")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Billing Type"; Rec."Billing Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Charges Options"; Rec."Charges Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Charge Option"; Rec."Interest Charge Option")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Interest Rate (Min.)"; Rec."Interest Rate (Min.)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Rate (Max.)"; Rec."Interest Rate (Max.)")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Installment Charge Option"; Rec."Installment Charge Option")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Insurance Fee"; Rec."Insurance Fee")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Settlement Fee"; Rec."Settlement Fee")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Mobile Money"; Rec."Mobile Money")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Customer Segment"; Rec."Customer Segment")
                {
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Account No. Prefix"; Rec."Account No. Prefix")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account No. Suffix"; Rec."Account No. Suffix")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }


                field("Recovery Priority"; Rec."Recovery Priority")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Search Code"; Rec."Search Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Dimension"; Rec."Account Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                 field("Product Dimension";Rec."Product Dimension")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group(Finance)
            {
                Caption = 'Finance';
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Account (G/L)"; Rec."Loan Account (G/L)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Account (G/L)"; Rec."Interest Account (G/L)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Receivable Account (G/L)"; Rec."Receivable Account (G/L)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Insurance Paid A/c"; Rec."Insurance Paid A/c")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance Account';
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Insurance Due A/c"; Rec."Insurance Due A/c")
                {
                    Caption = 'Insurance Receivable';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Ledger Fee Due A/c"; Rec."Ledger Fee Due A/c")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Ledger Paid A/c"; Rec."Ledger Paid A/c")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Suspend Interest Account (G/L)"; Rec."Suspend Interest Account (G/L)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Penalty Due Account"; Rec."Penalty Due Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Penalty Paid Account"; Rec."Penalty Paid Account")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Penalty Percentage"; Rec."Penalty Percentage")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Credit Product")
            {
                Caption = 'Loan Parameters';
                field(Minutes; Rec.Minutes)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Ignore Related Balance"; Rec."Ignore Related Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Disbursement Destination"; Rec."Disbursement Destination")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Payment Destination"; Rec."Loan Payment Destination")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }

                field("Maximum Guarantors"; Rec."Maximum Guarantors")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Minimum Guarantors"; Rec."Minimum Guarantors")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Min. Re-application Period"; Rec."Min. Re-application Period")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Min. Qualification Period (Loan)';
                }
                field("Charge Interest Due"; Rec."Charge Interest Due")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Minimum Loan Amount"; Rec."Minimum Loan Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Maximum Loan Amount"; Rec."Maximum Loan Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Minimum Balance"; Rec."Minimum Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Minimum Contribution"; Rec."Minimum Contribution")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;

                }
                field("Check Min. Balance On"; Rec."Check Min. Balance On")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Prefferential Installments"; Rec."Prefferential Installments")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Ordinary Default Intallments"; Rec."Ordinary Default Intallments")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Appraisal Parameter Type"; Rec."Appraisal Parameter Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Mode"; Rec."Repayment Mode")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Grace Period - Interest"; Rec."Grace Period - Interest")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Grace Period-Principle"; Rec."Grace Period-Principle")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Installment Period"; Rec."Installment Period")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("Ordinary Deposits Multiplier"; Rec."Ordinary Deposits Multiplier")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Preferential Dep. Multiplier"; Rec."Preferential Dep. Multiplier")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Nature of Loan Type"; Rec."Nature of Loan Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Type of Discounting"; Rec."Type of Discounting")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Minimum Deposit Balance"; Rec."Minimum Deposit Balance")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Minimum Deposit Contribution"; Rec."Minimum Deposit Contribution")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Graduation % (Mobile)"; Rec."Graduation % (Mobile)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Downgrade % (Mobile)"; Rec."Downgrade % (Mobile)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deposits Appraisal Parameter"; Rec."Deposits Appraisal Parameter")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deposit Multiplier"; Rec."Deposit Multiplier")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Max. Boost Amount"; Rec."Max. Boost Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Fixed Loan Term"; Rec."Fixed Loan Term")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Does not Require Batching"; Rec."Does not Require Batching")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Allow Multiple Running Loans"; Rec."Allow Multiple Running Loans")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Allow Share Boost";Rec."Allow Share Boost")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Max. No.(Same Loans)"; Rec."Max. No.(Same Loans)")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("Rcv Max. Graduated Amount"; Rec."Rcv Max. Graduated Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = true;
                }
                field("Salary %"; Rec."Salary %")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("No. of Times Salary"; Rec."No. of Times Salary")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Appraise Based on Banking"; Rec."Appraise Based on Banking")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Exclude Sacco Deduction"; Rec."Exclude Sacco Deduction")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Member Category"; Rec."Member Category")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
        }
        area(factboxes)
        {
            systempart(Control3; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control2; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Action20)
            {
                action("Product Charges")
                {
                    Image = SetupPayment;
                    RunObject = Page "Loan Product Charges";
                    RunPageLink = "Product Code" = field("Product ID");
                    ApplicationArea = All;
                }
                action("Tiered Interest Rates")
                {
                    Image = RegisteredDocs;
                    RunObject = Page "Interest Banding";
                    RunPageLink = "Product ID" = field("Product ID");
                    ApplicationArea = All;
                }
                action("Tiered Installment")
                {
                    Image = RegisteredDocs;
                    RunObject = Page "Tiered Installment";
                    RunPageLink = "Product ID" = field("Product ID");
                    ApplicationArea = All;
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
                Caption = 'Application Documents';
                RunObject = Page "Product Document";
                RunPageLink = "Product ID" = field("Product ID");
                ApplicationArea = All;
            }
            action("Refinance Product")
            {
                Image = HRSetup;
                RunObject = Page "Loan Products To Bridge";
                RunPageLink = "Product Code" = field("Product ID");
                ApplicationArea = All;
            }
            action("Related Products")
            {
                Image = Documents;
                Caption = 'Related Products';
                RunObject = Page "Related Product List";
                RunPageLink = "Product Code" = field("Product ID");
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
                        Rec.WorkflowRecordMngt(1);
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

                actionref("Tiered Interest Rates_Promoted"; "Tiered Interest Rates")
                {
                }
                actionref("Tiered Installment_Promoted"; "Tiered Installment")
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
                actionref("Refinance Product_Promoted"; "Refinance Product")
                {
                }
                actionref("Related Products_Promoted"; "Related Products")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Permissions', Comment = 'Generated from the PromotedActionCategories property index 4.';
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
                actionref(Block_Promoted; Block)
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
        Rec."Product Class" := Rec."Product Class"::Loan
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Product Class" := Rec."Product Class"::Loan
    end;

    trigger OnOpenPage()
    begin

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable := false
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
        case Rec.Status of
            Rec.Status::Active,
            Rec.Status::Blocked,
            Rec.Status::"Pending Approval":
                begin
                    Error('You cannot modify this record. the current status is %1', Rec.Status);
                end;
        end
    end;


    var
        VarVariant: Variant;
        RegisterMngt: Codeunit "Register Management";
        StatusChange: Record "Status Change Permissions";
        UserSettings: Page "User Settings";
        DoctMngt: Codeunit "Doc. Mngt";
        FunctionStrng: Enum "Change Status";
        MsgOnPermissionTxt: Label 'You do not have the following Permission on this page: READ';



}




