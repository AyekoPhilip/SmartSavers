page 50571 "Account Closure List-All"
{
    ApplicationArea = All;
    Caption = 'Account Closure List-All';
    PageType = List;
    SourceTable = "Membership closure";
    UsageCategory = Lists;
    SourceTableView = where(Posted = const(false), "Close Account" = const(All));
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
                field("Application Date"; Rec."Application Date")
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

                field("Approval Status"; Rec."Approval Status")
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

    actions
    {
    }
}


