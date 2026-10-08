page 50884 "Posted EFT Transfer List"
{
    CardPageID = "EFT Transfer Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "EFT Transfer Header";
    SourceTableView = WHERE("Approval Status" = FILTER(Transferred));
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
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Record Total"; Rec."Record Total")
                {
                    ApplicationArea = All;
                }
                field("Record Count"; Rec."Record Count")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control12; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control13; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Control14; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}




