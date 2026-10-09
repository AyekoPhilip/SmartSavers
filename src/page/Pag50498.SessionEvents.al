page 50498 "Session Events"
{
    Caption = 'Change Log Entry';
    PageType = List;
    SourceTable = "Session Event";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Session ID field';
                }
                field("Event Type"; Rec."Event Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Event Type field';
                }
                field("Event Datetime"; Rec."Event Datetime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Event Datetime field';
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Type field';
                }
                field("Database Name"; Rec."Database Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Database Name field';
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Computer Name field';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field';
                }
            }
        }
    }

    actions
    {
    }
}


