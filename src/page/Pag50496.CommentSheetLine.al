page 50496 "Comment Sheet Line"
{
    ApplicationArea = All;
    Caption = 'Comment Sheet Line';
    PageType = List;
    SourceTable = "Cred. Comment Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Comments; Rec.Comment)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the comment itself.';
                }

            }

        }

    }
    trigger OnOpenPage()
    begin

    end;

    trigger OnModifyRecord(): Boolean
    begin
        if UserId <> Rec."Entered By" then
            Error('Changes made to this record is restricted to %. who captured the comments', Rec."Entered By");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if UserId <> Rec."Entered By" then
            Error('Changes made to this record is restricted to %. who captured the comments', Rec."Entered By");
    end;

    var
        Temp: Record "User Setup";


}



