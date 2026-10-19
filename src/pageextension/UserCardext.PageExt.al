namespace SaccoDB.SaccoDB;

using System.Security.User;
using System.Azure.Identity;
pageextension 90000 "User Card ext." extends "User Card"
{
    layout
    {
        modify("User Security ID")
        {
            Visible = false;

        }
    }
    actions
    {
        addafter("Sent Emails")
        {
            action("Update users from Office")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update users from Microsoft 365';
                Image = Users;
                ToolTip = 'Update the names, authentication email addresses, contact email addresses, plans etc. from Microsoft 365 for all users. Having SUPER permission set for all companies is required to run this action.';
                AboutTitle = 'Keep in sync with Microsoft 365';
                AboutText = 'When licenses or user accounts change in the Microsoft 365 admin center, you must sync the changes back to this list.';

                trigger OnAction()
                begin
                    Page.RunModal(Page::"Azure AD User Update Wizard");
                end;
            }
        }


    }
}
