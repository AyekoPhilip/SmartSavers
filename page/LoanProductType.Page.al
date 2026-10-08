page 50992 "Loan Product Type"
{
    CardPageID = "Product Factory-Loan";
   DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true; 
    PageType = List;
    SourceTable = "Product Factory";
    SourceTableView = WHERE("Product Class" = const(Loan));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product ID"; Rec."Product ID")
                {
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
                field("Product Class"; Rec."Product Class")
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
                field("Loan Account (G/L)"; Rec."Loan Account (G/L)")
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
                    RunPageLink = "Product Code" = FIELD("Product ID");
                    ApplicationArea = All;
                }
                action("Tiered Interest Rates")
                {
                    Image = RegisteredDocs;
                    RunObject = Page "Interest Banding";
                    RunPageLink = "Product ID" = FIELD("Product ID");
                    ApplicationArea = All;
                }
                action("Tiered Installment")
                {
                    Image = RegisteredDocs;
                    RunObject = Page "Tiered Installment";
                    RunPageLink = "Product ID" = FIELD("Product ID");
                    ApplicationArea = All;
                }
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

    trigger OnModifyRecord(): Boolean
    begin
        
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
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

    trigger OnOpenPage()
    begin
        DoctMngt.PermissionMngt(UserId, FunctionStrng::Administrator, FunctionStrng::Administrator);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;
    end;

    trigger OnAfterGetRecord()
    begin
        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            Error(MsgOnPermissionTxt);

        if not DoctMngt.RecordRestrictMngt(UserId, Database::"Product Factory", FunctionStrng::Administrator) then
            CurrPage.Editable := false;

    end;

    trigger OnClosePage()
    begin

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

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




