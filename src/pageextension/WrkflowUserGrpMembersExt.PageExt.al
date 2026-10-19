pageextension 50021 "WrkflowUserGrpMembersExt" extends "Workflow User Group Members"
{
    layout
    {
        addlast(Group)
        {
            field("Approval Stages"; Rec."Approval Stages")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approval Stages field';
            }
        }
    }
}
