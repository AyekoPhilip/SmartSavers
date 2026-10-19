page 50968 "Collateral Collection Card"
{
    DeleteAllowed = false;
    Caption = 'Collection Card';
    PageType = Card;
    SourceTable = "Security Collection";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec."Document Type" = Rec."Document Type"::Collateral then
                            CollaTypeVisible := true else
                            CollaTypeVisible := false;
                    end;
                }
                field("Operation Type"; Rec."Operation Type")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field("Account No."; Rec."Account No.")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Member No.';
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Collateral Register No."; Rec."Collateral Register No.")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Collateral/Document';
                    ApplicationArea = All;
                }
                field("Savings Account No."; Rec."Savings Account No.")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Account No.';
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field(Remarks; Rec.Remarks)
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
            group("Collateral Information")
            {
                Visible = CollaTypeVisible;
                field("Collateral Type"; Rec."Collateral Type")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Collateral; Rec.Collateral)
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Collateral Name"; Rec."Collateral Name")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Collateral Multiplier"; Rec."Collateral Multiplier")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Collateral Value"; Rec."Collateral Value")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Collateral Limit"; Rec."Collateral Limit")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Last Valuation Date"; Rec."Last Valuation Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Forced Sale Value"; Rec."Forced Sale Value")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Collateral Perfected"; Rec."Collateral Perfected")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

                field("Next Valuation Date"; Rec."Next Valuation Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                field("Inward/Outward"; Rec."Inward/Outward")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Captured By"; Rec."Captured By")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control9; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(SendApprovalRequest)
            {
                Caption = 'Send A&pproval Request';
                Enabled = true;
                Image = SendApprovalRequest;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    Rec.TestField(Remarks);
                    VarVariant := Rec;
                    Rec.TestField("Operation Type");
                    CustomApproval.ApplicationDocPane(VarVariant, ActItems::Agreement)
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
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    VarVariant := Rec;
                    CustomApproval.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                end;
            }
            action(OpenApprovalRequest)
            {
                Caption = 'Open Approval Request';
                Image = Category;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CustomApproval.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                end;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approval;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    CustomApproval.ApplicationDocPane(VarVariant, ActItems::RepaymentSchedule)
                end;
            }
            action(Post)
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                    RegMngt: Codeunit "Registry Mngt.";
                begin
                    if Confirm('Are sure you want to Post this application?', true) = false then exit;

                    Rec.TestField("Account No.");
                    Rec.TestField("Collateral Register No.");
                    Rec.TestField("Operation Type");
                    if Rec."Operation Type" = Rec."Operation Type"::Retrieval then
                        Rec.TestField("Transaction Type");
                    RegMngt.PostSafeCustodyCollection(Rec);

                end;
            }
            action("Safe Custody")
            {
                Image = PostedCreditMemo;
                ApplicationArea = All;
                RunObject = page "Collateral Reg. Lookup Page";
                RunPageLink = "Account No." = field("Account No."), "Document Type" = const(Document);
                RunPageView = where("Approval Status" = const(Posted));
                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin

                end;
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
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Safe Custody_Promoted"; "Safe Custody")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';

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
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;

        if Rec."Document Type" = Rec."Document Type"::Collateral then
            CollaTypeVisible := true else
            CollaTypeVisible := false;

    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    var
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        CustomApproval: Codeunit "Credit Mgmt.";
        CollaTypeVisible: Boolean;
        CollaDocVisible: Boolean;
        ActItems: Enum ActionPanesItems;
}




