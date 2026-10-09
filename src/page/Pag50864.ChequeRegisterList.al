page 50864 "Cheque Register List"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Cheques Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                }
                field("Cancelled/Stopped By"; Rec."Cancelled/Stopped By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Cancel Cheque")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    if Confirm('Are you sure you want to cancel cheque ?', false) = true then begin
                        if Rec.Status <> Rec.Status::Pending then
                            Error('Status must be pending');
                        Rec.Status := Rec.Status::Cancelled;
                        Rec."Approval Date" := Today;
                        Rec."Cancelled/Stopped By" := UserId;
                        Rec.Modify;
                    end;
                end;
            }
            action("Stop Cheque")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    if Confirm('Are you sure you want to stop cheque ?', false) = true then begin
                        if Rec.Status <> Rec.Status::Pending then
                            Error('Status must be pending');
                        Rec.Status := Rec.Status::stopped;
                        Rec."Approval Date" := Today;
                        Rec."Cancelled/Stopped By" := UserId;
                        Rec.Modify;
                    end;
                end;
            }
            action("Cancel Cheque Book")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //reset;
                end;
            }
        }
    }
}




