namespace SmartSaverDB.SmartSaverDB;

// Historical notifications can be viewed; sending is not reconstructed.
page 50142 "Bulk Notification Header"
{
    PageType = Card;
    SourceTable = "Bulk Notification Header";
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Messages; Rec.Messages) { ApplicationArea = All; }
                field("Notification Type"; Rec."Notification Type") { ApplicationArea = All; }
                field("SMS Type"; Rec."SMS Type") { ApplicationArea = All; }
                field("Group Code"; Rec."Group Code") { ApplicationArea = All; }
                field("Use Line Message"; Rec."Use Line Message") { ApplicationArea = All; }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
                field("SMS Status"; Rec."SMS Status") { ApplicationArea = All; }
            }
            part(Lines; "Bulk Notification Line")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Editable = false;
            }
            group(History)
            {
                field("Date Entered"; Rec."Date Entered") { ApplicationArea = All; }
                field("Time Entered"; Rec."Time Entered") { ApplicationArea = All; }
                field("Entered By"; Rec."Entered By") { ApplicationArea = All; }
                field("Status Date"; Rec."Status Date") { ApplicationArea = All; }
                field("Status Time"; Rec."Status Time") { ApplicationArea = All; }
                field("Status By"; Rec."Status By") { ApplicationArea = All; }
                field("Date Posted"; Rec."Date Posted") { ApplicationArea = All; }
                field("Time Posted"; Rec."Time Posted") { ApplicationArea = All; }
                field("Posted By"; Rec."Posted By") { ApplicationArea = All; Caption = 'Posted By'; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Enabled = false;
                ToolTip = 'Sending is unavailable. Existing notifications can be viewed only.';
                trigger OnAction()
                begin
                    Error('Sending is unavailable. Existing notifications can be viewed only.');
                end;
            }
        }
    }
}
