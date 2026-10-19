page 50001 "Safe Custody Card"
{
    Caption = 'Safe Custody Card';
    PageType = Card;
    SourceTable = "Collateral Register";
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application Date"; Rec."Application Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ShowMandatory = true;
                    Caption = 'Member No.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Savings Account No."; Rec."Savings Account No.")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Savings Account No. field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }

                field("ID/Passport"; Rec."ID/Passport")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID/Passport field.';
                }

                field("SC Duration"; Rec."SC Duration")
                {
                    ShowMandatory = true;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FD Duration field.';
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FD Maturity Date field.';
                }
                field("Maturity Instructions"; Rec."Maturity Instructions")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maturity Instructions field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field("Terms & Conditions"; Rec."Terms & Conditions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Terms & Conditions.';

                }

            }
            group("Nominee Information")
            {
                field("Third Party Access"; Rec."Third Party Access")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Third Party Nominee field.';
                }
                field("Third Party Access ID/Passport"; Rec."Third Party Access ID/Passport")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Third Party Access ID/Passport field.';
                }

            }
            group("Trail Information")

            {
                Editable = false;

                field("Approval Status"; Rec."Approval Status")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Inward/Outward"; Rec."Inward/Outward")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.';

                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }

                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }

                field("Posted By"; Rec."Posted By")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }

                field("Date Posted"; Rec."Date Posted")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Captured By"; Rec."Captured By")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Captured By field.';
                }

            }
        }
        area(factboxes)
        {
           
            part(Control16; "SC Nominee Picture")
            {
                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }

            systempart(Control5; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control6; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; Links)
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
                Image = SendApprovalRequest;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin

                    VarVariant := Rec;
                    CustomApprvl.ApplicationDocPane(VarVariant, ActItems::Agreement)
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
                    CustomApprvl.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
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
                    CustomApprvl.ApplicationDocPane(VarVariant, ActItems::"Salary Details")
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
                    approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", Database::"Collateral Register");
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
                begin
                    Rec.CheckRequiredItems();
                    if Confirm('Are sure you want to Post this application?', true) = false then exit;
                    RegMngt.PostSafeCustody(Rec);
                end;
            }
            action(Attachment)
            {
                Image = Documents;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action("Member File")
            {
                Caption = 'Member File';
                Image = ElectronicDoc;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DMS: Record EDMS;
                begin
                    DMS.Reset;
                    DMS.SetRange(DMS.Key, DMS.Key::"member App");
                    if DMS.Find('-') then begin
                        HyperLink(DMS."url path" + Rec."No.");
                    end;
                end;
            }
            action(Nominee)
            {
                Caption = 'Third Part Access Nominee';
                Image = Customer;
                ApplicationArea = All;
                RunObject = page "SC Nominee List";
                RunPageLink = "No." = field("No.");
                trigger OnAction()
                var
                    DMS: Record EDMS;
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
            group(Category_Category4)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 3.';

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

                actionref(Attachment_Promoted; Attachment)
                {
                }
                actionref("Member File_Promoted"; "Member File")
                {
                }
                actionref(Nominee_Promoted; Nominee)
                {
                }
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
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Document;
        Rec."Maturity Instructions" := Rec."Maturity Instructions"::Renew;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
          then
            CurrPage.Editable := false
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
         then
            CurrPage.Editable := false;
        Rec."Document Type" := Rec."Document Type"::Document;
        Rec."Maturity Instructions" := Rec."Maturity Instructions"::Renew;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            error('You cannot edit a document with status-%1', Rec."Approval Status")
    end;

    var
        VarVariant: Variant;
        CustomApprvl: Codeunit "Credit Mgmt.";
        RegMngt: Codeunit "Registry Mngt.";
        ActItems: Enum ActionPanesItems;
}



