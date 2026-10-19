page 50807 "Fixed Deposit Notification Lis"
{
    PageType = List;
    SourceTable = "Fixed Deposit Notification Lis";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = All;
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                }
                field("Fixed Deposit Type"; Rec."Fixed Deposit Type")
                {
                    ApplicationArea = All;
                }
                field("Notification Type"; Rec."Notification Type")
                {
                    ApplicationArea = All;
                }
                field("Notification Period"; Rec."Notification Period")
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




