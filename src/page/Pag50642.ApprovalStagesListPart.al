page 50642 "Approval Stages ListPart"
{
    Caption = 'Approval Stages';
    PageType = List;
    SourceTable = "Approval Stages";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Approval Stage"; Rec."Approval Stage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Stage field';
                }
                field("Approval Stage Name"; Rec."Approval Stage Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Stage Name field';
                }
                field("Minimum Approvers"; Rec."Minimum Approvers")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Approvers field';
                }
            }
        }
    }

    actions
    {
    }
}


