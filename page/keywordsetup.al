page 90000 "Key Word Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Keyword Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Key Word"; Rec."Key Word")
                {
                    ApplicationArea = all;
                }
                field("Post-To Account Type"; Rec."Post-To Account Type")
                {
                    ApplicationArea = all;
                }
                field("Post-To Account Code"; Rec."Post-To Account Code")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}