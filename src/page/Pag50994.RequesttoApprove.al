page 50994 "Request to Approve"
{
    Caption = 'Approval Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Approval Entries";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Overdue; Overdue)
                {
                    Caption = 'Overdue';
                    Editable = false;
                    ToolTip = 'Overdue Entry';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(AccNo; AccNo)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Account No.';

                }
                field(AccountName; AccountName)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Account Name';
                }
                field(ProdName; ProdName)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Caption = 'Product Type';
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }

                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    Editable = true;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = All;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                Image = View;
                action(Document)
                {
                    Caption = 'Document';
                    Image = Document;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ShowRecord;
                    end;
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = FIELD("Table ID"),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("Document No.");
                    RunPageView = SORTING("Table ID", "Document Type", "Document No.");
                    ApplicationArea = All;
                }
                action("O&verdue Entries")
                {
                    Caption = 'O&verdue Entries';
                    Image = OverdueEntries;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.SetFilter(Status, '%1|%2', Rec.Status::Created, Rec.Status::Open);
                        Rec.SetFilter("Due Date", '<%1', Today);
                    end;
                }
                action("All Entries")
                {
                    Caption = 'All Entries';
                    Image = Entries;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Status);
                        Rec.SetRange("Due Date");
                    end;
                }
            }
        }
        area(processing)
        {
            action(Approve)
            {
                Caption = '&Approve';
                Image = Approve;
                Visible = ApproveVisible;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entries";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    if ApprovalEntry.Find('-') then
                        repeat
                            ApprovalMgt.ApproveApprovalRequest(ApprovalEntry);
                        until ApprovalEntry.Next = 0;
                end;
            }
            action(Reject)
            {
                Caption = '&Reject';
                Image = Reject;
                Visible = RejectVisible;
                ApplicationArea = All;


                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entries";
                    ApprovalSetup: Record "Approval Setup";
                    ApprovalCommentLine: Record "Apprvals. Comment Line";
                    ApprovalComment: Page "Apprvls Comment Line";
                    ApprovalCommentLine2: Record "Apprvals. Comment Line";
                    RejectionComments: Page "Rejection Comments";
                    Comment: Text;
                    AppMngt: Codeunit "Approval Mgmt.";
                    CommentLine: Record "Apprvals. Comment Line";

                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    if ApprovalEntry.Find('-') then
                        repeat
                            if not ApprovalSetup.Get then
                                Error(Text004);
                            if ApprovalSetup."Request Rejection Comment" = true then begin
                                CommentLine.SETRANGE("Table ID", ApprovalEntry."Table ID");
                                CommentLine.SETRANGE("Document Type", ApprovalEntry."Document Type");
                                CommentLine.SETRANGE("Document No.", ApprovalEntry."Document No.");
                                CommentLine.DeleteAll();
                                Commit();
                                AppMngt.InsertRejectionComment(Rec, '', Rec."Table ID");
                                Commit();

                                ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
                                ApprovalCommentLine.SetRange("Document Type", ApprovalEntry."Document Type");
                                ApprovalCommentLine.SetRange("Document No.", ApprovalEntry."Document No.");
                                ApprovalComment.SetTableView(ApprovalCommentLine);
                                IF ApprovalComment.RunModal() = Action::OK then begin

                                    ApprovalCommentLine2.Reset();
                                    ApprovalCommentLine2.SetRange("Table ID", ApprovalEntry."Table ID");
                                    ApprovalCommentLine2.SetRange("Document No.", ApprovalEntry."Document No.");
                                    ApprovalCommentLine2.SetRange("Document Type", ApprovalEntry."Document Type");
                                    if ApprovalCommentLine2.Find('-') then begin
                                        if ApprovalCommentLine2.Comment = '' then
                                            Error('You must enter comments before rejecting') else
                                            ApprovalMgt.RejectApprovalRequest(ApprovalEntry);
                                    end
                                end;
                            end else
                                ApprovalMgt.RejectApprovalRequest(ApprovalEntry);
                        until ApprovalEntry.Next = 0;
                end;
            }
            action("&Delegate")
            {
                Caption = '&Delegate';
                Image = Delegate;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entries";
                    TempApprovalEntry: Record "Approval Entries";
                    ApprovalSetup: Record "Approval Setup";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    CurrPage.SetSelectionFilter(TempApprovalEntry);
                    if TempApprovalEntry.FindFirst then begin
                        TempApprovalEntry.SetFilter(Status, '<>%1', TempApprovalEntry.Status::Open);
                        if not TempApprovalEntry.IsEmpty then
                            Error(Text001);
                    end;
                    if ApprovalEntry.Find('-') then begin
                        if ApprovalSetup.Get then;
                        if Usersetup.Get(UserId) then;
                        if (ApprovalEntry."Sender ID" = Usersetup."User ID") or
                           (ApprovalSetup."Approval Administrator" = Usersetup."User ID") or
                           (ApprovalEntry."Approver ID" = Usersetup."User ID")
                        then
                            repeat
                                ApprovalMgt.DelegateApprovalRequests(ApprovalEntry);
                            until ApprovalEntry.Next = 0;
                    end;

                    Message(Text002);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref("&Delegate_Promoted"; "&Delegate")
                {
                }
                actionref(Document_Promoted; Document)
                {
                }
                actionref(Comments_Promoted; Comments)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Overdue := Overdue::" ";
        if FormatField(Rec) then
            Overdue := Overdue::Yes;
        AccountName := '';
        AccNo := '';
        ProdName := '';

        case Rec."Table ID" of
            50390:
                begin
                    if Loan.Get(Rec."Document No.") then begin
                        AccountName := Loan."Account Name";
                        AccNo := Loan."Account No.";
                        ProdName := Loan."Product Description";
                        AccountName := '';

                    end else begin

                        AccountName := '';
                        AccNo := '';
                        ProdName := '';
                        AccountName := '';
                    end;
                end;
            50554:
                begin
                    if LoanApplic.Get(Rec."Document No.") then begin
                        AccountName := LoanApplic."Account Name";
                        AccNo := LoanApplic."Account No.";
                        ProdName := LoanApplic."Product Description";

                    end else begin

                        AccountName := '';
                        AccNo := '';
                        ProdName := '';
                        AccountName := '';

                    end;
                end;
            50464:
                begin
                    if LoanRecovery.Get(Rec."Document No.") then
                        AccountName := LoanRecovery.Name else
                        AccountName := '';

                end;
            50376:
                begin
                    if EFTHeader.Get(Rec."Document No.") then begin
                        AccountName := EFTHeader."Account Name";
                        ProdName := EFTHeader."Product Type";
                    end;
                end;
        end;

    end;

    trigger OnInit()
    begin
        RejectVisible := true;
        ApproveVisible := true;
    end;

    trigger OnOpenPage()
    var
        Filterstring: Text[250];
    begin
        if Usersetup.Get(UserId) then begin
            Rec.FilterGroup(2);
            Filterstring := Rec.GetFilters;
            Rec.FilterGroup(0);
            if StrLen(Filterstring) = 0 then begin
                Rec.FilterGroup(2);
                Rec.SetCurrentKey("Approver ID");
                FilterApproverID := '';
                FilterApproverID := Usersetup."Office/Group";
                Rec.SetFilter("Approver ID", ('%1|%2'), FilterApproverID, UserId);
            end;
            Rec.SetRange(Status, Rec.Status::Open);
            Rec.FilterGroup(0);
        end else
            Rec.SetCurrentKey("Table ID", "Document Type", "Document No.");
    end;

    var
        Usersetup: Record "User Setup";
        AccName: Text[150];
        ProdName: Text[150];
        AccNo: Code[100];
        ApprovalMgt: Codeunit "Approval Mgmt.";
        Text001: Label 'You can only delegate open approval entries.';
        Text002: Label 'The selected approval(s) have been delegated. ';
        Overdue: Option Yes," ";
        Text004: Label 'Approval Setup not found.';
        
        ApproveVisible: Boolean;
        EFTHeader: Record "EFT Transfer Header";
        
        RejectVisible: Boolean;
        FilterApproverID: Text[250];
        LoanRecovery: Record "Recovery Header";
        AccountName: Text[200];
        Loan: Record Loans;
        LoanApplic: Record "Loan Application";


    procedure Setfilters(TableId: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetCurrentKey("Table ID", "Document Type", "Document No.");
            Rec.SetRange("Table ID", TableId);
            Rec.SetRange("Document Type", DocumentType);
            if DocumentNo <> '' then
                Rec.SetRange("Document No.", DocumentNo);
            Rec.FilterGroup(0);
        end;

        ApproveVisible := false;
        RejectVisible := false;
    end;

    procedure FormatField(Rec: Record "Approval Entries") OK: Boolean
    begin
        if Rec.Status in [Rec.Status::Created, Rec.Status::Open] then begin
            if Rec."Due Date" < Today then
                exit(true);

            exit(false);
        end;
    end;

    procedure CalledFrom()
    begin
        Overdue := Overdue::" ";
    end;
}






