page 50805 "Fixed Deposit Type"
{
    DeleteAllowed = false;
    SourceTable = "Fixed Deposit Type";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("Code"; Rec.Code)
            {
                ApplicationArea = All;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
            field(Duration; Rec.Duration)
            {
                ApplicationArea = All;
            }
            field("Call Deposit"; Rec."Call Deposit")
            {
                ApplicationArea = All;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
            part(Control1102755004; "FD Interest Calculation")
            {
                SubPageLink = Code = FIELD(Code);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("User Notification")
            {
                Caption = 'User Notification';
                Image = UserSetup;
                RunObject = Page "Member List";
                RunPageLink = "Search Name" = FIELD(Code);
                ApplicationArea = All;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("User Notification_Promoted"; "User Notification")
                {
                }
            }
        }
    }
}




