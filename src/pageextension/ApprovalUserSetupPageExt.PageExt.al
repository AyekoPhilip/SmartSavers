pageextension 50044 "ApprovalUserSetupPageExt" extends "Approval User Setup"
{
    layout
    {
    }

    actions
    {
        addlast(Navigation)
        {
            action("User Signature")
            {
                Image = Signature;
                RunObject = page "User Signatures";
                RunPageLink = "User ID" = field("User ID");
                ApplicationArea = All;
                ToolTip = 'Executes the User Signature action';
            }
        }
        addfirst(Category_New)
        {
            actionref("User Signature_Promoted"; "User Signature")
            {
            }
        }
    }
}


