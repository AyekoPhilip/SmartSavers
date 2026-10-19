pageextension 50020 "WrkflowUserGroupPageExt" extends "Workflow User Group"
{
    layout
    {
    }

    actions
    {
        addfirst(Processing)
        {
            action("Approval Stages")
            {
                Image = Stages;
                RunObject = page "Approval Stages ListPart";
                RunPageLink = "Workflow User Group Code" = field(Code);
                ApplicationArea = All;
                ToolTip = 'Executes the Approval Stages action';
            }
        }
        addfirst(Category_Process)
        {
            actionref("Approval Stages_Promoted"; "Approval Stages")
            {
            }
        }
    }
}


