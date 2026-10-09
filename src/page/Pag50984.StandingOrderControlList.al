page 50984 "+Standing Order Control List"
{
    CardPageID = "Standing Order Control Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Standing Order Control";
    SourceTableView = WHERE(Status = FILTER(Approved | Rejected));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Standing Order No"; Rec."Standing Order No")
                {
                    ApplicationArea = All;
                }
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control12; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control13; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




