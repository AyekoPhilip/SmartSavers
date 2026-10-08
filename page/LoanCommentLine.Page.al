page 50490 "Loan Comment Line"
{
    Caption = 'Loan Comment Line';
    PageType = CardPart;
    SourceTable = "Cred. Comment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comment itself.';
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
}



