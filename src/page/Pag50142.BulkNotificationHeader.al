namespace SmartSaverDB.SmartSaverDB;

// Original page identity restored for AltChannel compatibility. Original page logic is unavailable.
page 50142 "Bulk Notification Header"
{
    PageType = Card;
    SourceTable = "Bulk Notification Header";
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Messages; Rec.Messages) { ApplicationArea = All; }
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
                trigger OnAction()
                begin
                    Error('Bulk notifications are blocked until the original notification logic has been reviewed.');
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Error('Bulk notifications are temporarily blocked during SmartSaver recovery. The original notification logic must be reviewed before use.');
    end;
}
