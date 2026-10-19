page 50080 "Posted Approval Factbox"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Posted Approval Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sender ID"; Rec."Sender ID")
                {
                    Caption = 'Sender';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sender field';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    Caption = 'Approver';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver field';
                }
            }
        }
    }

    actions
    {
    }
}


