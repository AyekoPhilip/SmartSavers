page 50035 "BBF List"
{
    ApplicationArea = All;
    CardPageID = "BBF Page";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    Caption = 'BBF List';
    PageType = List;
    SourceTable = "Interest Header";
    UsageCategory = Lists;
    SourceTableView = WHERE("Approval Status" = FILTER(<> Posted));
    
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
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



