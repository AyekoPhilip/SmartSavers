page 50800 "Dividend Progression"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Dividend Progression";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Processing Date"; Rec."Processing Date")
                {
                    ApplicationArea = All;
                }
                field("Dividend Calc. Method"; Rec."Dividend Calc. Method")
                {
                    ApplicationArea = All;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = All;
                }
                field(Shares; Rec.Shares)
                {
                    ApplicationArea = All;
                }
                field("Qualifying Shares"; Rec."Qualifying Shares")
                {
                    ApplicationArea = All;
                }
                field("Gross Dividends"; Rec."Gross Dividends")
                {
                    ApplicationArea = All;
                }
                field("Witholding Tax"; Rec."Witholding Tax")
                {
                    ApplicationArea = All;
                }
                field("Net Dividends"; Rec."Net Dividends")
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
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Dividend Process")
            {
                Image = Add;
                ApplicationArea = All;
                //RunObject = Codeunit Codeunit52140646;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("Dividend Process_Promoted"; "Dividend Process")
                {
                }
            }
        }
    }
}




