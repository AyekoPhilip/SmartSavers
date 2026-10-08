page 50888 "Remittance Header"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Checkoff Header";
    RefreshOnActivate = true;
    PopulateAllFields = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Cutoff Date"; Rec."Cutoff Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = All;

                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Post As"; Rec."Post As")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Application Type"; Rec."Application Type")
                {
                    ApplicationArea = All;

                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Deduction Type"; Rec."Deduction Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Loan Deduction Type"; Rec."Loan Deduction Type")
                {
                    ApplicationArea = All;
                    Editable = Rec."Deduction Type" = Rec."Deduction Type"::Loan;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Advice Type"; Rec."Advice Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    ShowCaption = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = EditCheckoff;
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = EditCheckoff;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Post Business Loan"; Rec."Post Business Loan")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
            }
            part(Control22; "Remittance Lines")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
            group(Computations)
            {
                Editable = false;
                field("Account Found"; Rec."Account Found")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Accounts(Found)';
                    ApplicationArea = All;
                }
                field("Accoun Not Found"; Rec."Accoun Not Found")
                {
                    Importance = Additional;
                    Caption = 'Accounts(Not Found)';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Posted Record"; Rec."Posted Record")
                {
                    Editable = false;
                    Style = StandardAccent;
                    Caption = 'Records(Posted)';
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Record Not Posted"; Rec."Record Not Posted")
                {
                    Style = StandardAccent;
                    Caption = 'Records(Not Posted)';
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Schedule Amount';
                    ApplicationArea = All;

                }
                field("Total Interest"; Rec."Total Interest")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

            }
            group("Trail Information")
            {
                Editable = false;
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
                field("Entered By"; Rec."Entered By")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                }

            }

        }
        area(factboxes)
        {
            systempart(Control21; Notes)
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
        area(processing)
        {
            action(Import)
            {
                Image = ImportExcel;
                Caption = 'Import File';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    ClearLine();
                    Commit();
                    case Rec."Application Type" of
                        Rec."Application Type"::"Allocated Amount":
                            Xmlport.Run(Xmlport::"Import Checkoff Receipts");
                        Rec."Application Type"::"Product Amount":
                            Xmlport.Run(Xmlport::"Import CheckOff- Product");
                        Rec."Application Type"::"Consolidated Amount":
                            begin
                                ConfigPackgt.Reset();
                                ConfigPackgt.SetRange(Code, 'CHECKOFF');
                                if ConfigPackgt.FindFirst() then begin
                                    Page.Run(Page::"Config.Package", ConfigPackgt, ConfigPackgt.Code);
                                end else begin
                                    Error('No Configuration Package related to this process found');
                                end;
                            end;
                    end;

                end;
            }
            action(ImportPackage)
            {
                Image = ImportExport;
                Visible = false;
                Enabled = false;
                Caption = 'Import Package';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    VarVariant := Rec;
                    Mgmt.ApplicationDocPane(VarVariant, ActItems::Commitments)
                end;
            }
            action(CreateFile)
            {
                Image = ImportExcel;
                Caption = 'Generate File';
                ApplicationArea = All;
                trigger OnAction()
                var
                    Base64Conv: Codeunit "Base64 Convert";
                    RemittnaceReport: Report "Gen. Remittance File";
                    AttachOutstr: OutStream;
                    Base64Txt: Text;
                    FileName: Text;
                    TempBlob: Codeunit "Temp Blob";
                    AttachInstr: InStream;
                    CheckoffHeader: Record "Checkoff Header";
                begin
                    Rec.TestField(Posted, false);
                    CheckoffHeader.Reset();
                    CheckoffHeader.SetRange("No.", Rec."No.");
                    if CheckoffHeader.FindFirst() then begin
                        Report.Run(Report::"Gen. Remittance File", true, false, CheckoffHeader);
                    end;
                end;
            }
            action("Validate Lines")
            {
                Caption = 'Validate Lines';
                Image = ValidateEmailLoggingSetup;
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Txt0000: Label 'Checkoff Successfully Generated';
                begin
                    Rec.TestField(Posted, false);
                    PostCheckMgt.PerfomValidate(Rec);
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = PostedMemo;
                Enabled = Rec."Approval Status" <> Rec."Approval Status"::Posted;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.OnBeforePerformPostOnCheckoffHeader(Rec, 0);
                end;
            }
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
                    Rec.OnBeforeReverseEntriesOnPostHeader(Rec, 0);
                end;
            }
            action("Mark as Posted")
            {
                Caption = 'Mark as Posted';
                Image = ReservationLedger;
                ApplicationArea = All;
                trigger OnAction()
                var
                    DocMngt: Codeunit "Doc. Mngt";
                    LoanApplic: Record "Loan Application";
                    TellerMngt: Codeunit "Teller-Post (Yes/No)";
                    Loans: Record Loans;
                begin

                    if TellerMngt.TestExtDocNoEntriesExist(Rec."Account Name", Rec."No.", 5) then begin
                        Rec."Posted By" := UserId;
                        Rec."Date Posted" := Today;
                        Rec."Time Posted" := Time;
                        Rec."Approval Status" := Rec."Approval Status"::Posted;
                        Rec.Modify;
                    end;
                end;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Posted, false);
                        VarVariant := Rec;
                        Mgmt.ApplicationDocPane(VarVariant, ActItems::"Salary Details")
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        VarVariant := Rec;
                        Mgmt.ApplicationDocPane(VarVariant, ActItems::RepaymentSchedule)
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
                action("Open Document")
                {
                    Image = Category;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField(Posted, false);
                        VarVariant := Rec;
                        Mgmt.ApplicationDocPane(VarVariant, ActItems::Statement)
                    end;
                }
            }
        }
        area(Reporting)
        {
            action(Report)
            {
                Image = Receipt;
                Caption = 'Checkoff Variance Report';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecHeader: Record "Checkoff Header";
                    CheckoffVariance: Report "Checkoff Variance Report";
                begin
                    RecHeader.SetFilter("No.", Rec."No.");
                    CheckoffVariance.SetTableView(RecHeader);
                    CheckoffVariance.Run();
                end;
            }


            action(Report2)
            {
                Image = Receipt;
                Caption = 'Checkoff Reconciliation Report';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecHeader: Record "Checkoff Header";
                    CheckoffVariance: Report "Check Off Reconciliation Repor";
                begin
                    RecHeader.SetFilter("No.", Rec."No.");
                    CheckoffVariance.SetTableView(RecHeader);
                    CheckoffVariance.Run();
                end;
            }
            action(Report3)
            {
                Image = Receipt;
                Caption = 'Detailed Checkoff Reconciliation ';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecLines: Record "Checkoff Receipt Lines";
                    CheckoffVariance: Report "Checkoff Rec Detailed";
                begin
                    RecLines.SetFilter("No.", Rec."No.");
                    CheckoffVariance.SetTableView(RecLines);
                    CheckoffVariance.Run();
                end;
            }
            action(Report4)
            {
                Image = Report;
                Caption = 'Posted Checkoff Variance ';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecHeader: Record "Checkoff Receipt Lines";
                    PostedCheckoffVariance: Report "Posted Checkoff Variance";
                begin
                    Rec.TestField(Posted, true);
                    Rec.Reset();
                    Rec.SetFilter("No.", Rec."No.");
                    Report.Run(Report::"Posted Checkoff Variance", true, false, Rec);
                    Rec.Reset();
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

                actionref(Report_Promoted; Report)
                {
                }
                actionref(Report2_Promoted; Report2)
                {
                }
                actionref(Report3_Promoted; Report3)
                {
                }
                actionref(Report4_Promoted; Report4)
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
                actionref(Approvals_Promoted; Approvals)
                {
                }
                actionref("Open Document_Promoted"; "Open Document")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'File', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref(Import_Promoted; Import)
                {
                }
                actionref(ImportPackage_Promoted; ImportPackage)
                {
                }
                actionref(CreateFile_Promoted; CreateFile)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Activities', Comment = 'Generated from the PromotedActionCategories property index 5.';

                actionref("Validate Lines_Promoted"; "Validate Lines")
                {
                }
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
                Caption = 'Account', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec."Post As" := Rec."Post As"::"Post As Batch";
        Rec."Application Type" := Rec."Application Type"::"Consolidated Amount";
        Rec."Advice Type" := Rec."Advice Type"::"Full Amount";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Post As" := Rec."Post As"::"Post As Batch";
        Rec."Application Type" := Rec."Application Type"::"Consolidated Amount";
        Rec."Advice Type" := Rec."Advice Type"::"Full Amount";
    end;
    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Posted = true then
            Error('You cannot Modify/Delete a record that is already Posted');
    end;
    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Posted = true then
            Error('You cannot Modify/Delete a record that is already Posted');
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        SetUpdateControl;
        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;

    trigger OnOpenPage()
    begin
        if Rec.Posted = true then
            CurrPage.Editable := false;
    end;

    var
        Mgmt: Codeunit "Credit Mgmt.";
        PostCheckMgt: Codeunit "Post. Checkoff Mngt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;
        EditCheckoff: Boolean;
        ActItems: Enum ActionPanesItems;
        ConfigPackgt: Record "Config. Package";


    local procedure ClearLine()
    var
        Receiptines: Record "Checkoff Receipt Lines";

    begin
        Receiptines.Reset;
        Receiptines.SetRange("No.", Rec."No.");
        Receiptines.DeleteAll;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure SetUpdateControl()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Open then begin
            EditCheckoff := true;
        end else begin
            EditCheckoff := false;
        end;
        if (Rec."Approval Status" = Rec."Approval Status"::Approved) or (Rec."Approval Status" = Rec."Approval Status"::"Pending Approval") then
            CurrPage.Editable := false;
    end;
}




