page 50646 "Open Approvals Delegations"
{
    CardPageID = "Approvals Delegation";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Approvals Delegation";
    SourceTableView = where(Status = const(Delegated));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Delegation No."; Rec."Delegation No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation No. field';
                }
                field("Current User"; Rec."Current User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current User field';
                }
                field("Delegation Start Date"; Rec."Delegation Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation Start Date field';
                }
                field("Delegation End Date"; Rec."Delegation End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegation End Date field';
                }
                field("Reason for Delegation"; Rec."Reason for Delegation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason for Delegation field';
                }
                field("Delegated To"; Rec."Delegated To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delegated To field';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("Current User", UserId);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Current User", UserId);
    end;
}


