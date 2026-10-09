page 51045 "Interest Header Posted"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Interest Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = PageEditable;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;
                }
                field("Interest Frequency"; Rec."Interest Frequency")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Distributed Amount"; Rec."Distributed Amount")
                {
                    ApplicationArea = All;
                }
                field("Loan Count"; Rec."Loan Count")
                {
                    Caption = 'Record Count';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Cashier ID"; Rec."Cashier ID")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
            }
            part("Buffer Lines"; "Buffer Lines")
            {
                Caption = 'Buffer Lines';
                Editable = PageEditable;
                SubPageLink = No = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            part(Control12; "Loans Interest Lines")
            {
                SubPageLink = No = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Control3; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control13; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(creation)
        {
            group(Action1000000010)
            {
                action("Create Entry Lines")
                {
                    Caption = 'Create Entry';
                    Image = Allocate;
                    Enabled=false;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        SelectOpttionsErr: Label 'Select Options';
                    begin
                        VarVariant := Rec;
                        Mgt.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                    end;
                }
                action(Post)
                {
                    Image = PrintAcknowledgement;
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        Mgt.ApplicationDocPane(VarVariant, ActItems::Agreement)
                    end;
                }

            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Enabled=false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        Mgt.ApplicationDocPane(VarVariant, ActItems::"Loan BuyOff")
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    Enabled=false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        Mgt.ApplicationDocPane(VarVariant, ActItems::"Salary Details")
                    end;
                }
                action(OpenApprovalRequest)
                {
                    Image = Category;
                    Enabled=false;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        Mgt.ApplicationDocPane(VarVariant, ActItems::Statement)
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
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        approvalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action("Mark as Posted")
                {

                    Image = MarketingSetup;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approvals Mgmt.";
                        DocPostMgt: Codeunit "Doc-PostMgt";
                    begin
                        DocPostMgt.fnIntPeriodClosure(Rec."Start Date", Rec."End Date", Rec."No.",Rec."Application Type");
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Posted := true;
                        Rec.Modify(true)
                    end;
                }
            }
        }
        area(Navigation)
        {
            group(Entries)
            {
                action(ReverseFunds)
                {
                    Caption = 'Reverse Entries';
                    Image = PostedVoucherGroup;
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::Posted;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        CredJnlMgt: Codeunit "Credit. Jnl.-Post Batch";
                    begin
                        Rec.OnBeforeReverseEntriesOnPostInt(Rec, 0);
                    end;
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
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Create Entry Lines_Promoted"; "Create Entry Lines")
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
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Mark as Posted_Promoted"; "Mark as Posted")
                {
                }
                actionref(ReverseFunds_Promoted; ReverseFunds)
                {
                }
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
                Caption = 'Post', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Disbursement', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

   

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateControls;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then Error('You cannot modify this record');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin
        UpdateControls;
        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;

    var
        Mgt: Codeunit "Credit Mgmt.";
        VarVariant: Variant;
        PageEditable: Boolean;
        ActItems: Enum ActionPanesItems;


    procedure UpdateControls()
    begin
        if (Rec.Posted = true) or (Rec."Approval Status" <> Rec."Approval Status"::Open) then begin
            PageEditable := false;
        end else
            PageEditable := true;
    end;
}




