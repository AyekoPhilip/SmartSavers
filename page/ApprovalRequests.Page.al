page 50995 "Approval Requests"
{
    Caption = 'Approval Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Approval Entries";
    SourceTableView = WHERE(Status = FILTER(<> Approved));
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
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = All;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
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
    }

    trigger OnAfterGetRecord()
    begin
        Overdue := Overdue::" ";
        if FormatField(Rec) then
            Overdue := Overdue::Yes;
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
            Rec.SetRange("Sender ID", UserId);
            Rec.FilterGroup(0);
        end else
            Rec.SetCurrentKey("Table ID", "Document Type", "Document No.");
    end;

    var
        Usersetup: Record "User Setup";
        Overdue: Option Yes," ";
        
        ApproveVisible: Boolean;
        
        RejectVisible: Boolean;
        FilterApproverID: Text[250];


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




