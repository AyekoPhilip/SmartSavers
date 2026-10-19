page 50692 "NotificationTemplate"
{
    ApplicationArea = All;
    Caption = 'NotificationTemplate';
    PageType = List;
    SourceTable = "Notification Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Linked To Table No."; Rec."Linked To Table No.")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Linked To Table Name"; Rec."Linked To Table Name")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;

                }
                field("Primary Key"; Rec."Primary Key")
                {
                    ToolTip = 'Specifies the value of the Primary Key field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Membership Application"; Rec."Membership Application")
                {
                    ToolTip = 'Specifies the value of the Membership Application field.';
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = true;
                }

            }
        }
    }
}



