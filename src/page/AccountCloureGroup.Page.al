page 50045 "Account Cloure-Group"
{
    ApplicationArea = All;
    Caption = 'Account Cloure-Group';
    PageType = List;
    CardPageId = "Ac. Closure-Non Member";
    SourceTable = "Membership closure";
    Editable=false;
    ModifyAllowed=false;
    UsageCategory = Lists;
    SourceTableView = where(Posted = const(false), "Close Account" = filter(Specific | All | " "), "Customer Type" = const(Groups));
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
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Closure Type"; Rec."Closure Type")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}



