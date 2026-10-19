page 50815 "EFT Transfer Header"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "EFT Transfer Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("EFT Options"; Rec."EFT Options")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Suggest All Product"; Rec."Suggest All Product")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Re-suggest Application"; Rec."Re-suggest Application")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Reason for Re-suggestion"; Rec."Reason for Re-suggestion")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Editable = TransactionTypeEdit;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Suggest Single Loan"; Rec."Suggest Single Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = Rec."Suggest All Product" = false;
                    StyleExpr = true;
                }
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Suggest Single Loan" = true;
                    Enabled = Rec."Suggest All Product" = false;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Account Type"; Rec."Account Type")
                {

                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Remarks; Rec.Remarks)
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Source of funds"; Rec."Source of funds")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ValuesAllowed = 1;
                    ApplicationArea = All;
                }
                field("External Payment Option"; Rec."External Payment Option")
                {
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Record Total"; Rec."Record Total")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Record Count"; Rec."Record Count")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            part(Control1; "EFT Transfer Lines")
            {
                Caption = 'EFT Transfer Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
                //Editable = false;
            }
            part(Control2; "EFT Reciept Line")
            {
                Visible = false;
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
                Editable = false;
            }

            group("Trail Information")
            {
                Editable = false;
                field("Application Source"; Rec."Application Source")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        getControl;
                    end;
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
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Transferred"; Rec."Date Transferred")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Time Transferred"; Rec."Time Transferred")
                {
                    ApplicationArea = All;
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
        }
    }

    actions
    {
        area(Processing)
        {
            action("Suggest Lines")
            {
                Image = Allocate;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                    Rec.TestField("Source of funds", Rec."Source of funds"::"Loan Proceed");
                    eftProcessing.CreateEftLines(Rec."No.",Rec."Product Type", Rec."Date Entered", 1);
                end;
            }
            action("Clear Lines")
            {
                Image = Allocations;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                    eftProcessing.CreateEftLineOnSingleEntry(Rec."No.",
                              Rec."Product Type", Rec."Date Entered", 0);
                end;
            }
        }
        area(creation)
        {
            group("Process EFT")
            {
                Caption = 'Process EFT';
                action("Generate EFT File")
                {
                    Caption = 'Generate EFT File';
                    Image = "Report";
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        RecLines: Record "EFT Transfer Lines";
                        EFTFile: Report "EFT File";
                    begin
                        eftProcessing.GenerateEFTFile(Rec);
                    end;
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = PostedCreditMemo;
                    Visible = TransferVisible;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.CheckMinRequired(0);
                        case Rec."Document Type" of
                            Rec."Document Type"::"Electronic Fund Transfer":
                                eftProcessing.ElectronicFundsProcessing(Rec, 1, false);
                            Rec."Document Type"::"Close Account":
                                eftProcessing.EFTAccountClosureProcessing(Rec, 1);
                        end;
                    end;
                }
                action("Post Preview")
                {
                    Caption = 'Post Preview';
                    Image = PrintVoucher;
                    Visible = TransferVisible;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.CheckMinRequired(0);
                        case Rec."Document Type" of
                            Rec."Document Type"::"Electronic Fund Transfer":
                                eftProcessing.ElectronicFundsProcessing(Rec, 0, false);
                            Rec."Document Type"::"Close Account":
                                eftProcessing.EFTAccountClosureProcessing(Rec, 0);

                        end;
                    end;
                }
                action("Post+Print")
                {
                    Caption = 'Post+ Print';
                    Image = PostPrint;
                    Visible = TransferVisible;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.CheckMinRequired(0);
                        case Rec."Document Type" of
                            Rec."Document Type"::"Electronic Fund Transfer":
                                eftProcessing.ElectronicFundsProcessing(Rec, 1, true);
                            Rec."Document Type"::"Close Account":
                                eftProcessing.EFTAccountClosureProcessing(Rec, 1);
                        end;
                    end;
                }
                action("Loan Schedule")
                {
                    Caption = 'Loan Schedule';
                    Image = PostPrint;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        EftLine: Record "EFT Transfer Lines";
                        EftLoanSchedule: Report "EFT Loan Schedule";
                    begin
                        EftLine.SetFilter("Document No.", Rec."No.");
                        EftLoanSchedule.SetTableView(EftLine);
                        EftLoanSchedule.Run();
                    end;
                }

                action("Print Preview")
                {
                    Caption = 'Print Preview';
                    Image = PostPrint;
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.CheckMinRequired(3);
                    end;
                }

            }
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
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50376);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending Approval");
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
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

                    Image = SendApprovalRequest;
                    Visible = SendApprovalRequestVisible;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec.CheckMinRequired(2);
                        ApprovalsMgmt.OnSendEFTApprovalRequest(Rec);
                        CurrPage.Close();
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';

                    Image = Cancel;
                    Visible = CancelApprovalRequestVisible;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelEFTApprovalRequest(Rec, true, true);
                        CurrPage.Close();
                    end;
                }
                action("Open Approval Request")
                {
                    Image = ReOpen;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.OnOpenEFTApprovalRequest(Rec, true, true)
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        approvalsMgmt.OpenApprovalEntriesPage(Rec."No.", 50376);
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
                actionref("Post Preview_Promoted"; "Post Preview")
                {
                }
                actionref("Post+Print_Promoted"; "Post+Print")
                {
                }
                actionref("Suggest Lines_Promoted"; "Suggest Lines")
                {
                }
                actionref("Clear Lines_Promoted"; "Clear Lines")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Reports', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Generate EFT File_Promoted"; "Generate EFT File")
                {
                }
                actionref("Loan Schedule_Promoted"; "Loan Schedule")
                {
                }
                actionref("Print Preview_Promoted"; "Print Preview")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
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
                Caption = 'Standing order', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Slalary ', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
                actionref("Open Approval Request_Promoted"; "Open Approval Request")
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category10)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        getControl;
        if Rec."Approval Status" <> Rec."Approval Status"::Open
        then
            CurrPage.Editable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        RecRef: Record "EFT Transfer Header";
    begin
        Temp.Get(UserId);
        Temp.TestField("Max. No. [Open Documents]");

        RecRef.Reset;
        RecRef.SetRange("Created By", UserId);
        RecRef.SetRange("Approval Status", RecRef."Approval Status"::Open);
        if RecRef.Count > Temp."Max. No. [Open Documents]" then begin
            Error(ErrorOnMaxNoTransactions);
        end;
        Rec."Account Type" := Rec."Account Type"::"Bank Account";
        Rec."Document Type" := Rec."Document Type"::"Electronic Fund Transfer";
        Rec."Application Source" := Rec."Application Source"::Credit;
    end;

    trigger OnOpenPage()
    var
        Filterstring: Text[250];
        FilterRespCentre: Code[10];
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
        then
            CurrPage.Editable := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
        then
            Error(ErrorPermsTxt);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Open
        then
            Error(ErrorPermsTxt);
    end;

    var
        eftProcessing: Codeunit "Banking Procedure Mngt.";
        DocumentTypeEdit: Boolean;
        TransactionTypeEdit: Boolean;
        AccountTypeEdit: Boolean;
        AccountNoEdit: Boolean;
        StartDateEdit: Boolean;
        EndDateEdit: Boolean;
        RemarkEdit: Boolean;
        EFTLineEdit: Boolean;
        Temp: Record "User Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        SendApprovalRequestVisible: Boolean;
        CancelApprovalRequestVisible: Boolean;
        GenerateStandingOrdtVisible: Boolean;
        TransferVisible: Boolean;
        SuccessfulGeneration: Label 'Successfully Generated';
        ErrorPermsTxt: Label 'You cannot edit or Delete a which status is not Open';
        GeneralSetUp: Record "General Set-Up";
        TextGen: Text[250];
        EFTHeader: Record "EFT Transfer Header";
        EFTFileTxt: Label 'are you sure you want to generate EFT File ?';
        ConfirmMSG: Label 'are you sure you want to set status of this document to open?';
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';
        ElectronicFundsL: Record "EFT Transfer Lines";


    procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;


    procedure getControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Transferred then begin
            SendApprovalRequestVisible := false;
            CancelApprovalRequestVisible := false;
            GenerateStandingOrdtVisible := false;
            TransferVisible := false;
        end else begin
            SendApprovalRequestVisible := true;
            CancelApprovalRequestVisible := true;
            GenerateStandingOrdtVisible := false;
            TransferVisible := true;
        end;

        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                begin
                    DocumentTypeEdit := true;
                    TransactionTypeEdit := true;
                    AccountTypeEdit := true;
                    AccountNoEdit := true;
                    StartDateEdit := true;
                    EndDateEdit := true;
                    RemarkEdit := true;
                    EFTLineEdit := true;
                end;

            Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Rejected, Rec."Approval Status"::Approved:
                begin
                    DocumentTypeEdit := false;
                    TransactionTypeEdit := false;
                    AccountTypeEdit := false;
                    AccountNoEdit := false;
                    StartDateEdit := false;
                    EndDateEdit := false;
                    RemarkEdit := false;
                    EFTLineEdit := false;
                end;
        end;
    end;
}




