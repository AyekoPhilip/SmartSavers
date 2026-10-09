page 51050 "Permission Change"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Status Change Permissions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                }
                field("Function"; Rec."Function")
                {
                    ApplicationArea = All;
                }
                field("Function Extended"; Rec."Function Extended")
                {
                    ApplicationArea = All;
                }
            }
            group(Control5)
            {
                ShowCaption = false;
                field("View Payroll"; Rec."View Payroll")
                {
                    ApplicationArea = All;
                }
                field("Edit Payroll"; Rec."Edit Payroll")
                {
                    ApplicationArea = All;
                }
                field("View Setup"; Rec."View Setup")
                {
                    ApplicationArea = All;
                }
                field("Edit Setup"; Rec."Edit Setup")
                {
                    ApplicationArea = All;
                }
                field("View G/L Account"; Rec."View G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Edit  G/L Account"; Rec."Edit  G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Edit Member Changes"; Rec."Edit Member Changes")
                {
                    ApplicationArea = All;
                }
                field("View Employee Record"; Rec."View Employee Record")
                {
                    ApplicationArea = All;
                }
                field("Edit Employee Record"; Rec."Edit Employee Record")
                {
                    ApplicationArea = All;
                }
                field("Block account"; Rec."Block account")
                {
                    ApplicationArea = All;
                }
                field("Unblock Account"; Rec."Unblock Account")
                {
                    ApplicationArea = All;
                }
                field("Cheque Writting"; Rec."Cheque Writting")
                {
                    ApplicationArea = All;
                }
                field("Post Dividends"; Rec."Post Dividends")
                {
                    ApplicationArea = All;
                }
                field("View Next of Kin"; Rec."View Next of Kin")
                {
                    ApplicationArea = All;
                }
                field("Edit Next of Kin"; Rec."Edit Next of Kin")
                {
                    ApplicationArea = All;
                }
                field("Edit Vendor"; Rec."Edit Vendor")
                {
                    ApplicationArea = All;
                }
                field("View Edit"; Rec."View Edit")
                {
                    ApplicationArea = All;
                }
                field("Edit Customer"; Rec."Edit Customer")
                {
                    ApplicationArea = All;
                }
                field("View Customer"; Rec."View Customer")
                {
                    ApplicationArea = All;
                }
                field("Edit Journal"; Rec."Edit Journal")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control37; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control38; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




