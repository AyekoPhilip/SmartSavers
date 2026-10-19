page 50954 "Collateral Register Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Collateral Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("ID/Passport"; Rec."ID/Passport")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Property Holder"; Rec."Property Holder")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Joint Ownership"; Rec."Joint Ownership")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Collateral Type"; Rec."Collateral Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Collateral; Rec.Collateral)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Collateral Name"; Rec."Collateral Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Collateral Multiplier"; Rec."Collateral Multiplier")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Collateral Value"; Rec."Collateral Value")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Market Value';
                }
                field("Collateral Limit"; Rec."Collateral Limit")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Inward/Outward"; Rec."Inward/Outward")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Last Valuation Date"; Rec."Last Valuation Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Forced Sale Value"; Rec."Forced Sale Value")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Insurance Value"; Rec."Insurance Value")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Collateral Perfected"; Rec."Collateral Perfected")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Next Valuation Date"; Rec."Next Valuation Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Policy No."; Rec."Policy No.")
                {
                    ApplicationArea = All;

                }
                field("Policy Start Date"; Rec."Policy Start Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;

                }
                field("Policy End Date"; Rec."Policy End Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;

                }
                field("Annual Premium Amount"; Rec."Annual Premium Amount")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;

                }
                field("Date Premium Last Paid"; Rec."Date Premium Last Paid")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                }
            }
            group("Other Information")
            {
                Caption = 'Other Information';
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Physical Location"; Rec."Physical Location")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Deed Transfer No."; Rec."Deed Transfer No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Value on Completion"; Rec."Value on Completion")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Chasis No."; Rec."Chasis No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Engine No."; Rec."Engine No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Year of Manufacture"; Rec."Year of Manufacture")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            part("Collateral Lines"; "Collateral Register Lines")
            {
                Caption = 'Collateral Checklist';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            group("Trail Information")
            {
                Caption = 'Trail Information';
                field("Captured By"; Rec."Captured By")
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
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
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
                var
                    LoanApp: Record "Loan Application";
                    LnSecurity: Record "Loan Guarantors and Security";
                begin

                    LnSecurity.Reset;
                    LnSecurity.SetRange("Collateral Reg. No.", Rec."No.");
                    LnSecurity.SetRange("Security Type", LnSecurity."Security Type"::Collateral);
                    if LnSecurity.Find('-') then begin

                        LoanApp.Reset();
                        LoanApp.SetRange("No.", LnSecurity."No.");
                        LoanApp.SetRange("Account No.", LnSecurity."Member No. (Loanee)");
                        if LoanApp.FindFirst() then begin
                            if LoanApp."Approval Status" <> LoanApp."Approval Status"::Open then
                                Error(ErrorOnDeleteDocTxt, LoanApp."No.");
                        end;
                        LnSecurity.Delete;
                    end;
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
                    ApprovalMgnt: Codeunit "Approval Mgmt.";
                begin
                    ApprovalMgnt.OpenApprovalEntriesPage(Rec."No.", 52140657)
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
            action("Appraisal Sheet")
            {
                Image = Documents;
                ApplicationArea = All;
                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                    CollatReg: Record "Collateral Register";
                begin
                    CollatReg.SetRange("No.", Rec."No.");
                    if CollatReg.FindFirst() then
                        Report.Run(Report::"Collateral Appraisal Sheet", true, false, CollatReg);

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
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Attachment_Promoted; Attachment)
                {
                }
                actionref("Appraisal Sheet_Promoted"; "Appraisal Sheet")
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

                actionref("Member File_Promoted"; "Member File")
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Collateral Type" := Rec."Collateral Type"::"Real Estate";
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
        //Rec."Collateral Type" := Rec."Collateral Type"::"Real Estate";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            error('You cannot edit a document with status-%1', Rec."Approval Status")
    end;

    var
        VarVariant: Variant;
        CustomApprvl: Codeunit "Credit Mgmt.";
        ActItems: Enum ActionPanesItems;
        ErrorOnDeleteDocTxt: Label 'You cannot open approval request attached to an Approved Document- %1';
}




