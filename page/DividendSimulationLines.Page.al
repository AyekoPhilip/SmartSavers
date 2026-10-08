page 50798 "Dividend Simulation Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Dividend Simulation Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Weighted Amount"; Rec."Weighted Amount")
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




