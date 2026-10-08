page 50998 "Additional Approvers"
{
    AutoSplitKey = true;
    Caption = 'Additional Approvers';
    PageType = List;
    SourceTable = "Additional Approver";
    SourceTableView = SORTING("Sequence No.");
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field("Approval Code"; Rec."Approval Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




