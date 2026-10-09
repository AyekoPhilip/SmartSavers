page 50037 "Comment Facbox"
{
    Caption = 'Comment Facbox';
    PageType = CardPart;
    SourceTable = "Cred. Comment Line";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the comment itself.';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entered By field.';
                }

            }
        }
    }
}



