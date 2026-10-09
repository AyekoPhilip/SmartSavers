page 51014 "Fields Change Setups"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Fields Change Setup";
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
                field("Field caption"; Rec."Field caption")
                {
                    ApplicationArea = All;
                }
                field("Log Insertion"; Rec."Log Insertion")
                {
                    ApplicationArea = All;
                }
                field("Log Deletion"; Rec."Log Deletion")
                {
                    ApplicationArea = All;
                }
                field("Log Modification"; Rec."Log Modification")
                {
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
                field("Record No."; Rec."Record No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}




