page 50811 "Standing Order"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Standing Order Header";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {


                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Source Account Type"; Rec."Source Account Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Source Account No."; Rec."Source Account No.")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Source Account Name"; Rec."Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Allocated Amount"; Rec."Allocated Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Allow Partial Deduction"; Rec."Allow Partial Deduction")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Income Type"; Rec."Income Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Standing Order Type"; Rec."Standing Order Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        statusControl;
                    end;
                }
                field("Deduction Status"; Rec."Deduction Status")
                {
                    ApplicationArea = All;
                }
                field("Effective/Start Date"; Rec."Effective/Start Date")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Frequency (Months)"; Rec."Frequency (Months)")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Duration (Months)"; Rec."Duration (Months)")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Next Run Date"; Rec."Next Run Date")
                {
                    ApplicationArea = All;
                }
            }
            part(Control46; "Standing Order Lines")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group(Statistics)
            {
                Editable = false;

                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field(Effected; Rec.Effected)
                {
                    ApplicationArea = All;
                }
                field(Unsuccessfull; Rec.Unsuccessfull)
                {
                    ApplicationArea = All;
                }

                field("Auto Process"; Rec."Auto Process")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Date Reset"; Rec."Date Reset")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        area(creation)
        {
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");

                    end;
                }
                action("Reject Application")
                {
                    Image = Reject;
                    Caption = 'Reject Approval Request';
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprvlsMngt: Codeunit "Approval Mgmt.";
                        ApprovalEntries: Record "Approval Entries";
                    begin
                        ApprvlsMngt.RejectApprovalApplication(Rec."No.");
                        CurrPage.Close();
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Approval Comments";
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;
                }
            }
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
                        StandingOrderLines: Record "Standing Order Lines";
                        TotalLineAmt: Decimal;
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                        Rec.TestField("Source Account No.");
                        Rec.TestField(Amount);
                        Rec.TestField("Effective/Start Date");
                        Rec.TestField("Duration (Months)");
                        Rec.TestField("Frequency (Months)");
                        Rec.CalcFields("Allocated Amount");
                        Rec.TestField(Description);
                        TotalLineAmt := 0;

                        StandingOrderLines.Reset;
                        StandingOrderLines.SetRange(StandingOrderLines."Document No.", Rec."No.");
                        if StandingOrderLines.Find('-') then begin
                            repeat
                                StandingOrderLines.TestField(StandingOrderLines."Destination Account No.");
                                StandingOrderLines.TestField(StandingOrderLines.Amount);
                                TotalLineAmt := TotalLineAmt + StandingOrderLines.Amount;

                                case StandingOrderLines."Destination Account Type" of
                                    StandingOrderLines."Destination Account Type"::"Bank Account":
                                        begin
                                            StandingOrderLines.TestField(StandingOrderLines."Bank Code");
                                            StandingOrderLines.TestField(StandingOrderLines."Destination Account No.");
                                            Rec."Transfered to EFT" := true;

                                        end;
                                    StandingOrderLines."Destination Account Type"::Loan:
                                        begin
                                            StandingOrderLines.TestField("Loan No.");
                                        end;
                                end;
                            until StandingOrderLines.Next = 0;
                        end;
                        rec.TestField("Allocated Amount", Rec.Amount);
                        ApprovalsMgmt.OnSendStandingOrderApprovalRequest(Rec)
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
                        ApprovalsMgmt.OnCancelStandingOrderApprovalRequest(Rec, true, true)

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
                        ApprovalsMgmt.OnOpenStandingOrderApprovalRequest(Rec, true, true)

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
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 52147162);
                    end;
                }
                action(Stop)
                {
                    Image = Stop;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        StopConfirm: Label 'Are you sure you want to Stop this standing order?';
                        ApprovalMgt: Codeunit "Approval Mgmt.";
                    begin
                        ApprovalMgt.OnStopStandingOrderApprovalRequest(Rec, true, true)

                    end;
                }

                action("Member Statistics")
                {
                    Image = Customer;
                    RunObject = Page "Member Statistics";
                    RunPageLink = "No." = FIELD("Member No.");
                    ApplicationArea = All;
                }
                action("Post Preview")
                {
                    Image = PostedCreditMemo;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        BnkMngt: Codeunit "Banking Procedure Mngt.";
                        Temp: Record "Banking User Template";
                        Journal: Record "Gen. Journal Line";
                    begin
                        Temp.Get(UserId);
                        Temp.TestField("STO Journal Template");
                        Temp.TestField("STO Journal Batch");
                        BnkMngt.PerformPostOnStandingOrder(Rec."Income Type"::Periodic, Rec."No.", 0);

                        Commit();
                        Journal.Reset();
                        Journal.SetRange("Journal Template Name", Temp."STO Journal Template");
                        Journal.SetRange("Journal Batch Name", Temp."STO Journal Batch");
                        if Journal.Find('-') then
                            Page.Run(Page::"Journal Test Batch", Journal);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Post Preview_Promoted"; "Post Preview")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Statistics', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref("Member Statistics_Promoted"; "Member Statistics")
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
                actionref(Comment_Promoted; Comment)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Account', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Reject Application_Promoted"; "Reject Application")
                {
                }
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
            group(Category_Category7)
            {
                Caption = 'Statement', Comment = 'Generated from the PromotedActionCategories property index 6.';

                actionref(Stop_Promoted; Stop)
                {
                }
            }
            group(Category_Category8)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Source Account Type" := Rec."Source Account Type"::Savings;
    end;

    trigger OnOpenPage()
    begin

        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open then
            CurrPage.Editable := false;
    end;

    var
        TransactionTypeEdit: Boolean;
        SourceAccountNoEtit: Boolean;
        DescriptionEdit: Boolean;
        AmountEdit: Boolean;
        AllowPartialEdit: Boolean;
        IncomeTypeEdit: Boolean;
        EffectiveDateEdit: Boolean;
        FrequencyEdit: Boolean;
        DurationEdit: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        SOLinesEdit: Boolean;


    procedure statusControl()
    begin
        CASE Rec."Approval Status" OF
            Rec."Approval Status"::Open:
                BEGIN
                    TransactionTypeEdit := TRUE;
                    SourceAccountNoEtit := TRUE;
                    DescriptionEdit := TRUE;
                    AmountEdit := TRUE;
                    AllowPartialEdit := TRUE;
                    IncomeTypeEdit := TRUE;
                    EffectiveDateEdit := TRUE;
                    FrequencyEdit := TRUE;
                    DurationEdit := TRUE;
                    SOLinesEdit := TRUE;
                END;

            Rec."Approval Status"::"Pending Approval",
            Rec."Approval Status"::Approved,
            Rec."Approval Status"::Rejected,
            Rec."Approval Status"::Stopped:
                BEGIN
                    TransactionTypeEdit := FALSE;
                    SourceAccountNoEtit := FALSE;
                    DescriptionEdit := FALSE;
                    AmountEdit := FALSE;
                    AllowPartialEdit := FALSE;
                    IncomeTypeEdit := FALSE;
                    EffectiveDateEdit := FALSE;
                    FrequencyEdit := FALSE;
                    DurationEdit := FALSE;
                    SOLinesEdit := FALSE;
                END;
        END;
    end;


    procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;
}




