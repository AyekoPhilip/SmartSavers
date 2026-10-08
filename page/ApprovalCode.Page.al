page 50999 "Approval Code"
{
    Caption = 'Approval Code';
    PageType = List;
    DeleteAllowed=true;
    InsertAllowed=true;
    Editable=true;
    ModifyAllowed=true;
    SourceTable = "Approval Code";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Linked To Table No."; Rec."Linked To Table No.")
                {
                    LookupPageID = "Table Objects";
                    ApplicationArea = All;
                }
                field("Linked To Table Name"; Rec."Linked To Table Name")
                {
                    Editable = false;
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




