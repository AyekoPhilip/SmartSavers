page 50709 "SMS Notification"
{
    ApplicationArea = All;
    Caption = 'SMS Notification';
    PageType = List;
    SourceTable = "SMS Notification";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Account No"; Rec."Account No")
                {
                    ToolTip = 'Specifies the value of the Account No field.';
                    ApplicationArea = All;
                }
                field("SMS Message"; Rec."SMS Message")
                {
                    ToolTip = 'Specifies the value of the SMS Message field.';
                    ApplicationArea = All;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ToolTip = 'Specifies the value of the Date Entered field.';
                    ApplicationArea = All;
                }
                field("Date Sent to Server"; Rec."Date Sent to Server")
                {
                    ToolTip = 'Specifies the value of the Date Sent to Server field.';
                    ApplicationArea = All;
                }
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.';
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ToolTip = 'Specifies the value of the Entered By field.';
                    ApplicationArea = All;
                }
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.';
                    ApplicationArea = All;
                }

                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }

                field("Sent To Server"; Rec."Sent To Server")
                {
                    ToolTip = 'Specifies the value of the Sent To Server field.';
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.';
                    ApplicationArea = All;
                }

                field("Telephone No"; Rec."Telephone No")
                {
                    ToolTip = 'Specifies the value of the Telephone No field.';
                    ApplicationArea = All;
                }
                field("Time Entered"; Rec."Time Entered")
                {
                    ToolTip = 'Specifies the value of the Time Entered field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}



