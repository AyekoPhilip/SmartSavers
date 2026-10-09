page 50806 "FD Interest Calculation"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "FD Interest Calculation Rules";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                ShowCaption = false;
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Allowed Margin"; Rec."Allowed Margin")
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




