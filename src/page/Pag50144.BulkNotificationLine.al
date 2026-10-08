namespace SmartSaverDB.SmartSaverDB;
page 50144 "Bulk Notification Line"
{
    PageType = ListPart;
    SourceTable = "Bulk Notification Line";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Phone No."; Rec."Phone No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Error('Bulk notifications are temporarily blocked during SmartSaver recovery until the original notification logic is reviewed.');
    end;
}
